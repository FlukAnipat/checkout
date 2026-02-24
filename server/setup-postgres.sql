-- PostgreSQL schema + sample data for Supabase
-- Full schema for HSK Flash Card application

-- --------------------------------------------------------
-- Table structure for table `daily_goals`
-- --------------------------------------------------------
CREATE TABLE daily_goals (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  goal_date DATE NOT NULL,
  target_cards INTEGER NOT NULL DEFAULT 10,
  completed_cards INTEGER NOT NULL DEFAULT 0,
  is_completed BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, goal_date)
);

-- Create indexes
CREATE INDEX idx_daily_goals_user_id ON daily_goals(user_id);
CREATE INDEX idx_daily_goals_goal_date ON daily_goals(goal_date);

-- --------------------------------------------------------
-- Table structure for table `learning_sessions`
-- --------------------------------------------------------
CREATE TABLE learning_sessions (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  session_date DATE NOT NULL,
  learned_cards INTEGER NOT NULL DEFAULT 0,
  minutes_spent INTEGER NOT NULL DEFAULT 0,
  hsk_level INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, session_date)
);

-- Create indexes
CREATE INDEX idx_learning_sessions_user_id ON learning_sessions(user_id);
CREATE INDEX idx_learning_sessions_session_date ON learning_sessions(session_date);

