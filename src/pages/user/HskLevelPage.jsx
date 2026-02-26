import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, Play, Bookmark, BookmarkCheck, Volume2, ChevronDown, ChevronUp, Search, X } from 'lucide-react'

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

  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')

  useEffect(() => {
    loadWords()
    loadSavedWords()
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
      <div className="app-container flex items-center justify-center min-h-screen">
        <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="app-container pb-6">
      {/* Header */}
      <div className={`bg-gradient-to-r ${colors.gradient} px-5 pt-6 pb-8`}>
        <div className="flex items-center gap-3 mb-4">
          <button onClick={() => navigate('/dashboard')}
            className="w-10 h-10 rounded-xl bg-white/20 flex items-center justify-center hover:bg-white/30 transition-colors cursor-pointer">
            <ArrowLeft size={18} className="text-white" />
          </button>
          <div className="flex-1">
            <h1 className="text-xl font-black text-white">HSK {levelNum}</h1>
            <p className="text-xs text-white/70">{words.length} vocabulary words</p>
          </div>
          <button
            onClick={() => navigate(`/flashcard/${levelNum}`)}
            className="flex items-center gap-1.5 px-4 py-2.5 rounded-xl bg-white/20 text-white text-xs font-bold hover:bg-white/30 transition-colors cursor-pointer"
          >
            <Play size={14} />
            Study
          </button>
        </div>

        {/* Search */}
        <div className="relative">
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
      </div>

      {/* Word List */}
      <div className="px-5 -mt-4 space-y-2">
        {filteredWords.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 shadow-sm text-center">
            <p className="text-gray-400 text-sm">No words found</p>
          </div>
        ) : (
          filteredWords.map((word, index) => {
            const isExpanded = expandedWord === word.id
            const isSaved = savedWords.has(word.id)

            return (
              <div
                key={word.id}
                className="bg-white rounded-2xl shadow-sm border border-gray-50 overflow-hidden transition-all"
              >
                {/* Main row */}
                <button
                  onClick={() => setExpandedWord(isExpanded ? null : word.id)}
                  className="w-full px-4 py-3.5 flex items-center gap-3 text-left cursor-pointer hover:bg-gray-50/50 transition-colors"
                >
                  {/* Number */}
                  <div className={`w-8 h-8 rounded-lg ${colors.light} flex items-center justify-center flex-shrink-0`}>
                    <span className={`text-xs font-bold ${colors.text}`}>{index + 1}</span>
                  </div>

                  {/* Hanzi + Pinyin */}
                  <div className="flex-1 min-w-0">
                    <div className="flex items-baseline gap-2">
                      <span className="text-lg font-bold text-gray-900">{word.hanzi}</span>
                      <span className="text-xs text-gray-400">{word.pinyin}</span>
                    </div>
                    <p className="text-xs text-gray-500 truncate mt-0.5">
                      {word.meaningEn || word.meaning}
                    </p>
                  </div>

                  {/* Actions */}
                  <div className="flex items-center gap-1 flex-shrink-0">
                    <button
                      onClick={(e) => { e.stopPropagation(); toggleSaveWord(word.id) }}
                      className={`w-8 h-8 rounded-lg flex items-center justify-center transition-colors cursor-pointer
                        ${isSaved ? 'bg-amber-50 text-amber-500' : 'text-gray-300 hover:text-gray-400'}
                      `}
                    >
                      {isSaved ? <BookmarkCheck size={16} /> : <Bookmark size={16} />}
                    </button>
                    {isExpanded ? <ChevronUp size={16} className="text-gray-300" /> : <ChevronDown size={16} className="text-gray-300" />}
                  </div>
                </button>

                {/* Expanded details */}
                {isExpanded && (
                  <div className="px-4 pb-4 border-t border-gray-50 pt-3 animate-fade-in">
                    {/* Meanings */}
                    <div className="space-y-2">
                      {word.meaningEn && (
                        <div className="flex items-start gap-2">
                          <span className="text-[10px] font-bold text-blue-500 bg-blue-50 px-1.5 py-0.5 rounded mt-0.5">EN</span>
                          <span className="text-sm text-gray-700">{word.meaningEn}</span>
                        </div>
                      )}
                      {word.meaningMy && (
                        <div className="flex items-start gap-2">
                          <span className="text-[10px] font-bold text-green-500 bg-green-50 px-1.5 py-0.5 rounded mt-0.5">MY</span>
                          <span className="text-sm text-gray-700">{word.meaningMy}</span>
                        </div>
                      )}
                      {word.meaning && word.meaning !== word.meaningEn && (
                        <div className="flex items-start gap-2">
                          <span className="text-[10px] font-bold text-purple-500 bg-purple-50 px-1.5 py-0.5 rounded mt-0.5">TH</span>
                          <span className="text-sm text-gray-700">{word.meaning}</span>
                        </div>
                      )}
                    </div>

                    {/* Example */}
                    {word.example && (
                      <div className="mt-3 p-3 rounded-xl bg-gray-50 border border-gray-100">
                        <p className="text-xs font-medium text-gray-400 mb-1">Example</p>
                        <p className="text-sm text-gray-700 whitespace-pre-line leading-relaxed">{word.example}</p>
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
  )
}
