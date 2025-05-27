import 'package:flutter/material.dart';
import 'dart:async';
import './config/auth_service.dart';

class TokenRefreshWrapper extends StatefulWidget {
  final Widget child;
  const TokenRefreshWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<TokenRefreshWrapper> createState() => _TokenRefreshWrapperState();
}

class _TokenRefreshWrapperState extends State<TokenRefreshWrapper> {
  final AuthService _authService = AuthService();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _handleStartupNavigation();
    _startPeriodicRefresh();
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

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(minutes: 50), (timer) async {
      final success = await _authService.refreshToken(context);
      if (!success && mounted) {
        Navigator.pushReplacementNamed(context, '/common-landing');
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
