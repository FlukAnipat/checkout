import express from 'express';
import { pool } from '../config/database.js';
import crypto from 'crypto';

const router = express.Router();

// Generate unique confirmation token
function generateConfirmationToken() {
  return crypto.randomBytes(32).toString('hex');
}

// Send confirmation email
router.post('/send-confirmation', async (req, res) => {
  try {
    const { email, firstName, lastName } = req.body;
    
    if (!email || !firstName || !lastName) {
      return res.status(400).json({ error: 'Email, first name, and last name are required' });
    }

    const normalizedEmail = email.toLowerCase().trim();
    const token = generateConfirmationToken();
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
    
    // Store confirmation token in database
    try {
      await pool.execute(
        `INSERT INTO email_confirmations (token, email, first_name, last_name, expires_at, created_at) 
         VALUES (?, ?, ?, ?, ?, NOW())`,
        [token, normalizedEmail, firstName, lastName, expiresAt]
      );
    } catch (dbError) {
      console.error('Database error:', dbError);
      // If table doesn't exist, create it
      if (dbError.code === 'ER_NO_SUCH_TABLE') {
        await pool.execute(`
          CREATE TABLE IF NOT EXISTS email_confirmations (
            id INT NOT NULL AUTO_INCREMENT,
            token VARCHAR(64) NOT NULL UNIQUE,
            email VARCHAR(255) NOT NULL,
            first_name VARCHAR(100) NOT NULL,
            last_name VARCHAR(100) NOT NULL,
            used BOOLEAN NOT NULL DEFAULT FALSE,
            expires_at DATETIME NOT NULL,
            confirmed_at DATETIME DEFAULT NULL,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY unique_token (token),
            KEY idx_email (email),
            KEY idx_used (used),
            KEY idx_expires_at (expires_at)
          ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        `);
        
        // Retry the insert
        await pool.execute(
          `INSERT INTO email_confirmations (token, email, first_name, last_name, expires_at, created_at) 
           VALUES (?, ?, ?, ?, ?, NOW())`,
          [token, normalizedEmail, firstName, lastName, expiresAt]
        );
      } else {
        throw dbError;
      }
    }

    // Create confirmation link
    const confirmationLink = `https://hsk-shwe-flash.vercel.app/confirm-email?token=${token}`;
    
    // Mock email sending (in production, integrate with SendGrid or AWS SES)
    console.log(`📧 Confirmation link for ${normalizedEmail}: ${confirmationLink}`);
    console.log(`📧 Token: ${token} (expires: ${expiresAt})`);
    
    // For demo purposes, we'll log the link in console
    // In production, this would be sent via email service like SendGrid
    
    res.json({
      success: true,
      message: 'Confirmation email sent successfully',
      // For development only - remove in production
      confirmationLink: process.env.NODE_ENV === 'development' ? confirmationLink : undefined,
      token: process.env.NODE_ENV === 'development' ? token : undefined,
      expiresIn: 86400 // 24 hours in seconds
    });
    
  } catch (error) {
    console.error('Send confirmation email error:', error);
    console.error('Error details:', {
      message: error.message,
      code: error.code,
      stack: error.stack
    });
    
    // Send detailed error for debugging
    res.status(500).json({ 
      error: 'Failed to send confirmation email',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

// Confirm email via link
router.get('/confirm', async (req, res) => {
  try {
    const { token } = req.query;
    
    if (!token) {
      return res.status(400).json({ error: 'Confirmation token is required' });
    }

    // Check if token exists and is valid
    const [confirmations] = await pool.execute(
      `SELECT * FROM email_confirmations 
       WHERE token = ? AND expires_at > NOW() AND used = FALSE`,
      [token]
    );
    
    if (confirmations.length === 0) {
      return res.status(400).json({ 
        error: 'Invalid or expired confirmation token',
        message: 'Please request a new confirmation email'
      });
    }

    const confirmation = confirmations[0];
    
    // Mark token as used
    await pool.execute(
      'UPDATE email_confirmations SET used = TRUE, confirmed_at = NOW() WHERE token = ?',
      [token]
    );
    
    res.json({ 
      success: true, 
      message: 'Email confirmed successfully',
      email: confirmation.email,
      firstName: confirmation.first_name,
      lastName: confirmation.last_name
    });
    
  } catch (error) {
    console.error('Confirm email error:', error);
    res.status(500).json({ error: 'Failed to confirm email' });
  }
});

// Check if email is already confirmed
router.post('/check-status', async (req, res) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const normalizedEmail = email.toLowerCase().trim();
    
    // Check if email has been confirmed
    const [confirmations] = await pool.execute(
      `SELECT * FROM email_confirmations 
       WHERE email = ? AND used = TRUE AND confirmed_at IS NOT NULL
       ORDER BY confirmed_at DESC LIMIT 1`,
      [normalizedEmail]
    );
    
    const isConfirmed = confirmations.length > 0;
    
    res.json({ 
      success: true, 
      isConfirmed,
      email: normalizedEmail
    });
    
  } catch (error) {
    console.error('Check email status error:', error);
    res.status(500).json({ error: 'Failed to check email status' });
  }
});

// Resend confirmation email
router.post('/resend', async (req, res) => {
  try {
    const { email, firstName, lastName } = req.body;
    
    if (!email || !firstName || !lastName) {
      return res.status(400).json({ error: 'Email, first name, and last name are required' });
    }

    const normalizedEmail = email.toLowerCase().trim();
    
    // Mark any existing tokens as used
    await pool.execute(
      'UPDATE email_confirmations SET used = TRUE WHERE email = ? AND used = FALSE',
      [normalizedEmail]
    );
    
    // Generate new token
    const token = generateConfirmationToken();
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
    
    // Store new confirmation token
    await pool.execute(
      `INSERT INTO email_confirmations (token, email, first_name, last_name, expires_at, created_at) 
       VALUES (?, ?, ?, ?, ?, NOW())`,
      [token, normalizedEmail, firstName, lastName, expiresAt]
    );

    // Create confirmation link
    const confirmationLink = `https://hsk-shwe-flash.vercel.app/confirm-email?token=${token}`;
    
    // Mock email sending
    console.log(`📧 Resend confirmation link for ${normalizedEmail}: ${confirmationLink}`);
    
    res.json({
      success: true,
      message: 'Confirmation email resent successfully',
      // For development only - remove in production
      confirmationLink: process.env.NODE_ENV === 'development' ? confirmationLink : undefined,
      token: process.env.NODE_ENV === 'development' ? token : undefined,
      expiresIn: 86400 // 24 hours in seconds
    });
    
  } catch (error) {
    console.error('Resend confirmation email error:', error);
    res.status(500).json({ error: 'Failed to resend confirmation email' });
  }
});

export default router;
