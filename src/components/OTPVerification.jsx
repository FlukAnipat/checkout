import { useState, useEffect } from 'react'
import { Phone, Mail, RefreshCw, Check, X, AlertCircle } from 'lucide-react'
import otpService from '../services/otpService.js'

export default function OTPVerification({ 
  phoneNumber, 
  countryCode, 
  onVerified, 
  onCancel,
  onBack 
}) {
  const [otp, setOtp] = useState(['', '', '', '', '', '', ''])
  const [isLoading, setIsLoading] = useState(false)
  const [isSending, setIsSending] = useState(false)
  const [timeLeft, setTimeLeft] = useState(300) // 5 minutes
  const [canResend, setCanResend] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState(false)
  const [attempts, setAttempts] = useState(0)
  const [otpSent, setOtpSent] = useState(false)

  // Handle OTP input change
  const handleOTPChange = (index, value) => {
    if (value.length <= 1) {
      const newOTP = [...otp]
      newOTP[index] = value
      setOtp(newOTP)
      setError('')
      
      // Auto-verify when all 6 digits are entered
      if (newOTP.every(digit => digit !== '')) {
        handleVerifyOTP(newOTP.join(''))
      }
    }
  }

  // Handle key press
  const handleKeyPress = (e, index) => {
    if (e.key === 'Backspace') {
      e.preventDefault()
      if (otp[index] === '') {
        // Move to previous input
        if (index > 0) {
          const prevInput = document.getElementById(`otp-${index - 1}`)
          if (prevInput) {
            prevInput.focus()
            handleOTPChange(index - 1, '')
          }
        }
      } else {
        handleOTPChange(index, '')
      }
    }
  }

  // Send OTP
  const sendOTP = async () => {
    setIsSending(true)
    setError('')
    
    try {
      const response = await otpService.sendOTP(phoneNumber, countryCode)
      
      if (response.success) {
        setOtpSent(true)
        setCanResend(false)
        setTimeLeft(300)
        startTimer()
        
        // For development, show the OTP
        if (response.otp) {
          console.log(`📱 OTP for ${countryCode}${phoneNumber}: ${response.otp}`)
        }
      }
    } catch (err) {
      setError(err.error || 'Failed to send OTP')
    } finally {
      setIsSending(false)
    }
  }

  // Verify OTP
  const handleVerifyOTP = async (otpValue) => {
    setIsLoading(true)
    setError('')
    
    try {
      const response = await otpService.verifyOTP(phoneNumber, countryCode, otpValue)
      
      if (response.success) {
        setSuccess(true)
        setTimeout(() => {
          onVerified()
        }, 1000)
      }
    } catch (err) {
      const errorMessage = err.error || 'Invalid OTP'
      setError(errorMessage)
      
      // Handle attempts limit
      if (err.attemptsRemaining !== undefined) {
        setAttempts(3 - err.attemptsRemaining)
      }
      
      // Clear OTP on error
      setOtp(['', '', '', '', '', ''])
    } finally {
      setIsLoading(false)
    }
  }

  // Resend OTP
  const resendOTP = async () => {
    setIsSending(true)
    setError('')
    
    try {
      const response = await otpService.resendOTP(phoneNumber, countryCode)
      
      if (response.success) {
        setOtp(['', '', '', '', '', ''])
        setCanResend(false)
        setTimeLeft(300)
        setAttempts(0)
        startTimer()
        
        // For development, show the OTP
        if (response.otp) {
          console.log(`📱 Resent OTP for ${countryCode}${phoneNumber}: ${response.otp}`)
        }
      }
    } catch (err) {
      setError(err.error || 'Failed to resend OTP')
    } finally {
      setIsSending(false)
    }
  }

  // Timer countdown
  const startTimer = () => {
    const timer = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev <= 1) {
          clearInterval(timer)
          setCanResend(true)
          return 0
        }
        return prev - 1
      })
    }, 1000)
  }

  // Auto-send OTP on mount
  useEffect(() => {
    sendOTP()
  }, [])

  // Format time
  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  if (success) {
    return (
      <div className="text-center py-8">
        <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-4">
          <Check size={32} className="text-green-600" />
        </div>
        <h3 className="text-xl font-bold text-gray-900 mb-2">Phone Verified!</h3>
        <p className="text-gray-600">Your phone number has been successfully verified.</p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="text-center">
        <div className="w-12 h-12 rounded-full bg-primary-100 flex items-center justify-center mx-auto mb-4">
          <Phone size={24} className="text-primary-600" />
        </div>
        <h3 className="text-xl font-bold text-gray-900 mb-2">Verify Your Phone</h3>
        <p className="text-gray-600 text-sm">
          We've sent a 6-digit code to {countryCode} {phoneNumber}
        </p>
      </div>

      {/* OTP Input */}
      <div className="space-y-4">
        <div className="flex justify-center gap-2">
          {otp.map((digit, index) => (
            <input
              key={index}
              id={`otp-${index}`}
              type="text"
              inputMode="numeric"
              maxLength={1}
              value={digit}
              onChange={(e) => handleOTPChange(index, e.target.value)}
              onKeyDown={(e) => handleKeyPress(e, index)}
              className={`w-12 h-12 text-center text-lg font-bold border-2 rounded-lg focus:outline-none focus:ring-2 transition-colors ${
                error
                  ? 'border-red-300 focus:ring-red-500 focus:border-red-500'
                  : digit
                  ? 'border-primary-500 bg-primary-50'
                  : 'border-gray-300 focus:ring-primary-500 focus:border-primary-500'
              }`}
              disabled={isLoading}
            />
          ))}
        </div>

        {error && (
          <div className="flex items-center gap-2 p-3 bg-red-50 border border-red-200 rounded-lg">
            <AlertCircle size={16} className="text-red-500 flex-shrink-0" />
            <span className="text-sm text-red-700">{error}</span>
          </div>
        )}

        {attempts > 0 && (
          <p className="text-xs text-orange-600 text-center">
            {3 - attempts} attempts remaining
          </p>
        )}
      </div>

      {/* Timer and Resend */}
      <div className="text-center space-y-4">
        {!canResend ? (
          <div className="flex items-center justify-center gap-2 text-gray-500">
            <Mail size={16} />
            <span className="text-sm">Resend code in {formatTime(timeLeft)}</span>
          </div>
        ) : (
          <button
            onClick={resendOTP}
            disabled={isSending}
            className="flex items-center justify-center gap-2 px-4 py-2 text-sm text-primary-600 hover:text-primary-700 font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isSending ? (
              <>
                <div className="w-4 h-4 border-2 border-primary-600 border-t-transparent rounded-full animate-spin" />
                <span>Sending...</span>
              </>
            ) : (
              <>
                <RefreshCw size={16} />
                <span>Resend Code</span>
              </>
            )}
          </button>
        )}
      </div>

      {/* Actions */}
      <div className="flex gap-3">
        <button
          onClick={onBack}
          className="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-xl hover:bg-gray-50 transition-colors font-medium"
        >
          Back
        </button>
        <button
          onClick={onCancel}
          className="flex-1 px-4 py-3 border border-gray-300 text-gray-700 rounded-xl hover:bg-gray-50 transition-colors font-medium"
        >
          Cancel
        </button>
      </div>
    </div>
  )
}
