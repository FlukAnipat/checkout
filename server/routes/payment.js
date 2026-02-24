import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import { getUserByEmail, updateUser, createPayment, getPaymentsByUserId, getPromoCode, usePromoCode } from '../config/database.js';
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
    const promo = await getPromoCode(code);
    if (!promo) {
      return res.status(400).json({ error: 'Invalid or expired promo code' });
    }

    let finalPrice = PRICING.basePrice;
    if (code) {
      finalPrice = calculateFinalPrice(code, promo.discount_percent);
    } else {
      finalPrice = calculateFinalPrice(null);
    }
    res.json({
      success: true,
      message: 'Promo code is valid!',
      discount: `${promo.discount_percent}%`,
      finalPrice,
      currency: PRICING.currency,
    });
  } catch (err) {
    console.error('Promo validation error:', err);
    res.status(500).json({ error: 'Failed to validate promo code' });
  }
});

/**
 * POST /api/payment/checkout
 * Process payment with MyanmarPay unified gateway or international methods
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

    let finalPrice = PRICING.basePrice;
    const code = promoCode ? promoCode.trim().toUpperCase() : null;

    if (code) {
      const promo = await getPromoCode(code);
      if (!promo) {
        return res.status(400).json({ error: 'Invalid or expired promo code' });
      }
      finalPrice = calculateFinalPrice(code, promo.discount_percent);
    } else {
      finalPrice = calculateFinalPrice(null);
    }

    const orderId = `SF-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    
    // ── MyanmarPay Unified Gateway Integration ──
    if (MYANMAR_PAY_PROVIDERS.includes(paymentMethod)) {
      try {
        const myanpayResponse = await createMyanMyanPayPayment({
          orderId,
          amount: finalPrice,
          currency: PRICING.currency,
          paymentMethod,
          userEmail: user.email,
          callbackUrl: `${process.env.BASE_URL || 'http://localhost:3001'}/api/payment/webhook/myanpay`,
        });

        const payment = {
          paymentId: uuidv4(),
          orderId,
          userId: user.user_id,
          email: user.email,
          amount: finalPrice,
          currency: PRICING.currency,
          promoCode: code,
          paymentMethod,
          provider: 'myanpay',
          providerPaymentId: myanpayResponse.paymentId,
          qrCode: myanpayResponse.qr,
          status: 'pending',
          createdAt: new Date().toISOString(),
        };

        await createPayment(payment);

        res.json({
          success: true,
          message: 'Payment initiated. Please scan QR code to complete payment.',
          payment: {
            paymentId: payment.paymentId,
            orderId: payment.orderId,
            amount: payment.amount,
            currency: payment.currency,
            status: payment.status,
            qrCode: payment.qrCode,
            provider: payment.provider,
            paymentMethod: payment.paymentMethod,
          },
        });
      } catch (myanpayError) {
        console.error('MyanMyanPay error:', myanpayError);
        res.status(500).json({ error: 'Failed to initiate MyanmarPay payment. Please try again.' });
      }
    } 
    // ── International Payment Methods (Mock for now) ──
    else if (INTERNATIONAL_PROVIDERS.includes(paymentMethod)) {
      // TODO: Integrate with Stripe/Omise for international cards
      const payment = {
        paymentId: uuidv4(),
        orderId,
        userId: user.user_id,
        email: user.email,
        amount: finalPrice,
        currency: PRICING.currency,
        promoCode: code,
        paymentMethod,
        provider: 'international',
        status: 'completed', // Mock success for now
        createdAt: new Date().toISOString(),
      };

      await createPayment(payment);

      if (code) {
        await usePromoCode(code);
      }

      await updateUser(user.email, {
        isPaid: true,
        promoCodeUsed: code,
        paidAt: new Date().toISOString(),
      });

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
    } else {
      res.status(400).json({ error: 'Invalid payment method selected' });
    }
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
        // Update payment status
        await updateUser(payment.email, {
          isPaid: true,
          paidAt: new Date().toISOString(),
        });
        
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
