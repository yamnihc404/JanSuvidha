import 'package:flutter/material.dart';
import 'Login.dart';
import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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
                  // Logo
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Transform.scale(
                        scale: 3,
                        child: Image.asset('images/Logo.png', height: 100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login Form (centered)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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

                          // Email Field
                          _buildInputField(
                            controller: _emailController,
                            hint: "Enter Email",
                            icon: Icons.email,
                          ),

                          const SizedBox(height: 20),

                          // Password Field
                          _buildPasswordField(),

                          const SizedBox(height: 10),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: TextButton(
                                onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ForgotPassword()),
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

                          // Login Button - Centered
                          Center(
                            child: _buildLoginButton(),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
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

          // Back Button
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: 50,
              height: 60,
              child: FloatingActionButton(
                onPressed: () => Navigator.pop(context),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 14, 66, 170),
          ),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 14, 66, 170)),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
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
        controller: _passwordController,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          hintText: "Enter Password",
          hintStyle: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 14, 66, 170),
          ),
          border: InputBorder.none,
          prefixIcon:
              const Icon(Icons.lock, color: Color.fromARGB(255, 14, 66, 170)),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color.fromARGB(255, 14, 66, 170)),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
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
          Navigator.pushNamed(context, '/admin');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 14, 66, 170),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
