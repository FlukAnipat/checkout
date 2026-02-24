// lib/services/referral_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ReferralService {
  // 🎯 ดู referral code ของตัวเอง
  static Future<Map<String, dynamic>> getMyReferralCode(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.currentBaseUrl}/referral/my-code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to get referral code');
      }
    } catch (e) {
      print('❌ Get referral code error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🎯 ตรวจสอบว่า referral code มีอยู่แล้ว
  static Future<Map<String, dynamic>> checkReferralCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.currentBaseUrl}/referral/check'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to check referral code');
      }
    } catch (e) {
      print('❌ Check referral code error: $e');
      throw Exception('Network error: $e');
    }
  }

  // 🎯 แชะ referral code ใน checkout
  static Future<Map<String, dynamic>> applyReferralCode(String referralCode, String token) async {
    try {
      // ตรวจสอบว่า referral code มีอยู่แล้ว
      final checkResponse = await checkReferralCode(referralCode);
      
      if (!checkResponse['exists']) {
        throw Exception('Invalid referral code');
      }

      // แสดงข้อมูลเจ้าของ referral code
      final referralInfo = checkResponse['referralInfo'];
      if (referralInfo != null) {
        print('🎯 Referral code belongs to: ${referralInfo['ownerName']}');
      }

      return checkResponse;
    } catch (e) {
      print('❌ Apply referral code error: $e');
      throw Exception('Failed to apply referral code');
    }
  }
}
