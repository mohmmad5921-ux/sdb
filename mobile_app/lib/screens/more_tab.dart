import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreTab extends StatefulWidget {
  const MoreTab({super.key});
  @override
  State<MoreTab> createState() => _MoreTabState();
}

class _MoreTabState extends State<MoreTab> {
  Map<String, dynamic>? _user;
  bool _loading = true;
  bool _notifications = true;
  bool _biometrics = false;
  bool _twoFactor = false;
  String _defaultCurrency = 'SYP';
  String _selectedIcon = 'default';
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _load();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final curr = await _storage.read(key: 'default_currency') ?? 'SYP';
    final bio = await _storage.read(key: 'biometric_enabled') ?? 'false';
    final notif = await _storage.read(key: 'notifications_enabled') ?? 'true';
    final icon = await _storage.read(key: 'selected_icon') ?? 'default';
    if (mounted) {
      setState(() {
        _defaultCurrency = curr;
        _biometrics = bio == 'true';
        _notifications = notif == 'true';
        _selectedIcon = icon;
      });
    }
  }

  Future<void> _load() async {
    final r = await ApiService.getProfile();
    if (mounted) {
      if (r['success'] == true) {
        final user = r['data']?['user'] ?? r['data'];
        setState(() {
          _user = user;
          _twoFactor = user?['sms_2fa_enabled'] == true || user?['sms_2fa_enabled'] == 1;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _logout() async {
    final t = L10n.of(context);
    final confirm = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(t.signOut, style: const TextStyle(fontWeight: FontWeight.w700)),
      content: Text(t.signOutConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(t.signOut, style: const TextStyle(color: AppTheme.danger))),
      ],
    ));
    if (confirm == true) {
      await ApiService.logout();
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  Future<void> _toggleBiometric() async {
    if (!_biometrics) {
      try {
        final can = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
        if (!can) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).biometricNotAvailable), backgroundColor: AppTheme.danger));
          }
          return;
        }
        final didAuth = await _auth.authenticate(localizedReason: L10n.of(context).biometricLogin, options: const AuthenticationOptions(biometricOnly: true));
        if (didAuth) {
          await _storage.write(key: 'biometric_enabled', value: 'true');
          if (mounted) {
            setState(() => _biometrics = true);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).biometricEnabled), backgroundColor: AppTheme.primary));
          }
        }
      } catch (_) {}
    } else {
      await _storage.write(key: 'biometric_enabled', value: 'false');
      if (mounted) {
        setState(() => _biometrics = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).biometricDisabled), backgroundColor: AppTheme.textSecondary));
      }
    }
  }

  Future<void> _toggleNotifications() async {
    final newVal = !_notifications;
    await _storage.write(key: 'notifications_enabled', value: newVal.toString());
    if (mounted) {
      setState(() => _notifications = newVal);
      final t = L10n.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(newVal ? '${t.notifications} ${t.enabled} ✓' : '${t.notifications} ${t.disabled}'),
        backgroundColor: newVal ? AppTheme.primary : AppTheme.textSecondary,
      ));
    }
  }

  Future<void> _toggle2fa() async {
    final r = await ApiService.toggle2fa();
    if (mounted) {
      if (r['success'] == true) {
        final enabled = r['data']?['sms_2fa_enabled'] == true;
        setState(() => _twoFactor = enabled);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(enabled ? '${L10n.of(context).twoFactorAuth} ${L10n.of(context).enabled} ✓' : '${L10n.of(context).twoFactorAuth} ${L10n.of(context).disabled}'),
          backgroundColor: enabled ? AppTheme.primary : AppTheme.textSecondary,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(L10n.of(context).errorTryAgain),
          backgroundColor: AppTheme.danger,
        ));
      }
    }
  }

  void _showLanguagePicker() {
    final t = L10n.of(context);
    final provider = L10n.providerOf(context);
    final currentLang = _currentLangName(provider);
    final languages = ['العربية', 'English', 'Türkçe', 'Dansk', 'Deutsch', 'Français', 'Svenska'];

    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(t.selectLanguage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ...languages.map((l) => ListTile(
          title: Text(l, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          trailing: currentLang == l ? const Icon(Icons.check_circle, color: AppTheme.primary, size: 20) : null,
          onTap: () {
            provider.setLanguage(l);
            Navigator.pop(context);
          },
        )),
      ]),
    ));
  }

  String _currentLangName(LocaleProvider provider) {
    switch (provider.locale.languageCode) {
      case 'en': return 'English';
      case 'tr': return 'Türkçe';
      case 'da': return 'Dansk';
      case 'de': return 'Deutsch';
      case 'fr': return 'Français';
      case 'sv': return 'Svenska';
      case 'ar':
      default: return 'العربية';
    }
  }

  void _showCurrencyPicker() {
    final t = L10n.of(context);
    final currencies = [
      {'code': 'SYP', 'name': 'Syrian Pound', 'flag': '🇸🇾'},
      {'code': 'EUR', 'name': 'Euro', 'flag': '🇪🇺'},
      {'code': 'USD', 'name': 'US Dollar', 'flag': '🇺🇸'},
      {'code': 'GBP', 'name': 'British Pound', 'flag': '🇬🇧'},
      {'code': 'DKK', 'name': 'Danish Krone', 'flag': '🇩🇰'},
    ];
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(t.defaultCurrency, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        ...currencies.map((c) => ListTile(
          leading: Text(c['flag']!, style: const TextStyle(fontSize: 22)),
          title: Text('${c['name']} (${c['code']})', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          trailing: _defaultCurrency == c['code'] ? const Icon(Icons.check_circle, color: AppTheme.primary, size: 20) : null,
          onTap: () async {
            await _storage.write(key: 'default_currency', value: c['code']!);
            if (mounted) {
              setState(() => _defaultCurrency = c['code']!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${t.currency}: ${c['code']} ✓'), backgroundColor: AppTheme.primary));
            }
          },
        )),
      ]),
    ));
  }

  void _showEditProfile() {
    final t = L10n.of(context);
    final nameCtrl = TextEditingController(text: _user?['full_name'] ?? '');
    final phoneCtrl = TextEditingController(text: _user?['phone'] ?? '');
    final usernameCtrl = TextEditingController(text: _user?['username'] ?? '');

    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(t.editProfile, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        _editField(t.fullName, nameCtrl, Icons.person_outline, readOnly: true),
        const SizedBox(height: 12),
        _editField(t.username, usernameCtrl, Icons.alternate_email),
        const SizedBox(height: 12),
        _editField(t.phone, phoneCtrl, Icons.phone_outlined),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () async {
            final data = <String, dynamic>{};
            if (usernameCtrl.text != (_user?['username'] ?? '')) data['username'] = usernameCtrl.text;
            if (phoneCtrl.text != (_user?['phone'] ?? '')) data['phone'] = phoneCtrl.text;
            if (data.isEmpty) { Navigator.pop(context); return; }
            final r = await ApiService.updateProfile(data);
            if (mounted) {
              Navigator.pop(context);
              if (r['success'] == true) {
                _load();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.profileUpdated), backgroundColor: AppTheme.primary));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r['data']?['message'] ?? 'Error'), backgroundColor: AppTheme.danger));
              }
            }
          },
          child: Text(t.save),
        )),
      ]),
    ));
  }

  Widget _editField(String hint, TextEditingController ctrl, IconData icon, {bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? AppTheme.bgMuted.withValues(alpha: 0.5) : AppTheme.bgMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        enabled: !readOnly,
        style: TextStyle(fontSize: 14, color: readOnly ? AppTheme.textMuted : AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: hint, hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
          prefixIcon: Icon(icon, size: 18, color: AppTheme.textMuted),
          suffixIcon: readOnly ? const Icon(Icons.lock_outline, size: 14, color: AppTheme.textMuted) : null,
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  void _showChangePassword() {
    final t = L10n.of(context);
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(t.changePassword, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        _editField(t.password, currentCtrl, Icons.lock_outline),
        const SizedBox(height: 12),
        _editField(t.password, newCtrl, Icons.lock_outline),
        const SizedBox(height: 12),
        _editField(t.confirmPassword, confirmCtrl, Icons.lock_outline),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () async {
            if (newCtrl.text != confirmCtrl.text) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.passwordMismatch), backgroundColor: AppTheme.danger));
              return;
            }
            final r = await ApiService.updateProfile({'current_password': currentCtrl.text, 'password': newCtrl.text, 'password_confirmation': confirmCtrl.text});
            if (mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(r['success'] == true ? t.passwordChanged : (r['data']?['message'] ?? 'Error')),
                backgroundColor: r['success'] == true ? AppTheme.primary : AppTheme.danger,
              ));
            }
          },
          child: Text(t.changePassword),
        )),
      ]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final provider = L10n.providerOf(context);

    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
    final name = _user?['full_name'] ?? 'User';
    final email = _user?['email'] ?? '';
    final phone = _user?['phone'] ?? '';
    final username = _user?['username'];
    final kyc = _user?['kyc_status'] ?? 'pending';
    final initials = _getInitials(name);
    final joined = _user?['created_at'] ?? '';
    final joinYear = joined.isNotEmpty ? DateTime.tryParse(joined)?.year.toString() ?? '2026' : '2026';
    final langDisplay = _currentLangName(provider);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Close button (Lunar: X at top-left)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Profile header (Lunar style: centered pink avatar + name)
            Center(child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: const Color(0xFFF9A8D4), borderRadius: BorderRadius.circular(40)),
                child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700))),
              ),
              const SizedBox(height: 12),
              Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              GestureDetector(
                onTap: _showEditProfile,
                child: Text(t.editProfile, style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500)),
              ),
            ])),
            const SizedBox(height: 20),

            // Two info cards side by side (Lunar: "Din pakke" + "Rentesats")
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Row(children: [
              Expanded(child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(t.member, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.card_giftcard_rounded, size: 14, color: AppTheme.primary),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  const Text('Premium', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                ]),
              )),
              const SizedBox(width: 10),
              Expanded(child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(t.kyc, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    _kycBadge(kyc),
                  ]),
                  const SizedBox(height: 8),
                  Text(kyc == 'verified' ? t.verified : t.pending, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                ]),
              )),
            ])),
            const SizedBox(height: 24),

            // Account
            _buildSection(t.sectionAccount, [
              _buildRow(Icons.person_outline, t.personalInfo, subtitle: '${t.fullName}, ${t.email}', onTap: _showEditProfile),
              _buildRow(Icons.alternate_email, t.username, subtitle: username != null ? '@$username' : t.username, onTap: _showEditProfile),
              _buildRow(Icons.verified_outlined, t.verification, right: _kycBadge(kyc), onTap: () => Navigator.pushNamed(context, '/kyc')),
              _buildRow(Icons.qr_code_rounded, t.myQrCode, subtitle: t.scanToPayMe, onTap: () => Navigator.pushNamed(context, '/qr')),
            ]),
            const SizedBox(height: 16),

            // Security
            _buildSection(t.sectionSecurity, [
              _buildRow(Icons.fingerprint, t.biometricSubtitle, subtitle: _biometrics ? t.enabled : t.disabled, right: _toggle(_biometrics, _toggleBiometric)),
              _buildRow(Icons.lock_outline, t.twoFactorAuth, subtitle: t.twoFactorSubtitle, right: _toggle(_twoFactor, _toggle2fa)),
            ]),
            const SizedBox(height: 16),

            // Preferences
            _buildSection(t.sectionPreferences, [
              _buildRow(Icons.settings_rounded, t.appSettings, subtitle: '${t.language}, ${t.appTheme}, ${t.security}', onTap: () => Navigator.pushNamed(context, '/app-settings')),
              _buildRow(Icons.notifications_none, t.notifications, subtitle: _notifications ? t.enabled : t.disabled, right: _toggle(_notifications, _toggleNotifications)),
              _buildRow(Icons.attach_money, t.defaultCurrency, subtitle: _defaultCurrency, onTap: _showCurrencyPicker),
            ]),
            const SizedBox(height: 16),

            // Support
            _buildSection(t.sectionSupport, [
              _buildRow(Icons.help_outline, t.helpCenter, onTap: () => Navigator.pushNamed(context, '/help')),
              _buildRow(Icons.chat_bubble_outline, t.contactSupport, subtitle: 'support@sdb-bank.com', onTap: () async {
                final uri = Uri(scheme: 'mailto', path: 'support@sdb-bank.com', queryParameters: {'subject': 'SDB Bank - ${t.contactSupport}'});
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              }),
              _buildRow(Icons.call_outlined, t.phone, subtitle: '+45 71 99 77 07', onTap: () async {
                final uri = Uri(scheme: 'tel', path: '+4571997707');
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              }),
            ]),
            const SizedBox(height: 16),

            // Sign Out
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
              child: _buildRow(Icons.logout, t.signOut, danger: true, onTap: _logout),
            )),
            const SizedBox(height: 16),

            Center(child: Text('SDB Bank v1.0.4 · ${t.appSubtitle}', style: TextStyle(fontSize: 11, color: AppTheme.textMuted.withValues(alpha: 0.6)))),
          ]),
        ),
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
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13), child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: danger ? AppTheme.danger.withValues(alpha: 0.1) : AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]),
          ),
        ),
      ),
    );
  }

  Widget _kycBadge(String status) {
    final t = L10n.of(context);
    final isVerified = status == 'verified';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: (isVerified ? AppTheme.primary : AppTheme.warning).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(isVerified ? t.verified : t.pending, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isVerified ? AppTheme.primary : AppTheme.warning)),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String _iconLabel(String key) {
    switch (key) {
      case 'AppIconBlack': return 'Black';
      case 'AppIconWhite': return 'White';
      case 'AppIconNavy': return 'Navy';
      case 'AppIconRed': return 'Red';
      default: return 'Green (Default)';
    }
  }

  void _showIconPicker() {
    final icons = [
      {'key': 'default', 'label': 'Green', 'asset': 'assets/icons/icon_green.png', 'color': const Color(0xFF1B5E20)},
      {'key': 'AppIconBlack', 'label': 'Black', 'asset': 'assets/icons/icon_black.png', 'color': const Color(0xFF000000)},
      {'key': 'AppIconWhite', 'label': 'White', 'asset': 'assets/icons/icon_white.png', 'color': const Color(0xFFFFFFFF)},
      {'key': 'AppIconNavy', 'label': 'Navy', 'asset': 'assets/icons/icon_navy.png', 'color': const Color(0xFF0A1628)},
      {'key': 'AppIconRed', 'label': 'Red', 'asset': 'assets/icons/icon_red.png', 'color': const Color(0xFFB71C1C)},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 22, color: AppTheme.textMuted),
            ),
          ]),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: icons.map((ic) {
              final isSelected = _selectedIcon == ic['key'];
              return GestureDetector(
                onTap: () async {
                  try {
                    if (ic['key'] == 'default') {
                      if (Platform.isIOS) {
                        const MethodChannel('flutter_dynamic_icon').invokeMethod('setAlternateIconName', {'iconName': null});
                      }
                    } else {
                      if (Platform.isIOS) {
                        const MethodChannel('flutter_dynamic_icon').invokeMethod('setAlternateIconName', {'iconName': ic['key'] as String});
                      }
                    }
                    await _storage.write(key: 'selected_icon', value: ic['key'] as String);
                    if (mounted) {
                      setState(() => _selectedIcon = ic['key'] as String);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Icon changed to ${ic["label"]} ✓'), backgroundColor: AppTheme.primary),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(L10n.of(context).iconChangeFailed), backgroundColor: AppTheme.danger),
                      );
                    }
                  }
                },
                child: Column(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.border,
                        width: isSelected ? 2.5 : 1,
                      ),
                      boxShadow: isSelected ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 8)] : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(ic['asset'] as String, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isSelected)
                    const Icon(Icons.check_circle, size: 16, color: AppTheme.primary)
                  else
                    Text(ic['label'] as String, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                ]),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }
}
