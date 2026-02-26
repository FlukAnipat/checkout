import { HashRouter, Routes, Route, Navigate } from 'react-router-dom'
import { lazy, Suspense } from 'react'

// Auth pages
import LoginPage from './pages/auth/LoginPage'
const UserRegisterPage = lazy(() => import('./pages/auth/UserRegisterPage'))
const SaleRegisterPage = lazy(() => import('./pages/auth/SaleRegisterPage'))
const ForgotPasswordPage = lazy(() => import('./pages/auth/ForgotPasswordPage'))

// User pages
const UserDashboard = lazy(() => import('./pages/user/UserDashboard'))
const HskLevelPage = lazy(() => import('./pages/user/HskLevelPage'))
const FlashcardPage = lazy(() => import('./pages/user/FlashcardPage'))
const SavedWordsPage = lazy(() => import('./pages/user/SavedWordsPage'))
const ProfilePage = lazy(() => import('./pages/user/ProfilePage'))

// Sales & Admin
const SalesDashboard = lazy(() => import('./pages/SalesDashboard'))
const AdminDashboard = lazy(() => import('./pages/AdminDashboard'))

// Payment & Others
const PaymentPage = lazy(() => import('./pages/PaymentPage'))
const SuccessPage = lazy(() => import('./pages/SuccessPage'))
const ConfirmEmailPage = lazy(() => import('./pages/ConfirmEmailPage'))

function Loading() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="w-8 h-8 border-3 border-primary-500 border-t-transparent rounded-full animate-spin" />
    </div>
  )
}

function PrivateRoute({ children }) {
  const token = localStorage.getItem('sf_token')
  return token ? children : <Navigate to="/login" replace />
}

function RoleRoute({ children, allowedRoles }) {
  const token = localStorage.getItem('sf_token')
  if (!token) return <Navigate to="/login" replace />
  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  if (!allowedRoles.includes(user.role)) {
    if (user.role === 'user') return <Navigate to="/dashboard" replace />
    return <Navigate to="/login" replace />
  }
  return children
}

function UserRoute({ children }) {
  const token = localStorage.getItem('sf_token')
  if (!token) return <Navigate to="/login" replace />
  const user = JSON.parse(localStorage.getItem('sf_user') || '{}')
  if (user.role === 'sales') return <Navigate to="/sales" replace />
  if (user.role === 'admin') return <Navigate to="/admin" replace />
  return children
}

export default function App() {
  return (
    <HashRouter>
      <Suspense fallback={<Loading />}>
        <Routes>
          {/* Auth Routes */}
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<UserRegisterPage />} />
          <Route path="/register/sale/:token" element={<SaleRegisterPage />} />
          <Route path="/register/:token" element={<SaleRegisterPage />} />
          <Route path="/forgot-password" element={<ForgotPasswordPage />} />
          <Route path="/confirm-email" element={<ConfirmEmailPage />} />

          {/* User Routes */}
          <Route path="/dashboard" element={<UserRoute><UserDashboard /></UserRoute>} />
          <Route path="/hsk/:level" element={<UserRoute><HskLevelPage /></UserRoute>} />
          <Route path="/flashcard/:level" element={<UserRoute><FlashcardPage /></UserRoute>} />
          <Route path="/saved" element={<UserRoute><SavedWordsPage /></UserRoute>} />
          <Route path="/profile" element={<PrivateRoute><ProfilePage /></PrivateRoute>} />

          {/* Payment */}
          <Route path="/payment" element={<PrivateRoute><PaymentPage /></PrivateRoute>} />
          <Route path="/success" element={<PrivateRoute><SuccessPage /></PrivateRoute>} />

          {/* Sales & Admin */}
          <Route path="/sales" element={<RoleRoute allowedRoles={['sales', 'admin']}><SalesDashboard /></RoleRoute>} />
          <Route path="/admin" element={<RoleRoute allowedRoles={['admin']}><AdminDashboard /></RoleRoute>} />

          {/* Default */}
          <Route path="*" element={<Navigate to="/login" replace />} />
        </Routes>
      </Suspense>
    </HashRouter>
  )
}
