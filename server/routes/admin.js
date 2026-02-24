import express from 'express';
import authMiddleware from '../middleware/auth.js';
import { 
  getAllUsers, 
  getAllPayments, 
  getAllPromoCodes, 
  createPromoCode,
  getAdminDashboardStats 
} from '../config/database.js';

const router = express.Router();

/**
 * Middleware: ตรวจสอบว่าเป็น admin
 */
function requireAdmin(req, res, next) {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Access denied. Admin only.' });
  }
  next();
}

/**
 * GET /api/admin/dashboard
 * สรุปข้อมูลทั้งหมดสำหรับ admin
 */
router.get('/dashboard', authMiddleware, requireAdmin, async (req, res) => {
  try {
    const stats = await getAdminDashboardStats();
    res.json({ success: true, stats });
  } catch (err) {
    console.error('Admin dashboard error:', err);
    res.status(500).json({ error: 'Failed to load dashboard' });
  }
});

/**
 * GET /api/admin/users
 * ดูรายการผู้ใช้ทั้งหมด
 */
router.get('/users', authMiddleware, requireAdmin, async (req, res) => {
  try {
    const users = await getAllUsers();
    res.json({ success: true, users });
  } catch (err) {
    console.error('Admin users error:', err);
    res.status(500).json({ error: 'Failed to load users' });
  }
});

/**
 * GET /api/admin/payments
 * ดูรายการการชำระเงินทั้งหมด
 */
router.get('/payments', authMiddleware, requireAdmin, async (req, res) => {
  try {
    const payments = await getAllPayments();
    res.json({ success: true, payments });
  } catch (err) {
    console.error('Admin payments error:', err);
    res.status(500).json({ error: 'Failed to load payments' });
  }
});

/**
 * GET /api/admin/promo-codes
 * ดูรายการ promo codes ทั้งหมด
 */
router.get('/promo-codes', authMiddleware, requireAdmin, async (req, res) => {
  try {
    const promoCodes = await getAllPromoCodes();
    res.json({ success: true, promoCodes });
  } catch (err) {
    console.error('Admin promo codes error:', err);
    res.status(500).json({ error: 'Failed to load promo codes' });
  }
});

/**
 * POST /api/admin/promo-codes
 * สร้าง promo code ใหม่
 */
router.post('/promo-codes', authMiddleware, requireAdmin, async (req, res) => {
  try {
    const { code, discountPercent, maxUses, salesPersonId, expiresAt } = req.body;

    if (!code || !discountPercent) {
      return res.status(400).json({ error: 'Code and discount percent are required' });
    }

    await createPromoCode({ code, discountPercent, maxUses, salesPersonId, expiresAt });
    res.status(201).json({ success: true, message: 'Promo code created' });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({ error: 'Promo code already exists' });
    }
    console.error('Create promo code error:', err);
    res.status(500).json({ error: 'Failed to create promo code' });
  }
});

export default router;
