import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { getUserByEmail, createUser, updateUser } from '../config/database.js';
import authMiddleware from '../middleware/auth.js';

const router = express.Router();

/**
 * POST /api/auth/login
 * Login with email + password (same credentials as Flutter app)
 */
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password are required' });
    }

    const user = await getUserByEmail(email);
    if (!user) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const token = jwt.sign(
      { userId: user.user_id, email: user.email, role: user.role || 'user' },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '7d' }
    );

    res.json({
      success: true,
      token,
      user: {
        userId: user.user_id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phone: user.phone,
        countryCode: user.country_code,
        role: user.role || 'user',
        isPaid: !!user.is_paid,
        is_paid: user.is_paid ? 1 : 0,
        paidAt: user.paid_at,
        promoCodeUsed: user.promo_code_used,
      },
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Login failed. Please try again.' });
  }
});

/**
 * POST /api/auth/register
 * Register new sales person (web only - users register via Flutter app)
 */
router.post('/register', async (req, res) => {
  try {
    const { firstName, lastName, email, phone, countryCode, password } = req.body;

    if (!firstName || !lastName || !email || !password) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    const normalizedEmail = email.toLowerCase().trim();

    const existingUser = await getUserByEmail(normalizedEmail);
    if (existingUser) {
      return res.status(409).json({ error: 'This email is already registered' });
    }

    if (password.length < 6) {
      return res.status(400).json({ error: 'Password must be at least 6 characters' });
    }

    // Only allow sales registration via web
    const role = 'sales';

    // Hash password with bcrypt
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = {
      userId: uuidv4(),
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: normalizedEmail,
      phone: (phone || '').trim(),
      countryCode: countryCode || '+95',
      country: 'Myanmar', // Default country
      role: role || 'user',
    };

    // Create user_registrations table if not exists
    await pool.execute(`
      CREATE TABLE IF NOT EXISTS user_registrations (
        user_id VARCHAR(100) PRIMARY KEY,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        country_code VARCHAR(10) NOT NULL,
        country VARCHAR(100) NOT NULL,
        role ENUM('user','sales','admin') NOT NULL DEFAULT 'user',
        status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        approved_at DATETIME DEFAULT NULL,
        rejected_at DATETIME DEFAULT NULL,
        approved_by VARCHAR(100) DEFAULT NULL,
        rejected_by VARCHAR(100) DEFAULT NULL,
        notes TEXT DEFAULT NULL
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `);

    // Insert into pending registrations table
    const [result] = await pool.execute(
      `INSERT INTO user_registrations 
        (user_id, email, password, first_name, last_name, phone, country_code, country, role, status, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending', NOW())`,
      [user.userId, user.email, hashedPassword, user.firstName, user.lastName, user.phone, user.countryCode, user.country, user.role]
    );

    // Generate JWT
    const token = jwt.sign(
      { userId: user.userId, email: user.email, role: user.role },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '24h' }
    );

    const { password: _, ...safeUser } = user;
    res.status(201).json({
      success: true,
      message: 'Registration submitted successfully! Your account is pending admin approval. You will be notified once approved.',
      user: safeUser,
      token,
      status: 'pending'
    });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ error: 'Registration failed. Please try again.' });
  }
});

/**
 * GET /api/auth/me
 * Get current user profile (requires JWT)
 */
router.get('/me', authMiddleware, async (req, res) => {
  const user = await getUserByEmail(req.user.email);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }

  const { password: _, ...safeUser } = user;
  res.json({ success: true, user: safeUser });
});

/**
 * PUT /api/auth/me
 * Update user profile (requires JWT)
 */
router.put('/me', authMiddleware, async (req, res) => {
  try {
    const { firstName, lastName, phone, countryCode } = req.body;

    if (!firstName || !lastName) {
      return res.status(400).json({ error: 'First name and last name are required' });
    }

    await updateUser(req.user.email, {
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      phone: phone?.trim() || '',
      countryCode: countryCode || '+95',
    });

    const updatedUser = await getUserByEmail(req.user.email);
    const { password: _, ...safeUser } = updatedUser;

    res.json({
      success: true,
      message: 'Profile updated successfully',
      user: {
        userId: safeUser.user_id,
        email: safeUser.email,
        firstName: safeUser.first_name,
        lastName: safeUser.last_name,
        phone: safeUser.phone,
        countryCode: safeUser.country_code,
        isPaid: !!safeUser.is_paid,
        paidAt: safeUser.paid_at,
        promoCodeUsed: safeUser.promo_code_used,
      }
    });
  } catch (err) {
    console.error('Update profile error:', err);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

/**
 * POST /api/auth/logout
 * Logout user (requires JWT)
 */
router.post('/logout', authMiddleware, async (req, res) => {
  try {
    // In a stateless JWT system, logout is typically handled client-side
    // by removing the token. Here we just return success.
    res.json({
      success: true,
      message: 'Logout successful',
    });
  } catch (err) {
    console.error('Logout error:', err);
    res.status(500).json({ error: 'Logout failed' });
  }
});

export default router;
