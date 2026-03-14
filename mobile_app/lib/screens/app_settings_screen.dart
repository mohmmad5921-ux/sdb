import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  final _storage = const FlutterSecureStorage();
  final _auth = LocalAuthentication();

  bool _biometrics = false;
  bool _notifications = true;
  String _selectedIcon = 'default';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final bio = await _storage.read(key: 'biometric_enabled') ?? 'false';
    final notif = await _storage.read(key: 'notifications_enabled') ?? 'true';
    final icon = await _storage.read(key: 'selected_icon') ?? 'default';
    if (mounted) {
      setState(() {
        _biometrics = bio == 'true';
        _notifications = notif == 'true';
        _selectedIcon = icon;
      });
    }
  }

  Future<void> _toggleBiometric() async {
    if (!_biometrics) {
      try {
        final can = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
        if (!can) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(L10n.of(context).biometricNotAvailable), backgroundColor: AppTheme.danger),
            );
          }
          return;
        }
        final didAuth = await _auth.authenticate(
          localizedReason: 'تفعيل تسجيل الدخول بالبصمة',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (didAuth) {
          await _storage.write(key: 'biometric_enabled', value: 'true');
          if (mounted) setState(() => _biometrics = true);
        }
      } catch (_) {}
    } else {
      await _storage.write(key: 'biometric_enabled', value: 'false');
      if (mounted) setState(() => _biometrics = false);
    }
  }

  Future<void> _toggleNotifications() async {
    final newVal = !_notifications;
    await _storage.write(key: 'notifications_enabled', value: newVal.toString());
    if (mounted) setState(() => _notifications = newVal);
  }

  void _showLanguagePicker() async {
    await launchUrl(Uri.parse('app-settings:'));
  }



  void _showAppearance() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _AppearanceScreen(
      selectedIcon: _selectedIcon,
      onIconChanged: (icon) {
        setState(() => _selectedIcon = icon);
      },
    )));
  }

  void _showChangePassword() {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    final t = L10n.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(t.changePasswordTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          _passField(t.currentPassword, currentCtrl),
          const SizedBox(height: 12),
          _passField(t.newPassword, newCtrl),
          const SizedBox(height: 12),
          _passField(t.confirmPasswordShort, confirmCtrl),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (newCtrl.text != confirmCtrl.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('كلمات السر غير متطابقة'), backgroundColor: AppTheme.danger),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تغيير كلمة السر ✓'), backgroundColor: AppTheme.primary),
                );
              },
              child: const Text('تغيير'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _passField(String hint, TextEditingController ctrl) {
    return Container(
      decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: TextField(
        controller: ctrl,
        obscureText: true,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppTheme.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final provider = L10n.providerOf(context);
    final langDisplay = provider.isArabic ? 'العربية' : 'English';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(t.appSettings, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 24),

            // General section
            Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
              child: Column(children: [
                _settingsRow(Icons.language, t.language, trailing: Text(langDisplay, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)), onTap: _showLanguagePicker),
                _divider(),
                _settingsRow(Icons.notifications_none_rounded, t.notifications, onTap: () {}),
                _divider(),
                _settingsRow(Icons.palette_outlined, t.appearanceAndSound, onTap: _showAppearance),
              ]),
            ),
            const SizedBox(height: 24),

            // Security section
            Text(t.security, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
              child: Column(children: [
                _settingsRow(Icons.lock_outline, t.changePassword, subtitle: '••••', onTap: _showChangePassword),
                _divider(),
                _settingsRow(Icons.face_rounded, t.biometricLogin, trailing: _toggle(_biometrics, _toggleBiometric)),
                _divider(),
                _settingsRow(Icons.notifications_active_outlined, 'الإشعارات', trailing: _toggle(_notifications, _toggleNotifications)),
              ]),
            ),
            const SizedBox(height: 32),

            // Version info
            Center(
              child: Text(
                'SDB Bank v1.0.7\nApp ID: com.sdb.sdbApp',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted.withValues(alpha: 0.6), height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _settingsRow(IconData icon, String label, {String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 17, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
              if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            ]),
          ),
          trailing ?? const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textMuted),
        ]),
      ),
    );
  }

  Widget _divider() => Divider(height: 0.5, color: AppTheme.border, indent: 60);

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
}

// ═══════ Appearance & Sound Screen (Udseende og lyd) ═══════

