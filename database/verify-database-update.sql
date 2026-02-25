-- ════════════════════════════════════════════════════════════════════════════════╗
-- ║  VERIFY DATABASE UPDATE COMPLETED                                          ║
-- ║  Run this to verify all tables and columns are created correctly               ║
-- ╚═══════════════════════════════════════════════════════════════════════════════╝

USE railway;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 1. Show all tables
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'All Tables:' as info;
SHOW TABLES;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 2. Verify user_registrations table structure
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'user_registrations Structure:' as info;
DESCRIBE `user_registrations`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 3. Verify promo_code_usage table structure
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'promo_code_usage Structure:' as info;
DESCRIBE `promo_code_usage`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 4. Verify new columns in users table
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'users Table Columns (including new country column):' as info;
DESCRIBE `users`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 5. Verify new columns in promo_codes table
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'promo_codes Table Columns (including total_discount_given):' as info;
DESCRIBE `promo_codes`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 6. Verify new columns in payments table
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'payments Table Columns (including referral_id):' as info;
DESCRIBE `payments`;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 7. Check existing sales users
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'Existing Sales Users:' as info;
SELECT 
    user_id,
    email,
    first_name,
    last_name,
    phone,
    country_code,
    country,
    role,
    is_paid,
    created_at
FROM users 
WHERE role = 'sales' 
ORDER BY created_at DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 8. Check pending registrations
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'Pending Registrations:' as info;
SELECT 
    user_id,
    email,
    first_name,
    last_name,
    phone,
    country_code,
    country,
    status,
    created_at
FROM user_registrations 
WHERE status = 'pending'
ORDER BY created_at DESC;

-- ═══════════════════════════════════════════════════════════════════════════════
-- 9. Database Summary
-- ═══════════════════════════════════════════════════════════════════════════════
SELECT 'Database Summary:' as info;
SELECT 
    'users' as table_name,
    COUNT(*) as record_count
FROM users
UNION ALL
SELECT 
    'user_registrations' as table_name,
    COUNT(*) as record_count
FROM user_registrations
UNION ALL
SELECT 
    'promo_codes' as table_name,
    COUNT(*) as record_count
FROM promo_codes
UNION ALL
SELECT 
    'promo_code_usage' as table_name,
    COUNT(*) as record_count
FROM promo_code_usage
UNION ALL
SELECT 
    'payments' as table_name,
    COUNT(*) as record_count
FROM payments;

SELECT 'Database update verification completed!' as status;
