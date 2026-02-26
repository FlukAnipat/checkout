import { createContext, useContext, useState, useEffect } from 'react'

// ═══════════════════════════════════════════════════════════════════════════
// UI STRINGS (matching Flutter app_strings.dart)
// ═══════════════════════════════════════════════════════════════════════════
const APP_STRINGS = {
  // App
  appName: { en: 'HSK Shwe Flash', my: 'HSK Shwe Flash' },
  appTagline: { en: 'Master Chinese with Flash Cards', my: 'Flash Card များဖြင့် တရုတ်စာ လေ့လာပါ' },
  // Greetings
  goodMorning: { en: 'Good Morning', my: 'မင်္ဂလာနံနက်ခင်းပါ' },
  goodAfternoon: { en: 'Good Afternoon', my: 'မင်္ဂလာနေ့လည်ခင်းပါ' },
  goodEvening: { en: 'Good Evening', my: 'မင်္ဂလာညနေခင်းပါ' },
  // Daily Progress
  dailyProgress: { en: 'DAILY PROGRESS', my: 'နေ့စဉ်တိုးတက်မှု' },
  editGoal: { en: 'Edit Goal', my: 'ပန်းတိုင်ပြင်ဆင်ရန်' },
  cards: { en: 'cards', my: 'ကတ်များ' },
  cardsLearned: { en: 'Cards Learned', my: 'လေ့လာပြီးသော ကတ်များ' },
  todayGoal: { en: "Today's Goal", my: 'ယနေ့ပန်းတိုင်' },
  completed: { en: 'Completed!', my: 'ပြီးဆုံးပါပြီ!' },
  // HSK Levels
  selectLevel: { en: 'Select Level', my: 'အဆင့်ရွေးချယ်ပါ' },
  chooseHskLevel: { en: 'Choose your HSK level', my: 'သင်၏ HSK အဆင့်ကို ရွေးချယ်ပါ' },
  level: { en: 'Level', my: 'အဆင့်' },
  words: { en: 'words', my: 'စကားလုံးများ' },
  wordOf: { en: 'Word', my: 'စကားလုံး' },
  of: { en: 'of', my: '/' },
  // Learning
  startLearning: { en: 'Start Learning', my: 'စတင်လေ့လာမည်' },
  continueLearning: { en: 'Continue Learning', my: 'ဆက်လက်လေ့လာမည်' },
  sessionComplete: { en: 'Session Complete! Great job!', my: 'လေ့လာမှုပြီးဆုံးပါပြီ! ကောင်းလိုက်တာ!' },
  // Flashcard
  tapToFlip: { en: 'Tap to flip', my: 'လှန်ရန် နှိပ်ပါ' },
  correct: { en: 'Correct', my: 'မှန်ပါသည်' },
  wrong: { en: 'Wrong', my: 'မှားပါသည်' },
  saved: { en: 'Saved', my: 'သိမ်းပြီး' },
  example: { en: 'Example', my: 'ဥပမာ' },
  meaning: { en: 'Meaning', my: 'အဓိပ္ပာယ်' },
  definition: { en: 'DEFINITION', my: 'အဓိပ္ပာယ်' },
  flipCard: { en: 'Flip Card', my: 'ကတ်လှန်ရန်' },
  // Saved
  savedWords: { en: 'Saved Words', my: 'သိမ်းထားသောစကားလုံးများ' },
  noSavedWords: { en: 'No saved words yet', my: 'သိမ်းထားသောစကားလုံး မရှိသေးပါ' },
  // Profile
  profile: { en: 'Profile', my: 'ပရိုဖိုင်' },
  guest: { en: 'Guest', my: 'ဧည့်သည်' },
  settings: { en: 'Settings', my: 'ဆက်တင်များ' },
  language: { en: 'Language', my: 'ဘာသာစကား' },
  selectLanguage: { en: 'Select Language', my: 'ဘာသာစကားရွေးချယ်ပါ' },
  about: { en: 'About', my: 'အကြောင်း' },
  appInfo: { en: 'App version and information', my: 'အက်ပ်ဗားရှင်းနှင့် အချက်အလက်' },
  logout: { en: 'Logout', my: 'ထွက်ရန်' },
  login: { en: 'Login', my: 'ဝင်ရန်' },
  signUp: { en: 'Sign Up', my: 'စာရင်းသွင်းရန်' },
  premium: { en: 'Premium', my: 'ပရီမီယံ' },
  premiumMember: { en: 'Premium Member', my: 'ပရီမီယံအသင်းဝင်' },
  free: { en: 'Free', my: 'အခမဲ့' },
  guestMode: { en: 'Guest Mode', my: 'ဧည့်သည်မုဒ်' },
  upgradeToPremium: { en: 'Upgrade to Premium', my: 'ပရီမီယံသို့အဆင့်မြှင့်ရန်' },
  unlockAll: { en: 'Unlock All', my: 'အားလုံးဖွင့်ရန်' },
  // Stats
  statistics: { en: 'Statistics', my: 'စာရင်းအင်း' },
  totalLearned: { en: 'Total Learned', my: 'စုစုပေါင်းလေ့လာပြီး' },
  dayStreak: { en: 'Day Streak', my: 'ရက်ဆက်တိုက်' },
  days: { en: 'days', my: 'ရက်' },
  totalWords: { en: 'Total Words', my: 'စုစုပေါင်းစကားလုံး' },
  learned: { en: 'Learned', my: 'လေ့လာပြီး' },
  remaining: { en: 'Remaining', my: 'ကျန်ရှိ' },
  progress: { en: 'Progress', my: 'တိုးတက်မှု' },
  // Calendar
  calendar: { en: 'Calendar', my: 'ပြက္ခဒိန်' },
  learningCalendar: { en: 'Learning Calendar', my: 'လေ့လာမှုပြက္ခဒိန်' },
  trackDailyProgress: { en: 'Track your daily progress', my: 'သင်၏နေ့စဉ်တိုးတက်မှုကို ခြေရာခံပါ' },
  daysCompleted: { en: 'Days Completed', my: 'ပြီးဆုံးသောရက်များ' },
  totalCards: { en: 'Total Cards', my: 'စုစုပေါင်းကတ်များ' },
  goalCompleted: { en: 'Goal Completed! 🎉', my: 'ပန်းတိုင်ပြည့်မီပါပြီ! 🎉' },
  goalNotMet: { en: 'Goal Not Met', my: 'ပန်းတိုင်မပြည့်မီပါ' },
  noActivity: { en: 'No Activity', my: 'လှုပ်ရှားမှုမရှိ' },
  completedStatus: { en: 'Completed', my: 'ပြီးဆုံး' },
  incompleteStatus: { en: 'Incomplete', my: 'မပြီးသေး' },
  cardsLabel: { en: 'Cards', my: 'ကတ်များ' },
  minutesLabel: { en: 'Minutes', my: 'မိနစ်' },
  // Months
  january: { en: 'January', my: 'ဇန်နဝါရီ' },
  february: { en: 'February', my: 'ဖေဖော်ဝါရီ' },
  march: { en: 'March', my: 'မတ်' },
  april: { en: 'April', my: 'ဧပြီ' },
  may: { en: 'May', my: 'မေ' },
  june: { en: 'June', my: 'ဇွန်' },
  july: { en: 'July', my: 'ဇူလိုင်' },
  august: { en: 'August', my: 'သြဂုတ်' },
  september: { en: 'September', my: 'စက်တင်ဘာ' },
  october: { en: 'October', my: 'အောက်တိုဘာ' },
  november: { en: 'November', my: 'နိုဝင်ဘာ' },
  december: { en: 'December', my: 'ဒီဇင်ဘာ' },
  // Days
  monday: { en: 'Mon', my: 'တနင်္လာ' },
  tuesday: { en: 'Tue', my: 'အင်္ဂါ' },
  wednesday: { en: 'Wed', my: 'ဗုဒ္ဓဟူး' },
  thursday: { en: 'Thu', my: 'ကြာသပတေး' },
  friday: { en: 'Fri', my: 'သောကြာ' },
  saturday: { en: 'Sat', my: 'စနေ' },
  sunday: { en: 'Sun', my: 'တနင်္ဂနွေ' },
  // Common
  cancel: { en: 'Cancel', my: 'ပယ်ဖျက်' },
  save: { en: 'Save', my: 'သိမ်းမည်' },
  confirm: { en: 'Confirm', my: 'အတည်ပြု' },
  ok: { en: 'OK', my: 'အိုကေ' },
  loading: { en: 'Loading...', my: 'ဖွင့်နေသည်...' },
  error: { en: 'Error', my: 'အမှား' },
  success: { en: 'Success', my: 'အောင်မြင်သည်' },
  home: { en: 'Home', my: 'ပင်မ' },
  search: { en: 'Search', my: 'ရှာဖွေ' },
  previous: { en: 'Previous', my: 'ယခင်' },
  next: { en: 'Next', my: 'နောက်' },
  shuffle: { en: 'Shuffle', my: 'ရောမွှေ' },
  flashcards: { en: 'Flashcards', my: 'Flash ကတ်များ' },
  study: { en: 'Study', my: 'လေ့လာ' },
  locked: { en: 'Locked', my: 'သော့ပိတ်' },
  available: { en: 'Available', my: 'ရနိုင်သည်' },
  showMore: { en: 'Show More', my: 'ပိုပြ' },
  showLess: { en: 'Show Less', my: 'လျော့ပြ' },
  welcomeBack: { en: 'Welcome back', my: 'ပြန်လာတာကြိုဆိုပါတယ်' },
  exploreHskLevels: { en: 'Explore HSK Levels', my: 'HSK အဆင့်များ လေ့လာပါ' },
  continueJourney: { en: 'Continue your Chinese learning journey', my: 'သင်၏ တရုတ်စာ လေ့လာရေးခရီးကို ဆက်လက်ပါ' },
  tryFree: { en: 'Try HSK 1 for free — sign up to unlock all levels', my: 'HSK 1 ကို အခမဲ့စမ်းပါ — အဆင့်အားလုံးဖွင့်ရန် စာရင်းသွင်းပါ' },
  hskLevels: { en: 'HSK Levels', my: 'HSK အဆင့်များ' },
  unlockAllHskLevels: { en: 'Unlock All HSK Levels', my: 'HSK အဆင့်အားလုံး ဖွင့်ရန်' },
  levelsUnlocked: { en: 'Levels Unlocked', my: 'ဖွင့်ထားသောအဆင့်များ' },
  languages: { en: 'Languages', my: 'ဘာသာစကားများ' },
  signUpForFullAccess: { en: 'Sign up for full access', my: 'အပြည့်အဝဝင်ရောက်ရန် စာရင်းသွင်းပါ' },
  premiumRequired: { en: 'Premium required for HSK 2-6', my: 'HSK 2-6 အတွက် ပရီမီယံလိုအပ်သည်' },
  registerFree: { en: 'Register Free', my: 'အခမဲ့စာရင်းသွင်း' },
  upgradeNow: { en: 'Upgrade Now', my: 'ယခုအဆင့်မြှင့်' },
  downloadApp: { en: 'Download App', my: 'အက်ပ်ဒေါင်းလုဒ်' },
  downloadApk: { en: 'Download APK', my: 'APK ဒေါင်းလုဒ်' },
  downloadMobileApp: { en: 'Download the Mobile App', my: 'မိုဘိုင်းအက်ပ် ဒေါင်းလုဒ်လုပ်ပါ' },
  getFullMobileExperience: { en: 'Get the full mobile experience', my: 'မိုဘိုင်းအတွေ့အကြုံ အပြည့်အဝ ရယူပါ' },
  email: { en: 'Email', my: 'အီးမေးလ်' },
  phone: { en: 'Phone', my: 'ဖုန်း' },
  accountType: { en: 'Account Type', my: 'အကောင့်အမျိုးအစား' },
  editProfile: { en: 'Edit Profile', my: 'ပရိုဖိုင်ပြင်ဆင်' },
  firstName: { en: 'First Name', my: 'နာမည်' },
  lastName: { en: 'Last Name', my: 'မျိုးနွယ်အမည်' },
  saveProfile: { en: 'Save Profile', my: 'ပရိုဖိုင်သိမ်းမည်' },
  changePassword: { en: 'Change Password', my: 'စကားဝှက်ပြောင်းရန်' },
  currentPassword: { en: 'Current Password', my: 'လက်ရှိစကားဝှက်' },
  newPassword: { en: 'New Password', my: 'စကားဝှက်အသစ်' },
  unlockFeatures: { en: 'Unlock all HSK levels and features', my: 'HSK အဆင့်နှင့် လုပ်ဆောင်ချက်အားလုံး ဖွင့်ရန်' },
  recentActivity: { en: 'Recent Activity', my: 'မကြာသေးမီ လှုပ်ရှားမှု' },
  studied: { en: 'Studied', my: 'လေ့လာခဲ့သည်' },
  noActivityYet: { en: 'No Activity Yet', my: 'လှုပ်ရှားမှု မရှိသေးပါ' },
  startStudyingFlashcards: { en: 'Start studying flashcards to track your daily progress here.', my: 'ဤနေရာတွင် နေ့စဉ်တိုးတက်မှု ခြေရာခံရန် Flash ကတ်များ စတင်လေ့လာပါ။' },
  goalComplete: { en: 'Goal Complete', my: 'ပန်းတိုင်ပြည့်မီ' },
  activeDay: { en: 'Active Day', my: 'လှုပ်ရှားသောနေ့' },
  goalsMetMonth: { en: 'Goals Met', my: 'ပြည့်မီသောပန်းတိုင်' },
  cardsThisMonth: { en: 'Cards This Month', my: 'ဤလကတ်များ' },
  myProgress: { en: 'My Progress', my: 'ကျွန်ုပ်၏တိုးတက်မှု' },
  startLearningFree: { en: 'Start Learning Free', my: 'အခမဲ့စတင်လေ့လာပါ' },
  masterChinese: { en: 'Master Chinese', my: 'တရုတ်စာကျွမ်းကျင်' },
  hskVocabulary: { en: 'HSK Vocabulary', my: 'HSK စကားလုံးများ' },
  clickToReveal: { en: 'Click to reveal meaning', my: 'အဓိပ္ပာယ်ကြည့်ရန် နှိပ်ပါ' },
  clickToFlipBack: { en: 'Click to flip back', my: 'ပြန်လှန်ရန် နှိပ်ပါ' },
  noWordsAvailable: { en: 'No words available for this level', my: 'ဤအဆင့်အတွက် စကားလုံးမရှိပါ' },
  backToDashboard: { en: 'Back to Dashboard', my: 'ပင်မသို့ပြန်' },
  vocabularyWords: { en: 'vocabulary words', my: 'စကားလုံးများ' },
  searchWords: { en: 'Search words...', my: 'စကားလုံးရှာ...' },
  noWordsFound: { en: 'No words found', my: 'စကားလုံးမတွေ့ပါ' },
  freePreview: { en: 'Free preview', my: 'အခမဲ့ အကြိုကြည့်ရှု' },
  showingOf: { en: 'Showing', my: 'ပြသနေသည်' },
  unlockMoreWords: { en: 'Unlock More Words', my: 'စကားလုံးများ ထပ်ဖွင့်ရန်' },
  searchVocabulary: { en: 'Search vocabulary (hanzi, pinyin, or meaning)...', my: 'စကားလုံးရှာ (hanzi, pinyin, အဓိပ္ပာယ်)...' },
  resultsFound: { en: 'results found', my: 'ရလဒ်တွေ့သည်' },
  noResultsFor: { en: 'No results found for', my: 'ရလဒ်မတွေ့ပါ' },
}

