-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║  SHWE FLASH - COMPLETE DATABASE (Railway MySQL) v2                      ║
-- ║  Generated: 2026-02-25 FRESH REBUILD                                    ║
-- ║                                                                         ║
-- ║  ระบบ:                                                                  ║
-- ║    1. Flutter App (เรียนภาษาจีน HSK 1-6)                                ║
-- ║    2. Checkout Web (ชำระเงิน Premium)                                   ║
-- ║    3. Admin Dashboard (จัดการระบบ)                                      ║
-- ║    4. Sales Dashboard (ดูยอดขาย + ค่าคอม)                               ║
-- ║                                                                         ║
-- ║  Roles:                                                                 ║
-- ║    admin  → Admin Dashboard (/admin)                                    ║
-- ║    sales  → Sales Dashboard (/sales)                                    ║
-- ║    user   → Payment Page (/payment)                                     ║
-- ║                                                                         ║
-- ║  Test Accounts:                                                         ║
-- ║    admin@gmail.com       / admin123     → Admin                         ║
-- ║    tom@shweflash.com     / password123  → Sales (Tom)                   ║
-- ║    mary@shweflash.com    / password123  → Sales (Mary)                  ║
-- ║    john@example.com      / password123  → User (ยังไม่จ่าย)             ║
-- ║    jane@example.com      / password123  → User (ยังไม่จ่าย)             ║
-- ║                                                                         ║
-- ║  Promo Code → Salesperson:                                              ║
-- ║    TOM10 (15%), TOM20 (20%)   → Tom Sales                              ║
-- ║    MARY15 (15%), MARY25 (25%) → Mary Sales                             ║
-- ║    FLASH10 (10%)              → Admin                                   ║
-- ║    EARLY25 (25%), SAVE5 (5%)  → ไม่มีเจ้าของ (general)                 ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

USE railway;

SET FOREIGN_KEY_CHECKS = 0;

-- ─────────────────────────────────────────────────
-- ลบตารางเก่าที่ไม่ใช้แล้ว
-- ─────────────────────────────────────────────────
DROP TABLE IF EXISTS `referral_codes`;
DROP TABLE IF EXISTS `referrals`;

