-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║  SHWE FLASH - COMPLETE DATABASE SCHEMA                                      ║
-- ║  Generated: 2026-02-25                                                      ║
-- ║                                                                             ║
-- ║  ระบบ:                                                                      ║
-- ║    1. Flutter App  → เรียนภาษาจีน HSK 1-6, sync ข้อมูลผ่าน API             ║
-- ║    2. Checkout Web → ชำระเงิน Premium, ใช้ promo code                       ║
-- ║    3. Admin Dashboard → จัดการ users, payments, promo codes                 ║
-- ║    4. Sales Dashboard → ดูยอดขาย + ค่าคอม 20%                              ║
-- ║                                                                             ║
-- ║  Roles:                                                                     ║
-- ║    admin → /admin    (Admin Dashboard)                                      ║
-- ║    sales → /sales    (Sales Dashboard)                                      ║
-- ║    user  → /payment  (Payment Page)                                         ║
-- ║                                                                             ║
-- ║  Test Accounts (password: admin123 ทุกคน):                                  ║
-- ║    admin@gmail.com  → admin                                                 ║
-- ║    sell@gmail.com   → sales                                                 ║
-- ║    test@gmail.com   → user                                                  ║
-- ║    test1@gmail.com  → user                                                  ║
-- ║                                                                             ║
-- ║  Tables: 11 ตาราง                                                          ║
-- ║    users, payments, promo_codes, promo_code_usage,                          ║
-- ║    vocabulary, daily_goals, learning_sessions,                              ║
-- ║    user_settings, user_word_status, user_achievements, user_saved_words     ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝


SET FOREIGN_KEY_CHECKS = 0;

-- ลบตารางเก่าที่ไม่ใช้
DROP TABLE IF EXISTS `referral_codes`;
DROP TABLE IF EXISTS `referrals`;

-- ลบตารางทั้งหมด สร้างใหม่
DROP TABLE IF EXISTS `promo_code_usage`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `promo_codes`;
DROP TABLE IF EXISTS `daily_goals`;
DROP TABLE IF EXISTS `learning_sessions`;
DROP TABLE IF EXISTS `user_achievements`;
DROP TABLE IF EXISTS `user_saved_words`;
DROP TABLE IF EXISTS `user_settings`;
DROP TABLE IF EXISTS `user_word_status`;
DROP TABLE IF EXISTS `vocabulary`;
DROP TABLE IF EXISTS `users`;

