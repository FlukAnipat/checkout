# 🚨 Railway Environment Variables Setup
# =====================================

## ⚠️ ต้อง Set ใน Railway Dashboard หมด!

### **1. DATABASE_URL (สำคัญที่สุด)**
```
DATABASE_URL=mysql://root:ERtQWdFODWIAyiGyBsxEcCyDqlImcEJB@shinkansen.proxy.rlwy.net:56119/hsk-shwe-flash-db
```

### **2. JWT_SECRET**
```
JWT_SECRET=shwe_flash_jwt_secret_production_2024_secure_change_me
```

### **3. MyanMyanPay (Production)**
```
MYANPAY_APP_ID=MM_PRODUCTION_APP_ID
MYANPAY_PUBLISHABLE_KEY=pk_live_production_key  
MYANPAY_SECRET_KEY=sk_live_production_secret_key
MYANPAY_API_BASE_URL=https://api.myanmyanpay.com
MYANPAY_WEBHOOK_SECRET=wh_production_webhook_secret
```

### **4. App Configuration**
```
NODE_ENV=production
APP_API_KEY=shwe_flash_app_key_production_2024
```

---

## 🛠️ วิธี Set ใน Railway:

### **Step 1: เข้า Railway Dashboard**
1. ไปที่ Railway project
2. เลือก service ของคุณ
3. คลิก "Variables" tab

### **Step 2: Add Variables**
1. คลิก "New Variable"
2. ใส่ชื่อและค่าจากด้านบน
3. คลิก "Add"

### **Step 3: Redeploy**
1. Railway จะ redeploy อัตโนมัติ
2. รอจนกเสร็จ

---

## 🔍 ตรวจสอบว่า Set ถูกต้อง:

### **ใน Railway Logs:**
```
✅ Connected to MySQL database (Railway)
```

### **ถ้าไม่มี DATABASE_URL:**
```
🚨 DATABASE_URL environment variable is required!
Please set it in Railway dashboard:
DATABASE_URL=mysql://root:ERtQWdFODWIAyiGyBsxEcCyDqlImcEJB@shinkansen.proxy.rlwy.net:56119/hsk-shwe-flash-db
```

---

## 🎯 คำถามที่พบบ่อย:

### **Q: ต้อง set ทุกตัวเลยหรอ?**
A: **DATABASE_URL** ต้อง set! ขาดไม่ได้
   ตัวอื่นถ้าไม่ set จะใช้ค่า default

### **Q: เปลี่ยน connection string ได้ไหม?**
A: ได้! ถ้า Railway ให้ connection string ใหม่
   แค่เปลี่ยนใน Railway variables

### **Q: Local ใช้ได้ไหม?**
A: Local จะใช้ localhost ปกติ
   Railway จะใช้ DATABASE_URL

---

## 📋 Checklist ก่อน Deploy:

- [ ] DATABASE_URL ✅ (ขาดไม่ได้)
- [ ] JWT_SECRET ✅
- [ ] MyanMyanPay keys ✅ (ถ้าใช้จริง)
- [ ] NODE_ENV=production ✅

**🚨 ถ้าไม่ set DATABASE_URL จะ error ทันที!**
