import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';

class AuthService {
  /// Signs up a new user with the provided details.
  Future<void> signUpUser({
    required String username,
    required String contactNumber,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final Map<String, dynamic> requestBody = {
      'username': username,
      'contactnumber': contactNumber,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User signed up successfully')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage = errorData['message'] ?? 'Signup failed';

        if (errorData['error'] != null) {
          errorMessage = errorData['error'].join('');
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  /// Signs in a user with the provided username and password.
  Future<void> signInUser({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    final Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['token'];
        final userData = json.decode(response.body)['user'] ?? {};

        // Save auth token and user data
        await _saveAuthData(token, userData);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection error: $e')),
      );
    }
  }

  /// Save authentication data to persistent storage
  Future<void> _saveAuthData(
      String token, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    // Optionally store user data for profile display
    if (userData.isNotEmpty) {
      await prefs.setString('user_data', jsonEncode(userData));
    }
  }

  /// Get the stored authentication token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      return token;
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  /// Check if user is currently logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Sign out the current user
  Future<void> signOut(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      // Navigate to landing page after logout
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  /// Get stored user data
  Future<Map<String, dynamic>> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null && userData.isNotEmpty) {
        return jsonDecode(userData) as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
    return {};
  }
}