SET FOREIGN_KEY_CHECKS = 1;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. users
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: ทุกระบบ
--   Flutter App  → register/login, profile, sync
--   Checkout Web → login, payment
--   Admin        → ดู users ทั้งหมด
--   Sales        → ดูลูกค้าที่ซื้อผ่าน promo
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `users` (
  `user_id`         VARCHAR(100)  NOT NULL,
  `email`           VARCHAR(255)  NOT NULL,
  `password`        VARCHAR(255)  NOT NULL,
  `first_name`      VARCHAR(100)  NOT NULL,
  `last_name`       VARCHAR(100)  NOT NULL,
  `phone`           VARCHAR(20)   NOT NULL DEFAULT '',
  `country_code`    VARCHAR(10)   NOT NULL DEFAULT '+95',
  `role`            ENUM('user','sales','admin') NOT NULL DEFAULT 'user',
  `referral_code`   VARCHAR(20)   DEFAULT NULL,
  `referred_by`     VARCHAR(100)  DEFAULT NULL,
  `is_paid`         TINYINT(1)    NOT NULL DEFAULT 0,
  `promo_code_used` VARCHAR(50)   DEFAULT NULL,
  `paid_at`         DATETIME      DEFAULT NULL,
  `created_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_is_paid` (`is_paid`),
  KEY `idx_referral_code` (`referral_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. promo_codes
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Checkout (validate-promo, checkout), Admin (CRUD), Sales (ดูของตัวเอง)
-- sales_person_id → เชื่อมกับ users.user_id ของเซล
-- เมื่อลูกค้าใส่ code → ระบบรู้ว่าเซลคนไหนขาย → คำนวณ commission 20%
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `promo_codes` (
  `code`             VARCHAR(50)   NOT NULL,
  `discount_percent` DECIMAL(5,2)  NOT NULL DEFAULT 10.00,
  `max_uses`         INT           DEFAULT 100,
  `used_count`       INT           NOT NULL DEFAULT 0,
  `sales_person_id`  VARCHAR(100)  DEFAULT NULL,
  `created_at`       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at`       DATETIME      DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `idx_sales_person` (`sales_person_id`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. payments
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Checkout (createPayment), Admin (ดูทั้งหมด), Sales (คำนวณยอดขาย)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `payments` (
  `payment_id`     VARCHAR(100)  NOT NULL,
  `user_id`        VARCHAR(100)  NOT NULL,
  `amount`         DECIMAL(12,2) NOT NULL,
  `currency`       VARCHAR(10)   NOT NULL DEFAULT 'MMK',
  `payment_method` VARCHAR(50)   NOT NULL,
  `promo_code`     VARCHAR(50)   DEFAULT NULL,
  `referral_id`    VARCHAR(100)  DEFAULT NULL,
  `status`         ENUM('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `created_at`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_promo_code` (`promo_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. promo_code_usage
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Checkout (checkPromoCodeUsage, recordPromoCodeUsage)
-- ป้องกัน user ใช้ promo code ซ้ำ
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `promo_code_usage` (
  `id`              INT           NOT NULL AUTO_INCREMENT,
  `promo_code`      VARCHAR(50)   NOT NULL,
  `user_id`         VARCHAR(100)  NOT NULL,
  `discount_amount` DECIMAL(12,2) DEFAULT NULL,
  `order_id`        VARCHAR(100)  DEFAULT NULL,
  `created_at`      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_user` (`promo_code`,`user_id`),
  KEY `idx_promo_code` (`promo_code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 5. vocabulary
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (flashcard, quiz), API /api/vocab/hsk/:level
-- ข้อมูล import จาก Flutter App หรือ shwe_flash_db.sql
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `vocabulary` (
  `vocab_id`    VARCHAR(50)  NOT NULL,
  `hsk_level`   TINYINT      NOT NULL,
  `hanzi`       VARCHAR(100) NOT NULL,
  `pinyin`      VARCHAR(200) NOT NULL,
  `meaning`     VARCHAR(500) DEFAULT '',
  `meaning_en`  VARCHAR(500) DEFAULT '',
  `meaning_my`  VARCHAR(500) DEFAULT '',
  `example`     TEXT,
  `audio_asset` VARCHAR(500) DEFAULT NULL,
  `sort_order`  INT          NOT NULL DEFAULT 0,
  PRIMARY KEY (`vocab_id`),
  KEY `idx_hsk_level` (`hsk_level`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 6. daily_goals
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (syncDailyGoal, getUserDailyGoals, getUserStats)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `daily_goals` (
  `id`              INT          NOT NULL AUTO_INCREMENT,
  `user_id`         VARCHAR(100) NOT NULL,
  `goal_date`       DATE         NOT NULL,
  `target_cards`    INT          NOT NULL DEFAULT 10,
  `completed_cards` INT          NOT NULL DEFAULT 0,
  `is_completed`    TINYINT(1)   NOT NULL DEFAULT 0,
  `created_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_goal_date` (`user_id`,`goal_date`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_goal_date` (`goal_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 7. learning_sessions
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (syncLearningSession, getUserLearningSessions)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `learning_sessions` (
  `id`            INT          NOT NULL AUTO_INCREMENT,
  `user_id`       VARCHAR(100) NOT NULL,
  `session_date`  DATE         NOT NULL,
  `learned_cards` INT          NOT NULL DEFAULT 0,
  `minutes_spent` INT          NOT NULL DEFAULT 0,
  `hsk_level`     TINYINT      DEFAULT NULL,
  `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_session_date` (`user_id`,`session_date`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_date` (`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 8. user_settings
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (getUserSettings, syncUserSettings)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_settings` (
  `user_id`              VARCHAR(100) NOT NULL,
  `app_language`         VARCHAR(20)  NOT NULL DEFAULT 'english',
  `current_hsk_level`    TINYINT      NOT NULL DEFAULT 1,
  `daily_goal_target`    INT          NOT NULL DEFAULT 10,
  `is_shuffle_mode`      TINYINT(1)   NOT NULL DEFAULT 0,
  `notification_enabled` TINYINT(1)   NOT NULL DEFAULT 1,
  `reminder_time`        TIME         NOT NULL DEFAULT '09:00:00',
  `updated_at`           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 9. user_word_status
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (syncUserWordStatus, getUserWordStatuses, getUserProfile)
-- status: learning, mastered, skipped
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_word_status` (
  `id`         INT          NOT NULL AUTO_INCREMENT,
  `user_id`    VARCHAR(100) NOT NULL,
  `vocab_id`   VARCHAR(50)  NOT NULL,
  `status`     ENUM('learning','mastered','skipped') NOT NULL DEFAULT 'learning',
  `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word_status` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 10. user_achievements
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (getUserAchievements, unlockAchievement)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_achievements` (
  `id`              INT          NOT NULL AUTO_INCREMENT,
  `user_id`         VARCHAR(100) NOT NULL,
  `achievement_key` VARCHAR(100) NOT NULL,
  `unlocked_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_achievement` (`user_id`,`achievement_key`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
-- 11. user_saved_words
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Flutter App (syncUserSavedWord, removeUserSavedWord, getUserSavedWords)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_saved_words` (
  `id`       INT          NOT NULL AUTO_INCREMENT,
  `user_id`  VARCHAR(100) NOT NULL,
  `vocab_id` VARCHAR(50)  NOT NULL,
  `saved_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_vocab_id` (`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═══════════════════════════════════════════════════════════════════════════════
--  INSERT: USERS
-- ═══════════════════════════════════════════════════════════════════════════════
-- password: admin123 (ทุกคน)
-- bcrypt hash: $2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq

INSERT INTO `users`
  (`user_id`, `email`, `password`, `first_name`, `last_name`, `phone`, `country_code`, `role`, `is_paid`)
VALUES
  ('admin-001', 'admin@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Admin', 'ShweFlash', '0912345678', '+95', 'admin', 0),

  ('sales-001', 'sell@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Sell', 'Person', '0987654321', '+95', 'sales', 0),

  ('user-001', 'test@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Test', 'User', '0998877665', '+95', 'user', 0),

  ('user-002', 'test1@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Test1', 'User', '0955544433', '+95', 'user', 0);


-- ═══════════════════════════════════════════════════════════════════════════════
--  INSERT: PROMO CODES
-- ═══════════════════════════════════════════════════════════════════════════════
-- SELL10, SELL20 → ของเซล (sell@gmail.com)
-- FLASH10, EARLY25 → general (ไม่มีเจ้าของ)

INSERT INTO `promo_codes`
  (`code`, `discount_percent`, `max_uses`, `used_count`, `sales_person_id`, `expires_at`)
VALUES
  ('SELL10',   10.00,  50, 0, 'sales-001', '2027-12-31 23:59:59'),
  ('SELL20',   20.00,  30, 0, 'sales-001', '2027-06-30 23:59:59'),
  ('FLASH10',  10.00, 100, 0, NULL,        '2027-12-31 23:59:59'),
  ('EARLY25',  25.00,  30, 0, NULL,        '2027-03-31 23:59:59');


-- ═══════════════════════════════════════════════════════════════════════════════
--  INSERT: SAMPLE VOCABULARY (HSK 1 ตัวอย่าง 10 คำ)
-- ═══════════════════════════════════════════════════════════════════════════════
-- คำศัพท์เต็มจะ import จาก Flutter App หรือ shwe_flash_db.sql

INSERT INTO `vocabulary`
  (`vocab_id`,`hsk_level`,`hanzi`,`pinyin`,`meaning`,`meaning_en`,`meaning_my`,`example`,`audio_asset`,`sort_order`)
VALUES
  ('hsk1_001',1,'爱','ài','รัก','love','ချစ်သည်','我爱你。','audio/hsk1/爱.mp3',1),
  ('hsk1_002',1,'八','bā','แปด','eight','ရှစ်','我有八个苹果。','audio/hsk1/八.mp3',2),
  ('hsk1_003',1,'爸爸','bà ba','พ่อ','father','ဖခင်','这是我爸爸。','audio/hsk1/爸爸.mp3',3),
  ('hsk1_004',1,'杯子','bēi zi','แก้ว','cup/glass','ဖန်ခွက်','请给我一个杯子。','audio/hsk1/杯子.mp3',4),
  ('hsk1_005',1,'北京','běi jīng','ปักกิ่ง','Beijing','ပေကျင်း','我去北京。','audio/hsk1/北京.mp3',5),
  ('hsk1_006',1,'本','běn','เล่ม','measure word for books','စာအုပ်','这本书很好。','audio/hsk1/本.mp3',6),
  ('hsk1_007',1,'不','bù','ไม่','not/no','မဟုတ်','我不懂。','audio/hsk1/不.mp3',7),
  ('hsk1_008',1,'菜','cài','อาหาร','dish/vegetable','ဟင်းလျာ','这个菜很好吃。','audio/hsk1/菜.mp3',8),
  ('hsk1_009',1,'吃','chī','กิน','to eat','စားသည်','我想吃饭。','audio/hsk1/吃.mp3',9),
  ('hsk1_010',1,'车','chē','รถ','car/vehicle','ကား','这是我的车。','audio/hsk1/车.mp3',10);
