import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

class AuthService {
  // URL to your backend signin route
  static const String apiUrl =
      'https://2e05-2405-201-1009-c9da-1480-bc5b-2c55-b813.ngrok-free.app';

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
}
