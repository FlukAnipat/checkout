import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { authAPI } from '../../services/api'
import { Eye, EyeOff, LogIn, UserPlus, Briefcase, BookOpen, Crown, Zap, Award, ArrowLeft } from 'lucide-react'

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
    <div className="min-h-screen flex">
      {/* Left Panel - Info (desktop only) */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 text-white flex-col justify-between p-12 relative overflow-hidden">
        <div className="absolute inset-0 opacity-10">
          <div className="absolute top-20 left-10 w-72 h-72 bg-primary-500 rounded-full blur-3xl"></div>
          <div className="absolute bottom-20 right-10 w-96 h-96 bg-blue-500 rounded-full blur-3xl"></div>
        </div>

        <div className="relative z-10">
          <button onClick={() => navigate('/')} className="flex items-center gap-2.5 mb-16 cursor-pointer group">
            <div className="w-10 h-10 rounded-lg gradient-primary flex items-center justify-center">
              <span className="text-white font-black text-base">HSK</span>
            </div>
            <span className="text-xl font-black">Shwe Flash</span>
          </button>

          <h1 className="text-4xl font-black mb-4 leading-tight">
            Master Chinese<br />HSK Vocabulary
          </h1>
          <p className="text-lg text-gray-400 mb-12 max-w-md">
            The most effective way to learn Chinese with flashcards, study modes, and progress tracking.
          </p>

          <div className="space-y-6">
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center flex-shrink-0">
                <BookOpen size={20} className="text-blue-400" />
              </div>
              <div>
                <h3 className="font-bold text-sm">5,000+ Words</h3>
                <p className="text-gray-400 text-sm">Complete HSK 1-6 vocabulary</p>
              </div>
            </div>
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center flex-shrink-0">
                <Zap size={20} className="text-amber-400" />
              </div>
              <div>
                <h3 className="font-bold text-sm">Smart Flashcards</h3>
                <p className="text-gray-400 text-sm">Interactive study with multi-language support</p>
              </div>
            </div>
            <div className="flex items-start gap-4">
              <div className="w-10 h-10 rounded-lg bg-white/10 flex items-center justify-center flex-shrink-0">
                <Award size={20} className="text-green-400" />
              </div>
              <div>
                <h3 className="font-bold text-sm">Track Progress</h3>
                <p className="text-gray-400 text-sm">Detailed stats and achievements</p>
              </div>
            </div>
          </div>
        </div>

        <div className="relative z-10 text-sm text-gray-500">
          &copy; 2026 HSK Shwe Flash
        </div>
      </div>

      {/* Right Panel - Login Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-6 sm:p-12">
        <div className="w-full max-w-md animate-fade-in">
          {/* Mobile back button & logo */}
          <div className="lg:hidden mb-8">
            <button onClick={() => navigate('/')} className="flex items-center gap-2 text-sm text-gray-500 hover:text-gray-700 mb-6 cursor-pointer">
              <ArrowLeft size={16} />
              Back to Home
            </button>
            <div className="flex items-center gap-2.5">
              <div className="w-10 h-10 rounded-lg gradient-primary flex items-center justify-center">
                <span className="text-white font-black text-base">HSK</span>
              </div>
              <span className="text-xl font-black text-gray-900">Shwe Flash</span>
            </div>
          </div>

          <h2 className="text-2xl font-black text-gray-900 mb-1">Welcome back</h2>
          <p className="text-gray-500 text-sm mb-8">Sign in to continue learning</p>

          {/* Login Form */}
          <form onSubmit={handleLogin} className="space-y-5">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Email</label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="you@example.com"
                className="w-full px-4 py-3 rounded-xl border border-gray-300 bg-white text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">Password</label>
              <div className="relative">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder="Enter your password"
                  className="w-full px-4 py-3 rounded-xl border border-gray-300 bg-white text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all pr-12"
                />
                <button type="button" onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600 cursor-pointer">
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            <div className="flex items-center justify-between">
              <label className="flex items-center gap-2 cursor-pointer">
                <input type="checkbox" className="w-4 h-4 rounded border-gray-300 text-primary-500 focus:ring-primary-500" />
                <span className="text-sm text-gray-600">Remember me</span>
              </label>
              <button type="button" onClick={() => navigate('/forgot-password')}
                className="text-sm text-primary-500 hover:text-primary-600 font-medium cursor-pointer">
                Forgot password?
              </button>
            </div>

            {error && (
              <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-sm font-medium">
                {error}
              </div>
            )}

            <button type="submit" disabled={loading}
              className="w-full py-3 rounded-xl gradient-primary text-white font-bold text-sm shadow-md hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 cursor-pointer">
              {loading ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <><LogIn size={18} /> Sign In</>
              )}
            </button>
          </form>

          <div className="mt-8 flex items-center gap-4">
            <div className="flex-1 h-px bg-gray-200"></div>
            <span className="text-xs text-gray-400 font-medium">OR</span>
            <div className="flex-1 h-px bg-gray-200"></div>
          </div>

          {/* Register Options */}
          <div className="mt-6 grid grid-cols-1 sm:grid-cols-2 gap-3">
            <button onClick={() => navigate('/register')}
              className="flex items-center justify-center gap-2 px-4 py-3 rounded-xl border border-gray-200 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 hover:border-gray-300 transition-all cursor-pointer">
              <UserPlus size={16} className="text-blue-500" />
              Create Account
            </button>
            <button onClick={() => navigate('/register/sale/salesHSK')}
              className="flex items-center justify-center gap-2 px-4 py-3 rounded-xl border border-gray-200 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50 hover:border-gray-300 transition-all cursor-pointer">
              <Briefcase size={16} className="text-amber-500" />
              Join Sales
            </button>
          </div>

          {/* Try as guest */}
          <div className="mt-6 text-center">
            <button onClick={() => navigate('/dashboard')}
              className="text-sm text-gray-500 hover:text-primary-500 font-medium cursor-pointer">
              Or continue as guest →
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
