import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: const Text('إيصال الحوالة', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success badge
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Color(0xFF00D4AA), size: 48),
            ),
            const SizedBox(height: 12),
            const Text('تم إرسال الحوالة بنجاح! ✅', style: TextStyle(color: Color(0xFF00D4AA), fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('شارك الإيصال مع المستلم عبر واتساب', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
            const SizedBox(height: 20),

            // Receipt Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A3A5C), Color(0xFF0D2137)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00D4AA).withOpacity(0.08), blurRadius: 30, spreadRadius: 5),
                ],
              ),
              child: Column(
                children: [
                  // SDB Logo + Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D4AA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(child: Text('SDB', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 8),
                      const Text('SDB SECURE', style: TextStyle(color: Color(0xFF00D4AA), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: qrToken,
                      version: QrVersions.auto,
                      size: 160,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.roundedRect, color: Color(0xFF0A1628)),
                      dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.roundedRect, color: Color(0xFF0A1628)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Notification Code
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tag, color: Color(0xFF00D4AA), size: 18),
                        const SizedBox(width: 6),
                        Text(code, style: const TextStyle(color: Color(0xFF00D4AA), fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4, fontFamily: 'monospace')),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرقم')));
                          },
                          child: const Icon(Icons.copy, color: Color(0xFF00D4AA), size: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details
                  const Divider(color: Colors.white24),
                  _receiptRow('المستلم', recipientName, Icons.person_outline),
                  _receiptRow('هاتف المستلم', recipientPhone, Icons.phone_outlined),
                  _receiptRow('الموقع', location, Icons.location_on_outlined),
                  _receiptRow('مكتب الوكيل', agentName, Icons.store_outlined),
                  const Divider(color: Colors.white24),
                  _receiptRow('المبلغ المرسل', '$amount $sendCurrency', Icons.arrow_upward),
                  _receiptRow('العمولة', '$fee $sendCurrency', Icons.percent),
                  _receiptRow('المستلم يحصل على', '$receiveAmount $receiveCurrency', Icons.arrow_downward, valueColor: const Color(0xFF00D4AA), bold: true),
                  const Divider(color: Colors.white24),
                  _receiptRow('الحالة', 'جاهزة للسحب ✅', Icons.check_circle_outline, valueColor: const Color(0xFF00D4AA)),
                  if (expiresAt.isNotEmpty)
                    _receiptRow('صلاحية', '72 ساعة', Icons.schedule, valueColor: Colors.amber),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Share buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _shareWhatsApp(context),
                      icon: const Text('📱', style: TextStyle(fontSize: 18)),
                      label: const Text('مشاركة واتساب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 50, height: 50,
                  child: ElevatedButton(
                    onPressed: () => _shareGeneric(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A2A44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.share, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Done button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF00D4AA)),
                  foregroundColor: const Color(0xFF00D4AA),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('العودة للرئيسية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, IconData icon, {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white.withOpacity(0.4)),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
          const Spacer(),
          Text(value, style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          )),
        ],
      ),
    );
  }

  String _shareText() {
    final code = remittance['notification_code'] ?? '';
    final name = remittance['recipient_name'] ?? '';
    final receiveAmount = remittance['receive_amount'] ?? '0';
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
💵 *المبلغ:* $receiveAmount ل.س

🔐 *رقم الإشعار:* `$code`

✅ توجه لمكتب الوكيل وأعرض رقم الإشعار لسحب المبلغ
⏱️ صلاحية الحوالة: 72 ساعة

_SDB Bank — أول بنك إلكتروني سوري_ 🇸🇾
''';
  }

  void _shareWhatsApp(BuildContext context) {
    final phone = remittance['recipient_phone'] ?? '';
    final text = Uri.encodeComponent(_shareText());
    final cleanPhone = phone.replaceAll('+', '').replaceAll(' ', '');
    final url = 'https://wa.me/$cleanPhone?text=$text';
    // Use url_launcher or share_plus
    Share.share(_shareText(), subject: 'SDB Bank — إيصال حوالة');
  }

  void _shareGeneric(BuildContext context) {
    Share.share(_shareText(), subject: 'SDB Bank — إيصال حوالة');
  }
}
