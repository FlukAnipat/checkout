import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, ChevronLeft, ChevronRight, Flame, Target, BookOpen, Trophy, Calendar as CalendarIcon, Check, X as XIcon } from 'lucide-react'
import WebLayout from '../../components/WebLayout'
import { useLanguage } from '../../contexts/LanguageContext'

const MONTH_KEYS = ['january','february','march','april','may','june','july','august','september','october','november','december']
const DAY_KEYS = ['sunday','monday','tuesday','wednesday','thursday','friday','saturday']

export default function ProgressPage() {
  const navigate = useNavigate()
  const { tr } = useLanguage()
  const [currentMonth, setCurrentMonth] = useState(new Date())
  const [dailyGoals, setDailyGoals] = useState([])
  const [sessions, setSessions] = useState([])
  const [stats, setStats] = useState({ dayStreak: 0, totalLearned: 0 })
  const [loading, setLoading] = useState(true)
  const [selectedDay, setSelectedDay] = useState(null)

  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  const userId = user.user_id || user.userId

  useEffect(() => {
    if (userId) {
      loadStats()
    } else {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    if (userId) loadMonthData()
  }, [currentMonth])

  const loadStats = async () => {
    try {
      const res = await vocabAPI.getUserStats(userId)
      setStats(res.data.stats || { dayStreak: 0, totalLearned: 0 })
    } catch (err) {
      console.error('Failed to load stats:', err)
    }
  }

  const loadMonthData = async () => {
    try {
      const year = currentMonth.getFullYear()
      const month = currentMonth.getMonth()
      const start = `${year}-${String(month + 1).padStart(2, '0')}-01`
      const lastDay = new Date(year, month + 1, 0).getDate()
      const end = `${year}-${String(month + 1).padStart(2, '0')}-${String(lastDay).padStart(2, '0')}`

      const [goalsRes, sessionsRes] = await Promise.all([
        vocabAPI.getDailyGoals(userId, start, end),
        vocabAPI.getLearningSessions(userId, start, end),
      ])

      setDailyGoals(goalsRes.data.goals || [])
      setSessions(sessionsRes.data.sessions || [])
    } catch (err) {
      console.error('Failed to load month data:', err)
    } finally {
      setLoading(false)
    }
  }

  const prevMonth = () => {
    setCurrentMonth(new Date(currentMonth.getFullYear(), currentMonth.getMonth() - 1, 1))
  }

  const nextMonth = () => {
    const now = new Date()
    const next = new Date(currentMonth.getFullYear(), currentMonth.getMonth() + 1, 1)
    if (next <= new Date(now.getFullYear(), now.getMonth() + 1, 1)) {
      setCurrentMonth(next)
    }
  }

  // Build calendar grid
  const year = currentMonth.getFullYear()
  const month = currentMonth.getMonth()
  const firstDayOfMonth = new Date(year, month, 1).getDay()
  const daysInMonth = new Date(year, month + 1, 0).getDate()
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const calendarDays = []
  for (let i = 0; i < firstDayOfMonth; i++) calendarDays.push(null)
  for (let d = 1; d <= daysInMonth; d++) calendarDays.push(d)

  const getGoalForDate = (day) => {
    if (!day) return null
    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
    return dailyGoals.find(g => {
      const gd = new Date(g.goal_date)
      const gs = `${gd.getFullYear()}-${String(gd.getMonth() + 1).padStart(2, '0')}-${String(gd.getDate()).padStart(2, '0')}`
      return gs === dateStr
    })
  }

  const getSessionForDate = (day) => {
    if (!day) return null
    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`
    return sessions.find(s => {
      const sd = new Date(s.session_date)
      const ss = `${sd.getFullYear()}-${String(sd.getMonth() + 1).padStart(2, '0')}-${String(sd.getDate()).padStart(2, '0')}`
      return ss === dateStr
    })
  }

  const isToday = (day) => {
    if (!day) return false
    return year === today.getFullYear() && month === today.getMonth() && day === today.getDate()
  }

  const isFuture = (day) => {
    if (!day) return false
    const d = new Date(year, month, day)
    d.setHours(0, 0, 0, 0)
    return d > today
  }

  // Build goal map for quick lookup: dateStr -> goal
  const goalMap = {}
  dailyGoals.forEach(g => {
    const gd = new Date(g.goal_date)
    const gs = `${gd.getFullYear()}-${String(gd.getMonth() + 1).padStart(2, '0')}-${String(gd.getDate()).padStart(2, '0')}`
    goalMap[gs] = g
  })

  const sessionMap = {}
  sessions.forEach(s => {
    const sd = new Date(s.session_date)
    const ss = `${sd.getFullYear()}-${String(sd.getMonth() + 1).padStart(2, '0')}-${String(sd.getDate()).padStart(2, '0')}`
    sessionMap[ss] = s
  })

  const getDateStr = (day) => `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`

  // Count completed days this month
  const completedDays = dailyGoals.filter(g => g.is_completed === 1 || g.is_completed === true).length
  const totalCardsMonth = dailyGoals.reduce((s, g) => s + (g.completed_cards || 0), 0)

  // Selected day info
  const selectedGoal = selectedDay ? goalMap[getDateStr(selectedDay)] : null
  const selectedSession = selectedDay ? sessionMap[getDateStr(selectedDay)] : null

  return (
    <WebLayout>
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="flex items-center gap-3 mb-6">
          <button onClick={() => navigate('/dashboard')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <div className="flex-1">
            <h1 className="text-2xl font-black text-gray-900">{tr('learningCalendar')}</h1>
            <p className="text-sm text-gray-500">{tr('trackDailyProgress')}</p>
          </div>
          <div className="w-12 h-12 rounded-xl bg-green-500 flex items-center justify-center">
            <CalendarIcon size={22} className="text-white" />
          </div>
        </div>

        {/* Stats Cards (matches Flutter _buildStatsSummary) */}
        <div className="grid grid-cols-3 gap-3 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 text-center">
            <Target size={22} className="text-green-500 mx-auto mb-2" />
            <div className="text-2xl font-black text-gray-900">{completedDays}</div>
            <div className="text-[10px] text-gray-500 font-medium leading-tight">{tr('daysCompleted')}</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 text-center">
            <Flame size={22} className="text-orange-500 mx-auto mb-2" />
            <div className="text-2xl font-black text-gray-900">{stats.dayStreak}</div>
            <div className="text-[10px] text-gray-500 font-medium leading-tight">{tr('dayStreak')}</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 text-center">
            <BookOpen size={22} className="text-blue-500 mx-auto mb-2" />
            <div className="text-2xl font-black text-gray-900">{totalCardsMonth}</div>
            <div className="text-[10px] text-gray-500 font-medium leading-tight">{tr('totalCards')}</div>
          </div>
        </div>

        {/* Calendar */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-4 sm:p-6 mb-6">
          {/* Month Navigation */}
          <div className="flex items-center justify-between mb-5">
            <button onClick={prevMonth}
              className="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center hover:bg-gray-100 transition-colors cursor-pointer">
              <ChevronLeft size={18} className="text-gray-600" />
            </button>
            <h2 className="text-lg font-bold text-gray-900">
              {tr(MONTH_KEYS[month])} {year}
            </h2>
            <button onClick={nextMonth}
              className="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center hover:bg-gray-100 transition-colors cursor-pointer">
              <ChevronRight size={18} className="text-gray-600" />
            </button>
          </div>

          {/* Day Headers */}
          <div className="grid grid-cols-7 gap-1 mb-1">
            {DAY_KEYS.map(dk => (
              <div key={dk} className="text-center text-[10px] sm:text-xs font-bold text-gray-400 py-1">
                {tr(dk)}
              </div>
            ))}
          </div>

          {/* Calendar Grid (matches Flutter calendar cells with X/10) */}
          <div className="grid grid-cols-7 gap-1">
            {calendarDays.map((day, idx) => {
              if (day === null) {
                return <div key={`empty-${idx}`} className="aspect-square" />
              }

              const dateStr = getDateStr(day)
              const goal = goalMap[dateStr]
              const wordsLearned = goal?.completed_cards || 0
              const isComplete = goal && (goal.is_completed === 1 || goal.is_completed === true)
              const hasProgress = wordsLearned > 0
              const todayCell = isToday(day)
              const futureDay = isFuture(day)
              const isSelected = selectedDay === day

              let bgClass, textClass, progressColor, icon

              if (futureDay) {
                bgClass = 'bg-gray-50'
                textClass = 'text-gray-300'
                progressColor = 'text-gray-300'
                icon = null
              } else if (isComplete) {
                bgClass = 'bg-green-50'
                textClass = 'text-green-700'
                progressColor = 'text-green-500'
                icon = <Check size={8} className="text-green-500" />
              } else if (hasProgress) {
                bgClass = 'bg-amber-50'
                textClass = 'text-amber-700'
                progressColor = 'text-amber-500'
                icon = null
              } else {
                bgClass = 'bg-gray-50'
                textClass = 'text-gray-600'
                progressColor = 'text-red-400'
                icon = !futureDay ? <XIcon size={8} className="text-red-400" /> : null
              }

              return (
                <button key={day}
                  onClick={() => setSelectedDay(isSelected ? null : day)}
                  className={`aspect-square rounded-lg flex flex-col items-center justify-center transition-all relative cursor-pointer
                    ${bgClass}
                    ${todayCell ? 'ring-2 ring-green-500 ring-offset-1' : ''}
                    ${isSelected ? 'ring-2 ring-blue-400 ring-offset-1' : ''}
                  `}>
                  <span className={`text-xs font-bold ${textClass}`}>{day}</span>
                  {!futureDay && (
                    <span className={`text-[7px] sm:text-[8px] font-semibold ${progressColor}`}>
                      {wordsLearned}/10
                    </span>
                  )}
                  {icon && (
                    <span className="absolute top-0.5 right-0.5">{icon}</span>
                  )}
                </button>
              )
            })}
          </div>

          {/* Legend */}
          <div className="flex items-center justify-center gap-4 sm:gap-6 mt-5 pt-4 border-t border-gray-100">
            <div className="flex items-center gap-1.5">
              <div className="w-3 h-3 rounded bg-green-50 border border-green-300" />
              <span className="text-[10px] sm:text-xs text-gray-500">{tr('completedStatus')}</span>
            </div>
            <div className="flex items-center gap-1.5">
              <div className="w-3 h-3 rounded bg-amber-50 border border-amber-300" />
              <span className="text-[10px] sm:text-xs text-gray-500">{tr('incompleteStatus')}</span>
            </div>
            <div className="flex items-center gap-1.5">
              <div className="w-3 h-3 rounded bg-gray-50 border border-gray-200" />
              <span className="text-[10px] sm:text-xs text-gray-500">{tr('noActivity')}</span>
            </div>
          </div>
        </div>

        {/* Selected Day Info (matches Flutter _buildSelectedDayInfo) */}
        {selectedDay && !isFuture(selectedDay) && (() => {
          const dateStr = getDateStr(selectedDay)
          const g = goalMap[dateStr]
          const wl = g?.completed_cards || 0
          const ic = g && (g.is_completed === 1 || g.is_completed === true)
          const statusColor = ic ? 'text-green-600' : wl > 0 ? 'text-amber-600' : 'text-red-500'
          const statusBg = ic ? 'bg-green-50 border-green-200' : wl > 0 ? 'bg-amber-50 border-amber-200' : 'bg-red-50 border-red-200'
          const statusText = ic ? tr('goalCompleted') : wl > 0 ? tr('goalNotMet') : tr('noActivity')
          const statusIcon = ic ? <Check size={16} className="text-green-500" /> : wl > 0 ? <Target size={16} className="text-amber-500" /> : <XIcon size={16} className="text-red-400" />

          const d = new Date(year, month, selectedDay)
          const dayName = d.toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })

          return (
            <div className={`rounded-2xl border p-5 mb-6 ${statusBg}`}>
              <div className="flex items-center gap-3 mb-3">
                {statusIcon}
                <div>
                  <p className={`text-sm font-bold ${statusColor}`}>{statusText}</p>
                  <p className="text-xs text-gray-500">{dayName}</p>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="bg-white/80 rounded-xl p-3 text-center">
                  <p className="text-lg font-black text-gray-900">{wl}</p>
                  <p className="text-[10px] text-gray-500 font-medium">{tr('cardsLabel')}</p>
                </div>
                <div className="bg-white/80 rounded-xl p-3 text-center">
                  <p className="text-lg font-black text-gray-900">{wl > 0 ? Math.round(wl * 2) : 0}</p>
                  <p className="text-[10px] text-gray-500 font-medium">{tr('minutesLabel')}</p>
                </div>
              </div>
            </div>
          )
        })()}

        {/* Recent Sessions */}
        {sessions.length > 0 && (
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">{tr('recentActivity')}</h3>
            <div className="space-y-3">
              {sessions.slice(0, 10).map((s, i) => {
                const d = new Date(s.session_date)
                return (
                  <div key={i} className="flex items-center justify-between py-3 border-b border-gray-50 last:border-0">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center">
                        <BookOpen size={16} className="text-blue-500" />
                      </div>
                      <div>
                        <p className="text-sm font-medium text-gray-900">
                          {tr('studied')} {s.learned_cards} {tr('cards')}
                          {s.hsk_level ? ` · HSK ${s.hsk_level}` : ''}
                        </p>
                        <p className="text-xs text-gray-400">
                          {d.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}
                          {s.minutes_spent > 0 && ` · ${s.minutes_spent} min`}
                        </p>
                      </div>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        )}

        {/* Empty state */}
        {!loading && sessions.length === 0 && dailyGoals.length === 0 && (
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center">
            <div className="w-16 h-16 rounded-full bg-gray-50 flex items-center justify-center mx-auto mb-4">
              <CalendarIcon size={28} className="text-gray-300" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-1">{tr('noActivityYet')}</h3>
            <p className="text-sm text-gray-400 mb-6">{tr('startStudyingFlashcards')}</p>
            <button onClick={() => navigate('/dashboard')}
              className="px-6 py-2.5 rounded-xl gradient-primary text-white text-sm font-bold cursor-pointer">
              {tr('startLearning')}
            </button>
          </div>
        )}
      </div>
    </WebLayout>
  )
}
