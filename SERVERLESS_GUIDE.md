# 🔄 Backend Migration: Express → Vercel Serverless

## 📋 สิ่งที่ต้องแปลง:

### 1️⃣ **แปลง Routes → API Functions**

#### 🔄 **จาก Express:**
```javascript
// server/routes/auth.js
router.post('/login', async (req, res) => {
  // logic here
});
```

#### ✅ **เป็น Vercel Function:**
```javascript
// api/auth.js
export default async function handler(req, res) {
  if (req.method === 'POST') {
    // login logic here
  }
}
```

### 2️⃣ **Database Connection**

#### 🔄 **จาก MySQL:**
```javascript
// server/config/database.js
mysql.createConnection({...});
```

#### ✅ **เป็น Vercel Postgres:**
```javascript
// lib/db.js
import { Pool } from '@vercel/postgres';
const pool = new Pool({ connectionString: process.env.POSTGRES_URL });
```

### 3️⃣ **API Functions ที่ต้องสร้าง:**

#### 📁 **api/auth.js**
- POST `/api/auth/login`
- POST `/api/auth/register`

#### 📁 **api/payment.js**  
- POST `/api/payment/create`
- GET `/api/payment/status`

#### 📁 **api/vocab.js**
- GET `/api/vocabulary/*`
- POST `/api/vocabulary/sync`

### 4️⃣ **Environment Variables บน Vercel:**
```env
POSTGRES_URL=postgresql://...
JWT_SECRET=your_secret
STRIPE_SECRET_KEY=sk_test_...
```

## 🎯 **เลือกวิธี:**

### **Option 1: Full Migration** (แนะนำ)
- แปลง backend ทั้งหมดเป็น serverless
- ใช้ Vercel Postgres
- Deploy ทั้ง frontend + backend บน Vercel

### **Option 2: Frontend Only**
- Deploy เฉพาะ frontend บน Vercel
- Backend ยังอยู่บน cPanel
- เปลี่ยน API URLs ใน frontend

### **Option 3: Hybrid**
- Frontend บน Vercel
- Backend บน Railway/Render (Node.js hosting)

## 🤔 **ต้องการทำอย่างไร?**

1. **Full Vercel** - แปลง backend ทั้งหมด
2. **Frontend Only** - backend ไว้บน cPanel  
3. **Hybrid** - frontend Vercel + backend อื่น

**แจ้งให้รู้ว่าต้องการ Option ไหนครับ!**
