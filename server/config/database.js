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

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'shwe_flash_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  ssl: { rejectUnauthorized: false }
});

// Test connection on startup
(async () => {
  try {
    const conn = await pool.getConnection();
    console.log('✅ Connected to MySQL database');
    conn.release();
  } catch (err) {
    console.error('❌ MySQL connection failed:', err.message);
  }
})();

// ═══════════════════════════════════════════════════════════════════════════
// 👤 USER OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════

export async function getUserByEmail(email) {
  const [rows] = await pool.execute(
    'SELECT * FROM users WHERE email = ?',
    [email.toLowerCase().trim()]
  );
  return rows[0] || null;
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
      phone, country_code, is_paid, promo_code_used, paid_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
      promo_code, status
    ) VALUES (?, ?, ?, ?, ?, ?, ?)
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
// 🔧 DATABASE UTILITIES
// ═══════════════════════════════════════════════════════════════════════════

export async function closeDatabase() {
  await pool.end();
  console.log('Database connection pool closed');
}

// NOTE: Graceful shutdown is handled in server.js after the server is fully started
