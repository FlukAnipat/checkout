# 🚀 Railway Complete Setup

## 📋 โครงสร้างสำหรับ Railway
```
checkout/
├── api/                    # Serverless Functions (ไม่ใช้แล้ว)
├── dist/                   # Frontend build
├── server/                 # Node.js backend
│   ├── server.js
│   ├── routes/
│   └── config/
├── package.json
└── railway.json           # Railway config
```

## 🔧 Railway Configuration

### 📄 railway.json
```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### 🗄️ Database Migration
```bash
# 1. Export MySQL จาก cPanel
mysqldump -u 651998013 -p 651998013 > mysql_backup.sql

# 2. Convert MySQL → PostgreSQL
# ใช้ online converter หรือ script

# 3. Import ไป Railway PostgreSQL
psql $DATABASE_URL < converted_postgres.sql
```

### 🔗 Environment Variables
```env
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://user:pass@host:port/db
JWT_SECRET=shwe_flash_jwt_secret_2026
APP_API_KEY=shwe_flash_app_key_2024
```

### 🌐 URLs หลัง deploy
- **Frontend**: `https://your-app.up.railway.app`
- **Backend API**: `https://your-app.up.railway.app/api`
- **Database**: Railway PostgreSQL

### 🔄 Update Frontend API
```javascript
// src/services/api.js
const API_BASE = 'https://your-app.up.railway.app/api';
```

## 🚀 Deploy Commands
```bash
# Push ไป GitHub
git add .
git commit -m "Ready for Railway deploy"
git push origin main

# Railway จะ deploy อัตโนมัติ
```

## 📊 Railway Features
- ✅ Free tier: 500 hrs/month
- ✅ Auto-deploy from GitHub
- ✅ Built-in PostgreSQL
- ✅ Custom domains
- ✅ SSL certificates
- ✅ Logs & monitoring
