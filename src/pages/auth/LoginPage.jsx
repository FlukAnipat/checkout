import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../../services/api'
import { Eye, EyeOff, LogIn, UserPlus, Briefcase, KeyRound, Download } from 'lucide-react'

export default function LoginPage() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleLogin = async (e) => {
    e.preventDefault()
    setError('')
    if (!email.trim() || !password.trim()) {
      setError('Please enter email and password')
      return
    }

    setLoading(true)
    try {
      const res = await authAPI.login(email, password)
      const { token, user } = res.data
      localStorage.setItem('sf_token', token)
      localStorage.setItem('sf_user', JSON.stringify(user))

      // Redirect based on role
      if (user.role === 'admin') {
        navigate('/admin')
      } else if (user.role === 'sales') {
        navigate('/sales')
      } else {
        navigate('/dashboard')
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Login failed. Please check your credentials.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8">
      <div className="w-full max-w-md animate-fade-in">
        {/* Logo & Header */}
        <div className="text-center mb-8">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-2xl gradient-primary shadow-lg mb-4">
            <span className="text-3xl font-black text-white">HSK</span>
          </div>
          <h1 className="text-2xl font-black text-gray-900 tracking-tight">
            Shwe Flash
          </h1>
          <p className="text-gray-500 text-sm mt-1">Learn Chinese HSK Vocabulary</p>
        </div>

        {/* Login Form */}
        <div className="glass-card rounded-2xl p-6">
          <form onSubmit={handleLogin} className="space-y-4">
            {/* Email */}
            <div>
              <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="Enter your email"
                className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all"
              />
            </div>

            {/* Password */}
            <div>
              <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Password</label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your password"
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all pr-12"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            {/* Forgot Password */}
            <div className="text-right">
              <button
                type="button"
                onClick={() => navigate('/forgot-password')}
                className="text-xs text-primary-500 hover:text-primary-600 font-medium"
              >
                Forgot Password?
              </button>
            </div>

            {/* Error */}
            {error && (
              <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-medium">
                {error}
              </div>
            )}

            {/* Login Button */}
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3.5 rounded-xl gradient-primary text-white font-bold text-sm shadow-md hover:shadow-lg transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 cursor-pointer"
            >
              {loading ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  <LogIn size={18} />
                  Login
                </>
              )}
            </button>
          </form>
        </div>

        {/* Register Links */}
        <div className="mt-6 space-y-3">
          {/* User Register */}
          <div className="glass-card rounded-xl p-4 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-lg bg-blue-50 flex items-center justify-center">
                <UserPlus size={18} className="text-blue-500" />
              </div>
              <div>
                <p className="text-sm font-semibold text-gray-900">New User?</p>
                <p className="text-xs text-gray-500">Create an account to start learning</p>
              </div>
            </div>
            <button
              onClick={() => navigate('/register')}
              className="px-4 py-2 rounded-lg bg-blue-50 text-blue-600 text-xs font-bold hover:bg-blue-100 transition-colors cursor-pointer"
            >
              Register
            </button>
          </div>

          {/* Sales Register */}
          <div className="glass-card rounded-xl p-4 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-lg bg-amber-50 flex items-center justify-center">
                <Briefcase size={18} className="text-amber-500" />
              </div>
              <div>
                <p className="text-sm font-semibold text-gray-900">Sales Team?</p>
                <p className="text-xs text-gray-500">Register as a sales representative</p>
              </div>
            </div>
            <button
              onClick={() => navigate('/register/sale/salesHSK')}
              className="px-4 py-2 rounded-lg bg-amber-50 text-amber-600 text-xs font-bold hover:bg-amber-100 transition-colors cursor-pointer"
            >
              Join Sales
            </button>
          </div>
        </div>

        {/* Download App */}
        <div className="mt-6 glass-card rounded-xl p-4 text-center">
          <div className="flex items-center justify-center gap-2 mb-2">
            <Download size={16} className="text-green-500" />
            <p className="text-sm font-semibold text-gray-900">Download the App</p>
          </div>
          <p className="text-xs text-gray-500 mb-3">
            Get the full experience with our mobile app
          </p>
          <a
            href="#"
            className="inline-flex items-center gap-2 px-5 py-2.5 rounded-lg bg-gray-900 text-white text-xs font-bold hover:bg-gray-800 transition-colors"
          >
            <svg className="w-4 h-4" viewBox="0 0 24 24" fill="currentColor">
              <path d="M17.523 2.236L5.036 9.216c-.563.315-.563 1.253 0 1.568l12.487 6.98c.595.333 1.326-.11 1.326-.784V3.02c0-.674-.731-1.117-1.326-.784z"/>
            </svg>
            Download APK
          </a>
        </div>

        {/* Footer */}
        <p className="text-center text-xs text-gray-400 mt-6">
          &copy; 2024 HSK Shwe Flash. All rights reserved.
        </p>
      </div>
    </div>
  )
}
