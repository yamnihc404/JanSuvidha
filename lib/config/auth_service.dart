import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'appconfig.dart';

class AuthService {
  static const String baseUrl = AppConfig.apiBaseUrl;

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
    required bool isAdmin,
  }) async {
    final endpoint = isAdmin ? '/admin/auth/signin' : '/user/auth/signin';

    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', responseData['accessToken']);
        await prefs.setString('refreshToken', responseData['refreshToken']);
        await prefs.setString('role', responseData['user']['role']);
        await prefs.setString('userId', responseData['user']['id']);
        await prefs.setString('userName', responseData['user']['name'] ?? '');
        await prefs.setString(
          'department',
          responseData['user']['department'] ?? '',
        );

        if (responseData['user']['role'] == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/user-dashboard');
        }
      } else {
        _showSnackBar(context, responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showSnackBar(context, 'Something went wrong: $e');
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String contactNumber,
    required BuildContext context,
    required bool isAdmin,
    String? department, // Required for admin
  }) async {
    final endpoint = isAdmin ? '/admin/auth/signup' : '/user/auth/signup';

    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'contactNumber': contactNumber,
          if (isAdmin) 'department': department,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _showSnackBar(context, responseData['message'] ?? 'Signup successful');
        Navigator.pushReplacementNamed(
          context,
          isAdmin ? '/admin-login' : '/user-login',
        );
      } else {
        _showSnackBar(context, responseData['message'] ?? 'Signup failed');
      }
    } catch (e) {
      _showSnackBar(context, 'Something went wrong: $e');
    }
  }

  Future<bool> refreshToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final refresh = prefs.getString('refreshToken');

    if (token == null || refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refresh',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString('accessToken', data['accessToken']);
        return true;
      } else {
        await signOut(context);
        return false;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/common-landing');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
