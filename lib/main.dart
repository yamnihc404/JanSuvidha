import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'inquiry.dart';
import 'filecomplain.dart';
import 'landing.dart';
import 'login.dart';
import 'signup.dart';
import 'myacount.dart';

void main() {
  runApp(const Myacc());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splashscreen(), // Start with SplashScreen
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
            const GradientBackground(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: 1.4,
                    child: Image.asset('images/Logo.png'),
                  ),
                  const Positioned(
                    top: 0,
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        color: Color.fromARGB(255, 242, 132, 7),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomRoundedBar(),
            ),
          ],
        ),
      ),
    );
  }
}
