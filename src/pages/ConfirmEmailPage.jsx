import { useState, useEffect } from 'react'
import { useSearchParams } from 'react-router-dom'
import { Mail, Check, X, AlertCircle } from 'lucide-react'
import emailConfirmationService from '../services/emailConfirmationService.js'

export default function ConfirmEmailPage() {
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token')
  const [status, setStatus] = useState('loading') // 'loading' | 'success' | 'error'
  const [message, setMessage] = useState('')
  const [email, setEmail] = useState('')

  useEffect(() => {
    if (!token) {
      setStatus('error')
      setMessage('No confirmation token provided.')
      return
    }

    confirmEmail()
  }, [token])

  const confirmEmail = async () => {
    try {
      const response = await emailConfirmationService.confirmEmail(token)
      
      if (response.success) {
        setStatus('success')
        setMessage('Your email has been confirmed successfully!')
        setEmail(response.email || '')
      } else {
        setStatus('error')
        setMessage(response.error || 'Failed to confirm email.')
      }
    } catch (error) {
      console.error('Confirm email error:', error)
      setStatus('error')
      setMessage(error.response?.data?.error || 'Invalid or expired confirmation token. Please request a new confirmation email.')
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8 bg-gray-50">
      <div className="w-full max-w-md animate-fade-in">
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center">
          {/* Loading */}
          {status === 'loading' && (
            <>
              <div className="w-16 h-16 rounded-full bg-blue-100 flex items-center justify-center mx-auto mb-6">
                <div className="w-8 h-8 border-3 border-blue-200 border-t-blue-600 rounded-full animate-spin" />
              </div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">Confirming your email...</h2>
              <p className="text-gray-500 text-sm">Please wait while we verify your email address.</p>
            </>
          )}

          {/* Success */}
          {status === 'success' && (
            <>
              <div className="w-16 h-16 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-6">
                <Check size={32} className="text-green-600" />
              </div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">Email Confirmed!</h2>
              <p className="text-gray-500 text-sm mb-4">{message}</p>
              {email && (
                <p className="text-sm text-gray-600 mb-6">
                  <Mail size={14} className="inline mr-1" />
                  <strong>{email}</strong>
                </p>
              )}
              <div className="p-4 rounded-xl bg-green-50 border border-green-200 text-green-700 text-sm mb-6">
                <p className="font-medium">You can now return to the registration page to complete your account setup.</p>
              </div>
              <a
                href="#/register/salesHSK"
                className="inline-flex items-center justify-center px-6 py-3 gradient-primary text-white rounded-xl font-bold text-sm shadow-md hover:shadow-lg transition-all"
              >
                Back to Registration
              </a>
            </>
          )}

          {/* Error */}
          {status === 'error' && (
            <>
              <div className="w-16 h-16 rounded-full bg-red-100 flex items-center justify-center mx-auto mb-6">
                <X size={32} className="text-red-600" />
              </div>
              <h2 className="text-xl font-bold text-gray-900 mb-2">Confirmation Failed</h2>
              <p className="text-gray-500 text-sm mb-6">{message}</p>
              <a
                href="#/register/salesHSK"
                className="inline-flex items-center justify-center px-6 py-3 gradient-primary text-white rounded-xl font-bold text-sm shadow-md hover:shadow-lg transition-all"
              >
                Back to Registration
              </a>
            </>
          )}
        </div>
      </div>
    </div>
  )
}
