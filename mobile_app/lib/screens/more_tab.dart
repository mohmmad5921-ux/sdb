import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'notifications_screen.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({super.key});
  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() { super.initState(); _loadProfile(); }

  Future<void> _loadProfile() async {
    try {
      final r = await ApiService.getProfile();
      if (r['success'] == true) {
        setState(() => profile = r['data'] is Map ? r['data'] as Map<String, dynamic> : null);
      }
    } catch (_) {}
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final name = profile?['full_name'] ?? profile?['user']?['full_name'] ?? 'المستخدم';
    final email = profile?['email'] ?? profile?['user']?['email'] ?? '';
    final kyc = profile?['kyc_status'] ?? profile?['user']?['kyc_status'] ?? 'unverified';

    return Scaffold(
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('الإعدادات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 24),

        // Profile Card
        GestureDetector(
          onTap: () => _showProfile(name, email, kyc),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E293B), Color(0xFF334155)]),
              boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withValues(alpha: 0.15), blurRadius: 15, offset: const Offset(0, 6))],
            ),
            child: Row(children: [
              Container(
                width: 56, height: 56,
                decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)])),
                child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 3),
                Text(email, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.45))),
              ])),
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white.withValues(alpha: 0.4)),
              ),
            ]),
          ),
        ),
        const SizedBox(height: 28),

        _section('الخدمات'),
        _menuGroup([
          _item(Icons.swap_horiz_rounded, 'التحويلات', const Color(0xFF6366F1), () => Navigator.pushNamed(context, '/transfer')),
          _item(Icons.add_rounded, 'الإيداع', const Color(0xFF10B981), () => Navigator.pushNamed(context, '/deposit')),
          _item(Icons.currency_exchange_rounded, 'صرف العملات', const Color(0xFFF59E0B), () => Navigator.pushNamed(context, '/exchange')),
          _item(Icons.verified_user_rounded, 'تحقق الهوية KYC', AppTheme.success, () => _showKYC(kyc)),
        ]),
        const SizedBox(height: 20),

        _section('الحساب والأمان'),
        _menuGroup([
          _item(Icons.notifications_rounded, 'الإشعارات', const Color(0xFFF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
          _item(Icons.lock_rounded, 'الأمان والخصوصية', const Color(0xFF10B981), () => _showComingSoon('الأمان والخصوصية')),
          _item(Icons.fingerprint_rounded, 'البصمة / Face ID', const Color(0xFF8B5CF6), () => _showComingSoon('البصمة / Face ID')),
          _item(Icons.headset_mic_rounded, 'الدعم والمساعدة', const Color(0xFF06B6D4), () => _showComingSoon('الدعم والمساعدة')),
        ]),
        const SizedBox(height: 20),

        _section('قانوني'),
        _menuGroup([
          _item(Icons.description_rounded, 'الشروط والأحكام', AppTheme.textMuted, () => _showComingSoon('الشروط والأحكام')),
          _item(Icons.shield_rounded, 'سياسة الخصوصية', AppTheme.textMuted, () => _showComingSoon('سياسة الخصوصية')),
          _item(Icons.info_rounded, 'عن SDB', AppTheme.textMuted, () => _showAbout()),
        ]),
        const SizedBox(height: 24),

        GestureDetector(
          onTap: () => _logout(context),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.danger.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(18),
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

  void _showProfile(String name, String email, String kyc) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
        const SizedBox(height: 24),
        Container(
          width: 80, height: 80,
          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)])),
          child: Center(child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
        ),
        const SizedBox(height: 16),
        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: kyc == 'verified' ? AppTheme.success.withValues(alpha: 0.08) : const Color(0xFFF59E0B).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            kyc == 'verified' ? '✓ هوية مُوثّقة' : '⚠ بحاجة للتحقق',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kyc == 'verified' ? AppTheme.success : const Color(0xFFF59E0B)),
          ),
        ),
        const SizedBox(height: 24),
        _profileItem(Icons.person_rounded, 'الاسم الكامل', name),
        _profileItem(Icons.email_rounded, 'البريد الإلكتروني', email),
        _profileItem(Icons.phone_rounded, 'الهاتف', profile?['phone'] ?? profile?['user']?['phone'] ?? 'غير محدد'),
        _profileItem(Icons.badge_rounded, 'رقم العميل', profile?['customer_number'] ?? profile?['user']?['customer_number'] ?? '-'),
      ]),
    ));
  }

  Widget _profileItem(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: AppTheme.primary, size: 18)),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ])),
    ]),
  );

  void _showKYC(String kyc) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
        const SizedBox(height: 24),
        Container(
          width: 70, height: 70,
          decoration: BoxDecoration(
            color: kyc == 'verified' ? AppTheme.success.withValues(alpha: 0.1) : const Color(0xFFF59E0B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(kyc == 'verified' ? Icons.verified_rounded : Icons.badge_outlined, size: 36,
            color: kyc == 'verified' ? AppTheme.success : const Color(0xFFF59E0B)),
        ),
        const SizedBox(height: 16),
        Text(kyc == 'verified' ? 'هويتك موثّقة ✓' : 'التحقق من الهوية', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        Text(
          kyc == 'verified' ? 'تم التحقق من هويتك بنجاح. يمكنك استخدام جميع خدمات البنك.' : 'يرجى إرسال مستنداتك عبر الويب أو التواصل مع الدعم لإتمام التحقق.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.6),
        ),
        const SizedBox(height: 20),
        if (kyc == 'verified')
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 22),
              const SizedBox(width: 12),
              const Text('جميع الخدمات مفعّلة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            ]),
          )
        else
          Column(children: [
            _kycStep(Icons.badge_rounded, 'بطاقة هوية', 'صورة أمامية وخلفية', true),
            const SizedBox(height: 10),
            _kycStep(Icons.portrait_rounded, 'صورة شخصية', 'سيلفي واضح', false),
            const SizedBox(height: 10),
            _kycStep(Icons.home_rounded, 'إثبات عنوان', 'فاتورة أو كشف حساب', false),
          ]),
      ]),
    ));
  }

  Widget _kycStep(IconData icon, String title, String sub, bool first) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(14),
      border: Border.all(color: first ? AppTheme.primary.withValues(alpha: 0.2) : AppTheme.border),
    ),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(
        color: first ? AppTheme.primary.withValues(alpha: 0.08) : AppTheme.bgSurface, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: first ? AppTheme.primary : AppTheme.textMuted, size: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        Text(sub, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      ])),
      Icon(first ? Icons.arrow_forward_ios_rounded : Icons.lock_rounded, size: 14, color: AppTheme.textMuted),
    ]),
  );

  void _showAbout() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
        const SizedBox(height: 24),
        Container(
          width: 70, height: 70,
          decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20)),
          child: const Center(child: Text('SDB', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.primary))),
        ),
        const SizedBox(height: 14),
        const Text('SDB Banking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 4),
        Text('v1.0.0', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        const SizedBox(height: 16),
        Text('بنك رقمي حديث يقدم خدمات مصرفية متكاملة\nتحويلات • بطاقات • صرف عملات',
          textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.6)),
        const SizedBox(height: 20),
        Text('© 2024 SDB Banking. جميع الحقوق محفوظة', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
      ]),
    ));
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('⏳ $feature — قريباً!'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _logout(BuildContext context) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      backgroundColor: Colors.white,
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
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
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
          Container(width: 38, height: 38, decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: c, size: 18)),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted.withValues(alpha: 0.4)),
        ]),
      ),
    );
  }
}
