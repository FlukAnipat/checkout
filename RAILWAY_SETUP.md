# Railway Configuration

## 📋 ตั้งค่า Railway Project

### 🔧 Environment Variables ที่ต้องตั้งค่า:
```env
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_USER=651998013
DB_PASSWORD=71008
DB_NAME=651998013
JWT_SECRET=shwe_flash_jwt_secret_2026_railway
APP_API_KEY=shwe_flash_app_key_2024
```

### 🗄️ Database Setup:
1. ใน Railway project → "Add New" → "PostgreSQL"
2. Railway จะสร้าง PostgreSQL database ใหม่
3. คัดลอก DATABASE_URL จาก Railway

### 🔄 Update Database Connection:
แก้ไข `server/config/database.js` ให้ใช้ Railway PostgreSQL:
```javascript
const connection = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});
```

### 🚀 Deploy Commands:
Railway จะรันคำสั่งนี้อัตโนมัติ:
```bash
npm install
npm run build
npm start
```

### 📝 Package.json Scripts:
ตรวจสอบว่ามี:
```json
{
  "scripts": {
    "start": "node server/server.js",
    "build": "vite build"
  }
}
```

### 🌐 URL หลัง Deploy:
- **Backend API**: `https://your-app-name.up.railway.app`
- **Frontend**: `https://chaeckout.vercel.app`

### 🔗 การเชื่อมต่อ:
Frontend (Vercel) → Backend (Railway)
```javascript
const API_BASE_URL = 'https://your-app-name.up.railway.app/api';
```
