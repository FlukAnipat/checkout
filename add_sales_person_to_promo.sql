-- เพิ่ม sales_person_id ใน promo_codes table
-- เพื่อเก็บว่า promo code มาจากเซลคนไหน

ALTER TABLE `promo_codes` ADD COLUMN `sales_person_id` varchar(100) DEFAULT NULL AFTER `used_count`;
ALTER TABLE `promo_codes` ADD INDEX `idx_sales_person_id` (`sales_person_id`);

-- อัปเดต promo codes ที่มีอยู่แล้วให้มี sales_person_id
-- สมมติว่า FLASH10 มาจาก admin-user-001
UPDATE `promo_codes` SET `sales_person_id` = 'admin-user-001' WHERE `code` = 'FLASH10';

-- สมมติว่า SPECIAL20 มาจาก demo-user-001  
UPDATE `promo_codes` SET `sales_person_id` = 'demo-user-001' WHERE `code` = 'SPECIAL20';

-- สมมติว่า STUDENT15 มาจาก test-user-001
UPDATE `promo_codes` SET `sales_person_id` = 'test-user-001' WHERE `code` = 'STUDENT15';

-- ตรวจสอบผลลัพธ์
SELECT pc.*, CONCAT(u.first_name, ' ', u.last_name) as sales_person_name 
FROM `promo_codes` pc 
LEFT JOIN `users` u ON pc.sales_person_id = u.user_id 
WHERE pc.sales_person_id IS NOT NULL;
