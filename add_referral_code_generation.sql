-- 🆕 เพิ่ม API Endpoint สำหรับ Referral Code Generation
-- ให้ user สร้าง referral code ของตัวเองและตรวจสอบว่ามีอยู่แล้ว

-- --------------------------------------------------------
-- 🆕 เพิ่มคอลัมน์ในตาราง users (ถ้ายังไม่มี)
-- --------------------------------------------------------
ALTER TABLE `users` ADD COLUMN `referral_code` varchar(20) DEFAULT NULL AFTER `country_code`;
ALTER TABLE `users` ADD COLUMN `referred_by` varchar(100) DEFAULT NULL AFTER `referral_code`;
ALTER TABLE `users` ADD INDEX `idx_referral_code` (`referral_code`);
ALTER TABLE `users` ADD INDEX `idx_referred_by` (`referred_by`);

-- --------------------------------------------------------
-- 🆕 เพิ่มฟังก์ชันสำหรับ Referral Code Generation
-- --------------------------------------------------------

-- สร้าง referral code สำหรับ user
export async function generateReferralCode(userId) {
  // สุ่มแบบสุ่ม: FLASH + 6 ตัวอักษร + 3 ตัวเลข
  const prefix = 'FLASH';
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  let code = prefix;
  
  // เพิ่ม 6 ตัวอักษร
  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  
  // เพิ่ม 3 ตัวเลข
  code += Math.floor(Math.random() * 1000).toString().padStart(3, '0');
  
  return code;
}

// สร้าง referral code และบันทึก
export async function createReferralCodeForUser(userId) {
  try {
    // ตรวจสอบว่ามี referral code อยู่แล้ว
    const [existingUser] = await pool.execute(
      'SELECT referral_code FROM users WHERE user_id = ? AND referral_code IS NOT NULL',
      [userId]
    );
    
    if (existingUser.length > 0) {
      return existingUser[0].referral_code;
    }
    
    // สร้าง referral code ใหม่
    const newCode = await generateReferralCode(userId);
    
    // ตรวจสอบว่า code ซ้ำในระบบ
    const [existingCode] = await pool.execute(
      'SELECT code FROM referral_codes WHERE code = ?',
      [newCode]
    );
    
    if (existingCode.length > 0) {
      // ถ้าซ้ำ สร้างใหม่
      return await createReferralCodeForUser(userId);
    }
    
    // บันทึก referral code
    await pool.execute(
      'INSERT INTO referral_codes (code, user_id, max_uses, is_active) VALUES (?, ?, 100, 1)',
      [newCode, userId]
    );
    
    // อัปเดต user table
    await pool.execute(
      'UPDATE users SET referral_code = ? WHERE user_id = ?',
      [newCode, userId]
    );
    
    return newCode;
  } catch (error) {
    console.error('Error creating referral code:', error);
    throw error;
  }
}

// ตรวจสอบว่า referral code มีอยู่แล้ว
export async function checkReferralCodeExists(code) {
  try {
    const [result] = await pool.execute(
      'SELECT code FROM referral_codes WHERE code = ? AND is_active = 1',
      [code.toUpperCase().trim()]
    );
    return result.length > 0;
  } catch (error) {
    console.error('Error checking referral code:', error);
    return false;
  }
}

// ตรวจสอบข้อมูล referral code
export async function getReferralCodeInfo(code) {
  try {
    const [result] = await pool.execute(
      `SELECT rc.*, u.first_name, u.last_name, u.email 
       FROM referral_codes rc 
       JOIN users u ON rc.user_id = u.user_id 
       WHERE rc.code = ? AND rc.is_active = 1`,
      [code.toUpperCase().trim()]
    );
    return result[0] || null;
  } catch (error) {
    console.error('Error getting referral code info:', error);
    return null;
  }
}

-- --------------------------------------------------------
-- 🆕 API Endpoint: GET /api/referral/my-code
-- ดู referral code ของตัวเอง
-- --------------------------------------------------------
export async function getMyReferralCode(req, res) {
  try {
    const user = await getUserByEmail(req.user.email);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    if (!user.referral_code) {
      // ถ้ายังไม่มี referral code ให้สร้างใหม่
      const newCode = await createReferralCodeForUser(user.user_id);
      return res.json({
        success: true,
        referralCode: newCode,
        message: 'Referral code created successfully',
        isNew: true
      });
    }

    // มี referral code อยู่แล้ว
    const referralInfo = await getReferralCodeInfo(user.referral_code);
    
    res.json({
      success: true,
      referralCode: user.referral_code,
      referralInfo: {
        ownerName: `${referralInfo.first_name} ${referralInfo.last_name}`,
        ownerEmail: referralInfo.email,
        maxUses: 100,
        usedCount: 0 // TODO: ดูจากจริงจาก referral_codes table
      },
      message: 'Referral code retrieved successfully',
      isNew: false
    });
  } catch (error) {
    console.error('Get referral code error:', error);
    res.status(500).json({ error: 'Failed to get referral code' });
  }
}

-- --------------------------------------------------------
-- 🆕 API Endpoint: POST /api/referral/check
-- ตรวจสอบว่า referral code มีอยู่แล้ว
-- --------------------------------------------------------
export async function checkReferralCode(req, res) {
  try {
    const { code } = req.body;
    
    if (!code || code.trim().length === 0) {
      return res.status(400).json({ error: 'Referral code is required' });
    }
    
    const exists = await checkReferralCodeExists(code);
    const info = exists ? await getReferralCodeInfo(code) : null;
    
    res.json({
      success: true,
      exists,
      referralInfo: info ? {
        ownerName: `${info.first_name} ${info.last_name}`,
        ownerEmail: info.email
      } : null
    });
  } catch (error) {
    console.error('Check referral code error:', error);
    res.status(500).json({ error: 'Failed to check referral code' });
  }
}
