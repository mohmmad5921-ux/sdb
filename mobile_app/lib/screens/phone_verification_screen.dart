import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});
  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrls = List.generate(6, (_) => TextEditingController());
  final _otpFocus = List.generate(6, (_) => FocusNode());

  bool _codeSent = false;
  bool _loading = false;
  bool _verified = false;
  String? _error;
  String _verificationId = '';
  int? _resendToken;
  int _countdown = 0;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    for (var c in _otpCtrls) c.dispose();
    for (var f in _otpFocus) f.dispose();
    super.dispose();
  }

  String get _otp => _otpCtrls.map((c) => c.text).join();

  Future<void> _sendCode() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) { setState(() => _error = 'يرجى إدخال رقم الهاتف'); return; }

    // Ensure it starts with +
    final fullPhone = phone.startsWith('+') ? phone : '+$phone';

    setState(() { _loading = true; _error = null; });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhone,
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android only)
        await _verifyWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _loading = false;
          _error = e.message ?? 'فشل إرسال رمز التحقق';
        });
      },
      codeSent: (String vId, int? resendToken) {
        setState(() {
          _verificationId = vId;
          _resendToken = resendToken;
          _codeSent = true;
          _loading = false;
          _countdown = 60;
        });
        _startCountdown();
      },
      codeAutoRetrievalTimeout: (String vId) {
        _verificationId = vId;
      },
    );
  }

  void _startCountdown() async {
    while (_countdown > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) setState(() => _countdown--);
    }
  }

  Future<void> _verifyCode() async {
    if (_otp.length != 6) { setState(() => _error = 'يرجى إدخال الرمز كاملاً'); return; }

    setState(() { _loading = true; _error = null; });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otp,
      );
      await _verifyWithCredential(credential);
    } catch (e) {
      setState(() { _loading = false; _error = 'رمز التحقق غير صحيح'; });
    }
  }

  Future<void> _verifyWithCredential(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() { _verified = true; _loading = false; });

      // Update phone verification status on backend
      final phone = _phoneCtrl.text.trim().startsWith('+') ? _phoneCtrl.text.trim() : '+${_phoneCtrl.text.trim()}';
      await ApiService.updateProfile({'phone': phone, 'phone_verified': true});

      if (mounted) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() { _loading = false; _error = 'فشل التحقق من الرمز'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('تأكيد رقم الهاتف', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تخطي', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
          ),
        ],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24),
        child: _verified ? _buildSuccess() : _codeSent ? _buildOTP() : _buildPhoneInput(),
      )),
    );
  }

  Widget _buildPhoneInput() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 20),
      // Icon
      Center(child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(Icons.phone_android_rounded, size: 40, color: AppTheme.primary),
      )),
      const SizedBox(height: 24),
      const Center(child: Text('تأكيد رقم الهاتف', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
      const SizedBox(height: 8),
      Center(child: Text('أدخل رقم هاتفك وسنرسل لك رمز تحقق عبر SMS', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5))),
      const SizedBox(height: 32),

      // Phone input
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
          const SizedBox(width: 4),
          Expanded(child: TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, letterSpacing: 1),
            decoration: InputDecoration(
              hintText: '963 9XX XXX XXX',
              hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.4)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          )),
          Icon(Icons.phone_rounded, color: AppTheme.textMuted, size: 20),
        ]),
      ),
      const SizedBox(height: 16),

      if (_error != null) Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(_error!, style: TextStyle(fontSize: 12, color: AppTheme.danger))),
        ]),
      ),
      const SizedBox(height: 24),

      // Send button
      SizedBox(width: double.infinity, height: 54, child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [Color(0xFF1E5EFF), Color(0xFF3B82F6)]),
          boxShadow: [BoxShadow(color: const Color(0xFF1E5EFF).withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: ElevatedButton(
          onPressed: _loading ? null : _sendCode,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: _loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : const Text('إرسال رمز التحقق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      )),
    ]);
  }

  Widget _buildOTP() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 20),
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(24)),
        child: const Icon(Icons.sms_rounded, size: 40, color: Color(0xFF10B981)),
      ),
      const SizedBox(height: 24),
      const Text('أدخل رمز التحقق', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 8),
      Text('تم إرسال رمز مكون من 6 أرقام إلى\n${_phoneCtrl.text}', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5)),
      const SizedBox(height: 32),

      // OTP fields
      Directionality(textDirection: TextDirection.ltr, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) =>
        Container(
          width: 48, height: 56,
          margin: EdgeInsets.symmetric(horizontal: i == 3 ? 8 : 4),
          child: TextField(
            controller: _otpCtrls[i],
            focusNode: _otpFocus[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primary, width: 2)),
              filled: true,
              fillColor: AppTheme.bgCard,
            ),
            onChanged: (v) {
              if (v.isNotEmpty && i < 5) _otpFocus[i + 1].requestFocus();
              if (v.isEmpty && i > 0) _otpFocus[i - 1].requestFocus();
            },
          ),
        ),
      ))),
      const SizedBox(height: 16),

      if (_error != null) Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18),
          const SizedBox(width: 8),
          Text(_error!, style: TextStyle(fontSize: 12, color: AppTheme.danger)),
        ]),
      ),
      const SizedBox(height: 24),

      // Verify button
      SizedBox(width: double.infinity, height: 54, child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: ElevatedButton(
          onPressed: _loading ? null : _verifyCode,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: _loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : const Text('تأكيد الرمز', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      )),

      const SizedBox(height: 20),
      // Resend
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('لم تستلم الرمز؟ ', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        GestureDetector(
          onTap: _countdown == 0 ? _sendCode : null,
          child: Text(
            _countdown > 0 ? 'إعادة الإرسال ($_countdown)' : 'إعادة الإرسال',
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: _countdown > 0 ? AppTheme.textMuted : AppTheme.primary,
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildSuccess() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.check_circle_rounded, size: 56, color: Color(0xFF10B981)),
      ),
      const SizedBox(height: 24),
      const Text('تم التحقق بنجاح!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
      const SizedBox(height: 8),
      Text('تم تأكيد رقم هاتفك بنجاح', style: TextStyle(fontSize: 15, color: AppTheme.textMuted)),
      const SizedBox(height: 8),
      Text('جاري الانتقال...', style: TextStyle(fontSize: 12, color: AppTheme.textMuted.withValues(alpha: 0.5))),
    ]));
  }
}
