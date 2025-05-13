import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'widgets/common_widgets.dart';
import 'login.dart';
import 'signup.dart';
import 'dashboard.dart';
import 'config/auth_service.dart';

void main() {
  runApp(const Landing());
}

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/home': (context) => const Dashboard()
      },
      navigatorKey: GlobalKey<NavigatorState>(),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Check if user is already authenticated when landing screen loads
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    // This is a backup check in case direct navigation from splash screen fails
    bool isLoggedIn = await _authService.isLoggedIn();

    if (isLoggedIn && mounted) {
      // Navigate to dashboard if user is already logged in
      Navigator.of(context).pushReplacementNamed('/home');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          Align(
            alignment: Alignment.topCenter,
            child: Transform.scale(
              scale: 1.2,
              child: Image.asset('images/Logo.png'),
            ),
          ),
          Positioned(
            bottom: 180,
            left: 50,
            right: 50,
            child: Column(
              children: [
                StyledContainer(
                  height: 100,
                  width: 149,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                StyledContainer(
                  height: 100,
                  width: 149,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 14, 66, 170),
                      ),
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
