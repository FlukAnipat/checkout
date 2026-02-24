import { useEffect, useState } from 'react'
import { useLocation, useNavigate } from 'react-router-dom'
import {
  Crown,
  CheckCircle2,
  ArrowRight,
  Download,
  Sparkles,
  BookOpen,
  Headphones,
  Globe,
  Zap,
  BarChart3,
} from 'lucide-react'

export default function SuccessPage() {
  const location = useLocation()
  const navigate = useNavigate()
  const [user, setUser] = useState(null)
  const payment = location.state?.payment || null

  useEffect(() => {
    const stored = localStorage.getItem('sf_user')
    if (stored) setUser(JSON.parse(stored))
  }, [])

  const formatPrice = (amount) => new Intl.NumberFormat('en-US').format(amount)

  const handleBackToApp = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/login')
  }

  const UNLOCKED = [
    { icon: BookOpen, label: 'All HSK Levels (1-7)', desc: '5,000+ vocabulary words' },
    { icon: Headphones, label: 'AI Voice & Native Audio', desc: 'Perfect pronunciation' },
    { icon: Zap, label: 'Unlimited Flashcards', desc: 'No daily limits' },
    { icon: Globe, label: 'Multi-language', desc: 'Chinese, English & Burmese' },
    { icon: BarChart3, label: 'Progress Tracking', desc: 'Detailed statistics' },
  ]

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-8 confetti-bg">
      <div className="w-full max-w-md text-center">
        {/* Success Icon */}
        <div className="relative mb-6 animate-scale-in">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-full bg-green-50 border-4 border-green-100">
            <div className="animate-check">
              <CheckCircle2 className="w-12 h-12 text-green-500" />
            </div>
          </div>
        </div>

        {/* Title */}
        <div className="animate-fade-in">
          <h1 className="text-2xl font-black text-gray-900 mb-1">
            Payment Successful
          </h1>
          <p className="text-gray-400 text-sm">
            Welcome to <span className="font-bold text-primary-500">HSK Shwe Flash Premium</span>
          </p>
        </div>

        {/* Receipt Card */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mt-6 mb-5 text-left animate-fade-in-delay">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-11 h-11 rounded-xl gradient-primary flex items-center justify-center">
              <Crown className="w-5 h-5 text-gold-400" />
            </div>
            <div>
              <h3 className="font-bold text-gray-900 text-sm">Premium Lifetime</h3>
              <p className="text-xs text-gray-400">{user?.email}</p>
            </div>
            <div className="ml-auto">
              <span className="inline-flex items-center gap-1 text-green-600 text-xs font-bold bg-green-50 px-2.5 py-1 rounded-lg">
                <CheckCircle2 size={12} />
                Active
              </span>
            </div>
          </div>

          {payment && (
            <div className="bg-gray-50 rounded-xl p-4 space-y-2.5 text-sm">
              <div className="flex justify-between">
                <span className="text-gray-400">Transaction ID</span>
                <span className="font-mono text-xs text-gray-500">
                  {payment.paymentId?.slice(0, 12)}...
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-400">Amount</span>
                <span className="font-bold text-gray-800">
                  {formatPrice(payment.amount)} {payment.currency}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-400">Method</span>
                <span className="text-gray-600 font-medium capitalize">
                  {payment.paymentMethod?.replace(/([A-Z])/g, ' $1') || 'N/A'}
                </span>
              </div>
              <div className="flex justify-between">
                <span className="text-gray-400">Status</span>
                <span className="text-green-600 font-semibold">Completed</span>
              </div>
            </div>
          )}
        </div>

        {/* Unlocked Features */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-6 text-left animate-fade-in-delay-2">
          <h3 className="font-bold text-gray-800 mb-3 text-sm flex items-center gap-2">
            <Sparkles className="w-4 h-4 text-gold-500" />
            Now Unlocked
          </h3>
          <div className="space-y-2.5">
            {UNLOCKED.map((item, i) => (
              <div key={i} className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-lg bg-green-50 flex items-center justify-center shrink-0">
                  <item.icon size={16} className="text-green-500" />
                </div>
                <div className="flex-1">
                  <p className="text-xs font-semibold text-gray-700">{item.label}</p>
                  <p className="text-[10px] text-gray-400">{item.desc}</p>
                </div>
                <CheckCircle2 size={14} className="text-green-400 shrink-0" />
              </div>
            ))}
          </div>
        </div>

        {/* CTA */}
        <div className="animate-fade-in-delay-2">
          <button
            onClick={handleBackToApp}
            className="w-full py-4 rounded-2xl gradient-primary text-white font-bold text-sm shadow-lg hover:shadow-xl transition-all duration-300 flex items-center justify-center gap-2 cursor-pointer"
          >
            <Download size={18} />
            Open HSK Shwe Flash App
            <ArrowRight size={16} />
          </button>

          <p className="text-[11px] text-gray-300 mt-4">
            Premium status will sync automatically when you open the app.
          </p>
        </div>
      </div>
    </div>
  )
}
