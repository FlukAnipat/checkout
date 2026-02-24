// lib/config/api_config.dart
class ApiConfig {
  // 🚀 PRODUCTION VERCEL API - Use this for real app
  static const String baseUrl = 'https://checkout-xxx.vercel.app/api';
  
  // 🔄 OR Railway API (if Vercel not deployed yet)
  // static const String baseUrl = 'https://shwe-flash-api.railway.app/api';
  
  // 📱 Flutter App API Key
  static const String appApiKey = 'shwe_flash_app_key_production_2024';
  
  // 🎯 Development Mode Switch
  static const bool useMockData = false; // Set true for UI development only
  
  // 🔄 Get appropriate base URL
  static String get currentBaseUrl {
    if (useMockData) {
      return 'http://localhost:3000/mock'; // Mock server for UI development
    }
    return baseUrl; // Production API
  }
}
