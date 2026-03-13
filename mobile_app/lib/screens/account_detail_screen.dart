import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'account_info_page.dart';
import 'account_background_picker.dart';

class AccountDetailScreen extends StatefulWidget {
  final Map<String, dynamic> account;
  const AccountDetailScreen({super.key, required this.account});
  @override
  State<AccountDetailScreen> createState() => _AccountDetailScreenState();
}

class _AccountDetailScreenState extends State<AccountDetailScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;
  int _bgIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadBackground();
  }

  Future<void> _loadBackground() async {
    final idx = await AccountBackgroundPicker.getSavedBgIndex(widget.account['id'] ?? 0);
    if (mounted) setState(() => _bgIndex = idx);
  }

  Future<void> _loadTransactions() async {
    final r = await ApiService.getTransactions();
    if (mounted) {
      setState(() {
        if (r['success'] == true) {
          _transactions = List<Map<String, dynamic>>.from(r['data']?['data'] ?? []);
        }
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final balance = (widget.account['balance'] is num)
        ? (widget.account['balance'] as num).toDouble()
        : double.tryParse(widget.account['balance'].toString()) ?? 0;
    final currency = widget.account['currency']?['code'] ?? 'EUR';
    final symbol = _sym(currency);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: Colors.white,
        onRefresh: _loadTransactions,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            // ── Ocean Background Header ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: Stack(children: [
                  // Dynamic background based on saved preference
                  Positioned.fill(
                    child: _buildDynamicBackground(),
                  ),

                  // Content
                  SafeArea(
                    child: Column(children: [
                      // Top bar: back + search
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.search_rounded, size: 18, color: Colors.white),
                          ),
                        ]),
                      ),

                      const Spacer(),

                      // Account name
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.person, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                        const SizedBox(width: 6),
                        Text(
                          '${t.account} $currency',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ]),
                      const SizedBox(height: 8),

                      // Big balance
                      Text(
                        '$symbol${_formatNum(balance)}',
                        style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                      ),

                      const Spacer(),

                      // 4 circular action buttons (Lunar style)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                          _circleAction(Icons.swap_vert_rounded, t.send, () => Navigator.pushNamed(context, '/transfer')),
                          _circleAction(Icons.credit_card_rounded, t.navCards, () {}),
                          _circleAction(Icons.add_rounded, t.addMoney, () => Navigator.pushNamed(context, '/deposit')),
                          _circleAction(Icons.info_outline_rounded, t.details, () async {
                            await Navigator.push(context, MaterialPageRoute(
                              builder: (_) => AccountInfoPage(account: widget.account),
                            ));
                            _loadBackground();
                          }),
                        ]),
                      ),
                    ]),
                  ),
                ]),
              ),
            ),

            // ── Transactions List ──
            if (_loading)
              const Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator(color: AppTheme.primary))
            else if (_transactions.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Column(children: [
                  Icon(Icons.receipt_long_rounded, size: 48, color: AppTheme.textMuted),
                  const SizedBox(height: 12),
                  Text(t.noTransactions, style: const TextStyle(color: AppTheme.textMuted, fontSize: 14)),
                ]),
              )
            else
              ..._buildGroupedTransactions(),

            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  // ── Dynamic Background based on saved preference ──
  Widget _buildDynamicBackground() {
    final bgColors = AccountBackgroundPicker.getBgColors(_bgIndex);
    final hasWaves = AccountBackgroundPicker.hasBgWaves(_bgIndex);
    final bgImage = AccountBackgroundPicker.getBgImage(_bgIndex);

    return Stack(children: [
      // Base: either image or gradient
      if (bgImage != null) ...[
        Positioned.fill(child: Image.asset(bgImage, fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.3))),
      ] else
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: bgColors,
              ),
            ),
          ),
        ),
      // Wave overlay for ocean-style
      if (hasWaves) Positioned.fill(child: CustomPaint(painter: _OceanDetailPainter())),
    ]);
  }

  // ── Circular Action Button (Lunar style) ──
  Widget _circleAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ── Grouped Transactions by Date (Lunar style) ──
  List<Widget> _buildGroupedTransactions() {
    final Map<String, List<Map<String, dynamic>>> groups = {};
    for (final tx in _transactions) {
      final dateLabel = _dateGroup(tx['created_at'] ?? '');
      groups.putIfAbsent(dateLabel, () => []).add(tx);
    }

    final widgets = <Widget>[];
    groups.forEach((dateLabel, txs) {
      // Date header with total
      double dayTotal = 0;
      for (final tx in txs) {
        final a = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount'].toString()) ?? 0;
        dayTotal += ['withdrawal', 'card_payment', 'fee'].contains(tx['type']) ? -a : a;
      }

      widgets.add(Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(dateLabel, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textMuted)),
          Text(
            '${dayTotal >= 0 ? '+' : ''}${_formatNum(dayTotal)}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textMuted),
          ),
        ]),
      ));

      // Transaction items
      widgets.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(children: txs.map((tx) => _buildTxItem(tx)).toList()),
      ));
    });

    return widgets;
  }

  Widget _buildTxItem(Map<String, dynamic> tx) {
    final amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount'].toString()) ?? 0;
    final isOut = ['withdrawal', 'card_payment', 'fee'].contains(tx['type']);
    final desc = tx['description'] ?? tx['type'] ?? '';
    final time = _formatTime(tx['created_at'] ?? '');
    final currencyCode = (tx['currency'] is Map) ? tx['currency']?['code'] ?? 'EUR' : tx['currency']?.toString() ?? 'EUR';
    final symbol = _sym(currencyCode);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(children: [
        // Avatar
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: AppTheme.bgMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(child: Text(
            desc.isNotEmpty ? desc[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          )),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(desc, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(time, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        ])),
        Text(
          '${isOut ? '-' : '+'}$symbol${_formatNum(amount)}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isOut ? AppTheme.textPrimary : AppTheme.primary,
          ),
        ),
      ]),
    );
  }

  String _sym(String c) => {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[c] ?? c;

  String _formatNum(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _dateGroup(String d) {
    try {
      final dt = DateTime.parse(d);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final txDay = DateTime(dt.year, dt.month, dt.day);
      if (txDay == today) return 'Today';
      if (txDay == today.subtract(const Duration(days: 1))) return 'Yesterday';
      final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${dt.day} ${months[dt.month]}';
    } catch (_) { return d; }
  }

  String _formatTime(String d) {
    try {
      final dt = DateTime.parse(d);
      final h = dt.hour;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = h >= 12 ? 'PM' : 'AM';
      final hh = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      return '$hh.$m $ampm';
    } catch (_) { return ''; }
  }
}

// ── Ocean Background for Account Detail ──
class _OceanDetailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Deep ocean gradient base
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0A3D5C),
          const Color(0xFF0C4A6E),
          const Color(0xFF155E75),
          const Color(0xFF0E4D64),
        ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), basePaint);

    // Light caustics / reflections (organic shapes)
    final caustic1 = Paint()..color = const Color(0xFF67E8F9).withValues(alpha: 0.08);
    final cp1 = Path();
    cp1.moveTo(0, h * 0.1);
    cp1.cubicTo(w * 0.2, h * 0.05, w * 0.4, h * 0.2, w * 0.55, h * 0.12);
    cp1.cubicTo(w * 0.7, h * 0.05, w * 0.85, h * 0.15, w, h * 0.08);
    cp1.lineTo(w, h * 0.3);
    cp1.cubicTo(w * 0.7, h * 0.35, w * 0.4, h * 0.2, 0, h * 0.28);
    cp1.close();
    canvas.drawPath(cp1, caustic1);

    // Wave layer 1
    final wave1 = Paint()..color = const Color(0xFF0891B2).withValues(alpha: 0.3);
    final p1 = Path();
    p1.moveTo(0, h * 0.4);
    p1.cubicTo(w * 0.15, h * 0.35, w * 0.3, h * 0.5, w * 0.5, h * 0.42);
    p1.cubicTo(w * 0.7, h * 0.34, w * 0.85, h * 0.48, w, h * 0.4);
    p1.lineTo(w, h);
    p1.lineTo(0, h);
    p1.close();
    canvas.drawPath(p1, wave1);

    // Wave layer 2
    final wave2 = Paint()..color = const Color(0xFF164E63).withValues(alpha: 0.5);
    final p2 = Path();
    p2.moveTo(0, h * 0.55);
    p2.cubicTo(w * 0.2, h * 0.48, w * 0.35, h * 0.6, w * 0.5, h * 0.52);
    p2.cubicTo(w * 0.65, h * 0.44, w * 0.8, h * 0.55, w, h * 0.5);
    p2.lineTo(w, h);
    p2.lineTo(0, h);
    p2.close();
    canvas.drawPath(p2, wave2);

    // Wave layer 3 (dark bottom)
    final wave3 = Paint()..color = const Color(0xFF083344).withValues(alpha: 0.6);
    final p3 = Path();
    p3.moveTo(0, h * 0.7);
    p3.cubicTo(w * 0.25, h * 0.65, w * 0.4, h * 0.75, w * 0.55, h * 0.7);
    p3.cubicTo(w * 0.7, h * 0.65, w * 0.85, h * 0.72, w, h * 0.68);
    p3.lineTo(w, h);
    p3.lineTo(0, h);
    p3.close();
    canvas.drawPath(p3, wave3);

    // Foam/light spots
    final spot1 = Paint()..color = const Color(0xFF7DD3FC).withValues(alpha: 0.06);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.25, h * 0.2), width: w * 0.5, height: h * 0.2), spot1);

    final spot2 = Paint()..color = const Color(0xFFA5F3FC).withValues(alpha: 0.04);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.7, h * 0.15), width: w * 0.35, height: h * 0.15), spot2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
