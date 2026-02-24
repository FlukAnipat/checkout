import axios from 'axios';

const API_BASE = process.env.NODE_ENV === 'production' 
  ? 'https://shwe-flash-backend.up.railway.app/api'
  : '/api';

const api = axios.create({
  baseURL: API_BASE,
  headers: { 'Content-Type': 'application/json' },
});

// Attach JWT token to every request
api.interceptors.request.use((config) => {
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

  checkout: (data) =>
    api.post('/payment/checkout', data),

  getStatus: () =>
    api.get('/payment/status'),

  getHistory: () =>
    api.get('/payment/history'),
};

export default api;
