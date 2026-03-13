import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/push_notification_service.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  final _confirmPass = TextEditingController();
  final _phone = TextEditingController();
  bool _loading = false, _obscure = true, _isRegister = false;
  final _auth = LocalAuthentication();
  bool _canBiometric = false;
  String? _error;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  // Registration dropdowns
  String? _employment;
  String? _annualVolume;
  String _currency = 'USD';

  // Login mode: 'email' or 'phone'
  String _loginMode = 'email';

  String _selectedCountryCode = '+963';
  String _selectedCountryName = 'سوريا';
  String _selectedCountryFlag = '🇸🇾';

  static const _countries = [
    {'name': 'سوريا', 'code': '+963', 'flag': '🇸🇾', 'en': 'Syria'},
    {'name': 'الدنمارك', 'code': '+45', 'flag': '🇩🇰', 'en': 'Denmark'},
    {'name': 'ألمانيا', 'code': '+49', 'flag': '🇩🇪', 'en': 'Germany'},
    {'name': 'تركيا', 'code': '+90', 'flag': '🇹🇷', 'en': 'Turkey'},
    {'name': 'لبنان', 'code': '+961', 'flag': '🇱🇧', 'en': 'Lebanon'},
    {'name': 'الأردن', 'code': '+962', 'flag': '🇯🇴', 'en': 'Jordan'},
    {'name': 'العراق', 'code': '+964', 'flag': '🇮🇶', 'en': 'Iraq'},
    {'name': 'السعودية', 'code': '+966', 'flag': '🇸🇦', 'en': 'Saudi Arabia'},
    {'name': 'الإمارات', 'code': '+971', 'flag': '🇦🇪', 'en': 'UAE'},
    {'name': 'مصر', 'code': '+20', 'flag': '🇪🇬', 'en': 'Egypt'},
    {'name': 'الكويت', 'code': '+965', 'flag': '🇰🇼', 'en': 'Kuwait'},
    {'name': 'قطر', 'code': '+974', 'flag': '🇶🇦', 'en': 'Qatar'},
    {'name': 'البحرين', 'code': '+973', 'flag': '🇧🇭', 'en': 'Bahrain'},
    {'name': 'عُمان', 'code': '+968', 'flag': '🇴🇲', 'en': 'Oman'},
    {'name': 'السويد', 'code': '+46', 'flag': '🇸🇪', 'en': 'Sweden'},
    {'name': 'النرويج', 'code': '+47', 'flag': '🇳🇴', 'en': 'Norway'},
    {'name': 'هولندا', 'code': '+31', 'flag': '🇳🇱', 'en': 'Netherlands'},
    {'name': 'فرنسا', 'code': '+33', 'flag': '🇫🇷', 'en': 'France'},
    {'name': 'بريطانيا', 'code': '+44', 'flag': '🇬🇧', 'en': 'UK'},
    {'name': 'أمريكا', 'code': '+1', 'flag': '🇺🇸', 'en': 'USA'},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    _checkBiometric();
    _loadSavedCountry();
  }

  Future<void> _loadSavedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('user_phone_code');
    final flag = prefs.getString('user_country_flag');
    final name = prefs.getString('user_country_name');
    final cur = prefs.getString('user_currency');
    if (mounted) {
      setState(() {
        if (code != null) _selectedCountryCode = code;
        if (flag != null) _selectedCountryFlag = flag;
        if (name != null) _selectedCountryName = name;
        if (cur != null) _currency = cur;
      });
    }
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  void _showHelpDialog() {
    Navigator.pushNamed(context, '/help');
  }

  void _showDuplicateDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 30),
            ),
            const SizedBox(height: 16),
            const Text('حساب موجود مسبقاً', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF666666), height: 1.5)),
            const SizedBox(height: 24),
            // Login button
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                setState(() { _isRegister = false; _error = null; });
              },
              child: Container(
                width: double.infinity, height: 50,
                decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(14)),
                child: const Center(child: Text('تسجيل الدخول', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white))),
              ),
            ),
            const SizedBox(height: 10),
            // Support button
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, '/help');
              },
              child: Container(
                width: double.infinity, height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: const Center(child: Text('التواصل مع الدعم', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A)))),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final t = L10n.of(context);

    if (_isRegister) {
      // Register mode
      if (_name.text.isEmpty || _email.text.isEmpty || _pass.text.isEmpty || _phone.text.isEmpty) {
        setState(() => _error = t.fillAllFields); return;
      }
      if (_pass.text != _confirmPass.text) { setState(() => _error = t.passwordMismatch); return; }
    } else {
      // Login mode
      if (_loginMode == 'email') {
        if (_email.text.isEmpty) { setState(() => _error = t.fillAllFields); return; }
      } else {
        if (_phone.text.isEmpty) { setState(() => _error = t.fillAllFields); return; }
      }
    }

    setState(() { _loading = true; _error = null; });
    try {
      final fullPhone = '$_selectedCountryCode${_phone.text.replaceAll(RegExp(r'[^0-9]'), '')}';

      if (_isRegister) {
        // Auto-generate username from email prefix
        final username = _email.text.split('@').first.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
        final res = await ApiService.register({
          'full_name': _name.text, 'email': _email.text,
          'username': username,
          'password': _pass.text, 'password_confirmation': _confirmPass.text,
          'phone': fullPhone, 'country': _selectedCountryName, 'device_name': 'SDB App',
          'employment': _employment ?? '',
          'expected_annual_volume': _annualVolume ?? '',
          'currency': _currency,
        });
        if (res['success'] == true) {
          if (mounted) {
            await Navigator.pushNamed(context, '/phone-verify', arguments: fullPhone);
            if (mounted) {
              PushNotificationService.initialize();
              // After phone verify → go to KYC for document scan
              Navigator.pushReplacementNamed(context, '/kyc');
            }
          }
        } else {
          // Check if it's a duplicate account detection
          final action = res['data']?['action'];
          if (action == 'login_or_support' && mounted) {
            _showDuplicateDialog(res['data']?['message'] ?? 'هذا الحساب مرتبط بحساب آخر');
          } else {
            setState(() => _error = res['data']?['message'] ?? t.connectionError);
          }
        }
      } else {
        // Login — can be via email or phone
        final identifier = _loginMode == 'email' ? _email.text : fullPhone;
        final res = await ApiService.login(identifier, _pass.text.isNotEmpty ? _pass.text : 'phone_login');
        if (res['success'] == true) {
          if (mounted) {
            PushNotificationService.initialize();
            // Check user status — pending → pending screen
            final profile = await ApiService.getProfile();
            final user = profile['data']?['user'] ?? profile['data'];
            final status = user?['status'] ?? 'active';
            if (mounted) {
              if (status == 'pending') {
                Navigator.pushReplacementNamed(context, '/pending');
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            }
          }
        } else {
          setState(() => _error = res['data']?['message'] ?? t.connectionError);
        }
      }
    } catch (e) {
      setState(() => _error = L10n.of(context).connectionError);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _checkBiometric() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      final canCheck = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (mounted) setState(() => _canBiometric = canCheck);
      final hasToken = await ApiService.isLoggedIn();
      if (hasToken && canCheck && mounted) _biometricLogin();
    } catch (e) {
      debugPrint('Biometric check error: $e');
    }
  }

  Future<void> _biometricLogin() async {
    try {
      final didAuth = await _auth.authenticate(
        localizedReason: 'Sign in with Face ID or fingerprint',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      if (didAuth && mounted) {
        // Validate token with server before proceeding
        final profile = await ApiService.getProfile();
        if (profile['success'] == true && mounted) {
          PushNotificationService.initialize();
          final user = profile['data']?['user'] ?? profile['data'];
          final status = user?['status'] ?? 'active';
          if (status == 'pending') {
            Navigator.pushReplacementNamed(context, '/pending');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          // Token invalid — clear and stay on login
          await ApiService.logout();
        }
      }
    } on PlatformException catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    const bg = Colors.white;
    const cardBg = Color(0xFFF5F5F5);
    const borderC = Color(0xFFE5E5E5);
    const textW = Color(0xFF1A1A1A);
    const textMuted = Color(0xFF888888);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(children: [
              // Top help button
              if (!_isRegister) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
                    onTap: _showHelpDialog,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: borderC)),
                      child: const Icon(Icons.help_outline_rounded, color: textMuted, size: 18),
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(child: _isRegister
                // Register — scrollable (many fields)
                ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const SizedBox(height: 20),
                      Center(child: Image.asset('assets/images/sdb-logo.png', width: 180, fit: BoxFit.contain)),
                      const SizedBox(height: 16),
                      Center(child: Text(t.createAccount, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textW))),
                      const SizedBox(height: 20),
                      _buildDarkField(t.fullName, _name, Icons.person_outline_rounded, TextInputType.name, cardBg, borderC, textW, textMuted),
                      const SizedBox(height: 10),
                      _buildPhoneField(cardBg, borderC, textW, textMuted, t),
                      const SizedBox(height: 10),
                      _buildDarkField(t.email, _email, Icons.mail_outline_rounded, TextInputType.emailAddress, cardBg, borderC, textW, textMuted),
                      const SizedBox(height: 10),
                      _buildDarkField(t.password, _pass, Icons.lock_outline_rounded, TextInputType.visiblePassword, cardBg, borderC, textW, textMuted, isPass: true),
                      const SizedBox(height: 10),
                      _buildDarkField(t.confirmPassword, _confirmPass, Icons.lock_outline_rounded, TextInputType.visiblePassword, cardBg, borderC, textW, textMuted, isPass: true),
                      const SizedBox(height: 10),
                      // Employment type
                      _buildDropdown('الوظيفة / Employment', _employment, [
                        'موظف / Employed', 'أعمال حرة / Self-employed',
                        'طالب / Student', 'متقاعد / Retired', 'أخرى / Other',
                      ], (v) => setState(() => _employment = v), cardBg, borderC, textW, textMuted, Icons.work_outline_rounded),
                      const SizedBox(height: 10),
                      // Annual volume
                      _buildDropdown('حجم المعاملات السنوي المتوقع ($_currency)', _annualVolume, [
                        'أقل من 5,000 / Less than 5,000',
                        '5,000 - 25,000',
                        '25,000 - 100,000',
                        '100,000 - 500,000',
                        'أكثر من 500,000 / More than 500,000',
                      ], (v) => setState(() => _annualVolume = v), cardBg, borderC, textW, textMuted, Icons.bar_chart_rounded),
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: TextStyle(color: AppTheme.danger, fontSize: 12))),
                          ]),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildSubmitButton(t.register),
                      const SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(t.hasAccount, style: const TextStyle(color: textMuted, fontSize: 13)),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() { _isRegister = false; _error = null; }),
                          child: Text(t.signIn, style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ]),
                      const SizedBox(height: 30),
                    ]),
                  )
                // Login — fixed single screen, no scrolling
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Spacer(flex: 2),
                      // Logo
                      Center(child: Image.asset('assets/images/sdb-logo.png', width: 200, fit: BoxFit.contain)),
                      const SizedBox(height: 16),
                      // Title
                      Center(child: Text(t.login, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textW))),
                      const Spacer(),

                      // Email / Phone toggle
                      Container(
                        height: 44,
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderC)),
                        child: Row(children: [
                          _buildTab(t.email, 'email', textW, textMuted, cardBg),
                          _buildTab(t.phone, 'phone', textW, textMuted, cardBg),
                        ]),
                      ),
                      const SizedBox(height: 16),

                      // Input
                      if (_loginMode == 'email') ...[
                        _buildDarkField(t.email, _email, null, TextInputType.emailAddress, cardBg, borderC, textW, textMuted),
                        const SizedBox(height: 10),
                        _buildDarkField(t.password, _pass, null, TextInputType.visiblePassword, cardBg, borderC, textW, textMuted, isPass: true),
                      ] else ...[
                        _buildPhoneField(cardBg, borderC, textW, textMuted, t),
                      ],

                      // Error
                      if (_error != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: TextStyle(color: AppTheme.danger, fontSize: 11))),
                          ]),
                        ),
                      ],

                      const SizedBox(height: 18),
                      _buildSubmitButton(t.login),

                      const SizedBox(height: 18),
                      // Divider
                      Row(children: [
                        Expanded(child: Container(height: 0.5, color: borderC)),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 14), child: Text('or', style: TextStyle(fontSize: 12, color: textMuted))),
                        Expanded(child: Container(height: 0.5, color: borderC)),
                      ]),
                      const SizedBox(height: 18),
                      // Social buttons
                      _buildSocialButton('المتابعة مع Apple', Icons.apple, cardBg, borderC, textW),
                      const SizedBox(height: 8),
                      _buildSocialButton('المتابعة مع Google', null, cardBg, borderC, textW, isGoogle: true),

                      const Spacer(),
                      // Register link
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(t.noAccount, style: const TextStyle(color: textMuted, fontSize: 13)),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() { _isRegister = true; _error = null; }),
                          child: Text(t.openAccount, style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ]),
                      const SizedBox(height: 16),
                    ]),
                  ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // ─── Tab toggle ───
  Widget _buildTab(String label, String mode, Color textW, Color textMuted, Color cardBg) {
    final isActive = _loginMode == mode;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() { _loginMode = mode; _error = null; }),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8E8E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(4),
        child: Center(child: Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isActive ? textW : textMuted),
        )),
      ),
    ));
  }

  // ─── Submit button ───
  Widget _buildSubmitButton(String label) {
    return GestureDetector(
      onTap: _loading ? null : _submit,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xFF1A1A1A),
        ),
        child: Center(child: _loading
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
          : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ),
    );
  }

  // ─── Dropdown field ───
  Widget _buildDropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged,
      Color cardBg, Color borderC, Color textW, Color textMuted, IconData icon) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cardBg, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderC),
      ),
      child: Row(children: [
        Icon(icon, color: textMuted, size: 20),
        const SizedBox(width: 10),
        Expanded(child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            hint: Text(label, style: TextStyle(fontSize: 14, color: textMuted.withValues(alpha: 0.5))),
            isExpanded: true,
            dropdownColor: Colors.white,
            style: TextStyle(fontSize: 14, color: textW),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: textMuted, size: 20),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 13, color: textW)))).toList(),
            onChanged: onChanged,
          ),
        )),
      ]),
    );
  }

  // ─── Dark theme input field ───
  Widget _buildDarkField(String hint, TextEditingController ctrl, IconData? icon, TextInputType type,
      Color cardBg, Color borderC, Color textW, Color textMuted, {bool isPass = false}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cardBg,
        border: Border.all(color: borderC),
      ),
      child: TextField(
        controller: ctrl, obscureText: isPass && _obscure, keyboardType: type,
        style: TextStyle(color: textW, fontSize: 15),
        textDirection: type == TextInputType.emailAddress || type == TextInputType.visiblePassword ? TextDirection.ltr : null,
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: textMuted, fontSize: 14),
          prefixIcon: icon != null ? Icon(icon, color: textMuted, size: 20) : null,
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: icon == null ? 16 : 0),
          suffixIcon: isPass ? IconButton(
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: textMuted, size: 20),
            onPressed: () => setState(() => _obscure = !_obscure),
          ) : null,
        ),
      ),
    );
  }

  // ─── Phone input with country code ───
  Widget _buildPhoneField(Color cardBg, Color borderC, Color textW, Color textMuted, AppStrings t) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cardBg,
        border: Border.all(color: borderC),
      ),
      child: Row(children: [
        // Country code button
        GestureDetector(
          onTap: _showCountryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(border: Border(left: BorderSide(color: borderC))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(_selectedCountryFlag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 6),
              Text(_selectedCountryCode, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textW)),
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: textMuted),
            ]),
          ),
        ),
        // Phone input
        Expanded(child: TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textW),
          decoration: InputDecoration(
            hintText: t.phone,
            hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.5)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          ),
        )),
      ]),
    );
  }

  // ─── Social login button ───
  Widget _buildSocialButton(String label, IconData? icon, Color cardBg, Color borderC, Color textW, {bool isGoogle = false}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('سجّل حساب جديد أو استخدم بريدك الإلكتروني للدخول'),
          backgroundColor: AppTheme.primary,
          duration: const Duration(seconds: 2),
        ));
      },
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cardBg,
          border: Border.all(color: borderC),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (isGoogle) ...[
            Image.asset('assets/images/google-logo.png', width: 20, height: 20),
          ] else if (icon != null) ...[
            Icon(icon, color: textW, size: 22),
          ],
          const SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textW)),
        ]),
      ),
    );
  }

  void _showCountryPicker() {
    final t = L10n.of(context);
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (ctx) => Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
        const SizedBox(height: 16),
        Text(t.selectCountry, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
        const SizedBox(height: 16),
        Expanded(child: ListView.builder(
          itemCount: _countries.length,
          itemBuilder: (_, i) {
            final c = _countries[i];
            final isSelected = c['code'] == _selectedCountryCode;
            return ListTile(
              leading: Text(c['flag']!, style: const TextStyle(fontSize: 28)),
              title: Text(c['name']!, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF1A1A1A))),
              subtitle: Text(c['code']!, style: const TextStyle(fontSize: 13, color: Color(0xFF888888))),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 22) : null,
              onTap: () {
                setState(() {
                  _selectedCountryCode = c['code']!;
                  _selectedCountryName = c['name']!;
                  _selectedCountryFlag = c['flag']!;
                });
                Navigator.pop(ctx);
              },
            );
          },
        )),
      ]),
    ));
  }
}
