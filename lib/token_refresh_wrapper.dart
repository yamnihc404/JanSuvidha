import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/auth_service.dart';

class TokenRefreshWrapper extends StatefulWidget {
  final Widget child;
  const TokenRefreshWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<TokenRefreshWrapper> createState() => _TokenRefreshWrapperState();
}

class _TokenRefreshWrapperState extends State<TokenRefreshWrapper> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _handleStartupNavigation();
  }

  Future<void> _handleStartupNavigation() async {
    final token = await _authService.getAccessToken();
    final role = await _authService.getRole();

    if (token == null || role == null) {
      Navigator.pushReplacementNamed(context, '/common-landing');
    } else if (role == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/user-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
