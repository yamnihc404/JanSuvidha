import 'package:flutter/material.dart';
import 'Admin_Dashboard.dart';
import 'inquiry.dart'; 
import 'landing.dart'; // Update this import
import 'Login.dart';
import 'Signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/admin': (context) => const AdminDashboard(),
        '/inquiries': (context) => const InquiryPage(),
      },
    );
  }
}