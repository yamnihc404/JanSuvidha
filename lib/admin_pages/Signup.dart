import 'package:flutter/material.dart';

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
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController lgdCodeController = TextEditingController();

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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Transform.scale(
                        scale: 3,
                        child: Image.asset('images/Logo.png', height: 100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            color: Color.fromARGB(255, 14, 66, 170),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildInputField(controller: usernameController, hint: "Gram Panchayat Name", icon: Icons.person),
                        _buildVerifyField(
                          controller: emailController,
                          hint: "Email",
                          icon: Icons.email,
                          onVerify: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Placeholder())),
                        ),
                        _buildVerifyField(
                          controller: contactNumberController,
                          hint: "Contact Number",
                          icon: Icons.call,
                          onVerify: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Placeholder())),
                        ),
                        _buildInputField(controller: lgdCodeController, hint: "LGD Code", icon: Icons.code),
                        _buildInputField(controller: lgdCodeController, hint: "PIN Code", icon: Icons.code),
                        _buildPasswordField(
                          controller: passwordController,
                          hint: "Password",
                          isVisible: _isPasswordVisible,
                          onToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        ),
                        _buildPasswordField(
                          controller: confirmPasswordController,
                          hint: "Confirm Password",
                          isVisible: _isConfirmPasswordVisible,
                          onToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                        ),
                        const SizedBox(height: 15),
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
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
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
                        _buildSSOButtons(),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
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
                onPressed: () => Navigator.pop(context),
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

  Widget _buildInputField({required TextEditingController controller, required String hint, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 300,
      height: 42,
      margin: const EdgeInsets.only(bottom: 15),
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
          hintStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 14, 66, 170)),
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 14, 66, 170)),
        ),
      ),
    );
  }

  Widget _buildVerifyField({required TextEditingController controller, required String hint, required IconData icon, required VoidCallback onVerify}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 300,
      height: 42,
      margin: const EdgeInsets.only(bottom: 15),
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
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 14, 66, 170)),
                border: InputBorder.none,
                prefixIcon: Icon(icon, color: const Color.fromARGB(255, 14, 66, 170)),
              ),
            ),
          ),
          SizedBox(
            height: 28,
            child: ElevatedButton(
              onPressed: onVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 14, 66, 170),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller, required String hint, required bool isVisible, required VoidCallback onToggle}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: 300,
      height: 42,
      margin: const EdgeInsets.only(bottom: 15),
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
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 14, 66, 170)),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 14, 66, 170)),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, 
                color: const Color.fromARGB(255, 14, 66, 170)),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }

  Widget _buildSSOButtons() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Or sign up with', style: TextStyle(color: Color.fromARGB(255, 14, 66, 170), fontSize: 16)),
        const SizedBox(height: 15),
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
            icon: Image.asset('images/google_logo.png', height: 24,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.g_mobiledata, color: Colors.red, size: 24)),
            label: const Text('Continue with Google', 
                style: TextStyle(color: Colors.black87, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
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
            icon: Image.asset('images/digilocker_logo.png', height: 24,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.folder_shared, color: Colors.white, size: 24)),
            label: const Text('Continue with DigiLocker', 
                style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ],
    );
  }
}