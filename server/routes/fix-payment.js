import express from 'express';
import { updateUser, createPayment } from '../config/database.js';

const router = express.Router();

// แก้ไข test@gmail.com payment status
router.post('/fix-test-payment', async (req, res) => {
  try {
    // อัปเดต user เป็น paid
    await updateUser('test@gmail.com', {
      isPaid: true,
      promoCodeUsed: 'FLASH10',
      paidAt: new Date().toISOString()
    });

    // เพิ่ม payment record
    await createPayment({
      paymentId: 'payment-test-001',
      orderId: 'order-test-001',
      userId: 'user-001',
      email: 'test@gmail.com',
      amount: 7500.00,
      currency: 'MMK',
      promoCode: 'FLASH10',
      paymentMethod: 'card',
      status: 'completed'
    });

    res.json({
      success: true,
      message: 'test@gmail.com payment status fixed!'
    });

  } catch (error) {
    console.error('Fix payment error:', error);
    res.status(500).json({ 
      success: false, 
      error: error.message 
    });
  }
});

export default router;
