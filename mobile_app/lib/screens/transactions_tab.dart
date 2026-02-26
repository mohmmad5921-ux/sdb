import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class TransactionsTab extends StatefulWidget {
  const TransactionsTab({super.key});
  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  List txs = [];
  bool loading = true;
  String filter = 'all';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final r = await ApiService.getTransactions(type: filter == 'all' ? null : filter);
      if (r['success'] == true) {
        final d = r['data'];
        setState(() => txs = d is List ? d : d?['data'] ?? d?['transactions'] ?? []);
      }
    } catch (_) {}
    setState(() => loading = false);
  }

  String fmt(dynamic a) => NumberFormat('#,##0.00').format(double.tryParse('$a') ?? 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(children: [
            const Text('المعاملات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const Spacer(),
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
              child: Icon(Icons.search_rounded, color: AppTheme.textMuted, size: 20),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _chip('الكل', 'all', Icons.list_rounded),
              _chip('تحويل', 'transfer', Icons.arrow_upward_rounded),
              _chip('إيداع', 'deposit', Icons.add_rounded),
              _chip('صرف', 'exchange', Icons.currency_exchange_rounded),
              _chip('دفع', 'card_payment', Icons.shopping_bag_outlined),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: loading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: _load,
                child: txs.isEmpty
                  ? ListView(children: [
                      const SizedBox(height: 80),
                      Center(child: Column(children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(24)),
                          child: Icon(Icons.receipt_long_outlined, size: 36, color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 16),
                        Text('لا توجد معاملات', style: TextStyle(fontSize: 16, color: AppTheme.textMuted)),
                      ])),
                    ])
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: txs.length,
                      itemBuilder: (_, i) => _txItem(txs[i]),
                    ),
              ),
        ),
      ])),
    );
  }

  Widget _txItem(Map<String, dynamic> t) {
    final type = '${t['type'] ?? ''}';
    final icons = {'transfer': Icons.arrow_upward_rounded, 'deposit': Icons.add_rounded, 'exchange': Icons.currency_exchange_rounded, 'card_payment': Icons.shopping_bag_outlined, 'fee': Icons.receipt_outlined};
    final colors = {'transfer': const Color(0xFF6366F1), 'deposit': AppTheme.success, 'exchange': const Color(0xFFF59E0B), 'card_payment': const Color(0xFFEC4899), 'fee': AppTheme.textMuted};
    final labels = {'transfer': 'تحويل', 'deposit': 'إيداع', 'exchange': 'صرف عملات', 'card_payment': 'دفع بالبطاقة', 'fee': 'رسوم'};
    final statusLabels = {'completed': 'مكتمل', 'pending': 'معلق', 'failed': 'فاشل'};
    final statusColors = {'completed': AppTheme.success, 'pending': AppTheme.warning, 'failed': AppTheme.danger};
    final c = colors[type] ?? AppTheme.primary;
    final status = '${t['status'] ?? ''}';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
          child: Icon(icons[type] ?? Icons.swap_horiz_rounded, color: c, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(labels[type] ?? type, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 3),
          Row(children: [
            Text(t['created_at'] != null ? DateFormat('MMM dd').format(DateTime.tryParse('${t['created_at']}') ?? DateTime.now()) : '', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: (statusColors[status] ?? AppTheme.textMuted).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
              child: Text(statusLabels[status] ?? status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: statusColors[status] ?? AppTheme.textMuted)),
            ),
          ]),
        ])),
        Text('${type == 'deposit' ? '+' : '-'}${fmt(t['amount'])}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: type == 'deposit' ? AppTheme.success : AppTheme.textPrimary)),
      ]),
    );
  }

  Widget _chip(String label, String value, IconData icon) {
    final active = filter == value;
    return GestureDetector(
      onTap: () { setState(() => filter = value); _load(); },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary.withValues(alpha: 0.08) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: active ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14, color: active ? AppTheme.primary : AppTheme.textMuted),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? AppTheme.primary : AppTheme.textSecondary)),
        ]),
      ),
    );
  }
}
