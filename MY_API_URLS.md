# 📋 MYANMAR PAY API URLs - บันทึกส่วนตัว
# ===============================================
# ไฟล์นี้สำหรับจดบันทึก API URLs ทั้งหมด ไม่ต้องอัพขึ้น Git
# ===============================================

## 🏠 LOCAL DEVELOPMENT (พัฒนาที่เครื่อง)
```
Environment: LOCAL
API_BASE: /api
BASE_URL: http://localhost:5001

🔗 Full API URLs:
├── Auth APIs:
│   ├── LOGIN: http://localhost:5001/api/auth/login
│   ├── REGISTER: http://localhost:5001/api/auth/register
│   ├── GET ME: http://localhost:5001/api/auth/me
│   └── LOGOUT: http://localhost:5001/api/auth/logout
│
├── Payment APIs:
│   ├── GET PRICING: http://localhost:5001/api/payment/pricing
│   ├── VALIDATE PROMO: http://localhost:5001/api/payment/validate-promo
│   ├── CHECKOUT: http://localhost:5001/api/payment/checkout
│   ├── VERIFY PAYMENT: http://localhost:5001/api/payment/verify/:paymentId
│   ├── GET STATUS: http://localhost:5001/api/payment/status
│   └── GET HISTORY: http://localhost:5001/api/payment/history
│
└── Webhook APIs:
    └── MYANPAY WEBHOOK: http://localhost:5001/api/payment/webhook/myanpay
```

## 🚀 PRODUCTION HOSTING (ใช้จริง)
```
Environment: PRODUCTION
API_BASE: https://your-domain.com/api
BASE_URL: https://your-domain.com

🔗 Full API URLs:
├── Auth APIs:
│   ├── LOGIN: https://your-domain.com/api/auth/login
│   ├── REGISTER: https://your-domain.com/api/auth/register
│   ├── GET ME: https://your-domain.com/api/auth/me
│   └── LOGOUT: https://your-domain.com/api/auth/logout
│
├── Payment APIs:
│   ├── GET PRICING: https://your-domain.com/api/payment/pricing
│   ├── VALIDATE PROMO: https://your-domain.com/api/payment/validate-promo
│   ├── CHECKOUT: https://your-domain.com/api/payment/checkout
│   ├── VERIFY PAYMENT: https://your-domain.com/api/payment/verify/:paymentId
│   ├── GET STATUS: https://your-domain.com/api/payment/status
│   └── GET HISTORY: https://your-domain.com/api/payment/history
│
└── Webhook APIs:
    └── MYANPAY WEBHOOK: https://your-domain.com/api/payment/webhook/myanpay
```

## 🧪 STAGING TESTING (ทดสอบก่อนใช้จริง)
```
Environment: STAGING
API_BASE: https://staging.your-domain.com/api
BASE_URL: https://staging.your-domain.com

🔗 Full API URLs:
├── Auth APIs:
│   ├── LOGIN: https://staging.your-domain.com/api/auth/login
│   ├── REGISTER: https://staging.your-domain.com/api/auth/register
│   ├── GET ME: https://staging.your-domain.com/api/auth/me
│   └── LOGOUT: https://staging.your-domain.com/api/auth/logout
│
├── Payment APIs:
│   ├── GET PRICING: https://staging.your-domain.com/api/payment/pricing
│   ├── VALIDATE PROMO: https://staging.your-domain.com/api/payment/validate-promo
│   ├── CHECKOUT: https://staging.your-domain.com/api/payment/checkout
│   ├── VERIFY PAYMENT: https://staging.your-domain.com/api/payment/verify/:paymentId
│   ├── GET STATUS: https://staging.your-domain.com/api/payment/status
│   └── GET HISTORY: https://staging.your-domain.com/api/payment/history
│
└── Webhook APIs:
    └── MYANPAY WEBHOOK: https://staging.your-domain.com/api/payment/webhook/myanpay
```

## 🌐 MYANMAR PAY PROVIDERS (ระบบชำระเงิน)
```
📱 MyanmarPay Unified Gateway:
├── KBZ Pay (คีบีซี เพย์)
├── Wave Pay (เวฟ เพย์)
├── AYA Pay (อาย่า เพย์)
└── CB Pay (ซีบี เพย์)

🏦 International Cards:
├── MPU Card (บัตรเอ็มพียู)
└── Visa/Mastercard (บัตรวีซ่า/มาสเตอร์การ์ด)
```

## 🔄 วิธีสลับ Environment (ง่ายๆ)
```
Method 1: Automatic (แนะนำ)
├── npm run dev        → ใช้ LOCAL อัตโนมัติ
└── npm run build      → ใช้ PRODUCTION อัตโนมัติ

Method 2: Manual (แก้ไขตรงๆ)
├── เปิดไฟล์: src/config/api-config.js
├── หาบรรทัด: export const CURRENT_ENV = 'LOCAL';
└── เปลี่ยนเป็น: 'PRODUCTION' หรือ 'STAGING'

Method 3: Environment Variable
├── VITE_API_ENV=PRODUCTION npm run build
└── VITE_API_ENV=STAGING npm run build
```

## 📝 บันทึกส่วนตัว (จด domain จริงที่นี่)
```
🚀 Production Domain ของคุณ:
├── Domain: https://[ใส่ domain จริงที่นี่].com
├── API Base: https://[ใส่ domain จริงที่นี่].com/api
└── Webhook: https://[ใส่ domain จริงที่นี่].com/api/payment/webhook/myanpay

🧪 Staging Domain ของคุณ (ถ้ามี):
├── Domain: https://[ใส่ staging domain].com
├── API Base: https://[ใส่ staging domain].com/api
└── Webhook: https://[ใส่ staging domain].com/api/payment/webhook/myanpay
```

## 🛠️ ขั้นตอนการเปลี่ยนไป Hosting
```
1️⃣ เปลี่ยน Domain ใน api-config.js:
   - แก้ 'https://your-domain.com' เป็น domain จริง

2️⃣ Build สำหรับ Production:
   - npm run build

3️⃣ Upload ขึ้น Hosting:
   - อัพโฟลเดอร์ dist/ ขึ้น server
   - อัพโฟลเดอร์ server/ ขึ้น backend

4️⃣ Test Payment Flow:
   - ทดสอบ MyanmarPay QR code
   - ทดสอบ International cards
```

## 📱 MyanmarPay Testing (ทดสอบระบบชำระเงิน)
```
🧪 Sandbox Testing:
├── API Base: https://api.sandbox.myanmyanpay.com
├── Test Credentials: ใช้ข้อมูลทดสอบจาก MyanMyanPay
└── Webhook: http://localhost:5001/api/payment/webhook/myanpay

🚀 Production:
├── API Base: https://api.myanmyanpay.com
├── Real Credentials: ใช้ API keys จริง
└── Webhook: https://your-domain.com/api/payment/webhook/myanpay
```

## 🔧 คำสั่งที่ใช้บ่อย
```
npm run dev              # เริ่ม development (LOCAL)
npm run build            # Build สำหรับ production
npm run preview          # ดูตัวอย่าง production build
git status               # เช็คสถานะไฟล์
git add . && git commit -m "message" && git push  # อัพขึ้น git
```
