# 🌐 All API Endpoints - Local & Hosting
# =====================================

## 🏠 LOCAL DEVELOPMENT API
```javascript
LOCAL = {
  API_BASE: '/api',
  BASE_URL: 'http://localhost:5001',
  
  // Full URLs:
  LOGIN: 'http://localhost:5001/api/auth/login',
  REGISTER: 'http://localhost:5001/api/auth/register', 
  PAYMENT_PRICING: 'http://localhost:5001/api/payment/pricing',
  PAYMENT_CHECKOUT: 'http://localhost:5001/api/payment/checkout',
  PAYMENT_VERIFY: 'http://localhost:5001/api/payment/verify/:id',
  MYANPAY_WEBHOOK: 'http://localhost:5001/api/payment/webhook/myanpay'
}
```

## 🚀 PRODUCTION HOSTING API
```javascript
PRODUCTION = {
  API_BASE: 'https://your-domain.com/api',
  BASE_URL: 'https://your-domain.com',
  
  // Full URLs:
  LOGIN: 'https://your-domain.com/api/auth/login',
  REGISTER: 'https://your-domain.com/api/auth/register',
  PAYMENT_PRICING: 'https://your-domain.com/api/payment/pricing', 
  PAYMENT_CHECKOUT: 'https://your-domain.com/api/payment/checkout',
  PAYMENT_VERIFY: 'https://your-domain.com/api/payment/verify/:id',
  MYANPAY_WEBHOOK: 'https://your-domain.com/api/payment/webhook/myanpay'
}
```

## 🧪 STAGING TESTING API
```javascript
STAGING = {
  API_BASE: 'https://staging.your-domain.com/api',
  BASE_URL: 'https://staging.your-domain.com',
  
  // Full URLs:
  LOGIN: 'https://staging.your-domain.com/api/auth/login',
  REGISTER: 'https://staging.your-domain.com/api/auth/register',
  PAYMENT_PRICING: 'https://staging.your-domain.com/api/payment/pricing',
  PAYMENT_CHECKOUT: 'https://staging.your-domain.com/api/payment/checkout', 
  PAYMENT_VERIFY: 'https://staging.your-domain.com/api/payment/verify/:id',
  MYANPAY_WEBHOOK: 'https://staging.your-domain.com/api/payment/webhook/myanpay'
}
```

## 🔄 AUTOMATIC SWITCHING
```javascript
// Development (npm run dev) → Uses LOCAL
// Production (npm run build) → Uses PRODUCTION
// Custom → Change CURRENT_ENV in api-config.js
```

## 📋 MyanmarPay Webhook URLs
- Local: `http://localhost:5001/api/payment/webhook/myanpay`
- Production: `https://your-domain.com/api/payment/webhook/myanpay`
- Staging: `https://staging.your-domain.com/api/payment/webhook/myanpay`

## 🛠️ QUICK SWITCH COMMANDS
```bash
# Force Local
VITE_API_ENV=LOCAL npm run dev

# Force Production  
VITE_API_ENV=PRODUCTION npm run build

# Force Staging
VITE_API_ENV=STAGING npm run build
```
