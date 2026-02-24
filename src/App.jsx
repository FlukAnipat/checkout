import { HashRouter, Routes, Route, Navigate } from 'react-router-dom'
import LoginPage from './pages/LoginPage'
import PaymentPage from './pages/PaymentPage'
import SuccessPage from './pages/SuccessPage'
import AdminDashboard from './pages/AdminDashboard'
import SalesDashboard from './pages/SalesDashboard'

function PrivateRoute({ children }) {
  const token = localStorage.getItem('sf_token')
  return token ? children : <Navigate to="#/login" replace />
}

function RoleRoute({ children, allowedRoles }) {
  const token = localStorage.getItem('sf_token')
  if (!token) return <Navigate to="#/login" replace />
  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  if (!allowedRoles.includes(user.role)) return <Navigate to="#/login" replace />
  return children
}

export default function App() {
  return (
    <HashRouter>
      <Routes>
        <Route path="/login" element={<LoginPage />} />
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
        <Route path="*" element={<Navigate to="#/login" replace />} />
      </Routes>
    </HashRouter>
  )
}
