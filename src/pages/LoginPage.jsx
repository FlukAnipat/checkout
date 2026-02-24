import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../services/api'
import { Eye, EyeOff, LogIn, Shield, Lock, BookOpen } from 'lucide-react'

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
    setLoading(true)

    try {
      const res = await authAPI.login(email, password)
      const { token, user } = res.data

      localStorage.setItem('sf_token', token)
      localStorage.setItem('sf_user', JSON.stringify(user))

      // Redirect ตาม role
      if (user.role === 'admin') {
        navigate('/admin')
      } else if (user.role === 'sales') {
        navigate('/sales')
      } else if (user.isPaid) {
        navigate('/success')
      } else {
        navigate('/payment')
      }
    } catch (err) {
      setError(err.response?.data?.error || 'Login failed. Please try again.')
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
            <BookOpen className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl font-black text-gray-900 tracking-tight">
            HSK Shwe Flash
          </h1>
          <p className="text-gray-400 mt-1 text-sm">
            Secure Payment Portal
          </p>
        </div>

        {/* Login Card */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-7">
          <h2 className="text-lg font-bold text-gray-800 mb-1">
            Sign in to your account
          </h2>
          <p className="text-sm text-gray-400 mb-6">
            Use your app credentials to continue
          </p>

          {error && (
            <div className="mb-4 p-3 rounded-xl bg-red-50 border border-red-100 text-red-600 text-sm font-medium flex items-center gap-2">
              <span className="shrink-0 w-1.5 h-1.5 rounded-full bg-red-500" />
              {error}
            </div>
          )}

          <form onSubmit={handleLogin} className="space-y-4">
            {/* Email */}
            <div>
              <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                Email Address
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="you@example.com"
                required
                className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-gray-800 placeholder-gray-300 text-sm"
              />
            </div>

            {/* Password */}
            <div>
              <label className="block text-sm font-semibold text-gray-600 mb-1.5">
                Password
              </label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your password"
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
                  <LogIn size={18} />
                  Sign In
                </>
              )}
            </button>
          </form>

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
            Don't have an account? Download{' '}
            <span className="font-semibold text-primary-500">HSK Shwe Flash</span>{' '}
            app to register.
          </p>
          <p className="text-xs text-gray-300">
            &copy; {new Date().getFullYear()} HSK Shwe Flash. All rights reserved.
          </p>
        </div>
      </div>
    </div>
  )
}
