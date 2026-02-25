import { useState, useEffect } from 'react'
import { Mail, RefreshCw, Check, X, AlertCircle, ExternalLink } from 'lucide-react'
import emailConfirmationService from '../services/emailConfirmationService.js'

export default function EmailConfirmation({ 
  email, 
  firstName, 
  lastName, 
  onConfirmed, 
  onCancel,
  onBack 
}) {
  const [isConfirmed, setIsConfirmed] = useState(false)
  const [isSending, setIsSending] = useState(false)
  const [isResending, setIsResending] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState(false)
  const [confirmationLink, setConfirmationLink] = useState('')
  const [timeLeft, setTimeLeft] = useState(86400) // 24 hours
  const [canResend, setCanResend] = useState(false)

  // Send confirmation email
  const sendConfirmationEmail = async () => {
    setIsSending(true)
    setError('')
    setSuccess(false)
    
    try {
      const response = await emailConfirmationService.sendConfirmation({
        email,
        firstName,
        lastName
      })
      
      if (response.success) {
        setSuccess(true)
        // For development - show confirmation link
        if (response.confirmationLink) {
          setConfirmationLink(response.confirmationLink)
        }
        // Start countdown for resend
        startResendCountdown()
      } else {
        setError(response.error || 'Failed to send confirmation email')
      }
    } catch (error) {
      console.error('Send confirmation error:', error)
      setError('Failed to send confirmation email. Please try again.')
    } finally {
      setIsSending(false)
    }
  }

  // Resend confirmation email
  const resendConfirmationEmail = async () => {
    setIsResending(true)
    setError('')
    setSuccess(false)
    
    try {
      const response = await emailConfirmationService.resendConfirmation({
        email,
        firstName,
        lastName
      })
      
      if (response.success) {
        setSuccess(true)
        // For development - show confirmation link
        if (response.confirmationLink) {
          setConfirmationLink(response.confirmationLink)
        }
        // Reset countdown
        startResendCountdown()
      } else {
        setError(response.error || 'Failed to resend confirmation email')
      }
    } catch (error) {
      console.error('Resend confirmation error:', error)
      setError('Failed to resend confirmation email. Please try again.')
    } finally {
      setIsResending(false)
    }
  }

  // Check if email is already confirmed
  const checkEmailStatus = async () => {
    try {
      const response = await emailConfirmationService.checkStatus(email)
      
      if (response.success && response.isConfirmed) {
        setIsConfirmed(true)
        onConfirmed()
      }
    } catch (error) {
      console.error('Check email status error:', error)
    }
  }

  // Start countdown for resend button
  const startResendCountdown = () => {
    setCanResend(false)
    setTimeLeft(60) // 1 minute cooldown
    
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

  // Format time for display
  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  // Auto-send confirmation email on mount
  useEffect(() => {
    sendConfirmationEmail()
    
    // Check email status periodically
    const statusTimer = setInterval(() => {
      checkEmailStatus()
    }, 5000) // Check every 5 seconds
    
    return () => clearInterval(statusTimer)
  }, [])

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="text-center">
        <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center mx-auto mb-4">
          <Mail size={24} className="text-blue-600" />
        </div>
        <h3 className="text-xl font-bold text-gray-900 mb-2">Confirm Your Email</h3>
        <p className="text-gray-600 text-sm">
          We've sent a confirmation link to {email}
        </p>
      </div>

      {/* Success Message */}
      {success && (
        <div className="p-4 rounded-xl bg-green-50 border border-green-200 text-green-700 text-sm font-medium flex items-start gap-3 animate-fade-in">
          <div className="shrink-0 w-5 h-5 rounded-full bg-green-100 flex items-center justify-center mt-0.5">
            <Check size={12} className="text-green-600" />
          </div>
          <div className="flex-1">
            <p className="font-semibold text-green-800">Confirmation Email Sent</p>
            <p className="text-green-600 mt-1">
              Please check your inbox and click the confirmation link to verify your email address.
            </p>
          </div>
        </div>
      )}

      {/* Error Message */}
      {error && (
        <div className="p-4 rounded-xl bg-red-50 border border-red-200 text-red-700 text-sm font-medium flex items-start gap-3 animate-fade-in">
          <div className="shrink-0 w-5 h-5 rounded-full bg-red-100 flex items-center justify-center mt-0.5">
            <span className="text-red-600 text-xs font-bold">!</span>
          </div>
          <div className="flex-1">
            <p className="font-semibold text-red-800">Error</p>
            <p className="text-red-600 mt-1">{error}</p>
          </div>
        </div>
      )}

      {/* Development - Show Confirmation Link */}
      {confirmationLink && (
        <div className="p-4 rounded-xl bg-yellow-50 border border-yellow-200 text-yellow-700 text-sm font-medium animate-fade-in">
          <div className="flex items-center gap-2 mb-2">
            <AlertCircle size={16} />
            <span className="font-semibold">Development Mode</span>
          </div>
          <p className="text-yellow-600 mb-2">
            Click the link below to confirm your email (for testing):
          </p>
          <a 
            href={confirmationLink} 
            target="_blank" 
            rel="noopener noreferrer"
            className="inline-flex items-center gap-2 text-blue-600 hover:text-blue-700 underline"
          >
            <ExternalLink size={14} />
            Open Confirmation Link
          </a>
        </div>
      )}

      {/* Instructions */}
      <div className="bg-gray-50 rounded-xl p-4 space-y-3">
        <h4 className="font-semibold text-gray-800 text-sm">Next Steps:</h4>
        <ol className="space-y-2 text-sm text-gray-600">
          <li className="flex items-start gap-2">
            <span className="w-5 h-5 rounded-full bg-gray-200 flex items-center justify-center text-xs font-bold mt-0.5">1</span>
            <span>Check your email inbox (including spam folder)</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="w-5 h-5 rounded-full bg-gray-200 flex items-center justify-center text-xs font-bold mt-0.5">2</span>
            <span>Click the confirmation link in the email</span>
          </li>
          <li className="flex items-start gap-2">
            <span className="w-5 h-5 rounded-full bg-gray-200 flex items-center justify-center text-xs font-bold mt-0.5">3</span>
            <span>Return here to complete registration</span>
          </li>
        </ol>
      </div>

      {/* Action Buttons */}
      <div className="space-y-3">
        {/* Resend Button */}
        <button
          onClick={resendConfirmationEmail}
          disabled={!canResend || isResending}
          className="w-full py-3 rounded-xl border border-gray-300 text-gray-700 font-medium text-sm hover:bg-gray-50 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
        >
          {isResending ? (
            <>
              <div className="w-4 h-4 border-2 border-gray-300 border-t-gray-600 rounded-full animate-spin" />
              Sending...
            </>
          ) : canResend ? (
            <>
              <RefreshCw size={16} />
              Resend Confirmation Email
            </>
          ) : (
            <>
              <RefreshCw size={16} />
              Resend in {formatTime(timeLeft)}
            </>
          )}
        </button>

        {/* Cancel Button */}
        <button
          onClick={onCancel}
          className="w-full py-3 rounded-xl border border-gray-300 text-gray-700 font-medium text-sm hover:bg-gray-50 transition-all duration-300"
        >
          Cancel
        </button>
      </div>

      {/* Help Text */}
      <div className="text-center">
        <p className="text-xs text-gray-500">
          Didn't receive the email? Check your spam folder or click "Resend Confirmation Email".
        </p>
      </div>
    </div>
  )
}
