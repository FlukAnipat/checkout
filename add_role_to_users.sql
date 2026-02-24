-- ═══════════════════════════════════════════════════════════════════════════
-- เพิ่ม role column ให้ users table ที่มีอยู่แล้วใน Railway
-- รันบน Railway MySQL Workbench
-- ═══════════════════════════════════════════════════════════════════════════

USE railway;

-- เพิ่ม role column (ถ้ายังไม่มี)
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = 'railway' 
     AND TABLE_NAME = 'users' 
     AND COLUMN_NAME = 'role') > 0,
  'SELECT "role column already exists" as message',
  'ALTER TABLE `users` ADD COLUMN `role` enum(''user'',''sales'',''admin'') NOT NULL DEFAULT ''user'' AFTER `country_code`'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- เพิ่ม index สำหรับ role
SET @sql = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
   WHERE TABLE_SCHEMA = 'railway' 
     AND TABLE_NAME = 'users' 
     AND INDEX_NAME = 'idx_role') > 0,
  'SELECT "idx_role already exists" as message',
  'ALTER TABLE `users` ADD INDEX `idx_role` (`role`)'
));
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- อัปเดต role ให้ users ที่มีอยู่แล้ว
-- admin
UPDATE `users` SET `role` = 'admin' WHERE `user_id` = 'admin-user-001';
UPDATE `users` SET `email` = 'admin@gmail.com' WHERE `user_id` = 'admin-user-001';

-- sales persons (คนที่มี promo code เป็นเจ้าของ)
UPDATE `users` SET `role` = 'sales' WHERE `user_id` IN (
  SELECT DISTINCT sales_person_id FROM promo_codes WHERE sales_person_id IS NOT NULL
) AND `role` != 'admin';

-- ตรวจสอบผลลัพธ์
SELECT user_id, email, first_name, last_name, role, is_paid 
FROM users 
ORDER BY FIELD(role, 'admin', 'sales', 'user'), created_at;
