import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { ArrowLeft, Crown, LogOut, Mail, Phone, Shield, Download, ChevronRight, Globe, Check, Pencil, Flame, BookOpen, Lock as LockIcon } from 'lucide-react'
import WebLayout from '../../components/WebLayout'
import { useLanguage } from '../../contexts/LanguageContext'
import { authAPI, vocabAPI } from '../../services/api'

export default function ProfilePage() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)
  const [showLangModal, setShowLangModal] = useState(false)
  const [showEditModal, setShowEditModal] = useState(false)
  const [showPasswordModal, setShowPasswordModal] = useState(false)
  const [stats, setStats] = useState({ dayStreak: 0, totalLearned: 0 })
  const [editForm, setEditForm] = useState({ firstName: '', lastName: '', phone: '', countryCode: '+95' })
  const [pwForm, setPwForm] = useState({ oldPassword: '', newPassword: '' })
  const [editMsg, setEditMsg] = useState(null)
  const [pwMsg, setPwMsg] = useState(null)
  const { language, setLanguage, currentLang, availableLanguages, tr } = useLanguage()

  useEffect(() => {
    const userData = JSON.parse(localStorage.getItem('sf_user') || '{}')
    setUser(userData)
    const userId = userData.user_id || userData.userId
    if (userId) {
      vocabAPI.getUserStats(userId).then(res => {
        setStats(res.data.stats || { dayStreak: 0, totalLearned: 0 })
      }).catch(() => {})
    }
  }, [])

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/')
  }

  const openEditModal = () => {
    setEditForm({
      firstName: user.first_name || user.firstName || '',
      lastName: user.last_name || user.lastName || '',
      phone: user.phone || '',
      countryCode: user.country_code || user.countryCode || '+95',
    })
    setEditMsg(null)
    setShowEditModal(true)
  }

  const handleSaveProfile = async () => {
    try {
      const res = await authAPI.updateProfile({
        firstName: editForm.firstName,
        lastName: editForm.lastName,
        phone: editForm.phone,
        countryCode: editForm.countryCode,
      })
      const updated = res.data.user || { ...user, first_name: editForm.firstName, last_name: editForm.lastName, phone: editForm.phone, country_code: editForm.countryCode }
      localStorage.setItem('sf_user', JSON.stringify(updated))
      setUser(updated)
      setEditMsg({ type: 'success', text: tr('success') })
      setTimeout(() => setShowEditModal(false), 800)
    } catch (err) {
      setEditMsg({ type: 'error', text: err.response?.data?.error || tr('error') })
    }
  }

  const handleChangePassword = async () => {
    if (pwForm.newPassword.length < 6) {
      setPwMsg({ type: 'error', text: 'Password must be at least 6 characters' })
      return
    }
    try {
      await authAPI.changePassword(pwForm.oldPassword, pwForm.newPassword)
      setPwMsg({ type: 'success', text: tr('success') })
      setTimeout(() => setShowPasswordModal(false), 800)
    } catch (err) {
      setPwMsg({ type: 'error', text: err.response?.data?.error || tr('error') })
    }
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
        <div className="text-center mb-6">
          <h1 className="text-3xl font-black text-gray-900">{tr('profile')}</h1>
        </div>

        {/* User Info Card (matches Flutter _ProfileCard) */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 mb-4">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-2xl gradient-primary flex items-center justify-center">
              <span className="text-2xl font-black text-white">
                {(user.first_name || user.firstName || 'U')[0].toUpperCase()}
              </span>
            </div>
            <div className="flex-1">
              <h2 className="text-lg font-bold text-gray-900">{fullName || 'User'}</h2>
              <p className="text-sm text-gray-400">{email}</p>
              <div className="flex items-center gap-2 mt-1">
                {isPaid ? (
                  <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-amber-50 border border-amber-200 text-xs font-bold text-amber-600">
                    <Crown size={10} /> {tr('premium')}
                  </span>
                ) : (
                  <span className="inline-flex items-center gap-1 px-2.5 py-1 rounded-full bg-gray-50 border border-gray-200 text-xs font-bold text-gray-500">
                    {tr('free')}
                  </span>
                )}
              </div>
            </div>
            <button onClick={openEditModal}
              className="w-10 h-10 rounded-xl bg-gray-50 flex items-center justify-center hover:bg-gray-100 transition-colors cursor-pointer">
              <Pencil size={16} className="text-gray-500" />
            </button>
          </div>
        </div>

        {/* Stats (matches Flutter _StatCard row) */}
        <div className="grid grid-cols-2 gap-3 mb-5">
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 text-center">
            <Flame size={22} className="text-orange-500 mx-auto mb-2" />
            <div className="text-2xl font-black text-gray-900">{stats.dayStreak}</div>
            <div className="text-[10px] text-gray-500 font-medium">{tr('dayStreak')}</div>
          </div>
          <div className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 text-center">
            <BookOpen size={22} className="text-blue-500 mx-auto mb-2" />
            <div className="text-2xl font-black text-gray-900">{stats.totalLearned}</div>
            <div className="text-[10px] text-gray-500 font-medium">{tr('totalCards')}</div>
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
              <h3 className="font-bold text-white">{tr('upgradeToPremium')}</h3>
              <p className="text-sm text-white/70">{tr('unlockFeatures')}</p>
            </div>
            <ChevronRight size={20} className="text-white/60" />
          </button>
        )}

        {/* Settings */}
        <p className="text-sm font-bold text-gray-500 mb-3 px-1">{tr('settings')}</p>

        {/* Language Selector */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 mb-3">
          <button onClick={() => setShowLangModal(true)}
            className="w-full px-5 py-4 flex items-center gap-3 cursor-pointer hover:bg-gray-50 transition-colors rounded-2xl">
            <div className="w-10 h-10 rounded-lg bg-indigo-50 flex items-center justify-center">
              <Globe size={16} className="text-indigo-500" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">{tr('language')}</p>
              <p className="text-xs text-gray-400">{currentLang.nativeName}</p>
            </div>
            <span className="px-2.5 py-1 rounded-lg bg-indigo-50 text-xs font-bold text-indigo-600">{currentLang.code}</span>
            <ChevronRight size={16} className="text-gray-300" />
          </button>
        </div>

        {/* Change Password */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 mb-3">
          <button onClick={() => { setPwForm({ oldPassword: '', newPassword: '' }); setPwMsg(null); setShowPasswordModal(true) }}
            className="w-full px-5 py-4 flex items-center gap-3 cursor-pointer hover:bg-gray-50 transition-colors rounded-2xl">
            <div className="w-10 h-10 rounded-lg bg-orange-50 flex items-center justify-center">
              <LockIcon size={16} className="text-orange-500" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">{tr('changePassword')}</p>
            </div>
            <ChevronRight size={16} className="text-gray-300" />
          </button>
        </div>

        {/* Download App */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 mb-4">
          <button onClick={() => window.open('#', '_blank')}
            className="w-full px-5 py-4 flex items-center gap-3 cursor-pointer hover:bg-gray-50 transition-colors rounded-2xl">
            <div className="w-10 h-10 rounded-lg bg-gray-900 flex items-center justify-center">
              <Download size={16} className="text-white" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-sm text-gray-900 font-medium">{tr('downloadApp')} (APK)</p>
              <p className="text-xs text-gray-400">{tr('getFullMobileExperience')}</p>
            </div>
            <ChevronRight size={16} className="text-gray-300" />
          </button>
        </div>

        {/* Logout */}
        <button onClick={handleLogout}
          className="w-full py-3.5 rounded-2xl bg-red-50 border border-red-100 text-red-500 font-bold text-sm flex items-center justify-center gap-2 cursor-pointer hover:bg-red-100 transition-colors">
          <LogOut size={16} />
          {tr('logout')}
        </button>
      </div>

      {/* Language Selection Modal */}
      {showLangModal && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={() => setShowLangModal(false)} />
          <div className="relative bg-white w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6 pb-8 animate-fade-in">
            <div className="w-10 h-1 bg-gray-200 rounded-full mx-auto mb-5" />
            <h3 className="text-xl font-black text-gray-900 text-center mb-5">{tr('selectLanguage')}</h3>
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

      {/* Edit Profile Modal (matches Flutter _showEditProfile) */}
      {showEditModal && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={() => setShowEditModal(false)} />
          <div className="relative bg-white w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6 pb-8 animate-fade-in">
            <div className="w-10 h-1 bg-gray-200 rounded-full mx-auto mb-5" />
            <h3 className="text-xl font-black text-gray-900 text-center mb-5">{tr('editProfile')}</h3>
            <div className="space-y-3">
              <div>
                <label className="text-xs text-gray-500 font-medium mb-1 block">{tr('firstName')}</label>
                <input type="text" value={editForm.firstName} onChange={e => setEditForm({...editForm, firstName: e.target.value})}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm outline-none focus:border-blue-300 transition-colors" />
              </div>
              <div>
                <label className="text-xs text-gray-500 font-medium mb-1 block">{tr('lastName')}</label>
                <input type="text" value={editForm.lastName} onChange={e => setEditForm({...editForm, lastName: e.target.value})}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm outline-none focus:border-blue-300 transition-colors" />
              </div>
              <div>
                <label className="text-xs text-gray-500 font-medium mb-1 block">{tr('phone')}</label>
                <input type="text" value={editForm.phone} onChange={e => setEditForm({...editForm, phone: e.target.value})}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm outline-none focus:border-blue-300 transition-colors" />
              </div>
              {editMsg && (
                <p className={`text-sm font-medium text-center ${editMsg.type === 'success' ? 'text-green-600' : 'text-red-500'}`}>{editMsg.text}</p>
              )}
              <button onClick={handleSaveProfile}
                className="w-full py-3.5 rounded-2xl gradient-primary text-white font-bold text-sm cursor-pointer hover:shadow-md transition-all">
                {tr('saveProfile')}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Change Password Modal (matches Flutter _showChangePassword) */}
      {showPasswordModal && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={() => setShowPasswordModal(false)} />
          <div className="relative bg-white w-full max-w-md rounded-t-3xl sm:rounded-3xl p-6 pb-8 animate-fade-in">
            <div className="w-10 h-1 bg-gray-200 rounded-full mx-auto mb-5" />
            <h3 className="text-xl font-black text-gray-900 text-center mb-5">{tr('changePassword')}</h3>
            <div className="space-y-3">
              <div>
                <label className="text-xs text-gray-500 font-medium mb-1 block">{tr('currentPassword')}</label>
                <input type="password" value={pwForm.oldPassword} onChange={e => setPwForm({...pwForm, oldPassword: e.target.value})}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm outline-none focus:border-blue-300 transition-colors" />
              </div>
              <div>
                <label className="text-xs text-gray-500 font-medium mb-1 block">{tr('newPassword')}</label>
                <input type="password" value={pwForm.newPassword} onChange={e => setPwForm({...pwForm, newPassword: e.target.value})}
                  className="w-full px-4 py-3 rounded-xl bg-gray-50 border border-gray-200 text-sm outline-none focus:border-blue-300 transition-colors" />
              </div>
              {pwMsg && (
                <p className={`text-sm font-medium text-center ${pwMsg.type === 'success' ? 'text-green-600' : 'text-red-500'}`}>{pwMsg.text}</p>
              )}
              <button onClick={handleChangePassword}
                className="w-full py-3.5 rounded-2xl bg-orange-500 text-white font-bold text-sm cursor-pointer hover:bg-orange-600 transition-colors">
                {tr('changePassword')}
              </button>
            </div>
          </div>
        </div>
      )}
    </WebLayout>
  )
}
