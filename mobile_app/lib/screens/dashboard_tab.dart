import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});
  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> with TickerProviderStateMixin {
  Map<String, dynamic>? data;
  bool loading = true;
  int selectedAccount = 0;

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

  String fmt(dynamic a) {
    final v = double.tryParse('$a') ?? 0;
    return NumberFormat('#,##0.00').format(v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
        ? _buildShimmer()
        : RefreshIndicator(color: AppTheme.primary, onRefresh: _load, child: _buildContent()),
    );
  }

  Widget _buildShimmer() => const Center(child: CircularProgressIndicator(color: AppTheme.primary));

  Widget _buildContent() {
    final user = data?['user'];
    final accounts = (data?['accounts'] as List?) ?? [];
    final cards = (data?['cards'] as List?) ?? [];
    final txs = (data?['recentTransactions'] as List?) ?? [];
    final totalEur = data?['totalBalanceEur'] ?? 0;
    final unread = data?['unreadNotifications'] ?? 0;

    return CustomScrollView(slivers: [
      // Custom App Bar
      SliverToBoxAdapter(child: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(children: [
          // Avatar
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
            ),
            child: Center(child: Text(
              (user?['full_name'] ?? 'U').substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
            )),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_greeting(), style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
            Text('${user?['full_name'] ?? 'عميل SDB'}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          ])),
          // Notification Bell
          Stack(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.05)),
              child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
            ),
            if (unread > 0) Positioned(right: 2, top: 2, child: Container(
              width: 18, height: 18,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.danger),
              child: Center(child: Text('$unread', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
            )),
          ]),
        ]),
      ))),

      // Balance Card — Premium Gradient
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)]),
            border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            boxShadow: [BoxShadow(color: const Color(0xFF0F3460).withValues(alpha: 0.3), blurRadius: 40, offset: const Offset(0, 20))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(100)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.success)),
                  const SizedBox(width: 6),
                  Text('الرصيد الكلي', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.6))),
                ]),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.gold.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(100), border: Border.all(color: AppTheme.gold.withValues(alpha: 0.2))),
                child: const Text('EUR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.gold, letterSpacing: 1)),
              ),
            ]),
            const SizedBox(height: 20),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('€', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.white.withValues(alpha: 0.5))),
              const SizedBox(width: 4),
              Text(fmt(totalEur), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5, height: 1)),
            ]),
            const SizedBox(height: 20),
            // Mini stats
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                _miniStat('📈', 'الحسابات', '${accounts.length}'),
                _divider(),
                _miniStat('💳', 'البطاقات', '${cards.length}'),
                _divider(),
                _miniStat('📋', 'المعاملات', '${txs.length}'),
              ]),
            ),
          ]),
        ),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),

      // Quick Actions — Horizontal
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          _quickBtn(Icons.arrow_upward_rounded, 'تحويل', const Color(0xFF6366F1)),
          const SizedBox(width: 10),
          _quickBtn(Icons.add_rounded, 'إيداع', AppTheme.success),
          const SizedBox(width: 10),
          _quickBtn(Icons.currency_exchange_rounded, 'صرف', const Color(0xFFF59E0B)),
          const SizedBox(width: 10),
          _quickBtn(Icons.credit_card_rounded, 'بطاقة', const Color(0xFFEC4899)),
        ]),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 28)),

      // Accounts Section
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          const Text('حساباتي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(100)),
            child: Text('${accounts.length} حساب', style: const TextStyle(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ),
        ]),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),

      // Account Cards — Horizontal Scroll
      SliverToBoxAdapter(child: SizedBox(
        height: 110,
        child: accounts.isEmpty
          ? Center(child: Text('لا توجد حسابات', style: TextStyle(color: Colors.white.withValues(alpha: 0.3))))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: accounts.length,
              itemBuilder: (_, i) {
                final a = accounts[i];
                final colors = [
                  [const Color(0xFF1E40AF), const Color(0xFF3B82F6)],
                  [const Color(0xFF059669), const Color(0xFF10B981)],
                  [const Color(0xFFB45309), const Color(0xFFF59E0B)],
                  [const Color(0xFF7C3AED), const Color(0xFFA78BFA)],
                ];
                final c = colors[i % colors.length];
                return Container(
                  width: 200, margin: const EdgeInsets.only(left: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: c),
                    boxShadow: [BoxShadow(color: (c[0]).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 6))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('${a['currency']?['code'] ?? ''}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.8))),
                      const Spacer(),
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.2)),
                        child: Center(child: Text('${a['currency']?['symbol'] ?? '€'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white))),
                      ),
                    ]),
                    const Spacer(),
                    Text(fmt(a['balance']), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text('${a['iban'] ?? ''}'.length > 15 ? '${(a['iban'] ?? '').toString().substring(0, 15)}...' : '${a['iban'] ?? ''}',
                      style: TextStyle(fontSize: 9, fontFamily: 'monospace', color: Colors.white.withValues(alpha: 0.5))),
                  ]),
                );
              },
            ),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 28)),

      // Cards Section — Show first card
      if (cards.isNotEmpty) ...[
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            const Text('بطاقاتي', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
            const Spacer(),
            Text('عرض الكل →', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
          ]),
        )),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _bankCard(cards.first),
        )),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
      ],

      // Transactions Header
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          const Text('آخر المعاملات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
          const Spacer(),
          Text('عرض الكل →', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
        ]),
      )),
      const SliverToBoxAdapter(child: SizedBox(height: 12)),

      // Transactions List
      if (txs.isEmpty)
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(child: Column(children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: Colors.white.withValues(alpha: 0.1)),
            const SizedBox(height: 12),
            Text('لا توجد معاملات بعد', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 14)),
          ])),
        )),

      SliverList(delegate: SliverChildBuilderDelegate(
        (_, i) {
          if (i >= txs.length) return null;
          return _txItem(txs[i]);
        },
        childCount: txs.length,
      )),

      const SliverToBoxAdapter(child: SizedBox(height: 80)),
    ]);
  }

  Widget _bankCard(Map<String, dynamic> card) {
    final isFrozen = card['status'] == 'frozen';
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: isFrozen
          ? const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)])
          : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)]),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Stack(children: [
        // Decorative circles
        Positioned(right: -30, top: -30, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)))),
        Positioned(left: -20, bottom: -40, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.02)))),
        // Content
        Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text('SDB', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.5), letterSpacing: 3)),
            const Spacer(),
            if (isFrozen) Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF3B82F6).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
              child: const Text('❄️ مجمّدة', style: TextStyle(fontSize: 10, color: Color(0xFF93C5FD))),
            ),
          ]),
          const Spacer(),
          Text(card['card_number_masked'] ?? '•••• •••• •••• ••••', style: TextStyle(fontSize: 20, letterSpacing: 4, fontFamily: 'monospace', color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 16),
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('HOLDER', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.3), letterSpacing: 1.5)),
              const SizedBox(height: 2),
              Text('${card['card_holder_name'] ?? ''}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
            ]),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('EXPIRES', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.3), letterSpacing: 1.5)),
              const SizedBox(height: 2),
              Text('${card['expiry_date'] ?? ''}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
            ]),
          ]),
        ])),
      ]),
    );
  }

  Widget _txItem(Map<String, dynamic> t) {
    final type = '${t['type'] ?? ''}';
    final icons = {'transfer': Icons.arrow_upward_rounded, 'deposit': Icons.add_rounded, 'exchange': Icons.currency_exchange_rounded, 'card_payment': Icons.shopping_bag_outlined, 'fee': Icons.receipt_outlined};
    final colors = {'transfer': const Color(0xFF6366F1), 'deposit': AppTheme.success, 'exchange': const Color(0xFFF59E0B), 'card_payment': const Color(0xFFEC4899), 'fee': AppTheme.textMuted};
    final labels = {'transfer': 'تحويل', 'deposit': 'إيداع', 'exchange': 'صرف عملات', 'card_payment': 'دفع بالبطاقة', 'fee': 'رسوم'};
    final c = colors[type] ?? AppTheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.04))),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
            child: Icon(icons[type] ?? Icons.swap_horiz_rounded, color: c, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(labels[type] ?? type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(height: 2),
            Text(
              t['created_at'] != null ? DateFormat('MMM dd, HH:mm').format(DateTime.tryParse('${t['created_at']}') ?? DateTime.now()) : '',
              style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.25)),
            ),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${type == 'deposit' ? '+' : '-'}${fmt(t['amount'])}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: type == 'deposit' ? AppTheme.success : Colors.white)),
            Text(t['currency']?['code'] ?? '', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.25))),
          ]),
        ]),
      ),
    );
  }

  Widget _quickBtn(IconData icon, String label, Color c) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(color: c.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(18), border: Border.all(color: c.withValues(alpha: 0.1))),
      child: Column(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: c, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c)),
      ]),
    ));
  }

  Widget _miniStat(String emoji, String label, String value) {
    return Expanded(child: Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 16)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
      Text(label, style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.4))),
    ]));
  }

  Widget _divider() => Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.06));

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'صباح الخير 🌅';
    if (h < 18) return 'مساء الخير ☀️';
    return 'مساء الخير 🌙';
  }
}
