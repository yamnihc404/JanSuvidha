import 'package:flutter/material.dart';
import 'inquiry.dart';
import 'filecomplain.dart';
import 'landing.dart';
import 'login.dart';
import 'signup.dart';
import 'myacount.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(), // Start with SplashScreen
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 2 seconds before navigating to the next page
    _navigateToLandingPage();
  }

  void _navigateToLandingPage() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate a 3-second splash
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Landing(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade animation
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration:
              const Duration(milliseconds: 800), // Animation duration
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
            Center(
              child: Stack(
                alignment: Alignment.center, // Align children to center
                children: [
                  Transform.scale(
                    scale: 1.4, // Scale the widget by 130%
                    child: Image.asset(
                      'images/Logo.png', // Path to your logo image
                      // Adjust size as needed
                    ),
                  ),
                  // Add your text on top of the image
                  const Positioned(
                    top: 0,
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        color: Color.fromARGB(
                            255, 242, 132, 7), // Change text color as needed
                        fontSize: 24, // Adjust font size
                        fontWeight: FontWeight.bold, // Optional: make text bold
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
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(
                      255, 15, 62, 129), // Background color of the rectangle
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(13), // Circular radius for top corners
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
