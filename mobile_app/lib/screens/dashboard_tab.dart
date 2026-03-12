import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class DashboardTab extends StatefulWidget {
  final Function(int)? onTabChange;
  const DashboardTab({super.key, this.onTabChange});
  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  Map<String, dynamic>? _data;
  bool _loading = true;
  int _activeWallet = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await ApiService.getDashboard();
    if (r['success'] == true) setState(() { _data = r['data']; _loading = false; });
    else setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
    }
    final user = _data?['user'] ?? {};
    final accounts = List<Map<String, dynamic>>.from(_data?['accounts'] ?? []);
    final transactions = List<Map<String, dynamic>>.from(_data?['recentTransactions'] ?? []);
    final unread = _data?['unreadNotifications'] ?? 0;
    final name = (user['full_name'] ?? 'User').toString().split(' ').first;
    final initials = _getInitials(user['full_name'] ?? 'U');

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 16),
          child: Builder(builder: (ctx) {
            final t = L10n.of(ctx);
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(19)),
                  child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_greeting(t), style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                ])),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(19)),
                    child: Stack(children: [
                      const Center(child: Icon(Icons.notifications_none_rounded, size: 20, color: AppTheme.textSecondary)),
                      if (unread > 0) Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(4)))),
                    ]),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 14),

            // KYC Activation Banner
            if ((user['kyc_status'] ?? 'pending') != 'verified')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/kyc');
                    _load(); // Refresh after returning
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          (user['kyc_status'] == 'submitted') ? 'حسابك قيد المراجعة' : 'حسابك غير مفعّل',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (user['kyc_status'] == 'submitted') ? 'سيتم إشعارك عند اكتمال التحقق' : 'فعّل حسابك بإرسال المستندات المطلوبة',
                          style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                        ),
                      ])),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFD97706)),
                    ]),
                  ),
                ),
              ),
            if ((user['kyc_status'] ?? 'pending') != 'verified')
              const SizedBox(height: 14),

            // Balance Card
            _buildBalanceCard(accounts),
            const SizedBox(height: 20),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _buildQuickAction(Icons.send_rounded, t.send, AppTheme.primary, true, () => Navigator.pushNamed(context, '/transfer')),
                _buildQuickAction(Icons.download_rounded, t.receive, AppTheme.bgMuted, false, () => _showReceive(accounts, t)),
                _buildQuickAction(Icons.add_circle_outline_rounded, t.addMoney, AppTheme.bgMuted, false, () => Navigator.pushNamed(context, '/deposit')),
                _buildQuickAction(Icons.swap_horiz_rounded, t.exchange, AppTheme.bgMuted, false, () => Navigator.pushNamed(context, '/exchange')),
                _buildQuickAction(Icons.smart_toy_rounded, 'SDB AI', const Color(0xFF8B5CF6), true, () => Navigator.pushNamed(context, '/ai-chat')),
              ]),
            ),
            const SizedBox(height: 24),

            // Wallets
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t.myWallets, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                GestureDetector(
                  onTap: () => widget.onTabChange?.call(2),
                  child: Text(t.seeAll, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primary)),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: accounts.length + 1, // +1 for Add Wallet card
                itemBuilder: (_, i) {
                  if (i < accounts.length) return _buildWalletCard(accounts[i], i);
                  return _buildAddWalletCard();
                },
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t.recentTransactions, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                GestureDetector(
                  onTap: () => widget.onTabChange?.call(3),
                  child: Text(t.seeAll, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primary)),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            if (transactions.isEmpty)
              _buildEmptyState()
            else
              ...transactions.take(5).map((tx) => _buildTransactionItem(tx, accounts)),
          ]);
          }),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(List<Map<String, dynamic>> accounts) {
    final t = L10n.of(context);
    final wallet = accounts.isNotEmpty && _activeWallet < accounts.length ? accounts[_activeWallet] : null;
    final balance = wallet?['balance'] ?? 0;
    final currency = wallet?['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.totalBalance, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            '$symbol${_formatNumber(balance)}',
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
              child: Text(t.thisMonth, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 8),
            Text('${t.account} $currency', style: const TextStyle(color: Colors.white60, fontSize: 11)),
          ]),
        ]),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color bg, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: isPrimary ? AppTheme.primary : bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
          ),
          child: Icon(icon, size: 20, color: isPrimary ? Colors.white : AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildWalletCard(Map<String, dynamic> account, int index) {
    final isActive = _activeWallet == index;
    final currency = account['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);
    final balance = account['balance'] ?? 0;
    final flag = _currencyFlag(currency);

    return GestureDetector(
      onTap: () => setState(() => _activeWallet = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 120,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: isActive ? null : Border.all(color: AppTheme.border),
          boxShadow: isActive ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(flag, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(currency, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isActive ? Colors.white70 : AppTheme.textMuted)),
          ]),
          const Spacer(),
          Text(
            '$symbol${_formatNumber(balance)}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isActive ? Colors.white : AppTheme.textPrimary),
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      ),
    );
  }

  Widget _buildAddWalletCard() {
    return GestureDetector(
      onTap: _showOpenWalletSheet,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.add_rounded, size: 18, color: AppTheme.primary),
          ),
          const SizedBox(height: 6),
          Text('محفظة', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.primary)),
        ]),
      ),
    );
  }

  void _showOpenWalletSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return FutureBuilder<Map<String, dynamic>>(
          future: ApiService.getAvailableWallets(),
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
            }
            final currencies = List<Map<String, dynamic>>.from(snap.data?['currencies'] ?? []);
            if (currencies.isEmpty) {
              return SizedBox(height: 200, child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_outline, size: 40, color: AppTheme.primary),
                  const SizedBox(height: 12),
                  const Text('لديك جميع المحافظ المتاحة', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
                ]),
              ));
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 16),
                const Text('فتح محفظة جديدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                const SizedBox(height: 4),
                const Text('اختر العملة', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const SizedBox(height: 16),
                ...currencies.map((c) => _buildCurrencyOption(c)),
                const SizedBox(height: 8),
              ]),
            );
          },
        );
      },
    );
  }

  Widget _buildCurrencyOption(Map<String, dynamic> currency) {
    final flag = currency['flag_icon'] ?? '🏳';
    final code = currency['code'] ?? '';
    final name = currency['name_ar'] ?? currency['name'] ?? '';
    final symbol = currency['symbol'] ?? '';

    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        setState(() => _loading = true);
        final result = await ApiService.openWallet(code);
        if (result['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم فتح محفظة $code بنجاح ✓'), backgroundColor: AppTheme.primary),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'حدث خطأ'), backgroundColor: Colors.red),
          );
        }
        _load();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(code, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            Text(name, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          Text(symbol, style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
          const SizedBox(width: 8),
          Icon(Icons.add_circle_outline, color: AppTheme.primary, size: 22),
        ]),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx, List<Map<String, dynamic>> accounts) {
    final t = L10n.of(context);
    final accountIds = accounts.map((a) => a['id']).toSet();
    final isIncoming = accountIds.contains(tx['to_account_id']);
    final amount = (tx['amount'] ?? 0).toDouble();
    final currency = tx['currency']?['code'] ?? tx['from_account']?['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);
    final status = tx['status'] ?? 'completed';
    final desc = tx['description'] ?? (tx['type'] ?? 'Transfer');
    final date = tx['created_at'] ?? '';
    final initials = desc.toString().isNotEmpty ? desc.toString().substring(0, min(2, desc.toString().length)).toUpperCase() : 'TX';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: isIncoming ? const Color(0xFFE8F5F0) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(initials, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: isIncoming ? AppTheme.primary : AppTheme.danger))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(desc.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis),
            Text(_formatDate(date), style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(
              '${isIncoming ? "+" : "-"}$symbol${_formatNumber(amount)}',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isIncoming ? AppTheme.primary : AppTheme.textPrimary),
            ),
            if (status == 'pending') Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(color: AppTheme.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: Text(t.pending, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.warning)),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildEmptyState() {
    final t = L10n.of(context);
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(child: Column(children: [
        Icon(Icons.receipt_long_rounded, size: 48, color: AppTheme.textMuted.withOpacity(0.3)),
        const SizedBox(height: 12),
        Text(t.noTransactions, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
      ])),
    );
  }

  // Helpers
  int min(int a, int b) => a < b ? a : b;

  String _greeting(AppStrings t) {
    final h = DateTime.now().hour;
    if (h < 12) return t.goodMorning;
    if (h < 17) return t.goodAfternoon;
    return t.goodEvening;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String _currencySymbol(String code) {
    const m = {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'};
    return m[code] ?? code;
  }

  String _currencyFlag(String code) {
    const m = {'EUR': '🇪🇺', 'USD': '🇺🇸', 'SYP': '🇸🇾', 'GBP': '🇬🇧', 'DKK': '🇩🇰'};
    return m[code] ?? '💰';
  }

  String _formatNumber(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _formatDate(String d) {
    if (d.isEmpty) return '';
    try {
      final dt = DateTime.parse(d);
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      final yesterday = now.subtract(const Duration(days: 1));
      if (dt.day == yesterday.day && dt.month == yesterday.month && dt.year == yesterday.year) {
        return 'Yesterday';
      }
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return d; }
  }

  void _showReceive(List<Map<String, dynamic>> accounts, AppStrings t) {
    final acc = accounts.isNotEmpty ? accounts[_activeWallet] : null;
    final iban = acc?['iban'] ?? acc?['account_number'] ?? 'N/A';
    final currency = acc?['currency']?['code'] ?? 'EUR';
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(t.receiveMoneyTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.qr_code_2, size: 60, color: AppTheme.primary),
        ),
        const SizedBox(height: 16),
        Text(t.yourAccountDetails, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(t.account, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              Text(iban, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(t.currency, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              Text(currency, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(t.bank, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
              const Text('SDB Bank', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            ]),
          ]),
        ),
        const SizedBox(height: 16),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account details copied ✓'), backgroundColor: AppTheme.primary)); },
          icon: const Icon(Icons.copy, size: 16),
          label: Text(t.copyDetails),
        )),
      ]),
    ));
  }
}
