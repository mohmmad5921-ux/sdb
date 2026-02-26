import 'package:flutter/material.dart';
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
      final res = _isRegister
        ? await ApiService.register({'name': _name.text, 'email': _email.text, 'password': _pass.text, 'password_confirmation': _confirmPass.text, 'phone': _phone.text, 'device_name': 'SDB App'})
        : await ApiService.login(_email.text, _pass.text);
      if (res['success'] == true) {
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0A1628), Color(0xFF060B18)])),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const SizedBox(height: 50),
                // Logo Section
                Center(child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E5EFF), Color(0xFF00C2FF)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF1E5EFF).withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 12))],
                  ),
                  child: const Center(child: Text('SDB', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2))),
                )),
                const SizedBox(height: 28),
                Center(child: Text(_isRegister ? 'إنشاء حساب جديد' : 'مرحباً بعودتك', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white))),
                const SizedBox(height: 6),
                Center(child: Text(_isRegister ? 'افتح حسابك الرقمي خلال دقائق' : 'سجّل دخولك للوصول لحسابك', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.35)))),
                const SizedBox(height: 40),

                // Form Fields
                if (_isRegister) ...[
                  _buildField('الاسم الكامل', _name, Icons.person_outline_rounded, TextInputType.name),
                  const SizedBox(height: 14),
                  _buildField('رقم الهاتف', _phone, Icons.phone_outlined, TextInputType.phone),
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

                // Error
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.danger.withValues(alpha: 0.15))),
                    child: Row(children: [
                      Icon(Icons.error_outline_rounded, color: AppTheme.danger.withValues(alpha: 0.7), size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_error!, style: TextStyle(color: AppTheme.danger.withValues(alpha: 0.8), fontSize: 12))),
                    ]),
                  ),
                ],

                const SizedBox(height: 24),
                // Submit
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [Color(0xFF1E5EFF), Color(0xFF3B82F6)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF1E5EFF).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
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

                // Divider
                Row(children: [
                  Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.06))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('أو', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.2)))),
                  Expanded(child: Container(height: 1, color: Colors.white.withValues(alpha: 0.06))),
                ]),

                const SizedBox(height: 20),
                // Biometric Login
                if (!_isRegister) Container(
                  height: 52,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.06)), color: Colors.white.withValues(alpha: 0.02)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.fingerprint_rounded, color: Colors.white.withValues(alpha: 0.4), size: 22),
                    const SizedBox(width: 10),
                    Text('الدخول بالبصمة', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.4), fontWeight: FontWeight.w500)),
                  ]),
                ),

                const SizedBox(height: 24),
                // Toggle
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_isRegister ? 'عندك حساب؟ ' : 'ما عندك حساب؟ ', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
                  GestureDetector(
                    onTap: () => setState(() { _isRegister = !_isRegister; _error = null; }),
                    child: Text(_isRegister ? 'سجّل دخول' : 'افتح حساب', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ]),
                const SizedBox(height: 30),

                // Footer
                Center(child: Text('بتسجيلك توافق على الشروط وسياسة الخصوصية', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.15)))),
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
        color: Colors.white.withValues(alpha: 0.03),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: TextField(
        controller: ctrl, obscureText: isPass && _obscure, keyboardType: type,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        textDirection: type == TextInputType.emailAddress || type == TextInputType.visiblePassword ? TextDirection.ltr : TextDirection.rtl,
        decoration: InputDecoration(
          hintText: hint, hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.2), size: 20),
          border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: isPass ? IconButton(
            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white.withValues(alpha: 0.2), size: 20),
            onPressed: () => setState(() => _obscure = !_obscure),
          ) : null,
        ),
      ),
    );
  }
}
