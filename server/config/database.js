/**
 * Database Configuration
 * MySQL via Railway for production
 */

import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({ path: path.join(__dirname, '..', '.env') });

// ═══════════════════════════════════════════════════════════════════════════
// 🗄️ MySQL CONNECTION POOL (Railway)
// ═══════════════════════════════════════════════════════════════════════════

// Railway auto-discovers MySQL database connection
const railwayUrl = process.env.DATABASE_URL;

let pool;

if (railwayUrl && railwayUrl.includes('mysql://')) {
  // Parse Railway connection string
  const url = new URL(railwayUrl);
  pool = mysql.createPool({
    host: url.hostname,
    port: parseInt(url.port) || 3306,
    user: url.username,
    password: url.password,
    database: url.pathname.substring(1), // Remove leading slash
    waitForConnections: true,
    connectionLimit: 5, // Reduce for Railway
    queueLimit: 0,
    ssl: { rejectUnauthorized: false },
    acquireTimeout: 60000, // 60 seconds
    timeout: 60000, // 60 seconds
    reconnect: true, // Auto reconnect
    idleTimeout: 300000, // 5 minutes
    enableKeepAlive: true,
    keepAliveInitialDelay: 0
  });
} else {
  // Fallback to individual environment variables (for local development)
  pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306'),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'shwe_flash_db',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
  });
}

// Test connection on startup with retry logic
(async () => {
  const maxRetries = 5;
  const retryDelay = 3000; // 3 seconds
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const conn = await pool.getConnection();
      console.log('✅ Connected to MySQL database (Railway)');
      conn.release();
      break;
    } catch (err) {
      console.error(`❌ MySQL connection attempt ${attempt}/${maxRetries} failed:`, err.message);
      
      if (attempt === maxRetries) {
        console.error('🚨 All connection attempts failed. Please check:');
        console.error('   - DATABASE_URL environment variable');
        console.error('   - Railway service status');
        console.error('   - Network connectivity');
        process.exit(1);
      }
      
      console.log(`⏳ Retrying in ${retryDelay/1000} seconds...`);
      await new Promise(resolve => setTimeout(resolve, retryDelay));
    }
  }
})();

// ═══════════════════════════════════════════════════════════════════════════
// � CONNECTION RETRY WRAPPER
// ═══════════════════════════════════════════════════════════════════════════

async function executeWithRetry(operation, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await operation();
    } catch (err) {
      if (err.code === 'ETIMEDOUT' || err.code === 'ECONNREFUSED' || err.code === 'ENOTFOUND') {
        console.error(`⚠️ Database operation attempt ${attempt}/${maxRetries} failed:`, err.message);
        
        if (attempt === maxRetries) {
          throw new Error(`Database operation failed after ${maxRetries} attempts: ${err.message}`);
        }
        
        console.log(`⏳ Retrying database operation in 2 seconds...`);
        await new Promise(resolve => setTimeout(resolve, 2000));
      } else {
        throw err; // Re-throw non-connection errors
      }
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// �� USER OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getUserByEmail(email) {
  return await executeWithRetry(async () => {
    const [rows] = await pool.execute(
      'SELECT * FROM users WHERE email = ?',
      [email.toLowerCase().trim()]
    );
    return rows[0] || null;
  });
}

export async function getUserById(userId) {
  const [rows] = await pool.execute(
    'SELECT * FROM users WHERE user_id = ?',
    [userId]
  );
  return rows[0] || null;
}