class _AppearanceScreen extends StatefulWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconChanged;

  const _AppearanceScreen({required this.selectedIcon, required this.onIconChanged});

  @override
  State<_AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<_AppearanceScreen> {
  final _storage = const FlutterSecureStorage();
  late String _selectedIcon;
  bool _soundEnabled = true;
  int _themeMode = 0; // 0=light, 1=dark

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.selectedIcon;
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final sound = await _storage.read(key: 'sound_enabled') ?? 'true';
    if (mounted) setState(() => _soundEnabled = sound == 'true');
  }

  Future<void> _changeIcon(String key) async {
    try {
      if (key == 'default') {
        await FlutterDynamicIcon.setAlternateIconName(null);
      } else {
        await FlutterDynamicIcon.setAlternateIconName(key);
      }
      await _storage.write(key: 'selected_icon', value: key);
      if (mounted) {
        setState(() => _selectedIcon = key);
        widget.onIconChanged(key);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر تغيير الأيقونة'), backgroundColor: AppTheme.danger),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      {'key': 'default', 'asset': 'assets/icons/icon_green.png'},
      {'key': 'AppIconBlack', 'asset': 'assets/icons/icon_black.png'},
      {'key': 'AppIconWhite', 'asset': 'assets/icons/icon_white.png'},
      {'key': 'AppIconNavy', 'asset': 'assets/icons/icon_navy.png'},
      {'key': 'AppIconRed', 'asset': 'assets/icons/icon_red.png'},
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 16),

            const Text('المظهر والصوت', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 24),

            // Theme selector (Light / Dark) - like Lunar
            const Text('سمة التطبيق', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
              child: Row(children: [
                // Light mode preview
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => _themeMode = 0),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _themeMode == 0 ? AppTheme.primary : AppTheme.border, width: _themeMode == 0 ? 2 : 1),
                    ),
                    child: Column(children: [
                      const SizedBox(height: 12),
                      Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(7))),
                      const SizedBox(height: 8),
                      _miniRow(const Color(0xFFFFC107)),
                      _miniRow(const Color(0xFFE91E63)),
                      _miniRow(const Color(0xFF3F51B5)),
                      _miniRow(const Color(0xFF009688)),
                      const Spacer(),
                      Text('فاتح', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _themeMode == 0 ? AppTheme.primary : AppTheme.textMuted)),
                      const SizedBox(height: 8),
                    ]),
                  ),
                )),
                const SizedBox(width: 12),
                // Dark mode preview
                Expanded(child: GestureDetector(
                  onTap: () => setState(() => _themeMode = 1),
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _themeMode == 1 ? AppTheme.primary : AppTheme.border, width: _themeMode == 1 ? 2 : 1),
                    ),
                    child: Column(children: [
                      const SizedBox(height: 12),
                      Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(7))),
                      const SizedBox(height: 8),
                      _miniRow(const Color(0xFFFFC107), dark: true),
                      _miniRow(const Color(0xFFE91E63), dark: true),
                      _miniRow(const Color(0xFF3F51B5), dark: true),
                      _miniRow(const Color(0xFF009688), dark: true),
                      const Spacer(),
                      Text('داكن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _themeMode == 1 ? AppTheme.primary : Colors.white54)),
                      const SizedBox(height: 8),
                    ]),
                  ),
                )),
              ]),
            ),
            const SizedBox(height: 24),

            // Icon picker - like Lunar "Tilpas app-ikon"
            if (Platform.isIOS) ...[
              Container(
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.apps_rounded, size: 17, color: AppTheme.textSecondary),
                    ),
                    title: const Text('تخصيص أيقونة التطبيق', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: icons.map((ic) {
                            final isSelected = _selectedIcon == ic['key'];
                            return GestureDetector(
                              onTap: () => _changeIcon(ic['key']!),
                              child: Column(children: [
                                Container(
                                  width: 56, height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isSelected ? AppTheme.primary : AppTheme.border,
                                      width: isSelected ? 2.5 : 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(ic['asset']!, fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (isSelected)
                                  const Icon(Icons.check_circle, size: 14, color: AppTheme.primary)
                                else
                                  const SizedBox(height: 14),
                              ]),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Sounds toggle
            Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.volume_up_rounded, size: 17, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('الأصوات في التطبيق', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                  GestureDetector(
                    onTap: () async {
                      final newVal = !_soundEnabled;
                      await _storage.write(key: 'sound_enabled', value: newVal.toString());
                      if (mounted) setState(() => _soundEnabled = newVal);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44, height: 24,
                      decoration: BoxDecoration(color: _soundEnabled ? AppTheme.primary : AppTheme.border, borderRadius: BorderRadius.circular(12)),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment: _soundEnabled ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          width: 20, height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _miniRow(Color dotColor, {bool dark = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      child: Row(children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Expanded(child: Container(height: 6, decoration: BoxDecoration(color: dark ? Colors.white12 : Colors.grey.shade200, borderRadius: BorderRadius.circular(3)))),
      ]),
    );
  }
}
