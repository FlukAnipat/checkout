import express from 'express';
import { pool } from '../config/database.js';

const router = express.Router();

// Get pending sales registrations
router.get('/pending', async (req, res) => {
  try {
    const [rows] = await pool.execute(`
      SELECT user_id, email, first_name, last_name, phone, country_code, 
             country, created_at, status
      FROM user_registrations 
      WHERE status = 'pending' 
      ORDER BY created_at DESC
    `);
    
    res.json({
      success: true,
      registrations: rows
    });
  } catch (error) {
    console.error('Error fetching pending registrations:', error);
    res.status(500).json({ error: 'Failed to fetch registrations' });
  }
});

// Approve sales registration
router.post('/approve/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { approved, notes } = req.body;
    
    if (approved) {
      // Move to users table
      const [registration] = await pool.execute(`
        SELECT * FROM user_registrations WHERE user_id = ?
      `, [userId]);
      
      if (registration.length === 0) {
        return res.status(404).json({ error: 'Registration not found' });
      }
      
      const reg = registration[0];
      
      // Insert into users table
      await pool.execute(`
        INSERT INTO users (user_id, email, password, first_name, last_name, 
                           phone, country_code, role, is_paid, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, 'sales', 0, NOW())
      `, [reg.user_id, reg.email, reg.password, reg.first_name, reg.last_name, 
          reg.phone, reg.country_code]);
      
      // Update registration status
      await pool.execute(`
        UPDATE user_registrations 
        SET status = 'approved', approved_at = NOW(), approved_by = ?, notes = ?
        WHERE user_id = ?
      `, [req.user?.userId || 'admin', notes || '', userId]);
      
      res.json({
        success: true,
        message: 'Registration approved successfully'
      });
    } else {
      // Reject registration
      await pool.execute(`
        UPDATE user_registrations 
        SET status = 'rejected', rejected_at = NOW(), rejected_by = ?, notes = ?
        WHERE user_id = ?
      `, [req.user?.userId || 'admin', notes || '', userId]);
      
      res.json({
        success: true,
        message: 'Registration rejected'
      });
    }
  } catch (error) {
    console.error('Error processing approval:', error);
    res.status(500).json({ error: 'Failed to process approval' });
  }
});

export default router;
