import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});
  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  String _otpValue = '';

  bool _codeSent = false;
  bool _loading = false;
  bool _verified = false;
  String? _error;
  int _countdown = 0;
  String _countryCode = '963';
  String _channel = 'sms'; // 'sms' or 'whatsapp'
  bool _isLoginOtp = false;

  @override
  void initState() {
    super.initState();
    _loadCountryCode();
  }

  Future<void> _loadCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('user_phone_code');
    if (code != null && mounted) {
      setState(() => _countryCode = code.replaceAll('+', ''));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      // Map args: {phone, codeSent, channel}
      if (_phoneCtrl.text.isEmpty) {
        final phone = args['phone'] as String? ?? '';
        _phoneCtrl.text = phone.replaceAll('+', '');
      }
      if (args['codeSent'] == true && !_codeSent) {
        _channel = (args['channel'] as String?) ?? 'sms';
        _isLoginOtp = args['isLogin'] == true;
        setState(() { _codeSent = true; _countdown = 60; });
        _startCountdown();
      }
    } else if (args is String && _phoneCtrl.text.isEmpty) {
      _phoneCtrl.text = args.replaceAll('+', '');
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String get _otp => _otpValue;

  Future<void> _sendCode() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) { setState(() => _error = 'يرجى إدخال رقم الهاتف'); return; }

    final fullPhone = phone.startsWith('+') ? phone : '+$phone';

    setState(() { _loading = true; _error = null; });

    try {
      if (_isLoginOtp) {
        final res = await ApiService.sendLoginOtp(fullPhone, _channel);
        if (res['success'] == true || res['data']?['success'] == true) {
          setState(() { _codeSent = true; _loading = false; _countdown = 60; });
          _startCountdown();
        } else {
          setState(() { _loading = false; _error = res['data']?['message'] ?? 'فشل إرسال رمز التحقق'; });
        }
      } else {
        final res = await ApiService.post('/verify/send', {
          'phone': fullPhone,
          'channel': _channel,
        });
        if (res['success'] == true || res['data']?['success'] == true) {
          setState(() { _codeSent = true; _loading = false; _countdown = 60; });
          _startCountdown();
        } else {
          setState(() { _loading = false; _error = res['data']?['message'] ?? 'فشل إرسال رمز التحقق'; });
        }
      }
    } catch (e) {
      setState(() { _loading = false; _error = 'خطأ في الاتصال بالسيرفر'; });
    }
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
      final phone = _phoneCtrl.text.trim().startsWith('+')
          ? _phoneCtrl.text.trim()
          : '+${_phoneCtrl.text.trim()}';

      if (_isLoginOtp) {
        final res = await ApiService.verifyLoginOtp(phone, _otp);
        if (res['success'] == true || res['data']?['verified'] == true) {
          setState(() { _verified = true; _loading = false; });
          if (mounted) {
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) Navigator.pop(context, true);
          }
        } else {
          setState(() { _loading = false; _error = res['data']?['message'] ?? 'رمز التحقق غير صحيح'; });
        }
      } else {
        final res = await ApiService.post('/verify/check', {
          'phone': phone,
          'code': _otp,
        });
        if (res['success'] == true || res['data']?['success'] == true || res['data']?['verified'] == true) {
          setState(() { _verified = true; _loading = false; });
          if (mounted) {
            await Future.delayed(const Duration(seconds: 2));
            if (mounted) Navigator.pop(context, true);
          }
        } else {
          setState(() { _loading = false; _error = res['data']?['message'] ?? 'رمز التحقق غير صحيح'; });
        }
      }
    } catch (e) {
      setState(() { _loading = false; _error = 'خطأ في الاتصال بالسيرفر'; });
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
      Center(child: Text('أدخل رقم هاتفك واختر طريقة استلام الرمز', textAlign: TextAlign.center,
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
            readOnly: _phoneCtrl.text.isNotEmpty,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, letterSpacing: 1),
            decoration: InputDecoration(
              hintText: '$_countryCode 9XX XXX XXX',
              hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.4)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          )),
          Icon(Icons.phone_rounded, color: AppTheme.textMuted, size: 20),
        ]),
      ),
      const SizedBox(height: 16),

      // ── Channel selector: SMS / WhatsApp ──
      Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          _buildChannelTab('sms', Icons.sms_rounded, 'SMS'),
          _buildChannelTab('whatsapp', Icons.chat_rounded, 'واتساب'),
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

      SizedBox(width: double.infinity, height: 54, child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: ElevatedButton(
          onPressed: _loading ? null : _sendCode,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: _loading
            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(_channel == 'whatsapp' ? Icons.chat_rounded : Icons.sms_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  _channel == 'whatsapp' ? 'إرسال عبر واتساب' : 'إرسال عبر SMS',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ]),
        ),
      )),
    ]);
  }

  Widget _buildChannelTab(String channel, IconData icon, String label) {
    final isActive = _channel == channel;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _channel = channel),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive
              ? (channel == 'whatsapp' ? const Color(0xFF25D366).withValues(alpha: 0.12) : AppTheme.primary.withValues(alpha: 0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: channel == 'whatsapp' ? const Color(0xFF25D366) : AppTheme.primary, width: 1.5)
              : null,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 20, color: isActive
              ? (channel == 'whatsapp' ? const Color(0xFF25D366) : AppTheme.primary)
              : AppTheme.textMuted),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(
            fontSize: 14, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? (channel == 'whatsapp' ? const Color(0xFF25D366) : AppTheme.primary)
                : AppTheme.textMuted,
          )),
        ]),
      ),
    ));
  }

  Widget _buildOTP() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 20),
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          color: (_channel == 'whatsapp' ? const Color(0xFF25D366) : const Color(0xFF10B981)).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          _channel == 'whatsapp' ? Icons.chat_rounded : Icons.sms_rounded,
          size: 40,
          color: _channel == 'whatsapp' ? const Color(0xFF25D366) : const Color(0xFF10B981),
        ),
      ),
      const SizedBox(height: 24),
      const Text('أدخل رمز التحقق', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 8),
      Text(
        'تم إرسال رمز مكون من 6 أرقام ${_channel == 'whatsapp' ? 'عبر واتساب' : 'عبر SMS'}\nإلى ${_phoneCtrl.text}',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.5),
      ),
      const SizedBox(height: 32),

      Directionality(textDirection: TextDirection.ltr, child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          controller: _otpCtrl,
          autoFocus: true,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          enableActiveFill: true,
          autoDisposeControllers: false,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(14),
            fieldHeight: 56,
            fieldWidth: 48,
            activeFillColor: AppTheme.bgCard,
            inactiveFillColor: AppTheme.bgCard,
            selectedFillColor: AppTheme.bgCard,
            activeColor: AppTheme.primary,
            inactiveColor: AppTheme.border,
            selectedColor: AppTheme.primary,
            borderWidth: 2,
          ),
          onChanged: (value) {
            setState(() => _otpValue = value);
          },
          onCompleted: (value) {
            _otpValue = value;
            _verifyCode();
          },
        ),
      )),
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
