import express from 'express';
import authMiddleware from '../middleware/auth.js';
import { 
  getSalesPromoCodes, 
  getSalesDashboardStats, 
  getSalesCustomers 
} from '../config/database.js';

const router = express.Router();

/**
 * Middleware: ตรวจสอบว่าเป็น sales
 */
function requireSales(req, res, next) {
  if (req.user.role !== 'sales' && req.user.role !== 'admin') {
    return res.status(403).json({ error: 'Access denied. Sales only.' });
  }
  next();
}

/**
 * GET /api/sales/dashboard
 * สรุปยอดขายสำหรับเซล
 */
router.get('/dashboard', authMiddleware, requireSales, async (req, res) => {
  try {
    const stats = await getSalesDashboardStats(req.user.userId);
    res.json({ success: true, stats });
  } catch (err) {
    console.error('Sales dashboard error:', err);
    res.status(500).json({ error: 'Failed to load dashboard' });
  }
});

/**
 * GET /api/sales/promo-codes
 * ดู promo codes ของเซลคนนี้
 */
router.get('/promo-codes', authMiddleware, requireSales, async (req, res) => {
  try {
    const promoCodes = await getSalesPromoCodes(req.user.userId);
    res.json({ success: true, promoCodes });
  } catch (err) {
    console.error('Sales promo codes error:', err);
    res.status(500).json({ error: 'Failed to load promo codes' });
  }
});

/**
 * GET /api/sales/customers
 * ดูรายการลูกค้าที่ซื้อผ่าน promo code ของเซลคนนี้
 */
router.get('/customers', authMiddleware, requireSales, async (req, res) => {
  try {
    const customers = await getSalesCustomers(req.user.userId);
    res.json({ success: true, customers });
  } catch (err) {
    console.error('Sales customers error:', err);
    res.status(500).json({ error: 'Failed to load customers' });
  }
});

export default router;
