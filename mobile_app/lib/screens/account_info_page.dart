import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'account_background_picker.dart';
import 'account_rename_page.dart';
import 'account_distribution_page.dart';

class AccountInfoPage extends StatefulWidget {
  final Map<String, dynamic> account;
  const AccountInfoPage({super.key, required this.account});
  @override
  State<AccountInfoPage> createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  late Map<String, dynamic> acc;

  @override
  void initState() {
    super.initState();
    acc = widget.account;
  }

  String _accountNumber() {
    final id = acc['id']?.toString() ?? '';
    final code = acc['currency']?['code'] ?? 'EUR';
    return 'SDB-${id.padLeft(10, '0')}';
  }

  String _iban() {
    final id = acc['id']?.toString() ?? '';
    return 'DK${id.padLeft(14, '0')}';
  }

  void _copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${L10n.of(context).copied} ✓'),
        backgroundColor: AppTheme.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final currency = acc['currency']?['code'] ?? 'EUR';
    final accountName = '${t.account} $currency';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Ocean Header with X and account info ──
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(children: [
                Positioned.fill(
                  child: CustomPaint(painter: _OceanHeaderPainter()),
                ),
                SafeArea(
                  child: Column(children: [
                    // Top bar: X close + title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.close_rounded, size: 20, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(accountName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                    const Spacer(),
                    // Avatar
                    Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0891B2).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Stack(alignment: Alignment.center, children: [
                        const Icon(Icons.people_rounded, size: 28, color: Colors.white),
                        Positioned(
                          bottom: 4, right: 4,
                          child: Container(
                            width: 20, height: 20,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E7490),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
                            ),
                            child: const Icon(Icons.image_rounded, size: 10, color: Colors.white),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    Text(accountName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                  ]),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 16),

          // ── Account Details Card ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              _infoRow(t.accountNumber, _accountNumber(), copyable: true),
              _divider(),
              _infoRow(t.iban, _iban(), copyable: true),
              _divider(),
              _infoRow(t.swiftBic, 'SDBSYDAM', copyable: true),
              _divider(),
              _infoRowMulti(t.bankAddress, [
                'SDB Bank',
                'بنك سوريا الرقمي',
                'دمشق، سوريا',
              ], copyable: true),
              _divider(),
              _infoNavRow(t.interestRate, '1 %', () {}),
            ]),
          ),
          const SizedBox(height: 28),

          // ── Manage Section (Lunar: "Administrer") ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(t.manage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              _manageRow(Icons.credit_card_rounded, t.navCards, trailing: '${(acc['cards_count'] ?? 1)}', onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
              }),
              _manageDivider(),
              _manageRow(Icons.upload_rounded, t.accountStatement, onTap: () => _showAccountStatement()),
              _manageDivider(),
              _manageRow(Icons.info_outline_rounded, t.distribution, onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => AccountDistributionPage(account: acc),
                ));
              }),
            ]),
          ),
          const SizedBox(height: 28),

          // ── Customize Section (Lunar: "Tilpas") ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(t.customize, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              _manageRow(Icons.image_rounded, t.editAppearance, onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => AccountBackgroundPicker(account: acc),
                ));
              }),
            ]),
          ),
          const SizedBox(height: 32),

          // ── Footer ──
          Center(child: Column(children: [
            Icon(Icons.verified_rounded, size: 24, color: AppTheme.primary),
            const SizedBox(height: 8),
            Text(
              t.moneyProtected,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted, height: 1.4),
            ),
            const SizedBox(height: 4),
            Text(t.learnMore, style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w500)),
          ])),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  // ── Info Row with copy button ──
  Widget _infoRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        ])),
        if (copyable)
          GestureDetector(
            onTap: () => _copy(value),
            child: Icon(Icons.copy_rounded, size: 18, color: AppTheme.primary),
          ),
      ]),
    );
  }

  Widget _infoRowMulti(String label, List<String> lines, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          ...lines.map((l) => Text(l, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
        ])),
        if (copyable)
          GestureDetector(
            onTap: () => _copy(lines.join('\n')),
            child: Icon(Icons.copy_rounded, size: 18, color: AppTheme.primary),
          ),
      ]),
    );
  }

  Widget _infoNavRow(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textMuted)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textMuted),
        ]),
      ),
    );
  }

  Widget _manageRow(IconData icon, String label, {String? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, size: 20, color: AppTheme.textSecondary),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          if (trailing != null) Text(trailing, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textMuted),
        ]),
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: AppTheme.border, indent: 16, endIndent: 16);
  Widget _manageDivider() => Divider(height: 1, color: AppTheme.border, indent: 50);

  void _showAccountStatement() async {
    final t = L10n.of(context);
    // Show loading
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return FutureBuilder<Map<String, dynamic>>(
          future: ApiService.getTransactions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
              );
            }
            final txs = List<Map<String, dynamic>>.from(snapshot.data?['data']?['data'] ?? []);
            final balance = acc['balance'] is num
                ? (acc['balance'] as num).toDouble()
                : double.tryParse(acc['balance'].toString()) ?? 0;
            final currency = acc['currency']?['code'] ?? 'EUR';
            final sym = {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[currency] ?? currency;

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.all(24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 16),
                Text(t.accountStatement, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 16),
                // Account summary card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF0A3D5C), Color(0xFF155E75)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_accountNumber(), style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('$sym${balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('${t.account} $currency', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                  ]),
                ),
                const SizedBox(height: 16),
                Text('${txs.length} ${t.recentTransfers}', style: TextStyle(fontSize: 13, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                // Transaction list
                Expanded(
                  child: txs.isEmpty
                      ? Center(child: Text(t.noTransactions, style: TextStyle(color: AppTheme.textMuted)))
                      : ListView.separated(
                          itemCount: txs.length > 20 ? 20 : txs.length,
                          separatorBuilder: (_, __) => Divider(height: 1, color: AppTheme.border),
                          itemBuilder: (_, i) {
                            final tx = txs[i];
                            final amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount'].toString()) ?? 0;
                            final isOut = ['withdrawal', 'card_payment', 'fee'].contains(tx['type']);
                            final desc = tx['description'] ?? tx['type'] ?? '';
                            final date = tx['created_at']?.toString().substring(0, 10) ?? '';
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(children: [
                                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(desc, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text(date, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                                ])),
                                Text(
                                  '${isOut ? '-' : '+'}$sym${amount.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isOut ? AppTheme.textPrimary : AppTheme.primary),
                                ),
                              ]),
                            );
                          },
                        ),
                ),
              ]),
            );
          },
        );
      },
    );
  }

  void _showRenameDialog() {
    final ctrl = TextEditingController(text: acc['name'] ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Rename Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(
            controller: ctrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Account name',
              filled: true,
              fillColor: AppTheme.bgMuted,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account renamed ✓'), backgroundColor: AppTheme.primary),
              );
            },
            child: const Text('Save'),
          )),
        ]),
      ),
    );
  }
}

// ── Small ocean header for info page ──
class _OceanHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0A3D5C),
          const Color(0xFF0C4A6E),
          const Color(0xFF155E75),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), basePaint);

    final wave1 = Paint()..color = const Color(0xFF0891B2).withValues(alpha: 0.2);
    final p1 = Path();
    p1.moveTo(0, h * 0.5);
    p1.cubicTo(w * 0.2, h * 0.4, w * 0.5, h * 0.6, w, h * 0.48);
    p1.lineTo(w, h);
    p1.lineTo(0, h);
    p1.close();
    canvas.drawPath(p1, wave1);

    final wave2 = Paint()..color = const Color(0xFF164E63).withValues(alpha: 0.4);
    final p2 = Path();
    p2.moveTo(0, h * 0.7);
    p2.cubicTo(w * 0.3, h * 0.6, w * 0.7, h * 0.75, w, h * 0.65);
    p2.lineTo(w, h);
    p2.lineTo(0, h);
    p2.close();
    canvas.drawPath(p2, wave2);

    final spot = Paint()..color = const Color(0xFF7DD3FC).withValues(alpha: 0.05);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.3, h * 0.25), width: w * 0.5, height: h * 0.3), spot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
