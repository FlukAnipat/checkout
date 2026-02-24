// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  // 🚀 Flutter Login (Production API)
  static Future<Map<String, dynamic>> loginFlutter(
    String email, 
    String password
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/auth/flutter/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'appApiKey': ApiConfig.appApiKey,
        }),
      );

      print('🔍 Login Response Status: ${response.statusCode}');
      print('🔍 Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['error'] ?? 'Login failed');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Login Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🚀 Flutter Register (Production API)
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
        Uri.parse('${ApiConfig.currentBaseUrl}/auth/flutter/register'),
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
          'appApiKey': ApiConfig.appApiKey,
        }),
      );

      print('🔍 Register Response Status: ${response.statusCode}');
      print('🔍 Register Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data;
        } else {
          throw Exception(data['error'] ?? 'Registration failed');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Register Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🚀 Get User Profile (Production API)
  static Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/auth/flutter/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'X-App-API-Key': ApiConfig.appApiKey,
        },
      );

      print('🔍 Profile Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Profile fetch failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Profile Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🚀 Get HSK Words (Production API)
  static Future<Map<String, dynamic>> getHSKWords(int level, String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/vocab/hsk/$level'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔍 HSK Words Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load words: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ HSK Words Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🚀 Get HSK Levels (Production API)
  static Future<Map<String, dynamic>> getHSKLevels() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/vocab/levels'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('🔍 HSK Levels Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load levels: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ HSK Levels Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🚀 Refresh Token (Production API)
  static Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/auth/flutter/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      print('🔍 Refresh Token Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Token refresh failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Refresh Token Error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🧪 Test API Connection
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/health'),
      );

      print('🔍 Health Check Status: ${response.statusCode}');
      print('🔍 Health Check Body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Health Check Error: $e');
      return false;
    }
  }
}
