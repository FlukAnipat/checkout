import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, Play, Bookmark, BookmarkCheck, Search, X, LogIn } from 'lucide-react'
import WebLayout from '../../components/WebLayout'

const HSK_COLORS = {
  1: { gradient: 'from-red-500 to-red-600', light: 'bg-red-50', text: 'text-red-600' },
  2: { gradient: 'from-orange-500 to-orange-600', light: 'bg-orange-50', text: 'text-orange-600' },
  3: { gradient: 'from-yellow-500 to-yellow-600', light: 'bg-yellow-50', text: 'text-yellow-600' },
  4: { gradient: 'from-green-500 to-green-600', light: 'bg-green-50', text: 'text-green-600' },
  5: { gradient: 'from-blue-500 to-blue-600', light: 'bg-blue-50', text: 'text-blue-600' },
  6: { gradient: 'from-purple-500 to-purple-600', light: 'bg-purple-50', text: 'text-purple-600' },
}

export default function HskLevelPage() {
  const navigate = useNavigate()
  const { level } = useParams()
  const levelNum = parseInt(level)
  const colors = HSK_COLORS[levelNum] || HSK_COLORS[1]

  const [words, setWords] = useState([])
  const [loading, setLoading] = useState(true)
  const [expandedWord, setExpandedWord] = useState(null)
  const [searchQuery, setSearchQuery] = useState('')
  const [savedWords, setSavedWords] = useState(new Set())

  const token = localStorage.getItem('sf_token')
  const isGuest = !token
  const user = !isGuest ? JSON.parse(localStorage.getItem('sf_user') || '{}') : {}

  useEffect(() => {
    loadWords()
    if (!isGuest) loadSavedWords()
  }, [levelNum])

  const loadWords = async () => {
    try {
      const res = await vocabAPI.getByLevel(levelNum)
      setWords(res.data.words || [])
    } catch (err) {
      console.error('Failed to load words:', err)
    } finally {
      setLoading(false)
    }
  }

  const loadSavedWords = async () => {
    try {
      const userId = user.user_id || user.userId
      if (!userId) return
      const res = await vocabAPI.getSavedWords(userId)
      const saved = new Set((res.data.savedWords || []).map(w => w.vocab_id || w.vocabId))
      setSavedWords(saved)
    } catch (err) {
      console.error('Failed to load saved words:', err)
    }
  }

  const toggleSaveWord = async (vocabId) => {
    if (isGuest) { navigate('/login'); return }
    const userId = user.user_id || user.userId
    if (!userId) return

    const newSaved = new Set(savedWords)
    if (newSaved.has(vocabId)) {
      newSaved.delete(vocabId)
      try { await vocabAPI.unsaveWord(userId, vocabId) } catch (e) {}
    } else {
      newSaved.add(vocabId)
      try { await vocabAPI.saveWord(userId, vocabId) } catch (e) {}
    }
    setSavedWords(newSaved)
  }

  const filteredWords = words.filter(w => {
    if (!searchQuery) return true
    const q = searchQuery.toLowerCase()
    return (
      w.hanzi?.includes(q) ||
      w.pinyin?.toLowerCase().includes(q) ||
      w.meaningEn?.toLowerCase().includes(q) ||
      w.meaningMy?.toLowerCase().includes(q) ||
      w.meaning?.toLowerCase().includes(q)
    )
  })

  if (loading) {
    return (
      <WebLayout>
        <div className="flex items-center justify-center min-h-[60vh]">
          <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
        </div>
      </WebLayout>
    )
  }

  return (
    <WebLayout>
      {/* Header Bar */}
      <div className={`bg-gradient-to-r ${colors.gradient}`}>
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div className="flex items-center gap-4">
              <button onClick={() => navigate('/dashboard')}
                className="w-10 h-10 rounded-xl bg-white/20 flex items-center justify-center hover:bg-white/30 transition-colors cursor-pointer">
                <ArrowLeft size={18} className="text-white" />
              </button>
              <div>
                <h1 className="text-2xl font-black text-white">HSK {levelNum}</h1>
                <p className="text-sm text-white/70">{words.length} vocabulary words</p>
              </div>
            </div>
            <div className="flex items-center gap-3">
              {/* Search */}
              <div className="relative flex-1 sm:w-64">
                <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-white/50" />
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Search words..."
                  className="w-full pl-9 pr-9 py-2.5 rounded-xl bg-white/15 text-white text-sm placeholder-white/50 border border-white/10 outline-none focus:bg-white/20 transition-all"
                />
                {searchQuery && (
                  <button onClick={() => setSearchQuery('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-white/50 cursor-pointer">
                    <X size={16} />
                  </button>
                )}
              </div>
              <button onClick={() => navigate(`/flashcard/${levelNum}`)}
                className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-white/20 text-white text-sm font-bold hover:bg-white/30 transition-colors cursor-pointer">
                <Play size={16} />
                Flashcards
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Word Cards Grid */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          {filteredWords.length === 0 ? (
            <div className="col-span-full bg-white rounded-2xl p-8 shadow-sm text-center">
              <p className="text-gray-400 text-sm">No words found</p>
            </div>
          ) : (
            filteredWords.map((word, index) => {
              const isExpanded = expandedWord === word.id
              const isSaved = savedWords.has(word.id)

              return (
                <div key={word.id}
                  className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden transition-all hover:shadow-md">
                  <div className="p-4">
                    <div className="flex items-start justify-between mb-3">
                      <div className={`w-8 h-8 rounded-lg ${colors.light} flex items-center justify-center flex-shrink-0`}>
                        <span className={`text-xs font-bold ${colors.text}`}>{index + 1}</span>
                      </div>
                      <button onClick={() => toggleSaveWord(word.id)}
                        className={`w-8 h-8 rounded-lg flex items-center justify-center transition-colors cursor-pointer flex-shrink-0
                          ${isGuest ? 'text-gray-300 hover:text-gray-400' : (isSaved ? 'bg-amber-50 text-amber-500' : 'text-gray-300 hover:text-gray-400')}
                        `}>
                        {!isGuest && isSaved ? <BookmarkCheck size={16} /> : <Bookmark size={16} />}
                      </button>
                    </div>

                    <div className="text-center mb-3">
                      <div className="text-2xl font-bold text-gray-900 mb-1">{word.hanzi}</div>
                      <div className="text-sm text-gray-400 mb-2">{word.pinyin}</div>
                      <div className="text-xs text-gray-500 line-clamp-2">
                        {word.meaningEn || word.meaning}
                      </div>
                    </div>

                    <button onClick={() => setExpandedWord(isExpanded ? null : word.id)}
                      className="w-full py-2 rounded-lg bg-gray-50 text-xs text-gray-600 font-medium hover:bg-gray-100 transition-colors cursor-pointer">
                      {isExpanded ? 'Show Less' : 'Show More'}
                    </button>
                  </div>

                  {isExpanded && (
                    <div className="px-4 pb-4 border-t border-gray-50 pt-3 animate-fade-in">
                      <div className="space-y-2 mb-3">
                        {word.meaningEn && (
                          <div className="flex items-start gap-2">
                            <span className="text-[10px] font-bold text-blue-500 bg-blue-50 px-1.5 py-0.5 rounded mt-0.5">EN</span>
                            <span className="text-xs text-gray-700">{word.meaningEn}</span>
                          </div>
                        )}
                        {word.meaningMy && (
                          <div className="flex items-start gap-2">
                            <span className="text-[10px] font-bold text-green-500 bg-green-50 px-1.5 py-0.5 rounded mt-0.5">MY</span>
                            <span className="text-xs text-gray-700">{word.meaningMy}</span>
                          </div>
                        )}
                        {word.meaning && word.meaning !== word.meaningEn && (
                          <div className="flex items-start gap-2">
                            <span className="text-[10px] font-bold text-purple-500 bg-purple-50 px-1.5 py-0.5 rounded mt-0.5">TH</span>
                            <span className="text-xs text-gray-700">{word.meaning}</span>
                          </div>
                        )}
                      </div>
                      {word.example && (
                        <div className="p-2 rounded-lg bg-gray-50 border border-gray-100">
                          <p className="text-[10px] font-medium text-gray-400 mb-1">Example</p>
                          <p className="text-xs text-gray-700 whitespace-pre-line leading-relaxed">{word.example}</p>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              )
            })
          )}
        </div>
      </div>
    </WebLayout>
  )
}
