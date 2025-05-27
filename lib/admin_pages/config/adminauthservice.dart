import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'appconfig.dart';

void _showErrorSnackBar(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100,
        left: 20,
        right: 20,
      ),
    ),
  );
}

class AuthService {
  static Future<void> registerAdmin({
    required String fullName,
    required String email,
    required String password,
    required String contactNumber,
    required String department,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/admin/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'contactNumber': contactNumber,
          'department': department,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${responseBody['message']}'),
            backgroundColor: const Color.fromARGB(255, 3, 169, 0),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              left: 20,
              right: 20,
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error: ${e.toString()}', context);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/admin/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final accessToken = responseData['accessToken'];
        final refreshToken = responseData['refreshToken'];
        final user = responseData['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('role', user['role']);
        await prefs.setString('userId', user['id']);
        await prefs.setString('userName', user['name']);
        await prefs.setString('department', user['department']);

        // ✅ Navigate based on role
        if (user['role'] == 'admin') {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/admin-dashboard',
            (route) => false,
          );
        }
      } else {
        final message = responseData['message'] ?? 'Login failed';
        _showErrorSnackbar(context, message);
      }
    } catch (e) {
      _showErrorSnackbar(context, "Something went wrong: $e");
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accessToken');
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  static Future<void> logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken != null) {
      await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/admin/auth/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    }

    await prefs.clear();

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Logged out successfully'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating, // Makes it float above content
        margin: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).size.height - 100, // Positions near top
          left: 20,
          right: 20,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10), // Rounded bottom corners
          ),
        ),
      ),
    );
  }
}
