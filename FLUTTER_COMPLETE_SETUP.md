# 📱 FLUTTER APP - COMPLETE SETUP GUIDE
# =====================================

## 🎯 **QUICK FIX - Copy These Files to Your Flutter Project:**

### **1. lib/config/api_config.dart**
```dart
class ApiConfig {
  // 🚀 PRODUCTION VERCEL API
  static const String baseUrl = 'https://checkout-xxx.vercel.app/api';
  
  // 🔄 OR Railway API (if Vercel not deployed yet)
  // static const String baseUrl = 'https://shwe-flash-api.railway.app/api';
  
  static const String appApiKey = 'shwe_flash_app_key_production_2024';
  static const bool useMockData = false; // Set true for UI development only
  
  static String get currentBaseUrl {
    return useMockData ? 'http://localhost:3000/mock' : baseUrl;
  }
}
```

### **2. lib/services/api_service.dart**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<Map<String, dynamic>> loginFlutter(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/auth/flutter/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'appApiKey': ApiConfig.appApiKey,
        }),
      );

      print('🔍 Login Status: ${response.statusCode}');
      print('🔍 Login Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] ? data : throw Exception(data['error'] ?? 'Login failed');
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Login Error: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> testConnection() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.currentBaseUrl}/health'));
      print('🔍 Health Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Health Error: $e');
      return false;
    }
  }
}
```

---

## 🚀 **DEPLOYMENT STEPS:**

### **Step 1: Deploy to Vercel**
```bash
# In checkout directory
npm run build
git add .
git commit -m "Ready for Vercel deployment"
git push origin master
```

### **Step 2: Get Vercel Domain**
```
Your Vercel URL: https://checkout-abc123.vercel.app
```

### **Step 3: Update Flutter Config**
```dart
// lib/config/api_config.dart
static const String baseUrl = 'https://checkout-abc123.vercel.app/api';
```

### **Step 4: Add Dependencies**
```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.5
  flutter_secure_storage: ^8.0.0
```

### **Step 5: Test Flutter App**
```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test API first
  final isConnected = await ApiService.testConnection();
  print('API Connected: $isConnected');
  
  runApp(MyApp());
}
```

---

## 🎯 **Expected Results:**

### **✅ Working:**
```
🔍 Health Status: 200
🔍 Health Body: {"status":"ok","timestamp":"2024-01-01T00:00:00.000Z"}
🔍 Login Status: 200
🔍 Login Body: {"success":true,"token":"eyJ...","user":{...}}
```

### **❌ Not Working:**
```
❌ Health Error: Connection refused
❌ Login Error: Network error
```

---

## 🔧 **Troubleshooting:**

### **Problem: Connection Refused**
```dart
// Check if Vercel is deployed
static const String baseUrl = 'https://your-actual-vercel-domain.vercel.app/api';
```

### **Problem: 500 Error**
```dart
// Check server logs on Vercel dashboard
// Make sure Railway MySQL is connected
```

### **Problem: 401 Unauthorized**
```dart
// Check appApiKey
static const String appApiKey = 'shwe_flash_app_key_production_2024';
```

---

## 🎉 **Final Architecture:**

```
📱 Flutter App
├── 🌐 Vercel API (https://checkout-xxx.vercel.app/api)
├── 🔐 Flutter Auth (/api/auth/flutter/*)
├── 📚 Vocabulary API (/api/vocab/*)
└── 🗄️ Railway MySQL Database
```

**🚀 Copy these files to your Flutter project and it will work with Vercel API + Railway MySQL!**