-- ─────────────────────────────────────────────────
-- ลบตารางทั้งหมดเพื่อสร้างใหม่
-- ─────────────────────────────────────────────────
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


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 1: users
-- ผู้ใช้ทั้งหมดในระบบ (admin, sales, user ธรรมดา)
-- ใช้โดย: Flutter App (register/login), Checkout Web, Admin Dashboard, Sales Dashboard
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `users` (
  `user_id`         varchar(100)  NOT NULL,
  `email`           varchar(255)  NOT NULL,
  `password`        varchar(255)  NOT NULL,                    -- bcrypt hash
  `first_name`      varchar(100)  NOT NULL,
  `last_name`       varchar(100)  NOT NULL,
  `phone`           varchar(20)   NOT NULL,
  `country_code`    varchar(10)   NOT NULL DEFAULT '+95',
  `role`            enum('user','sales','admin') NOT NULL DEFAULT 'user',
  `referral_code`   varchar(20)   DEFAULT NULL,                -- referral code ส่วนตัว (ถ้ามี)
  `referred_by`     varchar(100)  DEFAULT NULL,                -- ใครแนะนำมา
  `is_paid`         tinyint(1)    NOT NULL DEFAULT 0,          -- 0=free, 1=premium
  `promo_code_used` varchar(50)   DEFAULT NULL,                -- promo code ที่ใช้ตอนจ่าย
  `paid_at`         datetime      DEFAULT NULL,
  `created_at`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `idx_role`          (`role`),
  KEY `idx_is_paid`       (`is_paid`),
  KEY `idx_referral_code` (`referral_code`),
  KEY `idx_referred_by`   (`referred_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 2: promo_codes
-- โค้ดส่วนลด — แต่ละ code เชื่อมโยงกับ salesperson ผ่าน sales_person_id
-- เซลแจก code ให้ลูกค้า → ลูกค้าใส่ code → ระบบรู้ว่าเซลคนไหนขาย
-- ใช้โดย: Checkout Web (validate-promo), Admin Dashboard (CRUD), Sales Dashboard (ดูของตัวเอง)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `promo_codes` (
  `code`             varchar(50)   NOT NULL,
  `discount_percent` decimal(5,2)  NOT NULL DEFAULT 10.00,     -- ส่วนลด %
  `max_uses`         int           DEFAULT 100,                -- ใช้ได้สูงสุดกี่ครั้ง
  `used_count`       int           NOT NULL DEFAULT 0,         -- ใช้ไปแล้วกี่ครั้ง
  `sales_person_id`  varchar(100)  DEFAULT NULL,               -- FK → users.user_id ของเซล
  `created_at`       datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at`       datetime      DEFAULT NULL,               -- NULL = ไม่หมดอายุ

  PRIMARY KEY (`code`),
  KEY `idx_sales_person_id` (`sales_person_id`),
  KEY `idx_expires_at`      (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 3: payments
-- ประวัติการชำระเงิน Premium
-- ใช้โดย: Checkout Web (checkout), Admin Dashboard (ดูทั้งหมด),
--         Sales Dashboard (คำนวณยอดขาย + commission 20%)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `payments` (
  `payment_id`     varchar(100) NOT NULL,
  `user_id`        varchar(100) NOT NULL,                      -- FK → users.user_id
  `amount`         decimal(12,2) NOT NULL,                     -- จำนวนเงินจริงที่จ่าย (หลังหักส่วนลด)
  `currency`       varchar(10)  NOT NULL DEFAULT 'MMK',
  `payment_method` varchar(50)  NOT NULL,                      -- card, kbzpay, wavepay, mpu, etc.
  `promo_code`     varchar(50)  DEFAULT NULL,                  -- code ที่ใช้ (ถ้ามี)
  `referral_id`    varchar(100) DEFAULT NULL,                  -- สำหรับ tracking (reserved)
  `status`         enum('pending','completed','failed') NOT NULL DEFAULT 'pending',
  `order_id`       varchar(100) DEFAULT NULL,                  -- SF-xxxxx order reference
  `created_at`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`payment_id`),
  KEY `idx_user_id`  (`user_id`),
  KEY `idx_status`   (`status`),
  KEY `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 4: promo_code_usage
-- บันทึกว่า user ไหนใช้ promo code ไหนไปแล้ว (ป้องกันใช้ซ้ำ)
-- ใช้โดย: Checkout Web (checkPromoCodeUsage, recordPromoCodeUsage)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `promo_code_usage` (
  `id`              int          NOT NULL AUTO_INCREMENT,
  `promo_code`      varchar(50)  NOT NULL,
  `user_id`         varchar(100) NOT NULL,
  `discount_amount` decimal(12,2) DEFAULT NULL,                -- จำนวนเงินที่ลด
  `order_id`        varchar(100) DEFAULT NULL,
  `created_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_user` (`promo_code`,`user_id`),
  KEY `idx_promo_code` (`promo_code`),
  KEY `idx_user_id`    (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 5: vocabulary
-- คำศัพท์ HSK ทุกระดับ (HSK 1-6)
-- ใช้โดย: Flutter App (flashcard, quiz), API /api/vocab
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `vocabulary` (
  `vocab_id`    varchar(50)  NOT NULL,                         -- hsk1_001, hsk2_001, ...
  `hsk_level`   tinyint      NOT NULL,                         -- 1-6
  `hanzi`       varchar(100) NOT NULL,                         -- ตัวอักษรจีน
  `pinyin`      varchar(200) NOT NULL,                         -- การออกเสียง
  `meaning`     varchar(500) DEFAULT NULL,                     -- ความหมายภาษาไทย
  `meaning_en`  varchar(500) DEFAULT NULL,                     -- ความหมายภาษาอังกฤษ
  `meaning_my`  varchar(500) DEFAULT NULL,                     -- ความหมายภาษาพม่า
  `example`     text,                                          -- ตัวอย่างประโยค
  `audio_asset` varchar(500) DEFAULT NULL,                     -- path ไฟล์เสียง
  `sort_order`  int          NOT NULL,                         -- ลำดับการแสดง

  PRIMARY KEY (`vocab_id`),
  KEY `idx_hsk_level`  (`hsk_level`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 6: daily_goals
-- เป้าหมายประจำวัน (Flutter App)
-- ใช้โดย: Flutter App (syncDailyGoal, getUserDailyGoals, getUserStats)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `daily_goals` (
  `id`              int          NOT NULL AUTO_INCREMENT,
  `user_id`         varchar(100) NOT NULL,
  `goal_date`       date         NOT NULL,
  `target_cards`    int          NOT NULL DEFAULT 10,          -- เป้าหมาย
  `completed_cards` int          NOT NULL DEFAULT 0,           -- ทำได้
  `is_completed`    tinyint(1)   NOT NULL DEFAULT 0,
  `created_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_goal_date` (`user_id`,`goal_date`),
  KEY `idx_user_id`   (`user_id`),
  KEY `idx_goal_date`  (`goal_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 7: learning_sessions
-- บันทึกการเรียนแต่ละวัน (Flutter App)
-- ใช้โดย: Flutter App (syncLearningSession, getUserLearningSessions)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `learning_sessions` (
  `id`            int          NOT NULL AUTO_INCREMENT,
  `user_id`       varchar(100) NOT NULL,
  `session_date`  date         NOT NULL,
  `learned_cards` int          NOT NULL DEFAULT 0,
  `minutes_spent` int          NOT NULL DEFAULT 0,
  `hsk_level`     tinyint      DEFAULT NULL,
  `created_at`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_session_date` (`user_id`,`session_date`),
  KEY `idx_user_id`      (`user_id`),
  KEY `idx_session_date` (`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 8: user_settings
-- ตั้งค่าผู้ใช้ (Flutter App)
-- ใช้โดย: Flutter App (getUserSettings, syncUserSettings)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_settings` (
  `user_id`              varchar(100) NOT NULL,
  `app_language`         varchar(20)  NOT NULL DEFAULT 'english',  -- english, burmese, englishAndBurmese
  `current_hsk_level`    tinyint      NOT NULL DEFAULT 1,
  `daily_goal_target`    int          NOT NULL DEFAULT 10,
  `is_shuffle_mode`      tinyint(1)   NOT NULL DEFAULT 0,
  `notification_enabled` tinyint(1)   NOT NULL DEFAULT 1,
  `reminder_time`        time         NOT NULL DEFAULT '09:00:00',
  `updated_at`           datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 9: user_word_status
-- สถานะคำศัพท์ของแต่ละ user (learning / mastered / skipped)
-- ใช้โดย: Flutter App (syncUserWordStatus, getUserWordStatuses, getUserProfile)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_word_status` (
  `id`         int          NOT NULL AUTO_INCREMENT,
  `user_id`    varchar(100) NOT NULL,
  `vocab_id`   varchar(50)  NOT NULL,
  `status`     enum('learning','mastered','skipped') NOT NULL DEFAULT 'learning',
  `updated_at` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word_status` (`user_id`,`vocab_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status`  (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 10: user_achievements
-- ความสำเร็จที่ปลดล็อค (Flutter App)
-- ใช้โดย: Flutter App (getUserAchievements, unlockAchievement)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_achievements` (
  `id`              int          NOT NULL AUTO_INCREMENT,
  `user_id`         varchar(100) NOT NULL,
  `achievement_key` varchar(100) NOT NULL,
  `unlocked_at`     datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_achievement` (`user_id`,`achievement_key`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
-- TABLE 11: user_saved_words
-- คำศัพท์ที่ user บันทึกไว้ (bookmark)
-- ใช้โดย: Flutter App (syncUserSavedWord, removeUserSavedWord, getUserSavedWords)
-- ═════════════════════════════════════════════════════════════════════════════
CREATE TABLE `user_saved_words` (
  `id`       int          NOT NULL AUTO_INCREMENT,
  `user_id`  varchar(100) NOT NULL,
  `vocab_id` varchar(50)  NOT NULL,
  `saved_at` datetime     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`),
  KEY `idx_user_id`  (`user_id`),
  KEY `idx_vocab_id` (`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ═════════════════════════════════════════════════════════════════════════════
--  SAMPLE DATA
-- ═════════════════════════════════════════════════════════════════════════════

-- ─── USERS ───────────────────────────────────────────────────────────────────
-- password hashes:
--   admin123    → $2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe
--   password123 → $2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy

INSERT INTO `users`
  (`user_id`,`email`,`password`,`first_name`,`last_name`,`phone`,`country_code`,`role`,`referral_code`,`referred_by`,`is_paid`,`promo_code_used`,`paid_at`,`created_at`,`updated_at`)
VALUES
  -- Admin
  ('admin-user-001','admin@gmail.com',
   '$2a$10$RNmtcZRnv0cCqOTY2zdQYeLmzrVmJlDIHy/kzLXN5VoPhPSRIFnwe',
   'Admin','User','0912345678','+95','admin',
   'FLASH2024',NULL,1,NULL,NULL,
   '2026-02-24 18:54:24','2026-02-25 04:00:00'),

  -- Sales: Tom (มี 2 promo codes: TOM10, TOM20)
  ('tom-user-001','tom@shweflash.com',
   '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy',
   'Tom','Sales','0987654321','+95','sales',
   'TOM2026',NULL,0,NULL,NULL,
   '2026-02-24 18:54:24','2026-02-25 04:00:00'),

  -- Sales: Mary (มี 2 promo codes: MARY15, MARY25)
  ('mary-user-001','mary@shweflash.com',
   '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy',
   'Mary','Sales','0911122233','+95','sales',
   'MARY2026',NULL,0,NULL,NULL,
   '2026-02-24 18:54:24','2026-02-25 04:00:00'),

  -- User: John (ยังไม่จ่าย)
  ('john-user-001','john@example.com',
   '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy',
   'John','Customer','0998877665','+95','user',
   NULL,NULL,0,NULL,NULL,
   '2026-02-24 18:54:24','2026-02-25 04:00:00'),

  -- User: Jane (ยังไม่จ่าย)
  ('jane-user-001','jane@example.com',
   '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy',
   'Jane','Customer','0955544433','+95','user',
   NULL,NULL,0,NULL,NULL,
   '2026-02-24 18:54:24','2026-02-25 04:00:00'),

  -- User: Student (ใช้แอปเรียน, มีข้อมูล learning data)
  ('student-001','student@shweflash.com',
   '$2a$10$B59nw3dGtqMGxK0NdWzEXeUvx1LQoR0u1eiApYzTe3WzFhRA38Ziy',
   'Student','Learner','0911222334','+95','user',
   NULL,NULL,0,NULL,NULL,
   '2026-02-24 18:54:24','2026-02-25 04:00:00');


-- ─── PROMO CODES ─────────────────────────────────────────────────────────────
-- code → sales_person_id (ใครเป็นเจ้าของ code นี้)
-- เมื่อลูกค้าใส่ code → ระบบรู้ว่าเซลคนไหนขาย → คำนวณ commission 20%

INSERT INTO `promo_codes`
  (`code`,`discount_percent`,`max_uses`,`used_count`,`sales_person_id`,`created_at`,`expires_at`)
VALUES
  -- ของ Admin
  ('FLASH10',  10.00, 100, 0, 'admin-user-001', '2026-02-24 21:00:25', '2026-12-31 23:59:59'),

  -- ของ Tom Sales
  ('TOM10',    15.00,  50, 0, 'tom-user-001',   '2026-02-24 21:00:25', '2026-12-31 23:59:59'),
  ('TOM20',    20.00,  30, 0, 'tom-user-001',   '2026-02-24 21:00:25', '2026-06-30 23:59:59'),

  -- ของ Mary Sales
  ('MARY15',   15.00,  40, 0, 'mary-user-001',  '2026-02-24 21:00:25', '2026-12-31 23:59:59'),
  ('MARY25',   25.00,  20, 0, 'mary-user-001',  '2026-02-24 21:00:25', '2026-06-30 23:59:59'),

  -- General (ไม่มีเจ้าของ)
  ('EARLY25',  25.00,  30, 0, NULL,              '2026-02-24 21:00:25', '2026-03-31 23:59:59'),
  ('SAVE5',     5.00, 500, 0, NULL,              '2026-02-24 21:00:25', '2026-12-31 23:59:59'),
  ('LAUNCH2024',15.00, 50, 0, NULL,              '2026-02-24 18:47:11', '2026-12-31 23:59:59');


-- ─── PAYMENTS ────────────────────────────────────────────────────────────────
-- (ตัวอย่าง: 2 คนจ่ายผ่าน promo code ของเซล, 1 คนจ่ายเต็มราคา)

INSERT INTO `payments`
  (`payment_id`,`user_id`,`amount`,`currency`,`payment_method`,`promo_code`,`referral_id`,`status`,`order_id`,`created_at`)
VALUES
  ('pay-sample-001','john-user-001', 15300.00,'MMK','card',   'TOM10', NULL,'completed','SF-20260225-001','2026-02-25 04:00:00'),
  ('pay-sample-002','jane-user-001', 13500.00,'MMK','kbzpay', 'MARY25',NULL,'completed','SF-20260225-002','2026-02-25 04:10:00'),
  ('pay-sample-003','admin-user-001',18000.00,'MMK','card',    NULL,    NULL,'completed','SF-20260225-003','2026-02-25 03:00:00');


-- ─── PROMO CODE USAGE ────────────────────────────────────────────────────────
INSERT INTO `promo_code_usage`
  (`promo_code`,`user_id`,`discount_amount`,`order_id`,`created_at`)
VALUES
  ('TOM10', 'john-user-001', 2700.00, 'SF-20260225-001', '2026-02-25 04:00:00'),
  ('MARY25','jane-user-001', 4500.00, 'SF-20260225-002', '2026-02-25 04:10:00');


-- ─── VOCABULARY (HSK 1 ตัวอย่าง + HSK 2-3) ─────────────────────────────────
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
  ('hsk1_010',1,'车','chē','รถ','car/vehicle','ကား','这是我的车。','audio/hsk1/车.mp3',10),
  ('hsk2_001',2,'因为','yīn wèi','เพราะว่า','because','ဘာကြောင့်လဲ','因为下雨，所以我不出门。','audio/hsk2/因为.mp3',501),
  ('hsk2_002',2,'或者','huò zhě','หรือ','or','သို့မဟုတ်','你可以喝茶或者咖啡。','audio/hsk2/或者.mp3',502),
  ('hsk3_001',3,'环境','huán jìng','สภาพแวดล้อม','environment','ပတ်ဝန်းကျင်','我们要保护环境。','audio/hsk3/环境.mp3',1001);


-- ─── DAILY GOALS ─────────────────────────────────────────────────────────────
INSERT INTO `daily_goals`
  (`user_id`,`goal_date`,`target_cards`,`completed_cards`,`is_completed`)
VALUES
  ('student-001','2026-02-24',10,10,1),
  ('student-001','2026-02-25',10, 5,0);


-- ─── LEARNING SESSIONS ───────────────────────────────────────────────────────
INSERT INTO `learning_sessions`
  (`user_id`,`session_date`,`learned_cards`,`minutes_spent`,`hsk_level`)
VALUES
  ('student-001','2026-02-24',10,30,1),
  ('student-001','2026-02-25', 5,15,1);


-- ─── USER SETTINGS ───────────────────────────────────────────────────────────
INSERT INTO `user_settings`
  (`user_id`,`app_language`,`current_hsk_level`,`daily_goal_target`,`is_shuffle_mode`,`notification_enabled`,`reminder_time`)
VALUES
  ('student-001','english',1,10,0,1,'09:00:00'),
  ('john-user-001','burmese',1,10,1,0,'19:00:00');


-- ─── USER WORD STATUS ────────────────────────────────────────────────────────
INSERT INTO `user_word_status` (`user_id`,`vocab_id`,`status`) VALUES
  ('student-001','hsk1_001','mastered'),
  ('student-001','hsk1_002','mastered'),
  ('student-001','hsk1_003','learning'),
  ('student-001','hsk1_004','learning'),
  ('student-001','hsk1_005','skipped');


-- ─── USER ACHIEVEMENTS ───────────────────────────────────────────────────────
INSERT INTO `user_achievements` (`user_id`,`achievement_key`) VALUES
  ('student-001','first_word_learned'),
  ('student-001','ten_words_mastered'),
  ('student-001','first_daily_goal');


-- ─── USER SAVED WORDS ────────────────────────────────────────────────────────
INSERT INTO `user_saved_words` (`user_id`,`vocab_id`) VALUES
  ('student-001','hsk1_001'),
  ('student-001','hsk2_001'),
  ('student-001','hsk3_001');


-- ═════════════════════════════════════════════════════════════════════════════
--  VERIFICATION
-- ═════════════════════════════════════════════════════════════════════════════

SELECT '── TABLE COUNTS ──' as info;
SELECT
  (SELECT COUNT(*) FROM users)            as users,
  (SELECT COUNT(*) FROM promo_codes)      as promo_codes,
  (SELECT COUNT(*) FROM payments)         as payments,
  (SELECT COUNT(*) FROM promo_code_usage) as promo_usage,
  (SELECT COUNT(*) FROM vocabulary)       as vocabulary,
  (SELECT COUNT(*) FROM daily_goals)      as daily_goals,
  (SELECT COUNT(*) FROM learning_sessions) as learning_sessions,
  (SELECT COUNT(*) FROM user_settings)    as user_settings,
  (SELECT COUNT(*) FROM user_word_status) as word_status,
  (SELECT COUNT(*) FROM user_achievements) as achievements,
  (SELECT COUNT(*) FROM user_saved_words) as saved_words;

SELECT '── USERS BY ROLE ──' as info;
SELECT role, COUNT(*) as count FROM users GROUP BY role ORDER BY FIELD(role,'admin','sales','user');

SELECT '── SALES + PROMO CODES ──' as info;
SELECT
  CONCAT(u.first_name,' ',u.last_name) as salesperson,
  u.email,
  pc.code,
  pc.discount_percent as discount_pct,
  pc.used_count,
  pc.max_uses
FROM promo_codes pc
JOIN users u ON pc.sales_person_id = u.user_id
ORDER BY u.first_name, pc.discount_percent DESC;

SELECT '── PAYMENT SUMMARY ──' as info;
SELECT
  CONCAT(u.first_name,' ',u.last_name) as customer,
  p.amount, p.currency, p.promo_code, p.payment_method, p.status
FROM payments p
JOIN users u ON p.user_id = u.user_id
ORDER BY p.created_at DESC;

SELECT 'RAILWAY DATABASE SETUP COMPLETE' as status, NOW() as time;
