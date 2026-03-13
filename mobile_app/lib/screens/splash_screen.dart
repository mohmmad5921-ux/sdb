import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/push_notification_service.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    // Check if onboarding completed
    final onboarded = prefs.getBool('onboarding_completed') ?? false;
    if (!onboarded) {
      if (mounted) Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }

    final hasToken = await ApiService.isLoggedIn();
    if (hasToken) {
      // Verify token is still valid on server
      final profile = await ApiService.getProfile();
      if (profile['success'] == true) {
        final user = profile['data']?['user'] ?? profile['data'];
        final status = user?['status'] ?? 'active';
        PushNotificationService.initialize();
        if (mounted) {
          if (status == 'pending') {
            Navigator.pushReplacementNamed(context, '/pending');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        // Token invalid (account deleted/expired) — clear and go to login
        await ApiService.logout();
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppTheme.bgLight,
        body: Center(
          child: FadeTransition(
            opacity: _fade,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset('assets/images/sdb-logo.png', width: 260, fit: BoxFit.contain),
              const SizedBox(height: 6),
              const Text('Syrian Digital Bank', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              const SizedBox(height: 40),
              SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary.withValues(alpha: 0.5))),
            ]),
          ),
        ),
      ),
    );
  }
}
