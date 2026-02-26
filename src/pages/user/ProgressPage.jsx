import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { vocabAPI } from '../../services/api'
import { ArrowLeft, ChevronLeft, ChevronRight, Flame, Target, BookOpen, Trophy, Calendar as CalendarIcon } from 'lucide-react'
import WebLayout from '../../components/WebLayout'

const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

export default function ProgressPage() {
  const navigate = useNavigate()
  const [currentMonth, setCurrentMonth] = useState(new Date())
  const [dailyGoals, setDailyGoals] = useState([])
  const [sessions, setSessions] = useState([])
  const [stats, setStats] = useState({ dayStreak: 0, totalLearned: 0 })
  const [loading, setLoading] = useState(true)

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

  // Count completed days this month
  const completedDays = dailyGoals.filter(g => g.is_completed === 1 || g.is_completed === true).length
  const activeDays = sessions.length
  const totalCardsMonth = sessions.reduce((s, ses) => s + (ses.learned_cards || 0), 0)

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
            <h1 className="text-2xl font-black text-gray-900">My Progress</h1>
            <p className="text-sm text-gray-500">Track your daily learning journey</p>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4 mb-8">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="w-10 h-10 rounded-xl bg-orange-50 flex items-center justify-center mb-3">
              <Flame size={20} className="text-orange-500" />
            </div>
            <div className="text-2xl font-black text-gray-900">{stats.dayStreak}</div>
            <div className="text-xs text-gray-500 font-medium">Day Streak</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center mb-3">
              <BookOpen size={20} className="text-blue-500" />
            </div>
            <div className="text-2xl font-black text-gray-900">{stats.totalLearned}</div>
            <div className="text-xs text-gray-500 font-medium">Total Learned</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="w-10 h-10 rounded-xl bg-green-50 flex items-center justify-center mb-3">
              <Target size={20} className="text-green-500" />
            </div>
            <div className="text-2xl font-black text-gray-900">{completedDays}</div>
            <div className="text-xs text-gray-500 font-medium">Goals Met ({MONTHS[month].slice(0, 3)})</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100">
            <div className="w-10 h-10 rounded-xl bg-purple-50 flex items-center justify-center mb-3">
              <Trophy size={20} className="text-purple-500" />
            </div>
            <div className="text-2xl font-black text-gray-900">{totalCardsMonth}</div>
            <div className="text-xs text-gray-500 font-medium">Cards This Month</div>
          </div>
        </div>

        {/* Calendar */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-8">
          {/* Month Navigation */}
          <div className="flex items-center justify-between mb-6">
            <button onClick={prevMonth}
              className="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center hover:bg-gray-100 transition-colors cursor-pointer">
              <ChevronLeft size={18} className="text-gray-600" />
            </button>
            <div className="flex items-center gap-2">
              <CalendarIcon size={18} className="text-primary-500" />
              <h2 className="text-lg font-bold text-gray-900">
                {MONTHS[month]} {year}
              </h2>
            </div>
            <button onClick={nextMonth}
              className="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center hover:bg-gray-100 transition-colors cursor-pointer">
              <ChevronRight size={18} className="text-gray-600" />
            </button>
          </div>

          {/* Day Headers */}
          <div className="grid grid-cols-7 gap-1 mb-2">
            {DAYS.map(day => (
              <div key={day} className="text-center text-xs font-bold text-gray-400 py-2">
                {day}
              </div>
            ))}
          </div>

          {/* Calendar Grid */}
          <div className="grid grid-cols-7 gap-1">
            {calendarDays.map((day, idx) => {
              if (day === null) {
                return <div key={`empty-${idx}`} className="aspect-square" />
              }

              const goal = getGoalForDate(day)
              const session = getSessionForDate(day)
              const isComplete = goal && (goal.is_completed === 1 || goal.is_completed === true)
              const hasActivity = !!session
              const todayClass = isToday(day)
              const futureDay = isFuture(day)

              let bgClass = 'bg-gray-50'
              let textClass = 'text-gray-700'
              let indicator = null

              if (futureDay) {
                bgClass = 'bg-gray-25'
                textClass = 'text-gray-300'
              } else if (isComplete) {
                bgClass = 'bg-green-100'
                textClass = 'text-green-700'
                indicator = <div className="w-1.5 h-1.5 rounded-full bg-green-500 mx-auto mt-0.5" />
              } else if (hasActivity) {
                bgClass = 'bg-blue-50'
                textClass = 'text-blue-700'
                indicator = <div className="w-1.5 h-1.5 rounded-full bg-blue-400 mx-auto mt-0.5" />
              }

              return (
                <div key={day}
                  className={`aspect-square rounded-xl flex flex-col items-center justify-center transition-all
                    ${bgClass} ${todayClass ? 'ring-2 ring-primary-500 ring-offset-1' : ''}
                  `}>
                  <span className={`text-sm font-semibold ${textClass}`}>{day}</span>
                  {indicator}
                  {session && !futureDay && (
                    <span className="text-[8px] text-gray-400 font-medium mt-0.5">
                      {session.learned_cards}
                    </span>
                  )}
                </div>
              )
            })}
          </div>

          {/* Legend */}
          <div className="flex items-center justify-center gap-6 mt-6 pt-4 border-t border-gray-100">
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-green-500" />
              <span className="text-xs text-gray-500">Goal Complete</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded-full bg-blue-400" />
              <span className="text-xs text-gray-500">Active Day</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-3 h-3 rounded bg-gray-50 border border-gray-200" />
              <span className="text-xs text-gray-500">No Activity</span>
            </div>
          </div>
        </div>

        {/* Recent Sessions */}
        {sessions.length > 0 && (
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">Recent Activity</h3>
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
                          Studied {s.learned_cards} cards
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
        {!loading && sessions.length === 0 && (
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center">
            <div className="w-16 h-16 rounded-full bg-gray-50 flex items-center justify-center mx-auto mb-4">
              <CalendarIcon size={28} className="text-gray-300" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-1">No Activity Yet</h3>
            <p className="text-sm text-gray-400 mb-6">Start studying flashcards to track your daily progress here.</p>
            <button onClick={() => navigate('/dashboard')}
              className="px-6 py-2.5 rounded-xl gradient-primary text-white text-sm font-bold cursor-pointer">
              Start Learning
            </button>
          </div>
        )}
      </div>
    </WebLayout>
  )
}
