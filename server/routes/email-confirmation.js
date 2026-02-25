import express from 'express';
import { pool } from '../config/database.js';
import crypto from 'crypto';
import { Resend } from 'resend';

const router = express.Router();

// Generate unique confirmation token
function generateConfirmationToken() {
  return crypto.randomBytes(32).toString('hex');
}

// Send confirmation email
router.post('/send-confirmation', async (req, res) => {
  try {
    console.log('🔧 Debug: Email confirmation request received');
    console.log('🔧 Debug: Request body:', req.body);
    
    const { email, firstName, lastName } = req.body;
    
    if (!email || !firstName || !lastName) {
      console.log('🔧 Debug: Missing required fields');
      return res.status(400).json({ error: 'Email, first name, and last name are required' });
    }
    
    // Check database connection
    if (!pool) {
      console.log('🔧 Debug: Database pool not available');
      return res.status(500).json({ error: 'Database connection not available' });
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
    
    // Send real email using Resend API (Free Tier: 3,000 emails/month)
    try {
      console.log('🔧 Debug: Starting Resend API...');
      console.log('🔧 Debug: RESEND_API_KEY exists:', !!process.env.RESEND_API_KEY);
      
      const resend = new Resend(process.env.RESEND_API_KEY);
      console.log('🔧 Debug: Resend client created');

      // Send email
      const result = await resend.emails.send({
        from: 'HSK Shwe Flash <delivered@resend.dev>',
        to: normalizedEmail,
        subject: 'Sales Registration Confirmation - HSK Shwe Flash',
        html: `
          <!DOCTYPE html>
          <html>
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Sales Registration - HSK Shwe Flash</title>
          </head>
          <body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f5f5f5;">
            <div style="max-width: 600px; margin: 20px auto; background: white; border: 1px solid #ddd; border-radius: 8px;">
              
              <!-- Header -->
              <div style="background: #2c3e50; padding: 30px; text-align: center;">
                <h1 style="color: white; margin: 0; font-size: 24px;">HSK Shwe Flash</h1>
                <p style="color: #ecf0f1; margin: 5px 0 0 0; font-size: 14px;">Sales Registration System</p>
              </div>
              
              <!-- Content -->
              <div style="padding: 30px;">
                <h2 style="color: #2c3e50; margin: 0 0 20px 0; font-size: 20px;">Confirm Your Email Address</h2>
                
                <p style="color: #555; margin: 0 0 20px 0; font-size: 16px;">Hi ${name},</p>
                
                <p style="color: #555; margin: 0 0 25px 0; font-size: 16px; line-height: 1.5;">
                  Thank you for registering as a sales representative for HSK Shwe Flash. 
                  Please confirm your email address to activate your sales account.
                </p>
                
                <!-- Sales Benefits -->
                <div style="background: #f8f9fa; border-left: 4px solid #3498db; padding: 20px; margin: 25px 0;">
                  <h3 style="color: #2c3e50; margin: 0 0 15px 0; font-size: 16px;">Your Sales Account Includes:</h3>
                  <ul style="color: #555; margin: 0; padding-left: 20px; line-height: 1.6;">
                    <li>Access to HSK learning materials catalog</li>
                    <li>Sales dashboard and analytics</li>
                    <li>Customer management tools</li>
                    <li>Commission tracking system</li>
                  </ul>
                </div>
                
                <!-- CTA Button -->
                <div style="text-align: center; margin: 30px 0;">
                  <a href="${confirmationLink}" 
                     style="display: inline-block; background: #3498db; color: white; padding: 15px 35px; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 16px;">
                    Confirm Email Address
                  </a>
                </div>
                
                <!-- Fallback Link -->
                <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 25px 0;">
                  <p style="color: #666; margin: 0 0 8px 0; font-size: 13px;">Copy and paste this link:</p>
                  <p style="color: #333; margin: 0; font-size: 11px; word-break: break-all; font-family: monospace;">${confirmationLink}</p>
                </div>
              </div>
              
              <!-- Footer -->
              <div style="background: #f8f9fa; padding: 20px; text-align: center; border-top: 1px solid #ddd;">
                <p style="color: #666; margin: 0 0 10px 0; font-size: 13px;">
                  This link expires in 24 hours
                </p>
                <p style="color: #666; margin: 0 0 15px 0; font-size: 13px;">
                  If you didn't request this email, please ignore it
                </p>
                <p style="color: #999; margin: 0; font-size: 11px;">© 2024 HSK Shwe Flash. All rights reserved.</p>
              </div>
              
            </div>
          </body>
          </html>
        `
      });
      
      console.log('🔧 Debug: Email send result:', result);
      console.log(`📧 Email sent successfully to ${normalizedEmail}`);
    } catch (emailError) {
      console.error('❌ Email sending failed:', emailError.message);
      console.error('🔧 Full error:', {
        message: emailError.message,
        code: emailError.code,
        statusCode: emailError.statusCode,
        response: emailError.response?.data,
        stack: emailError.stack
      });
      
      // Return error to user
      return res.status(500).json({
        success: false,
        message: 'Failed to send confirmation email',
        error: emailError.message
      });
      // Fallback to mock for development
      console.log(`📧 Confirmation link for ${normalizedEmail}: ${confirmationLink}`);
      console.log(`📧 Token: ${token} (expires: ${expiresAt})`);
    }
    
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
