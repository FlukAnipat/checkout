import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, Bookmark, BookmarkX, Volume2, Check, XCircle, RotateCcw } from 'lucide-react'
import WebLayout from '../../components/WebLayout'
import { useLanguage } from '../../contexts/LanguageContext'

const HSK_COLORS = {
  1: { light: 'bg-red-50', text: 'text-red-600' },
  2: { light: 'bg-orange-50', text: 'text-orange-600' },
  3: { light: 'bg-yellow-50', text: 'text-yellow-600' },
  4: { light: 'bg-green-50', text: 'text-green-600' },
  5: { light: 'bg-blue-50', text: 'text-blue-600' },
  6: { light: 'bg-purple-50', text: 'text-purple-600' },
}

export default function SavedWordsPage() {
  const navigate = useNavigate()
  const { tr, getMeaning } = useLanguage()
  const [savedWords, setSavedWords] = useState([])
  const [wordStatuses, setWordStatuses] = useState([])
  const [allWords, setAllWords] = useState({}) // vocabId -> word data
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('saved') // 'saved' | 'passed' | 'skipped'

  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  const userId = user.user_id || user.userId

  useEffect(() => {
    loadData()
  }, [])

  const loadData = async () => {
    if (!userId) { setLoading(false); return }
    try {
      const [savedRes, statusRes] = await Promise.all([
        vocabAPI.getSavedWords(userId),
        vocabAPI.getWordStatuses(userId),
      ])
      setSavedWords(savedRes.data.savedWords || [])
      setWordStatuses(statusRes.data.statuses || statusRes.data.wordStatuses || [])

      // Build a map of all vocab data from saved + statuses for display
      const map = {}
      for (const w of (savedRes.data.savedWords || [])) {
        const id = w.vocab_id || w.vocabId
        map[id] = w
      }
      // For statuses, we may need to fetch word details from levels
      setAllWords(map)
    } catch (err) {
      console.error('Failed to load data:', err)
    } finally {
      setLoading(false)
    }
  }

  const unsaveWord = async (vocabId) => {
    try {
      await vocabAPI.unsaveWord(userId, vocabId)
      setSavedWords(prev => prev.filter(w => (w.vocab_id || w.vocabId) !== vocabId))
    } catch (err) {
      console.error('Failed to unsave word:', err)
    }
  }

  const removeStatus = async (vocabId, fromStatus) => {
    try {
      // Reset status by setting to empty/null
      await vocabAPI.updateWordStatus(userId, vocabId, 'none')
      setWordStatuses(prev => prev.filter(s => (s.vocab_id || s.vocabId) !== vocabId))
      // Also remove from localStorage
      for (let lvl = 1; lvl <= 6; lvl++) {
        const key = fromStatus === 'learned' ? `sf_passed_${lvl}` : `sf_skipped_${lvl}`
        try {
          const arr = JSON.parse(localStorage.getItem(key) || '[]')
          const filtered = arr.filter(id => id !== vocabId)
          localStorage.setItem(key, JSON.stringify(filtered))
        } catch {}
      }
    } catch (err) {
      console.error('Failed to remove status:', err)
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

  const passedStatuses = wordStatuses.filter(s => (s.status || s.wordStatus) === 'learned')
  const skippedStatuses = wordStatuses.filter(s => (s.status || s.wordStatus) === 'skipped')

  const tabs = [
    { key: 'saved', label: tr('savedWords'), count: savedWords.length, icon: Bookmark, color: 'amber' },
    { key: 'passed', label: tr('passedWords'), count: passedStatuses.length, icon: Check, color: 'green' },
    { key: 'skipped', label: tr('skippedWords'), count: skippedStatuses.length, icon: XCircle, color: 'red' },
  ]

  const renderWordCard = (word, vocabId, actions) => {
    const hskLevel = word.hsk_level || word.hskLevel
    const c = HSK_COLORS[hskLevel] || HSK_COLORS[1]
    return (
      <div key={vocabId} className="bg-white rounded-2xl shadow-sm border border-gray-100 px-5 py-4">
        <div className="flex items-start gap-3">
          <div className="flex-1 min-w-0">
            <div className="flex items-center gap-2 flex-wrap">
              <span className="text-lg font-bold text-gray-900">{word.hanzi}</span>
              <span className="text-xs text-gray-400">{word.pinyin}</span>
              {hskLevel && (
                <span className={`inline-flex items-center px-2 py-0.5 rounded-md text-[10px] font-bold ${c.light} ${c.text}`}>
                  HSK {hskLevel}
                </span>
              )}
              <button
                onClick={() => speakChinese(word.hanzi)}
                className="w-7 h-7 rounded-md bg-blue-50 flex items-center justify-center hover:bg-blue-100 transition-colors cursor-pointer flex-shrink-0"
                title="Listen">
                <Volume2 size={12} className="text-blue-500" />
              </button>
            </div>
            <p className="text-sm text-gray-600 mt-1 whitespace-pre-line line-clamp-2">
              {getMeaning(word)}
            </p>
          </div>
          {actions}
        </div>
      </div>
    )
  }

  const renderEmpty = (icon, title, subtitle) => (
    <div className="text-center py-16">
      <div className="w-16 h-16 rounded-full bg-gray-50 flex items-center justify-center mx-auto mb-4">
        {icon}
      </div>
      <h3 className="text-lg font-bold text-gray-900 mb-1">{title}</h3>
      <p className="text-sm text-gray-400 mb-6">{subtitle}</p>
      <button onClick={() => navigate('/dashboard')}
        className="px-6 py-2.5 rounded-xl gradient-primary text-white text-sm font-bold cursor-pointer">
        {tr('startLearning')}
      </button>
    </div>
  )

  return (
    <WebLayout>
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="flex items-center gap-3 mb-6">
          <button onClick={() => navigate('/dashboard')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <div>
            <h1 className="text-2xl font-black text-gray-900">{tr('savedWords')}</h1>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-2 mb-6 overflow-x-auto pb-1">
          {tabs.map(tab => (
            <button
              key={tab.key}
              onClick={() => setActiveTab(tab.key)}
              className={`flex items-center gap-2 px-4 py-2.5 rounded-xl text-sm font-bold transition-all cursor-pointer whitespace-nowrap
                ${activeTab === tab.key
                  ? tab.color === 'amber' ? 'bg-amber-50 text-amber-600 border-2 border-amber-200'
                    : tab.color === 'green' ? 'bg-green-50 text-green-600 border-2 border-green-200'
                    : 'bg-red-50 text-red-500 border-2 border-red-200'
                  : 'bg-white text-gray-500 border-2 border-gray-100 hover:bg-gray-50'
                }
              `}>
              <tab.icon size={16} />
              {tab.label}
              <span className={`ml-1 px-2 py-0.5 rounded-full text-xs font-bold
                ${activeTab === tab.key
                  ? tab.color === 'amber' ? 'bg-amber-200/60 text-amber-700'
                    : tab.color === 'green' ? 'bg-green-200/60 text-green-700'
                    : 'bg-red-200/60 text-red-700'
                  : 'bg-gray-100 text-gray-500'
                }
              `}>{tab.count}</span>
            </button>
          ))}
        </div>

        {/* Content */}
        <div className="space-y-3">
          {loading ? (
            <div className="flex items-center justify-center py-16">
              <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : activeTab === 'saved' ? (
            savedWords.length === 0
              ? renderEmpty(<Bookmark size={28} className="text-gray-300" />, tr('noSavedWords'), tr('startStudyingFlashcards'))
              : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {savedWords.map((word) => {
                    const vocabId = word.vocab_id || word.vocabId
                    return renderWordCard(word, vocabId,
                      <button onClick={() => unsaveWord(vocabId)}
                        className="w-9 h-9 rounded-lg bg-red-50 flex items-center justify-center text-red-400 hover:bg-red-100 transition-colors cursor-pointer flex-shrink-0">
                        <BookmarkX size={16} />
                      </button>
                    )
                  })}
                </div>
              )
          ) : activeTab === 'passed' ? (
            passedStatuses.length === 0
              ? renderEmpty(<Check size={28} className="text-gray-300" />, tr('noPassedWords'), tr('startStudyingFlashcards'))
              : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                  {passedStatuses.map((status) => {
                    const vocabId = status.vocab_id || status.vocabId
                    const word = allWords[vocabId] || status
                    return renderWordCard(word, vocabId,
                      <button onClick={() => removeStatus(vocabId, 'learned')}
                        className="w-9 h-9 rounded-lg bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors cursor-pointer flex-shrink-0"
                        title="Reset">
                        <RotateCcw size={14} />
                      </button>
                    )
                  })}
                </div>
              )
          ) : (
            skippedStatuses.length === 0
              ? renderEmpty(<XCircle size={28} className="text-gray-300" />, tr('noSkippedWords'), tr('startStudyingFlashcards'))
              : (
                <>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                    {skippedStatuses.map((status) => {
                      const vocabId = status.vocab_id || status.vocabId
                      const word = allWords[vocabId] || status
                      return renderWordCard(word, vocabId,
                        <button onClick={() => removeStatus(vocabId, 'skipped')}
                          className="w-9 h-9 rounded-lg bg-gray-50 flex items-center justify-center text-gray-400 hover:bg-gray-100 transition-colors cursor-pointer flex-shrink-0"
                          title="Reset">
                          <RotateCcw size={14} />
                        </button>
                      )
                    })}
                  </div>
                </>
              )
          )}
        </div>
      </div>
    </WebLayout>
  )
}
