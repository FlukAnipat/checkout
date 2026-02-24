-- เพิ่มตาราง Referral System และ Promo Code Usage Tracking
-- สำหรับระบบค่าคอมมิชชั่น 20% และการจำกัดการใช้ promo code

-- ตาราง Referral System
CREATE TABLE `referrals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referrer_id` varchar(100) NOT NULL,        -- คนแนะนำ (user_id)
  `referred_id` varchar(100) NOT NULL,        -- คนถูกแนะนำ (user_id)
  `referral_code` varchar(20) NOT NULL,       -- รหัสแนะนำ
  `commission_percent` decimal(5,2) NOT NULL DEFAULT 20.00,  -- ค่าคอมมิชชั่น 20%
  `commission_amount` decimal(12,2) DEFAULT NULL,          -- จำนวนเงินค่าคอมมิชชั่น
  `status` enum('pending','completed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `completed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_referral` (`referrer_id`, `referred_id`),
  KEY `idx_referrer` (`referrer_id`),
  KEY `idx_referred` (`referred_id`),
  KEY `idx_referral_code` (`referral_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ตาราง Referral Codes
CREATE TABLE `referral_codes` (
  `code` varchar(20) NOT NULL,
  `user_id` varchar(100) NOT NULL,           -- เจ้าของรหัส
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `max_uses` int(11) DEFAULT 100,
  `used_count` int(11) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime DEFAULT NULL,
  PRIMARY KEY (`code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ตาราง Promo Code Usage Tracking (เพิ่ม user_id)
CREATE TABLE `promo_code_usage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promo_code` varchar(50) NOT NULL,
  `user_id` varchar(100) NOT NULL,           -- ใครใช้
  `discount_amount` decimal(12,2) DEFAULT NULL,
  `order_id` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_promo_user` (`promo_code`, `user_id`),
  KEY `idx_promo_code` (`promo_code`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- เพิ่มคอลัมน์ referral_code ในตาราง users (ถ้ายังไม่มี)
ALTER TABLE `users` ADD COLUMN `referral_code` varchar(20) DEFAULT NULL AFTER `country_code`;
ALTER TABLE `users` ADD COLUMN `referred_by` varchar(100) DEFAULT NULL AFTER `referral_code`;

-- เพิ่มคอลัมน์ referral_id ในตาราง payments (เพื่อ track ค่าคอมมิชชั่น)
ALTER TABLE `payments` ADD COLUMN `referral_id` varchar(100) DEFAULT NULL AFTER `promo_code`;

-- สร้าง Index สำหรับ performance
CREATE INDEX `idx_users_referral_code` ON `users` (`referral_code`);
CREATE INDEX `idx_users_referred_by` ON `users` (`referred_by`);
CREATE INDEX `idx_payments_referral_id` ON `payments` (`referral_id`);

-- เพิ่ม Referral Codes ตัวอย่าง
INSERT INTO `referral_codes` (`code`, `user_id`, `max_uses`) VALUES
('FLASH2024', 'admin-user-id', 100),
('STUDENT25', 'demo-user-id', 50),
('EARLYBIRD', 'test-user-id', 30);

-- เพิ่ม Promo Code ส่วนลด 10% (ที่ขอ)
INSERT INTO `promo_codes` (
  `code`, 
  `discount_percent`, 
  `max_uses`, 
  `used_count`, 
  `created_at`, 
  `expires_at`
) VALUES 
('FLASH10', 10.00, 100, 0, NOW(), '2025-12-31 23:59:59'),
('SPECIAL20', 20.00, 50, 0, NOW(), '2025-06-30 23:59:59'),
('STUDENT15', 15.00, 200, 0, NOW(), '2025-12-31 23:59:59'),
('EARLY25', 25.00, 30, 0, NOW(), '2025-03-31 23:59:59'),
('SAVE5', 5.00, 500, 0, NOW(), '2025-12-31 23:59:59');

-- ตรวจสอบตารางที่สร้าง
SHOW TABLES LIKE '%referral%';
SHOW TABLES LIKE '%promo%';
DESCRIBE `referrals`;
DESCRIBE `referral_codes`;
DESCRIBE `promo_code_usage`;
