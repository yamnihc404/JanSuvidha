import 'package:flutter/material.dart';
import '../config/auth_service.dart';
import 'forgot_password.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool isLoading = false;
  String? emailError;
  String? passwordError;

  void _validateEmail(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        emailError = 'Invalid email format';
      } else {
        emailError = null;
      }
    });
  }

  void _validatePassword(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        passwordError = 'Password is required';
      } else if (value.length < 6) {
        passwordError = 'Minimum 6 characters required';
      } else {
        passwordError = null;
      }
    });
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
                  SizedBox(height: screenHeight * 0.1),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.scale(
                      scale: 1.8,
                      child: Image.asset(
                        'images/Logo.png',
                        width: screenWidth * 0.6,
                        height: screenHeight * 0.25,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Log in',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 14, 66, 170),
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Email Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                              ),
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
                              child: TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color: const Color.fromARGB(
                                      255,
                                      14,
                                      66,
                                      170,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Color.fromARGB(255, 14, 66, 170),
                                  ),
                                ),
                                onChanged: _validateEmail,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
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
                                        top: screenHeight * 0.005,
                                      ),
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
                        SizedBox(height: screenHeight * 0.02),
                        // Password Field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.04,
                              ),
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
                              child: TextField(
                                controller: passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  hintStyle: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color: const Color.fromARGB(
                                      255,
                                      14,
                                      66,
                                      170,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 14, 66, 170),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color.fromARGB(
                                        255,
                                        14,
                                        66,
                                        170,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: _validatePassword,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (
                                Widget child,
                                Animation<double> animation,
                              ) {
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
                                        top: screenHeight * 0.005,
                                      ),
                                      child: Text(
                                        passwordError!,
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
                        SizedBox(height: screenHeight * 0.02),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.1),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 14, 66, 170),
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Login Button
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
                            onPressed: () {
                              _validateEmail(emailController.text);
                              _validatePassword(passwordController.text);
                              if (emailError == null && passwordError == null) {
                                setState(() => isLoading = true);
                                final authservice = AuthService();
                                authservice
                                    .signIn(
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        context: context,
                                        isAdmin: true)
                                    .then(
                                      (_) => setState(() => isLoading = false),
                                    );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: isLoading
                                ? SizedBox(
                                    width: screenWidth * 0.06,
                                    height: screenWidth * 0.06,
                                    child: const CircularProgressIndicator(
                                      color: Color.fromARGB(
                                        255,
                                        14,
                                        66,
                                        170,
                                      ),
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.06,
                                      color: const Color.fromARGB(
                                        255,
                                        14,
                                        66,
                                        170,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.1),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
