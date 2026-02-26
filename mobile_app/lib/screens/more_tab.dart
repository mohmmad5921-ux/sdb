import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('الإعدادات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 24),

        // Profile Card (stays dark for contrast)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E293B), Color(0xFF334155)]),
            boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withValues(alpha: 0.15), blurRadius: 15, offset: const Offset(0, 6))],
          ),
          child: Row(children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)])),
              child: const Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 26)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('الملف الشخصي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 3),
              Text('إدارة معلوماتك وإعداداتك', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.45))),
            ])),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withValues(alpha: 0.4)),
            ),
          ]),
        ),
        const SizedBox(height: 28),

        _section('الخدمات'),
        _menuGroup([
          _item(Icons.analytics_rounded, 'التحليلات المالية', const Color(0xFF6366F1), () {}),
          _item(Icons.people_rounded, 'المستفيدون', const Color(0xFF3B82F6), () {}),
          _item(Icons.verified_user_rounded, 'تحقق الهوية KYC', AppTheme.success, () {}),
          _item(Icons.card_giftcard_rounded, 'إحالة صديق', const Color(0xFFEC4899), () {}),
        ]),
        const SizedBox(height: 20),

        _section('الحساب والأمان'),
        _menuGroup([
          _item(Icons.notifications_rounded, 'الإشعارات', const Color(0xFFF59E0B), () {}),
          _item(Icons.lock_rounded, 'الأمان والخصوصية', const Color(0xFF10B981), () {}),
          _item(Icons.fingerprint_rounded, 'البصمة / Face ID', const Color(0xFF8B5CF6), () {}),
          _item(Icons.headset_mic_rounded, 'الدعم والمساعدة', const Color(0xFF06B6D4), () {}),
        ]),
        const SizedBox(height: 20),

        _section('قانوني'),
        _menuGroup([
          _item(Icons.description_rounded, 'الشروط والأحكام', AppTheme.textMuted, () {}),
          _item(Icons.shield_rounded, 'سياسة الخصوصية', AppTheme.textMuted, () {}),
          _item(Icons.info_rounded, 'عن SDB', AppTheme.textMuted, () {}),
        ]),
        const SizedBox(height: 24),

        GestureDetector(
          onTap: () => _logout(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.danger.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.danger.withValues(alpha: 0.15)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.logout_rounded, color: AppTheme.danger.withValues(alpha: 0.7), size: 20),
              const SizedBox(width: 10),
              Text('تسجيل الخروج', style: TextStyle(color: AppTheme.danger.withValues(alpha: 0.8), fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Center(child: Text('SDB Banking v1.0.0', style: TextStyle(fontSize: 11, color: AppTheme.textMuted.withValues(alpha: 0.4)))),
        const SizedBox(height: 30),
      ])),
    );
  }

  void _logout(BuildContext context) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppTheme.bgCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('تسجيل الخروج', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 18)),
      content: Text('هل تريد تسجيل الخروج من حسابك؟', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text('إلغاء', style: TextStyle(color: AppTheme.textMuted))),
        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('خروج', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700))),
      ],
    ));
    if (ok == true) {
      await ApiService.logout();
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _section(String t) => Padding(padding: const EdgeInsets.only(bottom: 10, right: 4), child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 0.5)));

  Widget _menuGroup(List<Widget> items) => Container(
    decoration: BoxDecoration(
      color: AppTheme.bgCard, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppTheme.border),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))],
    ),
    child: Column(children: items),
  );

  Widget _item(IconData icon, String label, Color c, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: c, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted.withValues(alpha: 0.4)),
        ]),
      ),
    );
  }
}
