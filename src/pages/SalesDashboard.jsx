import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { salesAPI } from '../services/api'
import { 
  BarChart3, Users, DollarSign, Tag, LogOut, TrendingUp, 
  Ticket, ChevronRight, RefreshCw, BookOpen
} from 'lucide-react'

function formatPrice(amount) {
  return Number(amount).toLocaleString()
}

export default function SalesDashboard() {
  const navigate = useNavigate()
  const [stats, setStats] = useState(null)
  const [promoCodes, setPromoCodes] = useState([])
  const [customers, setCustomers] = useState([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('overview')

  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')

  useEffect(() => {
    loadData()
  }, [])

  const loadData = async () => {
    setLoading(true)
    try {
      const [dashRes, promoRes, custRes] = await Promise.all([
        salesAPI.getDashboard(),
        salesAPI.getPromoCodes(),
        salesAPI.getCustomers()
      ])
      setStats(dashRes.data.stats)
      setPromoCodes(promoRes.data.promoCodes)
      setCustomers(custRes.data.customers)
    } catch (err) {
      console.error('Failed to load sales data:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/login')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-3 border-primary-200 border-t-primary-600 rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-100 sticky top-0 z-10">
        <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl gradient-primary flex items-center justify-center">
              <BookOpen className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="font-bold text-gray-900 text-sm">Sales Dashboard</h1>
              <p className="text-xs text-gray-400">{user.firstName} {user.lastName}</p>
            </div>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={loadData} className="p-2 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer">
              <RefreshCw size={16} className="text-gray-400" />
            </button>
            <button onClick={handleLogout} className="p-2 rounded-lg hover:bg-red-50 transition-colors cursor-pointer">
              <LogOut size={16} className="text-red-400" />
            </button>
          </div>
        </div>
      </header>

      <div className="max-w-5xl mx-auto px-4 py-6 space-y-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-8 h-8 rounded-lg bg-blue-50 flex items-center justify-center">
                <Users size={16} className="text-blue-500" />
              </div>
            </div>
            <p className="text-2xl font-black text-gray-900">{stats?.totalSales || 0}</p>
            <p className="text-xs text-gray-400 mt-1">Total Sales</p>
          </div>

          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-8 h-8 rounded-lg bg-green-50 flex items-center justify-center">
                <DollarSign size={16} className="text-green-500" />
              </div>
            </div>
            <p className="text-2xl font-black text-gray-900">{formatPrice(stats?.totalRevenue || 0)}</p>
            <p className="text-xs text-gray-400 mt-1">Revenue (MMK)</p>
          </div>

          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-8 h-8 rounded-lg bg-yellow-50 flex items-center justify-center">
                <TrendingUp size={16} className="text-yellow-500" />
              </div>
            </div>
            <p className="text-2xl font-black text-green-600">{formatPrice(stats?.totalCommission || 0)}</p>
            <p className="text-xs text-gray-400 mt-1">Commission ({stats?.commissionRate || 20}%)</p>
          </div>

          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <div className="flex items-center gap-2 mb-2">
              <div className="w-8 h-8 rounded-lg bg-purple-50 flex items-center justify-center">
                <Tag size={16} className="text-purple-500" />
              </div>
            </div>
            <p className="text-2xl font-black text-gray-900">{stats?.promoCodes || 0}</p>
            <p className="text-xs text-gray-400 mt-1">Promo Codes</p>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 bg-white rounded-xl p-1 border border-gray-100">
          {['overview', 'customers'].map(tab => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`flex-1 py-2 px-4 rounded-lg text-sm font-semibold transition-all cursor-pointer ${
                activeTab === tab 
                  ? 'gradient-primary text-white shadow-sm' 
                  : 'text-gray-400 hover:text-gray-600'
              }`}
            >
              {tab === 'overview' ? 'Promo Codes' : 'Customers'}
            </button>
          ))}
        </div>

        {/* Promo Codes Tab */}
        {activeTab === 'overview' && (
          <div className="space-y-3">
            {promoCodes.length === 0 ? (
              <div className="bg-white rounded-xl p-8 border border-gray-100 text-center">
                <Ticket size={32} className="text-gray-300 mx-auto mb-2" />
                <p className="text-gray-400 text-sm">No promo codes assigned yet</p>
              </div>
            ) : (
              promoCodes.map(pc => (
                <div key={pc.code} className="bg-white rounded-xl p-4 border border-gray-100">
                  <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-2">
                      <span className="px-3 py-1 rounded-lg bg-primary-50 text-primary-600 font-bold text-sm">
                        {pc.code}
                      </span>
                      <span className="text-sm text-green-600 font-semibold">{Number(pc.discount_percent)}% OFF</span>
                    </div>
                    <span className="text-xs text-gray-400">
                      {pc.times_used}/{pc.max_uses} used
                    </span>
                  </div>
                  <div className="grid grid-cols-3 gap-3 text-center">
                    <div>
                      <p className="text-lg font-bold text-gray-900">{pc.times_used}</p>
                      <p className="text-xs text-gray-400">Used</p>
                    </div>
                    <div>
                      <p className="text-lg font-bold text-gray-900">{formatPrice(pc.total_discount_given || 0)}</p>
                      <p className="text-xs text-gray-400">Discount Given</p>
                    </div>
                    <div>
                      <p className="text-lg font-bold text-gray-900">
                        {pc.expires_at ? new Date(pc.expires_at).toLocaleDateString() : 'Never'}
                      </p>
                      <p className="text-xs text-gray-400">Expires</p>
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        )}

        {/* Customers Tab */}
        {activeTab === 'customers' && (
          <div className="space-y-3">
            {customers.length === 0 ? (
              <div className="bg-white rounded-xl p-8 border border-gray-100 text-center">
                <Users size={32} className="text-gray-300 mx-auto mb-2" />
                <p className="text-gray-400 text-sm">No customers yet</p>
              </div>
            ) : (
              customers.map(c => (
                <div key={c.payment_id} className="bg-white rounded-xl p-4 border border-gray-100">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-semibold text-gray-900 text-sm">{c.customer_name}</p>
                      <p className="text-xs text-gray-400">{c.customer_email}</p>
                    </div>
                    <div className="text-right">
                      <p className="font-bold text-gray-900 text-sm">{formatPrice(c.amount)} {c.currency}</p>
                      <p className="text-xs text-green-600 font-medium">
                        Commission: {formatPrice(Number(c.amount) * 0.2)} MMK
                      </p>
                    </div>
                  </div>
                  <div className="flex items-center justify-between mt-2 pt-2 border-t border-gray-50">
                    <span className="text-xs px-2 py-0.5 rounded-full bg-blue-50 text-blue-600 font-medium">
                      {c.promo_code}
                    </span>
                    <span className="text-xs text-gray-400">
                      {new Date(c.created_at).toLocaleDateString()}
                    </span>
                  </div>
                </div>
              ))
            )}
          </div>
        )}
      </div>
    </div>
  )
}
