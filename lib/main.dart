import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'widgets/common_widgets.dart';
import 'landing.dart';
import 'dashboard.dart';
import 'config/auth_service.dart';
import 'widgets/token_refresh_wrapper.dart';
import 'reset_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // initialize Firebase for dynamic links
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TokenRefreshWrapper(
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(), // Start with our merged Splashscreen
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
    _handleDynamicLink();      // set up the "forget password" dynamic link handler
    _checkAuthAndNavigate();   // splash delay + auth/token refresh + navigation
  }

  Future<void> _handleDynamicLink() async {
    // Check initial link if app was launched via dynamic link
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = initialLink?.link;

    if (deepLink != null && deepLink.queryParameters.containsKey('oobCode')) {
      final String? oobCode = deepLink.queryParameters['oobCode'];
      if (oobCode != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPassword(oobCode: oobCode),
          ),
        );
        return;
      }
    }

    // Listen for incoming dynamic links while the app is running
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri link = dynamicLinkData.link;
      final String? oobCode = link.queryParameters['oobCode'];
      if (oobCode != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPassword(oobCode: oobCode),
          ),
        );
      }
    }).onError((error) {
      debugPrint('Dynamic link error: $error');
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    bool isLoggedIn = await _authService.isLoggedIn();
    if (isLoggedIn) {
      // refresh token if needed
      await _authService.refreshTokenIfNeeded(context);

      // go to dashboard
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Dashboard(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      // not logged in -> landing page
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Landing(),
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
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
