import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reset_password_link_sent.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
  setState(() {
    isLoading = true;
  });

  try {
    await _auth.sendPasswordResetEmail(email: email);
    print('Password reset email sent to $email'); // ✅ Debug print

    if (mounted) {
      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordLinkSent(email: email),
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    print('Error sending reset email: ${e.code} - ${e.message}'); // ✅ Debug print

    setState(() {
      isLoading = false;
    });

    String errorMessage = 'An error occurred. Please try again.';
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found with this email address.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'Please enter a valid email address.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
    );
  } catch (e) {
    print('Unknown error: $e'); // ✅ Debug print

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  // Email validation function
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background gradient
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
                      scale: 1.5,
                      child: Image.asset(
                        'images/Logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Forgot Password',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 66, 170),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Enter your email address. We will send you a link to reset your password.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 14, 66, 170),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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
                        const SizedBox(height: 35),
                        Container(
                          width: 200,
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
                            onPressed: isLoading 
                                ? null 
                                : () {
                                    final email = emailController.text.trim();
                                    if (email.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please enter your email'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else if (!isValidEmail(email)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Please enter a valid email address'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    } else {
                                      sendPasswordResetEmail(email);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 230, 160),
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
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 14, 66, 170),
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
                  Navigator.pop(context);
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