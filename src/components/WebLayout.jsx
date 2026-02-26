import { useState } from 'react'
import { useNavigate, useLocation } from 'react-router-dom'
import { BookOpen, Crown, LogOut, User, Bookmark, Home, Menu, X, Download, LogIn, UserPlus, Calendar } from 'lucide-react'
import { useLanguage } from '../contexts/LanguageContext'

export default function WebLayout({ children }) {
  const navigate = useNavigate()
  const location = useLocation()
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false)
  const { tr } = useLanguage()

  const token = localStorage.getItem('sf_token')
  const user = token ? JSON.parse(localStorage.getItem('sf_user') || '{}') : null
  const isGuest = !token
  const isPaid = user?.is_paid || user?.isPaid || false
  const firstName = user?.first_name || user?.firstName || 'Guest'

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/')
  }

  const navItems = isGuest ? [
    { path: '/dashboard', label: tr('hskLevels'), icon: BookOpen },
  ] : [
    { path: '/dashboard', label: tr('hskLevels'), icon: BookOpen },
    { path: '/progress', label: tr('calendar'), icon: Calendar },
    { path: '/saved', label: tr('savedWords'), icon: Bookmark },
    { path: '/profile', label: tr('profile'), icon: User },
  ]

  const isActive = (path) => location.pathname === path || location.pathname.startsWith(path + '/')

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-white to-blue-50/30">
      {/* Top Navigation Bar */}
      <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-xl border-b border-gray-200/60">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <button onClick={() => navigate('/')} className="flex items-center gap-2.5 cursor-pointer group">
              <div className="w-9 h-9 rounded-lg gradient-primary flex items-center justify-center shadow-sm group-hover:shadow-md transition-shadow">
                <span className="text-white font-black text-sm">HSK</span>
              </div>
              <div className="hidden sm:block">
                <span className="text-lg font-black text-gray-900">Shwe Flash</span>
              </div>
            </button>

            {/* Desktop Navigation */}
            <nav className="hidden md:flex items-center gap-1">
              {navItems.map(item => (
                <button
                  key={item.path}
                  onClick={() => navigate(item.path)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all cursor-pointer
                    ${isActive(item.path)
                      ? 'bg-primary-50 text-primary-600'
                      : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'
                    }
                  `}
                >
                  <item.icon size={16} />
                  {item.label}
                </button>
              ))}
            </nav>

            {/* Right Actions */}
            <div className="flex items-center gap-2">
              {isGuest ? (
                <>
                  <button onClick={() => navigate('/login')}
                    className="hidden sm:flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-100 transition-colors cursor-pointer">
                    <LogIn size={16} />
                    {tr('login')}
                  </button>
                  <button onClick={() => navigate('/register')}
                    className="flex items-center gap-2 px-4 py-2 rounded-lg gradient-primary text-white text-sm font-bold shadow-sm hover:shadow-md transition-all cursor-pointer">
                    <UserPlus size={16} />
                    <span className="hidden sm:inline">{tr('signUp')}</span>
                    <span className="sm:hidden">{tr('signUp')}</span>
                  </button>
                </>
              ) : (
                <>
                  {!isPaid && (
                    <button onClick={() => navigate('/payment')}
                      className="hidden sm:flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-gradient-to-r from-amber-400 to-amber-500 text-white text-xs font-bold shadow-sm hover:shadow-md transition-all cursor-pointer">
                      <Crown size={14} />
                      {tr('premium')}
                    </button>
                  )}
                  {isPaid && (
                    <div className="hidden sm:flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-amber-50 border border-amber-200">
                      <Crown size={14} className="text-amber-500" />
                      <span className="text-xs font-bold text-amber-600">{tr('premium')}</span>
                    </div>
                  )}
                  <div className="hidden md:flex items-center gap-2 pl-2 border-l border-gray-200 ml-2">
                    <span className="text-sm font-medium text-gray-700">{firstName}</span>
                    <button onClick={handleLogout}
                      className="p-2 rounded-lg text-gray-400 hover:text-red-500 hover:bg-red-50 transition-colors cursor-pointer"
                      title="Logout">
                      <LogOut size={16} />
                    </button>
                  </div>
                </>
              )}

              {/* Mobile menu toggle */}
              <button onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                className="md:hidden p-2 rounded-lg text-gray-600 hover:bg-gray-100 cursor-pointer">
                {mobileMenuOpen ? <X size={20} /> : <Menu size={20} />}
              </button>
            </div>
          </div>
        </div>

        {/* Mobile Menu */}
        {mobileMenuOpen && (
          <div className="md:hidden border-t border-gray-100 bg-white animate-fade-in">
            <div className="px-4 py-3 space-y-1">
              {navItems.map(item => (
                <button
                  key={item.path}
                  onClick={() => { navigate(item.path); setMobileMenuOpen(false) }}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all cursor-pointer
                    ${isActive(item.path)
                      ? 'bg-primary-50 text-primary-600'
                      : 'text-gray-600 hover:bg-gray-50'
                    }
                  `}
                >
                  <item.icon size={18} />
                  {item.label}
                </button>
              ))}

              {isGuest && (
                <button onClick={() => { navigate('/login'); setMobileMenuOpen(false) }}
                  className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-gray-600 hover:bg-gray-50 cursor-pointer">
                  <LogIn size={18} />
                  {tr('login')}
                </button>
              )}

              {!isGuest && (
                <>
                  {!isPaid && (
                    <button onClick={() => { navigate('/payment'); setMobileMenuOpen(false) }}
                      className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-bold text-amber-600 bg-amber-50 cursor-pointer">
                      <Crown size={18} />
                      {tr('upgradeToPremium')}
                    </button>
                  )}
                  <div className="border-t border-gray-100 pt-2 mt-2">
                    <div className="px-4 py-2 text-xs text-gray-400">Signed in as {user?.email}</div>
                    <button onClick={() => { handleLogout(); setMobileMenuOpen(false) }}
                      className="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-red-500 hover:bg-red-50 cursor-pointer">
                      <LogOut size={18} />
                      {tr('logout')}
                    </button>
                  </div>
                </>
              )}
            </div>
          </div>
        )}
      </header>

      {/* Guest Banner */}
      {isGuest && location.pathname !== '/' && (
        <div className="bg-gradient-to-r from-blue-600 to-indigo-600 text-white">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-2.5 flex items-center justify-between">
            <p className="text-sm font-medium">
              {tr('tryFree')}
            </p>
            <button onClick={() => navigate('/register')}
              className="px-3 py-1 rounded-lg bg-white/20 text-xs font-bold hover:bg-white/30 transition-colors cursor-pointer">
              {tr('registerFree')}
            </button>
          </div>
        </div>
      )}

      {/* Main Content */}
      <main>
        {children}
      </main>
    </div>
  )
}
