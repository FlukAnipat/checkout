-- Full schema + sample data for phpMyAdmin import
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------
-- Table structure for table `daily_goals`
-- --------------------------------------------------------
CREATE TABLE `daily_goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `goal_date` date NOT NULL,
  `target_cards` int(11) NOT NULL DEFAULT 10,
  `completed_cards` int(11) NOT NULL DEFAULT 0,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_goal_date` (`goal_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `learning_sessions`
-- --------------------------------------------------------
CREATE TABLE `learning_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `session_date` date NOT NULL,
  `learned_cards` int(11) NOT NULL DEFAULT 0,
  `minutes_spent` int(11) NOT NULL DEFAULT 0,
  `hsk_level` tinyint(4) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_date` (`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `payments`
-- --------------------------------------------------------
CREATE TABLE `payments` (
  `payment_id` varchar(100) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'MMK',
  `payment_method` varchar(50) NOT NULL,
  `promo_code` varchar(50) DEFAULT NULL,
  `status` enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`payment_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `promo_codes`
-- --------------------------------------------------------
CREATE TABLE `promo_codes` (
  `code` varchar(50) NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT 10.00,
  `max_uses` int(11) DEFAULT 100,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `user_achievements`
-- --------------------------------------------------------
CREATE TABLE `user_achievements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `achievement_key` varchar(100) NOT NULL,
  `unlocked_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_achievement` (`user_id`, `achievement_key`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `user_saved_words`
-- --------------------------------------------------------
CREATE TABLE `user_saved_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `vocab_id` varchar(50) NOT NULL,
  `saved_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`, `vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_vocab_id` (`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `user_settings`
-- --------------------------------------------------------
CREATE TABLE `user_settings` (
  `user_id` varchar(100) NOT NULL,
  `app_language` varchar(20) NOT NULL DEFAULT 'english',
  `current_hsk_level` tinyint(4) NOT NULL DEFAULT 1,
  `daily_goal_target` int(11) NOT NULL DEFAULT 10,
  `is_shuffle_mode` tinyint(1) NOT NULL DEFAULT 0,
  `notification_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `reminder_time` time NOT NULL DEFAULT '09:00:00',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `user_word_status`
-- --------------------------------------------------------
CREATE TABLE `user_word_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `vocab_id` varchar(50) NOT NULL,
  `status` enum('learning','mastered','skipped') NOT NULL DEFAULT 'learning',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word_status` (`user_id`, `vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `users`
-- --------------------------------------------------------
CREATE TABLE `users` (
  `user_id` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `country_code` varchar(10) NOT NULL DEFAULT '+95',
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `promo_code_used` varchar(50) DEFAULT NULL,
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for table `vocabulary`
-- --------------------------------------------------------
CREATE TABLE `vocabulary` (
  `vocab_id` varchar(50) NOT NULL,
  `hsk_level` tinyint(4) NOT NULL,
  `hanzi` varchar(100) NOT NULL,
  `pinyin` varchar(200) NOT NULL,
  `meaning` varchar(500) DEFAULT NULL,
  `meaning_en` varchar(500) DEFAULT NULL,
  `meaning_my` varchar(500) DEFAULT NULL,
  `example` text DEFAULT NULL,
  `audio_asset` varchar(500) DEFAULT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`vocab_id`),
  KEY `idx_hsk_level` (`hsk_level`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Sample data for testing
-- --------------------------------------------------------

-- Insert promo codes
INSERT INTO `promo_codes` (`code`, `discount_percent`, `max_uses`, `used_count`, `created_at`, `expires_at`) VALUES
('EARLYBIRD', 20.00, 30, 0, NOW(), '2025-06-30 23:59:59'),
('LAUNCH2024', 15.00, 50, 0, NOW(), '2025-12-31 23:59:59'),
('STUDENT10', 10.00, 100, 0, NOW(), '2025-12-31 23:59:59');

-- Insert demo user (password: password123)
INSERT INTO `users` (`user_id`, `email`, `password`, `first_name`, `last_name`, `phone`, `country_code`, `is_paid`, `promo_code_used`, `paid_at`, `created_at`, `updated_at`) VALUES
('demo-user-001', 'demo@example.com', '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy', 'Demo', 'User', '123456789', '+66', 0, NULL, NULL, NOW(), NOW());

-- Insert sample HSK 1 vocabulary (first 20 words)
INSERT INTO `vocabulary` (`vocab_id`, `hsk_level`, `hanzi`, `pinyin`, `meaning`, `meaning_en`, `meaning_my`, `example`, `audio_asset`, `sort_order`) VALUES
('hsk1_001', 1, '爱', 'ài', 'รัก', 'love', 'ချစ်သည်', '我爱你。', 'audio/hsk1/爱.mp3', 1),
('hsk1_002', 1, '八', 'bā', 'แปด', 'eight', 'ရှစ်', '我有八个苹果。', 'audio/hsk1/八.mp3', 2),
('hsk1_003', 1, '爸爸', 'bà ba', 'พ่อ', 'father', 'ဖခင်', '这是我爸爸。', 'audio/hsk1/爸爸.mp3', 3),
('hsk1_004', 1, '杯子', 'bēi zi', 'แก้ว', 'cup/glass', 'ဖန်ခွက်', '请给我一个杯子。', 'audio/hsk1/杯子.mp3', 4),
('hsk1_005', 1, '北京', 'běi jīng', 'ปักกิ่ง', 'Beijing', 'ပေကျင်း', '我去北京。', 'audio/hsk1/北京.mp3', 5),
('hsk1_006', 1, '本', 'běn', 'เล่ม (หนังสือ)', 'measure word for books', 'စာအုပ်', '这本书很好。', 'audio/hsk1/本.mp3', 6),
('hsk1_007', 1, '不', 'bù', 'ไม่', 'not/no', 'မဟုတ်', '我不懂。', 'audio/hsk1/不.mp3', 7),
('hsk1_008', 1, '菜', 'cài', 'อาหาร', 'dish/vegetable', 'ဟင်းလျာ', '这个菜很好吃。', 'audio/hsk1/菜.mp3', 8),
('hsk1_009', 1, '吃', 'chī', 'กิน', 'to eat', 'စားသည်', '我想吃饭。', 'audio/hsk1/吃.mp3', 9),
('hsk1_010', 1, '车', 'chē', 'รถ', 'car/vehicle', 'ကား', '这是我的车。', 'audio/hsk1/车.mp3', 10),
('hsk1_011', 1, '出租', 'chū zū', 'แท็กซี่', 'taxi', 'ဓာတ်ဆီ', '坐出租去。', 'audio/hsk1/出租.mp3', 11),
('hsk1_012', 1, '大', 'dà', 'ใหญ่', 'big/large', 'ကြီးသည်', '这个房子很大。', 'audio/hsk1/大.mp3', 12),
('hsk1_013', 1, '的', 'de', 'ของ', 'possessive particle', 'ရဲ့', '这是我的书。', 'audio/hsk1/的.mp3', 13),
('hsk1_014', 1, '点', 'diǎn', 'จุด/นาฬิกา', 'o\'clock/point', 'နာရီ/အချိန်', '现在八点。', 'audio/hsk1/点.mp3', 14),
('hsk1_015', 1, '电脑', 'diàn nǎo', 'คอมพิวเตอร์', 'computer', 'ကွန်ပျူတာ', '我用电脑工作。', 'audio/hsk1/电脑.mp3', 15),
('hsk1_016', 1, '都', 'dōu', 'ทั้งหมด', 'all/both', 'အားလုံး', '我们都来了。', 'audio/hsk1/都.mp3', 16),
('hsk1_017', 1, '读', 'dú', 'อ่าน', 'to read', 'ဖတ်သည်', '我喜欢读书。', 'audio/hsk1/读.mp3', 17),
('hsk1_018', 1, '多', 'duō', 'หลาย/มาก', 'many/much', 'များသည်', '我有很多朋友。', 'audio/hsk1/多.mp3', 18),
('hsk1_019', 1, '二', 'èr', 'สอง', 'two', 'နှစ်', '我有两个哥哥。', 'audio/hsk1/二.mp3', 19),
('hsk1_020', 1, '饭', 'fàn', 'ข้าว', 'meal/rice', 'ထမင်း', '吃饭了吗？', 'audio/hsk1/饭.mp3', 20);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