export async function createUser(userData) {
  const sql = `
    INSERT INTO users (
      user_id, email, password, first_name, last_name,
      phone, country_code, role, is_paid, promo_code_used, paid_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const params = [
    userData.userId,
    userData.email.toLowerCase().trim(),
    userData.password,
    userData.firstName,
    userData.lastName,
    userData.phone,
    userData.countryCode || '+95',
    userData.role || 'user',
    userData.isPaid ? 1 : 0,
    userData.promoCodeUsed || null,
    userData.paidAt || null
  ];
  await pool.execute(sql, params);
  return userData;
}

export async function updateUser(email, updates) {
  const fields = [];
  const params = [];

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
    if (key === 'isPaid') {
      fields.push(`${col} = ?`);
      params.push(value ? 1 : 0);
    } else {
      fields.push(`${col} = ?`);
      params.push(value);
    }
  });

  if (fields.length === 0) return null;

  params.push(email.toLowerCase().trim());
  const sql = `UPDATE users SET ${fields.join(', ')} WHERE email = ?`;
  const [result] = await pool.execute(sql, params);

  if (result.affectedRows === 0) return null;
  return await getUserByEmail(email);
}

// ═══════════════════════════════════════════════════════════════════════════
// 💳 PAYMENT OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function createPayment(paymentData) {
  const sql = `
    INSERT INTO payments (
      payment_id, user_id, amount, currency, payment_method,
      promo_code, referral_id, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const params = [
    paymentData.paymentId,
    paymentData.userId,
    paymentData.amount,
    paymentData.currency || 'MMK',
    paymentData.paymentMethod,
    paymentData.promoCode || null,
    paymentData.referralId || null,
    paymentData.status || 'completed'
  ];
  await pool.execute(sql, params);
  return paymentData;
}

export async function getPaymentsByUserId(userId) {
  const [rows] = await pool.execute(
    'SELECT * FROM payments WHERE user_id = ? ORDER BY created_at DESC',
    [userId]
  );
  return rows;
}

// ═══════════════════════════════════════════════════════════════════════════
// 🏷️ PROMO CODE OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getSalesPersonByUserId(userId) {
  const [rows] = await pool.execute(
    'SELECT first_name, last_name FROM users WHERE user_id = ?',
    [userId]
  );
  return rows[0] || null;
}

export async function getPromoCode(code) {
  const [rows] = await pool.execute(
    `SELECT * FROM promo_codes 
     WHERE code = ? 
     AND (expires_at IS NULL OR expires_at > NOW())
     AND (max_uses IS NULL OR used_count < max_uses)`,
    [code.toUpperCase().trim()]
  );
  return rows[0] || null;
}

export async function usePromoCode(code) {
  const [result] = await pool.execute(
    'UPDATE promo_codes SET used_count = used_count + 1 WHERE code = ?',
    [code.toUpperCase().trim()]
  );
  return result.affectedRows > 0;
}


// ═══════════════════════════════════════════════════════════════════════════
// �️ PROMO CODE USAGE TRACKING
// ═══════════════════════════════════════════════════════════════════════════

export async function checkPromoCodeUsage(userId, promoCode) {
  const [rows] = await pool.execute(
    'SELECT * FROM promo_code_usage WHERE user_id = ? AND promo_code = ?',
    [userId, promoCode.toUpperCase().trim()]
  );
  return rows[0] || null;
}

export async function recordPromoCodeUsage(userId, promoCode, discountAmount, orderId) {
  const sql = `
    INSERT INTO promo_code_usage (promo_code, user_id, discount_amount, order_id)
    VALUES (?, ?, ?, ?)
  `;
  await pool.execute(sql, [promoCode.toUpperCase().trim(), userId, discountAmount, orderId]);
}

// ═══════════════════════════════════════════════════════════════════════════
// 📚 VOCABULARY OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getVocabularyByLevel(hskLevel) {
  const [rows] = await pool.execute(
    'SELECT * FROM vocabulary WHERE hsk_level = ? ORDER BY sort_order ASC',
    [hskLevel]
  );
  return rows;
}

export async function getHskLevelStats() {
  const [rows] = await pool.execute(
    `SELECT hsk_level, COUNT(*) as word_count 
     FROM vocabulary 
     GROUP BY hsk_level 
     ORDER BY hsk_level ASC`
  );
  return rows;
}

