import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

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
  String? _error;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  // Country picker data
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
  }

  @override
  void dispose() { _animCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) { setState(() => _error = 'يرجى ملء جميع الحقول'); return; }
    if (_isRegister && _pass.text != _confirmPass.text) { setState(() => _error = 'كلمة المرور غير متطابقة'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final fullPhone = '$_selectedCountryCode${_phone.text.replaceAll(RegExp(r'[^0-9]'), '')}';
      final res = _isRegister
        ? await ApiService.register({'full_name': _name.text, 'email': _email.text, 'password': _pass.text, 'password_confirmation': _confirmPass.text, 'phone': fullPhone, 'country': _selectedCountryName, 'device_name': 'SDB App'})
        : await ApiService.login(_email.text, _pass.text);
      if (res['success'] == true) {
        if (_isRegister) {
          // After registration → phone verification
          if (mounted) {
            await Navigator.pushNamed(context, '/phone-verify');
            if (mounted) Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          if (mounted) Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() => _error = res['data']?['message'] ?? 'فشل في ${_isRegister ? "إنشاء الحساب" : "تسجيل الدخول"}');
      }
    } catch (e) {
      setState(() => _error = 'خطأ في الاتصال بالسيرفر');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const SizedBox(height: 50),
                // Logo
                Center(child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E5EFF), Color(0xFF00C2FF)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF1E5EFF).withValues(alpha: 0.25), blurRadius: 30, offset: const Offset(0, 12))],
                  ),
                  child: const Center(child: Text('SDB', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2))),
                )),
                const SizedBox(height: 28),
                Center(child: Text(_isRegister ? 'إنشاء حساب جديد' : 'مرحباً بعودتك', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
                const SizedBox(height: 6),
                Center(child: Text(_isRegister ? 'افتح حسابك الرقمي خلال دقائق' : 'سجّل دخولك للوصول لحسابك', style: TextStyle(fontSize: 13, color: AppTheme.textMuted))),
                const SizedBox(height: 40),

                if (_isRegister) ...[
                  _buildField('الاسم الكامل', _name, Icons.person_outline_rounded, TextInputType.name),
                  const SizedBox(height: 14),
                  // Country picker + Phone
                  Container(
                    decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                    child: Row(children: [
                      // Country selector
                      GestureDetector(
                        onTap: _showCountryPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          decoration: BoxDecoration(border: Border(left: BorderSide(color: AppTheme.border))),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(_selectedCountryFlag, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(_selectedCountryCode, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                            const SizedBox(width: 2),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textMuted),
                          ]),
                        ),
                      ),
                      // Phone input
                      Expanded(child: TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'رقم الهاتف',
                          hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        ),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 14),
                ],
                _buildField('البريد الإلكتروني', _email, Icons.mail_outline_rounded, TextInputType.emailAddress),
                const SizedBox(height: 14),
                _buildField('كلمة المرور', _pass, Icons.lock_outline_rounded, TextInputType.visiblePassword, isPass: true),
                if (_isRegister) ...[
                  const SizedBox(height: 14),
                  _buildField('تأكيد كلمة المرور', _confirmPass, Icons.lock_outline_rounded, TextInputType.visiblePassword, isPass: true),
                ],

                if (!_isRegister) ...[
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerLeft, child: TextButton(
                    onPressed: () {},
                    child: Text('نسيت كلمة المرور؟', style: TextStyle(fontSize: 12, color: AppTheme.primary.withValues(alpha: 0.7))),
                  )),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.danger.withValues(alpha: 0.15))),
                    child: Row(children: [
                      Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_error!, style: TextStyle(color: AppTheme.danger, fontSize: 12))),
                    ]),
                  ),
                ],

                const SizedBox(height: 24),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [Color(0xFF1E5EFF), Color(0xFF3B82F6)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF1E5EFF).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                    child: _loading
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                      : Text(_isRegister ? 'إنشاء حساب' : 'تسجيل الدخول', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 24),

                Row(children: [
                  Expanded(child: Container(height: 1, color: AppTheme.border)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('أو', style: TextStyle(fontSize: 12, color: AppTheme.textMuted))),
                  Expanded(child: Container(height: 1, color: AppTheme.border)),
                ]),

                const SizedBox(height: 20),
                if (!_isRegister) Container(
                  height: 52,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border), color: AppTheme.bgCard),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.fingerprint_rounded, color: AppTheme.textMuted, size: 22),
                    const SizedBox(width: 10),
                    Text('الدخول بالبصمة', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                  ]),
                ),

                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_isRegister ? 'عندك حساب؟ ' : 'ما عندك حساب؟ ', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  GestureDetector(
                    onTap: () => setState(() { _isRegister = !_isRegister; _error = null; }),
                    child: Text(_isRegister ? 'سجّل دخول' : 'افتح حساب', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ]),
                const SizedBox(height: 30),

                Center(child: Text('بتسجيلك توافق على الشروط وسياسة الخصوصية', style: TextStyle(fontSize: 10, color: AppTheme.textMuted.withValues(alpha: 0.5)))),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController ctrl, IconData icon, TextInputType type, {bool isPass = false}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.bgSurface,
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        controller: ctrl, obscureText: isPass && _obscure, keyboardType: type,
        style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
        textDirection: type == TextInputType.emailAddress || type == TextInputType.visiblePassword ? TextDirection.ltr : TextDirection.rtl,
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20),
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: isPass ? IconButton(
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.textMuted, size: 20),
            onPressed: () => setState(() => _obscure = !_obscure),
          ) : null,
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (ctx) => Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
        const SizedBox(height: 16),
        const Text('اختر الدولة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 16),
        Expanded(child: ListView.builder(
          itemCount: _countries.length,
          itemBuilder: (_, i) {
            final c = _countries[i];
            final isSelected = c['code'] == _selectedCountryCode;
            return ListTile(
              leading: Text(c['flag']!, style: const TextStyle(fontSize: 28)),
              title: Text(c['name']!, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: AppTheme.textPrimary)),
              subtitle: Text(c['code']!, style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              trailing: isSelected ? Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 22) : null,
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
