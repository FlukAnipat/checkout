import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import { 
  getUserByEmail, 
  updateUser, 
  createPayment, 
  getPaymentsByUserId, 
  getPromoCode, 
  usePromoCode,
  checkPromoCodeUsage,
  recordPromoCodeUsage,
  getSalesCode,
  checkUserHasSalesCode,
  assignSalesCodeToUser,
  createReferral,
  completeReferralCommission,
  useSalesCode
} from '../config/database.js';
import authMiddleware from '../middleware/auth.js';
import { createMyanMyanPayPayment, verifyMyanMyanPayPayment } from '../services/myanpay.js';

const router = express.Router();

// ── Payment Method Categories ──
const MYANMAR_PAY_PROVIDERS = ['kbzpay', 'wavepay', 'ayapay', 'cbpay'];
const INTERNATIONAL_PROVIDERS = ['mpu', 'card'];

// ── Pricing (same as Flutter app) ──
const PRICING = {
  originalPrice: 36000,       // MMK
  discountPercent: 50,         // 50% off
  promoDiscountPercent: 10,    // extra 10% with promo code
  currency: 'MMK',
};
PRICING.basePrice = PRICING.originalPrice * (1 - PRICING.discountPercent / 100); // 18000

function calculateFinalPrice(promoCode, promoDiscountPercent = null) {
  let price = PRICING.basePrice;
  if (promoCode && promoCode.trim().length > 0) {
    const discount = promoDiscountPercent || PRICING.promoDiscountPercent;
    price = price * (1 - discount / 100);
  }
  return price;
}

/**
 * GET /api/payment/pricing
 */
router.get('/pricing', (req, res) => {
  res.json({
    success: true,
    pricing: {
      originalPrice: PRICING.originalPrice,
      discountPercent: PRICING.discountPercent,
      basePrice: PRICING.basePrice,
      promoDiscountPercent: PRICING.promoDiscountPercent,
      currency: PRICING.currency,
    },
  });
});

/**
 * POST /api/payment/validate-promo
 */
router.post('/validate-promo', authMiddleware, async (req, res) => {
  const { promoCode } = req.body;

  if (!promoCode || promoCode.trim().length === 0) {
    return res.status(400).json({ error: 'Please enter a promo code' });
  }

  const code = promoCode.trim().toUpperCase();

  if (!/^[A-Za-z0-9]{3,20}$/.test(code)) {
    return res.status(400).json({ error: 'Invalid code format' });
  }

  try {
    const user = await getUserByEmail(req.user.email);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (user.is_paid) {
      return res.status(400).json({ error: 'Premium members cannot use promo codes' });
    }

    const existingUsage = await checkPromoCodeUsage(user.user_id, code);
    if (existingUsage) {
      return res.status(400).json({ error: 'You have already used this promo code' });
    }

    const promo = await getPromoCode(code);
    if (!promo) {
      return res.status(400).json({ error: 'Invalid or expired promo code' });
    }

    const finalPrice = calculateFinalPrice(code, promo.discount_percent);

    // ตรวจสอบว่า promo code มีข้อมูลเซลหรือไม่
    let salesPerson = null;
    if (promo.sales_person_id) {
      const [salesUser] = await pool.execute(
        'SELECT first_name, last_name FROM users WHERE user_id = ?',
        [promo.sales_person_id]
      );
      if (salesUser.length > 0) {
        salesPerson = `${salesUser[0].first_name} ${salesUser[0].last_name}`;
      }
    }

    res.json({
      success: true,
      message: 'Promo code is valid!',
      discount: `${promo.discount_percent}%`,
      finalPrice,
      currency: PRICING.currency,
      salesPerson: salesPerson ? {
        name: salesPerson,
        message: `Promo code provided by: ${salesPerson}`
      } : null,
    });
  } catch (err) {
    console.error('Promo validation error:', err);
    res.status(500).json({ error: 'Failed to validate promo code' });
  }
});

/**
 * POST /api/payment/validate-sales-code
 * ตรวจสอบ sales code ว่ามีในฐานข้อมูลไหม + user ใส่ได้แค่ 1 ครั้ง
 */
