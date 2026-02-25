import dotenv from 'dotenv';
import express from 'express';
import cors from 'cors';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load .env from server directory
dotenv.config({ path: path.join(__dirname, '.env') });

import authRoutes from './routes/auth.js';
import paymentRoutes from './routes/payment.js';
import vocabRoutes from './routes/vocabulary.js';
import setupRoutes from './routes/setup.js';
import flutterAuthRoutes from './routes/flutter-auth.js';
import adminRoutes from './routes/admin.js';
import salesRoutes from './routes/sales.js';
import testSetupRoutes from './routes/test-setup.js';
import approvalRoutes from './routes/approval.js';
import otpRoutes from './routes/otp.js';
import emailConfirmationRoutes from './routes/email-confirmation.js';

const app = express();
const PORT = process.env.PORT || 8080;

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
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ── Simple test endpoint ──
app.get('/api/test/simple', (req, res) => {
  res.json({ 
    success: true, 
    message: 'Simple test endpoint working',
    timestamp: new Date().toISOString()
  });
});

// Note: Frontend is served by Vercel, not Railway
// Railway only serves API endpoints

// ── Error Handling Middleware (must be AFTER routes) ──
app.use((err, req, res, next) => {
  console.error('❌ Server error:', err.message);
  res.status(500).json({
    error: 'Internal server error',
    details: err.message,
  });
});

// ── Start server ──
let serverReady = false;

const server = app.listen(PORT, () => {
  serverReady = true;
  const baseUrl = process.env.NODE_ENV === 'production' 
    ? `https://checkout.up.railway.app` 
    : `http://localhost:${PORT}`;
  
  console.log(`\n🚀 Shwe Flash Payment Server running on ${baseUrl}`);
  console.log(`📡 API: ${baseUrl}/api`);
  console.log(`💳 Payment: ${baseUrl}/api/payment`);
  console.log(`🔐 Auth: ${baseUrl}/api/auth`);
  console.log(`📧 Email: ${baseUrl}/api/email-confirmation`);
  console.log(`✅ Server is ready and accepting connections\n`);
  console.log(`🔧 Environment: ${process.env.NODE_ENV}`);
  console.log(`🔧 Port: ${PORT}`);
  console.log(`🔧 DATABASE_URL exists:`, !!process.env.DATABASE_URL);
  console.log(`🔧 DB_NAME:`, process.env.DB_NAME);
  console.log(`🔧 RESEND_API_KEY exists:`, !!process.env.RESEND_API_KEY);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n❌ Port ${PORT} is already in use!`);
    console.error(`💡 Run: taskkill /F /PID <PID>  (find PID with: netstat -ano | findstr :${PORT})`);
  } else {
    console.error('❌ Server error:', err);
  }
  process.exit(1);
});

// ── Graceful shutdown (only after server is ready) ──
let shutdownCount = 0;
function shutdown(signal) {
  shutdownCount++;
  console.log(`\n📡 Received ${signal} signal (${shutdownCount}/3)`);
  
  if (!serverReady) {
    console.log('⚠️ Ignoring shutdown signal — server not ready yet');
    if (shutdownCount >= 3) {
      console.log('❌ Too many shutdown attempts, forcing exit');
      process.exit(1);
    }
    return;
  }
  
  if (shutdownCount === 1) {
    console.log('🛑 Shutting down server... (Press Ctrl+C again to force exit)');
    server.close(async () => {
      const { closeDatabase } = await import('./config/database.js');
      await closeDatabase();
      process.exit(0);
    });
    
    // Force exit after 5 seconds if graceful shutdown fails
    setTimeout(() => {
      console.log('❌ Graceful shutdown timeout, forcing exit');
      process.exit(1);
    }, 5000);
  } else if (shutdownCount >= 2) {
    console.log('❌ Force shutdown');
    process.exit(1);
  }
}

process.on('SIGINT', () => shutdown('SIGINT'));
process.on('SIGTERM', () => shutdown('SIGTERM'));

// Keep process alive — prevent early exit on Windows
process.stdin.resume();

// Additional safety: prevent uncaught exceptions from crashing
process.on('uncaughtException', (err) => {
  console.error('❌ Uncaught exception:', err);
  if (serverReady) {
    console.log('🛑 Shutting down due to uncaught exception...');
    process.exit(1);
  }
});

process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled rejection at:', promise, 'reason:', reason);
});
