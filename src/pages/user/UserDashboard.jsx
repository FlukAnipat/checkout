import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { Search, Crown, Lock, BookOpen, Star, Bookmark, User, Home, Download, X } from 'lucide-react'

const HSK_COLORS = {
  1: { bg: 'bg-red-500', light: 'bg-red-50', text: 'text-red-600', border: 'border-red-200', gradient: 'from-red-500 to-red-600' },
  2: { bg: 'bg-orange-500', light: 'bg-orange-50', text: 'text-orange-600', border: 'border-orange-200', gradient: 'from-orange-500 to-orange-600' },
  3: { bg: 'bg-yellow-500', light: 'bg-yellow-50', text: 'text-yellow-600', border: 'border-yellow-200', gradient: 'from-yellow-500 to-yellow-600' },
  4: { bg: 'bg-green-500', light: 'bg-green-50', text: 'text-green-600', border: 'border-green-200', gradient: 'from-green-500 to-green-600' },
  5: { bg: 'bg-blue-500', light: 'bg-blue-50', text: 'text-blue-600', border: 'border-blue-200', gradient: 'from-blue-500 to-blue-600' },
  6: { bg: 'bg-purple-500', light: 'bg-purple-50', text: 'text-purple-600', border: 'border-purple-200', gradient: 'from-purple-500 to-purple-600' },
}

const HSK_WORD_COUNTS = { 1: 150, 2: 150, 3: 300, 4: 600, 5: 1300, 6: 2500 }

