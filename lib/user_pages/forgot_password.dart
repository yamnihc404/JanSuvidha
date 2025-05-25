import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendPasswordResetEmail(String email) async {
    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/user/password/forgot'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check your email for reset link')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email not found or server error')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
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
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.scale(
                      scale: screenWidth < 350 ? 1.2 : 1.5,
                      child: Image.asset(
                        'images/Logo.png',
                        width: screenWidth * 0.5,
                        height: screenWidth * 0.5,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 14, 66, 170),
                            fontSize: screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1),
                          child: Text(
                            'Enter your email address. We will send you a link to reset your password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 14, 66, 170),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04),
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 230, 160),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.04),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(5, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: const Color.fromARGB(255, 14, 66, 170),
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: const Color.fromARGB(255, 14, 66, 170),
                                size: screenWidth * 0.06,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        Container(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.04),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(5, 5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final email = emailController.text.trim();
                                    if (email.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Please enter your email'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else if (!isValidEmail(email)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Please enter a valid email address'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      sendPasswordResetEmail(email);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 230, 160),
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.04),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: screenWidth * 0.06,
                                    height: screenWidth * 0.06,
                                    child: CircularProgressIndicator(
                                      color: const Color.fromARGB(
                                          255, 14, 66, 170),
                                      strokeWidth: screenWidth * 0.008,
                                    ),
                                  )
                                : Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      color: const Color.fromARGB(
                                          255, 14, 66, 170),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 15, 62, 129),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.03,
            left: screenWidth * 0.05,
            child: SizedBox(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 255, 230, 160),
                mini: true,
                child: Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: const Color.fromARGB(255, 15, 62, 129),
                  size: screenWidth * 0.06,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
