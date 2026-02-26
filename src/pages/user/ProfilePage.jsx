import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { ArrowLeft, Crown, LogOut, Mail, Phone, Shield, Download, ChevronRight, Globe, Check } from 'lucide-react'
import WebLayout from '../../components/WebLayout'
import { useLanguage } from '../../contexts/LanguageContext'

export default function ProfilePage() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)
  const [showLangModal, setShowLangModal] = useState(false)
  const { language, setLanguage, currentLang, availableLanguages } = useLanguage()

  useEffect(() => {
    const userData = JSON.parse(localStorage.getItem('sf_user') || '{}')
    setUser(userData)
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/')
  }

  if (!user) return null

  const isPaid = user.is_paid || user.isPaid || false
  const fullName = `${user.first_name || user.firstName || ''} ${user.last_name || user.lastName || ''}`.trim()
  const email = user.email || ''
  const phone = user.phone || ''
  const role = user.role || 'user'

  return (
    <WebLayout>
      <div className="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="flex items-center gap-3 mb-6">
          <button onClick={() => navigate('/dashboard')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer">
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <h1 className="text-2xl font-black text-gray-900">Profile</h1>
        </div>

        {/* User Info Card */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-4">
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
                  <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-amber-50 border border-amber-200 text-xs font-bold text-amber-600">
                    <Crown size={10} /> Premium
                  </span>
                ) : (
                  <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-gray-50 border border-gray-200 text-xs font-bold text-gray-500">
                    Free
                  </span>
                )}
                <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-blue-50 border border-blue-200 text-xs font-bold text-blue-500 capitalize">
                  {role}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Details */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 divide-y divide-gray-100 mb-4">
          <div className="px-5 py-4 flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-blue-50 flex items-center justify-center">
              <Mail size={16} className="text-blue-500" />
            </div>
            <div className="flex-1">
              <p className="text-xs text-gray-400 font-medium uppercase">Email</p>
              <p className="text-sm text-gray-900 font-medium">{email}</p>
            </div>
          </div>
          <div className="px-5 py-4 flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-green-50 flex items-center justify-center">
              <Phone size={16} className="text-green-500" />
            </div>
            <div className="flex-1">
              <p className="text-xs text-gray-400 font-medium uppercase">Phone</p>
              <p className="text-sm text-gray-900 font-medium">{user.country_code || user.countryCode || '+95'} {phone}</p>
            </div>
          </div>
          <div className="px-5 py-4 flex items-center gap-3">
            <div className="w-10 h-10 rounded-lg bg-purple-50 flex items-center justify-center">
              <Shield size={16} className="text-purple-500" />
            </div>
            <div className="flex-1">
              <p className="text-xs text-gray-400 font-medium uppercase">Account Type</p>
              <p className="text-sm text-gray-900 font-medium capitalize">{role}</p>
            </div>
          </div>
        </div>

        {/* Premium CTA */}
        {!isPaid && (
          <button onClick={() => navigate('/payment')}
            className="w-full rounded-2xl bg-gradient-to-r from-amber-400 to-orange-500 p-5 text-left flex items-center gap-4 cursor-pointer shadow-sm hover:shadow-md transition-all mb-4">
            <div className="w-12 h-12 rounded-xl bg-white/20 flex items-center justify-center">
              <Crown size={22} className="text-white" />
            </div>
            <div className="flex-1">
              <h3 className="font-bold text-white">Upgrade to Premium</h3>
              <p className="text-sm text-white/70">Unlock all HSK levels and features</p>
            </div>
            <ChevronRight size={20} className="text-white/60" />
          </button>
        )}

        {/* Settings */}
        <p className="text-sm font-bold text-gray-500 mb-3 px-1">Settings</p>

        {/* Language Selector */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 mb-4">
          <button onClick={() => setShowLangModal(true)}
            className="w-full px-5 py-4 flex items-center gap-3 cursor-pointer hover:bg-gray-50 transition-colors rounded-2xl">
            <div className="w-10 h-10 rounded-lg bg-indigo-50 flex items-center justify-center">
              <Globe size={16} className="text-indigo-500" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">Language</p>
              <p className="text-xs text-gray-400">{currentLang.nativeName}</p>
            </div>
            <span className="px-2.5 py-1 rounded-lg bg-indigo-50 text-xs font-bold text-indigo-600">{currentLang.code}</span>
            <ChevronRight size={16} className="text-gray-300" />
          </button>
        </div>

        {/* Actions */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 mb-4">
          <button onClick={() => window.open('#', '_blank')}
            className="w-full px-5 py-4 flex items-center gap-3 cursor-pointer hover:bg-gray-50 transition-colors rounded-2xl">
            <div className="w-10 h-10 rounded-lg bg-gray-900 flex items-center justify-center">
              <Download size={16} className="text-white" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">Download App (APK)</p>
              <p className="text-xs text-gray-400">Get the full mobile experience</p>
            </div>
            <ChevronRight size={16} className="text-gray-300" />
          </button>
        </div>

        {/* Logout */}
        <button onClick={handleLogout}
          className="w-full py-3.5 rounded-2xl bg-red-50 border border-red-100 text-red-500 font-bold text-sm flex items-center justify-center gap-2 cursor-pointer hover:bg-red-100 transition-colors">
          <LogOut size={16} />
          Logout
        </button>
      </div>

      {/* Language Selection Modal */}
      {showLangModal && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={() => setShowLangModal(false)} />
          <div className="relative bg-white w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6 pb-8 animate-fade-in">
            <div className="w-10 h-1 bg-gray-200 rounded-full mx-auto mb-5" />
            <h3 className="text-xl font-black text-gray-900 text-center mb-5">Select Language</h3>
            <div className="space-y-3">
              {availableLanguages.map((lang) => {
                const selected = language === lang.key
                return (
                  <button
                    key={lang.key}
                    onClick={() => { setLanguage(lang.key); setShowLangModal(false) }}
                    className={`w-full flex items-center gap-4 p-4 rounded-2xl border-2 transition-all cursor-pointer
                      ${selected ? 'border-indigo-500 bg-indigo-50' : 'border-gray-100 bg-gray-50 hover:border-gray-200'}`}
                  >
                    <span className="text-2xl">{lang.flag}</span>
                    <div className="flex-1 text-left">
                      <p className="text-sm font-bold text-gray-900">{lang.name}</p>
                      <p className="text-xs text-gray-500">{lang.nativeName}</p>
                    </div>
                    {selected && (
                      <div className="w-6 h-6 rounded-full bg-indigo-500 flex items-center justify-center">
                        <Check size={14} className="text-white" />
                      </div>
                    )}
                  </button>
                )
              })}
            </div>
          </div>
        </div>
      )}
    </WebLayout>
  )
}
