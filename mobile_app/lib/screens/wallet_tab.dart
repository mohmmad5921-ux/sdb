import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'account_detail_screen.dart';
import 'card_detail_page.dart';

class WalletTab extends StatefulWidget {
  const WalletTab({super.key});
  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  List<Map<String, dynamic>> _accounts = [];
  List<Map<String, dynamic>> _cards = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final dashR = await ApiService.getDashboard();
    final cardsR = await ApiService.getCards();
    if (mounted) {
      setState(() {
        if (dashR['success'] == true) {
          _accounts = List<Map<String, dynamic>>.from(dashR['data']?['accounts'] ?? []);
        }
        if (cardsR['success'] == true) {
          _cards = List<Map<String, dynamic>>.from(cardsR['data']?['cards'] ?? []);
        }
        _loading = false;
      });
    }
  }

  // Find the primary account (highest balance) and show its currency
  Map<String, dynamic>? get _primaryAccount {
    if (_accounts.isEmpty) return null;
    Map<String, dynamic> best = _accounts.first;
    double bestBal = 0;
    for (final a in _accounts) {
      final bal = (a['balance'] is num) ? (a['balance'] as num).toDouble() : double.tryParse(a['balance'].toString()) ?? 0;
      if (bal > bestBal) { bestBal = bal; best = a; }
    }
    return best;
  }

  double get _primaryBalance {
    final a = _primaryAccount;
    if (a == null) return 0;
    return (a['balance'] is num) ? (a['balance'] as num).toDouble() : double.tryParse(a['balance'].toString()) ?? 0;
  }

  String get _primaryCurrencySymbol {
    final a = _primaryAccount;
    if (a == null) return '€';
    final code = a['currency']?['code'] ?? 'EUR';
    return _sym(code);
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Header (Lunar: "Wallet" + "+" button) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.bgMuted,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(width: 10),
                  const Text('Wallet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                ]),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/deposit'),
                  child: Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.bgMuted,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.add_rounded, size: 22, color: AppTheme.textSecondary),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Cards Section (always show, with + card at end) ──
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _cards.length + 1, // +1 for add card
                itemBuilder: (_, i) {
                  // Last item = add card placeholder
                  if (i >= _cards.length) {
                    return GestureDetector(
                      onTap: _showIssueDialog,
                      child: Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: const Icon(Icons.add_rounded, size: 22, color: Color(0xFF9CA3AF)),
                          ),
                          const SizedBox(height: 6),
                          const Text('طلب بطاقة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
                        ]),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () async {
                      // Pass design based on index
                      final designs = ['marble', 'whiteGreen', 'waves'];
                      final cardData = Map<String, dynamic>.from(_cards[i]);
                      cardData['card_design'] = designs[i % designs.length];
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (_) => CardDetailPage(card: cardData),
                      ));
                      _load();
                    },
                    child: _buildBigCard(_cards[i], i),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // ── Konti (Accounts) Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t.myWallets, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                Text(
                  '${_primaryCurrencySymbol}${_formatNum(_primaryBalance)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textMuted),
                ),
              ]),
            ),
            const SizedBox(height: 12),

            // Account items (tap to open detail with ocean background)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: _accounts.asMap().entries.map((entry) {
                  final i = entry.key;
                  final a = entry.value;
                  return Column(children: [
                    _buildAccountRow(a),
                    if (i < _accounts.length - 1)
                      Divider(height: 1, color: AppTheme.border, indent: 68),
                  ]);
                }).toList(),
              ),
            ),

            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  // ── Big Card (uses card design images) ──
  Widget _buildBigCard(Map<String, dynamic> card, int index) {
    final last4 = _last4(card);
    final isFrozen = card['status'] == 'frozen';

    // Cycle through card designs
    final designs = ['assets/cards/card_marble.png', 'assets/cards/card_classic.png', 'assets/cards/card_waves.png'];
    final assetPath = designs[index % designs.length];
    final isDark = (index % designs.length) != 1; // classic is light

    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset(assetPath, fit: BoxFit.cover),
          if (isFrozen) Container(color: Colors.black.withValues(alpha: 0.4)),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // Top: SDB logo
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('SDB', style: TextStyle(color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF111827), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
                if (isFrozen) Icon(Icons.ac_unit_rounded, size: 12, color: isDark ? Colors.white70 : const Color(0xFF6B7280)),
              ]),
              const Spacer(),
              // Bottom: last 4 + Mastercard circles
              Text('•••• $last4', style: TextStyle(color: isDark ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF111827), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
              const SizedBox(height: 4),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // Mastercard circles
                SizedBox(width: 28, height: 18, child: Stack(children: [
                  Positioned(left: 0, child: Container(width: 18, height: 18, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEB001B)))),
                  Positioned(left: 10, child: Container(width: 18, height: 18, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFF79E1B).withValues(alpha: 0.9)))),
                ])),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Account Row (Lunar: avatar, name, account number, balance) ──
  Widget _buildAccountRow(Map<String, dynamic> account) {
    final currency = account['currency']?['code'] ?? 'EUR';
    final balance = (account['balance'] is num)
        ? (account['balance'] as num).toDouble()
        : double.tryParse(account['balance'].toString()) ?? 0;
    final symbol = _sym(currency);
    final accNum = account['account_number'] ?? account['iban'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => AccountDetailScreen(account: account),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          // Avatar circle
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: AppTheme.bgMuted,
              borderRadius: BorderRadius.circular(21),
            ),
            child: Center(child: Icon(Icons.person, size: 20, color: AppTheme.textSecondary)),
          ),
          const SizedBox(width: 14),
          // Name + account number
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${L10n.of(context).account} $currency', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            if (accNum.isNotEmpty)
              Text(accNum, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          // Balance
          Text(
            '$symbol${_formatNum(balance)}',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
          ),
        ]),
      ),
    );
  }

  // ── Issue Card Flow ──
  Future<void> _showIssueDialog() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _WalletCardIssueSheet(accounts: _accounts, existingCards: _cards),
    );
    if (result != null) {
      _issueCard(result['wallet_id'] as int);
    }
  }

  Future<void> _issueCard(int walletId) async {
    setState(() => _loading = true);
    final r = await ApiService.issueCard(walletId);
    if (r['success'] == true) {
      await _load();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(r['success'] == true ? 'تم إصدار البطاقة بنجاح! ✅' : (r['data']?['message'] ?? 'خطأ')),
        backgroundColor: r['success'] == true ? AppTheme.primary : const Color(0xFFEF4444),
      ));
    }
  }

  String _last4(Map<String, dynamic> card) {
    final m = card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '';
    return m.length >= 4 ? m.substring(m.length - 4) : '••••';
  }

  String _sym(String c) => {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[c] ?? c;

  String _formatNum(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}

// ── Card Issue Sheet (wallet selection + design + terms) ──
class _WalletCardIssueSheet extends StatefulWidget {
  final List<Map<String, dynamic>> accounts;
  final List<Map<String, dynamic>> existingCards;
  const _WalletCardIssueSheet({required this.accounts, required this.existingCards});
  @override
  State<_WalletCardIssueSheet> createState() => _WalletCardIssueSheetState();
}

class _WalletCardIssueSheetState extends State<_WalletCardIssueSheet> {
  bool _agreed = false;
  CardDesign _selectedDesign = CardDesign.marble;
  int? _selectedWalletId;

  @override
  void initState() {
    super.initState();
    final usedIds = widget.existingCards.map((c) => c['account_id']?.toString()).whereType<String>().toSet();
    final available = widget.accounts.where((a) => !usedIds.contains(a['id']?.toString())).toList();
    if (available.isNotEmpty) _selectedWalletId = int.tryParse(available.first['id'].toString());
  }

  bool _hasCard(int walletId) => widget.existingCards.any((c) => c['account_id']?.toString() == walletId.toString());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Color(0xFFECFDF5), shape: BoxShape.circle),
            child: const Icon(Icons.credit_card_rounded, size: 36, color: Color(0xFF10B981))),
          const SizedBox(height: 16),
          const Text('طلب بطاقة جديدة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 8),
          const Text('بطاقة Mastercard رقمية للدفع أونلاين وفي المتاجر', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
          const SizedBox(height: 20),

          // ── Wallet Selection ──
          const Align(alignment: Alignment.centerRight, child: Text('ربط البطاقة بالمحفظة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827)))),
          const SizedBox(height: 8),
          ...widget.accounts.map((w) {
            final id = int.tryParse(w['id'].toString()) ?? 0;
            final hasCard = _hasCard(id);
            final isSelected = _selectedWalletId == id;
            final currency = w['currency']?['code'] ?? w['currency'] ?? '';
            final balance = w['balance']?.toString() ?? '0';
            return GestureDetector(
              onTap: hasCard ? () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('⚠️ كل محفظة يحق لها بطاقة واحدة فقط'), backgroundColor: Color(0xFFEF4444)));
              } : () => setState(() => _selectedWalletId = id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: hasCard ? const Color(0xFFF9FAFB) : (isSelected ? const Color(0xFFECFDF5) : Colors.white),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: hasCard ? const Color(0xFFE5E7EB) : (isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB)), width: isSelected ? 2 : 1),
                ),
                child: Row(children: [
                  Container(
                    width: 22, height: 22,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF10B981) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? const Color(0xFF10B981) : const Color(0xFFD1D5DB), width: 1.5),
                    ),
                    child: isSelected ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${L10n.of(context).account} $currency', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: hasCard ? const Color(0xFF9CA3AF) : const Color(0xFF111827))),
                    Text('$balance $currency', style: TextStyle(fontSize: 11, color: hasCard ? const Color(0xFFD1D5DB) : const Color(0xFF9CA3AF))),
                  ])),
                  if (hasCard) Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(8)),
                    child: const Text('يوجد بطاقة', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            );
          }),
          const SizedBox(height: 16),

          // ── Design Picker ──
          CardDesignPicker(selected: _selectedDesign, onChanged: (d) => setState(() => _selectedDesign = d)),
          const SizedBox(height: 16),

          // ── Terms ──
          GestureDetector(
            onTap: () => setState(() => _agreed = !_agreed),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _agreed ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _agreed ? const Color(0xFF10B981) : const Color(0xFFE5E7EB)),
              ),
              child: Row(children: [
                Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    color: _agreed ? const Color(0xFF10B981) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: _agreed ? const Color(0xFF10B981) : const Color(0xFFD1D5DB), width: 1.5),
                  ),
                  child: _agreed ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
                ),
                const SizedBox(width: 12),
                const Expanded(child: Text('أوافق على شروط وأحكام إصدار البطاقة وسياسة الخصوصية', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280), fontWeight: FontWeight.w500))),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // ── Confirm ──
          GestureDetector(
            onTap: (_agreed && _selectedWalletId != null) ? () => Navigator.pop(context, {'wallet_id': _selectedWalletId, 'design': _selectedDesign.name}) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 54,
              decoration: BoxDecoration(
                gradient: (_agreed && _selectedWalletId != null) ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]) : null,
                color: (_agreed && _selectedWalletId != null) ? null : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(16),
                boxShadow: (_agreed && _selectedWalletId != null) ? [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))] : null,
              ),
              child: Center(child: Text('إصدار البطاقة', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: (_agreed && _selectedWalletId != null) ? Colors.white : const Color(0xFF9CA3AF),
              ))),
            ),
          ),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }
}
