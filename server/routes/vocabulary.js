import express from 'express';
import {
  getVocabularyByLevel,
  getHskLevelStats,
  getUserSavedWords,
  getUserWordStatuses,
  syncUserSavedWord,
  syncUserWordStatus,
  getUserProfile,
  syncLearningSession,
  syncDailyGoal,
  getUserDailyGoals,
  getUserLearningSessions,
  getUserStats,
  getUserSettings,
  syncUserSettings,
  getUserAchievements,
  unlockAchievement,
  searchVocabulary,
  getUserDailyGoalsRange,
  getUserLearningSessionsRange,
} from '../config/database.js';

const router = express.Router();

// ═══════════════════════════════════════════════════════════════════════════
// 📚 GET /api/vocab/levels — HSK level stats (word count per level)
// ═══════════════════════════════════════════════════════════════════════════
router.get('/levels', async (req, res) => {
  try {
    const stats = await getHskLevelStats();
    res.json({ levels: stats });
  } catch (err) {
    console.error('Get HSK levels error:', err);
    res.status(500).json({ error: 'Failed to fetch HSK levels' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 📖 GET /api/vocab/hsk/:level — Get all words for a specific HSK level
// ═══════════════════════════════════════════════════════════════════════════
router.get('/hsk/:level', async (req, res) => {
  try {
    const level = parseInt(req.params.level);
    if (isNaN(level) || level < 1 || level > 7) {
      return res.status(400).json({ error: 'Invalid HSK level (1-7)' });
    }

    const words = await getVocabularyByLevel(level);
    res.json({
      hskLevel: level,
      count: words.length,
      words: words.map(w => ({
        id: w.vocab_id,
        hskLevel: w.hsk_level,
        hanzi: w.hanzi,
        pinyin: w.pinyin,
        meaning: w.meaning || '',
        meaningEn: w.meaning_en || '',
        meaningMy: w.meaning_my || '',
        example: w.example || '',
        audioAsset: w.audio_asset || '',
      })),
    });
  } catch (err) {
    console.error('Get vocabulary error:', err);
    res.status(500).json({ error: 'Failed to fetch vocabulary' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// � GET /api/vocab/search?q=xxx — Search vocabulary across all levels
// ═══════════════════════════════════════════════════════════════════════════
router.get('/search', async (req, res) => {
  try {
    const query = req.query.q;
    if (!query || query.trim().length === 0) {
      return res.json({ results: [] });
    }
    const words = await searchVocabulary(query.trim());
    res.json({
      query: query.trim(),
      count: words.length,
      results: words.map(w => ({
        id: w.vocab_id,
        hskLevel: w.hsk_level,
        hanzi: w.hanzi,
        pinyin: w.pinyin,
        meaning: w.meaning || '',
        meaningEn: w.meaning_en || '',
        meaningMy: w.meaning_my || '',
        example: w.example || '',
        audioAsset: w.audio_asset || '',
      })),
    });
  } catch (err) {
    console.error('Search vocabulary error:', err);
    res.status(500).json({ error: 'Failed to search vocabulary' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// �👤 GET /api/vocab/user/:userId/profile — Get user profile + stats
// ═══════════════════════════════════════════════════════════════════════════
router.get('/user/:userId/profile', async (req, res) => {
  try {
    const profile = await getUserProfile(req.params.userId);
    if (!profile) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.json({
      userId: profile.user_id,
      email: profile.email,
      firstName: profile.first_name,
      lastName: profile.last_name,
      phone: profile.phone,
      countryCode: profile.country_code,
      isPaid: profile.is_paid === 1,
      promoCodeUsed: profile.promo_code_used,
      paidAt: profile.paid_at,
      savedCount: profile.saved_count,
      masteredCount: profile.mastered_count,
      skippedCount: profile.skipped_count,
      totalLearned: profile.total_learned,
    });
  } catch (err) {
    console.error('Get user profile error:', err);
    res.status(500).json({ error: 'Failed to fetch profile' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// ⭐ GET /api/vocab/user/:userId/saved — Get user's saved words
// ═══════════════════════════════════════════════════════════════════════════
router.get('/user/:userId/saved', async (req, res) => {
  try {
    const words = await getUserSavedWords(req.params.userId);
    res.json({
      savedWords: words.map(w => ({
        id: w.vocab_id,
        hskLevel: w.hsk_level,
        hanzi: w.hanzi,
        pinyin: w.pinyin,
        meaning: w.meaning || '',
        meaningEn: w.meaning_en || '',
        meaningMy: w.meaning_my || '',
        example: w.example || '',
        audioAsset: w.audio_asset || '',
      })),
    });
  } catch (err) {
    console.error('Get saved words error:', err);
    res.status(500).json({ error: 'Failed to fetch saved words' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 📊 GET /api/vocab/user/:userId/statuses — Get word statuses (skipped/mastered)
// ═══════════════════════════════════════════════════════════════════════════
router.get('/user/:userId/statuses', async (req, res) => {
  try {
    const statuses = await getUserWordStatuses(req.params.userId);
    res.json({ statuses });
  } catch (err) {
    console.error('Get word statuses error:', err);
    res.status(500).json({ error: 'Failed to fetch word statuses' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 🔄 POST /api/vocab/sync — Sync all user data from app to server
// ═══════════════════════════════════════════════════════════════════════════
router.post('/sync', async (req, res) => {
  try {
    console.log('🔄 Sync request received');
    console.log('📊 Request body:', JSON.stringify(req.body, null, 2));

    const { userId, savedWords, wordStatuses, learningSessions, dailyGoals } = req.body;

    if (!userId) {
      console.log('❌ Missing userId');
      return res.status(400).json({ error: 'userId is required' });
    }

    console.log(`👤 Syncing for user: ${userId}`);
    console.log(`📚 Saved words: ${savedWords?.length || 0}`);
    console.log(`📊 Word statuses: ${wordStatuses?.length || 0}`);
    console.log(`📅 Learning sessions: ${learningSessions?.length || 0}`);
    console.log(`🎯 Daily goals: ${dailyGoals?.length || 0}`);

    // Sync saved words
    if (Array.isArray(savedWords)) {
      for (const vocabId of savedWords) {
        await syncUserSavedWord(userId, vocabId);
      }
      console.log(`✅ Synced ${savedWords.length} saved words`);
    }

    // Sync word statuses (skipped/mastered)
    if (Array.isArray(wordStatuses)) {
      for (const ws of wordStatuses) {
        await syncUserWordStatus(userId, ws.vocabId, ws.status);
      }
      console.log(`✅ Synced ${wordStatuses.length} word statuses`);
    }

    // Sync learning sessions
    if (Array.isArray(learningSessions)) {
      for (const ls of learningSessions) {
        await syncLearningSession(
          userId, ls.sessionDate, ls.learnedCards, ls.minutesSpent, ls.hskLevel
        );
      }
      console.log(`✅ Synced ${learningSessions.length} learning sessions`);
    }

    // Sync daily goals
    if (Array.isArray(dailyGoals)) {
      for (const dg of dailyGoals) {
        await syncDailyGoal(
          userId, dg.goalDate, dg.targetCards, dg.completedCards, dg.isCompleted
        );
      }
      console.log(`✅ Synced ${dailyGoals.length} daily goals`);
    }

    console.log('🎉 Sync completed successfully');
    res.json({ success: true, message: 'Data synced successfully' });
  } catch (err) {
    console.error('❌ Sync error:', err);
    console.error('❌ Error stack:', err.stack);
    res.status(500).json({ 
      error: 'Sync failed', 
      details: err.message,
      stack: err.stack 
    });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 DAILY GOALS & LEARNING SESSIONS
// ═══════════════════════════════════════════════════════════════════════════

router.get('/user/:userId/goals', async (req, res) => {
  try {
    const { userId } = req.params;
    const { start, end } = req.query;
    
    if (start && end) {
      const goals = await getUserDailyGoalsRange(userId, start, end);
      return res.json({ success: true, goals });
    }
    
    const goals = await getUserDailyGoals(userId);
    res.json({ success: true, goals });
  } catch (err) {
    console.error('Get daily goals error:', err);
    res.status(500).json({ error: 'Failed to fetch daily goals' });
  }
});

router.get('/user/:userId/sessions-range', async (req, res) => {
  try {
    const { userId } = req.params;
    const { start, end } = req.query;
    if (!start || !end) {
      return res.status(400).json({ error: 'start and end dates are required' });
    }
    const sessions = await getUserLearningSessionsRange(userId, start, end);
    res.json({ success: true, sessions });
  } catch (err) {
    console.error('Get learning sessions range error:', err);
    res.status(500).json({ error: 'Failed to fetch learning sessions' });
  }
});

router.get('/user/:userId/sessions', async (req, res) => {
  try {
    const { userId } = req.params;
    const sessions = await getUserLearningSessions(userId);
    res.json({ success: true, sessions });
  } catch (err) {
    console.error('Get learning sessions error:', err);
    res.status(500).json({ error: 'Failed to fetch learning sessions' });
  }
});

router.get('/user/:userId/stats', async (req, res) => {
  try {
    const { userId } = req.params;
    const stats = await getUserStats(userId);
    res.json({ success: true, stats });
  } catch (err) {
    console.error('Get user stats error:', err);
    res.status(500).json({ error: 'Failed to fetch user stats' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// ⚙️ USER SETTINGS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GET /api/vocab/user/:userId/settings
 * Get user settings
 */
router.get('/user/:userId/settings', async (req, res) => {
  try {
    const { userId } = req.params;
    const settings = await getUserSettings(userId);
    
    if (!settings) {
      return res.json({
        success: true,
        settings: {
          appLanguage: 'english',
          currentHskLevel: 1,
          dailyGoalTarget: 10,
          isShuffleMode: false,
          notificationEnabled: true,
          reminderTime: '09:00:00'
        }
      });
    }

    res.json({
      success: true,
      settings: {
        appLanguage: settings.app_language,
        currentHskLevel: settings.current_hsk_level,
        dailyGoalTarget: settings.daily_goal_target,
        isShuffleMode: !!settings.is_shuffle_mode,
        notificationEnabled: !!settings.notification_enabled,
        reminderTime: settings.reminder_time
      }
    });
  } catch (err) {
    console.error('Get user settings error:', err);
    res.status(500).json({ error: 'Failed to get user settings' });
  }
});

/**
 * POST /api/vocab/user/:userId/settings
 * Sync user settings
 */
router.post('/user/:userId/settings', async (req, res) => {
  try {
    const { userId } = req.params;
    const { settings } = req.body;

    if (!settings) {
      return res.status(400).json({ error: 'Settings data is required' });
    }

    await syncUserSettings(userId, settings);
    
    res.json({
      success: true,
      message: 'Settings synced successfully'
    });
  } catch (err) {
    console.error('Sync user settings error:', err);
    res.status(500).json({ error: 'Failed to sync user settings' });
  }
});

// ═══════════════════════════════════════════════════════════════════════════
// 🏆 USER ACHIEVEMENTS
// ═══════════════════════════════════════════════════════════════════════════

/**
 * GET /api/vocab/user/:userId/achievements
 * Get user achievements
 */
router.get('/user/:userId/achievements', async (req, res) => {
  try {
    const { userId } = req.params;
    const achievements = await getUserAchievements(userId);
    
    res.json({
      success: true,
      achievements: achievements.map(a => ({
        achievementKey: a.achievement_key,
        unlockedAt: a.unlocked_at
      }))
    });
  } catch (err) {
    console.error('Get user achievements error:', err);
    res.status(500).json({ error: 'Failed to get user achievements' });
  }
});

/**
 * POST /api/vocab/user/:userId/achievements
 * Unlock achievement
 */
router.post('/user/:userId/achievements', async (req, res) => {
  try {
    const { userId } = req.params;
    const { achievementKey } = req.body;

    if (!achievementKey) {
      return res.status(400).json({ error: 'Achievement key is required' });
    }

    await unlockAchievement(userId, achievementKey);
    
    res.json({
      success: true,
      message: 'Achievement unlocked successfully'
    });
  } catch (err) {
    console.error('Unlock achievement error:', err);
    res.status(500).json({ error: 'Failed to unlock achievement' });
  }
});

export default router;
