import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { authAPI } from '../../services/api'
import { Eye, EyeOff, Briefcase, ArrowLeft, Mail, Lock, User, Phone, Shield, Tag, Copy, Check } from 'lucide-react'

export default function SaleRegisterPage() {
  const navigate = useNavigate()
  const { token } = useParams()
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [step, setStep] = useState(1)
  const [personalPromoCode, setPersonalPromoCode] = useState('')
  const [promoCopied, setPromoCopied] = useState(false)
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    countryCode: '+95',
    password: '',
    confirmPassword: ''
  })
  const [showPassword, setShowPassword] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    if (!token) {
      setError('Access denied. Registration token required.')
      return
    }
    if (token === 'salesHSK' || token.startsWith('sales_')) {
      setIsAuthorized(true)
    } else {
      setError('Invalid registration token.')
    }
  }, [token])

  const generatePromoCode = (firstName, lastName) => {
    const firstInitial = firstName.charAt(0).toUpperCase()
    const lastInitial = lastName.charAt(0).toUpperCase()
    const random = Math.random().toString(36).substring(2, 6).toUpperCase()
    return `${firstInitial}${lastInitial}${random}10`
  }

  const copyPromoCode = () => {
    navigator.clipboard.writeText(personalPromoCode)
    setPromoCopied(true)
    setTimeout(() => setPromoCopied(false), 2000)
  }

  const handleChange = (e) => {
    setFormData(prev => ({ ...prev, [e.target.name]: e.target.value }))
    if (error) setError('')
  }

  const handleNext = (e) => {
    e.preventDefault()
    if (!formData.firstName.trim() || !formData.lastName.trim()) {
      setError('First name and last name are required')
      return
    }
    if (!formData.email.trim() || !formData.email.includes('@')) {
      setError('Valid email is required')
      return
    }
    if (!formData.phone.trim()) {
      setError('Phone number is required')
      return
    }
    // Generate personal promo code
    const promoCode = generatePromoCode(formData.firstName, formData.lastName)
    setPersonalPromoCode(promoCode)
    setError('')
    setStep(2)
  }

  const handleRegister = async (e) => {
    e.preventDefault()
    if (formData.password.length < 6) {
      setError('Password must be at least 6 characters')
      return
    }
    if (formData.password !== formData.confirmPassword) {
      setError('Passwords do not match')
      return
    }

    setLoading(true)
    setError('')
    try {
      const res = await authAPI.register({
        firstName: formData.firstName,
        lastName: formData.lastName,
        email: formData.email,
        phone: formData.phone,
        countryCode: formData.countryCode,
        password: formData.password,
        role: 'sales',
        registrationToken: token,
        personalPromoCode: personalPromoCode
      })

      const { token: authToken, user } = res.data
      localStorage.setItem('sf_token', authToken)
      localStorage.setItem('sf_user', JSON.stringify(user))
      navigate('/sales')
    } catch (err) {
      setError(err.response?.data?.error || 'Registration failed. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  if (!isAuthorized) {
    return (
      <div className="min-h-screen flex items-center justify-center px-4">
        <div className="text-center">
          <div className="w-16 h-16 rounded-full bg-red-50 flex items-center justify-center mx-auto mb-4">
            <Shield size={32} className="text-red-400" />
          </div>
          <h2 className="text-xl font-bold text-gray-900 mb-2">Access Restricted</h2>
          <p className="text-gray-500 text-sm mb-6">{error || 'Sales registration is by invitation only.'}</p>
          <button onClick={() => navigate('/login')} className="px-6 py-3 rounded-xl gradient-primary text-white font-bold text-sm cursor-pointer">
            Back to Login
          </button>
        </div>
      </div>
    )
  }

  const countryCodes = [
    { code: '+95', flag: '🇲🇲' },
    { code: '+66', flag: '🇹🇭' },
    { code: '+86', flag: '🇨🇳' },
    { code: '+81', flag: '🇯🇵' },
    { code: '+82', flag: '🇰🇷' },
    { code: '+1', flag: '🇺🇸' },
  ]

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8">
      <div className="w-full max-w-md animate-fade-in">
        {/* Header */}
        <div className="flex items-center gap-3 mb-6">
          <button
            onClick={() => step === 2 ? setStep(1) : navigate('/login')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-100 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer"
          >
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <div>
            <h1 className="text-xl font-black text-gray-900">Sales Registration</h1>
            <p className="text-xs text-gray-500">Step {step} of 2</p>
          </div>
          <div className="ml-auto">
            <div className="px-3 py-1 rounded-full bg-amber-50 border border-amber-200">
              <span className="text-xs font-bold text-amber-600">Sales Team</span>
            </div>
          </div>
        </div>

        {/* Progress */}
        <div className="flex gap-2 mb-6">
          <div className={`h-1.5 rounded-full flex-1 ${step >= 1 ? 'bg-amber-500' : 'bg-gray-200'}`} />
          <div className={`h-1.5 rounded-full flex-1 ${step >= 2 ? 'bg-amber-500' : 'bg-gray-200'}`} />
        </div>

        {/* Form */}
        <div className="glass-card rounded-2xl p-6">
          {step === 1 ? (
            <form onSubmit={handleNext} className="space-y-4">
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">First Name</label>
                  <div className="relative">
                    <User size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                    <input name="firstName" value={formData.firstName} onChange={handleChange} placeholder="First name"
                      className="w-full pl-9 pr-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 focus:ring-2 focus:ring-amber-500/20 outline-none transition-all" />
                  </div>
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Last Name</label>
                  <input name="lastName" value={formData.lastName} onChange={handleChange} placeholder="Last name"
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 focus:ring-2 focus:ring-amber-500/20 outline-none transition-all" />
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Email</label>
                <div className="relative">
                  <Mail size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input name="email" type="email" value={formData.email} onChange={handleChange} placeholder="your@email.com"
                    className="w-full pl-9 pr-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 focus:ring-2 focus:ring-amber-500/20 outline-none transition-all" />
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Phone</label>
                <div className="flex gap-2">
                  <select name="countryCode" value={formData.countryCode} onChange={handleChange}
                    className="w-28 px-2 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 outline-none">
                    {countryCodes.map(c => (
                      <option key={c.code} value={c.code}>{c.flag} {c.code}</option>
                    ))}
                  </select>
                  <div className="relative flex-1">
                    <Phone size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                    <input name="phone" value={formData.phone} onChange={handleChange} placeholder="Phone number"
                      className="w-full pl-9 pr-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 focus:ring-2 focus:ring-amber-500/20 outline-none transition-all" />
                  </div>
                </div>
              </div>

              {error && (
                <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-medium">{error}</div>
              )}

              <button type="submit"
                className="w-full py-3.5 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-bold text-sm shadow-md transition-all cursor-pointer flex items-center justify-center gap-2">
                Continue <ArrowLeft size={16} className="rotate-180" />
              </button>
            </form>
          ) : (
            <form onSubmit={handleRegister} className="space-y-4">
              {/* Personal Promo Code Display */}
              <div className="p-4 rounded-xl bg-gradient-to-r from-amber-50 to-orange-50 border border-amber-200">
                <div className="flex items-center gap-2 mb-2">
                  <Tag size={16} className="text-amber-600" />
                  <span className="text-sm font-bold text-amber-700">Your Personal Promo Code</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="flex-1 px-4 py-3 rounded-lg bg-white border border-amber-300 font-mono text-lg font-bold text-amber-700 text-center">
                    {personalPromoCode}
                  </div>
                  <button type="button" onClick={copyPromoCode}
                    className="px-3 py-3 rounded-lg bg-amber-500 text-white hover:bg-amber-600 transition-colors cursor-pointer">
                    {promoCopied ? <Check size={16} /> : <Copy size={16} />}
                  </button>
                </div>
                <p className="text-xs text-amber-600 mt-2">Share this code for 10% discount - You earn 20% commission!</p>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Password</label>
                <div className="relative">
                  <Lock size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input name="password" type={showPassword ? 'text' : 'password'} value={formData.password} onChange={handleChange} placeholder="Minimum 6 characters"
                    className="w-full pl-9 pr-12 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 focus:ring-2 focus:ring-amber-500/20 outline-none transition-all" />
                  <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                    {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                  </button>
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Confirm Password</label>
                <div className="relative">
                  <Lock size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                  <input name="confirmPassword" type="password" value={formData.confirmPassword} onChange={handleChange} placeholder="Confirm your password"
                    className="w-full pl-9 pr-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-amber-500 focus:ring-2 focus:ring-amber-500/20 outline-none transition-all" />
                </div>
              </div>

              {error && (
                <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-medium">{error}</div>
              )}

              <button type="submit" disabled={loading}
                className="w-full py-3.5 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-bold text-sm shadow-md transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 cursor-pointer">
                {loading ? (
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <><Briefcase size={18} /> Register as Sales</>
                )}
              </button>
            </form>
          )}
        </div>

        <p className="text-center text-sm text-gray-500 mt-6">
          Already have an account?{' '}
          <button onClick={() => navigate('/login')} className="text-primary-500 font-bold hover:text-primary-600 cursor-pointer">Login</button>
        </p>
      </div>
    </div>
  )
}
