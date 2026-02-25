import { useState, useEffect } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { authAPI } from '../services/api'
import CountryPhoneInput from '../components/CountryPhoneInput.jsx'
import OTPVerification from '../components/OTPVerification.jsx'
import { Eye, EyeOff, UserPlus, Shield, Lock, Building } from 'lucide-react'

export default function RegisterPage() {
  const navigate = useNavigate()
  const { token } = useParams()
  const [isAuthorized, setIsAuthorized] = useState(false)
  const [tokenError, setTokenError] = useState('')
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    countryCode: '+95',
    country: 'Myanmar',
    phoneValid: false,
    password: '',
    confirmPassword: ''
  })
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)
  const [showOTP, setShowOTP] = useState(false)
  const [otpVerified, setOtpVerified] = useState(false)

  // Validate registration token
  useEffect(() => {
    if (!token) {
      setTokenError('Access denied. Registration token required.')
      return
    }

    // Token validation for sales registration
    if (token === 'salesHSK') {
      // Special token for HSK sales team
      setIsAuthorized(true)
    } else {
      // Check if token starts with 'sales_' (for future dynamic tokens)
      if (token.startsWith('sales_')) {
        setIsAuthorized(true)
      } else {
        setTokenError('Invalid registration token. Please contact your app administrator.')
      }
    }
  }, [token])

  if (!isAuthorized) {
    return (
      <div className="min-h-screen flex items-center justify-center px-4 py-8">
        <div className="w-full max-w-md text-center">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-red-100 mb-4">
            <Shield className="w-8 h-8 text-red-600" />
          </div>
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Access Restricted</h1>
          <p className="text-gray-600 mb-6">
            {tokenError || 'Sales registration is by invitation only.'}
          </p>
          <a href="#/login" className="inline-flex items-center justify-center px-6 py-3 bg-primary-500 text-white rounded-xl hover:bg-primary-600 transition-colors">
            Back to Login
          </a>
        </div>
      </div>
    )
  }

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
    if (error) setError('')
  }

  const validateForm = () => {
    if (!formData.firstName.trim() || !formData.lastName.trim()) {
      setError('First name and last name are required')
      return false
    }
    if (!formData.email.trim() || !formData.email.includes('@')) {
      setError('Valid email is required')
      return false
    }
    if (formData.password.length < 6) {
      setError('Password must be at least 6 characters')
      return false
    }
    if (formData.password !== formData.confirmPassword) {
      setError('Passwords do not match')
      return false
    }
    if (!formData.phoneValid) {
      setError('Valid phone number is required')
      return false
    }
    if (!otpVerified) {
      setError('Phone number verification is required')
      return false
    }
    return true
  }

  const handleShowOTP = (e) => {
    e.preventDefault()
    setError('')
    
    if (!formData.firstName.trim() || !formData.lastName.trim() || !formData.email.trim() || !formData.phoneValid) {
      setError('Please fill in all required fields and verify phone number')
      return
    }
    
    setShowOTP(true)
  }

  const handleRegister = async (e) => {
    e.preventDefault()
    setError('')
    
    if (!validateForm()) return
    
    setLoading(true)

    try {
      const res = await authAPI.register({
        firstName: formData.firstName,
        lastName: formData.lastName,
        email: formData.email,
        phone: formData.phone,
        countryCode: formData.countryCode,
        password: formData.password
      })

      const { token, user } = res.data
      localStorage.setItem('sf_token', token)
      localStorage.setItem('sf_user', JSON.stringify(user))

      // Redirect to sales dashboard
      navigate('#/sales')
    } catch (err) {
      setError(err.response?.data?.error || 'Registration failed. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8">
      <div className="w-full max-w-md animate-fade-in">
        {/* Logo & Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl gradient-primary shadow-lg mb-4">
            <Building className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl font-black text-gray-900 tracking-tight">
            HSK Shwe Flash
          </h1>
          <p className="text-gray-400 mt-1 text-sm">
            Sales Registration
          </p>
        </div>

        {/* Registration Card */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-7">
          <h2 className="text-lg font-bold text-gray-800 mb-1">
            Create Sales Account
          </h2>
          <p className="text-sm text-gray-400 mb-6">
            Register as a sales person to start selling
          </p>

          {error && (
            <div className="mb-4 p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 text-sm font-medium flex items-start gap-3 animate-fade-in">
              <div className="shrink-0 w-5 h-5 rounded-full bg-red-100 flex items-center justify-center mt-0.5">
                <span className="text-red-600 text-xs font-bold">!</span>
              </div>
              <div className="flex-1">
                <p className="font-semibold text-red-800">Registration Failed</p>
                <p className="text-red-600 mt-1">{error}</p>
                <p className="text-red-500 text-xs mt-2">Please check your information and try again.</p>
              </div>
            </div>
          )}

          {!showOTP ? (
            <form onSubmit={handleShowOTP} className="space-y-4">
              {/* Name Fields */}
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                    First Name
                  </label>
                  <input
                    type="text"
                    name="firstName"
                    value={formData.firstName}
                    onChange={handleChange}
                    placeholder="John"
                    required
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-gray-800 placeholder-gray-300 text-sm"
                  />
                </div>
                <div>
                  <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                    Last Name
                  </label>
                  <input
                    type="text"
                    name="lastName"
                    value={formData.lastName}
                    onChange={handleChange}
                    placeholder="Doe"
                    required
                    className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-gray-800 placeholder-gray-300 text-sm"
                  />
                </div>
              </div>
            </div>

            {/* Email */}
            <div>
              <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                Email Address
              </label>
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="you@example.com"
                required
                className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-gray-800 placeholder-gray-300 text-sm"
              />
            </div>

            {/* Phone */}
            <CountryPhoneInput
              value={{
                countryCode: formData.countryCode,
                phone: formData.phone,
                country: formData.country
              }}
              onChange={(phoneData) => {
                setFormData(prev => ({
                  ...prev,
                  ...phoneData,
                  phoneValid: phoneData.phone !== '' && phoneData.phone !== undefined
                }))
                if (error) setError('')
              }}
              error={error}
              setError={setError}
            />

            {/* Password */}
            <div>
              <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                Password
              </label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  name="password"
                  value={formData.password}
                  onChange={handleChange}
                  placeholder="Min 6 characters"
                  required
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-gray-800 placeholder-gray-300 pr-12 text-sm"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-300 hover:text-gray-500 transition-colors cursor-pointer"
                >
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            {/* Confirm Password */}
            <div>
              <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                Confirm Password
              </label>
              <div className="relative">
                <input
                  type={showConfirmPassword ? 'text' : 'password'}
                  name="confirmPassword"
                  value={formData.confirmPassword}
                  onChange={handleChange}
                  placeholder="Confirm password"
                  required
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-gray-800 placeholder-gray-300 pr-12 text-sm"
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-300 hover:text-gray-500 transition-colors cursor-pointer"
                >
                  {showConfirmPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            {/* Submit */}
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3.5 rounded-xl gradient-primary text-white font-bold text-sm shadow-md hover:shadow-lg transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 cursor-pointer mt-2"
            >
              {loading ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <UserPlus size={18} />
                  Verify Phone Number
                </>
              )}
            </button>
          </form>
          ) : (
            <OTPVerification
              phoneNumber={formData.phone}
              countryCode={formData.countryCode}
              onVerified={() => setOtpVerified(true)}
              onCancel={() => setShowOTP(false)}
              onBack={() => setShowOTP(false)}
            />
          )}
        </div>

          {/* Login Link */}
          <div className="mt-6 text-center">
            <p className="text-sm text-gray-400">
              Already have an account?{' '}
              <a href="#/login" className="text-primary-500 font-semibold hover:text-primary-600 transition-colors">
                Sign in here
              </a>
            </p>
          </div>

          {/* Security badges */}
          <div className="mt-6 pt-5 border-t border-gray-100">
            <div className="flex items-center justify-center gap-4 text-gray-300">
              <div className="flex items-center gap-1.5">
                <Shield size={14} />
                <span className="text-xs font-medium">SSL Secured</span>
              </div>
              <div className="w-1 h-1 rounded-full bg-gray-200" />
              <div className="flex items-center gap-1.5">
                <Lock size={14} />
                <span className="text-xs font-medium">Encrypted</span>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center mt-6 space-y-2">
          <p className="text-xs text-gray-400">
            Sales accounts are for authorized personnel only.
          </p>
          <p className="text-xs text-gray-300">
            &copy; {new Date().getFullYear()} HSK Shwe Flash. All rights reserved.
          </p>
        </div>
      </div>
    </div>
  )
}
