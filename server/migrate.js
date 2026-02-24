/**
 * Migration Script: JSON → SQLite
 * Run once to migrate existing data from JSON files to SQLite database
 */

import sqlite3 from 'sqlite3';
import fs from 'fs';
import path from 'path';
import bcrypt from 'bcryptjs';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Database file
const DB_PATH = path.join(__dirname, '..', '..', 'shwe_flash.db');
const DATA_DIR = path.join(__dirname, '..', 'data');

// Ensure database exists
const db = new sqlite3.Database(DB_PATH);

// Read JSON files
function readJSON(filePath) {
  try {
    if (!fs.existsSync(filePath)) return [];
    const data = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(data);
  } catch {
    return [];
  }
}

// Promisify database operations
function run(sql, params = []) {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) reject(err);
      else resolve({ id: this.lastID, changes: this.changes });
    });
  });
}

async function migrate() {
  console.log('🔄 Starting migration from JSON to SQLite...');

  // Read existing data
  const users = readJSON(path.join(DATA_DIR, 'users.json'));
  const payments = readJSON(path.join(DATA_DIR, 'payments.json'));

  console.log(`📊 Found ${users.length} users and ${payments.length} payments`);

  // Migrate users
  for (const user of users) {
    try {
      await run(`
        INSERT OR REPLACE INTO users (
          user_id, email, password, first_name, last_name, 
          phone, country_code, is_paid, promo_code_used, paid_at, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        user.userId || `migrated_${Date.now()}_${Math.random().toString(36).slice(2)}`,
        user.email,
        user.password,
        user.firstName,
        user.lastName,
        user.phone,
        user.countryCode || '+95',
        user.isPaid ? 1 : 0,
        user.promoCodeUsed || null,
        user.paidAt || null,
        user.createdAt || new Date().toISOString()
      ]);
      console.log(`✅ Migrated user: ${user.email}`);
    } catch (err) {
      console.error(`❌ Failed to migrate user ${user.email}:`, err.message);
    }
  }

  // Migrate payments
  for (const payment of payments) {
    try {
      await run(`
        INSERT OR REPLACE INTO payments (
          payment_id, user_id, amount, currency, payment_method, 
          promo_code, status, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        payment.paymentId,
        payment.userId,
        payment.amount,
        payment.currency || 'MMK',
        payment.paymentMethod,
        payment.promoCode || null,
        payment.status || 'completed',
        payment.createdAt || new Date().toISOString()
      ]);
      console.log(`✅ Migrated payment: ${payment.paymentId}`);
    } catch (err) {
      console.error(`❌ Failed to migrate payment ${payment.paymentId}:`, err.message);
    }
  }

  // Create admin user if not exists
  const adminEmail = 'admin@gmail.com';
  const existingAdmin = await run('SELECT user_id FROM users WHERE email = ?', [adminEmail]);
  
  if (existingAdmin.changes === 0) {
    const hashedPassword = await bcrypt.hash('admin123', 10);
    await run(`
      INSERT INTO users (
        user_id, email, password, first_name, last_name, 
        phone, country_code, is_paid, created_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      'user_admin_001',
      adminEmail,
      hashedPassword,
      'Admin',
      'User',
      '123456789',
      '+95',
      0,
      new Date().toISOString()
    ]);
    console.log('✅ Created admin user: admin@gmail.com / admin123');
  }

  console.log('🎉 Migration completed!');
  console.log('💡 You can now delete the /data folder and use SQLite exclusively');
  
  // Close database
  db.close();
}

// Run migration
migrate().catch(console.error);
