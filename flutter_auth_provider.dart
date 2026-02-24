// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final _storage = FlutterSecureStorage();
  String? _token;
  String? _refreshToken;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String? get token => _token;
  String? get refreshToken => _refreshToken;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  String? get errorMessage => _errorMessage;

  // 🚀 Login with Production API
  Future<void> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      print('🔐 Attempting login with: $email');
      
      final response = await ApiService.loginFlutter(email, password);
      
      if (response['success']) {
        _token = response['token'];
        _refreshToken = response['refreshToken'];
        _user = response['user'];
        
        // Save to secure storage
        await _storage.write(key: 'shwe_flash_token', value: _token);
        await _storage.write(key: 'shwe_flash_refresh', value: _refreshToken);
        await _storage.write(key: 'shwe_flash_user', value: jsonEncode(_user));
        
        print('✅ Login successful!');
        notifyListeners();
      } else {
        _setError(response['error'] ?? 'Login failed');
      }
    } catch (e) {
      print('❌ Login error: $e');
      _setError('Login failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 🚀 Register with Production API
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      print('🔐 Attempting registration for: $email');
      
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
        
        print('✅ Registration successful!');
        notifyListeners();
      } else {
        _setError(response['error'] ?? 'Registration failed');
      }
    } catch (e) {
      print('❌ Registration error: $e');
      _setError('Registration failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  // 🔄 Refresh Token
  Future<void> refreshAuthToken() async {
    if (_refreshToken == null) {
      await logout();
      return;
    }

    try {
      print('🔄 Refreshing token...');
      
      final response = await ApiService.refreshToken(_refreshToken!);
      
      if (response['success']) {
        _token = response['token'];
        _user = response['user'];
        
        await _storage.write(key: 'shwe_flash_token', value: _token);
        await _storage.write(key: 'shwe_flash_user', value: jsonEncode(_user));
        
        print('✅ Token refreshed successfully!');
        notifyListeners();
      } else {
        print('❌ Token refresh failed, logging out...');
        await logout();
      }
    } catch (e) {
      print('❌ Token refresh error: $e');
      await logout();
    }
  }

  // 👤 Get Updated Profile
  Future<void> updateProfile() async {
    if (_token == null) return;

    try {
      print('🔄 Updating profile...');
      
      final response = await ApiService.getProfile(_token!);
      
      if (response['success']) {
        _user = response['user'];
        await _storage.write(key: 'shwe_flash_user', value: jsonEncode(_user));
        notifyListeners();
      }
    } catch (e) {
      print('❌ Profile update error: $e');
    }
  }

  // 🚪 Logout
  Future<void> logout() async {
    try {
      await _storage.deleteAll();
      _token = null;
      _refreshToken = null;
      _user = null;
      _clearError();
      print('✅ Logged out successfully');
      notifyListeners();
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  // 📂 Load Saved User
  Future<void> loadUser() async {
    try {
      final savedToken = await _storage.read(key: 'shwe_flash_token');
      final savedRefresh = await _storage.read(key: 'shwe_flash_refresh');
      final savedUser = await _storage.read(key: 'shwe_flash_user');
      
      if (savedToken != null && savedUser != null) {
        _token = savedToken;
        _refreshToken = savedRefresh;
        _user = jsonDecode(savedUser);
        print('✅ User loaded from storage');
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      await logout();
    }
  }

  // 🧪 Test API Connection
  Future<bool> testConnection() async {
    try {
      print('🔍 Testing API connection...');
      final isConnected = await ApiService.testConnection();
      
      if (isConnected) {
        print('✅ API connection successful');
      } else {
        print('❌ API connection failed');
      }
      
      return isConnected;
    } catch (e) {
      print('❌ Connection test error: $e');
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