export async function getUserProfile(userId) {
  const [rows] = await pool.execute(
    `SELECT u.*, 
      (SELECT COUNT(*) FROM user_saved_words sw WHERE sw.user_id = u.user_id) AS saved_count,
      (SELECT COUNT(*) FROM user_word_status ws WHERE ws.user_id = u.user_id AND ws.status = 'mastered') AS mastered_count,
      (SELECT COUNT(*) FROM user_word_status ws WHERE ws.user_id = u.user_id AND ws.status = 'skipped') AS skipped_count,
      (SELECT COALESCE(SUM(ls.learned_cards), 0) FROM learning_sessions ls WHERE ls.user_id = u.user_id) AS total_learned
     FROM users u WHERE u.user_id = ?`,
    [userId]
  );
  return rows[0] || null;
}

export async function getUserSavedWords(userId) {
  const [rows] = await pool.execute(
    `SELECT v.* FROM user_saved_words sw
     JOIN vocabulary v ON sw.vocab_id = v.vocab_id
     WHERE sw.user_id = ?
     ORDER BY sw.saved_at DESC`,
    [userId]
  );
  return rows;
}

export async function getUserWordStatuses(userId) {
  const [rows] = await pool.execute(
    'SELECT vocab_id, status FROM user_word_status WHERE user_id = ?',
    [userId]
  );
  return rows;
}

export async function syncUserSavedWord(userId, vocabId) {
  try {
    await pool.execute(
      'INSERT IGNORE INTO user_saved_words (user_id, vocab_id) VALUES (?, ?)',
      [userId, vocabId]
    );
  } catch (err) {
    console.error('syncUserSavedWord error:', err);
    throw err;
  }
}

export async function removeUserSavedWord(userId, vocabId) {
  await pool.execute(
    'DELETE FROM user_saved_words WHERE user_id = ? AND vocab_id = ?',
    [userId, vocabId]
  );
}

export async function syncUserWordStatus(userId, vocabId, status) {
  try {
    await pool.execute(
      `INSERT INTO user_word_status (user_id, vocab_id, status) 
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE status = VALUES(status), updated_at = NOW()`,
      [userId, vocabId, status]
    );
  } catch (err) {
    console.error('syncUserWordStatus error:', err);
    throw err;
  }
}

export async function syncLearningSession(userId, sessionDate, learnedCards, minutesSpent, hskLevel) {
  await pool.execute(
    `INSERT INTO learning_sessions (user_id, session_date, learned_cards, minutes_spent, hsk_level)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE 
       learned_cards = VALUES(learned_cards),
       minutes_spent = VALUES(minutes_spent),
       hsk_level = VALUES(hsk_level)`,
    [userId, sessionDate, learnedCards, minutesSpent, hskLevel]
  );
}

export async function getUserDailyGoals(userId) {
  const [rows] = await pool.execute(
    'SELECT goal_date, target_cards, completed_cards, is_completed FROM daily_goals WHERE user_id = ? ORDER BY goal_date DESC LIMIT 30',
    [userId]
  );
  return rows;
}

export async function getUserLearningSessions(userId) {
  const [rows] = await pool.execute(
    'SELECT session_date, learned_cards, minutes_spent, hsk_level FROM learning_sessions WHERE user_id = ? ORDER BY session_date DESC LIMIT 30',
    [userId]
  );
  return rows;
}

export async function getUserStats(userId) {
  const [goalRows] = await pool.execute(
    'SELECT goal_date, is_completed FROM daily_goals WHERE user_id = ? ORDER BY goal_date DESC',
    [userId]
  );
  
  const [sessionRows] = await pool.execute(
    'SELECT SUM(learned_cards) as total_learned FROM learning_sessions WHERE user_id = ?',
    [userId]
  );
  
  let dayStreak = 0;
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  let checkDate = new Date(today);
  while (true) {
    const hasCompleted = goalRows.some(row => {
      const goalDate = new Date(row.goal_date);
      goalDate.setHours(0, 0, 0, 0);
      return goalDate.getTime() === checkDate.getTime() && (row.is_completed === 1 || row.is_completed === true);
    });
    
    if (hasCompleted) {
      dayStreak++;
      checkDate.setDate(checkDate.getDate() - 1);
    } else {
      break;
    }
  }
  
  const totalLearned = sessionRows[0]?.total_learned || 0;
  
  return {
    dayStreak,
    totalLearned
  };
}

