import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(t.explore, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textSecondary),
                ),
              ),
            ]),
          ),

          // Content
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Banking Services
              _sectionHeader('الخدمات المصرفية'),
              const SizedBox(height: 8),
              _buildItem(
                icon: Icons.swap_horiz_rounded,
                color: const Color(0xFFF59E0B),
                title: t.exchangeCurrency,
                subtitle: 'صرف بين محافظك',
                onTap: () => Navigator.pushNamed(context, '/exchange'),
              ),
              _buildItem(
                icon: Icons.add_circle_outline_rounded,
                color: AppTheme.primary,
                title: t.addMoney,
                subtitle: 'إيداع أموال في حسابك',
                onTap: () => Navigator.pushNamed(context, '/deposit'),
              ),
              _buildItem(
                icon: Icons.account_balance_wallet_rounded,
                color: const Color(0xFF3B82F6),
                title: 'فتح محفظة',
                subtitle: 'فتح محفظة عملة جديدة',
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              const SizedBox(height: 20),

              // Security & Identity
              _sectionHeader('الأمان والهوية'),
              const SizedBox(height: 8),
              _buildItem(
                icon: Icons.verified_user_rounded,
                color: const Color(0xFF8B5CF6),
                title: t.verifyIdentity,
                subtitle: 'إكمال التحقق من الهوية',
                onTap: () => Navigator.pushNamed(context, '/kyc'),
              ),
              _buildItem(
                icon: Icons.qr_code_rounded,
                color: AppTheme.textSecondary,
                title: t.myQrCode,
                subtitle: t.scanToPayMe,
                onTap: () => Navigator.pushNamed(context, '/qr'),
              ),
              const SizedBox(height: 20),

              // Support
              _sectionHeader('الدعم'),
              const SizedBox(height: 8),
              _buildItem(
                icon: Icons.smart_toy_rounded,
                color: const Color(0xFF8B5CF6),
                title: 'SDB AI',
                subtitle: 'مساعدك المالي الذكي',
                onTap: () => Navigator.pushNamed(context, '/ai-chat'),
              ),
              _buildItem(
                icon: Icons.help_outline_rounded,
                color: AppTheme.primary,
                title: t.helpCenter,
                subtitle: 'احصل على مساعدة وإجابات',
                onTap: () => Navigator.pushNamed(context, '/help'),
              ),
              _buildItem(
                icon: Icons.group_rounded,
                color: const Color(0xFF3B82F6),
                title: t.contacts,
                subtitle: 'إدارة جهات اتصالك',
                onTap: () => Navigator.pushNamed(context, '/contacts'),
              ),
              const SizedBox(height: 32),
            ]),
          )),
        ]),
      ),
    );
  }

  static Widget _sectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 1.2),
    );
  }

  static Widget _buildItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
        ]),
      ),
    );
  }
}
