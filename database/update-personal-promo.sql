-- ╔═══════════════════════════════════════════════════════════════════════════════╗
-- ║  UPDATE: Add personal_promo_code field to users table                           ║
-- ║  Use this script to update existing database without recreating tables         ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

USE railway;

-- Add personal_promo_code field to users table
ALTER TABLE `users` 
ADD COLUMN `personal_promo_code` VARCHAR(20) DEFAULT NULL AFTER `paid_at`,
ADD UNIQUE KEY `unique_personal_promo` (`personal_promo_code`);

-- Generate personal promo codes for existing sales users
UPDATE `users` 
SET `personal_promo_code` = CONCAT(
    UPPER(LEFT(`first_name`, 1)),
    UPPER(LEFT(`last_name`, 1)),
    UPPER(SUBSTRING(MD5(`user_id`), 1, 4)),
    '10'
)
WHERE `role` = 'sales' AND `personal_promo_code` IS NULL;

-- Insert promo codes for existing sales users in promo_codes table
INSERT IGNORE INTO `promo_codes` 
(`code`, `discount_percent`, `max_uses`, `used_count`, `sales_person_id`, `expires_at`)
SELECT 
    `personal_promo_code`,
    10.00,
    100,
    0,
    `user_id`,
    DATE_ADD(CURRENT_DATE, INTERVAL 2 YEAR)
FROM `users` 
WHERE `role` = 'sales' AND `personal_promo_code` IS NOT NULL;

-- Show results
SELECT 
    `user_id`,
    `email`,
    `first_name`,
    `last_name`,
    `role`,
    `personal_promo_code`
FROM `users` 
WHERE `role` = 'sales' AND `personal_promo_code` IS NOT NULL;