export async function syncDailyGoal(userId, goalDate, targetCards, completedCards, isCompleted) {
  await pool.execute(
    `INSERT INTO daily_goals (user_id, goal_date, target_cards, completed_cards, is_completed)
     VALUES (?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE 
       target_cards = VALUES(target_cards),
       completed_cards = VALUES(completed_cards),
       is_completed = VALUES(is_completed)`,
    [userId, goalDate, targetCards, completedCards, isCompleted ? 1 : 0]
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// ⚙️ USER SETTINGS
// ═══════════════════════════════════════════════════════════════════════════

export async function getUserSettings(userId) {
  const [rows] = await pool.execute(
    `SELECT user_id, app_language, current_hsk_level, daily_goal_target, 
            is_shuffle_mode, notification_enabled, reminder_time, updated_at
     FROM user_settings WHERE user_id = ?`,
    [userId]
  );
  return rows.length > 0 ? rows[0] : null;
}

export async function syncUserSettings(userId, settings) {
  const { appLanguage, currentHskLevel, dailyGoalTarget, isShuffleMode, notificationEnabled, reminderTime } = settings;
  await pool.execute(
    `INSERT INTO user_settings 
     (user_id, app_language, current_hsk_level, daily_goal_target, is_shuffle_mode, notification_enabled, reminder_time)
     VALUES (?, ?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE 
       app_language = VALUES(app_language),
       current_hsk_level = VALUES(current_hsk_level),
       daily_goal_target = VALUES(daily_goal_target),
       is_shuffle_mode = VALUES(is_shuffle_mode),
       notification_enabled = VALUES(notification_enabled),
       reminder_time = VALUES(reminder_time)`,
    [userId, appLanguage, currentHskLevel, dailyGoalTarget, isShuffleMode ? 1 : 0, notificationEnabled ? 1 : 0, reminderTime]
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// 🏆 USER ACHIEVEMENTS
// ═══════════════════════════════════════════════════════════════════════════

export async function getUserAchievements(userId) {
  const [rows] = await pool.execute(
    `SELECT achievement_key, unlocked_at 
     FROM user_achievements WHERE user_id = ? ORDER BY unlocked_at DESC`,
    [userId]
  );
  return rows;
}

export async function unlockAchievement(userId, achievementKey) {
  await pool.execute(
    `INSERT IGNORE INTO user_achievements (user_id, achievement_key, unlocked_at)
     VALUES (?, ?, NOW())`,
    [userId, achievementKey]
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// 📊 ADMIN OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getAllUsers() {
  const [rows] = await pool.execute(
    `SELECT user_id, email, first_name, last_name, phone, country_code, role, 
            is_paid, promo_code_used, paid_at, created_at, updated_at
     FROM users ORDER BY created_at DESC`
  );
  return rows;
}

export async function getAllPayments() {
  const [rows] = await pool.execute(
    `SELECT p.*, CONCAT(u.first_name, ' ', u.last_name) as customer_name, u.email as customer_email
     FROM payments p
     JOIN users u ON p.user_id = u.user_id
     ORDER BY p.created_at DESC`
  );
  return rows;
}

export async function getAllPromoCodes() {
  const [rows] = await pool.execute(
    `SELECT pc.*, CONCAT(u.first_name, ' ', u.last_name) as sales_person_name
     FROM promo_codes pc
     LEFT JOIN users u ON pc.sales_person_id = u.user_id
     ORDER BY pc.created_at DESC`
  );
  return rows;
}

export async function createPromoCode(data) {
  const sql = `
    INSERT INTO promo_codes (code, discount_percent, max_uses, sales_person_id, expires_at)
    VALUES (?, ?, ?, ?, ?)
  `;
  await pool.execute(sql, [
    data.code.toUpperCase().trim(),
    data.discountPercent,
    data.maxUses || 100,
    data.salesPersonId || null,
    data.expiresAt || null
  ]);
}

export async function getAdminDashboardStats() {
  const [userStats] = await pool.execute(
    `SELECT 
       COUNT(*) as total_users,
       SUM(CASE WHEN role = 'sales' THEN 1 ELSE 0 END) as total_sales_persons,
       SUM(CASE WHEN is_paid = 1 THEN 1 ELSE 0 END) as total_paid_users
     FROM users`
  );
  const [paymentStats] = await pool.execute(
    `SELECT 
       COUNT(*) as total_payments,
       COALESCE(SUM(amount), 0) as total_revenue
     FROM payments WHERE status = 'completed'`
  );
  const [promoStats] = await pool.execute(
    `SELECT COUNT(*) as total_promo_codes, SUM(used_count) as total_promo_used FROM promo_codes`
  );
  return {
    ...userStats[0],
    ...paymentStats[0],
    ...promoStats[0]
  };
}

// ═══════════════════════════════════════════════════════════════════════════
// 💼 SALES OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getSalesPromoCodes(salesPersonId) {
  const [rows] = await pool.execute(
    `SELECT pc.*,
       (SELECT COUNT(*) FROM promo_code_usage pcu WHERE pcu.promo_code = pc.code) as times_used,
       (SELECT COALESCE(SUM(pcu.discount_amount), 0) FROM promo_code_usage pcu WHERE pcu.promo_code = pc.code) as total_discount_given
     FROM promo_codes pc
     WHERE pc.sales_person_id = ?
     ORDER BY pc.created_at DESC`,
    [salesPersonId]
  );
  return rows;
}

export async function getSalesDashboardStats(salesPersonId) {
  const COMMISSION_RATE = 0.20;
  const [promoRows] = await pool.execute(
    `SELECT code FROM promo_codes WHERE sales_person_id = ?`,
    [salesPersonId]
  );
  
  if (promoRows.length === 0) {
    return { totalSales: 0, totalRevenue: 0, totalCommission: 0, promoCodes: 0, uniqueCustomers: 0 };
  }
  
  const codes = promoRows.map(r => r.code);
  const placeholders = codes.map(() => '?').join(',');
  
  const [salesStats] = await pool.execute(
    `SELECT 
       COUNT(*) as total_sales,
       COALESCE(SUM(p.amount), 0) as total_revenue,
       COUNT(DISTINCT p.user_id) as unique_customers
     FROM payments p
     WHERE p.promo_code IN (${placeholders}) AND p.status = 'completed'`,
    codes
  );
  
  return {
    totalSales: salesStats[0].total_sales,
    totalRevenue: Number(salesStats[0].total_revenue),
    totalCommission: Number(salesStats[0].total_revenue) * COMMISSION_RATE,
    commissionRate: COMMISSION_RATE * 100,
    promoCodes: codes.length,
    uniqueCustomers: salesStats[0].unique_customers
  };
}

export async function getSalesCustomers(salesPersonId) {
  const [promoRows] = await pool.execute(
    `SELECT code FROM promo_codes WHERE sales_person_id = ?`,
    [salesPersonId]
  );
  
  if (promoRows.length === 0) return [];
  
  const codes = promoRows.map(r => r.code);
  const placeholders = codes.map(() => '?').join(',');
  
  const [rows] = await pool.execute(
    `SELECT p.payment_id, p.amount, p.currency, p.promo_code, p.status, p.created_at,
            CONCAT(u.first_name, ' ', u.last_name) as customer_name, u.email as customer_email
     FROM payments p
     JOIN users u ON p.user_id = u.user_id
     WHERE p.promo_code IN (${placeholders}) AND p.status = 'completed'
     ORDER BY p.created_at DESC`,
    codes
  );
  return rows;
}

// ═══════════════════════════════════════════════════════════════════════════
// 🔧 DATABASE UTILITIES
// ═══════════════════════════════════════════════════════════════════════════

export async function closeDatabase() {
  await pool.end();
  console.log('Database connection pool closed');
}

// NOTE: Graceful shutdown is handled in server.js after the server is fully started
