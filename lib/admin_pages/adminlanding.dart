import 'package:flutter/material.dart';
import 'admin_widgets/common_widgets.dart';
import 'adminlogin.dart';
import 'signup.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: screenWidth * 1,
              height: screenHeight * .5,
              margin: EdgeInsets.only(top: screenHeight * 0.05),
              child: Image.asset('images/Logo.png', fit: BoxFit.contain),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.25,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Column(
              children: [
                StyledContainer(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.47,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminLogin()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        color: const Color.fromARGB(255, 14, 66, 170),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                StyledContainer(
                  height: screenHeight * 0.12,
                  width: screenWidth * 0.47,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminSignup()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Text(
                      'Sign Up',
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 15, 62, 129),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
