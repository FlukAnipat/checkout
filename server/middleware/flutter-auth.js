// ═══════════════════════════════════════════════════════════════════════════
// 📱 FLUTTER APP AUTHENTICATION MIDDLEWARE
// ═══════════════════════════════════════════════════════════════════════════

import jwt from 'jsonwebtoken';
import { getUserById } from '../config/database.js';

// Enhanced auth middleware for Flutter apps
export const flutterAuthMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    const appApiKey = req.headers['x-app-api-key'];

    // Validate app API key (optional but recommended)
    if (appApiKey !== process.env.APP_API_KEY && appApiKey !== 'shwe_flash_app_key_production_2024') {
      return res.status(401).json({ 
        error: 'Invalid app API key',
        code: 'INVALID_APP_KEY'
      });
    }

    // Check for Bearer token
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        error: 'Authorization token required',
        code: 'TOKEN_REQUIRED'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024');
    
    // Get user from database
    const user = await getUserById(decoded.userId);
    if (!user) {
      return res.status(401).json({ 
        error: 'User not found',
        code: 'USER_NOT_FOUND'
      });
    }

    // Attach user to request
    req.user = {
      userId: user.user_id,
      email: user.email,
      isPaid: !!user.is_paid
    };

    next();
  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      return res.status(401).json({ 
        error: 'Token expired',
        code: 'TOKEN_EXPIRED'
      });
    } else if (err.name === 'JsonWebTokenError') {
      return res.status(401).json({ 
        error: 'Invalid token',
        code: 'INVALID_TOKEN'
      });
    } else {
      console.error('Auth middleware error:', err);
      return res.status(500).json({ 
        error: 'Authentication error',
        code: 'AUTH_ERROR'
      });
    }
  }
};

// ═══════════════════════════════════════════════════════════════════════════
// 🔄 TOKEN REFRESH ENDPOINT
// ═══════════════════════════════════════════════════════════════════════════

export const refreshToken = async (req, res) => {
  try {
    const { refreshToken } = req.body;
    
    if (!refreshToken) {
      return res.status(400).json({ error: 'Refresh token required' });
    }

    // Verify refresh token (longer-lived token)
    const decoded = jwt.verify(refreshToken, process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024');
    
    // Get fresh user data
    const user = await getUserById(decoded.userId);
    if (!user) {
      return res.status(401).json({ error: 'User not found' });
    }

    // Generate new access token
    const newToken = jwt.sign(
      { userId: user.user_id, email: user.email },
      process.env.JWT_SECRET || 'shwe_flash_secret_key_change_in_production_2024',
      { expiresIn: '7d' }
    );

    res.json({
      success: true,
      token: newToken,
      user: {
        userId: user.user_id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        isPaid: !!user.is_paid
      }
    });
  } catch (err) {
    res.status(401).json({ error: 'Invalid refresh token' });
  }
};
