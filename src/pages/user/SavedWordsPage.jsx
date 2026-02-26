import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, Bookmark, BookmarkX, Home, User } from 'lucide-react'

export default function SavedWordsPage() {
  const navigate = useNavigate()
  const [savedWords, setSavedWords] = useState([])
  const [loading, setLoading] = useState(true)

  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  const userId = user.user_id || user.userId

  useEffect(() => {
    loadSavedWords()
  }, [])

  const loadSavedWords = async () => {
    if (!userId) { setLoading(false); return }
    try {
      const res = await vocabAPI.getSavedWords(userId)
      setSavedWords(res.data.savedWords || [])
    } catch (err) {
      console.error('Failed to load saved words:', err)
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

  return (
    <div className="app-container pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4">
        <div className="flex items-center gap-3">
          <button onClick={() => navigate('/dashboard')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-100 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <div>
            <h1 className="text-xl font-black text-gray-900">Saved Words</h1>
            <p className="text-xs text-gray-500">{savedWords.length} words saved</p>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="px-5 space-y-2">
        {loading ? (
          <div className="flex items-center justify-center py-16">
            <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
          </div>
        ) : savedWords.length === 0 ? (
          <div className="text-center py-16">
            <div className="w-16 h-16 rounded-full bg-gray-50 flex items-center justify-center mx-auto mb-4">
              <Bookmark size={28} className="text-gray-300" />
            </div>
            <h3 className="text-base font-bold text-gray-900 mb-1">No Saved Words</h3>
            <p className="text-sm text-gray-400 mb-6">Save vocabulary words while studying to review them here.</p>
            <button onClick={() => navigate('/dashboard')}
              className="px-6 py-2.5 rounded-xl gradient-primary text-white text-sm font-bold cursor-pointer">
              Start Learning
            </button>
          </div>
        ) : (
          savedWords.map((word) => {
            const vocabId = word.vocab_id || word.vocabId
            return (
              <div key={vocabId} className="bg-white rounded-2xl shadow-sm border border-gray-50 px-4 py-3.5 flex items-center gap-3">
                <div className="flex-1 min-w-0">
                  <div className="flex items-baseline gap-2">
                    <span className="text-lg font-bold text-gray-900">{word.hanzi}</span>
                    <span className="text-xs text-gray-400">{word.pinyin}</span>
                  </div>
                  <p className="text-xs text-gray-500 truncate mt-0.5">
                    {word.meaning_en || word.meaningEn || word.meaning}
                  </p>
                </div>
                <button onClick={() => unsaveWord(vocabId)}
                  className="w-9 h-9 rounded-lg bg-red-50 flex items-center justify-center text-red-400 hover:bg-red-100 transition-colors cursor-pointer flex-shrink-0">
                  <BookmarkX size={16} />
                </button>
              </div>
            )
          })
        )}
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[480px] bg-white border-t border-gray-100 px-4 py-2 z-50">
        <div className="flex items-center justify-around">
          {[
            { id: 'home', icon: Home, label: 'Home', path: '/dashboard' },
            { id: 'saved', icon: Bookmark, label: 'Saved', path: '/saved' },
            { id: 'profile', icon: User, label: 'Profile', path: '/profile' },
          ].map(tab => (
            <button key={tab.id} onClick={() => navigate(tab.path)}
              className={`flex flex-col items-center gap-0.5 py-1 px-4 rounded-xl transition-all cursor-pointer
                ${tab.id === 'saved' ? 'text-primary-500' : 'text-gray-400 hover:text-gray-600'}
              `}>
              <tab.icon size={20} />
              <span className="text-[10px] font-semibold">{tab.label}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
