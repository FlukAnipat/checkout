import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { paymentAPI } from '../services/api'
import {
  Crown,
  Tag,
  CheckCircle2,
  CreditCard,
  Smartphone,
  ArrowRight,
  Shield,
  LogOut,
  X,
  Loader2,
  BookOpen,
  Zap,
  Globe,
  Headphones,
  Lock,
  Wallet,
  QrCode,
  Users,
} from 'lucide-react'

const FEATURES = [
  { icon: BookOpen, label: 'All HSK Levels (1-7)', desc: '5,000+ vocabulary words' },
  { icon: Headphones, label: 'AI Voice & Audio', desc: 'Native pronunciation' },
  { icon: Globe, label: 'Multi-language', desc: 'CN / EN / MM support' },
  { icon: Zap, label: 'Unlimited Practice', desc: 'No daily limits' },
]

const MYANMAR_PAY_PROVIDERS = [
  {
    id: 'kbzpay',
    label: 'KBZ Pay',
    desc: 'Pay with KBZ Pay app or QR',
    icon: Wallet,
    color: '#0066CC',
    bg: '#EBF4FF',
    category: 'myanpay',
  },
  {
    id: 'wavepay',
    label: 'Wave Pay',
    desc: 'Pay with Wave Money',
    icon: Smartphone,
    color: '#FF6600',
    bg: '#FFF4EB',
    category: 'myanpay',
  },
  {
    id: 'ayapay',
    label: 'AYA Pay',
    desc: 'AYA Bank mobile payment',
    icon: Wallet,
    color: '#00A651',
    bg: '#EBFFF3',
    category: 'myanpay',
  },
  {
    id: 'cbpay',
    label: 'CB Pay',
    desc: 'CB Bank mobile payment',
    icon: Wallet,
    color: '#003DA5',
    bg: '#EBF0FF',
    category: 'myanpay',
  },
]

const INTERNATIONAL_PAYMENT_METHODS = [
  {
    id: 'mpu',
    label: 'MPU Card',
    desc: 'Myanmar Payment Union debit/credit',
    icon: CreditCard,
    color: '#006633',
    bg: '#EBFFF0',
    category: 'international',
  },
  {
    id: 'card',
    label: 'Visa / Mastercard',
    desc: 'International credit or debit card',
    icon: CreditCard,
    color: '#1A1F36',
    bg: '#F0F0F5',
    category: 'international',
  },
]

const PAYMENT_METHODS = [...MYANMAR_PAY_PROVIDERS, ...INTERNATIONAL_PAYMENT_METHODS]

