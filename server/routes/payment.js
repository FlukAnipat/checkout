import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import { getUserByEmail, updateUser, createPayment, getPaymentsByUserId, getPromoCode, usePromoCode } from '../config/database.js';
import authMiddleware from '../middleware/auth.js';

const router = express.Router();

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
 * Process payment (mock — prepared for Omise/Stripe)
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

    // ── TODO: Integrate real payment gateway here ──
    // For now, simulate successful payment

    const payment = {
      paymentId: uuidv4(),
      userId: user.user_id,
      email: user.email,
      amount: finalPrice,
      currency: PRICING.currency,
      promoCode: code,
      paymentMethod: paymentMethod || 'card',
      status: 'completed',
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
 * GET /api/payment/history
 */
router.get('/history', authMiddleware, async (req, res) => {
  const payments = await getPaymentsByUserId(req.user.userId);
  res.json({ success: true, payments });
});

export default router;
