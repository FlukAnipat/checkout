-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 SHWE FLASH APP DATABASE - COMPLETE SCHEMA
-- ระบบแอปหลัก + Checkout System + Salesperson Tracking
-- ═══════════════════════════════════════════════════════════════════════════

-- ใช้ฐานข้อมูล railway (Railway MySQL default database)
USE railway;

-- ═══════════════════════════════════════════════════════════════════════════
-- 👤 USERS TABLE - ข้อมูลผู้ใช้แอปหลัก
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `users` (
  `user_id` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `country_code` varchar(10) NOT NULL DEFAULT '+95',
  `role` enum('user','sales','admin') NOT NULL DEFAULT 'user',  -- บทบาท: user, sales, admin
  `referral_code` varchar(20) DEFAULT NULL,           -- referral code ของตัวเอง (ถ้ามี)
  `referred_by` varchar(100) DEFAULT NULL,           -- ใครแนะนำมา (ถ้ามี)
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `promo_code_used` varchar(50) DEFAULT NULL,        -- promo code ที่ใช้
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_referral_code` (`referral_code`),
  KEY `idx_referred_by` (`referred_by`),
  KEY `idx_is_paid` (`is_paid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎫 PROMO CODES TABLE - โค้ดส่วนลด + เชื่อมโยงเซล
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `promo_codes` (
  `code` varchar(50) NOT NULL,
  `discount_percent` decimal(5,2) NOT NULL DEFAULT 10.00,
  `max_uses` int DEFAULT 100,
  `used_count` int NOT NULL DEFAULT 0,
  `sales_person_id` varchar(100) DEFAULT NULL,       -- ใครเป็นเจ้าของ promo code
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `idx_sales_person_id` (`sales_person_id`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 💳 PAYMENTS TABLE - ประวัติการชำระเงิน
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `payments` (
  `payment_id` varchar(100) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` varchar(10) NOT NULL DEFAULT 'MMK',
  `payment_method` varchar(50) NOT NULL,
  `promo_code` varchar(50) DEFAULT NULL,
  `referral_id` varchar(100) DEFAULT NULL,        -- สำหรับ tracking ค่าคอม (ถ้ามี)
  `status` enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `order_id` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 PROMO CODE USAGE TRACKING
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `promo_code_usage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `promo_code` varchar(50) NOT NULL,
  `user_id` varchar(100) NOT NULL,
  `discount_amount` decimal(12,2) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_user` (`promo_code`,`user_id`),
  KEY `idx_promo_code` (`promo_code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 📚 VOCABULARY TABLE - คำศัพท์ HSK (แอปหลัก)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `vocabulary` (
  `vocab_id` varchar(50) NOT NULL,
  `hsk_level` tinyint NOT NULL,
  `hanzi` varchar(100) NOT NULL,
  `pinyin` varchar(200) NOT NULL,
  `meaning` varchar(500) DEFAULT NULL,
  `meaning_en` varchar(500) DEFAULT NULL,
  `meaning_my` varchar(500) DEFAULT NULL,
  `example` text,
  `audio_asset` varchar(500) DEFAULT NULL,
  `sort_order` int NOT NULL,
  PRIMARY KEY (`vocab_id`),
  KEY `idx_hsk_level` (`hsk_level`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 USER LEARNING DATA (แอปหลัก)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `daily_goals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `goal_date` date NOT NULL,
  `target_cards` int NOT NULL DEFAULT 10,
  `completed_cards` int NOT NULL DEFAULT 0,
  `is_completed` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_goal_date` (`user_id`,`goal_date`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `learning_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `session_date` date NOT NULL,
  `learned_cards` int NOT NULL DEFAULT 0,
  `minutes_spent` int NOT NULL DEFAULT 0,
  `hsk_level` tinyint DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_session_date` (`user_id`,`session_date`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚙️ USER SETTINGS (แอปหลัก)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_settings` (
  `user_id` varchar(100) NOT NULL,
  `app_language` enum('english','burmese','englishAndBurmese') NOT NULL DEFAULT 'english',
  `current_hsk_level` tinyint NOT NULL DEFAULT 1,
  `daily_goal_target` int NOT NULL DEFAULT 10,
  `is_shuffle_mode` tinyint(1) NOT NULL DEFAULT 0,
  `notification_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `reminder_time` time NOT NULL DEFAULT '09:00:00',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 📝 USER WORD STATUS (แอปหลัก)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_word_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `vocab_id` varchar(50) NOT NULL,
  `status` enum('learning','mastered','skipped') NOT NULL DEFAULT 'learning',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word_status` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 🏆 USER ACHIEVEMENTS (แอปหลัก)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_achievements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `achievement_key` varchar(100) NOT NULL,
  `unlocked_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_achievement` (`user_id`,`achievement_key`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔖 USER SAVED WORDS (แอปหลัก)
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_saved_words` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) NOT NULL,
  `vocab_id` varchar(50) NOT NULL,
  `saved_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_vocab_id` (`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════
-- 📝 SAMPLE DATA - ข้อมูลตัวอย่าง (แอปหลัก + Checkout)
-- ═══════════════════════════════════════════════════════════════════════════

-- 👤 Sample Users (admin + เซล + ลูกค้า + ผู้ใช้ทั่วไป)
-- password: admin123 → $2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe
-- password: password123 → $2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy
INSERT INTO `users` (`user_id`,`email`,`password`,`first_name`,`last_name`,`phone`,`country_code`,`role`,`referral_code`,`referred_by`,`is_paid`,`promo_code_used`,`paid_at`,`created_at`,`updated_at`) VALUES 
('admin-user-001','admin@gmail.com','$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe','Admin','User','0912345678','+95','admin','FLASH2024',NULL,1,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('tom-user-001','tom@shweflash.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Tom','Sales','0987654321','+95','sales','TOM2026',NULL,1,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('mary-user-001','mary@shweflash.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Mary','Sales','0911122233','+95','sales','MARY2026',NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('john-user-001','john@example.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','John','Customer','0998877665','+95','user',NULL,NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('jane-user-001','jane@example.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Jane','Customer','0955544433','+95','user',NULL,NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('student-001','student@shweflash.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Student','User','0911222334','+95','user',NULL,NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00');

-- 🎫 Sample Promo Codes (เชื่อมโยงกับเซล)
INSERT INTO `promo_codes` VALUES 
('FLASH10',10.00,100,0,'admin-user-001','2026-02-24 21:00:25','2025-12-31 23:59:59'),
('TOM10',15.00,50,0,'tom-user-001','2026-02-24 21:00:25','2025-12-31 23:59:59'),
('TOM20',20.00,30,0,'tom-user-001','2026-02-24 21:00:25','2025-06-30 23:59:59'),
('MARY15',15.00,40,0,'mary-user-001','2026-02-24 21:00:25','2025-12-31 23:59:59'),
('MARY25',25.00,20,0,'mary-user-001','2026-02-24 21:00:25','2025-06-30 23:59:59'),
('EARLY25',25.00,30,0,NULL,'2026-02-24 21:00:25','2025-03-31 23:59:59'),
('LAUNCH2024',15.00,50,0,NULL,'2026-02-24 18:47:11','2025-12-31 23:59:59'),
('SAVE5',5.00,500,0,NULL,'2026-02-24 21:00:25','2025-12-31 23:59:59');

-- 💳 Sample Payments
INSERT INTO `payments` VALUES 
('pay-001','john-user-001',15300.00,'MMK','card','TOM10',NULL,'completed','SF-20260225-001','2026-02-25 04:00:00'),
('pay-002','jane-user-001',14400.00,'MMK','kbzpay','MARY15',NULL,'completed','SF-20260225-002','2026-02-25 04:00:00'),
('pay-003','admin-user-001',18000.00,'MMK','card',NULL,NULL,'completed','SF-20260225-003','2026-02-25 04:00:00');

-- 📊 Sample Promo Code Usage
INSERT INTO `promo_code_usage` VALUES 
(1,'TOM10','john-user-001',2700.00,'SF-20260225-001','2026-02-25 04:00:00'),
(2,'MARY15','jane-user-001',3600.00,'SF-20260225-002','2026-02-25 04:00:00');

-- 📚 Sample Vocabulary (HSK 1-3)
INSERT INTO `vocabulary` VALUES 
('hsk1_001',1,'爱','ài','รัก','love','ချစ်သည်','我爱你。','audio/hsk1/爱.mp3',1),
('hsk1_002',1,'八','bā','แปด','eight','ရှစ်','我有八个苹果。','audio/hsk1/八.mp3',2),
('hsk1_003',1,'爸爸','bà ba','พ่อ','father','ဖခင်','这是我爸爸。','audio/hsk1/爸爸.mp3',3),
('hsk1_004',1,'杯子','bēi zi','แก้ว','cup/glass','ဖန်ခွက်','请给我一个杯子。','audio/hsk1/杯子.mp3',4),
('hsk1_005',1,'北京','běi jīng','ปักกิ่ง','Beijing','ပေကျင်း','我去北京。','audio/hsk1/北京.mp3',5),
('hsk2_001',2,'因为','yīn wèi','เพราะว่า','because','ဘာကြောင့်လဲ','因为下雨，所以我不出门。','audio/hsk2/因为.mp3',6),
('hsk2_002',2,'或者','huò zhě','หรือ','or','သို့မဟုတ်','你可以喝茶或者咖啡。','audio/hsk2/或者.mp3',7),
('hsk3_001',3,'环境','huán jìng','สภาพแวดล้อม','environment','ပတ်ဝန်းကျင်','我们要保护环境。','audio/hsk3/环境.mp3',8);

-- 🎯 Sample Learning Data
INSERT INTO `daily_goals` VALUES 
(1,'student-001','2026-02-24',10,8,0,'2026-02-24 12:38:46','2026-02-24 12:38:48'),
(2,'student-001','2026-02-25',10,5,0,'2026-02-25 08:00:00','2026-02-25 08:30:00');

INSERT INTO `learning_sessions` VALUES 
(1,'student-001','2026-02-24',8,25,1,'2026-02-24 12:38:46','2026-02-24 13:03:46'),
(2,'student-001','2026-02-25',5,15,1,'2026-02-25 08:00:00','2026-02-25 08:15:00');

-- ⚙️ Sample User Settings
INSERT INTO `user_settings` VALUES 
('student-001','english',1,10,0,1,'09:00:00','2026-02-24 12:38:46'),
('john-user-001','burmese',1,10,1,0,'19:00:00','2026-02-24 18:54:24');

-- 📝 Sample Word Status
INSERT INTO `user_word_status` VALUES 
(1,'student-001','hsk1_001','mastered','2026-02-24 12:45:00'),
(2,'student-001','hsk1_002','learning','2026-02-24 12:45:00'),
(3,'student-001','hsk1_003','learning','2026-02-24 12:45:00');

-- 🏆 Sample Achievements
INSERT INTO `user_achievements` VALUES 
(1,'student-001','first_word_learned','2026-02-24 12:45:00'),
(2,'student-001','daily_goal_completed','2026-02-24 23:59:59');

-- 🔖 Sample Saved Words
INSERT INTO `user_saved_words` VALUES 
(1,'student-001','hsk1_001','2026-02-24 12:45:00'),
(2,'student-001','hsk2_001','2026-02-25 08:15:00');

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔍 VERIFICATION QUERIES - ตรวจสอบข้อมูลทั้งระบบ
-- ═══════════════════════════════════════════════════════════════════════════

-- ดูข้อมูลเซลและ promo codes ของพวกเขา
SELECT 
  u.user_id,
  CONCAT(u.first_name, ' ', u.last_name) as salesperson_name,
  u.email,
  pc.code,
  pc.discount_percent,
  pc.used_count,
  pc.max_uses
FROM `users` u
JOIN `promo_codes` pc ON u.user_id = pc.sales_person_id
WHERE u.user_id IN ('admin-user-001', 'tom-user-001', 'mary-user-001')
ORDER BY u.first_name, pc.discount_percent DESC;

-- ดูประวัติการชำระเงินและ promo codes ที่ใช้
SELECT 
  p.payment_id,
  p.amount,
  p.currency,
  p.payment_method,
  p.promo_code,
  p.status,
  CONCAT(u.first_name, ' ', u.last_name) as customer_name,
  u.email,
  p.created_at
FROM `payments` p
JOIN `users` u ON p.user_id = u.user_id
ORDER BY p.created_at DESC;

-- ดูสถิติการขายของเซลแต่ละคน
SELECT 
  CONCAT(u.first_name, ' ', u.last_name) as salesperson_name,
  COUNT(p.payment_id) as total_sales,
  SUM(p.amount) as total_revenue,
  AVG(p.amount) as avg_sale_amount,
  COUNT(DISTINCT p.user_id) as unique_customers
FROM `users` u
LEFT JOIN `promo_codes` pc ON u.user_id = pc.sales_person_id
LEFT JOIN `payments` p ON pc.code = p.promo_code
WHERE u.user_id IN ('admin-user-001', 'tom-user-001', 'mary-user-001')
GROUP BY u.user_id, u.first_name, u.last_name
ORDER BY total_revenue DESC;

-- ดูข้อมูลการเรียนของผู้ใช้
SELECT 
  u.user_id,
  CONCAT(u.first_name, ' ', u.last_name) as student_name,
  u.email,
  ls.session_date,
  ls.learned_cards,
  ls.minutes_spent,
  ls.hsk_level,
  dg.target_cards,
  dg.completed_cards,
  dg.is_completed
FROM `users` u
LEFT JOIN `learning_sessions` ls ON u.user_id = ls.user_id
LEFT JOIN `daily_goals` dg ON u.user_id = dg.user_id AND ls.session_date = dg.goal_date
WHERE u.user_id = 'student-001'
ORDER BY ls.session_date DESC;

-- ดูคำศัพท์ที่ผู้ใช้เรียน
SELECT 
  uws.user_id,
  uws.status,
  v.vocab_id,
  v.hsk_level,
  v.hanzi,
  v.pinyin,
  v.meaning,
  uws.updated_at
FROM `user_word_status` uws
JOIN `vocabulary` v ON uws.vocab_id = v.vocab_id
WHERE uws.user_id = 'student-001'
ORDER BY v.hsk_level, v.sort_order;

-- ═══════════════════════════════════════════════════════════════════════════
-- 📋 SYSTEM SUMMARY - สรุประบบทั้งหมด
-- ═══════════════════════════════════════════════════════════════════════════
SELECT 'SHWE FLASH APP DATABASE COMPLETE' as status,
       NOW() as setup_time,
       (SELECT COUNT(*) FROM users) as total_users,
       (SELECT COUNT(*) FROM promo_codes) as total_promo_codes,
       (SELECT COUNT(*) FROM payments) as total_payments,
       (SELECT COUNT(*) FROM vocabulary) as total_vocabulary,
       (SELECT COUNT(*) FROM daily_goals) as total_daily_goals,
       (SELECT COUNT(*) FROM learning_sessions) as total_learning_sessions,
       (SELECT COUNT(*) FROM user_word_status) as total_word_status,
       (SELECT COUNT(*) FROM user_achievements) as total_achievements,
       (SELECT COUNT(*) FROM user_saved_words) as total_saved_words;
