import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;
  bool _isRegister = false;
  final _name = TextEditingController();
  final _confirmPass = TextEditingController();
  final _phone = TextEditingController();

  Future<void> _submit() async {
    if (_email.text.isEmpty || _pass.text.isEmpty) { setState(() => _error = 'يرجى ملء جميع الحقول'); return; }
    if (_isRegister && _pass.text != _confirmPass.text) { setState(() => _error = 'كلمة المرور غير متطابقة'); return; }
    setState(() { _loading = true; _error = null; });
    try {
      final res = _isRegister
        ? await ApiService.register({'name': _name.text, 'email': _email.text, 'password': _pass.text, 'password_confirmation': _confirmPass.text, 'phone': _phone.text})
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
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF0A1628), AppTheme.bgDark])),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const SizedBox(height: 40),
              // Logo
              Center(child: Container(
                width: 70, height: 70,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 25, offset: const Offset(0, 8))]),
                child: const Center(child: Text('SDB', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2))),
              )),
              const SizedBox(height: 24),
              Center(child: Text(_isRegister ? 'إنشاء حساب جديد' : 'مرحباً بعودتك', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white))),
              const SizedBox(height: 6),
              Center(child: Text(_isRegister ? 'افتح حسابك الرقمي في دقائق' : 'سجّل دخولك للمتابعة', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.4)))),
              const SizedBox(height: 36),
              // Form
              if (_isRegister) ...[
                _buildField('الاسم الكامل', _name, Icons.person_outline),
                const SizedBox(height: 14),
                _buildField('رقم الهاتف', _phone, Icons.phone_outlined, type: TextInputType.phone),
                const SizedBox(height: 14),
              ],
              _buildField('البريد الإلكتروني', _email, Icons.email_outlined, type: TextInputType.emailAddress),
              const SizedBox(height: 14),
              _buildField('كلمة المرور', _pass, Icons.lock_outline, isPass: true),
              if (_isRegister) ...[
                const SizedBox(height: 14),
                _buildField('تأكيد كلمة المرور', _confirmPass, Icons.lock_outline, isPass: true),
              ],
              if (_error != null) ...[
                const SizedBox(height: 14),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.danger.withValues(alpha: 0.2))),
                  child: Text(_error!, style: const TextStyle(color: AppTheme.danger, fontSize: 13), textAlign: TextAlign.center)),
              ],
              const SizedBox(height: 24),
              // Submit Button
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFF3B82F6)]),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 6))]),
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: _loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_isRegister ? 'إنشاء حساب' : 'تسجيل الدخول', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
              // Toggle
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(_isRegister ? 'عندك حساب؟' : 'ما عندك حساب؟', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13)),
                TextButton(onPressed: () => setState(() { _isRegister = !_isRegister; _error = null; }),
                  child: Text(_isRegister ? 'سجّل دخول' : 'افتح حساب', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 13))),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController ctrl, IconData icon, {bool isPass = false, TextInputType type = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border), color: Colors.white.withValues(alpha: 0.04)),
      child: TextField(
        controller: ctrl, obscureText: isPass && _obscure, keyboardType: type, style: const TextStyle(color: Colors.white, fontSize: 15),
        textDirection: type == TextInputType.emailAddress ? TextDirection.ltr : TextDirection.rtl,
        decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          suffixIcon: isPass ? IconButton(icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppTheme.textMuted, size: 20), onPressed: () => setState(() => _obscure = !_obscure)) : null),
      ),
    );
  }
}
