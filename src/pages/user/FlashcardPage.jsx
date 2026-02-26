import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, RotateCcw, ChevronLeft, ChevronRight, Shuffle, BookmarkCheck, Bookmark, Check, X as XIcon, Volume2, Lock } from 'lucide-react'
import WebLayout from '../../components/WebLayout'
import { useLanguage } from '../../contexts/LanguageContext'

const HSK_COLORS = {
  1: { gradient: 'from-red-500 to-red-600' },
  2: { gradient: 'from-orange-500 to-orange-600' },
  3: { gradient: 'from-yellow-500 to-yellow-600' },
  4: { gradient: 'from-green-500 to-green-600' },
  5: { gradient: 'from-blue-500 to-blue-600' },
  6: { gradient: 'from-purple-500 to-purple-600' },
}

export default function FlashcardPage() {
  const navigate = useNavigate()
  const { level } = useParams()
  const levelNum = parseInt(level)
  const colors = HSK_COLORS[levelNum] || HSK_COLORS[1]

  const [words, setWords] = useState([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [isFlipped, setIsFlipped] = useState(false)
  const [loading, setLoading] = useState(true)
  const [savedWords, setSavedWords] = useState(new Set())
  const [learned, setLearned] = useState(new Set())
  const { language, getMeaning, getExample, currentLang, tr } = useLanguage()

  const FREE_WORD_LIMIT = 20

  const token = localStorage.getItem('sf_token')
  const isGuest = !token
  const user = !isGuest ? JSON.parse(localStorage.getItem('sf_user') || '{}') : {}
  const isPaid = user?.is_paid || user?.isPaid || false
  const isLimited = isGuest || !isPaid

  useEffect(() => {
    loadWords()
  }, [levelNum])

  const loadWords = async () => {
    try {
      const res = await vocabAPI.getByLevel(levelNum)
      const allWords = res.data.words || []
      setWords(isLimited ? allWords.slice(0, FREE_WORD_LIMIT) : allWords)
    } catch (err) {
      console.error('Failed to load words:', err)
    } finally {
      setLoading(false)
    }
  }

  const speakChinese = (text) => {
    if ('speechSynthesis' in window) {
      window.speechSynthesis.cancel()
      const utterance = new SpeechSynthesisUtterance(text)
      utterance.lang = 'zh-CN'
      utterance.rate = 0.8
      window.speechSynthesis.speak(utterance)
    }
  }

  const currentWord = words[currentIndex]
  const progress = words.length > 0 ? ((currentIndex + 1) / words.length) * 100 : 0

  const goNext = () => {
    if (currentIndex < words.length - 1) {
      setCurrentIndex(currentIndex + 1)
      setIsFlipped(false)
    }
  }

  const goPrev = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1)
      setIsFlipped(false)
    }
  }

  const shuffleWords = () => {
    const shuffled = [...words].sort(() => Math.random() - 0.5)
    setWords(shuffled)
    setCurrentIndex(0)
    setIsFlipped(false)
  }

  const markLearned = () => {
    if (currentWord) {
      const newLearned = new Set(learned)
      newLearned.add(currentWord.id)
      setLearned(newLearned)

      // Sync daily goal progress (like Flutter GoalProvider.incrementProgress)
      if (!isGuest) {
        const userId = user.user_id || user.userId
        if (userId) {
          const today = new Date()
          const goalDate = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`
          const completedCards = newLearned.size
          vocabAPI.syncDailyGoal(userId, {
            goalDate,
            targetCards: 10,
            completedCards,
            isCompleted: completedCards >= 10,
          }).catch(() => {})

          vocabAPI.syncLearningSession(userId, {
            sessionDate: goalDate,
            hskLevel: levelNum,
            learnedCards: 1,
            minutesSpent: 0,
          }).catch(() => {})
        }
      }
    }
    goNext()
  }

  const toggleSave = () => {
    if (isGuest) { navigate('/login'); return }
    if (!currentWord) return
    const newSaved = new Set(savedWords)
    if (newSaved.has(currentWord.id)) {
      newSaved.delete(currentWord.id)
    } else {
      newSaved.add(currentWord.id)
    }
    setSavedWords(newSaved)
  }

  if (loading) {
    return (
      <WebLayout>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      </WebLayout>
    )
  }

  if (!currentWord) {
    return (
      <WebLayout>
        <div className="flex items-center justify-center min-h-[60vh] px-5">
          <div className="text-center">
            <p className="text-gray-500 text-sm mb-4">{tr('noWordsAvailable')}</p>
            <button onClick={() => navigate('/dashboard')} className="px-6 py-3 rounded-xl gradient-primary text-white font-bold text-sm cursor-pointer">
              {tr('backToDashboard')}
            </button>
          </div>
        </div>
      </WebLayout>
    )
  }

  return (
    <WebLayout>
      <div className="max-w-3xl mx-auto px-4 sm:px-6 py-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <button onClick={() => navigate(`/hsk/${levelNum}`)}
              className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
              <ArrowLeft size={18} className="text-gray-600" />
            </button>
            <div>
              <h1 className="text-lg font-black text-gray-900">HSK {levelNum} {tr('flashcards')}</h1>
              <p className="text-sm text-gray-400">{currentIndex + 1} {tr('of')} {words.length}</p>
            </div>
          </div>
          <button onClick={shuffleWords}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white shadow-sm border border-gray-200 text-sm text-gray-600 font-medium hover:bg-gray-50 transition-colors cursor-pointer">
            <Shuffle size={16} />
            {tr('shuffle')}
          </button>
        </div>

        {/* Progress Bar */}
        <div className="h-2 bg-gray-100 rounded-full overflow-hidden mb-8">
          <div
            className={`h-full rounded-full bg-gradient-to-r ${colors.gradient} transition-all duration-300`}
            style={{ width: `${progress}%` }}
          />
        </div>

        {/* Flashcard - centered */}
        <div className="flex items-center justify-center mb-8">
          <button
            onClick={() => setIsFlipped(!isFlipped)}
            className="w-full max-w-md aspect-[3/4] rounded-3xl shadow-lg border border-gray-100 bg-white flex flex-col items-center justify-center p-8 cursor-pointer transition-all duration-300 hover:shadow-xl active:scale-[0.98]"
          >
            {!isFlipped ? (
              <div className="text-center animate-fade-in">
                <p className="text-6xl font-bold text-gray-900 mb-4">{currentWord.hanzi}</p>
                <p className="text-lg text-gray-400 mb-4">{currentWord.pinyin}</p>
                <button
                  onClick={(e) => { e.stopPropagation(); speakChinese(currentWord.hanzi) }}
                  className="w-10 h-10 rounded-full bg-blue-50 flex items-center justify-center hover:bg-blue-100 transition-colors cursor-pointer mx-auto mb-4"
                  title="Listen to pronunciation">
                  <Volume2 size={18} className="text-blue-500" />
                </button>
                <p className="text-xs text-gray-300">{tr('clickToReveal')}</p>
              </div>
            ) : (
              <div className="text-center animate-fade-in w-full overflow-y-auto max-h-full">
                {/* DEFINITION header */}
                <div className="inline-block px-3 py-1 rounded-xl bg-indigo-50 border border-indigo-100 mb-4">
                  <span className="text-[9px] font-extrabold tracking-widest text-indigo-400 uppercase">{tr('definition')}</span>
                </div>

                {/* Pinyin */}
                <div className="inline-block px-5 py-2.5 rounded-2xl bg-indigo-50/50 border border-indigo-100 mb-3">
                  <p className="text-2xl font-bold text-indigo-600 tracking-wide">{currentWord.pinyin}</p>
                </div>

                {/* Divider */}
                <div className="h-px mx-8 bg-gradient-to-r from-transparent via-amber-300 to-transparent mb-4" />

                {/* Meaning based on language */}
                <div className="p-4 rounded-2xl bg-white shadow-sm border border-gray-100 mb-4">
                  <p className={`font-bold text-gray-900 whitespace-pre-line ${language === 'englishAndBurmese' ? 'text-base' : 'text-xl'}`}>
                    {getMeaning(currentWord)}
                  </p>
                </div>

                {/* Language badge + Examples */}
                {(() => {
                  const exampleText = getExample(currentWord.example)
                  if (!exampleText) return null

                  const langColors = {
                    english: { primary: 'text-blue-800', bg: 'bg-blue-50', border: 'border-blue-100' },
                    burmese: { primary: 'text-green-700', bg: 'bg-green-50', border: 'border-green-100' },
                    englishAndBurmese: { primary: 'text-purple-700', bg: 'bg-purple-50', border: 'border-purple-100' },
                  }
                  const lc = langColors[language] || langColors.english

                  return (
                    <div className="p-3 text-left">
                      {/* Language header */}
                      <div className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-xl ${lc.bg} mb-3`}>
                        <span className="text-xs">{currentLang.flag}</span>
                        <span className={`text-[10px] font-bold ${lc.primary} tracking-wide`}>{currentLang.nativeName}</span>
                      </div>

                      {/* Example lines */}
                      <div className="space-y-1">
                        {exampleText.split('\n').filter(l => l.trim()).map((line, idx) => {
                          const hasChinese = /[\u4e00-\u9fff]/.test(line)
                          return hasChinese ? (
                            <div key={idx} className="flex items-start gap-2 py-1">
                              <button
                                onClick={(e) => { e.stopPropagation(); speakChinese(line.replace(/^\d+\.\s*/, '').trim()) }}
                                className="w-6 h-6 rounded-full bg-orange-500 flex items-center justify-center hover:bg-orange-600 transition-colors cursor-pointer flex-shrink-0 mt-0.5"
                                title="Listen">
                                <Volume2 size={11} className="text-white" />
                              </button>
                              <span className="text-sm text-gray-800 font-medium">{line.trim()}</span>
                            </div>
                          ) : (
                            <div key={idx} className="pl-8 py-0.5">
                              <span className="text-xs text-gray-500 font-medium">{line.trim()}</span>
                            </div>
                          )
                        })}
                      </div>
                    </div>
                  )
                })()}
                
                <p className="text-xs text-gray-300 mt-4">{tr('clickToFlipBack')}</p>
              </div>
            )}
          </button>
        </div>

        {/* Controls */}
        <div className="space-y-4">
          {/* Action buttons */}
          <div className="flex items-center justify-center gap-4">
            <button onClick={toggleSave}
              className={`w-12 h-12 rounded-2xl flex items-center justify-center transition-all cursor-pointer
                ${!isGuest && savedWords.has(currentWord.id) ? 'bg-amber-50 border-2 border-amber-300 text-amber-500' : 'bg-white border-2 border-gray-200 text-gray-400 hover:border-gray-300'}
              `}>
              {!isGuest && savedWords.has(currentWord.id) ? <BookmarkCheck size={20} /> : <Bookmark size={20} />}
            </button>

            <button onClick={() => { setIsFlipped(false); goNext() }}
              className="w-12 h-12 rounded-2xl bg-red-50 border-2 border-red-200 text-red-400 flex items-center justify-center hover:bg-red-100 transition-all cursor-pointer">
              <XIcon size={20} />
            </button>

            <button onClick={markLearned}
              className="w-12 h-12 rounded-2xl bg-green-50 border-2 border-green-200 text-green-500 flex items-center justify-center hover:bg-green-100 transition-all cursor-pointer">
              <Check size={20} />
            </button>
          </div>

          {/* Navigation */}
          <div className="flex items-center justify-between">
            <button onClick={goPrev} disabled={currentIndex === 0}
              className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-white border border-gray-200 text-sm text-gray-600 font-medium disabled:opacity-30 hover:bg-gray-50 transition-colors cursor-pointer disabled:cursor-not-allowed">
              <ChevronLeft size={16} />
              {tr('previous')}
            </button>
            <button onClick={() => setIsFlipped(!isFlipped)}
              className="w-10 h-10 rounded-xl bg-white border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
              <RotateCcw size={16} className="text-gray-500" />
            </button>
            <button onClick={goNext} disabled={currentIndex >= words.length - 1}
              className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-white border border-gray-200 text-sm text-gray-600 font-medium disabled:opacity-30 hover:bg-gray-50 transition-colors cursor-pointer disabled:cursor-not-allowed">
              {tr('next')}
              <ChevronRight size={16} />
            </button>
          </div>

          {/* Stats */}
          <div className="flex items-center justify-center gap-4 text-sm text-gray-400">
            <span>{learned.size} {tr('learned')}</span>
            <span>·</span>
            <span>{savedWords.size} {tr('saved')}</span>
          </div>
        </div>
      </div>
    </WebLayout>
  )
}
