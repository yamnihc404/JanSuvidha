import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/appconfig.dart';
import '../config/auth_service.dart';
import 'otp_verification.dart';

class AdminSignup extends StatefulWidget {
  const AdminSignup({super.key});

  @override
  State<AdminSignup> createState() => _AdminSignupState();
}

class _AdminSignupState extends State<AdminSignup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? selectedDepartment;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailVerified = false;
  bool _isPhoneVerified = false;

  // Error states
  String? fullNameError;
  String? emailError;
  String? contactError;
  String? passwordError;
  String? confirmPasswordError;
  String? departmentError;

  void _showErrorSnackBar(String message) {
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

  // Validation methods
  String? _validateFullName(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        fullNameError = 'Full name is required';
      } else if (value.length < 2) {
        fullNameError = 'Minimum 2 characters';
      } else if (value.length > 50) {
        fullNameError = 'Maximum 50 characters';
      } else {
        fullNameError = null;
      }
    });
    return null;
  }

  String? _validateDepartment(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        departmentError = 'Department is required';
      } else {
        departmentError = null;
      }
    });
    return null;
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

  String? _validateContact(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        contactError = 'Contact number is required';
      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
        contactError = '10 digits required';
      } else {
        contactError = null;
      }
    });
    return null;
  }

  String? _validatePassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        passwordError = 'Password is required';
      } else if (value.length < 8) {
        passwordError = 'Minimum 8 characters';
      } else {
        passwordError = null;
      }
    });
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        confirmPasswordError = 'Confirm password';
      } else if (value != passwordController.text) {
        confirmPasswordError = 'Passwords don\'t match';
      } else {
        confirmPasswordError = null;
      }
    });
    return null;
  }

  bool _isFormValid() {
    _validateFullName(fullNameController.text);
    _validateEmail(emailController.text);
    _validateContact(contactController.text);
    _validatePassword(passwordController.text);
    _validateConfirmPassword(confirmPasswordController.text);
    _validateDepartment(selectedDepartment);

    return fullNameError == null &&
        emailError == null &&
        contactError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        departmentError == null;
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    required String? error,
    required Function(String?) validator,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: screenWidth * 0.045,
                color: const Color.fromARGB(255, 14, 66, 170),
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                icon,
                color: const Color.fromARGB(255, 14, 66, 170),
              ),
              suffixIcon: suffix,
              errorStyle: const TextStyle(height: 0),
            ),
            keyboardType: keyboardType,
            validator: (value) => validator(value),
            onChanged: (value) => validator(value),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: error != null
              ? Padding(
                  key: ValueKey<String?>(error),
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.12,
                    top: screenHeight * 0.005,
                  ),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildDepartmentDropdown() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
          child: DropdownButtonFormField<String>(
            value: selectedDepartment,
            hint: Text(
              'Select Department',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: const Color.fromARGB(255, 14, 66, 170),
              ),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Color.fromARGB(255, 14, 66, 170),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Water Supply',
                child: Text('Water Supply'),
              ),
              DropdownMenuItem(
                value: 'Road Maintenance',
                child: Text('Road Maintenance'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedDepartment = value;
                _validateDepartment(value);
              });
            },
            validator: (value) => _validateDepartment(value),
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.business,
                color: Color.fromARGB(255, 14, 66, 170),
              ),
              errorStyle: TextStyle(height: 0),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: departmentError != null
              ? Padding(
                  key: ValueKey(departmentError),
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.12,
                    top: screenHeight * 0.005,
                  ),
                  child: Text(
                    departmentError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildEmailVerifyButton() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isEmailVerified) {
      return const Text('Verified', style: TextStyle(color: Colors.green));
    } else if (emailError == null) {
      return ElevatedButton(
        onPressed: () async {
          final email = emailController.text.trim();
          if (email.isEmpty) {
            _showErrorSnackBar('Invalid Email');
            return;
          }
          try {
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
              _showErrorSnackBar(error);
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
      return const SizedBox.shrink();
    }
  }

  Widget _buildPhoneVerifyButton() {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isPhoneVerified) {
      return const Text('Verified', style: TextStyle(color: Colors.green));
    } else if (contactError == null) {
      return ElevatedButton(
        onPressed: () async {
          final phone = contactController.text.trim();
          if (phone.isEmpty) {
            _showErrorSnackBar('Invalid Phone Number');
            return;
          }
          try {
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
      return const SizedBox.shrink();
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
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.17),
                      Text(
                        'Admin Registration',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 14, 66, 170),
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      // Full Name
                      _buildInputField(
                        controller: fullNameController,
                        hint: 'Full Name',
                        icon: Icons.person,
                        error: fullNameError,
                        validator: _validateFullName,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Email
                      _buildInputField(
                        controller: emailController,
                        hint: 'Email',
                        icon: Icons.email,
                        error: emailError,
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildEmailVerifyButton(),
                            SizedBox(width: screenWidth * 0.02),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Contact Number
                      _buildInputField(
                        controller: contactController,
                        hint: 'Contact Number',
                        icon: Icons.phone,
                        error: contactError,
                        validator: _validateContact,
                        keyboardType: TextInputType.phone,
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildPhoneVerifyButton(),
                            SizedBox(width: screenWidth * 0.02),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildDepartmentDropdown(),
                      SizedBox(height: screenHeight * 0.02),
                      // Password
                      _buildInputField(
                        controller: passwordController,
                        hint: 'Password',
                        icon: Icons.lock,
                        obscureText: !_isPasswordVisible,
                        error: passwordError,
                        validator: _validatePassword,
                        suffix: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 14, 66, 170),
                          ),
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      // Confirm Password
                      _buildInputField(
                        controller: confirmPasswordController,
                        hint: 'Confirm Password',
                        icon: Icons.lock,
                        obscureText: !_isConfirmPasswordVisible,
                        error: confirmPasswordError,
                        validator: _validateConfirmPassword,
                        suffix: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 14, 66, 170),
                          ),
                          onPressed: () => setState(
                            () => _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      // Submit Button
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
                              try {
                                final authservice = AuthService();
                                await authservice.signUp(
                                    fullName: fullNameController.text.trim(),
                                    password: passwordController.text.trim(),
                                    email: emailController.text.trim(),
                                    contactNumber:
                                        contactController.text.trim(),
                                    department: selectedDepartment!,
                                    context: context,
                                    isAdmin: true);
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
                            'Register',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              color: const Color.fromARGB(255, 14, 66, 170),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 15, 62, 129),
          borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
        ),
      ),
    );
  }
}