-- --------------------------------------------------------
-- Table structure for table `payments`
-- --------------------------------------------------------
CREATE TABLE payments (
  payment_id VARCHAR(100) PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'MMK',
  payment_method VARCHAR(50) NOT NULL,
  promo_code VARCHAR(50),
  payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
  transaction_id VARCHAR(100),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(payment_status);

-- --------------------------------------------------------
-- Table structure for table `promo_codes`
-- --------------------------------------------------------
CREATE TABLE promo_codes (
  id SERIAL PRIMARY KEY,
  code VARCHAR(50) NOT NULL UNIQUE,
  discount_percentage DECIMAL(5,2) NOT NULL,
  max_uses INTEGER NOT NULL DEFAULT 100,
  used_count INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- Table structure for table `user_achievements`
-- --------------------------------------------------------
CREATE TABLE user_achievements (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  achievement_key VARCHAR(50) NOT NULL,
  unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, achievement_key)
);

-- Create indexes
CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_key ON user_achievements(achievement_key);

-- --------------------------------------------------------
-- Table structure for table `user_settings`
-- --------------------------------------------------------
CREATE TABLE user_settings (
  user_id VARCHAR(100) PRIMARY KEY,
  app_language VARCHAR(10) NOT NULL DEFAULT 'en',
  current_hsk_level INTEGER NOT NULL DEFAULT 1,
  daily_goal_target INTEGER NOT NULL DEFAULT 10,
  is_shuffle_mode BOOLEAN NOT NULL DEFAULT FALSE,
  notification_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  reminder_time VARCHAR(10) DEFAULT '09:00',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------
-- Table structure for table `user_word_status`
-- --------------------------------------------------------
CREATE TABLE user_word_status (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  vocab_id VARCHAR(50) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'learning' CHECK (status IN ('learning', 'mastered', 'skipped')),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, vocab_id)
);

-- Create indexes
CREATE INDEX idx_user_word_status_user_id ON user_word_status(user_id);
CREATE INDEX idx_user_word_status_status ON user_word_status(status);

-- --------------------------------------------------------
-- Table structure for table `users`
-- --------------------------------------------------------
CREATE TABLE users (
  user_id VARCHAR(100) PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  country_code VARCHAR(10) NOT NULL DEFAULT '+95',
  is_paid BOOLEAN NOT NULL DEFAULT FALSE,
  promo_code_used VARCHAR(50),
  paid_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_paid ON users(is_paid);

-- --------------------------------------------------------
-- Table structure for table `vocabulary`
-- --------------------------------------------------------
CREATE TABLE vocabulary (
  vocab_id VARCHAR(50) PRIMARY KEY,
  hsk_level INTEGER NOT NULL,
  chinese VARCHAR(50) NOT NULL,
  pinyin VARCHAR(100) NOT NULL,
  thai VARCHAR(100) NOT NULL,
  english VARCHAR(200) NOT NULL,
  myanmar VARCHAR(200) NOT NULL,
  example_sentence TEXT NOT NULL,
  audio_path VARCHAR(255),
  sort_order INTEGER NOT NULL
);

-- Create indexes
CREATE INDEX idx_vocabulary_hsk_level ON vocabulary(hsk_level);
CREATE INDEX idx_vocabulary_sort_order ON vocabulary(sort_order);

-- --------------------------------------------------------
-- Table structure for table `user_saved_words`
-- --------------------------------------------------------
CREATE TABLE user_saved_words (
  id SERIAL PRIMARY KEY,
  user_id VARCHAR(100) NOT NULL,
  vocab_id VARCHAR(50) NOT NULL,
  saved_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, vocab_id)
);

-- Create indexes
CREATE INDEX idx_user_saved_words_user_id ON user_saved_words(user_id);

-- --------------------------------------------------------
-- Insert sample data
-- --------------------------------------------------------

-- Insert promo codes
INSERT INTO promo_codes (code, discount_percentage, max_uses, is_active) VALUES
('WELCOME10', 10.00, 100, TRUE),
('FLASH20', 20.00, 50, TRUE),
('STUDENT30', 30.00, 25, TRUE);

-- Insert demo user
INSERT INTO users (user_id, email, password, first_name, last_name, phone, country_code) VALUES
('demo_user_001', 'demo@example.com', '$2a$10$rQO8Z8Z8Z8Z8Z8Z8Z8Z8ZO7Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8Z8', 'Demo', 'User', '+95123456789', '+95');

-- Insert HSK1 vocabulary (20 words)
INSERT INTO vocabulary (vocab_id, hsk_level, chinese, pinyin, thai, english, myanmar, example_sentence, audio_path, sort_order) VALUES
('hsk1_001', 1, '一', 'yī', 'หนึ่ง', 'one', 'တစ်', '我有一个弟弟。', 'audio/hsk1/一.mp3', 1),
('hsk1_002', 1, '二', 'èr', 'สอง', 'two', 'နှစ်', '我有两个哥哥。', 'audio/hsk1/二.mp3', 2),
('hsk1_003', 1, '三', 'sān', 'สาม', 'three', 'သုံး', '我有三个妹妹。', 'audio/hsk1/三.mp3', 3),
('hsk1_004', 1, '四', 'sì', 'สี่', 'four', 'လေး', '这是第四个。', 'audio/hsk1/四.mp3', 4),
('hsk1_005', 1, '五', 'wǔ', 'ห้า', 'five', 'ငါး', '我喜欢五。', 'audio/hsk1/五.mp3', 5),
('hsk1_006', 1, '六', 'liù', 'หก', 'six', 'ခြောက်', '今天是星期六。', 'audio/hsk1/六.mp3', 6),
('hsk1_007', 1, '七', 'qī', 'เจ็ด', 'seven', 'ခုနစ်', '我有七个朋友。', 'audio/hsk1/七.mp3', 7),
('hsk1_008', 1, '八', 'bā', 'แปด', 'eight', 'ရှစ်', '现在是八点。', 'audio/hsk1/八.mp3', 8),
('hsk1_009', 1, '九', 'jiǔ', 'เก้า', 'nine', 'ကိုး', '我喜欢九。', 'audio/hsk1/九.mp3', 9),
('hsk1_010', 1, '十', 'shí', 'สิบ', 'ten', 'ဆယ်', '我有十个苹果。', 'audio/hsk1/十.mp3', 10),
('hsk1_011', 1, '人', 'rén', 'คน', 'person/people', 'လူ', '这是一个人。', 'audio/hsk1/人.mp3', 11),
('hsk1_012', 1, '我', 'wǒ', 'ฉัน/ผม', 'I/me', 'ကျွန်ုပ်', '我是学生。', 'audio/hsk1/我.mp3', 12),
('hsk1_013', 1, '你', 'nǐ', 'คุณ', 'you', 'သင်', '你好！', 'audio/hsk1/你.mp3', 13),
('hsk1_014', 1, '他', 'tā', 'เขา (ชาย)', 'he/him', 'သူ', '他是我的朋友。', 'audio/hsk1/他.mp3', 14),
('hsk1_015', 1, '她', 'tā', 'เขา (หญิง)', 'she/her', 'သူမ', '她是我的妹妹。', 'audio/hsk1/她.mp3', 15),
('hsk1_016', 1, '好', 'hǎo', 'ดี', 'good/well', 'ကောင်း', '你好吗？', 'audio/hsk1/好.mp3', 16),
('hsk1_017', 1, '不', 'bù', 'ไม่', 'no/not', 'မဟုတ်', '我不是老师。', 'audio/hsk1/不.mp3', 17),
('hsk1_018', 1, '的', 'de', 'ของ', 'possessive particle', 'ရဲ့', '这是我的书。', 'audio/hsk1/的.mp3', 18),
('hsk1_019', 1, '是', 'shì', 'เป็น/คือ', 'to be/is/am/are', 'ဖြစ်သည်', '我是学生。', 'audio/hsk1/是.mp3', 19),
('hsk1_020', 1, '在', 'zài', 'อยู่ที่', 'at/in/on', 'တွင်', '我在家。', 'audio/hsk1/在.mp3', 20);

-- Insert demo user settings
INSERT INTO user_settings (user_id, app_language, current_hsk_level, daily_goal_target) VALUES
('demo_user_001', 'en', 1, 10);

COMMIT;
