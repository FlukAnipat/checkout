# 🚨 IMMEDIATE FIX: Flutter API Connection
# =====================================

## ❌ Problem:
- Flutter uses SQLite + local API
- Local server can't connect to Railway MySQL (SSL issue)
- Login response 500

## ✅ QUICK SOLUTION:

### **1. Use Vercel API Directly (Recommended):**

```dart
// lib/config/api_config.dart
class ApiConfig {
  // ✅ DEPLOYED VERCEL API
  static const String baseUrl = 'https://checkout-xxx.vercel.app/api';
  
  // 🔄 OR Railway API (if Vercel not deployed yet)
  // static const String baseUrl = 'https://shwe-flash-api.railway.app/api';
  
  static const String appApiKey = 'shwe_flash_app_key_production_2024';
}
```

### **2. Test API Connection:**

```dart
// Test in Flutter main.dart
void testAPI() async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/health'),
    );
    print('✅ API Status: ${response.statusCode}');
    print('Response: ${response.body}');
  } catch (e) {
    print('❌ API Error: $e');
  }
}
```

### **3. Update Flutter Login:**

```dart
// lib/services/auth_service.dart
Future<bool> login(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/auth/flutter/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'appApiKey': ApiConfig.appApiKey,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Save token and user data
        return true;
      }
    }
    return false;
  } catch (e) {
    print('Login error: $e');
    return false;
  }
}
```

---

## 🎯 **Expected Result:**

```
✅ API Status: 200
Response: {"status":"ok","timestamp":"2024-01-01T00:00:00.000Z"}
[AUTH] Login successful! Welcome to Premium.
```

---

## 🚀 **Next Steps:**

1. **Deploy to Vercel** (if not done yet)
2. **Update Flutter baseUrl** to Vercel domain
3. **Test with `/api/health`** first
4. **Test Flutter login**

**🎉 Flutter จะเชื่อมต่อ Vercel API + Railway MySQL จริง!**
