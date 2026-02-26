import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { Search, Crown, Lock, BookOpen, Play, Download, X, Sparkles } from 'lucide-react'
import WebLayout from '../../components/WebLayout'

const HSK_COLORS = {
  1: { bg: 'bg-red-500', light: 'bg-red-50', text: 'text-red-600', border: 'border-red-200', gradient: 'from-red-500 to-red-600' },
  2: { bg: 'bg-orange-500', light: 'bg-orange-50', text: 'text-orange-600', border: 'border-orange-200', gradient: 'from-orange-500 to-orange-600' },
  3: { bg: 'bg-yellow-500', light: 'bg-yellow-50', text: 'text-yellow-600', border: 'border-yellow-200', gradient: 'from-yellow-500 to-yellow-600' },
  4: { bg: 'bg-green-500', light: 'bg-green-50', text: 'text-green-600', border: 'border-green-200', gradient: 'from-green-500 to-green-600' },
  5: { bg: 'bg-blue-500', light: 'bg-blue-50', text: 'text-blue-600', border: 'border-blue-200', gradient: 'from-blue-500 to-blue-600' },
  6: { bg: 'bg-purple-500', light: 'bg-purple-50', text: 'text-purple-600', border: 'border-purple-200', gradient: 'from-purple-500 to-purple-600' },
}

const HSK_LABELS = { 1: 'Beginner', 2: 'Elementary', 3: 'Intermediate', 4: 'Upper-Intermediate', 5: 'Advanced', 6: 'Proficient' }
const HSK_WORD_COUNTS = { 1: 150, 2: 150, 3: 300, 4: 600, 5: 1300, 6: 2500 }

