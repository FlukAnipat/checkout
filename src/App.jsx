import { HashRouter, Routes, Route, Navigate } from 'react-router-dom'
import LoginPage from './pages/LoginPage'
import RegisterPage from './pages/RegisterPage'
import PaymentPage from './pages/PaymentPage'
import SuccessPage from './pages/SuccessPage'
import AdminDashboard from './pages/AdminDashboard'
import SalesDashboard from './pages/SalesDashboard'
import ConfirmEmailPage from './pages/ConfirmEmailPage'

function PrivateRoute({ children }) {
  const token = localStorage.getItem('sf_token')
  return token ? children : <Navigate to="/login" replace />
}

function RoleRoute({ children, allowedRoles }) {
  const token = localStorage.getItem('sf_token')
  if (!token) return <Navigate to="/login" replace />
  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  if (!allowedRoles.includes(user.role)) return <Navigate to="/login" replace />
  return children
}

export default function App() {
  return (
    <HashRouter>
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/register" element={
          <div className="min-h-screen flex items-center justify-center px-4 py-8">
            <div className="w-full max-w-md text-center">
              <h1 className="text-2xl font-bold text-gray-900 mb-4">Access Restricted</h1>
              <p className="text-gray-600 mb-6">
                Sales registration is by invitation only. Please contact your administrator for access.
              </p>
              <a href="#/login" className="inline-flex items-center justify-center px-6 py-3 bg-primary-500 text-white rounded-xl hover:bg-primary-600 transition-colors">
                Back to Login
              </a>
            </div>
          </div>
        } />
        <Route
          path="/payment"
          element={
            <PrivateRoute>
              <PaymentPage />
            </PrivateRoute>
          }
        />
        <Route
          path="/success"
          element={
            <PrivateRoute>
              <SuccessPage />
            </PrivateRoute>
          }
        />
        <Route
          path="/admin"
          element={
            <RoleRoute allowedRoles={['admin']}>
              <AdminDashboard />
            </RoleRoute>
          }
        />
        <Route
          path="/sales"
          element={
            <RoleRoute allowedRoles={['sales', 'admin']}>
              <SalesDashboard />
            </RoleRoute>
          }
        />
        <Route path="/register/:token" element={<RegisterPage />} />
        <Route path="/confirm-email" element={<ConfirmEmailPage />} />
        <Route path="*" element={<Navigate to="/login" replace />} />
      </Routes>
    </HashRouter>
  )
}
