import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'reset_password.dart';
import 'widgets/common_widgets.dart';
import 'landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Required for Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(), // Start with SplashScreen
    );
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    _handleDynamicLink(); // Check for oobCode from Firebase
    _navigateToLandingPage(); // Splash delay
  }

  void _navigateToLandingPage() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Landing(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  void _handleDynamicLink() async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = initialLink?.link;

    if (deepLink != null && deepLink.queryParameters.containsKey('oobCode')) {
      final String? oobCode = deepLink.queryParameters['oobCode'];
      if (oobCode != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResetPassword(oobCode: oobCode)),
        );
      }
    }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri link = dynamicLinkData.link;
      final String? oobCode = link.queryParameters['oobCode'];
      if (oobCode != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResetPassword(oobCode: oobCode)),
        );
      }
    }).onError((error) {
      debugPrint('Dynamic link error: $error');
    });
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
                Transform.scale(scale: 1.4, child: Image.asset('images/Logo.png')),
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
