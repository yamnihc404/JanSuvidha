import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'otp_verification.dart';
import '../config/auth_service.dart';
import '../config/appconfig.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;
  // Error message storage variables
  String? usernameError;
  String? emailError;
  String? contactError;
  String? passwordError;
  String? confirmPasswordError;

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating, // Makes it float above content
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 100, // Positions near top
        left: 20,
        right: 20,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10), // Rounded bottom corners
        ),
      ),
    ));
  }

  String? _validateContactNumber(String? value) {
    if (value == null || value.isEmpty) return 'Contact number is required';
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Invalid contact number (10 digits required)';
    }
    return null;
  }

  // Custom validator functions that update error state variables
  String? _validateUsername(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        usernameError = 'Username is required';
      } else if (value.length < 2) {
        usernameError = 'At least 2 characters needed';
      } else if (value.length > 10) {
        usernameError = 'Username too long';
      } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
        usernameError = 'Only letters allowed';
      } else {
        usernameError = null;
      }
    });
    return null; // Always return null so the form doesn't show built-in errors
  }

  String? _validateEmail(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        emailError = 'Invalid email format';
      } else {
        emailError = null;
      }
    });
    return null;
  }

  String? _validateContactWithState(String? value) {
    setState(() {
      contactError = _validateContactNumber(value);
    });
    return null;
  }

  String? _validatePassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        passwordError = 'Password is required';
      } else if (value.length < 8) {
        passwordError = 'At least 8 characters required';
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        passwordError = 'At least one uppercase letter';
      } else if (!RegExp(r'[!@#$%^&*(){}+-.<>]').hasMatch(value)) {
        passwordError = 'At least one special character';
      } else {
        passwordError = null;
      }
    });
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        confirmPasswordError = 'Please confirm password';
      } else if (value != passwordController.text) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
    });
    return null;
  }

  // Method to check if form is valid
  bool _isFormValid() {
    _validateUsername(usernameController.text);
    _validateEmail(emailController.text);
    _validateContactWithState(contactNumberController.text);
    _validatePassword(passwordController.text);
    _validateConfirmPassword(confirmPasswordController.text);

    return usernameError == null &&
        emailError == null &&
        contactError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  Widget _buildEmailVerifyButton() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isEmailVerified) {
      return const Text('Verified', style: TextStyle(color: Colors.green));
    } else if (emailError == null) {
      return ElevatedButton(
        onPressed: () async {
          final email = emailController.text.trim();
          if (email == "") {
            _showErrorSnackBar('Invalid Email');
            return;
          }
          try {
            // Call backend to send OTP
            final response = await http.post(
              Uri.parse('${AppConfig.apiBaseUrl}/user/verify/email-otp'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'email': email}),
            );

            if (response.statusCode == 200) {
              bool verified = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerification(
                    verificationType: 'email',
                    contactInfo: email,
                  ),
                ),
              );
              if (verified) setState(() => _isEmailVerified = true);
            } else {
              final error =
                  jsonDecode(response.body)['message'] ?? 'Failed to send OTP';
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error)),
              );
            }
          } catch (e) {
            _showErrorSnackBar('Verify Email');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 14, 66, 170),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.026, vertical: screenWidth * 0.016),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Verify',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.032,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink(); // Hide button when input is invalid
    }
  }

  Widget _buildPhoneVerifyButton() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isPhoneVerified) {
      return const Text('Verified', style: TextStyle(color: Colors.green));
    } else if (contactError == null) {
      return ElevatedButton(
        onPressed: () async {
          final phone = contactNumberController.text.trim();
          if (phone == "") {
            _showErrorSnackBar('Invalid Phone Number');
            return;
          }
          try {
            // Call backend to send OTP
            final response = await http.post(
              Uri.parse('${AppConfig.apiBaseUrl}/user/verify/phone-otp'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'phone': phone}),
            );

            if (response.statusCode == 200) {
              bool verified = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpVerification(
                    verificationType: 'phone',
                    contactInfo: phone,
                  ),
                ),
              );
              if (verified) setState(() => _isPhoneVerified = true);
            } else {
              final error =
                  jsonDecode(response.body)['message'] ?? 'Failed to send OTP';
              _showErrorSnackBar(error);
            }
          } catch (e) {
            _showErrorSnackBar('Error: ${e.toString()}');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 14, 66, 170),
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.026, vertical: screenWidth * 0.016),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Verify',
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.032,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink(); // Hide button when input is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(children: [
                  SizedBox(height: screenHeight * 0.19),
                  Center(
                    child: Column(children: [
                      Text(
                        'Create Account',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 14, 66, 170),
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      // Username field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04),
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 230, 160),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(5, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                hintText: "Full Name",
                                hintStyle: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color:
                                        const Color.fromARGB(255, 14, 66, 170)),
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Color.fromARGB(255, 14, 66, 170),
                                ),
                                errorStyle: const TextStyle(height: 0),
                              ),
                              validator: _validateUsername,
                              onChanged: _validateUsername,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: usernameError != null
                                ? Padding(
                                    key: ValueKey<String?>(usernameError),
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.12,
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      usernameError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Email field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04),
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 230, 160),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(5, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          color: const Color.fromARGB(
                                              255, 14, 66, 170)),
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Color.fromARGB(255, 14, 66, 170),
                                      ),
                                      errorStyle: const TextStyle(height: 0),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    onChanged: _validateEmail,
                                  ),
                                ),
                                _buildEmailVerifyButton(),
                                SizedBox(width: screenWidth * 0.02),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: emailError != null
                                ? Padding(
                                    key: ValueKey<String?>(emailError),
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.12,
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      emailError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Contact field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04),
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 230, 160),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(5, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: contactNumberController,
                                    decoration: InputDecoration(
                                      hintText: "Contact Number",
                                      hintStyle: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          color: const Color.fromARGB(
                                              255, 14, 66, 170)),
                                      border: InputBorder.none,
                                      prefixIcon: const Icon(
                                        Icons.call,
                                        color: Color.fromARGB(255, 14, 66, 170),
                                      ),
                                      errorStyle: const TextStyle(height: 0),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: _validateContactWithState,
                                    onChanged: _validateContactWithState,
                                  ),
                                ),
                                _buildPhoneVerifyButton(),
                                SizedBox(width: screenWidth * 0.03),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: contactError != null
                                ? Padding(
                                    key: ValueKey<String?>(contactError),
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.12,
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      contactError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Password field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04),
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 230, 160),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(5, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !_isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color:
                                        const Color.fromARGB(255, 14, 66, 170)),
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 14, 66, 170),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color:
                                        const Color.fromARGB(255, 14, 66, 170),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                errorStyle: const TextStyle(height: 0),
                              ),
                              validator: _validatePassword,
                              onChanged: (value) {
                                _validatePassword(value);
                                // Also validate confirm password when password changes
                                if (confirmPasswordController.text.isNotEmpty) {
                                  _validateConfirmPassword(
                                      confirmPasswordController.text);
                                }
                              },
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: passwordError != null
                                ? Padding(
                                    key: ValueKey<String?>(passwordError),
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.12,
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      passwordError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Confirm Password field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04),
                            width: screenWidth * 0.8,
                            height: screenHeight * 0.06,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 230, 160),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(5, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: confirmPasswordController,
                              obscureText: !_isConfirmPasswordVisible,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color:
                                        const Color.fromARGB(255, 14, 66, 170)),
                                border: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 14, 66, 170),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color:
                                        const Color.fromARGB(255, 14, 66, 170),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                                errorStyle: const TextStyle(height: 0),
                              ),
                              validator: _validateConfirmPassword,
                              onChanged: _validateConfirmPassword,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -0.1),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                ),
                              );
                            },
                            child: confirmPasswordError != null
                                ? Padding(
                                    key:
                                        ValueKey<String?>(confirmPasswordError),
                                    padding: EdgeInsets.only(
                                        left: screenWidth * 0.12,
                                        top: screenHeight * 0.005),
                                    child: Text(
                                      confirmPasswordError!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 230, 160),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(5, 5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_isFormValid()) {
                              if (!_isEmailVerified || !_isPhoneVerified) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Verify email and phone first'),
                                ));
                                return;
                              }
                              try {
                                final authservice = AuthService();
                                await authservice.signUp(
                                    fullName: usernameController.text.trim(),
                                    password: passwordController.text.trim(),
                                    email: emailController.text.trim(),
                                    contactNumber:
                                        contactNumberController.text.trim(),
                                    context: context,
                                    isAdmin: false);
                              } catch (e) {
                                _showErrorSnackBar(e.toString());
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                color: const Color.fromARGB(255, 14, 66, 170),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                    ]),
                  ),
                ]),
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
        ],
      ),
    );
  }
}
