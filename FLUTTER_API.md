# 📱 Flutter App API Documentation
# ===================================

## 🔐 Authentication (สำคัญที่สุด)

### **POST /api/auth/login**
```dart
// Flutter login
final response = await http.post(
  Uri.parse('https://your-vercel-domain.com/api/auth/login'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'email': 'user@example.com',
    'password': 'password123'
  }),
);

// Response
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "userId": "uuid-123",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "isPaid": true,
    "paidAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### **POST /api/auth/register**
```dart
// Flutter register
final response = await http.post(
  Uri.parse('https://your-vercel-domain.com/api/auth/register'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'email': 'newuser@example.com',
    'password': 'password123',
    'firstName': 'John',
    'lastName': 'Doe',
    'phone': '09123456789',
    'countryCode': '+95'
  }),
);
```

### **GET /api/auth/me**
```dart
// Get user profile (with token)
final response = await http.get(
  Uri.parse('https://your-vercel-domain.com/api/auth/me'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  },
);
```

---

## 📚 Vocabulary API

### **GET /api/vocab/levels**
```dart
// Get HSK level stats
final response = await http.get(
  Uri.parse('https://your-vercel-domain.com/api/vocab/levels'),
);

// Response
{
  "levels": [
    {"hsk_level": 1, "word_count": 150},
    {"hsk_level": 2, "word_count": 150},
    {"hsk_level": 3, "word_count": 300}
  ]
}
```

### **GET /api/vocab/hsk/:level**
```dart
// Get words for HSK level
final response = await http.get(
  Uri.parse('https://your-vercel-domain.com/api/vocab/hsk/1'),
  headers: {'Authorization': 'Bearer $token'},
);

// Response
{
  "hskLevel": 1,
  "count": 150,
  "words": [
    {
      "vocab_id": 1,
      "chinese": "你好",
      "pinyin": "nǐ hǎo",
      "thai": "สวัสดี",
      "english": "hello"
    }
  ]
}
```

---

## 👤 User Profile API

### **GET /api/vocab/profile/:userId**
```dart
// Get complete user profile
final response = await http.get(
  Uri.parse('https://your-vercel-domain.com/api/vocab/profile/$userId'),
  headers: {'Authorization': 'Bearer $token'},
);

// Response
{
  "user_id": "uuid-123",
  "email": "user@example.com",
  "first_name": "John",
  "is_paid": 1,
  "saved_count": 25,
  "mastered_count": 10,
  "total_learned": 150
}
```

---

## 🎯 Learning Progress API

### **POST /api/vocab/session**
```dart
// Sync learning session
final response = await http.post(
  Uri.parse('https://your-vercel-domain.com/api/vocab/session'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  },
  body: jsonEncode({
    'userId': 'uuid-123',
    'sessionDate': '2024-01-01',
    'learnedCards': 10,
    'minutesSpent': 15,
    'hskLevel': 1
  }),
);
```

### **GET /api/vocab/stats/:userId**
```dart
// Get user statistics
final response = await http.get(
  Uri.parse('https://your-vercel-domain.com/api/vocab/stats/$userId'),
  headers: {'Authorization': 'Bearer $token'},
);

// Response
{
  "dayStreak": 7,
  "totalLearned": 150
}
```

---

## 💾 Saved Words API

### **POST /api/vocab/save**
```dart
// Save word
final response = await http.post(
  Uri.parse('https://your-vercel-domain.com/api/vocab/save'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  },
  body: jsonEncode({
    'userId': 'uuid-123',
    'vocabId': 1
  }),
);
```

### **DELETE /api/vocab/save/:userId/:vocabId**
```dart
// Remove saved word
final response = await http.delete(
  Uri.parse('https://your-vercel-domain.com/api/vocab/save/uuid-123/1'),
  headers: {'Authorization': 'Bearer $token'},
);
```

---

## 🏆 Achievements API

### **POST /api/vocab/achievement**
```dart
// Unlock achievement
final response = await http.post(
  Uri.parse('https://your-vercel-domain.com/api/vocab/achievement'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  },
  body: jsonEncode({
    'userId': 'uuid-123',
    'achievementKey': 'first_word_mastered'
  }),
);
```

---

## 🔧 Flutter Implementation

### **API Service Class**
```dart
class ShweFlashAPI {
  final String baseUrl = 'https://your-vercel-domain.com/api';
  String? _token;

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      return data;
    } else {
      throw Exception('Login failed');
    }
  }

  // Get headers with token
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  // Get HSK words
  Future<List<Map<String, dynamic>>> getHSKWords(int level) async {
    final response = await http.get(
      Uri.parse('$baseUrl/vocab/hsk/$level'),
      headers: _getHeaders(),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['words']);
    } else {
      throw Exception('Failed to load words');
    }
  }
}
```

---

## 🚨 Error Handling

### **Common Error Responses**
```dart
// 401 Unauthorized
{
  "error": "Invalid email or password"
}

// 400 Bad Request
{
  "error": "Email and password are required"
}

// 500 Server Error
{
  "error": "Internal server error",
  "details": "Database connection failed"
}
```

### **Flutter Error Handling**
```dart
try {
  final userData = await api.login(email, password);
  // Save token to secure storage
  await storage.write(key: 'token', value: api.token);
} catch (e) {
  if (e.toString().contains('401')) {
    // Show invalid credentials dialog
  } else if (e.toString().contains('500')) {
    // Show server error dialog
  } else {
    // Show generic error dialog
  }
}
```

---

## 🔐 Security Notes

### **Token Management**
```dart
// Use flutter_secure_storage for token storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Save token
await storage.write(key: 'shwe_flash_token', value: token);

// Read token
final token = await storage.read(key: 'shwe_flash_token');

// Delete token
await storage.delete(key: 'shwe_flash_token');
```

### **API Key Validation**
```dart
// Add app API key to headers (optional)
Map<String, String> _getHeaders() {
  return {
    'Content-Type': 'application/json',
    'X-App-API-Key': 'shwe_flash_app_key_production_2024',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };
}
```

---

## 📋 Deployment Checklist

### **Before Launch**
- [ ] Update `baseUrl` to actual Vercel domain
- [ ] Test all API endpoints
- [ ] Implement proper error handling
- [ ] Add token refresh logic
- [ ] Test offline functionality

### **API Base URL**
```
Development: http://localhost:5001/api
Production: https://your-vercel-domain.com/api
```

**🎉 Flutter app พร้อมเชื่อมต่อกับ Railway database ผ่าน Vercel API!**
