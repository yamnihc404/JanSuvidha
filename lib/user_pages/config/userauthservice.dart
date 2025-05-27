import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jansuvidha/user_pages/dashboard.dart';
import 'package:jansuvidha/user_pages/landing.dart';
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
        Uri.parse('${AppConfig.apiBaseUrl}/user/auth/signup'),
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> signInUser({
    required String username,
    required String password,
    required BuildContext context,
  }) async {
    final Map<String, dynamic> requestBody = {
      'email': username,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        // ✅ Extract tokens and user data
        final accessToken = responseData['token'];
        final refreshToken = responseData['refreshToken'];
        final userData = Map<String, dynamic>.from(responseData['user'] ?? {});

        // ✅ Save tokens and user data
        await _saveAuthData(accessToken, refreshToken, userData);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboard()),
          (route) => false,
        );
      } else {
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Login failed';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Connection error: $e')));
    }
  }

  /// Save authentication data to persistent storage
  Future<void> _saveAuthData(
    String accessToken,
    String refreshToken,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('auth_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('role', userData['role']);

    if (userData.isNotEmpty) {
      await prefs.setString('user_data', jsonEncode(userData));
    }
  }

  /// Get the stored authentication token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      print("Error retrieving token: $e");
      return null;
    }
  }

  /// Check if user is currently logged in with a valid token
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    // Check if token is valid by verifying its expiration
    try {
      if (_isTokenExpired(token)) {
        // Token is expired, clear it
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('auth_token');
        return false;
      }
      return true;
    } catch (e) {
      print("Error checking token validity: $e");
      return false;
    }
  }

  /// Check if a JWT token is expired
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        return true; // Not a valid JWT format
      }

      // Decode the payload part (second part)
      String normalizedPayload = base64Url.normalize(parts[1]);
      final payloadMap = json.decode(
        utf8.decode(base64Url.decode(normalizedPayload)),
      );

      // Check if the token has an expiration claim
      if (payloadMap.containsKey('exp')) {
        final expTimestamp = payloadMap['exp'] as int;
        final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        return currentTimestamp >= expTimestamp;
      }

      return false; // If there's no expiration, consider it valid
    } catch (e) {
      print("Error parsing token: $e");
      return true; // Consider malformed tokens as expired
    }
  }

  /// Refresh token if needed or get a new one
  Future<String?> refreshTokenIfNeeded(BuildContext context) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return null;
    }

    // If token is about to expire (less than 5 minutes remaining), refresh it
    if (_isTokenAboutToExpire(token)) {
      return await _refreshToken(context);
    }

    return token;
  }

  bool _isTokenAboutToExpire(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      ) as Map<String, dynamic>;

      if (payload.containsKey('exp')) {
        final expiration = DateTime.fromMillisecondsSinceEpoch(
          payload['exp'] * 1000,
        );
        return expiration.difference(DateTime.now()).inMinutes < 5;
      }
      return false;
    } catch (e) {
      print("Token expiration check error: $e");
      return true;
    }
  }

  Future<String?> _refreshToken(BuildContext context) async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return null;

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'] ?? refreshToken;
        final userData = data['user'] ?? {};

        await _saveAuthData(newAccessToken, newRefreshToken, userData);
        return newAccessToken;
      } else {
        await logoutUser(context);
        return null;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      await logoutUser(context);
      return null;
    }
  }

  Future<bool> isRefreshTokenValid() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/auth/refresh-token'),
        headers: {'Authorization': 'Bearer $refreshToken'},
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('refresh_token');
    } catch (e) {
      print("Error retrieving refresh token: $e");
      return null;
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

  static Future<void> logoutUser(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken != null) {
      await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/auth/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
    }

    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Landing()),
      (route) => false,
    );

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
