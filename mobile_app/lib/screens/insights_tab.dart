import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

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
  int? _selectedAccountId; // null = All accounts
  int _chartType = 1; // 0=Pie, 1=Bar

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await ApiService.getDashboard();
    final tr = await ApiService.getTransactions();
    if (mounted) {
      setState(() {
        if (r['success'] == true) _accounts = List<Map<String, dynamic>>.from(r['data']?['accounts'] ?? []);
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

  // ═══════ Data Helpers ═══════

  Set<dynamic> get _accountIds {
    if (_selectedAccountId != null) return {_selectedAccountId};
    return _accounts.map((a) => a['id']).toSet();
  }

  Set<dynamic> get _allAccountIds => _accounts.map((a) => a['id']).toSet();

  List<Map<String, dynamic>> get _filteredTransactions {
    final txs = _transactions.where((tx) {
      // Filter by account if selected
      if (_selectedAccountId != null) {
        if (tx['from_account_id'] != _selectedAccountId && tx['to_account_id'] != _selectedAccountId) return false;
      }
      return true;
    }).toList();

    if (_timeFilter == 2) return txs;
    final now = DateTime.now();
    return txs.where((tx) {
      try {
        final dt = DateTime.parse(tx['created_at'] ?? '');
        if (_timeFilter == 0) return dt.month == now.month && dt.year == now.year;
        if (_timeFilter == 1) return dt.year == now.year;
      } catch (_) {}
      return false;
    }).toList();
  }

  Map<String, double> get _spendingByCategory {
    final cats = <String, double>{};
    for (final tx in _filteredTransactions) {
      final isOut = _allAccountIds.contains(tx['from_account_id']) && !_allAccountIds.contains(tx['to_account_id']);
      if (isOut) {
        if (_selectedAccountId != null && tx['from_account_id'] != _selectedAccountId) continue;
        cats[_categorize(tx)] = (cats[_categorize(tx)] ?? 0) + _parseAmount(tx);
      }
    }
    return cats;
  }

  Map<String, double> get _incomeByCategory {
    final cats = <String, double>{};
    for (final tx in _filteredTransactions) {
      final isIn = _allAccountIds.contains(tx['to_account_id']);
      if (isIn) {
        if (_selectedAccountId != null && tx['to_account_id'] != _selectedAccountId) continue;
        cats[_categorize(tx)] = (cats[_categorize(tx)] ?? 0) + _parseAmount(tx);
      }
    }
    return cats;
  }

  Map<String, int> _countByCategory(bool spending) {
    final counts = <String, int>{};
    for (final tx in _filteredTransactions) {
      final isOut = _allAccountIds.contains(tx['from_account_id']) && !_allAccountIds.contains(tx['to_account_id']);
      final isIn = _allAccountIds.contains(tx['to_account_id']);
      if (spending && isOut) {
        if (_selectedAccountId != null && tx['from_account_id'] != _selectedAccountId) continue;
        counts[_categorize(tx)] = (counts[_categorize(tx)] ?? 0) + 1;
      }
      if (!spending && isIn) {
        if (_selectedAccountId != null && tx['to_account_id'] != _selectedAccountId) continue;
        counts[_categorize(tx)] = (counts[_categorize(tx)] ?? 0) + 1;
      }
    }
    return counts;
  }

  double get _totalSpending => _spendingByCategory.values.fold(0, (a, b) => a + b);
  double get _totalIncome => _incomeByCategory.values.fold(0, (a, b) => a + b);
  int get _spendingTxCount => _countByCategory(true).values.fold(0, (a, b) => a + b);
  int get _incomeTxCount => _countByCategory(false).values.fold(0, (a, b) => a + b);

  double _parseAmount(Map<String, dynamic> tx) => (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;

  String _categorize(Map<String, dynamic> tx) {
    final type = (tx['type'] ?? tx['description'] ?? '').toString().toLowerCase();
    if (type.contains('transfer')) return 'تحويلات';
    if (type.contains('deposit')) return 'إيداعات';
    if (type.contains('exchange')) return 'صرف عملات';
    if (type.contains('card')) return 'مدفوعات بطاقة';
    if (type.contains('fee')) return 'رسوم';
    return 'أخرى';
  }

  IconData _catIcon(String c) => {'تحويلات': Icons.send_rounded, 'إيداعات': Icons.account_balance_rounded, 'صرف عملات': Icons.swap_horiz_rounded, 'مدفوعات بطاقة': Icons.credit_card_rounded, 'رسوم': Icons.receipt_long_rounded}[c] ?? Icons.help_outline_rounded;
  Color _catColor(String c) => {'تحويلات': const Color(0xFF3B82F6), 'إيداعات': AppTheme.primary, 'صرف عملات': const Color(0xFFF59E0B), 'مدفوعات بطاقة': const Color(0xFFA855F7), 'رسوم': const Color(0xFFEF4444)}[c] ?? const Color(0xFF6B7280);

  String _dateRangeLabel() {
    final now = DateTime.now();
    final m = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    if (_timeFilter == 0) return '1 ${m[now.month]} - ${now.day} ${m[now.month]}';
    if (_timeFilter == 1) return 'يناير ${now.year} - ${m[now.month]} ${now.year}';
    return 'كل الفترات';
  }

  String _accountLabel() {
    if (_selectedAccountId == null) return 'جميع الحسابات';
    final acc = _accounts.firstWhere((a) => a['id'] == _selectedAccountId, orElse: () => {});
    return acc['name'] ?? acc['currency']?['code'] ?? 'حساب';
  }

  // ═══════ Monthly Bars ═══════

  List<_MonthBar> _getMonthlyBars() {
    final now = DateTime.now();
    final bars = <_MonthBar>[];
    final mn = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    for (int i = 3; i >= 0; i--) {
      int month = now.month - i;
      int year = now.year;
      if (month <= 0) { month += 12; year--; }
      double spending = 0, income = 0;
      for (final tx in _transactions) {
        try {
          final dt = DateTime.parse(tx['created_at'] ?? '');
          if (dt.month == month && dt.year == year) {
            if (_selectedAccountId != null && tx['from_account_id'] != _selectedAccountId && tx['to_account_id'] != _selectedAccountId) continue;
            final amt = _parseAmount(tx);
            final isOut = _allAccountIds.contains(tx['from_account_id']) && !_allAccountIds.contains(tx['to_account_id']);
            if (isOut && (_selectedAccountId == null || tx['from_account_id'] == _selectedAccountId)) spending += amt;
            if (_allAccountIds.contains(tx['to_account_id']) && (_selectedAccountId == null || tx['to_account_id'] == _selectedAccountId)) income += amt;
          }
        } catch (_) {}
      }
      bars.add(_MonthBar(label: mn[month].substring(0, 3), spending: spending, income: income));
    }
    return bars;
  }

  // ═══════ Build ═══════

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(backgroundColor: AppTheme.bgLight, body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Header ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(17)),
                      child: const Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('الإحصائيات', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                ]),
                GestureDetector(
                  onTap: () => _showSettings(context),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                    child: const Icon(Icons.settings_outlined, size: 20, color: AppTheme.textSecondary),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── Tab Chips ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                _tabChip('الإنفاق', 0),
                const SizedBox(width: 12),
                _tabChip('الدخل', 1),
                const SizedBox(width: 12),
                _tabChip('التدفق النقدي', 2),
              ]),
            ),
            const SizedBox(height: 24),

            // ── Chart Area ──
            if (_chartType == 0 && _activeTab != 2) ...[
              // Donut chart with amount inside
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(height: 260, child: _buildDonutChart()),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // Total Amount (shown only with bar chart or cash flow)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    _activeTab == 2 ? '€${_fmtNum(_totalIncome - _totalSpending)}' : '€${_fmtNum(_activeTab == 0 ? _totalSpending : _totalIncome)}',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 4),
                  Text(_dateRangeLabel(), style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                ]),
              ),
              const SizedBox(height: 24),
              // Bar Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(height: 160, child: _buildBarChart()),
              ),
              const SizedBox(height: 20),
            ],

            // ── Time Filter ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  _filterChip('الشهر', 0),
                  _filterChip('السنة', 1),
                  _filterChip('كل الفترات', 2),
                ]),
              ),
            ),
            const SizedBox(height: 28),

            // ── Content ──
            if (_activeTab == 0) _buildSpendingContent(),
            if (_activeTab == 1) _buildIncomeContent(),
            if (_activeTab == 2) _buildCashFlowContent(),
          ]),
        ),
      ),
    );
  }

  // ═══════ Settings Sheet (Lunar style) ═══════

  void _showSettings(BuildContext ctx) {
    int tempAccount = _selectedAccountId ?? -1; // -1 = all
    int tempChart = _chartType;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(builder: (_, setSheetState) => Container(
        height: MediaQuery.of(ctx).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Close button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GestureDetector(
              onTap: () => Navigator.pop(sheetCtx),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
                child: const Icon(Icons.close_rounded, size: 20, color: AppTheme.textPrimary),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('الإعدادات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 24),

          // Account picker
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('الحسابات', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                // Show account picker
                showModalBottomSheet(context: sheetCtx, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (pickCtx) => Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 16),
                      const Text('اختر حساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                      const SizedBox(height: 16),
                      // All accounts
                      ListTile(
                        leading: const Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primary),
                        title: const Text('جميع الحسابات', style: TextStyle(fontWeight: FontWeight.w600)),
                        trailing: tempAccount == -1 ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary) : null,
                        onTap: () { setSheetState(() => tempAccount = -1); Navigator.pop(pickCtx); },
                      ),
                      ..._accounts.map((a) => ListTile(
                        leading: Text(a['currency']?['symbol'] ?? '€', style: const TextStyle(fontSize: 20)),
                        title: Text(a['name'] ?? 'حساب ${a['currency']?['code'] ?? ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(a['currency']?['code'] ?? '', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                        trailing: tempAccount == a['id'] ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary) : null,
                        onTap: () { setSheetState(() => tempAccount = a['id']); Navigator.pop(pickCtx); },
                      )),
                    ]),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('اختر حساب', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                    const SizedBox(height: 2),
                    Text(
                      tempAccount == -1 ? 'جميع الحسابات' : (_accounts.firstWhere((a) => a['id'] == tempAccount, orElse: () => {'name': 'حساب'})['name'] ?? 'حساب'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                    ),
                  ]),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Period
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('الفترة الزمنية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('اختر الفترة', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  const SizedBox(height: 2),
                  Text(
                    _timeFilter == 0 ? 'آخر يوم عمل في الشهر' : _timeFilter == 1 ? 'السنة الحالية' : 'كل الفترات',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                ]),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
              ]),
            ),
          ),
          const SizedBox(height: 24),

          // Chart type
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('اختر المظهر', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              _chartOption(sheetCtx, setSheetState, Icons.donut_large_rounded, 'دائرة الإنفاق', 0, tempChart, (v) => setSheetState(() => tempChart = v)),
              const SizedBox(height: 8),
              _chartOption(sheetCtx, setSheetState, Icons.bar_chart_rounded, 'رسم بياني', 1, tempChart, (v) => setSheetState(() => tempChart = v)),
            ]),
          ),
          const Spacer(),

          // Apply button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedAccountId = tempAccount == -1 ? null : tempAccount;
                  _chartType = tempChart;
                });
                Navigator.pop(sheetCtx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.textPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              child: const Text('حفظ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            )),
          ),
        ]),
      )),
    );
  }

  Widget _chartOption(BuildContext ctx, StateSetter setSheet, IconData icon, String label, int value, int current, ValueChanged<int> onTap) {
    final active = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Icon(icon, size: 22, color: AppTheme.textSecondary),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: active ? AppTheme.textPrimary : AppTheme.border, width: 2),
              color: active ? AppTheme.textPrimary : Colors.transparent,
            ),
            child: active ? const Icon(Icons.circle, size: 10, color: Colors.white) : null,
          ),
        ]),
      ),
    );
  }

  // ═══════ Widgets ═══════

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
        child: Text(label, style: TextStyle(
          fontSize: 13,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active ? Colors.white : AppTheme.textMuted,
        )),
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
          child: Center(child: Text(label, style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? AppTheme.textPrimary : AppTheme.textMuted,
          ))),
        ),
      ),
    );
  }

  // ═══════ Donut Chart (Lunar style) ═══════

  Widget _buildDonutChart() {
    final data = _activeTab == 0 ? _spendingByCategory : _incomeByCategory;
    final total = _activeTab == 0 ? _totalSpending : _totalIncome;

    if (data.isEmpty || total == 0) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.donut_large_rounded, size: 60, color: AppTheme.textMuted.withValues(alpha: 0.2)),
        const SizedBox(height: 12),
        const Text('لا توجد بيانات', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
      ]));
    }

    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final segments = sorted.map((e) => _DonutSegment(value: e.value, color: _catColor(e.key))).toList();

    return Center(
      child: SizedBox(
        width: 240, height: 240,
        child: Stack(alignment: Alignment.center, children: [
          CustomPaint(
            size: const Size(240, 240),
            painter: _DonutPainter(segments: segments, total: total),
          ),
          // Center text
          Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_dateRangeLabel(), style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            const SizedBox(height: 4),
            Text(
              '€${_fmtNum(total)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
            ),
          ]),
        ]),
      ),
    );
  }

  // ═══════ Bar Chart ═══════

  Widget _buildBarChart() {
    final bars = _getMonthlyBars();
    double maxVal = 0;
    for (final b in bars) {
      if (_activeTab == 0 && b.spending > maxVal) maxVal = b.spending;
      if (_activeTab == 1 && b.income > maxVal) maxVal = b.income;
      if (_activeTab == 2) {
        if (b.income > maxVal) maxVal = b.income;
        if (b.spending > maxVal) maxVal = b.spending;
      }
    }
    if (maxVal == 0) maxVal = 1;

    double avg = 0;
    if (_activeTab == 0) avg = bars.map((b) => b.spending).reduce((a, b) => a + b) / bars.length;
    if (_activeTab == 1) avg = bars.map((b) => b.income).reduce((a, b) => a + b) / bars.length;

    return LayoutBuilder(builder: (_, constraints) {
      final chartH = constraints.maxHeight - 28;
      final barW = _activeTab == 2 ? 18.0 : 28.0;

      return Stack(children: [
        // Y-axis
        Positioned(right: 0, top: 0, child: Text(_fmtShort(maxVal), style: const TextStyle(fontSize: 10, color: AppTheme.textMuted))),
        Positioned(right: 0, top: chartH * 0.5, child: Text(_fmtShort(maxVal * 0.5), style: const TextStyle(fontSize: 10, color: AppTheme.textMuted))),
        Positioned(right: 0, bottom: 24, child: const Text('0', style: TextStyle(fontSize: 10, color: AppTheme.textMuted))),

        // Average line
        if (_activeTab != 2 && avg > 0) Positioned(
          left: 0, right: 40,
          top: chartH * (1 - avg / maxVal),
          child: Row(children: [
            Expanded(child: CustomPaint(painter: _DashedLinePainter(color: AppTheme.primary.withValues(alpha: 0.6)))),
            const SizedBox(width: 4),
            Text('م: ${_fmtShort(avg)}', style: TextStyle(fontSize: 9, color: AppTheme.primary.withValues(alpha: 0.8))),
          ]),
        ),

        // Bars
        Positioned(left: 0, right: 50, bottom: 0, top: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bars.map((b) {
              if (_activeTab == 2) {
                final incH = maxVal > 0 ? (b.income / maxVal) * chartH : 0.0;
                final expH = maxVal > 0 ? (b.spending / maxVal) * chartH : 0.0;
                return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(width: barW, height: incH.clamp(3, chartH), decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(4))),
                    const SizedBox(width: 3),
                    Container(width: barW, height: expH.clamp(3, chartH), decoration: BoxDecoration(color: const Color(0xFFD1D5DB), borderRadius: BorderRadius.circular(4))),
                  ]),
                  const SizedBox(height: 6),
                  Text(b.label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                ]);
              }
              final val = _activeTab == 0 ? b.spending : b.income;
              final h = maxVal > 0 ? (val / maxVal) * chartH : 0.0;
              final color = _activeTab == 0 ? const Color(0xFFD1D5DB) : AppTheme.primary;
              return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(width: barW, height: h.clamp(3, chartH), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5))),
                const SizedBox(height: 6),
                Text(b.label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
              ]);
            }).toList(),
          ),
        ),
      ]);
    });
  }

  // ═══════ Spending ═══════

  Widget _buildSpendingContent() {
    final data = _spendingByCategory;
    final counts = _countByCategory(true);
    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: const [
            Text('الفئات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textMuted),
          ]),
        ]),
      ),
      const SizedBox(height: 12),
      if (data.isEmpty)
        _emptyState()
      else
        ...sorted.map((e) => _categoryRow(e.key, counts[e.key] ?? 0, e.value, _catIcon(e.key), _catColor(e.key), onTap: () => _openCategoryDetail(e.key, e.value, counts[e.key] ?? 0, true))),
    ]);
  }

  // ═══════ Income ═══════

  Widget _buildIncomeContent() {
    final data = _incomeByCategory;
    final counts = _countByCategory(false);
    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text('المعاملات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ),
      const SizedBox(height: 12),
      if (data.isEmpty)
        _emptyState()
      else
        ...sorted.map((e) => _categoryRow(e.key, counts[e.key] ?? 0, e.value, _catIcon(e.key), _catColor(e.key), isIncome: true, onTap: () => _openCategoryDetail(e.key, e.value, counts[e.key] ?? 0, false))),
    ]);
  }

  // ═══════ Cash Flow ═══════

  Widget _buildCashFlowContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        GestureDetector(
          onTap: () => setState(() => _activeTab = 1),
          child: _cashFlowRow(Icons.add_rounded, AppTheme.primary, 'الدخل', _incomeTxCount, _totalIncome),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => setState(() => _activeTab = 0),
          child: _cashFlowRow(Icons.remove_rounded, AppTheme.textMuted, 'المصروفات', _spendingTxCount, _totalSpending),
        ),
      ]),
    );
  }

  Widget _cashFlowRow(IconData icon, Color iconColor, String label, int count, double amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          Text('$count عملية', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        ])),
        Text('€${_fmtNum(amount)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textMuted),
      ]),
    );
  }

  // ═══════ Category Row ═══════

  Widget _categoryRow(String name, int count, double amount, IconData icon, Color color, {bool isIncome = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(21)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text('$count عملية', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          Text('${isIncome ? "" : "-"}€${_fmtNum(amount)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ]),
      ),
    );
  }

  // ═══════ Category Detail Page ═══════

  void _openCategoryDetail(String catName, double total, int count, bool isSpending) {
    final color = _catColor(catName);
    final txsInCat = _filteredTransactions.where((tx) {
      final isOut = _allAccountIds.contains(tx['from_account_id']) && !_allAccountIds.contains(tx['to_account_id']);
      final isIn = _allAccountIds.contains(tx['to_account_id']);
      if (isSpending && isOut && _categorize(tx) == catName) return true;
      if (!isSpending && isIn && _categorize(tx) == catName) return true;
      return false;
    }).toList();

    Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Back button
          Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppTheme.textPrimary),
              ),
            ),
          ),

          // Time filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                _filterChip('الشهر', 0),
                _filterChip('السنة', 1),
                _filterChip('كل الفترات', 2),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Category name + icon + amount
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(catName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                Text('${isSpending ? "-" : ""}€${_fmtNum(total)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                Text(_dateRangeLabel(), style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
              ]),
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(24)),
                child: Icon(_catIcon(catName), size: 24, color: color),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // Mini bar chart for this category
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(height: 120, child: _buildCategoryChart(catName, isSpending, color)),
          ),
          const SizedBox(height: 24),

          // Transactions in this category
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('المعاملات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),

          ...txsInCat.map((tx) {
            final desc = tx['description'] ?? tx['type'] ?? '';
            final amt = _parseAmount(tx);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
              ),
              child: Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                  child: Icon(_catIcon(catName), size: 18, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(desc.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis),
                  Text(_fmtDate(tx['created_at'] ?? ''), style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                ])),
                Text('${isSpending ? "-" : ""}€${_fmtNum(amt)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              ]),
            );
          }),

          const SizedBox(height: 32),
        ]),
      ),
    )));
  }

  Widget _buildCategoryChart(String catName, bool isSpending, Color color) {
    final now = DateTime.now();
    final mn = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    final bars = <_MonthBar>[];
    for (int i = 3; i >= 0; i--) {
      int month = now.month - i;
      int year = now.year;
      if (month <= 0) { month += 12; year--; }
      double val = 0;
      for (final tx in _transactions) {
        try {
          final dt = DateTime.parse(tx['created_at'] ?? '');
          if (dt.month == month && dt.year == year && _categorize(tx) == catName) {
            final isOut = _allAccountIds.contains(tx['from_account_id']) && !_allAccountIds.contains(tx['to_account_id']);
            final isIn = _allAccountIds.contains(tx['to_account_id']);
            if (isSpending && isOut) val += _parseAmount(tx);
            if (!isSpending && isIn) val += _parseAmount(tx);
          }
        } catch (_) {}
      }
      bars.add(_MonthBar(label: mn[month].substring(0, 3), spending: val, income: val));
    }
    double maxVal = bars.map((b) => b.spending).reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) maxVal = 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: bars.map((b) {
        final h = (b.spending / maxVal) * 90;
        return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(width: 28, height: h.clamp(3, 90), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5))),
          const SizedBox(height: 6),
          Text(b.label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ]);
      }).toList(),
    );
  }

  // ═══════ Empty State ═══════

  Widget _emptyState() => Padding(
    padding: const EdgeInsets.all(40),
    child: Center(child: Column(children: [
      Icon(Icons.insights_rounded, size: 48, color: AppTheme.textMuted.withValues(alpha: 0.3)),
      const SizedBox(height: 12),
      const Text('لا توجد بيانات لهذه الفترة', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
    ])),
  );

  // ═══════ Helpers ═══════

  String _fmtNum(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _fmtShort(double n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k' : n.toStringAsFixed(0);

  String _fmtDate(String d) {
    if (d.isEmpty) return '';
    try {
      final dt = DateTime.parse(d);
      final m = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      return '${dt.day} ${m[dt.month]}';
    } catch (_) { return d; }
  }
}

class _MonthBar {
  final String label;
  final double spending;
  final double income;
  _MonthBar({required this.label, required this.spending, required this.income});
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) { canvas.drawLine(Offset(x, 0), Offset(x + 4, 0), paint); x += 8; }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DonutSegment {
  final double value;
  final Color color;
  _DonutSegment({required this.value, required this.color});
}

class _DonutPainter extends CustomPainter {
  final List<_DonutSegment> segments;
  final double total;
  _DonutPainter({required this.segments, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    const strokeWidth = 22.0;
    const gapDegrees = 4.0;
    const startAngle = -90.0; // Start from top

    final totalGap = gapDegrees * segments.length;
    final availableDegrees = 360.0 - totalGap;

    double currentAngle = startAngle;

    for (final seg in segments) {
      final sweepDegrees = (seg.value / total) * availableDegrees;

      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        currentAngle * 3.14159265 / 180,
        sweepDegrees * 3.14159265 / 180,
        false,
        paint,
      );

      currentAngle += sweepDegrees + gapDegrees;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
