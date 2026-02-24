-- ═══════════════════════════════════════════════════════════════════════════════
-- COMPLETE DATABASE SETUP WITH sell002 AND PAID test@gmail.com
-- ═══════════════════════════════════════════════════════════════════════════════

-- Drop all tables
DROP TABLE IF EXISTS `user_saved_words`;
DROP TABLE IF EXISTS `user_achievements`;
DROP TABLE IF EXISTS `user_word_status`;
DROP TABLE IF EXISTS `user_settings`;
DROP TABLE IF EXISTS `learning_sessions`;
DROP TABLE IF EXISTS `daily_goals`;
DROP TABLE IF EXISTS `promo_code_usage`;
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `promo_codes`;
DROP TABLE IF EXISTS `vocabulary`;
DROP TABLE IF EXISTS `users`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. users
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `users` (
  `user_id`      VARCHAR(100)  NOT NULL,
  `email`        VARCHAR(255)  NOT NULL,
  `password`     VARCHAR(255)  NOT NULL,
  `first_name`   VARCHAR(100)  DEFAULT NULL,
  `last_name`    VARCHAR(100)  DEFAULT NULL,
  `phone`        VARCHAR(20)   DEFAULT NULL,
  `country_code` VARCHAR(10)   DEFAULT '+95',
  `role`         ENUM('admin', 'sales', 'user') NOT NULL DEFAULT 'user',
  `is_paid`      TINYINT(1)    NOT NULL DEFAULT 0,
  `promo_code_used` VARCHAR(50) DEFAULT NULL,
  `paid_at`      DATETIME      DEFAULT NULL,
  `created_at`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `unique_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_is_paid` (`is_paid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. promo_codes
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
CREATE TABLE `payments` (
  `payment_id`     VARCHAR(100)  NOT NULL,
  `user_id`        VARCHAR(100)  NOT NULL,
  `amount`         DECIMAL(12,2) NOT NULL,
  `currency`       VARCHAR(10)   NOT NULL DEFAULT 'MMK',
  `payment_method` VARCHAR(50)   NOT NULL,
  `status`         ENUM('pending', 'completed', 'failed') NOT NULL DEFAULT 'pending',
  `promo_code`     VARCHAR(50)   DEFAULT NULL,
  `order_id`       VARCHAR(100)  DEFAULT NULL,
  `created_at`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_promo_code` (`promo_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. promo_code_usage
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
-- 6-11. Other tables (simplified)
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE `daily_goals` (
  `id`            INT          NOT NULL AUTO_INCREMENT,
  `user_id`       VARCHAR(100) NOT NULL,
  `session_date`  DATE         NOT NULL,
  `target_cards`  INT          NOT NULL DEFAULT 10,
  `completed_cards` INT        NOT NULL DEFAULT 0,
  `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_date` (`user_id`,`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `learning_sessions` (
  `id`            INT          NOT NULL AUTO_INCREMENT,
  `user_id`       VARCHAR(100) NOT NULL,
  `session_date`  DATE         NOT NULL,
  `learned_cards` INT          NOT NULL DEFAULT 0,
  `minutes_spent` INT          NOT NULL DEFAULT 0,
  `hsk_level`     TINYINT      DEFAULT NULL,
  `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_session_date` (`user_id`,`session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

CREATE TABLE `user_word_status` (
  `id`       INT          NOT NULL AUTO_INCREMENT,
  `user_id`  VARCHAR(100) NOT NULL,
  `vocab_id` VARCHAR(50)  NOT NULL,
  `status`   ENUM('new', 'learning', 'review', 'mastered') NOT NULL DEFAULT 'new',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_achievements` (
  `id`              INT          NOT NULL AUTO_INCREMENT,
  `user_id`         VARCHAR(100) NOT NULL,
  `achievement_key` VARCHAR(100) NOT NULL,
  `unlocked_at`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_achievement` (`user_id`,`achievement_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_saved_words` (
  `id`       INT          NOT NULL AUTO_INCREMENT,
  `user_id`  VARCHAR(100) NOT NULL,
  `vocab_id` VARCHAR(50)  NOT NULL,
  `saved_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- INSERT: USERS (รวม sell002 และ test@gmail.com ที่จ่ายแล้ว)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO `users`
  (`user_id`, `email`, `password`, `first_name`, `last_name`, `phone`, `country_code`, `role`, `is_paid`, `promo_code_used`, `paid_at`)
VALUES
  ('admin-001', 'admin@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Admin', 'ShweFlash', '0912345678', '+95', 'admin', 0, NULL, NULL),

  ('sales-001', 'sell@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Sell', 'Person', '0987654321', '+95', 'sales', 0, NULL, NULL),

  ('sales-002', 'sell002@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Sell', 'Person002', '0922233344', '+95', 'sales', 0, NULL, NULL),

  ('user-001', 'test@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Test', 'User', '0998877665', '+95', 'user', 1, 'FLASH10', NOW()),

  ('user-002', 'test1@gmail.com',
   '$2a$10$WsRycmaiuFepqsex83N/bekfWZYAeYCVdqXmmd4JJ4p2zAqJTODmq',
   'Test1', 'User', '0955544433', '+95', 'user', 0, NULL, NULL);

-- ═══════════════════════════════════════════════════════════════════════════════
-- INSERT: PROMO CODES (FLASH10 เชื่อมกับ sell002)
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO `promo_codes`
  (`code`, `discount_percent`, `max_uses`, `used_count`, `sales_person_id`, `expires_at`)
VALUES
  ('SELL10',   10.00,  50, 0, 'sales-001', '2027-12-31 23:59:59'),
  ('SELL20',   20.00,  30, 0, 'sales-001', '2027-06-30 23:59:59'),
  ('FLASH10',  10.00, 100, 0, 'sales-002', '2027-12-31 23:59:59'),
  ('EARLY25',  25.00,  30, 0, NULL,        '2027-03-31 23:59:59');

-- ═══════════════════════════════════════════════════════════════════════════════
-- INSERT: SAMPLE VOCABULARY (HSK 1)
-- ═══════════════════════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- INSERT: PAYMENT RECORD สำหรับ test@gmail.com
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO `payments`
  (`payment_id`, `user_id`, `amount`, `currency`, `payment_method`, `status`, `promo_code`, `order_id`, `created_at`)
VALUES
  ('payment-test-001', 'user-001', 7500.00, 'MMK', 'card', 'completed', 'FLASH10', 'order-test-001', NOW());

-- ═══════════════════════════════════════════════════════════════════════════════
-- INSERT: PROMO CODE USAGE สำหรับ test@gmail.com
-- ═══════════════════════════════════════════════════════════════════════════════
INSERT INTO `promo_code_usage`
  (`promo_code`, `user_id`, `order_id`, `created_at`)
VALUES
  ('FLASH10', 'user-001', 'order-test-001', NOW());

-- ═══════════════════════════════════════════════════════════════════════════════
-- FOREIGN KEY CONSTRAINTS
-- ═══════════════════════════════════════════════════════════════════════════════
ALTER TABLE `payments` 
  ADD CONSTRAINT `payments_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `promo_codes` 
  ADD CONSTRAINT `promo_codes_sales_person_fk` 
  FOREIGN KEY (`sales_person_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

ALTER TABLE `promo_code_usage` 
  ADD CONSTRAINT `promo_usage_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `promo_code_usage` 
  ADD CONSTRAINT `promo_usage_code_fk` 
  FOREIGN KEY (`promo_code`) REFERENCES `promo_codes` (`code`) ON DELETE CASCADE;

ALTER TABLE `daily_goals` 
  ADD CONSTRAINT `daily_goals_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `learning_sessions` 
  ADD CONSTRAINT `learning_sessions_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `user_settings` 
  ADD CONSTRAINT `user_settings_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `user_word_status` 
  ADD CONSTRAINT `user_word_status_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `user_word_status` 
  ADD CONSTRAINT `user_word_status_vocab_id_fk` 
  FOREIGN KEY (`vocab_id`) REFERENCES `vocabulary` (`vocab_id`) ON DELETE CASCADE;

ALTER TABLE `user_achievements` 
  ADD CONSTRAINT `user_achievements_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `user_saved_words` 
  ADD CONSTRAINT `user_saved_words_user_id_fk` 
  FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

ALTER TABLE `user_saved_words` 
  ADD CONSTRAINT `user_saved_words_vocab_id_fk` 
  FOREIGN KEY (`vocab_id`) REFERENCES `vocabulary` (`vocab_id`) ON DELETE CASCADE;
