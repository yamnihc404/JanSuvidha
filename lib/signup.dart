import 'package:flutter/material.dart';
import 'package:jansuvidha/login.dart';
import 'package:jansuvidha/landing.dart';
import 'otp_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'config/auth_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _showTemporaryUnavailableMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Temporarily not available'),
        backgroundColor: Color.fromARGB(255, 14, 66, 170),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background container with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(
                      255, 255, 196, 107), // Starting color of the gradient
                  Colors.white,
                  Color.fromARGB(
                      255, 143, 255, 147), // Ending color of the gradient
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
            child: Column(children: [
              Align(
                alignment: Alignment.topCenter, // Align at the top center
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 60), // Push down by 50 pixels
                  child: Transform.scale(
                    scale: 3, // Scale the widget by 140%
                    child: Image.asset('images/Logo.png', height: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(children: [
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 14, 66, 170), // Change text color as needed
                      fontSize: 24, // Adjust font size
                      fontWeight: FontWeight.bold, // Optional: make text bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 300,
                    height: 42,
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
                      controller: usernameController,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66, 170)),
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 14, 66, 170),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 300,
                    height: 42,
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
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 14, 66, 170)),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtpVerification(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 14, 66, 170),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 300,
                    height: 42,
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
                          child: TextField(
                            controller: contactNumberController,
                            decoration: const InputDecoration(
                              hintText: "Contact Number",
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 14, 66, 170)),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.call,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OtpVerification(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 14, 66, 170),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 300,
                    height: 42,
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
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66, 170)),
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
                            color: const Color.fromARGB(255, 14, 66, 170),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: 300,
                    height: 42,
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
                      controller: confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 14, 66, 170)),
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
                            color: const Color.fromARGB(255, 14, 66, 170),
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Sign up button
                  Container(
                    width: 149,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 255, 230, 160), // Updated color
                      borderRadius: BorderRadius.circular(15), // Rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.3), // Shadow color with opacity
                          offset: const Offset(5,
                              5), // Shadow offset (light coming from top left)
                          blurRadius: 10, // Blur radius of the shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final authservice = AuthService();
                        authservice.signUpUser(
                          username: usernameController.text.trim(),
                          password: passwordController.text.trim(),
                          email: emailController.text.trim(),
                          contactNumber: contactNumberController.text.trim(),
                          context: context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .transparent, // Make the ElevatedButton background transparent
                        shadowColor:
                            Colors.transparent, // Remove default shadow
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 14, 66, 170),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // SSO Options Section
                  const SizedBox(height: 20),
                  const Text(
                    'Or sign up with',
                    style: TextStyle(
                      color: Color.fromARGB(255, 14, 66, 170),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Google Login Button
                  Container(
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _showTemporaryUnavailableMessage,
                      icon: Image.asset(
                        'images/google_logo.png', // Make sure to add this asset
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.g_mobiledata,
                                color: Colors.red, size: 24),
                      ),
                      label: const Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  // DigiLocker Login Button
                  const SizedBox(height: 15),
                  Container(
                    width: 300,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 61, 90, 254),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _showTemporaryUnavailableMessage,
                      icon: Image.asset(
                        'images/digilocker_logo.png', // Make sure to add this asset
                        height: 24,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.folder_shared,
                                color: Colors.white, size: 24),
                      ),
                      label: const Text(
                        'Continue with DigiLocker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          )),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 15, 62, 129),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: 50,
              height: 60,
              child: FloatingActionButton(
                onPressed: () async {
                  Navigator.pop(
                    context,
                  );
                },
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 254, 183, 101),
                mini: true,
                child: const Icon(Icons.arrow_back_ios_new_sharp,
                    color: Color.fromARGB(255, 15, 62, 129), size: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