export default function UserDashboard() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)
  const [levels, setLevels] = useState([])
  const [loading, setLoading] = useState(true)
  const [searchQuery, setSearchQuery] = useState('')

  const token = localStorage.getItem('sf_token')
  const isGuest = !token

  useEffect(() => {
    if (!isGuest) {
      const userData = JSON.parse(localStorage.getItem('sf_user') || '{}')
      setUser(userData)
    }
    loadLevels()
  }, [])

  const loadLevels = async () => {
    try {
      const res = await vocabAPI.getLevels()
      setLevels(res.data.levels || [])
    } catch (err) {
      console.error('Failed to load levels:', err)
      setLevels([1, 2, 3, 4, 5, 6].map(l => ({ hsk_level: l, word_count: HSK_WORD_COUNTS[l] })))
    } finally {
      setLoading(false)
    }
  }

  const isPaid = user?.is_paid || user?.isPaid || false
  const firstName = user?.first_name || user?.firstName || 'Guest'

  const handleLevelClick = (level) => {
    if (isGuest && level > 1) {
      navigate('/login')
      return
    }
    if (!isGuest && !isPaid && level > 1) {
      navigate('/payment')
      return
    }
    navigate(`/hsk/${level}`)
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

  return (
    <WebLayout>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Page Header */}
        <div className="mb-8">
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
              <h1 className="text-2xl sm:text-3xl font-black text-gray-900">
                {isGuest ? 'Explore HSK Levels' : `Welcome back, ${firstName}`}
              </h1>
              <p className="text-gray-500 mt-1">
                {isGuest ? 'Try HSK 1 for free — sign up to unlock all levels' : 'Continue your Chinese learning journey'}
              </p>
            </div>
            {!isGuest && !isPaid && (
              <button onClick={() => navigate('/payment')}
                className="flex items-center gap-2 px-5 py-2.5 rounded-xl bg-gradient-to-r from-amber-400 to-amber-500 text-white text-sm font-bold shadow-sm hover:shadow-md transition-all cursor-pointer self-start">
                <Crown size={16} />
                Upgrade to Premium
              </button>
            )}
          </div>
        </div>

        {/* Stats Row */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="text-2xl font-black text-primary-500">
              {levels.reduce((sum, l) => sum + (l.word_count || 0), 0).toLocaleString()}
            </div>
            <div className="text-sm text-gray-500 font-medium mt-1">Total Words</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="text-2xl font-black text-green-500">6</div>
            <div className="text-sm text-gray-500 font-medium mt-1">HSK Levels</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="text-2xl font-black text-blue-500">
              {isGuest ? 1 : (isPaid ? 6 : 1)}
            </div>
            <div className="text-sm text-gray-500 font-medium mt-1">Levels Unlocked</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="text-2xl font-black text-purple-500">3</div>
            <div className="text-sm text-gray-500 font-medium mt-1">Languages</div>
          </div>
        </div>

        {/* Search */}
        <div className="mb-6">
          <div className="relative max-w-md">
            <Search size={18} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search HSK levels..."
              className="w-full pl-11 pr-10 py-3 rounded-xl bg-white border border-gray-200 text-sm focus:border-primary-300 focus:ring-2 focus:ring-primary-500/10 outline-none transition-all"
            />
            {searchQuery && (
              <button onClick={() => setSearchQuery('')}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer">
                <X size={18} />
              </button>
            )}
          </div>
        </div>

        {/* Section Title */}
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-gray-900">HSK Levels</h2>
          {(isGuest || !isPaid) && (
            <span className="text-xs text-gray-400 font-medium flex items-center gap-1">
              <Lock size={12} />
              {isGuest ? 'Sign up for full access' : 'Premium required for HSK 2-6'}
            </span>
          )}
        </div>

        {/* HSK Level Cards - Responsive Grid */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
          {[1, 2, 3, 4, 5, 6].map(level => {
            const colors = HSK_COLORS[level]
            const levelData = levels.find(l => l.hsk_level === level)
            const wordCount = levelData?.word_count || HSK_WORD_COUNTS[level]
            const isLocked = isGuest ? level > 1 : (!isPaid && level > 1)
            const label = HSK_LABELS[level]

            if (searchQuery && !`HSK ${level} ${label}`.toLowerCase().includes(searchQuery.toLowerCase())) {
              return null
            }

            return (
              <div key={level}
                className={`relative rounded-2xl overflow-hidden transition-all duration-300 group
                  ${isLocked ? 'opacity-75' : 'hover:shadow-lg hover:-translate-y-1'}
                `}
              >
                {/* Card Top - Colored Header */}
                <div className={`bg-gradient-to-r ${colors.gradient} p-5 ${isLocked ? 'opacity-60' : ''}`}>
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="text-2xl font-black text-white">HSK {level}</h3>
                      <p className="text-white/80 text-sm font-medium">{label}</p>
                    </div>
                    <div className="w-12 h-12 rounded-xl bg-white/20 flex items-center justify-center">
                      <span className="text-white text-xl font-black">{level}</span>
                    </div>
                  </div>
                </div>

                {/* Card Body */}
                <div className="bg-white p-5 border border-t-0 border-gray-100 rounded-b-2xl">
                  <div className="flex items-center justify-between mb-4">
                    <div>
                      <span className="text-lg font-bold text-gray-900">{wordCount}</span>
                      <span className="text-sm text-gray-500 ml-1">words</span>
                    </div>
                    {isLocked ? (
                      <div className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-gray-100">
                        <Lock size={14} className="text-gray-400" />
                        <span className="text-xs font-medium text-gray-400">Locked</span>
                      </div>
                    ) : (
                      <div className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg ${colors.light}`}>
                        <BookOpen size={14} className={colors.text} />
                        <span className={`text-xs font-medium ${colors.text}`}>Available</span>
                      </div>
                    )}
                  </div>

                  <div className="flex gap-2">
                    <button onClick={() => handleLevelClick(level)}
                      className={`flex-1 flex items-center justify-center gap-2 py-2.5 rounded-xl text-sm font-bold transition-all cursor-pointer
                        ${isLocked
                          ? 'bg-gray-100 text-gray-400'
                          : `bg-gradient-to-r ${colors.gradient} text-white shadow-sm hover:shadow-md`
                        }
                      `}>
                      <BookOpen size={16} />
                      {isLocked ? (isGuest ? 'Sign Up' : 'Unlock') : 'Study'}
                    </button>
                    {!isLocked && (
                      <button onClick={() => navigate(`/flashcard/${level}`)}
                        className={`flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl text-sm font-bold border ${colors.border} ${colors.text} hover:${colors.light} transition-all cursor-pointer`}>
                        <Play size={16} />
                        Cards
                      </button>
                    )}
                  </div>
                </div>
              </div>
            )
          })}
        </div>

        {/* Premium CTA */}
        {(isGuest || !isPaid) && (
          <div className="rounded-2xl bg-gradient-to-r from-amber-400 via-orange-500 to-red-500 p-6 sm:p-8 text-white shadow-lg mb-8">
            <div className="flex flex-col sm:flex-row sm:items-center gap-4 sm:gap-6">
              <div className="w-14 h-14 rounded-2xl bg-white/20 flex items-center justify-center flex-shrink-0">
                <Crown size={28} className="text-white" />
              </div>
              <div className="flex-1">
                <h3 className="text-xl font-bold">Unlock All HSK Levels</h3>
                <p className="text-white/85 mt-1">
                  Get full access to 5,000+ vocabulary words across all 6 HSK levels with premium features.
                </p>
              </div>
              <button onClick={() => isGuest ? navigate('/register') : navigate('/payment')}
                className="px-6 py-3 rounded-xl bg-white text-amber-600 font-bold text-sm hover:bg-white/90 transition-colors cursor-pointer flex-shrink-0 self-start">
                {isGuest ? 'Register Free' : 'Upgrade Now'}
              </button>
            </div>
          </div>
        )}

        {/* Download App Banner */}
        <div className="rounded-2xl bg-gray-900 p-6 text-white">
          <div className="flex flex-col sm:flex-row sm:items-center gap-4">
            <div className="w-12 h-12 rounded-xl bg-white/10 flex items-center justify-center flex-shrink-0">
              <Download size={22} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold">Download the Mobile App</h3>
              <p className="text-gray-400 text-sm mt-0.5">Get offline access, audio pronunciation, and the full mobile experience</p>
            </div>
            <a href="#" className="px-5 py-2.5 rounded-xl bg-white text-gray-900 text-sm font-bold hover:bg-gray-100 transition-colors self-start">
              Download APK
            </a>
          </div>
        </div>
      </div>
    </WebLayout>
  )
}
