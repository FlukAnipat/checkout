import axios from 'axios';
import { API_BASE } from '../config/api-config.js';

const api = axios.create({
  baseURL: API_BASE,
  headers: { 'Content-Type': 'application/json' },
});

// Attach JWT token to every request
api.interceptors.request.use((config) => {
  // TODO: Get token from auth context instead of localStorage
  const token = localStorage.getItem('sf_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 responses (token expired)
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // TODO: Clear auth context instead of localStorage
      localStorage.removeItem('sf_token');
      localStorage.removeItem('sf_user');
      window.location.hash = '#/login';
    }
    return Promise.reject(error);
  }
);

// ── Auth API ──
export const authAPI = {
  login: (email, password) =>
    api.post('/auth/login', { email, password }),

  register: (data) =>
    api.post('/auth/register', data),

  getMe: () =>
    api.get('/auth/me'),

  updateProfile: (data) =>
    api.put('/auth/me', data),

  changePassword: (oldPassword, newPassword) =>
    api.put('/auth/me', { password: oldPassword, newPassword }),
};

// ── Payment API ──
export const paymentAPI = {
  getPricing: () =>
    api.get('/payment/pricing'),

  validatePromo: (promoCode) =>
    api.post('/payment/validate-promo', { promoCode }),

  checkout: (data) =>
    api.post('/payment/checkout', data),

  verifyPayment: (paymentId) =>
    api.get(`/payment/verify/${paymentId}`),

  getCurrentUser: () =>
    api.get('/auth/me'),

  logout: () =>
    api.post('/auth/logout'),

  getStatus: () =>
    api.get('/payment/status'),

  getHistory: () =>
    api.get('/payment/history'),
};

// ── Admin API ──
export const adminAPI = {
  getDashboard: () => api.get('/admin/dashboard'),
  getUsers: () => api.get('/admin/users'),
  getPayments: () => api.get('/admin/payments'),
  getPromoCodes: () => api.get('/admin/promo-codes'),
  createPromoCode: (data) => api.post('/admin/promo-codes', data),
};

// ── Sales API ──
export const salesAPI = {
  getDashboard: () => api.get('/sales/dashboard'),
  getPromoCodes: () => api.get('/sales/promo-codes'),
  getCustomers: () => api.get('/sales/customers'),
};

// ── Vocabulary API ──
export const vocabAPI = {
  getLevels: () => api.get('/vocab/levels'),
  getByLevel: (level) => api.get(`/vocab/hsk/${level}`),
  search: (query) => api.get(`/vocab/search?q=${encodeURIComponent(query)}`),
  getSavedWords: (userId) => api.get(`/vocab/user/${userId}/saved`),
  saveWord: (userId, vocabId) => api.post('/vocab/sync', { userId, savedWords: [vocabId] }),
  unsaveWord: (userId, vocabId) => api.delete(`/vocab/saved-words/${userId}/${vocabId}`),
  getWordStatuses: (userId) => api.get(`/vocab/user/${userId}/statuses`),
  updateWordStatus: (userId, vocabId, status) => api.post('/vocab/sync', { userId, wordStatuses: [{ vocabId, status }] }),
  getUserProfile: (userId) => api.get(`/vocab/user/${userId}/profile`),
  getUserStats: (userId) => api.get(`/vocab/user/${userId}/stats`),
  getUserSettings: (userId) => api.get(`/vocab/user/${userId}/settings`),
  updateSettings: (userId, settings) => api.post(`/vocab/user/${userId}/settings`, { settings }),
  syncLearningSession: (userId, data) => api.post('/vocab/sync', { userId, learningSessions: [data] }),
  syncDailyGoal: (userId, data) => api.post('/vocab/sync', { userId, dailyGoals: [data] }),
  getDailyGoals: (userId, start, end) => api.get(`/vocab/user/${userId}/goals${start && end ? `?start=${start}&end=${end}` : ''}`),
  getLearningSessions: (userId, start, end) => api.get(`/vocab/user/${userId}/sessions-range?start=${start}&end=${end}`),
};

// ── OTP API ──
export const otpAPI = {
  sendOTP: (email) => api.post('/otp/send', { email }),
  verifyOTP: (email, otp) => api.post('/otp/verify', { email, otp }),
  resetPassword: (email, otp, newPassword) => api.post('/otp/reset-password', { email, otp, newPassword }),
};

export default api;
