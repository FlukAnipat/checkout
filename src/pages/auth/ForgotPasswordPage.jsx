import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { otpAPI } from '../../services/api'
import { ArrowLeft, Mail, KeyRound, Lock, CheckCircle } from 'lucide-react'

export default function ForgotPasswordPage() {
  const navigate = useNavigate()
  const [step, setStep] = useState(1) // 1: email, 2: otp, 3: new password, 4: success
  const [email, setEmail] = useState('')
  const [otp, setOtp] = useState('')
  const [newPassword, setNewPassword] = useState('')
  const [confirmPassword, setConfirmPassword] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  const handleSendOTP = async (e) => {
    e.preventDefault()
    if (!email.trim() || !email.includes('@')) {
      setError('Please enter a valid email')
      return
    }
    setLoading(true)
    setError('')
    try {
      await otpAPI.sendOTP(email)
      setStep(2)
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to send OTP. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const handleVerifyOTP = async (e) => {
    e.preventDefault()
    if (!otp.trim() || otp.length !== 4) {
      setError('Please enter 4-digit OTP')
      return
    }
    setLoading(true)
    setError('')
    try {
      await otpAPI.verifyOTP(email, otp)
      setStep(3)
    } catch (err) {
      setError(err.response?.data?.error || 'Invalid OTP. Please try again.')
    } finally {
      setLoading(false)
    }
  }

  const handleResetPassword = async (e) => {
    e.preventDefault()
    if (newPassword.length < 6) {
      setError('Password must be at least 6 characters')
      return
    }
    if (newPassword !== confirmPassword) {
      setError('Passwords do not match')
      return
    }
    setLoading(true)
    setError('')
    try {
      await otpAPI.resetPassword(email, otp, newPassword)
      setStep(4)
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to reset password.')
    } finally {
      setLoading(false)
    }
  }

  if (step === 4) {
    return (
      <div className="min-h-screen flex items-center justify-center px-4">
        <div className="w-full max-w-md text-center animate-fade-in">
          <div className="w-16 h-16 rounded-full bg-green-50 flex items-center justify-center mx-auto mb-4">
            <CheckCircle size={32} className="text-green-500" />
          </div>
          <h2 className="text-xl font-bold text-gray-900 mb-2">Password Reset!</h2>
          <p className="text-gray-500 text-sm mb-6">Your password has been reset successfully.</p>
          <button onClick={() => navigate('/login')} className="px-8 py-3 rounded-xl gradient-primary text-white font-bold text-sm cursor-pointer">
            Login Now
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8">
      <div className="w-full max-w-md animate-fade-in">
        {/* Header */}
        <div className="flex items-center gap-3 mb-6">
          <button
            onClick={() => step > 1 ? setStep(step - 1) : navigate('/login')}
            className="w-10 h-10 rounded-xl bg-white shadow-sm border border-gray-100 flex items-center justify-center hover:bg-gray-50 transition-colors cursor-pointer"
          >
            <ArrowLeft size={18} className="text-gray-600" />
          </button>
          <div>
            <h1 className="text-xl font-black text-gray-900">Reset Password</h1>
            <p className="text-xs text-gray-500">Step {step} of 3</p>
          </div>
        </div>

        {/* Progress */}
        <div className="flex gap-2 mb-6">
          <div className={`h-1.5 rounded-full flex-1 ${step >= 1 ? 'bg-primary-500' : 'bg-gray-200'}`} />
          <div className={`h-1.5 rounded-full flex-1 ${step >= 2 ? 'bg-primary-500' : 'bg-gray-200'}`} />
          <div className={`h-1.5 rounded-full flex-1 ${step >= 3 ? 'bg-primary-500' : 'bg-gray-200'}`} />
        </div>

        <div className="glass-card rounded-2xl p-6">
          {step === 1 && (
            <form onSubmit={handleSendOTP} className="space-y-4">
              <div className="text-center mb-4">
                <div className="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center mx-auto mb-3">
                  <Mail size={24} className="text-blue-500" />
                </div>
                <p className="text-sm text-gray-600">Enter your email to receive a verification code</p>
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Email</label>
                <input type="email" value={email} onChange={(e) => { setEmail(e.target.value); setError('') }}
                  placeholder="your@email.com"
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all" />
              </div>
              {error && <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-medium">{error}</div>}
              <button type="submit" disabled={loading}
                className="w-full py-3.5 rounded-xl gradient-primary text-white font-bold text-sm shadow-md transition-all disabled:opacity-50 flex items-center justify-center gap-2 cursor-pointer">
                {loading ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Send OTP'}
              </button>
            </form>
          )}

          {step === 2 && (
            <form onSubmit={handleVerifyOTP} className="space-y-4">
              <div className="text-center mb-4">
                <div className="w-12 h-12 rounded-full bg-amber-50 flex items-center justify-center mx-auto mb-3">
                  <KeyRound size={24} className="text-amber-500" />
                </div>
                <p className="text-sm text-gray-600">Enter the 4-digit code sent to <strong>{email}</strong></p>
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">OTP Code</label>
                <input type="text" value={otp} onChange={(e) => { setOtp(e.target.value.replace(/\D/g, '').slice(0, 4)); setError('') }}
                  placeholder="0000" maxLength={4}
                  className="w-full px-4 py-4 rounded-xl border border-gray-200 bg-gray-50/50 text-2xl text-center tracking-[1em] font-bold focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all" />
              </div>
              {error && <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-medium">{error}</div>}
              <button type="submit" disabled={loading}
                className="w-full py-3.5 rounded-xl gradient-primary text-white font-bold text-sm shadow-md transition-all disabled:opacity-50 flex items-center justify-center gap-2 cursor-pointer">
                {loading ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Verify OTP'}
              </button>
            </form>
          )}

          {step === 3 && (
            <form onSubmit={handleResetPassword} className="space-y-4">
              <div className="text-center mb-4">
                <div className="w-12 h-12 rounded-full bg-green-50 flex items-center justify-center mx-auto mb-3">
                  <Lock size={24} className="text-green-500" />
                </div>
                <p className="text-sm text-gray-600">Create your new password</p>
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">New Password</label>
                <input type="password" value={newPassword} onChange={(e) => { setNewPassword(e.target.value); setError('') }}
                  placeholder="Minimum 6 characters"
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1.5 uppercase tracking-wider">Confirm Password</label>
                <input type="password" value={confirmPassword} onChange={(e) => { setConfirmPassword(e.target.value); setError('') }}
                  placeholder="Confirm your password"
                  className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 text-sm focus:border-primary-500 focus:ring-2 focus:ring-primary-500/20 outline-none transition-all" />
              </div>
              {error && <div className="p-3 rounded-xl bg-red-50 border border-red-200 text-red-600 text-xs font-medium">{error}</div>}
              <button type="submit" disabled={loading}
                className="w-full py-3.5 rounded-xl gradient-primary text-white font-bold text-sm shadow-md transition-all disabled:opacity-50 flex items-center justify-center gap-2 cursor-pointer">
                {loading ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Reset Password'}
              </button>
            </form>
          )}
        </div>

        <p className="text-center text-sm text-gray-500 mt-6">
          Remember your password?{' '}
          <button onClick={() => navigate('/login')} className="text-primary-500 font-bold hover:text-primary-600 cursor-pointer">Login</button>
        </p>
      </div>
    </div>
  )
}
