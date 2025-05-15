import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jansuvidha/dashboard.dart';
import 'forgot_password.dart';
import 'config/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Adding resizeToAvoidBottomInset to handle keyboard appearance
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background container with gradient
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: Transform.scale(
                      scale: 1.8,
                      child: Image.asset(
                        'images/Logo.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Log in',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 66, 170),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 27),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: 284,
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
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color.fromARGB(255, 14, 66, 170),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: 284,
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
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              hintStyle: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 14, 66, 170),
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
                                  color: const Color.fromARGB(255, 14, 66, 170),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Forgot Password Text Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
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
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 14, 66, 170),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                            width: 149,
                            height: 55,
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
                                final _authservice = AuthService();
                                _authservice.signInUser(
                                  username: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  context: context,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 230, 160),
                                shadowColor: Colors.transparent,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Color.fromARGB(255, 14, 66, 170),
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Color.fromARGB(255, 14, 66, 170),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            )),
                        // Add extra padding at the bottom to ensure everything is visible
                        const SizedBox(height: 100),
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
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                shape: const CircleBorder(),
                backgroundColor: const Color.fromARGB(255, 255, 230, 160),
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
