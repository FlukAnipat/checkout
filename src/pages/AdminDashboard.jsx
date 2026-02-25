import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { adminAPI } from '../services/api'
import TokenManagement from './TokenManagement'
import { 
  BarChart3, Users, DollarSign, Tag, LogOut, Plus, 
  CreditCard, Shield, RefreshCw, BookOpen, X, ChevronDown, UserCheck, Link
} from 'lucide-react'
import Pagination from '../components/Pagination.jsx'

function formatPrice(amount) {
  return Number(amount).toLocaleString()
}

export default function AdminDashboard() {
  const navigate = useNavigate()
  const [stats, setStats] = useState(null)
  const [users, setUsers] = useState([])
  const [payments, setPayments] = useState([])
  const [promoCodes, setPromoCodes] = useState([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('overview')
  const [showCreatePromo, setShowCreatePromo] = useState(false)
  const [newPromo, setNewPromo] = useState({ code: '', discountPercent: 10, maxUses: 100, salesPersonId: '', expiresAt: '' })
  const [createError, setCreateError] = useState('')

  // Pagination states
  const [usersPage, setUsersPage] = useState(1)
  const [paymentsPage, setPaymentsPage] = useState(1)
  const [promoCodesPage, setPromoCodesPage] = useState(1)
  const itemsPerPage = 10

  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')

  useEffect(() => {
    loadData()
  }, [])

  const loadData = async () => {
    setLoading(true)
    try {
      const [dashRes, usersRes, payRes, promoRes] = await Promise.all([
        adminAPI.getDashboard(),
        adminAPI.getUsers(),
        adminAPI.getPayments(),
        adminAPI.getPromoCodes()
      ])
      setStats(dashRes.data.stats)
      setUsers(usersRes.data.users)
      setPayments(payRes.data.payments)
      setPromoCodes(promoRes.data.promoCodes)
    } catch (err) {
      console.error('Failed to load admin data:', err)
    } finally {
      setLoading(false)
    }
  }

  const handleCreatePromo = async (e) => {
    e.preventDefault()
    setCreateError('')
    try {
      await adminAPI.createPromoCode({
        code: newPromo.code,
        discountPercent: Number(newPromo.discountPercent),
        maxUses: Number(newPromo.maxUses),
        salesPersonId: newPromo.salesPersonId || null,
        expiresAt: newPromo.expiresAt || null
      })
      setShowCreatePromo(false)
      setNewPromo({ code: '', discountPercent: 10, maxUses: 100, salesPersonId: '', expiresAt: '' })
      loadData()
    } catch (err) {
      setCreateError(err.response?.data?.error || 'Failed to create promo code')
    }
  }

  const handleLogout = () => {
    localStorage.removeItem('sf_token')
    localStorage.removeItem('sf_user')
    navigate('/login')
  }

  const salesUsers = users.filter(u => u.role === 'sales')

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
        <div className="max-w-6xl mx-auto px-4 py-3 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-xl bg-gray-900 flex items-center justify-center">
              <Shield className="w-5 h-5 text-white" />
            </div>
            <div>
              <h1 className="font-bold text-gray-900 text-sm">Admin Dashboard</h1>
              <p className="text-xs text-gray-400">{user.email}</p>
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

      <div className="max-w-6xl mx-auto px-4 py-6 space-y-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-2 lg:grid-cols-5 gap-3">
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <Users size={16} className="text-blue-500 mb-2" />
            <p className="text-2xl font-black text-gray-900">{Number(stats?.total_users || 0)}</p>
            <p className="text-xs text-gray-400">Total Users</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <UserCheck size={16} className="text-green-500 mb-2" />
            <p className="text-2xl font-black text-green-600">{Number(stats?.total_paid_users || 0)}</p>
            <p className="text-xs text-gray-400">Paid Users</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <BarChart3 size={16} className="text-purple-500 mb-2" />
            <p className="text-2xl font-black text-gray-900">{Number(stats?.total_sales_persons || 0)}</p>
            <p className="text-xs text-gray-400">Sales Persons</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <DollarSign size={16} className="text-yellow-500 mb-2" />
            <p className="text-2xl font-black text-gray-900">{formatPrice(stats?.total_revenue || 0)}</p>
            <p className="text-xs text-gray-400">Revenue (MMK)</p>
          </div>
          <div className="bg-white rounded-xl p-4 border border-gray-100">
            <Tag size={16} className="text-indigo-500 mb-2" />
            <p className="text-2xl font-black text-gray-900">{Number(stats?.total_promo_codes || 0)}</p>
            <p className="text-xs text-gray-400">Promo Codes</p>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 bg-white rounded-xl p-1 border border-gray-100">
          {['overview', 'users', 'payments', 'promo', 'tokens'].map(tab => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`flex-1 py-2 px-3 rounded-lg text-xs font-semibold transition-all cursor-pointer ${
                activeTab === tab 
                  ? 'bg-gray-900 text-white shadow-sm' 
                  : 'text-gray-400 hover:text-gray-600'
              }`}
            >
              {tab === 'overview' ? 'Overview' : tab === 'users' ? 'Users' : tab === 'payments' ? 'Payments' : tab === 'promo' ? 'Promo Codes' : 'Tokens'}
            </button>
          ))}
        </div>

        {/* Overview Tab */}
        {activeTab === 'overview' && (
          <div className="space-y-4">
            <div className="bg-white rounded-xl border border-gray-100 p-4">
              <h3 className="font-bold text-gray-900 text-sm mb-3">Recent Payments</h3>
              {payments.slice(0, 5).map(p => (
                <div key={p.payment_id} className="flex items-center justify-between py-2 border-b border-gray-50 last:border-0">
                  <div>
                    <p className="text-sm font-medium text-gray-900">{p.customer_name}</p>
                    <p className="text-xs text-gray-400">{p.customer_email}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-bold text-gray-900">{formatPrice(p.amount)} {p.currency}</p>
                    <p className="text-xs text-gray-400">{p.promo_code || 'No promo'}</p>
                  </div>
                </div>
              ))}
            </div>
            <div className="bg-white rounded-xl border border-gray-100 p-4">
              <h3 className="font-bold text-gray-900 text-sm mb-3">Sales Persons</h3>
              {salesUsers.length === 0 ? (
                <p className="text-xs text-gray-400">No sales persons registered</p>
              ) : (
                salesUsers.map(s => (
                  <div key={s.user_id} className="flex items-center justify-between py-2 border-b border-gray-50 last:border-0">
                    <div>
                      <p className="text-sm font-medium text-gray-900">{s.first_name} {s.last_name}</p>
                      <p className="text-xs text-gray-400">{s.email}</p>
                    </div>
                    <span className="text-xs px-2 py-0.5 rounded-full bg-blue-50 text-blue-600 font-medium">Sales</span>
                  </div>
                ))
              )}
            </div>
          </div>
        )}

        {/* Users Tab */}
        {activeTab === 'users' && (
          <div className="bg-white rounded-xl border border-gray-100 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-gray-50 text-left">
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Name</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Email</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Role</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Status</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Joined</th>
                  </tr>
                </thead>
                <tbody>
                  {users.slice((usersPage - 1) * itemsPerPage, usersPage * itemsPerPage).map(u => (
                    <tr key={u.user_id} className="border-t border-gray-50 hover:bg-gray-50/50">
                      <td className="px-4 py-3 font-medium text-gray-900">{u.first_name} {u.last_name}</td>
                      <td className="px-4 py-3 text-gray-500">{u.email}</td>
                      <td className="px-4 py-3">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                          u.role === 'admin' ? 'bg-gray-900 text-white' :
                          u.role === 'sales' ? 'bg-blue-50 text-blue-600' :
                          'bg-gray-100 text-gray-500'
                        }`}>
                          {u.role || 'user'}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                          u.is_paid ? 'bg-green-50 text-green-600' : 'bg-gray-100 text-gray-400'
                        }`}>
                          {u.is_paid ? 'Premium' : 'Free'}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-gray-400 text-xs">
                        {new Date(u.created_at).toLocaleDateString()}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <Pagination
              currentPage={usersPage}
              totalPages={Math.ceil(users.length / itemsPerPage)}
              onPageChange={setUsersPage}
              itemsPerPage={itemsPerPage}
              totalItems={users.length}
            />
          </div>
        )}

        {/* Payments Tab */}
        {activeTab === 'payments' && (
          <div className="bg-white rounded-xl border border-gray-100 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="bg-gray-50 text-left">
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Customer</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Amount</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Promo</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Method</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Status</th>
                    <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Date</th>
                  </tr>
                </thead>
                <tbody>
                  {payments.slice((paymentsPage - 1) * itemsPerPage, paymentsPage * itemsPerPage).map(p => (
                    <tr key={p.payment_id} className="border-t border-gray-50 hover:bg-gray-50/50">
                      <td className="px-4 py-3">
                        <p className="font-medium text-gray-900">{p.customer_name}</p>
                        <p className="text-xs text-gray-400">{p.customer_email}</p>
                      </td>
                      <td className="px-4 py-3 font-bold text-gray-900">{formatPrice(p.amount)} {p.currency}</td>
                      <td className="px-4 py-3">
                        {p.promo_code ? (
                          <span className="text-xs px-2 py-0.5 rounded-full bg-primary-50 text-primary-600 font-medium">{p.promo_code}</span>
                        ) : (
                          <span className="text-xs text-gray-400">-</span>
                        )}
                      </td>
                      <td className="px-4 py-3 text-gray-500 text-xs uppercase">{p.payment_method}</td>
                      <td className="px-4 py-3">
                        <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${
                          p.status === 'completed' ? 'bg-green-50 text-green-600' :
                          p.status === 'pending' ? 'bg-yellow-50 text-yellow-600' :
                          'bg-red-50 text-red-600'
                        }`}>
                          {p.status}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-gray-400 text-xs">{new Date(p.created_at).toLocaleDateString()}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <Pagination
              currentPage={paymentsPage}
              totalPages={Math.ceil(payments.length / itemsPerPage)}
              onPageChange={setPaymentsPage}
              itemsPerPage={itemsPerPage}
              totalItems={payments.length}
            />
          </div>
        )}

        {/* Promo Codes Tab */}
        {activeTab === 'promo' && (
          <div className="space-y-4">
            <div className="flex justify-end">
              <button
                onClick={() => setShowCreatePromo(true)}
                className="flex items-center gap-2 px-4 py-2 rounded-xl bg-gray-900 text-white text-sm font-semibold hover:bg-gray-800 transition-colors cursor-pointer"
              >
                <Plus size={16} /> New Promo Code
              </button>
            </div>
            <div className="bg-white rounded-xl border border-gray-100 overflow-hidden">
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="bg-gray-50 text-left">
                      <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Code</th>
                      <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Discount</th>
                      <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Sales Person</th>
                      <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Usage</th>
                      <th className="px-4 py-3 font-semibold text-gray-600 text-xs">Expires</th>
                    </tr>
                  </thead>
                  <tbody>
                    {promoCodes.slice((promoCodesPage - 1) * itemsPerPage, promoCodesPage * itemsPerPage).map(pc => (
                      <tr key={pc.code} className="border-t border-gray-50 hover:bg-gray-50/50">
                        <td className="px-4 py-3">
                          <span className="px-2 py-0.5 rounded-lg bg-primary-50 text-primary-600 font-bold text-xs">{pc.code}</span>
                        </td>
                        <td className="px-4 py-3 font-bold text-green-600">{Number(pc.discount_percent)}%</td>
                        <td className="px-4 py-3 text-gray-500">{pc.sales_person_name || '-'}</td>
                        <td className="px-4 py-3 text-gray-500">{pc.used_count}/{pc.max_uses}</td>
                        <td className="px-4 py-3 text-gray-400 text-xs">
                          {pc.expires_at ? new Date(pc.expires_at).toLocaleDateString() : 'Never'}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            <Pagination
              currentPage={promoCodesPage}
              totalPages={Math.ceil(promoCodes.length / itemsPerPage)}
              onPageChange={setPromoCodesPage}
              itemsPerPage={itemsPerPage}
              totalItems={promoCodes.length}
            />
            </div>
          </div>
        )}
      </div>

      {/* Create Promo Code Modal */}
      {showCreatePromo && (
        <div className="fixed inset-0 bg-black/50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl p-6 max-w-md w-full animate-fade-in">
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-bold text-gray-900">Create Promo Code</h3>
              <button onClick={() => setShowCreatePromo(false)} className="p-1 rounded-lg hover:bg-gray-100 cursor-pointer">
                <X size={20} className="text-gray-400" />
              </button>
            </div>
            {createError && (
              <div className="mb-3 p-2 rounded-lg bg-red-50 text-red-600 text-xs font-medium">{createError}</div>
            )}
            <form onSubmit={handleCreatePromo} className="space-y-3">
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1">Code</label>
                <input
                  type="text"
                  value={newPromo.code}
                  onChange={e => setNewPromo({ ...newPromo, code: e.target.value.toUpperCase() })}
                  placeholder="e.g. TOM20"
                  required
                  className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="block text-xs font-semibold text-gray-600 mb-1">Discount %</label>
                  <input
                    type="number"
                    value={newPromo.discountPercent}
                    onChange={e => setNewPromo({ ...newPromo, discountPercent: e.target.value })}
                    min="1" max="100" required
                    className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary-500"
                  />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-600 mb-1">Max Uses</label>
                  <input
                    type="number"
                    value={newPromo.maxUses}
                    onChange={e => setNewPromo({ ...newPromo, maxUses: e.target.value })}
                    min="1" required
                    className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary-500"
                  />
                </div>
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1">Sales Person (optional)</label>
                <select
                  value={newPromo.salesPersonId}
                  onChange={e => setNewPromo({ ...newPromo, salesPersonId: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary-500"
                >
                  <option value="">No salesperson</option>
                  {salesUsers.map(s => (
                    <option key={s.user_id} value={s.user_id}>{s.first_name} {s.last_name} ({s.email})</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-600 mb-1">Expires At (optional)</label>
                <input
                  type="datetime-local"
                  value={newPromo.expiresAt}
                  onChange={e => setNewPromo({ ...newPromo, expiresAt: e.target.value })}
                  className="w-full px-3 py-2 rounded-lg border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-primary-500"
                />
              </div>
              <button
                type="submit"
                className="w-full py-2.5 rounded-xl bg-gray-900 text-white font-bold text-sm hover:bg-gray-800 transition-colors cursor-pointer"
              >
                Create Promo Code
              </button>
            </form>
          </div>
        </div>
      )}

        {/* Tokens Tab */}
        {activeTab === 'tokens' && (
          <TokenManagement />
        )}
    </div>
  )
}
