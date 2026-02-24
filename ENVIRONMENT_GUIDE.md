# 🌐 Environment Configuration Guide
# ====================================

# 🏠 LOCAL DEVELOPMENT
# API_BASE: /api
# BASE_URL: http://localhost:5001
# Use for: Development on your machine

# 🚀 PRODUCTION HOSTING  
# API_BASE: https://your-domain.com/api
# BASE_URL: https://your-domain.com
# Use for: Live production server

# 🧪 STAGING TESTING
# API_BASE: https://staging.your-domain.com/api  
# BASE_URL: https://staging.your-domain.com
# Use for: Testing before production

# ====================================
# 📋 HOW TO SWITCH ENVIRONMENTS:
# ====================================

# Method 1: Automatic (Recommended)
# - Development: Uses LOCAL automatically
# - Production: Uses PRODUCTION when npm run build

# Method 2: Manual Override
# Edit src/config/api-config.js > CURRENT_ENV

# Method 3: Environment Variable  
# Add .env file with: VITE_API_ENV=PRODUCTION

# ====================================
# 🛠️ QUICK SETUP COMMANDS:
# ====================================

# For Local Development:
# npm run dev

# For Production Build:
# npm run build

# For Staging Build:
# VITE_API_ENV=STAGING npm run build

# ====================================
# 📁 FILES TO CONFIGURE FOR HOSTING:
# ====================================

# 1. Frontend (dist/ folder)
#    - Upload to Vercel/Netlify/etc.
#    - Change domain in api-config.js

# 2. Backend (server/ folder) 
#    - Upload to Railway/Heroku/VPS
#    - Set environment variables
#    - Configure database

# 3. MyanmarPay
#    - Get production API keys
#    - Set webhook URLs
#    - Update .env on server
