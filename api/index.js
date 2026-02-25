import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables for Vercel
dotenv.config();

// Import database configuration
import { pool } from '../server/config/database.js';

import authRoutes from '../server/routes/auth.js';
import paymentRoutes from '../server/routes/payment.js';
import vocabRoutes from '../server/routes/vocabulary.js';
import setupRoutes from '../server/routes/setup.js';
import flutterAuthRoutes from '../server/routes/flutter-auth.js';
import adminRoutes from '../server/routes/admin.js';
import salesRoutes from '../server/routes/sales.js';
import testSetupRoutes from '../server/routes/test-setup.js';
import approvalRoutes from '../server/routes/approval.js';
import otpRoutes from '../server/routes/otp.js';
import emailConfirmationRoutes from '../server/routes/email-confirmation.js';

const app = express();

// ── Middleware ──
app.use(cors({
  origin: true,
  credentials: true,
}));
app.use(express.json());

// ── API Routes ──
app.use('/api/auth', authRoutes);
app.use('/api/payment', paymentRoutes);
app.use('/api/vocab', vocabRoutes);
app.use('/api/setup', setupRoutes);
app.use('/api/auth', flutterAuthRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/sales', salesRoutes);
app.use('/api/test', testSetupRoutes);
app.use('/api/approval', approvalRoutes);
app.use('/api/otp', otpRoutes);
app.use('/api/email-confirmation', emailConfirmationRoutes);

// ── Health check ──
app.get('/api/health', async (req, res) => {
  try {
    // Test database connection
    await pool.execute('SELECT 1');
    res.json({ 
      status: 'ok', 
      timestamp: new Date().toISOString(),
      database: 'connected',
      environment: process.env.NODE_ENV || 'development'
    });
  } catch (dbError) {
    res.status(500).json({ 
      status: 'error', 
      timestamp: new Date().toISOString(),
      database: 'disconnected',
      error: dbError.message
    });
  }
});

// ── Error Handling Middleware ──
app.use((err, req, res, next) => {
  console.error('Server error:', err.message);
  res.status(500).json({
    error: 'Internal server error',
    details: err.message,
  });
});

export default function handler(req, res) {
  return app(req, res);
}
