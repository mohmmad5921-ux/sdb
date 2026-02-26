import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _fade = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOut)));
    _scale = Tween(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOutBack)));
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final loggedIn = await ApiService.isLoggedIn();
    Navigator.pushReplacementNamed(context, loggedIn ? '/home' : '/login');
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.bgDark, Color(0xFF0A1628), AppTheme.bgDark]),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => Opacity(
              opacity: _fade.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                      boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 10))],
                    ),
                    child: const Center(child: Text('SDB', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2))),
                  ),
                  const SizedBox(height: 20),
                  Text('ShambaDigital Bank', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9))),
                  const SizedBox(height: 6),
                  Text('مصرفك الرقمي الذكي', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4))),
                  const SizedBox(height: 40),
                  SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary.withValues(alpha: 0.5))),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