router.post('/validate-sales-code', authMiddleware, async (req, res) => {
  const { salesCode } = req.body;

  if (!salesCode || salesCode.trim().length === 0) {
    return res.status(400).json({ error: 'Please enter a sales code' });
  }

  const code = salesCode.trim().toUpperCase();

  try {
    const user = await getUserByEmail(req.user.email);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // เช็คว่า user เคยใส่ sales code แล้วหรือยัง (1 ครั้งต่อ 1 user)
    const existing = await checkUserHasSalesCode(user.user_id);
    if (existing) {
      return res.status(400).json({ 
        error: 'You have already entered a sales code',
        existingCode: existing.referred_by
      });
    }

    // เช็คว่า sales code มีอยู่ในฐานข้อมูลไหม
    const salesData = await getSalesCode(code);
    if (!salesData) {
      return res.status(400).json({ error: 'Invalid sales code' });
    }

    // ห้ามใส่ code ตัวเอง
    if (salesData.user_id === user.user_id) {
      return res.status(400).json({ error: 'You cannot use your own sales code' });
    }

    // บันทึก sales code ให้ user
    const assigned = await assignSalesCodeToUser(user.user_id, code);
    if (!assigned) {
      return res.status(400).json({ error: 'Failed to assign sales code' });
    }

    res.json({
      success: true,
      message: `Sales code added! Salesperson: ${salesData.first_name} ${salesData.last_name}`,
      salesPerson: {
        name: `${salesData.first_name} ${salesData.last_name}`,
        code: code,
      },
    });
  } catch (err) {
    console.error('Sales code validation error:', err);
    res.status(500).json({ error: 'Failed to validate sales code' });
  }
});

/**
 * POST /api/payment/checkout
 * ชำระเงิน (mock - ยังไม่ใช้ payment gateway จริง)
 * ถ้า user มี sales code → สร้าง referral record + คำนวณค่าคอม 20%
 */
router.post('/checkout', authMiddleware, async (req, res) => {
  try {
    const { promoCode, paymentMethod } = req.body;
    const user = await getUserByEmail(req.user.email);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (user.is_paid) {
      return res.status(400).json({ error: 'You are already a premium member' });
    }

    // ── คำนวณราคา ──
    let finalPrice = PRICING.basePrice;
    const code = promoCode ? promoCode.trim().toUpperCase() : null;
    let discountAmount = 0;

    if (code) {
      const existingUsage = await checkPromoCodeUsage(user.user_id, code);
      if (existingUsage) {
        return res.status(400).json({ error: 'You have already used this promo code' });
      }

      const promo = await getPromoCode(code);
      if (!promo) {
        return res.status(400).json({ error: 'Invalid or expired promo code' });
      }
      
      const originalPrice = finalPrice;
      finalPrice = calculateFinalPrice(code, promo.discount_percent);
      discountAmount = originalPrice - finalPrice;
    }

    const orderId = `SF-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

    // ── เช็ค sales code ของ user (ถ้ามี) → สร้าง referral + ค่าคอม ──
    let referralId = null;
    if (user.referred_by) {
      const salesData = await getSalesCode(user.referred_by);
      if (salesData && salesData.user_id !== user.user_id) {
        referralId = await createReferral(salesData.user_id, user.user_id, user.referred_by);
        await useSalesCode(user.referred_by);
      }
    }

    // ── Mock Payment (ยังไม่ใช้ payment gateway จริง) ──
    const payment = {
      paymentId: uuidv4(),
      orderId,
      userId: user.user_id,
      email: user.email,
      amount: finalPrice,
      currency: PRICING.currency,
      promoCode: code,
      referralId: referralId ? String(referralId) : null,
      paymentMethod: paymentMethod || 'card',
      status: 'completed',
    };

    await createPayment(payment);

    // บันทึก promo code usage
    if (code) {
      await recordPromoCodeUsage(user.user_id, code, discountAmount, orderId);
      await usePromoCode(code);
    }

    // อัปเดต user เป็น premium
    await updateUser(user.email, {
      isPaid: true,
      promoCodeUsed: code,
      paidAt: new Date().toISOString(),
    });

    // คำนวณค่าคอม 20% ให้เซล
    if (referralId) {
      const commission = await completeReferralCommission(referralId, finalPrice);
      console.log(`💰 Commission ${commission} MMK for referral #${referralId}`);
    }

    res.json({
      success: true,
      message: 'Payment successful! Welcome to Premium.',
      payment: {
        paymentId: payment.paymentId,
        orderId: payment.orderId,
        amount: payment.amount,
        currency: payment.currency,
        status: payment.status,
      },
    });
  } catch (err) {
    console.error('Checkout error:', err);
    res.status(500).json({ error: 'Payment processing failed. Please try again.' });
  }
});

