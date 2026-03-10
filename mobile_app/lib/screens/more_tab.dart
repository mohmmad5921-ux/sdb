import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({super.key});
  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  Map<String, dynamic>? _user;
  bool _loading = true;
  bool _notifications = true;
  bool _biometrics = true;
  bool _twoFactor = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final r = await ApiService.getProfile();
    if (r['success'] == true) setState(() { _user = r['data']?['user'] ?? r['data']; _loading = false; });
    else setState(() => _loading = false);
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
    final name = _user?['full_name'] ?? 'User';
    final email = _user?['email'] ?? '';
    final phone = _user?['phone'] ?? '';
    final username = _user?['username'];
    final kyc = _user?['kyc_status'] ?? 'pending';
    final initials = _getInitials(name);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Profile header
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
            Stack(children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(30)),
                child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
              ),
              Positioned(bottom: 0, right: 0, child: Container(
                width: 20, height: 20,
                decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.bgLight, width: 2)),
                child: const Icon(Icons.edit, size: 10, color: Colors.white),
              )),
            ]),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              if (username != null) Text('@$username', style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500)),
              Text(email, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              if (phone.isNotEmpty) Text(phone, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ])),
          ])),
          const SizedBox(height: 16),

          // Stats
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
            _buildStat('Member', '2026'),
            const SizedBox(width: 8),
            _buildStat('Transfers', '5'),
            const SizedBox(width: 8),
            _buildStat('KYC', kyc == 'verified' ? '✓' : '⏳'),
          ])),
          const SizedBox(height: 24),

          // Account
          _buildSection('ACCOUNT', [
            _buildRow(Icons.person_outline, 'Personal Information', subtitle: 'Name, email, phone'),
            _buildRow(Icons.location_on_outlined, 'Address', subtitle: _user?['city'] ?? 'Not set'),
            _buildRow(Icons.verified_outlined, 'Verification', right: _kycBadge(kyc), onTap: () => Navigator.pushNamed(context, '/kyc')),
          ]),
          const SizedBox(height: 16),

          // Security
          _buildSection('SECURITY', [
            _buildRow(Icons.shield_outlined, 'Biometric Login', subtitle: 'Face ID / Fingerprint', right: _toggle(_biometrics, () => setState(() => _biometrics = !_biometrics))),
            _buildRow(Icons.lock_outline, 'Two-Factor Auth', subtitle: 'SMS or authenticator', right: _toggle(_twoFactor, () => setState(() => _twoFactor = !_twoFactor))),
            _buildRow(Icons.key, 'Change Password'),
          ]),
          const SizedBox(height: 16),

          // Preferences
          _buildSection('PREFERENCES', [
            _buildRow(Icons.notifications_none, 'Notifications', subtitle: 'Push & email alerts', right: _toggle(_notifications, () => setState(() => _notifications = !_notifications))),
            _buildRow(Icons.language, 'Language', subtitle: 'English'),
            _buildRow(Icons.attach_money, 'Default Currency', subtitle: 'Euro (EUR)'),
          ]),
          const SizedBox(height: 16),

          // Support
          _buildSection('SUPPORT', [
            _buildRow(Icons.help_outline, 'Help Center'),
            _buildRow(Icons.chat_bubble_outline, 'Contact Support', subtitle: 'Chat, email or call'),
          ]),
          const SizedBox(height: 16),

          // Sign Out
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
            decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
            child: _buildRow(Icons.logout, 'Sign Out', danger: true, onTap: _logout),
          )),
          const SizedBox(height: 16),

          Center(child: Text('SDB Bank v1.0.4 · Syrian Digital Bank', style: TextStyle(fontSize: 11, color: AppTheme.textMuted.withOpacity(0.6)))),
        ]),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
      ]),
    ));
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 1.2)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: List.generate(children.length, (i) => Column(children: [
          children[i],
          if (i < children.length - 1) Divider(height: 0.5, color: AppTheme.border, indent: 52),
        ]))),
      ),
    ]));
  }

  Widget _buildRow(IconData icon, String label, {String? subtitle, Widget? right, bool danger = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(16),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13), child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: danger ? AppTheme.danger.withOpacity(0.1) : AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: danger ? AppTheme.danger : AppTheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: danger ? AppTheme.danger : AppTheme.textPrimary)),
          if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        ])),
        right ?? Icon(Icons.chevron_right, size: 18, color: danger ? AppTheme.danger : AppTheme.textMuted),
      ])),
    );
  }

  Widget _toggle(bool value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44, height: 24,
        decoration: BoxDecoration(color: value ? AppTheme.primary : AppTheme.border, borderRadius: BorderRadius.circular(12)),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20, height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
          ),
        ),
      ),
    );
  }

  Widget _kycBadge(String status) {
    final isVerified = status == 'verified';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: (isVerified ? AppTheme.primary : AppTheme.warning).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(isVerified ? 'Verified' : 'Pending', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isVerified ? AppTheme.primary : AppTheme.warning)),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
