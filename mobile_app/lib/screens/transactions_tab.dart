import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class TransactionsTab extends StatefulWidget {
  const TransactionsTab({super.key});
  @override
  State<TransactionsTab> createState() => _TransactionsTabState();
}

class _TransactionsTabState extends State<TransactionsTab> {
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _accounts = [];
  bool _loading = true;
  String _filter = 'all';
  String _search = '';

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await ApiService.getDashboard();
    if (r['success'] == true) {
      setState(() {
        _transactions = List<Map<String, dynamic>>.from(r['data']?['recentTransactions'] ?? []);
        _accounts = List<Map<String, dynamic>>.from(r['data']?['accounts'] ?? []);
        _loading = false;
      });
    } else { setState(() => _loading = false); }
    // Also get full paginated list
    final tr = await ApiService.getTransactions();
    if (tr['success'] == true) {
      final data = tr['data']?['data'] ?? tr['data'];
      if (data is List) setState(() => _transactions = List<Map<String, dynamic>>.from(data));
    }
  }

  List<Map<String, dynamic>> get _filtered {
    final accountIds = _accounts.map((a) => a['id']).toSet();
    var list = _transactions;
    if (_filter == 'incoming') list = list.where((t) => accountIds.contains(t['to_account_id'])).toList();
    if (_filter == 'outgoing') list = list.where((t) => accountIds.contains(t['from_account_id']) && !accountIds.contains(t['to_account_id'])).toList();
    if (_filter == 'pending') list = list.where((t) => t['status'] == 'pending').toList();
    if (_search.isNotEmpty) {
      final s = _search.toLowerCase();
      list = list.where((t) => (t['description'] ?? '').toString().toLowerCase().contains(s) || (t['type'] ?? '').toString().toLowerCase().contains(s)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: _load,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 20, right: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const SizedBox(height: 14),
                  // Search
                  Container(
                    decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 18, color: AppTheme.textMuted),
                        border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Filter tabs
                  Row(children: ['all', 'incoming', 'outgoing', 'pending'].map((f) {
                    final labels = {'all': 'All', 'incoming': 'Incoming', 'outgoing': 'Outgoing', 'pending': 'Pending'};
                    final isActive = _filter == f;
                    return Expanded(child: GestureDetector(
                      onTap: () => setState(() => _filter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppTheme.primary : AppTheme.bgMuted,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text(labels[f]!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppTheme.textSecondary))),
                      ),
                    ));
                  }).toList()),
                  const SizedBox(height: 12),
                ]),
              )),
              if (_filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.receipt_long_rounded, size: 48, color: AppTheme.textMuted.withOpacity(0.3)),
                    const SizedBox(height: 12),
                    const Text('No transactions found', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
                  ])),
                )
              else
                SliverList(delegate: SliverChildBuilderDelegate(
                  (_, i) => _buildItem(_filtered[i]),
                  childCount: _filtered.length,
                )),
            ]),
          ),
    );
  }

  Widget _buildItem(Map<String, dynamic> tx) {
    final accountIds = _accounts.map((a) => a['id']).toSet();
    final isIncoming = accountIds.contains(tx['to_account_id']);
    final amount = (tx['amount'] ?? 0).toDouble();
    final currency = tx['currency']?['code'] ?? tx['from_account']?['currency']?['code'] ?? 'EUR';
    final symbol = _sym(currency);
    final status = tx['status'] ?? 'completed';
    final desc = tx['description'] ?? (tx['type'] ?? 'Transfer');
    final date = tx['created_at'] ?? '';
    final initials = desc.toString().length >= 2 ? desc.toString().substring(0, 2).toUpperCase() : 'TX';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border.withOpacity(0.5))),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: isIncoming ? const Color(0xFFE8F5F0) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Icon(
              isIncoming ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              size: 18,
              color: isIncoming ? AppTheme.primary : AppTheme.danger,
            )),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(desc.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(_fmtDate(date), style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              '${isIncoming ? "+" : "-"}$symbol${_fmtNum(amount)}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isIncoming ? AppTheme.primary : AppTheme.textPrimary),
            ),
            if (status == 'pending') Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: const Text('Pending', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.warning)),
            )
            else if (status == 'completed') Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: const Text('Done', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.primary)),
            ),
          ]),
        ]),
      ),
    );
  }

  String _sym(String c) => {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[c] ?? c;
  String _fmtNum(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
  String _fmtDate(String d) {
    if (d.isEmpty) return '';
    try {
      final dt = DateTime.parse(d);
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month) return 'Today, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
      final y = now.subtract(const Duration(days: 1));
      if (dt.day == y.day && dt.month == y.month) return 'Yesterday';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return d; }
  }
}