/**
 * POST /api/payment/verify
 * Public endpoint for Flutter app to check if a user has paid.
 * Secured with API key (not JWT) so the app can call it directly.
 */
router.post('/verify', async (req, res) => {
  const apiKey = req.headers['x-api-key'];
  if (apiKey !== (process.env.APP_API_KEY || 'shwe_flash_app_key_2024')) {
    return res.status(403).json({ error: 'Invalid API key' });
  }

  const { email } = req.body;
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }

  const user = await getUserByEmail(email.toLowerCase().trim());
  if (!user) {
    return res.json({
      success: true,
      found: false,
      isPaid: false,
    });
  }

  res.json({
    success: true,
    found: true,
    isPaid: !!user.is_paid,
    paidAt: user.paid_at || null,
    promoCodeUsed: user.promo_code_used || null,
  });
});

/**
 * GET /api/payment/status
 */
router.get('/status', authMiddleware, async (req, res) => {
  const user = await getUserByEmail(req.user.email);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  res.json({
    success: true,
    isPaid: !!user.is_paid,
    paidAt: user.paid_at,
    promoCodeUsed: user.promo_code_used,
  });
});

/**
 * GET /api/payment/verify/:paymentId
 * Verify payment status by payment ID
 */
router.get('/verify/:paymentId', authMiddleware, async (req, res) => {
  try {
    const { paymentId } = req.params;
    const user = await getUserByEmail(req.user.email);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Get payments for this user
    const payments = await getPaymentsByUserId(user.user_id);
    const payment = payments.find(p => p.payment_id === paymentId);
    
    if (!payment) {
      return res.status(404).json({ error: 'Payment not found' });
    }

    // If this is a MyanmarPay payment, verify with provider
    if (payment.provider === 'myanpay') {
      try {
        const verification = await verifyMyanMyanPayPayment(payment.provider_payment_id);
        
        if (verification.status === 'completed' && payment.status !== 'completed') {
          // Update user and payment status
          await updateUser(user.email, {
            isPaid: true,
            paidAt: new Date().toISOString(),
          });
          
          // TODO: Update payment record in database
          payment.status = 'completed';
        }
      } catch (verifyError) {
        console.error('Payment verification error:', verifyError);
        // Continue with current status if verification fails
      }
    }

    res.json({
      success: true,
      payment: {
        paymentId: payment.payment_id,
        status: payment.status,
        amount: payment.amount,
        currency: payment.currency,
      },
      isPaid: payment.status === 'completed',
      user: {
        email: user.email,
        isPaid: !!user.is_paid,
        paidAt: user.paid_at,
      },
    });
  } catch (err) {
    console.error('Payment verification error:', err);
    res.status(500).json({ error: 'Payment verification failed' });
  }
});

/**
 * POST /api/payment/webhook/myanpay
 * Webhook endpoint for MyanMyanPay payment notifications
 */
router.post('/webhook/myanpay', async (req, res) => {
  try {
    const { paymentId, status, orderId, signature } = req.body;
    
    // TODO: Verify webhook signature with MyanMyanPay
    const isValidSignature = true; // Implement signature verification
    
    if (!isValidSignature) {
      return res.status(401).json({ error: 'Invalid signature' });
    }

    if (status === 'completed' || status === 'success') {
      // Find payment by orderId
      const payments = await getPaymentsByUserId(req.body.userId || null);
      const payment = payments.find(p => p.order_id === orderId);
      
      if (payment && payment.status !== 'completed') {
        // Update user to premium
        await updateUser(payment.email, {
          isPaid: true,
          paidAt: new Date().toISOString(),
        });
        
        // Use promo code if applicable
        if (payment.promo_code) {
          await usePromoCode(payment.promo_code);
        }
        
        // Create referral commission if applicable
        if (payment.referral_id) {
          await completeReferralCommission(payment.referral_id, payment.amount);
        }
        
        // TODO: Update payment record to completed status
        console.log(`Payment completed for order: ${orderId}`);
      }
    }
    
    res.json({ success: true });
  } catch (err) {
    console.error('MyanMyanPay webhook error:', err);
    res.status(500).json({ error: 'Webhook processing failed' });
  }
});

/**
 * GET /api/payment/history
 */
router.get('/history', authMiddleware, async (req, res) => {
  const payments = await getPaymentsByUserId(req.user.userId);
  res.json({ success: true, payments });
});

export default router;
