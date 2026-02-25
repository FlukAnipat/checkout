import express from 'express';
import { pool } from '../config/database.js';

const router = express.Router();

// Store OTP codes (in production, use Redis or database table)
const otpStore = new Map();

// Generate 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// Send OTP (mock implementation - in production, use SMS service)
router.post('/send', async (req, res) => {
  try {
    const { phoneNumber, countryCode } = req.body;
    
    if (!phoneNumber || !countryCode) {
      return res.status(400).json({ error: 'Phone number and country code are required' });
    }

    const fullPhoneNumber = `${countryCode}${phoneNumber}`;
    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes
    
    // Store OTP
    otpStore.set(fullPhoneNumber, {
      otp,
      expiresAt,
      attempts: 0,
      createdAt: new Date()
    });

    // Mock SMS sending (in production, integrate with SMS service like Twilio, AWS SNS, etc.)
    console.log(`📱 OTP for ${fullPhoneNumber}: ${otp} (expires: ${expiresAt})`);
    
    // For demo purposes, we'll log the OTP in console
    // In production, this would be sent via SMS service
    
    res.json({
      success: true,
      message: 'OTP sent successfully',
      // For development only - remove in production
      otp: process.env.NODE_ENV === 'development' ? otp : undefined,
      expiresIn: 300 // 5 minutes in seconds
    });
    
  } catch (error) {
    console.error('Send OTP error:', error);
    res.status(500).json({ error: 'Failed to send OTP' });
  }
});

// Verify OTP
router.post('/verify', async (req, res) => {
  try {
    const { phoneNumber, countryCode, otp } = req.body;
    
    if (!phoneNumber || !countryCode || !otp) {
      return res.status(400).json({ error: 'Phone number, country code, and OTP are required' });
    }

    const fullPhoneNumber = `${countryCode}${phoneNumber}`;
    const storedData = otpStore.get(fullPhoneNumber);
    
    if (!storedData) {
      return res.status(400).json({ error: 'OTP not found or expired' });
    }

    // Check if OTP is expired
    if (new Date() > storedData.expiresAt) {
      otpStore.delete(fullPhoneNumber);
      return res.status(400).json({ error: 'OTP has expired' });
    }

    // Check attempts
    if (storedData.attempts >= 3) {
      otpStore.delete(fullPhoneNumber);
      return res.status(400).json({ error: 'Too many attempts. Please request a new OTP.' });
    }

    // Verify OTP
    if (storedData.otp === otp) {
      otpStore.delete(fullPhoneNumber);
      res.json({
        success: true,
        message: 'OTP verified successfully'
      });
    } else {
      // Increment attempts
      storedData.attempts++;
      otpStore.set(fullPhoneNumber, storedData);
      
      res.status(400).json({
        error: 'Invalid OTP',
        attemptsRemaining: 3 - storedData.attempts
      });
    }
    
  } catch (error) {
    console.error('Verify OTP error:', error);
    res.status(500).json({ error: 'Failed to verify OTP' });
  }
});

// Resend OTP
router.post('/resend', async (req, res) => {
  try {
    const { phoneNumber, countryCode } = req.body;
    
    if (!phoneNumber || !countryCode) {
      return res.status(400).json({ error: 'Phone number and country code are required' });
    }

    const fullPhoneNumber = `${countryCode}${phoneNumber}`;
    
    // Clear existing OTP if any
    otpStore.delete(fullPhoneNumber);
    
    // Generate new OTP
    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes
    
    // Store new OTP
    otpStore.set(fullPhoneNumber, {
      otp,
      expiresAt,
      attempts: 0,
      createdAt: new Date()
    });

    console.log(`📱 Resent OTP for ${fullPhoneNumber}: ${otp} (expires: ${expiresAt})`);
    
    res.json({
      success: true,
      message: 'OTP resent successfully',
      // For development only - remove in production
      otp: process.env.NODE_ENV === 'development' ? otp : undefined,
      expiresIn: 300 // 5 minutes in seconds
    });
    
  } catch (error) {
    console.error('Resend OTP error:', error);
    res.status(500).json({ error: 'Failed to resend OTP' });
  }
});

