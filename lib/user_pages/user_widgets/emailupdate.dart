import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/appconfig.dart';
import '../../config/auth_service.dart';

class EmailUpdateFlow extends StatefulWidget {
  @override
  _EmailUpdateFlowState createState() => _EmailUpdateFlowState();
}

class _EmailUpdateFlowState extends State<EmailUpdateFlow> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isSendingOtp = false;
  bool _isVerifying = false;
  String? _errorMessage;
  String? _newEmail;
  final baseColor = const Color.fromARGB(255, 14, 66, 170);

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() => _errorMessage = 'Invalid email format');
      return;
    }

    setState(() {
      _isSendingOtp = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getAccessToken();

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/profile/update-email'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'newEmail': email}),
      );

      if (response.statusCode == 200) {
        setState(() => _newEmail = email);
      } else {
        setState(() => _errorMessage = jsonDecode(response.body)['message']);
      }
    } finally {
      setState(() => _isSendingOtp = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final authService = AuthService();
      final token = await authService.getAccessToken();

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/profile/confirm-email'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'otp': _otpController.text.trim(), 'newEmail': _newEmail}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        setState(() => _errorMessage = jsonDecode(response.body)['message']);
      }
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Update Email',
          style: TextStyle(
            color: baseColor,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.045,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: baseColor,
          size: screenWidth * 0.06,
        ),
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 196, 107),
              Colors.white,
              Color.fromARGB(255, 143, 255, 147),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                if (_newEmail == null) ...[
                  Text(
                    'Enter new email address:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: screenWidth * 0.002,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset:
                              Offset(screenWidth * 0.005, screenWidth * 0.005),
                          blurRadius: screenWidth * 0.01,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02,
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter your new email',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Verify your email:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: baseColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    'Code sent to:',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    _newEmail!,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: baseColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: screenWidth * 0.002,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset:
                              Offset(screenWidth * 0.005, screenWidth * 0.005),
                          blurRadius: screenWidth * 0.01,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: TextStyle(fontSize: screenWidth * 0.04),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02,
                        ),
                        border: InputBorder.none,
                        hintText: 'Enter 6-digit code',
                        hintStyle: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey.shade600,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                ],
                if (_errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Center(
                  child: Container(
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 254, 232, 179),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset:
                              Offset(screenWidth * 0.01, screenWidth * 0.01),
                          blurRadius: screenWidth * 0.02,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _newEmail == null ? _sendOtp : _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                        ),
                      ),
                      child: (_isSendingOtp || _isVerifying)
                          ? SizedBox(
                              width: screenWidth * 0.06,
                              height: screenWidth * 0.06,
                              child: CircularProgressIndicator(
                                color: baseColor,
                                strokeWidth: screenWidth * 0.005,
                              ),
                            )
                          : Text(
                              _newEmail == null ? 'Update' : 'Confirm Update',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: baseColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
