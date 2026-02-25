-- Check if email_confirmations table exists
USE railway;

SHOW TABLES LIKE 'email_confirmations';

-- If table doesn't exist, create it
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

-- Show table structure
DESCRIBE `email_confirmations`;
