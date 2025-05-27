import 'package:flutter/material.dart';
import 'token_refresh_wrapper.dart';
import 'common_landing.dart';
import './user_pages/dashboard.dart';
import './admin_pages/admin_dashboard.dart';
import './user_pages/landing.dart';
import './admin_pages/adminlanding.dart';
import './admin_pages/admininquiry.dart';
import './user_pages/login.dart';
import './admin_pages/adminlogin.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JanSuvidha',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TokenRefreshWrapper(child: SizedBox()),
      routes: {
        '/common-landing': (context) => const CommonLandingPage(),
        '/user-landing': (context) => const Landing(),
        '/admin-landing': (context) => const LandingScreen(),
        '/user-dashboard': (context) => const UserDashboard(),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/inquiries': (context) => const InquiryPage(),
        '/user-login': (context) => const UserLogin(),
        '/admin-login': (context) => const AdminLogin()
      },
    );
  }
}
