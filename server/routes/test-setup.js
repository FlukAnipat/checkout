import express from 'express';
import { getAdminDashboardStats, getSalesDashboardStats } from '../config/database.js';

const router = express.Router();

// Test dashboard stats
router.get('/test-stats', async (req, res) => {
  try {
    const adminStats = await getAdminDashboardStats();
    const salesStats = await getSalesDashboardStats('sales-001');
    
    res.json({
      success: true,
      adminStats,
      salesStats,
      message: 'Dashboard stats test'
    });
  } catch (error) {
    console.error('Test stats error:', error);
    res.status(500).json({ 
      success: false, 
      error: error.message 
    });
  }
});

export default router;
