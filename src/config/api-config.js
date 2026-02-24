// API Configuration
// Local: Vite proxy handles /api → localhost:5001
// Vercel: vercel.json rewrites /api → api/index.js serverless function
// Both cases use '/api' as base — no switching needed!

export const API_BASE = '/api';
export const BASE_URL = '';
