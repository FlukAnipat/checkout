-- ════════════════════════════════════════════════════════════════════════════════╗
-- ║  CREATE EMAIL CONFIRMATIONS TABLE                                          ║
-- ║  For email confirmation link system                                          ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

USE railway;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. email_confirmations table
-- ═══════════════════════════════════════════════════════════════════════════════
-- ใช้โดย: Email Confirmation System
-- เก็บ confirmation tokens สำหรับยืนยัน email address
-- ═══════════════════════════════════════════════════════════════════════════════
CREATE TABLE IF NOT EXISTS `email_confirmations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `token` VARCHAR(64) NOT NULL UNIQUE,
  `email` VARCHAR(255) NOT NULL,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `used` BOOLEAN NOT NULL DEFAULT FALSE,
  `expires_at` DATETIME NOT NULL,
  `confirmed_at` DATETIME DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_token` (`token`),
  KEY `idx_email` (`email`),
  KEY `idx_used` (`used`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. Clean up expired tokens (optional - can be run periodically)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Delete expired tokens (run this periodically to clean up)
-- DELETE FROM email_confirmations WHERE expires_at < NOW();

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. Verify table created successfully
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'Email confirmations table created successfully!' as status;

-- Show table structure
DESCRIBE `email_confirmations`;

-- Show all tables
SHOW TABLES LIKE 'email_confirmations';
