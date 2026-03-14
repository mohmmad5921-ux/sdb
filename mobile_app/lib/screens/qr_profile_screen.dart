import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class QrProfileScreen extends StatefulWidget {
  const QrProfileScreen({super.key});
  @override
  State<QrProfileScreen> createState() => _QrProfileScreenState();
}

class _QrProfileScreenState extends State<QrProfileScreen> {
  Map<String, dynamic>? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final r = await ApiService.getProfile();
    if (r['success'] == true && mounted) {
      setState(() { _user = r['data']?['user'] ?? r['data']; _loading = false; });
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }

  String _getQrData() {
    final username = _user?['username'] ?? '';
    final id = _user?['id'] ?? '';
    return 'sdb://pay/$username?id=$id';
  }

  void _shareQr() {
    final username = _user?['username'] ?? '';
    final name = _user?['full_name'] ?? '';
    final shareText = 'ادفع لي عبر SDB Bank!\nالاسم: $name\nالمستخدم: @$username\nhttps://sdb-bank.com/pay/$username';
    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${L10n.of(context).paymentLinkCopied} ✅'), backgroundColor: AppTheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(t.myQrCode, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        backgroundColor: AppTheme.bgLight,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : _buildMyQrCard(t),
    );
  }

  Widget _buildMyQrCard(AppStrings t) {
    final name = _user?['full_name'] ?? 'User';
    final username = _user?['username'] ?? '';
    final initials = _getInitials(name);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 10),
        // QR Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(children: [
            // User avatar
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(height: 14),
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            if (username.isNotEmpty) Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Text('@$username', style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 28),

            // QR Code with branded frame
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
              ),
              child: Column(children: [
                QrImageView(
                  data: _getQrData(),
                  version: QrVersions.auto,
                  size: 200,
                  eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF1A1A2E)),
                  dataModuleStyle: QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 12),
                // Branding below QR
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('SDB', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: 1.5)),
                  const SizedBox(width: 3),
                  Text('Bank', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppTheme.textMuted)),
                ]),
              ]),
            ),
            const SizedBox(height: 20),

            // Scan to pay me
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.qr_code_scanner_rounded, size: 16, color: AppTheme.primary),
                const SizedBox(width: 6),
                Text(t.scanToPayMe, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary)),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 24),

        // Share button
        GestureDetector(
          onTap: _shareQr,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.share_rounded, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Text(t.shareQr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ]),
          ),
        ),
      ]),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
