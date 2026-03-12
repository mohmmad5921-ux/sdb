import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class InsightsTab extends StatefulWidget {
  const InsightsTab({super.key});
  @override
  State<InsightsTab> createState() => _InsightsTabState();
}

class _InsightsTabState extends State<InsightsTab> {
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _accounts = [];
  bool _loading = true;
  int _activeTab = 0; // 0=Spending, 1=Income, 2=Cash Flow
  int _timeFilter = 0; // 0=Month, 1=Year, 2=All Time

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await ApiService.getDashboard();
    final tr = await ApiService.getTransactions();
    if (mounted) {
      setState(() {
        if (r['success'] == true) {
          _accounts = List<Map<String, dynamic>>.from(r['data']?['accounts'] ?? []);
        }
        if (tr['success'] == true) {
          final data = tr['data']?['data'] ?? tr['data'];
          if (data is List) _transactions = List<Map<String, dynamic>>.from(data);
        }
        if (_transactions.isEmpty && r['success'] == true) {
          _transactions = List<Map<String, dynamic>>.from(r['data']?['recentTransactions'] ?? []);
        }
        _loading = false;
      });
    }
  }

  Map<String, double> get _spendingByCategory {
    final accountIds = _accounts.map((a) => a['id']).toSet();
    final categories = <String, double>{};
    for (final tx in _filteredTransactions) {
      final isOutgoing = accountIds.contains(tx['from_account_id']) && !accountIds.contains(tx['to_account_id']);
      if (isOutgoing) {
        String cat = _categorize(tx);
        double amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount'].toString()) ?? 0;
        categories[cat] = (categories[cat] ?? 0) + amount;
      }
    }
    return categories;
  }

  Map<String, double> get _incomeByCategory {
    final accountIds = _accounts.map((a) => a['id']).toSet();
    final categories = <String, double>{};
    for (final tx in _filteredTransactions) {
      final isIncoming = accountIds.contains(tx['to_account_id']);
      if (isIncoming) {
        String cat = _categorize(tx);
        double amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount'].toString()) ?? 0;
        categories[cat] = (categories[cat] ?? 0) + amount;
      }
    }
    return categories;
  }

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_timeFilter == 2) return _transactions; // All time
    final now = DateTime.now();
    return _transactions.where((tx) {
      try {
        final dt = DateTime.parse(tx['created_at'] ?? '');
        if (_timeFilter == 0) return dt.month == now.month && dt.year == now.year;
        if (_timeFilter == 1) return dt.year == now.year;
      } catch (_) {}
      return false;
    }).toList();
  }

  double get _totalSpending => _spendingByCategory.values.fold(0, (a, b) => a + b);
  double get _totalIncome => _incomeByCategory.values.fold(0, (a, b) => a + b);

  String _categorize(Map<String, dynamic> tx) {
    final type = (tx['type'] ?? tx['description'] ?? 'Other').toString().toLowerCase();
    if (type.contains('transfer')) return 'Transfers';
    if (type.contains('deposit')) return 'Deposits';
    if (type.contains('exchange')) return 'Exchange';
    if (type.contains('card')) return 'Card Payments';
    if (type.contains('fee')) return 'Fees';
    return 'Other';
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'Transfers': return Icons.send_rounded;
      case 'Deposits': return Icons.account_balance_rounded;
      case 'Exchange': return Icons.swap_horiz_rounded;
      case 'Card Payments': return Icons.credit_card_rounded;
      case 'Fees': return Icons.receipt_long_rounded;
      default: return Icons.category_rounded;
    }
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'Transfers': return const Color(0xFF3B82F6);
      case 'Deposits': return AppTheme.primary;
      case 'Exchange': return const Color(0xFFF59E0B);
      case 'Card Payments': return const Color(0xFF8B5CF6);
      case 'Fees': return const Color(0xFFEF4444);
      default: return const Color(0xFF6B7280);
    }
  }

  String _dateRangeLabel() {
    final now = DateTime.now();
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (_timeFilter == 0) {
      final start = DateTime(now.year, now.month, 1);
      return '${start.day} ${months[start.month]} - ${now.day} ${months[now.month]}';
    } else if (_timeFilter == 1) {
      return 'Jan ${now.year} - ${months[now.month]} ${now.year}';
    }
    return 'All time';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    final data = _activeTab == 0 ? _spendingByCategory : _incomeByCategory;
    final total = _activeTab == 0 ? _totalSpending : _totalIncome;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Header (Lunar: person icon + "Indsigt" + settings gear) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(width: 10),
                  const Text('Insights', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                ]),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.settings_outlined, size: 20, color: AppTheme.textSecondary),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── 3 Tabs (Lunar: Forbrug / Indtægter / Pengestrøm) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _tabChip('Spending', 0),
                const SizedBox(width: 12),
                _tabChip('Income', 1),
                const SizedBox(width: 12),
                _tabChip('Cash Flow', 2),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Total Amount + Date Range (Lunar style) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '€${_formatNum(_activeTab == 2 ? (_totalIncome - _totalSpending) : total)}',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  _dateRangeLabel(),
                  style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Bar Chart Area ──
            if (data.isNotEmpty || _activeTab == 2) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 140,
                  child: _buildMonthlyChart(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Time Filter (Lunar: Måned / År / Altid) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  _filterChip('Month', 0),
                  _filterChip('Year', 1),
                  _filterChip('All Time', 2),
                ]),
              ),
            ),
            const SizedBox(height: 28),

            // ── Categories (Lunar style) ──
            if (_activeTab != 2) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(children: [
                    const Text('Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textMuted),
                  ]),
                ]),
              ),
              const SizedBox(height: 12),

              if (data.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(child: Column(children: [
                    Icon(Icons.insights_rounded, size: 48, color: AppTheme.textMuted.withValues(alpha: 0.3)),
                    const SizedBox(height: 12),
                    Text('No data yet', style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
                  ])),
                )
              else
                ..._buildCategoryItems(data),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _tabChip(String label, int idx) {
    final active = _activeTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppTheme.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? Colors.white : AppTheme.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, int idx) {
    final active = _timeFilter == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _timeFilter = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppTheme.bgCard : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: active ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active ? AppTheme.textPrimary : AppTheme.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    // Simple vertical bar chart matching Lunar's style
    final data = _activeTab == 0 ? _spendingByCategory : _incomeByCategory;
    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) {
      return Center(child: Text('No data for this period', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)));
    }

    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxVal = sorted.first.value;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: sorted.take(6).map((e) {
        final heightFraction = maxVal > 0 ? e.value / maxVal : 0.0;
        return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            width: 32,
            height: (heightFraction * 100).clamp(8, 100),
            decoration: BoxDecoration(
              color: _catColor(e.key).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            e.key.length > 5 ? e.key.substring(0, 5) : e.key,
            style: const TextStyle(fontSize: 9, color: AppTheme.textMuted),
          ),
        ]);
      }).toList(),
    );
  }

  List<Widget> _buildCategoryItems(Map<String, double> data) {
    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((e) {
      // Count transactions in this category
      final txCount = _filteredTransactions.where((tx) => _categorize(tx) == e.key).length;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: _catColor(e.key).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(21),
            ),
            child: Icon(_catIcon(e.key), size: 20, color: _catColor(e.key)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text('$txCount transactions', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          Text(
            '-€${_formatNum(e.value)}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
        ]),
      );
    }).toList();
  }

  String _formatNum(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}
