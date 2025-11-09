import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/profile.dart';
import '../config/app_config.dart';
import 'storage_service.dart';

class ApiService {
  // Use configured backend URL from AppConfig
  static String get baseUrl => AppConfig.apiUrl;

  // Auth methods
  static Future<Map<String, dynamic>> sendOTP(String phoneNumber, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneNumber,
          'role': role,
        }),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to send OTP: $e'};
    }
  }

  static Future<Map<String, dynamic>> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneNumber,
          'otp': otp,
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] && data['token'] != null) {
        // Save token using web storage
        await StorageService.saveToken(data['token']);
      }

      return data;
    } catch (e) {
      return {'success': false, 'message': 'Failed to verify OTP: $e'};
    }
  }

  // Profile methods
  static Future<Map<String, dynamic>> createBasicProfile(Map<String, dynamic> data) async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return {'success': false, 'message': 'Not authorized. Please login again.'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/profiles/create-basic'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to create profile: $e'};
    }
  }

  static Future<Map<String, dynamic>> getProfileByCode(String code) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profiles/code/$code'),
        headers: {'Content-Type': 'application/json'},
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to get profile: $e'};
    }
  }

  static Future<Map<String, dynamic>> completeProfile(
    String code,
    Map<String, dynamic> data
  ) async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return {'success': false, 'message': 'Not authorized. Please login again.'};
      }

      final response = await http.put(
        Uri.parse('$baseUrl/profiles/complete/$code'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to complete profile: $e'};
    }
  }

  static Future<Map<String, dynamic>> getAllProfiles() async {
    try {
      final token = await StorageService.getToken();

      if (token == null) {
        return {'success': false, 'message': 'Not authorized. Please login again.'};
      }

      final response = await http.get(
        Uri.parse('$baseUrl/profiles'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Failed to get profiles: $e'};
    }
  }

  static Future<bool> isLoggedIn() async {
    return await StorageService.hasToken();
  }

  static Future<void> logout() async {
    await StorageService.removeToken();
  }
}
