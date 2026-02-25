-- ════════════════════════════════════════════════════════════════════════════════╗
-- ║  ADD MISSING TABLES FOR SALES REGISTRATION SYSTEM                           ║
-- ║  Run this script to add missing tables to existing database                     ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

USE railway;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. user_registrations (NEW)
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Sales Registration (OTP verification, Admin approval)
-- เก็บการสมัคร Sales ที่รอ approve ก่อนย้ายไป users table
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS `user_registrations` (
  `user_id` VARCHAR(100) PRIMARY KEY,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `country_code` VARCHAR(10) NOT NULL,
  `country` VARCHAR(100) NOT NULL DEFAULT 'Myanmar',
  `role` ENUM('user','sales','admin') NOT NULL DEFAULT 'sales',
  `status` ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `approved_at` DATETIME DEFAULT NULL,
  `rejected_at` DATETIME DEFAULT NULL,
  `approved_by` VARCHAR(100) DEFAULT NULL,
  `rejected_by` VARCHAR(100) DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. promo_code_usage (NEW)
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Checkout (prevent duplicate promo code usage)
-- ป้องกัน user ใช้ promo code ซ้ำ
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS `promo_code_usage` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `promo_code` VARCHAR(50) NOT NULL,
  `user_id` VARCHAR(100) NOT NULL,
  `discount_amount` DECIMAL(12,2) DEFAULT NULL,
  `order_id` VARCHAR(100) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_user` (`promo_code`,`user_id`),
  KEY `idx_promo_code` (`promo_code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. Add missing columns to existing tables (if needed)
-- ═══════════════════════════════════════════════════════════════════════════════

-- Add country column to users table (if not exists)
-- Check if column exists first
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'railway' 
    AND TABLE_NAME = 'users' 
    AND COLUMN_NAME = 'country'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `users` ADD COLUMN `country` VARCHAR(100) NOT NULL DEFAULT \'Myanmar\' AFTER `country_code`',
    'SELECT "Column country already exists" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add total_discount_given column to promo_codes table (if not exists)
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'railway' 
    AND TABLE_NAME = 'promo_codes' 
    AND COLUMN_NAME = 'total_discount_given'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `promo_codes` ADD COLUMN `total_discount_given` DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `used_count`',
    'SELECT "Column total_discount_given already exists" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add referral_id column to payments table (if not exists)
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'railway' 
    AND TABLE_NAME = 'payments' 
    AND COLUMN_NAME = 'referral_id'
);

SET @sql = IF(@column_exists = 0, 
    'ALTER TABLE `payments` ADD COLUMN `referral_id` VARCHAR(100) DEFAULT NULL AFTER `promo_code`',
    'SELECT "Column referral_id already exists" as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. Verify tables created successfully
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'Tables created successfully!' as status;

-- Show all tables
SHOW TABLES;

-- Show user_registrations structure
DESCRIBE `user_registrations`;

-- Show promo_code_usage structure  
DESCRIBE `promo_code_usage`;
