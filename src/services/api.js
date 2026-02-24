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
      window.location.href = '/login';
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
};

// ── Payment API ──
export const paymentAPI = {
  getPricing: () =>
    api.get('/payment/pricing'),

  validatePromo: (promoCode) =>
    api.post('/payment/validate-promo', { promoCode }),

  validateSalesCode: (salesCode) =>
    api.post('/payment/validate-sales-code', { salesCode }),

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

export default api;
