import express from 'express';
import { 
  getUserByEmail, 
  createReferralCodeForUser,
  checkReferralCodeExists,
  getReferralCodeInfo
} from '../config/database.js';
import authMiddleware from '../middleware/auth.js';

const router = express.Router();

/**
 * GET /api/referral/my-code
 * ดู referral code ของตัวเอง หรือสร้างใหม่
 */
router.get('/my-code', authMiddleware, async (req, res) => {
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
      referralInfo: referralInfo ? {
        ownerName: `${referralInfo.first_name} ${referralInfo.last_name}`,
        ownerEmail: referralInfo.email,
        maxUses: 100,
        usedCount: 0 // TODO: ดูจากจริงจาก referral_codes table
      } : null,
      message: 'Referral code retrieved successfully',
      isNew: false
    });
  } catch (error) {
    console.error('Get referral code error:', error);
    res.status(500).json({ error: 'Failed to get referral code' });
  }
});

/**
 * POST /api/referral/check
 * ตรวจสอบว่า referral code มีอยู่แล้ว
 */
router.post('/check', async (req, res) => {
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
});

export default router;
