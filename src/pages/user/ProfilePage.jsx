import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../../services/api'
import { ArrowLeft, Crown, LogOut, User, Mail, Phone, Shield, Download, Home, Bookmark, ChevronRight } from 'lucide-react'

export default function ProfilePage() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)

  useEffect(() => {
    const userData = JSON.parse(localStorage.getItem('sf_user') || '{}')
    setUser(userData)
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/login')
  }

  if (!user) return null

  const isPaid = user.is_paid || user.isPaid || false
  const fullName = `${user.first_name || user.firstName || ''} ${user.last_name || user.lastName || ''}`.trim()
  const email = user.email || ''
  const phone = user.phone || ''
  const role = user.role || 'user'

  return (
    <div className="app-container pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4">
        <div className="flex items-center gap-3">
          <button onClick={() => navigate('/dashboard')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-100 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <h1 className="text-xl font-black text-gray-900">Profile</h1>
        </div>
      </div>

      {/* User Info Card */}
      <div className="px-5 mb-4">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-50 p-5">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-2xl gradient-primary flex items-center justify-center">
              <span className="text-2xl font-black text-white">
                {(user.first_name || user.firstName || 'U')[0].toUpperCase()}
              </span>
            </div>
            <div className="flex-1">
              <h2 className="text-lg font-bold text-gray-900">{fullName || 'User'}</h2>
              <div className="flex items-center gap-2 mt-1">
                {isPaid ? (
                  <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-amber-50 border border-amber-200 text-xs font-bold text-amber-600">
                    <Crown size={10} /> Premium
                  </span>
                ) : (
                  <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-gray-50 border border-gray-200 text-xs font-bold text-gray-500">
                    Free
                  </span>
                )}
                <span className="inline-flex items-center gap-1 px-2 py-0.5 rounded-full bg-blue-50 border border-blue-200 text-xs font-bold text-blue-500 capitalize">
                  {role}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Details */}
      <div className="px-5 mb-4">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-50 divide-y divide-gray-50">
          <div className="px-4 py-3.5 flex items-center gap-3">
            <div className="w-9 h-9 rounded-lg bg-blue-50 flex items-center justify-center">
              <Mail size={16} className="text-blue-500" />
            </div>
            <div className="flex-1">
              <p className="text-[10px] text-gray-400 font-medium uppercase">Email</p>
              <p className="text-sm text-gray-900 font-medium">{email}</p>
            </div>
          </div>
          <div className="px-4 py-3.5 flex items-center gap-3">
            <div className="w-9 h-9 rounded-lg bg-green-50 flex items-center justify-center">
              <Phone size={16} className="text-green-500" />
            </div>
            <div className="flex-1">
              <p className="text-[10px] text-gray-400 font-medium uppercase">Phone</p>
              <p className="text-sm text-gray-900 font-medium">{user.country_code || user.countryCode || '+95'} {phone}</p>
            </div>
          </div>
          <div className="px-4 py-3.5 flex items-center gap-3">
            <div className="w-9 h-9 rounded-lg bg-purple-50 flex items-center justify-center">
              <Shield size={16} className="text-purple-500" />
            </div>
            <div className="flex-1">
              <p className="text-[10px] text-gray-400 font-medium uppercase">Account Type</p>
              <p className="text-sm text-gray-900 font-medium capitalize">{role}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Premium CTA */}
      {!isPaid && (
        <div className="px-5 mb-4">
          <button onClick={() => navigate('/payment')}
            className="w-full rounded-2xl bg-gradient-to-r from-amber-400 to-orange-500 p-4 text-left flex items-center gap-3 cursor-pointer shadow-sm hover:shadow-md transition-all">
            <div className="w-10 h-10 rounded-xl bg-white/20 flex items-center justify-center">
              <Crown size={20} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="text-sm font-bold text-white">Upgrade to Premium</h3>
              <p className="text-xs text-white/70">Unlock all HSK levels and features</p>
            </div>
            <ChevronRight size={18} className="text-white/60" />
          </button>
        </div>
      )}

      {/* Actions */}
      <div className="px-5 mb-4">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-50 divide-y divide-gray-50">
          <button onClick={() => window.open('#', '_blank')}
            className="w-full px-4 py-3.5 flex items-center gap-3 cursor-pointer hover:bg-gray-50 transition-colors">
            <div className="w-9 h-9 rounded-lg bg-gray-900 flex items-center justify-center">
              <Download size={16} className="text-white" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">Download App (APK)</p>
              <p className="text-[10px] text-gray-400">Get the full mobile experience</p>
            </div>
            <ChevronRight size={16} className="text-gray-300" />
          </button>
        </div>
      </div>

      {/* Logout */}
      <div className="px-5">
        <button onClick={handleLogout}
          className="w-full py-3.5 rounded-2xl bg-red-50 border border-red-100 text-red-500 font-bold text-sm flex items-center justify-center gap-2 cursor-pointer hover:bg-red-100 transition-colors">
          <LogOut size={16} />
          Logout
        </button>
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
                ${tab.id === 'profile' ? 'text-primary-500' : 'text-gray-400 hover:text-gray-600'}
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
