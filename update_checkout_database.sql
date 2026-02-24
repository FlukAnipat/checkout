-- อัปเดต checkout.sql ให้ตรงกับระบบปัจจุบัน
-- เพิ่ม sales_person_id ใน promo_codes table
-- อัปเดต users table ให้มี referral_code, referred_by
-- เพิ่ม referral_id ใน payments table
-- เพิ่ม missing tables ที่ระบบต้องการใช้

USE railway;

-- ─── อัปเดต promo_codes table เพิ่ม sales_person_id ───
ALTER TABLE `promo_codes` ADD COLUMN `sales_person_id` varchar(100) DEFAULT NULL AFTER `used_count`;
ALTER TABLE `promo_codes` ADD INDEX `idx_sales_person_id` (`sales_person_id`);

-- ─── อัปเดต users table เพิ่ม referral_code, referred_by ───
ALTER TABLE `users` ADD COLUMN `referral_code` varchar(20) DEFAULT NULL AFTER `country_code`;
ALTER TABLE `users` ADD COLUMN `referred_by` varchar(100) DEFAULT NULL AFTER `referral_code`;
ALTER TABLE `users` ADD INDEX `idx_referral_code` (`referral_code`);
ALTER TABLE `users` ADD INDEX `idx_referred_by` (`referred_by`);

-- ─── อัปเดต payments table เพิ่ม referral_id ───
ALTER TABLE `payments` ADD COLUMN `referral_id` varchar(100) DEFAULT NULL AFTER `promo_code`;
ALTER TABLE `payments` ADD INDEX `idx_referral_id` (`referral_id`);

-- ─── อัปเดต promo_codes ที่มีอยู่แล้วให้มี sales_person_id ───
-- FLASH10 มาจาก admin-user-001
UPDATE `promo_codes` SET `sales_person_id` = 'admin-user-001' WHERE `code` = 'FLASH10';

-- SPECIAL20 มาจาก demo-user-001  
UPDATE `promo_codes` SET `sales_person_id` = 'demo-user-001' WHERE `code` = 'SPECIAL20';

-- STUDENT15 มาจาก test-user-001
UPDATE `promo_codes` SET `sales_person_id` = 'test-user-001' WHERE `code` = 'STUDENT15';

-- STUDENT10 มาจาก test-user-001
UPDATE `promo_codes` SET `sales_person_id` = 'test-user-001' WHERE `code` 'STUDENT10';

-- ─── อัปเดต users ที่มีอยู่แล้วให้มี referral_code ───
-- admin-user-001 มี referral_code: FLASH2024
UPDATE `users` SET `referral_code` = 'FLASH2024' WHERE `user_id` = 'admin-user-001';

-- demo-user-001 มี referral_code: STUDENT25
UPDATE `users` SET `referral_code` = 'STUDENT25' WHERE `user_id` = 'demo-user-001';

-- test-user-001 มี referral_code: EARLYBIRD
UPDATE `users` SET `referral_code` = 'EARLYBIRD' WHERE `user_id` = 'test-user-001';

-- ─── ตรวจสอสถานะการอัปเดต ───
SELECT 'promo_codes' as table_name, COUNT(*) as columns FROM `promo_codes`;
SELECT 'users' as table_name, COUNT(*) as columns FROM `users`;
SELECT 'payments' as table_name, COUNT(*) as columns FROM `payments`;

-- ─── ดูข้อมูล salesperson ใน promo codes ───
SELECT 
  pc.code,
  pc.discount_percent,
  pc.sales_person_id,
  CONCAT(u.first_name, ' ', u.last_name) as salesperson_name
FROM `promo_codes` pc
LEFT JOIN `users` u ON pc.sales_person_id = u.user_id
WHERE pc.sales_person_id IS NOT NULL
ORDER BY pc.created_at DESC;

-- ─── ดู users ที่มี referral codes ───
SELECT 
  user_id,
  email,
  referral_code,
  referred_by,
  is_paid,
  created_at
FROM `users`
WHERE referral_code IS NOT NULL OR referred_by IS NOT NULL
ORDER BY created_at DESC;

-- ─── ดู payments ที่มี referral_id ───
SELECT 
  payment_id,
  user_id,
  amount,
  promo_code,
  referral_id,
  status,
  created_at
FROM `payments`
WHERE referral_id IS NOT NULL
ORDER BY created_at DESC;
