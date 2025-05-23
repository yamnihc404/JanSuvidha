import 'package:flutter/material.dart';
import 'widgets/common_widgets.dart';
import 'landing.dart';
import 'login.dart'; // Add these new imports
import 'signup.dart'; // Add these new imports
import 'dashboard.dart';
import 'config/auth_service.dart';
import 'widgets/token_refresh_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TokenRefreshWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const Splashscreen(),
          '/': (context) => const Landing(),
          '/login': (context) => const Login(),
          '/signup': (context) => const Signup(),
          '/dashboard': (context) => const Dashboard(),
        },
      ),
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      await _authService.refreshTokenIfNeeded(context);
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
