# 🚨 QUICK SWITCH GUIDE - คู่มือสลับ Environment ไว
# ==================================================

## 🎯 สลับจาก Local → Hosting (2 ขั้นตอน)

### ขั้นที่ 1: เปลี่ยน Domain
```javascript
// 📁 ไฟล์: src/config/api-config.js

// จากนี้:
PRODUCTION: {
  API_BASE: 'https://your-domain.com/api',  // ❌ เปลี่ยน
  BASE_URL: 'https://your-domain.com',     // ❌ เปลี่ยน
}

// เป็นนี้ (ใส่ domain จริง):
PRODUCTION: {
  API_BASE: 'https://shweflash.com/api',   // ✅ domain จริง
  BASE_URL: 'https://shweflash.com',      // ✅ domain จริง
}
```

### ขั้นที่ 2: Build & Deploy
```bash
npm run build          # ✅ Build สำหรับ production
# อัพโฟลเดอร์ dist/ ขึ้น hosting
```

---

## 🔄 สลับจาก Hosting → Local (1 ขั้นตอน)

### ขั้นที่ 1: ใช้ Development Mode
```bash
npm run dev            # ✅ ใช้ LOCAL อัตโนมัติ
# ไม่ต้องแก้ไขอะไร!
```

---

## 🧪 สลับไป Staging (ทดสอบ)

### ขั้นที่ 1: เปลี่ยน Environment
```javascript
// 📁 ไฟล์: src/config/api-config.js

// เปลี่ยนบรรทัดนี้:
export const CURRENT_ENV = import.meta.env.PROD ? 'PRODUCTION' : 'LOCAL';

// เป็นนี้ชั่วคราว:
export const CURRENT_ENV = 'STAGING';
```

---

## 📱 Test URLs สำหรับทดสอบ

### 🏠 Local Test:
```bash
Frontend: http://localhost:5173
Backend:  http://localhost:5001
API:      http://localhost:5001/api
```

### 🚀 Production Test:
```bash
Frontend: https://your-domain.com
Backend:  https://your-domain.com
API:      https://your-domain.com/api
```

### 🧪 Staging Test:
```bash
Frontend: https://staging.your-domain.com
Backend:  https://staging.your-domain.com
API:      https://staging.your-domain.com/api
```

---

## 🔥 Commands ที่ใช้บ่อย

```bash
# Development
npm run dev                    # 🏠 Local development

# Production
npm run build                  # 🚀 Build production
npm run preview                # 👀 ดู preview

# Environment Variables
VITE_API_ENV=PRODUCTION npm run build    # 🚀 บังคับใช้ production
VITE_API_ENV=STAGING npm run build       # 🧪 บังคับใช้ staging

# Git (ไม่อัพ automatic config files)
git add . --ignore-errors
git commit -m "message"
git push origin master
```

---

## 📋 Checklist ก่อน Deploy

### ✅ Local Development:
- [ ] Backend ทำงานที่ `localhost:5001`
- [ ] Frontend ทำงานที่ `localhost:5173`
- [ ] Payment flow ทำงานปกติ
- [ ] MyanmarPay QR code แสดงผล

### ✅ Production Deploy:
- [ ] เปลี่ยน domain ใน `api-config.js`
- [ ] `npm run build` สำเร็จ
- [ ] อัพ `dist/` ขึ้น hosting
- [ ] Test payment flow บน production
- [ ] MyanmarPay webhook ทำงาน

---

## 🚨 ปัญหาที่พบบ่อย & แก้ไข

### ❌ "API not found"
```javascript
// แก้: เช็คว่า API_BASE ถูกต้อง
console.log(API_BASE); // ต้องแสดง URL ที่ถูกต้อง
```

### ❌ "CORS error"
```javascript
// แก้: Backend ต้องอนุญาต domain ของ frontend
// ใน server: app.use(cors({ origin: 'https://your-domain.com' }))
```

### ❌ "Payment failed"
```javascript
// แก้: เช็ค MyanmarPay credentials
// ใน .env: MYANPAY_SECRET_KEY=sk_live_...
```

---

## 🎯 สรุปเร็วๆ

| Environment | Command | Domain | Auto? |
|-------------|---------|--------|-------|
| 🏠 Local | `npm run dev` | `localhost` | ✅ |
| 🚀 Production | `npm run build` | `your-domain.com` | ✅ |
| 🧪 Staging | `VITE_API_ENV=STAGING npm run build` | `staging.domain.com` | ❌ |

**🔥 ง่ายที่สุด: แค่ `npm run dev` สำหรับ local, `npm run build` สำหรับ production!**
