import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});
  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Map<String, dynamic>? data;
  bool loading = true;
  bool balanceHidden = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final r = await ApiService.getDashboard();
      if (r['success'] == true) setState(() => data = r['data']);
    } catch (_) {}
    setState(() => loading = false);
  }

  String fmt(dynamic a) => NumberFormat('#,##0.00').format(double.tryParse('$a') ?? 0);

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    final user = data?['user'];
    final accounts = (data?['accounts'] as List?) ?? [];
    final cards = (data?['cards'] as List?) ?? [];
    final txs = (data?['recentTransactions'] as List?) ?? [];
    final totalEur = data?['totalBalanceEur'] ?? 0;
    final unread = data?['unreadNotifications'] ?? 0;
    final kycStatus = data?['kycStatus'] ?? '';

    return Scaffold(
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: CustomScrollView(slivers: [
          // ═══════════════ APP BAR ═══════════════
          SliverToBoxAdapter(child: SafeArea(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                  boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Center(child: Text(
                  (user?['full_name'] ?? 'U').substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                )),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_greeting(), style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.35))),
                const SizedBox(height: 1),
                Text('${user?['full_name'] ?? 'عميل SDB'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              ])),
              // Search
              _iconBtn(Icons.search_rounded, () {}),
              const SizedBox(width: 8),
              // Notifications
              Stack(children: [
                _iconBtn(Icons.notifications_none_rounded, () {}),
                if (unread > 0) Positioned(right: 4, top: 4, child: Container(
                  width: 16, height: 16, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.danger),
                  child: Center(child: Text('$unread', style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white))),
                )),
              ]),
            ]),
          ))),

          // ═══════════════ KYC BANNER ═══════════════
          if (kycStatus != 'verified') SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [AppTheme.warning.withValues(alpha: 0.08), AppTheme.warning.withValues(alpha: 0.04)]),
                border: Border.all(color: AppTheme.warning.withValues(alpha: 0.15)),
              ),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppTheme.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.verified_user_outlined, color: AppTheme.warning, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('أكمل التحقق من هويتك', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                  Text('للوصول لجميع الخدمات المصرفية', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.35))),
                ])),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.warning.withValues(alpha: 0.5)),
              ]),
            ),
          )),

          // ═══════════════ BALANCE CARD ═══════════════
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)]),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 15))],
              ),
              child: Stack(children: [
                // Decorative glow
                Positioned(right: -20, top: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [AppTheme.primary.withValues(alpha: 0.08), Colors.transparent])))),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    _pill('الرصيد الإجمالي', AppTheme.success),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => balanceHidden = !balanceHidden),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
                        child: Icon(balanceHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 16, color: Colors.white.withValues(alpha: 0.4)),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('€', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.white.withValues(alpha: 0.4), height: 1.4)),
                    const SizedBox(width: 4),
                    Text(balanceHidden ? '••••••' : fmt(totalEur), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1, height: 1)),
                  ]),
                  const SizedBox(height: 20),
                  // Stats bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.04))),
                    child: Row(children: [
                      _statItem(Icons.trending_up_rounded, '${accounts.length}', 'حساب', AppTheme.success),
                      _vDiv(),
                      _statItem(Icons.credit_card_rounded, '${cards.length}', 'بطاقة', const Color(0xFF6366F1)),
                      _vDiv(),
                      _statItem(Icons.swap_horiz_rounded, '${txs.length}', 'معاملة', const Color(0xFFF59E0B)),
                    ]),
                  ),
                ]),
              ]),
            ),
          )),

          // ═══════════════ QUICK ACTIONS ═══════════════
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Row(children: [
              _actionBtn(Icons.arrow_upward_rounded, 'تحويل', const Color(0xFF6366F1)),
              const SizedBox(width: 10),
              _actionBtn(Icons.add_rounded, 'إيداع', const Color(0xFF10B981)),
              const SizedBox(width: 10),
              _actionBtn(Icons.currency_exchange_rounded, 'صرف', const Color(0xFFF59E0B)),
              const SizedBox(width: 10),
              _actionBtn(Icons.credit_card_rounded, 'بطاقة', const Color(0xFFEC4899)),
              const SizedBox(width: 10),
              _actionBtn(Icons.qr_code_scanner_rounded, 'مسح', const Color(0xFF06B6D4)),
            ]),
          )),

          // ═══════════════ PROMO BANNER ═══════════════
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)]),
                boxShadow: [BoxShadow(color: const Color(0xFF1E40AF).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _pill('جديد ✨', Colors.white),
                  const SizedBox(height: 10),
                  const Text('ادعُ صديقك واحصل\n على 10€ مجاناً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white, height: 1.4)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(100)),
                    child: const Text('ادعُ الآن', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ])),
                const SizedBox(width: 10),
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                  child: const Icon(Icons.card_giftcard_rounded, size: 30, color: Colors.white),
                ),
              ]),
            ),
          )),

          // ═══════════════ ACCOUNTS ═══════════════
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: _sectionHeader('حساباتي', '${accounts.length} حساب'),
          )),
          SliverToBoxAdapter(child: SizedBox(
            height: 125,
            child: accounts.isEmpty
              ? Center(child: Text('لا توجد حسابات', style: TextStyle(color: Colors.white.withValues(alpha: 0.2))))
              : ListView.builder(
                  scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
                  itemCount: accounts.length,
                  itemBuilder: (_, i) => _accountCard(accounts[i], i),
                ),
          )),

          // ═══════════════ CARDS PREVIEW ═══════════════
          if (cards.isNotEmpty) ...[
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _sectionHeader('بطاقاتي', 'عرض الكل'),
            )),
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: _miniCard(cards.first),
            )),
          ],

          // ═══════════════ SPENDING INSIGHTS ═══════════════
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: _sectionHeader('نظرة سريعة', 'هذا الشهر'),
          )),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(children: [
              _insightCard('الوارد', '€0.00', Icons.trending_up_rounded, AppTheme.success),
              const SizedBox(width: 10),
              _insightCard('المنفق', '€0.00', Icons.trending_down_rounded, AppTheme.danger),
            ]),
          )),

          // ═══════════════ TRANSACTIONS ═══════════════
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: _sectionHeader('آخر المعاملات', 'عرض الكل'),
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          if (txs.isEmpty)
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.all(40),
              child: Center(child: Column(children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(20)),
                  child: Icon(Icons.receipt_long_outlined, size: 32, color: Colors.white.withValues(alpha: 0.1)),
                ),
                const SizedBox(height: 14),
                Text('لا توجد معاملات بعد', style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 14)),
                const SizedBox(height: 4),
                Text('ستظهر معاملاتك هنا', style: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 12)),
              ])),
            )),

          SliverList(delegate: SliverChildBuilderDelegate(
            (_, i) => i < txs.length ? _txItem(txs[i]) : null,
            childCount: txs.length,
          )),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ]),
      ),
    );
  }

  // ═══════════════ WIDGETS ═══════════════

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 42, height: 42,
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(13)),
      child: Icon(icon, color: Colors.white.withValues(alpha: 0.5), size: 20),
    ),
  );

  Widget _pill(String text, Color dotColor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(100)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 5, height: 5, decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)),
      const SizedBox(width: 6),
      Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.5))),
    ]),
  );

  Widget _statItem(IconData icon, String value, String label, Color c) => Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, size: 16, color: c),
    const SizedBox(width: 8),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
      Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.3))),
    ]),
  ]));

  Widget _vDiv() => Container(width: 1, height: 30, margin: const EdgeInsets.symmetric(horizontal: 4), color: Colors.white.withValues(alpha: 0.05));

  Widget _actionBtn(IconData icon, String label, Color c) => Expanded(child: Column(children: [
    Container(
      width: 52, height: 52,
      decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withValues(alpha: 0.1))),
      child: Icon(icon, color: c, size: 22),
    ),
    const SizedBox(height: 8),
    Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.5))),
  ]));

  Widget _sectionHeader(String title, String action) => Row(children: [
    Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
    const Spacer(),
    Text(action, style: TextStyle(fontSize: 12, color: AppTheme.primary.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
  ]);

  Widget _accountCard(Map<String, dynamic> a, int i) {
    final gradients = [
      [const Color(0xFF1E40AF), const Color(0xFF3B82F6)],
      [const Color(0xFF047857), const Color(0xFF10B981)],
      [const Color(0xFF92400E), const Color(0xFFF59E0B)],
      [const Color(0xFF7C3AED), const Color(0xFFA78BFA)],
      [const Color(0xFFBE185D), const Color(0xFFEC4899)],
    ];
    final c = gradients[i % gradients.length];
    return Container(
      width: 180, margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: c),
        boxShadow: [BoxShadow(color: c[0].withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('${a['currency']?['code'] ?? ''}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.7))),
          const Spacer(),
          Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.2)),
            child: Center(child: Text('${a['currency']?['symbol'] ?? '€'}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)))),
        ]),
        const Spacer(),
        Text(balanceHidden ? '••••' : fmt(a['balance']), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 4),
        Text('${a['currency']?['name_ar'] ?? ''}', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5))),
      ]),
    );
  }

  Widget _miniCard(Map<String, dynamic> c) => Container(
    height: 190,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8))],
    ),
    child: Stack(children: [
      Positioned(right: -20, top: -20, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.02)))),
      Positioned(left: -30, bottom: -30, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.015)))),
      Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('SDB', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.3), letterSpacing: 3)),
          const Spacer(),
          _pill(c['status'] == 'frozen' ? '❄️ مجمّدة' : '✓ نشطة', c['status'] == 'frozen' ? const Color(0xFF93C5FD) : AppTheme.success),
        ]),
        const Spacer(),
        Text(c['card_number_masked'] ?? '•••• •••• •••• ••••', style: TextStyle(fontSize: 18, letterSpacing: 4, fontFamily: 'monospace', color: Colors.white.withValues(alpha: 0.8))),
        const SizedBox(height: 14),
        Row(children: [
          Text('${c['card_holder_name'] ?? ''}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.5))),
          const Spacer(),
          Text('${c['expiry_date'] ?? ''}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.5))),
        ]),
      ])),
    ]),
  );

  Widget _insightCard(String title, String amount, IconData icon, Color c) => Expanded(child: Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(20),
      border: Border.all(color: c.withValues(alpha: 0.08)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(width: 34, height: 34, decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: c, size: 18)),
        const Spacer(),
        Icon(Icons.more_horiz, size: 16, color: Colors.white.withValues(alpha: 0.15)),
      ]),
      const SizedBox(height: 14),
      Text(title, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.35))),
      const SizedBox(height: 2),
      Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: c)),
    ]),
  ));

  Widget _txItem(Map<String, dynamic> t) {
    final type = '${t['type'] ?? ''}';
    final icons = {'transfer': Icons.arrow_upward_rounded, 'deposit': Icons.add_rounded, 'exchange': Icons.currency_exchange_rounded, 'card_payment': Icons.shopping_bag_outlined, 'fee': Icons.receipt_outlined};
    final colors = {'transfer': const Color(0xFF6366F1), 'deposit': AppTheme.success, 'exchange': const Color(0xFFF59E0B), 'card_payment': const Color(0xFFEC4899), 'fee': AppTheme.textMuted};
    final labels = {'transfer': 'تحويل', 'deposit': 'إيداع', 'exchange': 'صرف عملات', 'card_payment': 'دفع', 'fee': 'رسوم'};
    final c = colors[type] ?? AppTheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.03))),
        child: Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(13)),
            child: Icon(icons[type] ?? Icons.swap_horiz, color: c, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(labels[type] ?? type, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 2),
            Text(t['created_at'] != null ? DateFormat('MMM dd, HH:mm').format(DateTime.tryParse('${t['created_at']}') ?? DateTime.now()) : '', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.2))),
          ])),
          Text('${type == 'deposit' ? '+' : '-'}${fmt(t['amount'])}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: type == 'deposit' ? AppTheme.success : Colors.white)),
        ]),
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'صباح الخير 🌅';
    if (h < 18) return 'مساء الخير ☀️';
    return 'مساء الخير 🌙';
  }
}
