# 📝 Checklist การ Upload ด้วย FileZilla

## ✅ ไฟล์ที่ Build เสร็จแล้ว (พร้อม Upload)
```
checkout/dist/
├── index.html (744 bytes)
├── vite.svg (1,497 bytes)
└── assets/
    ├── index-Bj_OTV3-.css (24,731 bytes)
    └── index-C5MeJ_JZ.js (290,770 bytes)
```

## 🚀 ขั้นตอนการ Upload ด้วย FileZilla

### 1️⃣ เปิด FileZilla และเชื่อมต่อ Server
- **Host**: [your-server-host]
- **Username**: [your-username] 
- **Password**: [your-password]
- **Port**: 21 (FTP) หรือ 22 (SFTP)

### 2️⃣ สร้างโครงสร้างโฟลเดอร์บน Server
```
public_html/
└── checkout/          ← สร้างโฟลเดอร์นี้
```

### 3️⃣ Upload ไฟล์ (ลากและวาง)
#### 📁 **Frontend Files** (จาก `checkout/dist/`)
```
local: checkout/dist/*        →  server: public_html/checkout/
```
ไฟล์ที่ต้อง upload:
- ✅ `index.html`
- ✅ `vite.svg`  
- ✅ `assets/` (ทั้งโฟลเดอร์)

#### 📁 **Backend Files** (จาก `checkout/server/`)
```
local: checkout/server/*      →  server: public_html/checkout/server/
```
ไฟล์ที่ต้อง upload:
- ✅ `server.js`
- ✅ `config/` (ทั้งโฟลเดอร์)
- ✅ `routes/` (ทั้งโฟลเดอร์)
- ✅ `middleware/` (ทั้งโฟลเดอร์)
- ✅ `data/` (ทั้งโฟลเดอร์)

#### 📄 **Config Files**
```
local: checkout/package.json  →  server: public_html/checkout/
```

### 4️⃣ หลัง Upload เสร็จ (SSH เข้า Server)
```bash
# เข้าโฟลเดอร์ project
cd public_html/checkout

# Install dependencies
npm install

# สร้างไฟล์ .env (สำคัญมาก!)
nano .env
```

### 5️⃣ สร้างไฟล์ .env บน Server
```env
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_USER=your_db_user
DB_PASSWORD=your_db_password  
DB_NAME=shwe_flash_db
JWT_SECRET=your_jwt_secret_key_here
```

### 6️⃣ รัน Server ด้วย PM2
```bash
# Install PM2 (ถ้ายังไม่มี)
npm install -g pm2

# Start server
pm2 start server/server.js --name "shwe-checkout"

# Save process
pm2 save

# Setup auto-start
pm2 startup
```

## 🎯 ตรวจสอบการทำงาน
- **Frontend**: `http://yourdomain.com/checkout/`
- **Backend API**: `http://yourdomain.com/api/health`
- **PM2 Status**: `pm2 status`

## 🚨 อย่าลืม!
- ❌ อย่า upload `node_modules/`
- ❌ อย่า upload `.env` จาก local  
- ✅ สร้าง `.env` ใหม่บน server
- ✅ ตรวจสอบ permission ของโฟลเดอร์