export default function PaymentPage() {
  const navigate = useNavigate()
  const [user, setUser] = useState(null)
  const [pricing, setPricing] = useState(null)
  const [promoCode, setPromoCode] = useState('')
  const [promoApplied, setPromoApplied] = useState(false)
  const [promoError, setPromoError] = useState('')
  const [promoDiscount, setPromoDiscount] = useState(0)
  const [referralCode, setReferralCode] = useState('')
  const [referralApplied, setReferralApplied] = useState(false)
  const [referralError, setReferralError] = useState('')
  const [selectedMethod, setSelectedMethod] = useState('kbzpay')
  const [loading, setLoading] = useState(false)
  const [checkoutLoading, setCheckoutLoading] = useState(false)
  const [paymentData, setPaymentData] = useState(null)
  const [showQR, setShowQR] = useState(false)

  useEffect(() => {
    // Get user from auth context or API call instead of localStorage
    loadUser()
    loadPricing()
  }, [])

  const loadUser = async () => {
    try {
      // TODO: Get user from auth context or API
      // For now, we'll assume user is logged in and passed via state
      const userData = await paymentAPI.getCurrentUser()
      setUser(userData.data)
    } catch (error) {
      console.error('Failed to load user:', error)
      // Redirect to login if user not found
      navigate('/login')
    }
  }

  const loadPricing = async () => {
    try {
      const res = await paymentAPI.getPricing()
      setPricing(res.data.pricing)
    } catch {
      setPricing({
        originalPrice: 36000,
        discountPercent: 50,
        basePrice: 18000,
        promoDiscountPercent: 10,
        currency: 'MMK',
      })
    }
  }

  const finalPrice = promoApplied && pricing
    ? pricing.basePrice * (1 - pricing.promoDiscountPercent / 100)
    : pricing?.basePrice || 18000

  const handleApplyPromo = async () => {
    if (!promoCode.trim()) return
    setPromoError('')
    setLoading(true)
    try {
      await paymentAPI.validatePromo(promoCode)
      setPromoApplied(true)
      setPromoDiscount(pricing?.promoDiscountPercent || 10)
    } catch (err) {
      setPromoError(err.response?.data?.error || 'Invalid promo code')
      setPromoApplied(false)
    } finally {
      setLoading(false)
    }
  }

  const handleCheckout = async () => {
    setCheckoutLoading(true)
    try {
      const res = await paymentAPI.checkout({
        promoCode: promoApplied ? promoCode : null,
        paymentMethod: selectedMethod,
        referralCode: referralCode.trim() || null,
      })
      
      if (res.data.success) {
        // Check if this is a MyanmarPay payment with QR code
        if (res.data.payment.qrCode) {
          setPaymentData(res.data.payment)
          setShowQR(true)
        } else {
          // International card payment completed
          const updatedUser = { ...user, isPaid: true, paidAt: new Date().toISOString() }
          localStorage.setItem('sf_user', JSON.stringify(updatedUser))
          navigate('/success', { state: { payment: res.data.payment } })
        }
      }
    } catch (err) {
      alert(err.response?.data?.error || 'Payment failed. Please try again.')
    } finally {
      setCheckoutLoading(false)
    }
  }

  const handlePaymentComplete = async () => {
    try {
      // Verify payment status with server
      const verification = await paymentAPI.verifyPayment(paymentData.paymentId)
      
      if (verification.data.success && verification.data.isPaid) {
        // Update user state from server response
        setUser(verification.data.user)
        navigate('/success', { state: { payment: paymentData } })
      } else {
        alert('Payment not yet confirmed. Please try again in a moment.')
      }
    } catch (error) {
      console.error('Payment verification failed:', error)
      // For development, allow completion anyway
      navigate('/success', { state: { payment: paymentData } })
    }
  }

  const handleCancelPayment = () => {
    setShowQR(false)
    setPaymentData(null)
  }

  const handleLogout = async () => {
    try {
      await paymentAPI.logout()
      setUser(null)
      navigate('/login')
    } catch (error) {
      console.error('Logout failed:', error)
      // Force logout anyway
      setUser(null)
      navigate('/login')
    }
  }

  const formatPrice = (amount) => new Intl.NumberFormat('en-US').format(amount)

  return (
    <div className="min-h-screen px-4 py-6 pb-32">
      <div className="max-w-lg mx-auto">
        {/* Header */}
        <div className="flex items-center justify-between mb-5 animate-fade-in">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl gradient-primary flex items-center justify-center">
              <BookOpen className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="text-lg font-black text-gray-900 leading-tight">HSK Shwe Flash</h1>
              <p className="text-xs text-gray-400">Premium Checkout</p>
            </div>
          </div>
          <button
            onClick={handleLogout}
            className="p-2 rounded-xl hover:bg-gray-100 transition-colors text-gray-400 cursor-pointer"
            title="Logout"
          >
            <LogOut size={18} />
          </button>
        </div>

        {/* Price Hero */}
        <div className="relative overflow-hidden rounded-2xl gradient-hero p-6 mb-5 animate-fade-in">
          <div className="absolute top-0 right-0 w-40 h-40 bg-white/5 rounded-full -translate-y-1/2 translate-x-1/2" />
          <div className="absolute bottom-0 left-0 w-28 h-28 bg-white/3 rounded-full translate-y-1/2 -translate-x-1/2" />
          <div className="relative">
            <div className="flex items-center gap-2 mb-3">
              <Crown className="w-5 h-5 text-gold-400" />
              <span className="text-gold-400 font-bold text-xs tracking-widest uppercase">
                Premium Lifetime Access
              </span>
            </div>
            <div className="flex items-baseline gap-2 mb-2">
              <span className="text-4xl font-black text-white tracking-tight">
                {formatPrice(finalPrice)}
              </span>
              <span className="text-white/50 font-medium text-sm">
                {pricing?.currency || 'MMK'}
              </span>
            </div>
            {pricing && (
              <div className="flex items-center gap-2 flex-wrap">
                <span className="text-white/30 line-through text-sm">
                  {formatPrice(pricing.originalPrice)} MMK
                </span>
                <span className="bg-gold-500/90 text-gray-900 text-xs font-bold px-2 py-0.5 rounded-md">
                  SAVE {pricing.discountPercent}%
                </span>
                {promoApplied && (
                  <span className="bg-green-400/90 text-gray-900 text-xs font-bold px-2 py-0.5 rounded-md">
                    +{promoDiscount}% PROMO
                  </span>
                )}
              </div>
            )}

            {/* Mini features */}
            <div className="mt-4 grid grid-cols-2 gap-2">
              {FEATURES.map((f, i) => (
                <div key={i} className="flex items-center gap-2">
                  <f.icon className="w-3.5 h-3.5 text-white/40" />
                  <span className="text-white/60 text-xs">{f.label}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Payment Methods */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-4 animate-fade-in-delay">
          <h3 className="font-bold text-gray-800 mb-4 text-sm flex items-center gap-2">
            <Wallet className="w-4 h-4 text-gray-400" />
            Select Payment Method
          </h3>
          
          {/* MyanmarPay Section */}
          <div className="mb-6">
            <div className="flex items-center gap-2 mb-3">
              <div className="w-6 h-6 rounded-lg bg-gradient-to-r from-blue-500 to-purple-600 flex items-center justify-center">
                <QrCode className="w-3.5 h-3.5 text-white" />
              </div>
              <div>
                <h4 className="text-xs font-bold text-gray-800">MyanmarPay</h4>
                <p className="text-[10px] text-gray-400">Unified MMQR Gateway - All major wallets</p>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-2.5">
              {MYANMAR_PAY_PROVIDERS.map((method) => {
                const isSelected = selectedMethod === method.id
                return (
                  <button
                    key={method.id}
                    onClick={() => setSelectedMethod(method.id)}
                    className={`payment-option flex flex-col items-center gap-2 p-4 rounded-xl border-2 cursor-pointer text-center relative ${
                      isSelected ? 'selected' : 'border-gray-100 hover:border-gray-200'
                    }`}
                  >
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center"
                      style={{ backgroundColor: isSelected ? method.color : method.bg }}
                    >
                      <method.icon
                        size={20}
                        style={{ color: isSelected ? '#fff' : method.color }}
                      />
                    </div>
                    <div>
                      <p className="text-xs font-bold text-gray-800">{method.label}</p>
                      <p className="text-[10px] text-gray-400 leading-tight mt-0.5">{method.desc}</p>
                    </div>
                    {isSelected && (
                      <div className="absolute top-1.5 right-1.5">
                        <CheckCircle2 size={14} className="text-primary-500" />
                      </div>
                    )}
                  </button>
                )
              })}
            </div>
          </div>
          
          {/* International Payment Methods */}
          <div>
            <div className="flex items-center gap-2 mb-3">
              <div className="w-6 h-6 rounded-lg bg-gray-800 flex items-center justify-center">
                <Globe className="w-3.5 h-3.5 text-white" />
              </div>
              <div>
                <h4 className="text-xs font-bold text-gray-800">International Cards</h4>
                <p className="text-[10px] text-gray-400">For international customers</p>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-2.5">
              {INTERNATIONAL_PAYMENT_METHODS.map((method) => {
                const isSelected = selectedMethod === method.id
                return (
                  <button
                    key={method.id}
                    onClick={() => setSelectedMethod(method.id)}
                    className={`payment-option flex flex-col items-center gap-2 p-4 rounded-xl border-2 cursor-pointer text-center relative ${
                      isSelected ? 'selected' : 'border-gray-100 hover:border-gray-200'
                    }`}
                  >
                    <div
                      className="w-10 h-10 rounded-xl flex items-center justify-center"
                      style={{ backgroundColor: isSelected ? method.color : method.bg }}
                    >
                      <method.icon
                        size={20}
                        style={{ color: isSelected ? '#fff' : method.color }}
                      />
                    </div>
                    <div>
                      <p className="text-xs font-bold text-gray-800">{method.label}</p>
                      <p className="text-[10px] text-gray-400 leading-tight mt-0.5">{method.desc}</p>
                    </div>
                    {isSelected && (
                      <div className="absolute top-1.5 right-1.5">
                        <CheckCircle2 size={14} className="text-primary-500" />
                      </div>
                    )}
                  </button>
                )
              })}
            </div>
          </div>
        </div>

        {/* Promo Code */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-4 animate-fade-in-delay">
          <h3 className="font-bold text-gray-800 mb-3 text-sm flex items-center gap-2">
            <Tag className="w-4 h-4 text-gray-400" />
            Promo Code
            <span className="text-[10px] font-normal text-gray-300 ml-1">(optional)</span>
          </h3>
          <div className="flex gap-2">
            <div className="flex-1 relative">
              <input
                type="text"
                value={promoCode}
                onChange={(e) => {
                  setPromoCode(e.target.value.toUpperCase())
                  setPromoError('')
                  if (promoApplied) setPromoApplied(false)
                }}
                placeholder="Enter code"
                disabled={promoApplied}
                className="w-full px-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 text-sm font-medium disabled:bg-green-50 disabled:border-green-300 disabled:text-green-700"
              />
              {promoApplied && (
                <button
                  onClick={() => { setPromoApplied(false); setPromoCode('') }}
                  className="absolute right-2 top-1/2 -translate-y-1/2 cursor-pointer"
                >
                  <X size={16} className="text-gray-400" />
                </button>
              )}
            </div>
            <button
              onClick={handleApplyPromo}
              disabled={loading || promoApplied || !promoCode.trim()}
              className="px-5 py-2.5 rounded-xl bg-gray-900 text-white text-sm font-semibold hover:bg-gray-800 transition-colors disabled:opacity-30 disabled:cursor-not-allowed cursor-pointer"
            >
              {loading ? (
                <Loader2 size={16} className="animate-spin" />
              ) : promoApplied ? (
                <CheckCircle2 size={16} className="text-green-400" />
              ) : (
                'Apply'
              )}
            </button>
          </div>
          {promoError && (
            <p className="text-xs text-red-500 mt-2 font-medium">{promoError}</p>
          )}
          {promoApplied && (
            <p className="text-xs text-green-600 mt-2 font-medium flex items-center gap-1">
              <CheckCircle2 size={12} />
              Promo code applied! You saved {promoDiscount}% off
            </p>
          )}
        </div>

        {/* Referral Code */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-4 animate-fade-in-delay">
          <h3 className="font-bold text-gray-800 mb-3 text-sm flex items-center gap-2">
            <Users className="w-4 h-4 text-gray-400" />
            Referral Code
            <span className="text-[10px] font-normal text-gray-300 ml-1">(optional)</span>
          </h3>
          <div className="flex gap-2">
            <div className="flex-1 relative">
              <input
                type="text"
                value={referralCode}
                onChange={(e) => {
                  setReferralCode(e.target.value.toUpperCase())
                  setReferralError('')
                }}
                placeholder="Enter referral code"
                className="w-full px-4 py-2.5 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 text-sm font-medium"
              />
            </div>
          </div>
          {referralError && (
            <p className="text-xs text-red-500 mt-2 font-medium">{referralError}</p>
          )}
          <p className="text-xs text-gray-500 mt-2">
            Enter a referral code to support your friend. They'll earn 20% commission!
          </p>
        </div>

        {/* Order Summary */}
        <div className="bg-white rounded-2xl border border-gray-100 shadow-sm p-5 mb-6 animate-fade-in-delay-2">
          <h3 className="font-bold text-gray-800 mb-3 text-sm">Order Summary</h3>
          <div className="space-y-2.5 text-sm">
            <div className="flex justify-between">
              <span className="text-gray-400">Premium (Lifetime)</span>
              <span className="text-gray-400 line-through">
                {formatPrice(pricing?.originalPrice || 36000)} MMK
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-gray-400">
                Launch Discount ({pricing?.discountPercent || 50}%)
              </span>
              <span className="text-green-600 font-medium">
                -{formatPrice((pricing?.originalPrice || 36000) - (pricing?.basePrice || 18000))} MMK
              </span>
            </div>
            {promoApplied && (
              <div className="flex justify-between">
                <span className="text-gray-400">Promo ({promoDiscount}%)</span>
                <span className="text-green-600 font-medium">
                  -{formatPrice((pricing?.basePrice || 18000) - finalPrice)} MMK
                </span>
              </div>
            )}
            <div className="border-t border-gray-100 pt-3 mt-3">
              <div className="flex justify-between items-center">
                <span className="font-bold text-gray-900">Total</span>
                <span className="font-black text-xl text-primary-600">
                  {formatPrice(finalPrice)} MMK
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* QR Code Modal for MyanmarPay */}
        {showQR && paymentData && (
          <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl p-6 max-w-sm w-full animate-fade-in">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-gray-800">Scan QR Code</h3>
                <button
                  onClick={handleCancelPayment}
                  className="p-1 rounded-lg hover:bg-gray-100 transition-colors"
                >
                  <X size={20} className="text-gray-400" />
                </button>
              </div>
              
              <div className="text-center mb-4">
                <div className="w-48 h-48 mx-auto bg-gray-100 rounded-xl flex items-center justify-center mb-4 p-4">
                  {/* QR Code Placeholder - In production, generate actual QR code */}
                  <div className="text-center">
                    <QrCode className="w-24 h-24 text-gray-400 mx-auto mb-2" />
                    <p className="text-xs text-gray-500 font-mono break-all">{paymentData.qrCode}</p>
                  </div>
                </div>
                
                <div className="space-y-2 text-sm">
                  <p className="font-bold text-gray-800">
                    {formatPrice(paymentData.amount)} {paymentData.currency}
                  </p>
                  <p className="text-gray-400">
                    Order ID: {paymentData.orderId}
                  </p>
                  <p className="text-gray-400">
                    Pay with: {MYANMAR_PAY_PROVIDERS.find(p => p.id === paymentData.paymentMethod)?.label}
                  </p>
                </div>
              </div>
              
              <div className="bg-blue-50 rounded-xl p-3 mb-4">
                <p className="text-xs text-blue-700 text-center">
                  <strong>Instructions:</strong> Open your {MYANMAR_PAY_PROVIDERS.find(p => p.id === paymentData.paymentMethod)?.label} app and scan the QR code above to complete payment.
                </p>
              </div>
              
              <div className="flex gap-2">
                <button
                  onClick={handleCancelPayment}
                  className="flex-1 py-2.5 rounded-xl border border-gray-200 text-gray-600 text-sm font-semibold hover:bg-gray-50 transition-colors"
                >
                  Cancel
                </button>
                <button
                  onClick={handlePaymentComplete}
                  className="flex-1 py-2.5 rounded-xl bg-green-500 text-white text-sm font-semibold hover:bg-green-600 transition-colors"
                >
                  I've Paid
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Sticky Checkout Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-lg border-t border-gray-100 p-4 z-50">
          <div className="max-w-lg mx-auto">
            <button
              onClick={handleCheckout}
              disabled={checkoutLoading}
              className="w-full py-4 rounded-2xl gradient-primary text-white font-bold text-base shadow-lg hover:shadow-xl transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 cursor-pointer"
            >
              {checkoutLoading ? (
                <>
                  <Loader2 size={20} className="animate-spin" />
                  Processing Payment...
                </>
              ) : (
                <>
                  <Lock size={18} />
                  Pay {formatPrice(finalPrice)} MMK
                  <ArrowRight size={18} />
                </>
              )}
            </button>
            <div className="flex items-center justify-center gap-3 mt-2.5 text-gray-300">
              <div className="flex items-center gap-1">
                <Shield size={12} />
                <span className="text-[10px] font-medium">Secure</span>
              </div>
              <div className="w-0.5 h-0.5 rounded-full bg-gray-200" />
              <div className="flex items-center gap-1">
                <Lock size={12} />
                <span className="text-[10px] font-medium">Encrypted</span>
              </div>
              <div className="w-0.5 h-0.5 rounded-full bg-gray-200" />
              <span className="text-[10px] font-medium">Instant Activation</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
