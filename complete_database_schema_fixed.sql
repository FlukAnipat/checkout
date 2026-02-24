-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 SHWE FLASH CHECKOUT DATABASE - COMPLETE SCHEMA (FIXED)
-- ระบบชำระเงิน + Promo Codes + Salesperson Tracking
-- ═══════════════════════════════════════════════════════════════════════════

-- ใช้ฐานข้อมูล railway (Railway MySQL default database)
USE railway;

-- ═══════════════════════════════════════════════════════════════════════════
-- 👤 USERS TABLE - ข้อมูลผู้ใช้
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE `users` (
  `user_id` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `country_code` varchar(10) NOT NULL DEFAULT '+95',
  `role` enum('user','sales','admin') NOT NULL DEFAULT 'user',  -- บทบาท
  `referral_code` varchar(20) DEFAULT NULL,
  `referred_by` varchar(100) DEFAULT NULL,
  `is_paid` tinyint(1) NOT NULL DEFAULT 0,
  `promo_code_used` varchar(50) DEFAULT NULL,
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
-- 📚 VOCABULARY TABLE - คำศัพท์ HSK
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
-- 🎯 USER LEARNING DATA
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
-- 📝 SAMPLE DATA - ข้อมูลตัวอย่าง (FIXED COLUMN COUNT)
-- ═══════════════════════════════════════════════════════════════════════════

-- 👤 Sample Users (เซล + ลูกค้า) - ตรวจสอบจำนวนคอลัมน์ให้ตรงกัน
-- password: admin123, password123
INSERT INTO `users` (`user_id`,`email`,`password`,`first_name`,`last_name`,`phone`,`country_code`,`role`,`referral_code`,`referred_by`,`is_paid`,`promo_code_used`,`paid_at`,`created_at`,`updated_at`) VALUES 
('admin-user-001','admin@gmail.com','$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe','Admin','User','0912345678','+95','admin','FLASH2024',NULL,1,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('tom-user-001','tom@shweflash.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Tom','Sales','0987654321','+95','sales','TOM2026',NULL,1,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('mary-user-001','mary@shweflash.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Mary','Sales','0911122233','+95','sales','MARY2026',NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('john-user-001','john@example.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','John','Customer','0998877665','+95','user',NULL,NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00'),
('jane-user-001','jane@example.com','$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy','Jane','Customer','0955544433','+95','user',NULL,NULL,0,NULL,NULL,'2026-02-24 18:54:24','2026-02-25 04:00:00');

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

-- 📚 Sample Vocabulary (HSK 1)
INSERT INTO `vocabulary` VALUES 
('hsk1_001',1,'爱','ài','รัก','love','ချစ်သည်','我爱你。','audio/hsk1/爱.mp3',1),
('hsk1_002',1,'八','bā','แปด','eight','ရှစ်','我有八个苹果。','audio/hsk1/八.mp3',2),
('hsk1_003',1,'爸爸','bà ba','พ่อ','father','ဖခင်','这是我爸爸。','audio/hsk1/爸爸.mp3',3),
('hsk1_004',1,'杯子','bēi zi','แก้ว','cup/glass','ဖန်ခွက်','请给我一个杯子。','audio/hsk1/杯子.mp3',4),
('hsk1_005',1,'北京','běi jīng','ปักกิ่ง','Beijing','ပေကျင်း','我去北京。','audio/hsk1/北京.mp3',5);

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔍 VERIFICATION QUERIES - ตรวจสอบข้อมูล
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

-- ═══════════════════════════════════════════════════════════════════════════
-- 📋 SYSTEM SUMMARY
-- ═══════════════════════════════════════════════════════════════════════════
SELECT 'DATABASE SETUP COMPLETE' as status,
       NOW() as setup_time,
       (SELECT COUNT(*) FROM users) as total_users,
       (SELECT COUNT(*) FROM promo_codes) as total_promo_codes,
       (SELECT COUNT(*) FROM payments) as total_payments,
       (SELECT COUNT(*) FROM vocabulary) as total_vocabulary;
