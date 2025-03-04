import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

class AuthService {
  // URL to your backend signin route
  static const String apiUrl =
      'https://2b75-114-143-215-162.ngrok-free.app/user/signin';
  static const String apiUrlSignUp =
      'https://2b75-114-143-215-162.ngrok-free.app/user/signup';

  // Function to handle sign-in
  static Future<Map<String, dynamic>> signIn(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "token": data['token']
        }; // Return the token on success
      } else {
        final error = jsonDecode(response.body);
        return {
          "success": false,
          "message": error['message']
        }; // Return error message
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error connecting to server: $e"
      }; // Handle network error
    }
  }

  static Future<bool> signUp(
    String username,
    String password,
    String email,
    String contactnumber,
    String aadharnumber,
    Function onSuccess,
    Function onError,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrlSignUp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
          "email": email,
          "contactnumber": contactnumber,
          "aadharnumber": aadharnumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        onSuccess(data['message']); // Call success callback
        return true;
      } else {
        final error = jsonDecode(response.body);
        onError(error['message']); // Call error callback
        return false;
      }
    } catch (e) {
      onError("Error connecting to server: $e");
      return false;
    }
  }
}