export default function UserDashboard() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)
  const [levels, setLevels] = useState([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')
  const [showSearch, setShowSearch] = useState(false)
  const [activeTab, setActiveTab] = useState('home')

  useEffect(() => {
    const userData = JSON.parse(localStorage.getItem('sf_user') || '{}')
    setUser(userData)
    loadLevels()
  }, [])

  const loadLevels = async () => {
    try {
      const res = await vocabAPI.getLevels()
      setLevels(res.data.levels || [])
    } catch (err) {
      console.error('Failed to load levels:', err)
      // Fallback data
      setLevels([1, 2, 3, 4, 5, 6].map(l => ({ hsk_level: l, word_count: HSK_WORD_COUNTS[l] })))
    } finally {
      setLoading(false)
    }
  }

  const isPaid = user?.is_paid || user?.isPaid || false
  const firstName = user?.first_name || user?.firstName || 'User'

  const handleLevelClick = (level) => {
    if (!isPaid && level > 1) {
      navigate('/payment')
      return
    }
    navigate(`/hsk/${level}`)
  }

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/login')
  }

  const handleTabChange = (tab) => {
    setActiveTab(tab)
    switch (tab) {
      case 'home': break
      case 'saved': navigate('/saved'); break
      case 'profile': navigate('/profile'); break
    }
  }

  if (loading) {
    return (
      <div className="app-container flex items-center justify-center min-h-screen">
        <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="app-container pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-2">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-xs text-gray-500 font-medium">Welcome back</p>
            <h1 className="text-xl font-black text-gray-900">{firstName} 👋</h1>
          </div>
          <div className="flex items-center gap-2">
            {!isPaid && (
              <button
                onClick={() => navigate('/payment')}
                className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-gradient-to-r from-amber-400 to-amber-500 text-white text-xs font-bold shadow-sm hover:shadow-md transition-all cursor-pointer"
              >
                <Crown size={14} />
                Get Premium
              </button>
            )}
            {isPaid && (
              <div className="flex items-center gap-1.5 px-3 py-2 rounded-xl bg-amber-50 border border-amber-200">
                <Crown size={14} className="text-amber-500" />
                <span className="text-xs font-bold text-amber-600">Premium</span>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Search Bar */}
      <div className="px-5 py-3">
        <div className="relative">
          <Search size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            onFocus={() => setShowSearch(true)}
            placeholder="Search vocabulary..."
            className="w-full pl-11 pr-10 py-3 rounded-2xl bg-white border border-gray-100 shadow-sm text-sm focus:border-primary-300 focus:ring-2 focus:ring-primary-500/10 outline-none transition-all"
          />
          {searchQuery && (
            <button onClick={() => { setSearchQuery(''); setShowSearch(false) }}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer">
              <X size={18} />
            </button>
          )}
        </div>
      </div>

      {/* Stats Row */}
      <div className="px-5 py-2">
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-white rounded-2xl p-3 shadow-sm border border-gray-50 text-center">
            <div className="text-lg font-black text-primary-500">
              {levels.reduce((sum, l) => sum + (l.word_count || 0), 0)}
            </div>
            <div className="text-[10px] text-gray-500 font-medium mt-0.5">Total Words</div>
          </div>
          <div className="bg-white rounded-2xl p-3 shadow-sm border border-gray-50 text-center">
            <div className="text-lg font-black text-green-500">
              {isPaid ? 6 : 1}
            </div>
            <div className="text-[10px] text-gray-500 font-medium mt-0.5">Levels Unlocked</div>
          </div>
          <div className="bg-white rounded-2xl p-3 shadow-sm border border-gray-50 text-center">
            <div className="text-lg font-black text-blue-500">0</div>
            <div className="text-[10px] text-gray-500 font-medium mt-0.5">Words Learned</div>
          </div>
        </div>
      </div>

      {/* HSK Levels Title */}
      <div className="px-5 pt-4 pb-2 flex items-center justify-between">
        <h2 className="text-base font-black text-gray-900">HSK Levels</h2>
        {!isPaid && (
          <span className="text-[10px] text-gray-400 font-medium flex items-center gap-1">
            <Lock size={10} />
            Premium required for HSK 2-6
          </span>
        )}
      </div>

      {/* HSK Level Grid */}
      <div className="px-5 py-2 grid grid-cols-2 gap-3">
        {[1, 2, 3, 4, 5, 6].map(level => {
          const colors = HSK_COLORS[level]
          const levelData = levels.find(l => l.hsk_level === level)
          const wordCount = levelData?.word_count || HSK_WORD_COUNTS[level]
          const isLocked = !isPaid && level > 1

          return (
            <button
              key={level}
              onClick={() => handleLevelClick(level)}
              className={`relative rounded-2xl p-4 text-left transition-all duration-300 cursor-pointer group
                ${isLocked ? 'bg-white/60 border border-gray-100' : `bg-white border ${colors.border} shadow-sm hover:shadow-md hover:-translate-y-0.5`}
              `}
            >
              {/* Level Badge */}
              <div className={`w-10 h-10 rounded-xl bg-gradient-to-br ${colors.gradient} flex items-center justify-center shadow-sm mb-3
                ${isLocked ? 'opacity-40' : 'opacity-100'}
              `}>
                <span className="text-white text-sm font-black">{level}</span>
              </div>

              {/* Title */}
              <h3 className={`text-sm font-bold ${isLocked ? 'text-gray-400' : 'text-gray-900'}`}>
                HSK {level}
              </h3>

              {/* Word Count */}
              <p className={`text-xs mt-0.5 ${isLocked ? 'text-gray-300' : 'text-gray-500'}`}>
                {wordCount} words
              </p>

              {/* Lock Overlay */}
              {isLocked && (
                <div className="absolute top-3 right-3">
                  <div className="w-7 h-7 rounded-lg bg-gray-100 flex items-center justify-center">
                    <Lock size={14} className="text-gray-400" />
                  </div>
                </div>
              )}

              {/* Unlocked indicator */}
              {!isLocked && (
                <div className="absolute top-3 right-3">
                  <div className={`w-7 h-7 rounded-lg ${colors.light} flex items-center justify-center`}>
                    <BookOpen size={14} className={colors.text} />
                  </div>
                </div>
              )}
            </button>
          )
        })}
      </div>

      {/* Premium CTA (for non-premium users) */}
      {!isPaid && (
        <div className="px-5 py-4">
          <div className="rounded-2xl bg-gradient-to-r from-amber-400 to-orange-500 p-5 text-white shadow-lg">
            <div className="flex items-start gap-3">
              <div className="w-10 h-10 rounded-xl bg-white/20 flex items-center justify-center flex-shrink-0">
                <Crown size={20} className="text-white" />
              </div>
              <div className="flex-1">
                <h3 className="font-bold text-sm">Unlock All HSK Levels</h3>
                <p className="text-xs text-white/80 mt-1">Get full access to 5,000+ vocabulary words across all 6 HSK levels.</p>
                <button
                  onClick={() => navigate('/payment')}
                  className="mt-3 px-5 py-2 rounded-xl bg-white text-amber-600 text-xs font-bold hover:bg-white/90 transition-colors cursor-pointer"
                >
                  Upgrade to Premium
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Download App Banner */}
      <div className="px-5 py-2 pb-4">
        <div className="rounded-2xl bg-gray-900 p-4 text-white">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center flex-shrink-0">
              <Download size={18} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-sm">Download the App</h3>
              <p className="text-xs text-gray-400 mt-0.5">Get the full experience with flashcards & audio</p>
            </div>
            <a href="#" className="px-4 py-2 rounded-lg bg-white text-gray-900 text-xs font-bold hover:bg-gray-100 transition-colors">
              APK
            </a>
          </div>
        </div>
      </div>

      {/* Bottom Navigation */}
      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[480px] bg-white border-t border-gray-100 px-4 py-2 z-50">
        <div className="flex items-center justify-around">
          {[
            { id: 'home', icon: Home, label: 'Home' },
            { id: 'saved', icon: Bookmark, label: 'Saved' },
            { id: 'profile', icon: User, label: 'Profile' },
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => handleTabChange(tab.id)}
              className={`flex flex-col items-center gap-0.5 py-1 px-4 rounded-xl transition-all cursor-pointer
                ${activeTab === tab.id ? 'text-primary-500' : 'text-gray-400 hover:text-gray-600'}
              `}
            >
              <tab.icon size={20} />
              <span className="text-[10px] font-semibold">{tab.label}</span>
            </button>
          ))}
        </div>
      </div>
    </div>
  )
}