// Send Email OTP (mock implementation - in production, use email service)
router.post('/send-email', async (req, res) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const normalizedEmail = email.toLowerCase().trim();
    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes
    
    // Store OTP
    otpStore.set(`email_${normalizedEmail}`, {
      otp,
      expiresAt,
      attempts: 0,
      createdAt: new Date()
    });

    // Mock email sending (in production, integrate with email service like SendGrid, AWS SES, etc.)
    console.log(`📧 Email OTP for ${normalizedEmail}: ${otp} (expires: ${expiresAt})`);
    
    // For demo purposes, we'll log the OTP in console
    // In production, this would be sent via email service
    
    res.json({
      success: true,
      message: 'Email OTP sent successfully',
      // For development only - remove in production
      otp: process.env.NODE_ENV === 'development' ? otp : undefined,
      expiresIn: 300 // 5 minutes in seconds
    });
    
  } catch (error) {
    console.error('Send Email OTP error:', error);
    res.status(500).json({ error: 'Failed to send email OTP' });
  }
});

// Verify Email OTP
router.post('/verify-email', async (req, res) => {
  try {
    const { email, otp } = req.body;
    
    if (!email || !otp) {
      return res.status(400).json({ error: 'Email and OTP are required' });
    }

    const normalizedEmail = email.toLowerCase().trim();
    const storedData = otpStore.get(`email_${normalizedEmail}`);
    
    if (!storedData) {
      return res.status(400).json({ error: 'Email OTP not found or expired' });
    }

    // Check if OTP is expired
    if (new Date() > storedData.expiresAt) {
      otpStore.delete(`email_${normalizedEmail}`);
      return res.status(400).json({ error: 'Email OTP has expired' });
    }

    // Check attempts
    if (storedData.attempts >= 3) {
      otpStore.delete(`email_${normalizedEmail}`);
      return res.status(400).json({ error: 'Too many attempts. Please request a new OTP.' });
    }

    // Verify OTP
    if (storedData.otp === otp) {
      otpStore.delete(`email_${normalizedEmail}`);
      res.json({
        success: true,
        message: 'Email OTP verified successfully'
      });
    } else {
      // Increment attempts
      storedData.attempts++;
      otpStore.set(`email_${normalizedEmail}`, storedData);
      
      res.status(400).json({
        error: 'Invalid Email OTP',
        attemptsRemaining: 3 - storedData.attempts
      });
    }
    
  } catch (error) {
    console.error('Verify Email OTP error:', error);
    res.status(500).json({ error: 'Failed to verify email OTP' });
  }
});

// Resend Email OTP
router.post('/resend-email', async (req, res) => {
  try {
    const { email } = req.body;
    
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const normalizedEmail = email.toLowerCase().trim();
    
    // Clear existing OTP if any
    otpStore.delete(`email_${normalizedEmail}`);
    
    // Generate new OTP
    const otp = generateOTP();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000); // 5 minutes
    
    // Store new OTP
    otpStore.set(`email_${normalizedEmail}`, {
      otp,
      expiresAt,
      attempts: 0,
      createdAt: new Date()
    });

    console.log(`📧 Resent Email OTP for ${normalizedEmail}: ${otp} (expires: ${expiresAt})`);
    
    res.json({
      success: true,
      message: 'Email OTP resent successfully',
      // For development only - remove in production
      otp: process.env.NODE_ENV === 'development' ? otp : undefined,
      expiresIn: 300 // 5 minutes in seconds
    });
    
  } catch (error) {
    console.error('Resend Email OTP error:', error);
    res.status(500).json({ error: 'Failed to resend email OTP' });
  }
});

// Clean expired OTPs (run periodically)
setInterval(() => {
  const now = new Date();
  for (const [key, value] of otpStore.entries()) {
    if (now > value.expiresAt) {
      otpStore.delete(key);
    }
  }
}, 60000); // Clean every minute

export default router;
