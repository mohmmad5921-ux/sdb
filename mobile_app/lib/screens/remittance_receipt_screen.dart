import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';

class RemittanceReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> remittance;
  const RemittanceReceiptScreen({super.key, required this.remittance});

  @override
  Widget build(BuildContext context) {
    final code = remittance['notification_code'] ?? '';
    final qrToken = remittance['qr_token'] ?? '';
    final recipientName = remittance['recipient_name'] ?? '';
    final recipientPhone = remittance['recipient_phone'] ?? '';
    final amount = remittance['amount'] ?? '0';
    final sendCurrency = remittance['send_currency'] ?? 'EUR';
    final receiveAmount = remittance['receive_amount'] ?? '0';
    final receiveCurrency = remittance['receive_currency'] ?? 'SYP';
    final fee = remittance['fee'] ?? '0';
    final expiresAt = remittance['expires_at'] ?? '';
    final agent = remittance['agent'];
    final agentName = agent?['name_ar'] ?? '';
    final district = agent?['district'];
    final governorate = district?['governorate'];
    final location = '${governorate?['name_ar'] ?? ''} - ${district?['name_ar'] ?? ''}';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textSecondary),
                ),
              ),
              const Spacer(),
              const Text('إيصال الحوالة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const Spacer(),
              const SizedBox(width: 36),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Success
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.08), shape: BoxShape.circle),
                  child: const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 44),
                ),
                const SizedBox(height: 10),
                Text('تم إرسال الحوالة بنجاح! ✅', style: TextStyle(color: AppTheme.success, fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('شارك الإيصال مع المستلم عبر واتساب', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                const SizedBox(height: 16),

                // Receipt Card with watermark
                Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(children: [
                      // SDB Logo header
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/sdb-logo.png', width: 28, height: 28, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 8),
                        const Text('SDB BANK', style: TextStyle(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2)),
                      ]),
                      const SizedBox(height: 14),

                      // QR Code
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.bgMuted,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: QrImageView(data: qrToken, version: QrVersions.auto, size: 140, backgroundColor: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // Notification Code
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.tag, color: AppTheme.primary, size: 16),
                          const SizedBox(width: 4),
                          Text(code, style: TextStyle(color: AppTheme.primary, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 4, fontFamily: 'monospace')),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: code));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرقم')));
                            },
                            child: Icon(Icons.copy_rounded, color: AppTheme.primary, size: 16),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 16),

                      // Details
                      const Divider(color: AppTheme.border),
                      _row('المستلم', recipientName, Icons.person_outline_rounded),
                      _row('هاتف المستلم', recipientPhone, Icons.phone_outlined),
                      _row('الموقع', location, Icons.location_on_outlined),
                      _row('مكتب الوكيل', agentName, Icons.store_outlined),
                      const Divider(color: AppTheme.border),
                      _row('المبلغ المرسل', '$amount $sendCurrency', Icons.arrow_upward_rounded),
                      _row('العمولة', '$fee $sendCurrency', Icons.percent_rounded),
                      _row('المستلم يحصل على', '$receiveAmount $receiveCurrency', Icons.arrow_downward_rounded, valueColor: AppTheme.success, bold: true),
                      const Divider(color: AppTheme.border),
                      _row('الحالة', 'جاهزة للسحب ✅', Icons.check_circle_outline, valueColor: AppTheme.success),
                      if (expiresAt.isNotEmpty)
                        _row('صلاحية', '72 ساعة', Icons.schedule, valueColor: Colors.amber.shade700),
                    ]),
                  ),
                  // SDB Gold Logo Watermark (semi-transparent)
                  Positioned.fill(
                    child: Center(
                      child: Opacity(
                        opacity: 0.06,
                        child: Image.asset('assets/sdb-logo.png', width: 200, height: 200, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),

                // Share buttons
                Row(children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => _shareWhatsApp(context),
                        icon: const Text('📱', style: TextStyle(fontSize: 16)),
                        label: const Text('مشاركة واتساب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48, height: 48,
                    child: ElevatedButton(
                      onPressed: () => _shareGeneric(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.bgMuted,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.zero,
                        elevation: 0,
                      ),
                      child: const Icon(Icons.share_rounded, color: AppTheme.textSecondary, size: 20),
                    ),
                  ),
                ]),
                const SizedBox(height: 10),

                // Done
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primary),
                      foregroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _row(String label, String value, IconData icon, {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon, size: 15, color: AppTheme.textMuted),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        const Spacer(),
        Flexible(child: Text(value, style: TextStyle(
          color: valueColor ?? AppTheme.textPrimary,
          fontSize: bold ? 15 : 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ), textAlign: TextAlign.left)),
      ]),
    );
  }

  String _shareText() {
    final code = remittance['notification_code'] ?? '';
    final name = remittance['recipient_name'] ?? '';
    final receiveAmount = remittance['receive_amount'] ?? '0';
    final receiveCurrency = remittance['receive_currency'] ?? 'SYP';
    final agent = remittance['agent'];
    final agentName = agent?['name_ar'] ?? '';
    final district = agent?['district'];
    final governorate = district?['governorate'];
    final location = '${governorate?['name_ar'] ?? ''} - ${district?['name_ar'] ?? ''}';

    return '''
🏦 *SDB Bank — إيصال حوالة*

مرحباً *$name*!
تم إرسال حوالة لك عبر بنك SDB 💰

📍 *الموقع:* $location
🏬 *مكتب الوكيل:* $agentName
💵 *المبلغ:* $receiveAmount $receiveCurrency

🔐 *رقم الإشعار:* `$code`

✅ توجه لمكتب الوكيل وأعرض رقم الإشعار لسحب المبلغ
⏱️ صلاحية الحوالة: 72 ساعة

_SDB Bank — أول بنك إلكتروني سوري_ 🇸🇾
''';
  }

  void _shareWhatsApp(BuildContext context) {
    Share.share(_shareText(), subject: 'SDB Bank — إيصال حوالة');
  }

  void _shareGeneric(BuildContext context) {
    Share.share(_shareText(), subject: 'SDB Bank — إيصال حوالة');
  }
}
