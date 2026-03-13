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

  // ═══════ Data Helpers ═══════

  Set<dynamic> get _accountIds => _accounts.map((a) => a['id']).toSet();

  List<Map<String, dynamic>> get _filteredTransactions {
    if (_timeFilter == 2) return _transactions;
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

  Map<String, double> get _spendingByCategory {
    final cats = <String, double>{};
    for (final tx in _filteredTransactions) {
      final isOut = _accountIds.contains(tx['from_account_id']) && !_accountIds.contains(tx['to_account_id']);
      if (isOut) {
        String cat = _categorize(tx);
        double amt = _parseAmount(tx);
        cats[cat] = (cats[cat] ?? 0) + amt;
      }
    }
    return cats;
  }

  Map<String, double> get _incomeByCategory {
    final cats = <String, double>{};
    for (final tx in _filteredTransactions) {
      final isIn = _accountIds.contains(tx['to_account_id']);
      if (isIn) {
        String cat = _categorize(tx);
        double amt = _parseAmount(tx);
        cats[cat] = (cats[cat] ?? 0) + amt;
      }
    }
    return cats;
  }

  Map<String, int> get _spendingCounts {
    final counts = <String, int>{};
    for (final tx in _filteredTransactions) {
      final isOut = _accountIds.contains(tx['from_account_id']) && !_accountIds.contains(tx['to_account_id']);
      if (isOut) counts[_categorize(tx)] = (counts[_categorize(tx)] ?? 0) + 1;
    }
    return counts;
  }

  Map<String, int> get _incomeCounts {
    final counts = <String, int>{};
    for (final tx in _filteredTransactions) {
      final isIn = _accountIds.contains(tx['to_account_id']);
      if (isIn) counts[_categorize(tx)] = (counts[_categorize(tx)] ?? 0) + 1;
    }
    return counts;
  }

  double get _totalSpending => _spendingByCategory.values.fold(0, (a, b) => a + b);
  double get _totalIncome => _incomeByCategory.values.fold(0, (a, b) => a + b);
  int get _spendingTxCount => _filteredTransactions.where((tx) => _accountIds.contains(tx['from_account_id']) && !_accountIds.contains(tx['to_account_id'])).length;
  int get _incomeTxCount => _filteredTransactions.where((tx) => _accountIds.contains(tx['to_account_id'])).length;

  double _parseAmount(Map<String, dynamic> tx) {
    return (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
  }

  String _categorize(Map<String, dynamic> tx) {
    final type = (tx['type'] ?? tx['description'] ?? '').toString().toLowerCase();
    if (type.contains('transfer')) return 'تحويلات';
    if (type.contains('deposit')) return 'إيداعات';
    if (type.contains('exchange')) return 'صرف عملات';
    if (type.contains('card')) return 'مدفوعات بطاقة';
    if (type.contains('fee')) return 'رسوم';
    return 'أخرى';
  }

  IconData _catIcon(String cat) {
    switch (cat) {
      case 'تحويلات': return Icons.send_rounded;
      case 'إيداعات': return Icons.account_balance_rounded;
      case 'صرف عملات': return Icons.swap_horiz_rounded;
      case 'مدفوعات بطاقة': return Icons.credit_card_rounded;
      case 'رسوم': return Icons.receipt_long_rounded;
      default: return Icons.help_outline_rounded;
    }
  }

  Color _catColor(String cat) {
    switch (cat) {
      case 'تحويلات': return const Color(0xFF3B82F6);
      case 'إيداعات': return AppTheme.primary;
      case 'صرف عملات': return const Color(0xFFF59E0B);
      case 'مدفوعات بطاقة': return const Color(0xFFA855F7);
      case 'رسوم': return const Color(0xFFEF4444);
      default: return const Color(0xFF6B7280);
    }
  }

  String _dateRangeLabel() {
    final now = DateTime.now();
    final m = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    if (_timeFilter == 0) return '1 ${m[now.month]} - ${now.day} ${m[now.month]}';
    if (_timeFilter == 1) return 'يناير ${now.year} - ${m[now.month]} ${now.year}';
    return 'كل الفترات';
  }

  // ═══════ Monthly Bar Data ═══════

  List<_MonthBar> _getMonthlyBars() {
    final now = DateTime.now();
    final bars = <_MonthBar>[];
    final monthNames = ['', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];

    // Show last 4 months
    for (int i = 3; i >= 0; i--) {
      final month = now.month - i;
      final year = now.year;
      final adjustedMonth = month <= 0 ? month + 12 : month;
      final adjustedYear = month <= 0 ? year - 1 : year;

      double spending = 0, income = 0;
      for (final tx in _transactions) {
        try {
          final dt = DateTime.parse(tx['created_at'] ?? '');
          if (dt.month == adjustedMonth && dt.year == adjustedYear) {
            final amt = _parseAmount(tx);
            final isOut = _accountIds.contains(tx['from_account_id']) && !_accountIds.contains(tx['to_account_id']);
            final isIn = _accountIds.contains(tx['to_account_id']);
            if (isOut) spending += amt;
            if (isIn) income += amt;
          }
        } catch (_) {}
      }
      bars.add(_MonthBar(
        label: monthNames[adjustedMonth].substring(0, 3),
        spending: spending,
        income: income,
      ));
    }
    return bars;
  }

  // ═══════ Build ═══════

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF111111),
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
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
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(Icons.person_outline_rounded, size: 18, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(width: 10),
                  const Text('الإحصائيات', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.settings_outlined, size: 20, color: Color(0xFF9CA3AF)),
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

            // ── Total Amount ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  _activeTab == 2
                    ? '€${_fmtNum(_totalIncome - _totalSpending)}'
                    : '€${_fmtNum(_activeTab == 0 ? _totalSpending : _totalIncome)}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text(_dateRangeLabel(), style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
              ]),
            ),
            const SizedBox(height: 24),

            // ── Bar Chart ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(height: 160, child: _buildBarChart()),
            ),
            const SizedBox(height: 20),

            // ── Time Filter ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  _filterChip('الشهر', 0),
                  _filterChip('السنة', 1),
                  _filterChip('كل الفترات', 2),
                ]),
              ),
            ),
            const SizedBox(height: 28),

            // ── Content based on tab ──
            if (_activeTab == 0) _buildSpendingContent(),
            if (_activeTab == 1) _buildIncomeContent(),
            if (_activeTab == 2) _buildCashFlowContent(),
          ]),
        ),
      ),
    );
  }

  // ═══════ Tab Chip (Lunar style) ═══════

  Widget _tabChip(String label, int idx) {
    final active = _activeTab == idx;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 13,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active ? Colors.black : const Color(0xFF9CA3AF),
        )),
      ),
    );
  }

  // ═══════ Filter Chip ═══════

  Widget _filterChip(String label, int idx) {
    final active = _timeFilter == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _timeFilter = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2A2A2A) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text(label, style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active ? Colors.white : const Color(0xFF6B7280),
          ))),
        ),
      ),
    );
  }

  // ═══════ Bar Chart (Lunar style) ═══════

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

    // Average
    double avg = 0;
    if (_activeTab == 0) avg = bars.map((b) => b.spending).reduce((a, b) => a + b) / bars.length;
    if (_activeTab == 1) avg = bars.map((b) => b.income).reduce((a, b) => a + b) / bars.length;

    return LayoutBuilder(builder: (_, constraints) {
      final chartHeight = constraints.maxHeight - 28;
      final barWidth = _activeTab == 2 ? 18.0 : 28.0;

      return Stack(children: [
        // Y-axis labels
        Positioned(right: 0, top: 0, child: Text(_fmtShort(maxVal), style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)))),
        Positioned(right: 0, top: chartHeight * 0.5, child: Text(_fmtShort(maxVal * 0.5), style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)))),
        Positioned(right: 0, bottom: 24, child: const Text('0', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)))),

        // Average line
        if (_activeTab != 2 && avg > 0) Positioned(
          left: 0, right: 40,
          top: chartHeight * (1 - avg / maxVal),
          child: Row(children: [
            Expanded(child: CustomPaint(painter: _DashedLinePainter(color: AppTheme.primary.withValues(alpha: 0.6)))),
            const SizedBox(width: 4),
            Text('م: ${_fmtShort(avg)}', style: TextStyle(fontSize: 9, color: AppTheme.primary.withValues(alpha: 0.8))),
          ]),
        ),

        // Bars
        Positioned(
          left: 0, right: 50, bottom: 0, top: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: bars.map((b) {
              if (_activeTab == 2) {
                // Cash flow: side-by-side green + gray bars
                final incH = maxVal > 0 ? (b.income / maxVal) * chartHeight : 0.0;
                final expH = maxVal > 0 ? (b.spending / maxVal) * chartHeight : 0.0;
                return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Container(
                      width: barWidth, height: incH.clamp(3, chartHeight),
                      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      width: barWidth, height: expH.clamp(3, chartHeight),
                      decoration: BoxDecoration(color: const Color(0xFF4B5563), borderRadius: BorderRadius.circular(4)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  Text(b.label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                ]);
              } else {
                // Spending or income: single bar
                final val = _activeTab == 0 ? b.spending : b.income;
                final h = maxVal > 0 ? (val / maxVal) * chartHeight : 0.0;
                final color = _activeTab == 0
                    ? const Color(0xFFE5E7EB) // Gray for spending (Lunar style)
                    : AppTheme.primary; // Green for income
                return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    width: barWidth, height: h.clamp(3, chartHeight),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
                  ),
                  const SizedBox(height: 6),
                  Text(b.label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                ]);
              }
            }).toList(),
          ),
        ),
      ]);
    });
  }

  // ═══════ Spending Content ═══════

  Widget _buildSpendingContent() {
    final data = _spendingByCategory;
    final counts = _spendingCounts;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Header
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: const [
            Text('الفئات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF6B7280)),
          ]),
        ]),
      ),
      const SizedBox(height: 12),

      if (data.isEmpty)
        _emptyState()
      else
        ...(data.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).map((e) =>
          _categoryRow(e.key, counts[e.key] ?? 0, e.value, _catIcon(e.key), _catColor(e.key)),
        ),
    ]);
  }

  // ═══════ Income Content ═══════

  Widget _buildIncomeContent() {
    final data = _incomeByCategory;
    final counts = _incomeCounts;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Text('المعاملات', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      const SizedBox(height: 12),

      if (data.isEmpty)
        _emptyState()
      else
        ...(data.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).map((e) =>
          _categoryRow(e.key, counts[e.key] ?? 0, e.value, _catIcon(e.key), _catColor(e.key), isIncome: true),
        ),
    ]);
  }

  // ═══════ Cash Flow Content ═══════

  Widget _buildCashFlowContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        // Income row
        _cashFlowRow(
          icon: Icons.add_rounded,
          iconColor: AppTheme.primary,
          label: 'الدخل',
          count: _incomeTxCount,
          amount: _totalIncome,
        ),
        const SizedBox(height: 10),
        // Expenses row
        _cashFlowRow(
          icon: Icons.remove_rounded,
          iconColor: const Color(0xFF6B7280),
          label: 'المصروفات',
          count: _spendingTxCount,
          amount: _totalSpending,
        ),
      ]),
    );
  }

  Widget _cashFlowRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int count,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          Text('$count عملية', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        ])),
        Text('€${_fmtNum(amount)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF4B5563)),
      ]),
    );
  }

  // ═══════ Category Row (Lunar dark style) ═══════

  Widget _categoryRow(String name, int count, double amount, IconData icon, Color color, {bool isIncome = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(21),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          Text('$count عملية', style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        ])),
        Text(
          '${isIncome ? "" : "-"}€${_fmtNum(amount)}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ]),
    );
  }

  // ═══════ Empty State ═══════

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(child: Column(children: [
        Icon(Icons.insights_rounded, size: 48, color: const Color(0xFF4B5563).withValues(alpha: 0.4)),
        const SizedBox(height: 12),
        const Text('لا توجد بيانات لهذه الفترة', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
      ])),
    );
  }

  // ═══════ Helpers ═══════

  String _fmtNum(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _fmtShort(double n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toStringAsFixed(0);
  }
}

// ═══════ Month bar data ═══════

class _MonthBar {
  final String label;
  final double spending;
  final double income;
  _MonthBar({required this.label, required this.spending, required this.income});
}

// ═══════ Dashed line painter ═══════

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.5;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 4, 0), paint);
      x += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
