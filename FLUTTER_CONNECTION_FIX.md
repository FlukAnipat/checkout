# 🚨 Flutter App API Connection Fix
# ===================================

## ❌ Current Problem:
```
[DB] SQLite not available on web - using in-memory providers
[API] Login response 500
[AUTH] Server login failed, using local-only
```

## ✅ Solution: Update Flutter API Configuration

### **1. Update API Base URL in Flutter:**

```dart
// lib/config/api_config.dart
class ApiConfig {
  // ❌ WRONG (local SQLite)
  // static const String baseUrl = 'http://localhost:5001/api';
  
  // ✅ CORRECT (Vercel production API)
  static const String baseUrl = 'https://your-vercel-domain.com/api';
  
  // App API Key for Flutter
  static const String appApiKey = 'shwe_flash_app_key_production_2024';
}
```

### **2. Update Flutter API Service:**

```dart
// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static const String _baseUrl = ApiConfig.baseUrl;
  static const String _appApiKey = ApiConfig.appApiKey;

  // Flutter Login
  static Future<Map<String, dynamic>> loginFlutter(
    String email, 
    String password
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/flutter/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'appApiKey': _appApiKey,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Flutter Register
  static Future<Map<String, dynamic>> registerFlutter({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String? countryCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/flutter/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone ?? '',
          'countryCode': countryCode ?? '+95',
          'appApiKey': _appApiKey,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get User Profile
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/auth/flutter/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-App-API-Key': _appApiKey,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Profile fetch failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get HSK Words
  static Future<Map<String, dynamic>> getHSKWords(int level, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/vocab/hsk/$level'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load words: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
```

### **3. Update Flutter Auth Provider:**

```dart
// lib/providers/auth_provider.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  String? _token;
  String? _refreshToken;
  Map<String, dynamic>? _user;
  bool _isLoading = false;

  // Getters
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  // Login
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await ApiService.loginFlutter(email, password);
      
      if (response['success']) {
        _token = response['token'];
        _refreshToken = response['refreshToken'];
        _user = response['user'];
        
        // Save to secure storage
        await _storage.write(key: 'shwe_flash_token', value: _token);
        await _storage.write(key: 'shwe_flash_refresh', value: _refreshToken);
        await _storage.write(key: 'shwe_flash_user', value: jsonEncode(_user));
        
        notifyListeners();
      } else {
        throw Exception(response['error'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Register
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    _setLoading(true);
    try {
      final response = await ApiService.registerFlutter(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      
      if (response['success']) {
        _token = response['token'];
        _refreshToken = response['refreshToken'];
        _user = response['user'];
        
        // Save to secure storage
        await _storage.write(key: 'shwe_flash_token', value: _token);
        await _storage.write(key: 'shwe_flash_refresh', value: _refreshToken);
        await _storage.write(key: 'shwe_flash_user', value: jsonEncode(_user));
        
        notifyListeners();
      } else {
        throw Exception(response['error'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.deleteAll();
    _token = null;
    _refreshToken = null;
    _user = null;
    notifyListeners();
  }

  // Load saved user
  Future<void> loadUser() async {
    try {
      final savedToken = await _storage.read(key: 'shwe_flash_token');
      final savedUser = await _storage.read(key: 'shwe_flash_user');
      
      if (savedToken != null && savedUser != null) {
        _token = savedToken;
        _user = jsonDecode(savedUser);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
```

### **4. Test Connection:**

```dart
// main.dart - Test API connection
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Test API connection
  try {
    final response = await http.get(
      Uri.parse('https://your-vercel-domain.com/api/health'),
    );
    print('API Health Check: ${response.statusCode}');
    print('Response: ${response.body}');
  } catch (e) {
    print('API Connection Error: $e');
  }
  
  runApp(MyApp());
}
```

---

## 🎯 **Quick Fix Steps:**

1. **Update `baseUrl`** to Vercel domain
2. **Add `appApiKey`** to all Flutter requests  
3. **Use `/api/auth/flutter/*`** endpoints
4. **Remove SQLite** dependencies
5. **Test with `/api/health`** first

---

## 🚀 **Expected Result:**

```
[API] Health Check: 200
[API] Response: {"status":"ok","timestamp":"2024-01-01T00:00:00.000Z"}
[API] Login response 200
[AUTH] Login successful! Welcome to Premium.
```

**🎉 Flutter app จะเชื่อมต่อกับ Vercel API และ Railway MySQL จริง!**