// Language options matching Flutter app
export const LANGUAGES = {
  english: { code: 'EN', name: 'English', nativeName: 'English', flag: '🇬🇧' },
  burmese: { code: 'MY', name: 'Burmese', nativeName: 'မြန်မာ', flag: '🇲🇲' },
  englishAndBurmese: { code: 'EN+MY', name: 'English + Burmese', nativeName: 'English + မြန်မာ', flag: '🇬🇧🇲🇲' },
}

const LanguageContext = createContext()

export function LanguageProvider({ children }) {
  const [language, setLanguage] = useState(() => {
    return localStorage.getItem('sf_language') || 'english'
  })

  useEffect(() => {
    localStorage.setItem('sf_language', language)
  }, [language])

  // Get meaning based on selected language (matches Flutter Vocabulary.getMeaning)
  const getMeaning = (word) => {
    if (!word) return ''
    const en = word.meaning_en || word.meaningEn || word.meaning || ''
    const my = word.meaning_my || word.meaningMy || ''
    const fallback = en || word.hanzi || 'No meaning'

    switch (language) {
      case 'english':
        return en || fallback
      case 'burmese':
        return my || fallback
      case 'englishAndBurmese':
        if (my && en !== my) return `${en || fallback}\n${my}`
        return en || fallback
      default:
        return en || fallback
    }
  }

  // Get example sentences based on selected language (matches Flutter Vocabulary.getExample)
  const getExample = (exampleText) => {
    if (!exampleText) return ''

    const parts = exampleText.split('\n\n')
    const sentences = []

    for (const part of parts) {
      if (!part.trim()) continue
      const lines = part.split('\n')
      if (!lines.length) continue

      let chineseSentence = null
      let englishSentence = null
      let burmeseSentence = null

      for (const line of lines) {
        const trimmed = line.trim()
        if (!trimmed) continue

        // Numbered Chinese sentence
        if (/^\d+\.\s*[\u4e00-\u9fff]/.test(trimmed)) {
          chineseSentence = trimmed
        }
        // English (Latin chars, no Chinese, no Burmese)
        else if (/^[a-zA-Z]/.test(trimmed) && !/[\u4e00-\u9fff]/.test(trimmed) && !/[\u1000-\u109F]/.test(trimmed)) {
          englishSentence = trimmed
        }
        // Burmese
        else if (/[\u1000-\u109F]/.test(trimmed)) {
          burmeseSentence = trimmed
        }
      }

      if (chineseSentence) {
        let sentence = chineseSentence
        switch (language) {
          case 'english':
            if (englishSentence) sentence += '\n' + englishSentence
            break
          case 'burmese':
            if (burmeseSentence) sentence += '\n' + burmeseSentence
            break
          case 'englishAndBurmese':
            if (englishSentence) sentence += '\n' + englishSentence
            if (burmeseSentence) sentence += '\n' + burmeseSentence
            break
        }
        sentences.push(sentence)
      }
    }

    return sentences.join('\n\n')
  }

  // Get language display info
  const currentLang = LANGUAGES[language] || LANGUAGES.english

  // App UI language code (EN or MY) — matches Flutter LanguageProvider.appLangCode
  // For EN+MY: app UI shows English, only vocabulary meaning shows both
  const appLangCode = language === 'burmese' ? 'my' : 'en'

  // Translate UI strings (matches Flutter LanguageProvider.tr)
  const tr = (key) => {
    const entry = APP_STRINGS[key]
    if (!entry) return key
    return entry[appLangCode] || entry['en'] || key
  }

  return (
    <LanguageContext.Provider value={{
      language,
      setLanguage,
      currentLang,
      getMeaning,
      getExample,
      tr,
      appLangCode,
      availableLanguages: Object.entries(LANGUAGES).map(([key, val]) => ({ key, ...val })),
    }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) throw new Error('useLanguage must be used within LanguageProvider')
  return context
}
