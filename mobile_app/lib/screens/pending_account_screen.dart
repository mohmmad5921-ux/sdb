import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'dart:async';

class PendingAccountScreen extends StatefulWidget {
  const PendingAccountScreen({super.key});
  @override
  State<PendingAccountScreen> createState() => _PendingAccountScreenState();
}

class _PendingAccountScreenState extends State<PendingAccountScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _fadeCtrl;
  Timer? _checkTimer;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    _loadProfile();
    // Check status every 30 seconds
    _checkTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkStatus());
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    _checkTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final res = await ApiService.getProfile();
    if (res['success'] == true) {
      final user = res['data']?['user'] ?? res['data'];
      setState(() => _userName = user?['full_name'] ?? '');
    }
  }

  Future<void> _checkStatus() async {
    final res = await ApiService.getProfile();
    if (res['success'] == true) {
      final user = res['data']?['user'] ?? res['data'];
      if (user?['status'] == 'active' && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Animated hourglass
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [AppTheme.primary.withValues(alpha: 0.15), AppTheme.primary.withValues(alpha: 0.05)],
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: const Center(child: Text('⏳', style: TextStyle(fontSize: 36))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome text
                if (_userName.isNotEmpty) ...[
                  Text('مرحباً، $_userName 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                  const SizedBox(height: 12),
                ],

                const Text('حسابك قيد المراجعة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                Text(
                  'يتم مراجعة حسابك من قبل فريقنا.\nسيتم إشعارك فور تفعيل حسابك.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.7),
                ),
                const SizedBox(height: 36),

                // Status steps
                _statusStep('✅', 'تم إنشاء الحساب', true),
                _statusStep('✅', 'تم التحقق من رقم الهاتف', true),
                _statusStep('⏳', 'مراجعة الحساب من الإدارة', false),
                _statusStep('🔒', 'تفعيل الحساب', false),

                const SizedBox(height: 36),

                // Support chat button
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/support-chat'),
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text('تواصل مع الدعم', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),

                const Spacer(flex: 3),

                // Logout
                TextButton(
                  onPressed: _logout,
                  child: const Text('تسجيل الخروج', style: TextStyle(color: AppTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusStep(String icon, String label, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600,
          color: done ? AppTheme.textPrimary : AppTheme.textMuted,
        ))),
        if (!done && icon == '⏳')
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary.withValues(alpha: 0.5))),
      ]),
    );
  }
}
