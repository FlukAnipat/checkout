/**
 * Database Configuration
 * PostgreSQL for Railway deployment
 */

import { Pool } from 'pg';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, '..', '.env') });

// ═══════════════════════════════════════════════════════════════════════════
// 🗄️ PostgreSQL CONNECTION POOL
// ═══════════════════════════════════════════════════════════════════════════

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false,
});

// Test connection on startup
(async () => {
  try {
    const client = await pool.connect();
    console.log('✅ Connected to PostgreSQL database');
    client.release();
  } catch (err) {
    console.error('❌ PostgreSQL connection failed:', err.message);
    console.error('💡 Make sure DATABASE_URL is set correctly');
  }
})();

// ═══════════════════════════════════════════════════════════════════════════
// 👤 USER OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getUserByEmail(email) {
  const result = await pool.query(
    'SELECT * FROM users WHERE email = $1',
    [email.toLowerCase().trim()]
  );
  return result.rows[0] || null;
}

export async function getUserById(userId) {
  const result = await pool.query(
    'SELECT * FROM users WHERE user_id = $1',
    [userId]
  );
  return result.rows[0] || null;
}

export async function createUser(userData) {
  const sql = `
    INSERT INTO users (
      user_id, email, password, first_name, last_name,
      phone, country_code, is_paid, promo_code_used, paid_at
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
  `;
  const params = [
    userData.userId,
    userData.email.toLowerCase().trim(),
    userData.password,
    userData.firstName,
    userData.lastName,
    userData.phone,
    userData.countryCode || '+95',
    userData.isPaid ? 1 : 0,
    userData.promoCodeUsed || null,
    userData.paidAt || null
  ];
  await pool.query(sql, params);
  return userData;
}

export async function updateUser(email, updates) {
  const fields = [];
  const params = [];
  let paramIndex = 1;

  const fieldMap = {
    firstName: 'first_name',
    lastName: 'last_name',
    phone: 'phone',
    countryCode: 'country_code',
    isPaid: 'is_paid',
    promoCodeUsed: 'promo_code_used',
    paidAt: 'paid_at',
  };

  Object.entries(updates).forEach(([key, value]) => {
    const col = fieldMap[key] || key;
    fields.push(`${col} = $${paramIndex}`);
    if (key === 'isPaid') {
      params.push(value ? 1 : 0);
    } else {
      params.push(value);
    }
    paramIndex++;
  });

  if (fields.length === 0) return null;

  params.push(email.toLowerCase().trim());
  const sql = `UPDATE users SET ${fields.join(', ')} WHERE email = $${paramIndex}`;
  const result = await pool.query(sql, params);

  if (result.rowCount === 0) return null;
  return await getUserByEmail(email);
}

// ═══════════════════════════════════════════════════════════════════════════
// 💳 PAYMENT OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function createPayment(paymentData) {
  const sql = `
    INSERT INTO payments (
      payment_id, user_id, amount, currency, payment_method,
      promo_code, status
    ) VALUES ($1, $2, $3, $4, $5, $6, $7)
  `;
  const params = [
    paymentData.paymentId,
    paymentData.userId,
    paymentData.amount,
    paymentData.currency || 'MMK',
    paymentData.paymentMethod,
    paymentData.promoCode || null,
    paymentData.status || 'completed'
  ];
  await pool.query(sql, params);
  return paymentData;
}

export async function getPaymentsByUserId(userId) {
  const result = await pool.query(
    'SELECT * FROM payments WHERE user_id = $1 ORDER BY created_at DESC',
    [userId]
  );
  return result.rows;
}

// ═══════════════════════════════════════════════════════════════════════════
// 🏷️ PROMO CODE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getPromoCode(code) {
  const result = await pool.query(
    `SELECT * FROM promo_codes 
     WHERE code = $1 
     AND (expires_at IS NULL OR expires_at > NOW())
     AND (max_uses IS NULL OR used_count < max_uses)`,
    [code.toUpperCase().trim()]
  );
  return result.rows[0] || null;
}

export async function usePromoCode(code) {
  const result = await pool.query(
    'UPDATE promo_codes SET used_count = used_count + 1 WHERE code = $1',
    [code.toUpperCase().trim()]
  );
  return result.rowCount > 0;
}

// ═══════════════════════════════════════════════════════════════════════════
// 🗂️ VOCABULARY OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getVocabularyByLevel(hskLevel) {
  const result = await pool.query(
    'SELECT * FROM vocabulary WHERE hsk_level = $1 ORDER BY sort_order ASC',
    [hskLevel]
  );
  return result.rows;
}

export async function getHskLevelStats() {
  const result = await pool.query(
    `SELECT hsk_level, COUNT(*) as word_count 
     FROM vocabulary 
     GROUP BY hsk_level 
     ORDER BY hsk_level ASC`
  );
  return result.rows;
}

// ═══════════════════════════════════════════════════════════════════════════
// 🔧 DATABASE UTILITIES
// ═══════════════════════════════════════════════════════════════════════════

export async function closeDatabase() {
  await pool.end();
  console.log('Database connection pool closed');
}
