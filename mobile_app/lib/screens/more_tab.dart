import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المزيد')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        // Profile Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.border)),
          child: Row(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
              borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Text('👤', style: TextStyle(fontSize: 26)))),
            const SizedBox(width: 16),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('حسابي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
              SizedBox(height: 2),
              Text('إدارة الملف الشخصي والإعدادات', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            ])),
            Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.3)),
          ]),
        ),
        const SizedBox(height: 24),

        // Menu Sections
        _sectionTitle('الخدمات'),
        _menuItem(context, Icons.analytics_outlined, 'التحليلات المالية', '📊', () {}),
        _menuItem(context, Icons.people_outline, 'المستفيدون', '👥', () {}),
        _menuItem(context, Icons.badge_outlined, 'تحقق الهوية KYC', '🪪', () {}),
        _menuItem(context, Icons.card_giftcard_outlined, 'إحالة صديق', '🎁', () {}),

        const SizedBox(height: 16),
        _sectionTitle('الحساب'),
        _menuItem(context, Icons.notifications_outlined, 'الإشعارات', '🔔', () {}),
        _menuItem(context, Icons.security_outlined, 'الأمان والخصوصية', '🔒', () {}),
        _menuItem(context, Icons.help_outline, 'الدعم والمساعدة', '🎧', () {}),

        const SizedBox(height: 16),
        _sectionTitle('قانوني'),
        _menuItem(context, Icons.description_outlined, 'الشروط والأحكام', '📋', () {}),
        _menuItem(context, Icons.privacy_tip_outlined, 'سياسة الخصوصية', '🛡', () {}),
        _menuItem(context, Icons.info_outline, 'عن SDB', 'ℹ️', () {}),

        const SizedBox(height: 24),
        // Logout
        GestureDetector(
          onTap: () async {
            final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
              backgroundColor: AppTheme.bgCard,
              title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              content: const Text('هل تريد تسجيل الخروج من حسابك؟', style: TextStyle(color: AppTheme.textSecondary)),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('خروج', style: TextStyle(color: AppTheme.danger))),
              ],
            ));
            if (ok == true) {
              await ApiService.logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.danger.withValues(alpha: 0.15))),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.logout, color: AppTheme.danger, size: 20),
              SizedBox(width: 8),
              Text('تسجيل الخروج', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700, fontSize: 14)),
            ]),
          ),
        ),
        const SizedBox(height: 20),
        Center(child: Text('SDB v1.0.0', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.15)))),
        const SizedBox(height: 30),
      ]),
    );
  }

  Widget _sectionTitle(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.3))));

  Widget _menuItem(BuildContext ctx, IconData icon, String label, String emoji, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))),
          Icon(Icons.chevron_right, size: 18, color: Colors.white.withValues(alpha: 0.2)),
        ]),
      ),
    );
  }
}
