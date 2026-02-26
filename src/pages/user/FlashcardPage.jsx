import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, RotateCcw, ChevronLeft, ChevronRight, Shuffle, BookmarkCheck, Bookmark, Check, X as XIcon, Volume2, Lock } from 'lucide-react'
import WebLayout from '../../components/WebLayout'

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
            <p className="text-gray-500 text-sm mb-4">No words available for this level</p>
            <button onClick={() => navigate('/dashboard')} className="px-6 py-3 rounded-xl gradient-primary text-white font-bold text-sm cursor-pointer">
              Back to Dashboard
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
              <h1 className="text-lg font-black text-gray-900">HSK {levelNum} Flashcards</h1>
              <p className="text-sm text-gray-400">{currentIndex + 1} of {words.length}</p>
            </div>
          </div>
          <button onClick={shuffleWords}
            className="flex items-center gap-2 px-4 py-2 rounded-xl bg-white shadow-sm border border-gray-200 text-sm text-gray-600 font-medium hover:bg-gray-50 transition-colors cursor-pointer">
            <Shuffle size={16} />
            Shuffle
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
                <p className="text-xs text-gray-300">Click to reveal meaning</p>
              </div>
            ) : (
              <div className="text-center animate-fade-in w-full">
                <div className="flex items-center justify-center gap-2 mb-2">
                  <p className="text-4xl font-bold text-gray-900">{currentWord.hanzi}</p>
                  <button
                    onClick={(e) => { e.stopPropagation(); speakChinese(currentWord.hanzi) }}
                    className="w-8 h-8 rounded-full bg-blue-50 flex items-center justify-center hover:bg-blue-100 transition-colors cursor-pointer flex-shrink-0"
                    title="Listen">
                    <Volume2 size={14} className="text-blue-500" />
                  </button>
                </div>
                <p className="text-sm text-gray-400 mb-6">{currentWord.pinyin}</p>
                <div className="space-y-3 w-full">
                  {currentWord.meaningEn && (
                    <div className="px-4 py-2.5 rounded-xl bg-blue-50">
                      <span className="text-xs font-bold text-blue-400 block mb-0.5">English</span>
                      <span className="text-sm font-medium text-blue-700">{currentWord.meaningEn}</span>
                    </div>
                  )}
                  {currentWord.meaningMy && (
                    <div className="px-4 py-2.5 rounded-xl bg-green-50">
                      <span className="text-xs font-bold text-green-400 block mb-0.5">Myanmar</span>
                      <span className="text-sm font-medium text-green-700">{currentWord.meaningMy}</span>
                    </div>
                  )}
                  {currentWord.meaning && currentWord.meaning !== currentWord.meaningEn && (
                    <div className="px-4 py-2.5 rounded-xl bg-purple-50">
                      <span className="text-xs font-bold text-purple-400 block mb-0.5">Thai</span>
                      <span className="text-sm font-medium text-purple-700">{currentWord.meaning}</span>
                    </div>
                  )}
                </div>
                
                {/* Example sentences with audio */}
                {currentWord.example && (
                  <div className="mt-4 p-3 rounded-xl bg-gray-50 border border-gray-100">
                    <p className="text-xs font-medium text-gray-400 mb-2">Example Sentences</p>
                    <div className="space-y-2">
                      {currentWord.example.split('\n').filter(line => line.trim()).map((line, index) => {
                        // Check if line contains Chinese characters
                        const hasChinese = /[\u4e00-\u9fff]/.test(line)
                        // Only show Chinese lines
                        return hasChinese ? (
                          <div key={index} className="flex items-start gap-2">
                            <button
                              onClick={(e) => { e.stopPropagation(); speakChinese(line.trim()) }}
                              className="w-6 h-6 rounded-md bg-blue-50 flex items-center justify-center hover:bg-blue-100 transition-colors cursor-pointer flex-shrink-0 mt-0.5"
                              title="Listen to example">
                              <Volume2 size={10} className="text-blue-500" />
                            </button>
                            <span className="text-sm text-gray-700">{line.trim()}</span>
                          </div>
                        ) : null
                      })}
                    </div>
                  </div>
                )}
                
                <p className="text-xs text-gray-300 mt-6">Click to flip back</p>
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
              Previous
            </button>
            <button onClick={() => setIsFlipped(!isFlipped)}
              className="w-10 h-10 rounded-xl bg-white border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
              <RotateCcw size={16} className="text-gray-500" />
            </button>
            <button onClick={goNext} disabled={currentIndex >= words.length - 1}
              className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-white border border-gray-200 text-sm text-gray-600 font-medium disabled:opacity-30 hover:bg-gray-50 transition-colors cursor-pointer disabled:cursor-not-allowed">
              Next
              <ChevronRight size={16} />
            </button>
          </div>

          {/* Stats */}
          <div className="flex items-center justify-center gap-4 text-sm text-gray-400">
            <span>{learned.size} learned</span>
            <span>·</span>
            <span>{savedWords.size} saved</span>
          </div>
        </div>
      </div>
    </WebLayout>
  )
}
