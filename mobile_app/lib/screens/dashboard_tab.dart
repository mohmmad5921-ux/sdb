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
    return Scaffold(
      body: SafeArea(
        child: loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: _load,
              child: ListView(padding: const EdgeInsets.all(20), children: [
                // Greeting
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('مرحباً 👋', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))),
                    const SizedBox(height: 2),
                    Text(data?['user']?['name'] ?? 'عميل SDB', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                  ])),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.notifications_outlined, color: AppTheme.textMuted, size: 22),
                  ),
                ]),
                const SizedBox(height: 24),

                // Balance Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppTheme.primary, Color(0xFF3B82F6), AppTheme.accent]),
                    boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 25, offset: const Offset(0, 10))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text('الرصيد الإجمالي', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7))),
                      const Spacer(),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                        child: Text('EUR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9)))),
                    ]),
                    const SizedBox(height: 10),
                    Text('€${fmt(data?['totalBalanceEur'] ?? 0)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                    const SizedBox(height: 14),
                    Row(children: [
                      _balanceChip('📈 وارد', '+${fmt(data?['monthlyIncome'] ?? 0)}', AppTheme.success),
                      const SizedBox(width: 12),
                      _balanceChip('📉 منفق', '-${fmt(data?['monthlySpending'] ?? 0)}', AppTheme.danger),
                    ]),
                  ]),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Row(children: [
                  _quickAction('💳', 'إيداع', AppTheme.success),
                  const SizedBox(width: 12),
                  _quickAction('↗', 'تحويل', AppTheme.primary),
                  const SizedBox(width: 12),
                  _quickAction('💱', 'صرف', const Color(0xFF8B5CF6)),
                  const SizedBox(width: 12),
                  _quickAction('💳', 'بطاقة', AppTheme.gold),
                ]),
                const SizedBox(height: 24),

                // Accounts
                const Text('💰 حساباتي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 12),
                if (data?['accounts'] != null)
                  ...((data!['accounts'] as List).map((acc) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                    child: Row(children: [
                      Container(width: 44, height: 44, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text(acc['currency']?['symbol'] ?? '€', style: const TextStyle(fontSize: 20)))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('${acc['currency']?['code'] ?? 'EUR'} · ${acc['currency']?['name_ar'] ?? ''}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('${acc['iban'] ?? ''}', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.3), fontFamily: 'monospace')),
                      ])),
                      Text('${fmt(acc['balance'])}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
                    ]),
                  ))),

                const SizedBox(height: 20),

                // Recent Transactions
                Row(children: [
                  const Text('📋 آخر المعاملات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text('عرض الكل', style: TextStyle(color: AppTheme.primary, fontSize: 12))),
                ]),
                const SizedBox(height: 8),
                if (data?['recentTransactions'] != null)
                  ...((data!['recentTransactions'] as List).take(5).map((t) => _txItem(t))),
                if (data?['recentTransactions'] == null || (data!['recentTransactions'] as List).isEmpty)
                  Container(padding: const EdgeInsets.all(30), child: Center(child: Text('لا توجد معاملات بعد', style: TextStyle(color: Colors.white.withValues(alpha: 0.3))))),
              ]),
            ),
      ),
    );
  }

  Widget _balanceChip(String label, String amount, Color color) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.6))),
        const SizedBox(height: 2),
        Text(amount, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
      ]),
    ));
  }

  Widget _quickAction(String emoji, String label, Color c) {
    return Expanded(child: GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16), border: Border.all(color: c.withValues(alpha: 0.15))),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c)),
        ]),
      ),
    ));
  }

  Widget _txItem(Map<String, dynamic> t) {
    final icons = {'transfer': '↗', 'deposit': '💳', 'exchange': '💱', 'card_payment': '💸', 'fee': '📎'};
    final labels = {'transfer': 'تحويل', 'deposit': 'إيداع', 'exchange': 'صرف', 'card_payment': 'دفع', 'fee': 'رسوم'};
    final statusC = {'completed': AppTheme.success, 'pending': AppTheme.warning, 'failed': AppTheme.danger};
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(icons[t['type']] ?? '💸', style: const TextStyle(fontSize: 18)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(labels[t['type']] ?? '${t['type']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          Text('${t['reference_number'] ?? ''}', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.3))),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(fmt(t['amount']), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: statusC[t['status']] ?? Colors.white)),
          Text(t['status'] == 'completed' ? 'مكتمل' : t['status'] == 'pending' ? 'معلق' : '${t['status']}', style: TextStyle(fontSize: 10, color: statusC[t['status']] ?? AppTheme.textMuted)),
        ]),
      ]),
    );
  }
}
