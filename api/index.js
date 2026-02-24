import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables for Vercel
dotenv.config();

import authRoutes from '../server/routes/auth.js';
import paymentRoutes from '../server/routes/payment.js';
import vocabRoutes from '../server/routes/vocabulary.js';
import setupRoutes from '../server/routes/setup.js';
import flutterAuthRoutes from '../server/routes/flutter-auth.js';
import adminRoutes from '../server/routes/admin.js';
import salesRoutes from '../server/routes/sales.js';

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

// ── Health check ──
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Error Handling Middleware ──
app.use((err, req, res, next) => {
  console.error('Server error:', err.message);
  res.status(500).json({
    error: 'Internal server error',
    details: err.message,
  });
});

export default app;
