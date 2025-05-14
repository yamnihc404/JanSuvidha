import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/auth_service.dart';

class TokenRefreshWrapper extends StatefulWidget {
  final Widget child;

  const TokenRefreshWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _TokenRefreshWrapperState createState() => _TokenRefreshWrapperState();
}

class _TokenRefreshWrapperState extends State<TokenRefreshWrapper>
    with WidgetsBindingObserver {
  final AuthService _authService = AuthService();
  DateTime? _lastRefreshAttempt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      _checkAndRefreshToken();
    }
  }

  Future<void> _checkAndRefreshToken() async {
    final now = DateTime.now();
    // Only attempt refresh if it's been at least 1 minute since the last attempt
    if (_lastRefreshAttempt == null ||
        now.difference(_lastRefreshAttempt!).inMinutes >= 1) {
      _lastRefreshAttempt = now;

      bool isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        // Silently refresh token if needed
        await _authService.refreshTokenIfNeeded(context);
      } else {
        // Token is invalid or expired, redirect to login
        _handleExpiredToken();
      }
    }
  }

  void _handleExpiredToken() {
    final navigator = Navigator.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Only navigate to landing if not already there
    if (currentRoute != '/' &&
        currentRoute != '/login' &&
        currentRoute != '/signup') {
      // Show message about session expiration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your session has expired. Please login again.'),
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to landing page
      navigator.pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
