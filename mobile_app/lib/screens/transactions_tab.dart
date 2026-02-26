import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(title: const Text('💸 المعاملات')),
      body: Column(children: [
        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _chip('الكل', 'all'), _chip('تحويل', 'transfer'), _chip('إيداع', 'deposit'),
              _chip('صرف', 'exchange'), _chip('دفع', 'card_payment'),
            ]),
          ),
        ),
        Expanded(
          child: loading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : RefreshIndicator(
                color: AppTheme.primary,
                onRefresh: _load,
                child: txs.isEmpty
                  ? ListView(children: [const SizedBox(height: 100), Center(child: Text('لا توجد معاملات', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))))])
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: txs.length,
                      itemBuilder: (_, i) {
                        final t = txs[i];
                        final icons = {'transfer': '↗', 'deposit': '💳', 'exchange': '💱', 'card_payment': '💸', 'fee': '📎', 'refund': '↩'};
                        final labels = {'transfer': 'تحويل', 'deposit': 'إيداع', 'exchange': 'صرف', 'card_payment': 'دفع', 'fee': 'رسوم', 'refund': 'استرداد'};
                        final statusC = {'completed': AppTheme.success, 'pending': AppTheme.warning, 'failed': AppTheme.danger};
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
                          child: Row(children: [
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                              child: Center(child: Text(icons[t['type']] ?? '💸', style: const TextStyle(fontSize: 20)))),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(labels[t['type']] ?? '${t['type']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                              const SizedBox(height: 2),
                              Text(t['description'] ?? t['reference_number'] ?? '', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.3))),
                              if (t['created_at'] != null) Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.tryParse('${t['created_at']}') ?? DateTime.now()), style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.2))),
                            ])),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text('${fmt(t['amount'])} ${t['currency']?['symbol'] ?? '€'}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: statusC[t['status']] ?? Colors.white)),
                              Text(t['status'] == 'completed' ? 'مكتمل' : t['status'] == 'pending' ? 'معلق' : t['status'] == 'failed' ? 'فشل' : '${t['status']}',
                                style: TextStyle(fontSize: 10, color: statusC[t['status']] ?? AppTheme.textMuted)),
                            ]),
                          ]),
                        );
                      },
                    ),
              ),
        ),
      ]),
    );
  }

  Widget _chip(String label, String value) {
    final active = filter == value;
    return GestureDetector(
      onTap: () { setState(() => filter = value); _load(); },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: active ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.border),
        ),
        child: Text(label, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? AppTheme.primary : AppTheme.textMuted)),
      ),
    );
  }
}
