import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'landing.dart';
import 'dashboard.dart';
import 'config/auth_service.dart';
import 'widgets/token_refresh_wrapper.dart'; // Import the wrapper

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TokenRefreshWrapper(
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(), // Start with SplashScreen
      ),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Splashscreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Check authentication status and navigate accordingly
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Wait for 2 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is already logged in with a valid token
    bool isLoggedIn = await _authService.isLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        // If token is about to expire, refresh it silently
        await _authService.refreshTokenIfNeeded(context);

        // User is logged in with valid token, navigate directly to dashboard
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Dashboard(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else {
        // User is not logged in or token expired, navigate to landing page
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Landing(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
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
