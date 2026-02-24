# Shwe Flash Checkout - Deployment Guide

## 📋 โครงสร้างโปรเจค
```
checkout/
├── public/             # Static files
├── src/                # React frontend
├── server/             # Node.js backend
│   ├── config/         # Database config
│   ├── routes/         # API routes
│   ├── middleware/     # Express middleware
│   ├── data/          # Database files
│   └── server.js      # Main server file
├── package.json       # Dependencies
└── vite.config.js     # Vite config
```

## 🚀 ขั้นตอนการบิ้วด้วย FileZilla

### 1️⃣ เตรียมไฟล์สำหรับ Upload
```bash
# ในโฟลเดอร์ checkout (local)
npm run build
```
จะสร้างโฟลเดอร์ `dist/` สำหรับ frontend

### 2️⃣ ตั้งค่า FileZilla
- **Host**: [your-server-host]
- **Username**: [your-username]
- **Password**: [your-password]
- **Port**: 21 (FTP) หรือ 22 (SFTP)

### 3️⃣ โครงสร้างที่ Upload บน Server
```
public_html/
├── checkout/           # โฟลเดอร์หลัก
│   ├── dist/          # Frontend build files
│   ├── server/        # Backend files
│   ├── package.json   # Dependencies
│   └── .env           # Environment variables
```

### 4️⃣ ไฟล์ที่ต้อง Upload
#### ✅ **Frontend (dist/)**
- `dist/index.html`
- `dist/assets/` (ทั้งหมด)

#### ✅ **Backend (server/)**
- `server/server.js`
- `server/config/` (ทั้งหมด)
- `server/routes/` (ทั้งหมด)
- `server/middleware/` (ทั้งหมด)
- `server/data/` (ทั้งหมด)

#### ✅ **Config Files**
- `package.json`
- `.env` (สร้างใหม่บน server)
- `node_modules/` (install บน server)

### 5️⃣ ตั้งค่าบน Server
```bash
# SSH เข้า server แล้วรันคำสั่ง
cd public_html/checkout
npm install
npm install -g pm2  # ถ้ายังไม่มี
```

### 6️⃣ สร้าง .env บน Server
```env
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_NAME=shwe_flash_db
JWT_SECRET=your_jwt_secret_key
```

### 7️⃣ รัน Server ด้วย PM2
```bash
pm2 start server/server.js --name "shwe-checkout"
pm2 save
pm2 startup
```

## 🔧 การตั้งค่าเพิ่มเติม

### Apache/Nginx Config
ต้องตั้งค่า reverse proxy จาก port 80/443 → 3000

#### Apache (.htaccess)
```apache
RewriteEngine On
RewriteRule ^api/(.*)$ http://localhost:3000/api/$1 [P,L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /dist/$1 [L]
```

#### Nginx
```nginx
location /api/ {
    proxy_pass http://localhost:3000/api/;
}
location / {
    try_files $uri $uri/ /dist/index.html;
}
```

## 🎯 ตรวจสอบการทำงาน
- Frontend: `http://yourdomain.com/checkout/`
- Backend API: `http://yourdomain.com/api/health`
- PM2 Status: `pm2 status`

## 🚨 ข้อควรระวัง
- ❌ อย่า upload `node_modules/` จาก local
- ❌ อย่า upload `.env` จาก local (สร้างใหม่บน server)
- ✅ ตรวจสอบ permission ของโฟลเดอร์
- ✅ Backup ข้อมูลก่อน deploy
