import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import { 
  getUserByEmail, 
  createUser, 
  getUserById,
  updateUser 
} from '../config/database.js';
import { flutterAuthMiddleware, refreshToken } from '../middleware/flutter-auth.js';
import jwt from 'jsonwebtoken';

const router = express.Router();

// ═══════════════════════════════════════════════════════════════════════════
// 📱 FLUTTER APP REGISTRATION
// ═══════════════════════════════════════════════════════════════════════════

/**
 * POST /api/auth/flutter/register
 * Flutter app registration with enhanced validation
 */
router.post('/flutter/register', async (req, res) => {
  try {
    const { 
      email, 
      password, 
      firstName, 
      lastName, 
      phone, 
      countryCode = '+95',
      appApiKey 
    } = req.body;

    // Validate app API key
    if (appApiKey !== process.env.APP_API_KEY && appApiKey !== 'shwe_flash_app_key_production_2024') {
      return res.status(401).json({ 
        error: 'Invalid app API key',
        code: 'INVALID_APP_KEY'
      });
    }

    // Validate required fields
    if (!email || !password || !firstName || !lastName) {
      return res.status(400).json({ 
        error: 'Email, password, firstName, and lastName are required',
        code: 'MISSING_FIELDS'
      });
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ 
        error: 'Invalid email format',
        code: 'INVALID_EMAIL'
      });
    }

    // Validate password strength
    if (password.length < 6) {
      return res.status(400).json({ 
        error: 'Password must be at least 6 characters long',
        code: 'WEAK_PASSWORD'
      });
    }

    // Check if user already exists
    const existingUser = await getUserByEmail(email);
    if (existingUser) {
      return res.status(409).json({ 
        error: 'Email already registered',
        code: 'EMAIL_EXISTS'
      });
    }

    // Create new user
    const bcrypt = await import('bcryptjs');
    const hashedPassword = await bcrypt.hash(password, 10);
    
    const userId = uuidv4();
    const userData = {
      userId,
      email: email.toLowerCase().trim(),
      password: hashedPassword,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phone: phone || '',
      countryCode,
      isPaid: false,
      promoCodeUsed: null,
      paidAt: null
    };

    await createUser(userData);

    // Generate tokens
    const token = jwt.sign(
      { userId, email: userData.email },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '7d' }
    );

    const refreshTokenValue = jwt.sign(
      { userId, email: userData.email },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '30d' }
    );

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      token,
      refreshToken: refreshTokenValue,
      user: {
        userId,
        email: userData.email,
        firstName: userData.firstName,
        lastName: userData.lastName,
        phone: userData.phone,
        countryCode: userData.countryCode,
        isPaid: false,
        paidAt: null
      }
    });
  } catch (err) {
    console.error('Flutter registration error:', err);
    res.status(500).json({ 
      error: 'Registration failed',
      code: 'REGISTRATION_ERROR'
    });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 📱 FLUTTER APP LOGIN
// ═══════════════════════════════════════════════════════════════════════════

/**
 * POST /api/auth/flutter/login
 * Flutter app login with enhanced security
 */
router.post('/flutter/login', async (req, res) => {
  try {
    const { email, password, appApiKey } = req.body;

    // Validate app API key
    if (appApiKey !== process.env.APP_API_KEY && appApiKey !== 'shwe_flash_app_key_production_2024') {
      return res.status(401).json({ 
        error: 'Invalid app API key',
        code: 'INVALID_APP_KEY'
      });
    }

    if (!email || !password) {
      return res.status(400).json({ 
        error: 'Email and password are required',
        code: 'MISSING_CREDENTIALS'
      });
    }

    const user = await getUserByEmail(email);
    if (!user) {
      return res.status(401).json({ 
        error: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS'
      });
    }

    const bcrypt = await import('bcryptjs');
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ 
        error: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS'
      });
    }

    // Generate tokens
    const token = jwt.sign(
      { userId: user.user_id, email: user.email },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '7d' }
    );

    const refreshTokenValue = jwt.sign(
      { userId: user.user_id, email: user.email },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '30d' }
    );

    res.json({
      success: true,
      message: 'Login successful',
      token,
      refreshToken: refreshTokenValue,
      user: {
        userId: user.user_id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phone: user.phone,
        countryCode: user.country_code,
        isPaid: !!user.is_paid,
        paidAt: user.paid_at
      }
    });
  } catch (err) {
    console.error('Flutter login error:', err);
    res.status(500).json({ 
      error: 'Login failed',
      code: 'LOGIN_ERROR'
    });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 🔄 TOKEN REFRESH
// ═══════════════════════════════════════════════════════════════════════════

/**
 * POST /api/auth/flutter/refresh
 * Refresh access token for Flutter app
 */
router.post('/flutter/refresh', refreshToken);

// ═══════════════════════════════════════════════════════════════════════════
// 👤 FLUTTER USER PROFILE
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GET /api/auth/flutter/me
 * Get Flutter user profile with enhanced middleware
 */
router.get('/flutter/me', flutterAuthMiddleware, async (req, res) => {
  try {
    const user = await getUserById(req.user.userId);
    if (!user) {
      return res.status(404).json({ 
        error: 'User not found',
        code: 'USER_NOT_FOUND'
      });
    }

    res.json({
      success: true,
      user: {
        userId: user.user_id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phone: user.phone,
        countryCode: user.country_code,
        isPaid: !!user.is_paid,
        paidAt: user.paid_at,
        createdAt: user.created_at
      }
    });
  } catch (err) {
    console.error('Flutter profile error:', err);
    res.status(500).json({ 
      error: 'Failed to fetch profile',
      code: 'PROFILE_ERROR'
    });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 🔄 FLUTTER PROFILE UPDATE
// ═══════════════════════════════════════════════════════════════════════════

/**
 * PUT /api/auth/flutter/profile
 * Update Flutter user profile
 */
router.put('/flutter/profile', flutterAuthMiddleware, async (req, res) => {
  try {
    const { firstName, lastName, phone, countryCode } = req.body;
    
    const updates = {};
    if (firstName !== undefined) updates.firstName = firstName.trim();
    if (lastName !== undefined) updates.lastName = lastName.trim();
    if (phone !== undefined) updates.phone = phone;
    if (countryCode !== undefined) updates.countryCode = countryCode;

    const updatedUser = await updateUser(req.user.email, updates);
    if (!updatedUser) {
      return res.status(404).json({ 
        error: 'User not found',
        code: 'USER_NOT_FOUND'
      });
    }

    res.json({
      success: true,
      message: 'Profile updated successfully',
      user: {
        userId: updatedUser.user_id,
        email: updatedUser.email,
        firstName: updatedUser.first_name,
        lastName: updatedUser.last_name,
        phone: updatedUser.phone,
        countryCode: updatedUser.country_code,
        isPaid: !!updatedUser.is_paid,
        paidAt: updatedUser.paid_at
      }
    });
  } catch (err) {
    console.error('Flutter profile update error:', err);
    res.status(500).json({ 
      error: 'Profile update failed',
      code: 'UPDATE_ERROR'
    });
  }
});

export default router;
