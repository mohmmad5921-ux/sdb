import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'account_detail_screen.dart';
import 'account_background_picker.dart';
import 'transaction_detail_page.dart';

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
  final _pageCtrl = PageController(viewportFraction: 0.92);


  @override
  void initState() {
    super.initState();
    _load();
  }

  final Map<dynamic, int> _bgIndices = {};
  Future<void> _loadBackground() async {
    final accounts = List<Map<String, dynamic>>.from(_data?['accounts'] ?? []);
    for (final acc in accounts) {
      final id = acc['id'] ?? 0;
      final idx = await AccountBackgroundPicker.getSavedBgIndex(id);
      _bgIndices[id] = idx;
    }
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    try {
      setState(() => _loading = true);
      final r = await ApiService.getDashboard();
      if (mounted) {
        if (r['success'] == true) _data = r['data'];
        setState(() => _loading = false);
        _loadBackground();
      }
    } catch (e) {
      debugPrint('🔴 Dashboard load error: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
    final user = _data?['user'] ?? {};
    final accounts = List<Map<String, dynamic>>.from(_data?['accounts'] ?? []);
    final transactions = List<Map<String, dynamic>>.from(_data?['recentTransactions'] ?? []);
    final unread = _data?['unreadNotifications'] ?? 0;
    final name = (user['full_name'] ?? 'User').toString().split(' ').first;
    final initials = _getInitials(user['full_name'] ?? 'U');
    final t = L10n.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, bottom: 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Header (Lunar style: avatar left, name, Explore right) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(children: [
                GestureDetector(
                  onTap: () => widget.onTabChange?.call(4), // Go to Profile
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: const Color(0xFFF9A8D4), borderRadius: BorderRadius.circular(20)),
                    child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_greeting(t), style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                ])),
                // Explore button (like Lunar's green "Udforsk" button)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/explore'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
                    child: Text(L10n.of(context).explore, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                // Notifications
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/notifications'),
                  child: Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(19)),
                    child: Stack(children: [
                      const Center(child: Icon(Icons.notifications_none_rounded, size: 20, color: AppTheme.textSecondary)),
                      if (unread > 0) Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppTheme.danger, borderRadius: BorderRadius.circular(4)))),
                    ]),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // ── KYC Activation Banner ──
            if ((user['kyc_status'] ?? 'pending') != 'verified')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.pushNamed(context, '/kyc');
                    _load();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)]),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                    ),
                    child: Row(children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFD97706), size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          (user['kyc_status'] == 'submitted') ? 'الحساب قيد المراجعة' : 'الحساب غير موثّق',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                        ),
                        Text(
                          (user['kyc_status'] == 'submitted') ? 'سيتم إشعارك عند التوثيق' : 'وثّق هويتك لتفعيل الحساب',
                          style: const TextStyle(fontSize: 11, color: Color(0xFFB45309)),
                        ),
                      ])),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFD97706)),
                    ]),
                  ),
                ),
              ),
            if ((user['kyc_status'] ?? 'pending') != 'verified') const SizedBox(height: 14),

            // ── Balance Card (Lunar style: gradient card, swipe between accounts) ──
            if (accounts.isNotEmpty) SizedBox(
              height: 240,
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: accounts.length,
                onPageChanged: (i) => setState(() => _activeWallet = i),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(
                      builder: (_) => AccountDetailScreen(account: accounts[i]),
                    ));
                    _loadBackground();
                  },
                  child: _buildBalanceCard(accounts[i]),
                ),
              ),
            ),

            // Dots indicator
            if (accounts.length > 1) ...[
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(accounts.length, (i) =>
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: i == _activeWallet ? 20 : 8, height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _activeWallet ? AppTheme.primary : AppTheme.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              )),
            ],
            const SizedBox(height: 20),

            // ── Quick Actions (Lunar style: Betal, Kort, Indsæt, SDB AI) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                _buildQuickAction(Icons.send_rounded, t.send, AppTheme.primary, () => Navigator.pushNamed(context, '/transfer')),
                _buildQuickAction(Icons.credit_card_rounded, t.navCards, AppTheme.textSecondary, () => widget.onTabChange?.call(1)),
                _buildQuickAction(Icons.add_circle_outline_rounded, t.addMoney, AppTheme.textSecondary, () => Navigator.pushNamed(context, '/deposit')),
                _buildQuickAction(Icons.smart_toy_rounded, 'SDB AI', const Color(0xFF8B5CF6), () => Navigator.pushNamed(context, '/ai-chat')),
              ]),
            ),
            const SizedBox(height: 24),



            // ── Recent Transactions (Lunar style: grouped by date) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(t.recentTransactions, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                GestureDetector(
                  onTap: () => widget.onTabChange?.call(3), // Insights
                  child: Text(t.seeAll, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primary)),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            if (transactions.isEmpty) _buildEmptyState()
            else ...transactions.take(5).map((tx) => _buildTransactionItem(tx, accounts)),

            const SizedBox(height: 24),

            // ── AI Assistant Section (Lunar-style "Hvordan kan jeg hjælpe dig?") ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/ai-chat'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [const Color(0xFF8B5CF6).withValues(alpha: 0.08), const Color(0xFF3B82F6).withValues(alpha: 0.05)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.15)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.smart_toy_rounded, size: 24, color: Color(0xFF8B5CF6)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(L10n.of(context).howCanIHelp, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      Text(L10n.of(context).askAssistant, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                    ])),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Support Section (Lunar style) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/help'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.support_agent_rounded, size: 18, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.contactSupport, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                      Text('support@sdb-bank.com', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                    ])),
                    Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
                  ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Dynamic background for balance card ──
  Widget _buildDynamicBg(dynamic accountId) {
    final bgIdx = _bgIndices[accountId] ?? 0;
    final bgColors = AccountBackgroundPicker.getBgColors(bgIdx);
    final hasWaves = AccountBackgroundPicker.hasBgWaves(bgIdx);
    final bgImage = AccountBackgroundPicker.getBgImage(bgIdx);

    return Stack(children: [
      if (bgImage != null) ...[
        Positioned.fill(child: Image.asset(bgImage, fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.3))),
      ] else
        Positioned.fill(child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: bgColors),
          ),
        )),
      if (hasWaves) Positioned.fill(child: CustomPaint(painter: _OceanWavePainter())),
    ]);
  }

  // ── Balance Card (Lunar-style: ocean wave background) ──
  Widget _buildBalanceCard(Map<String, dynamic> account) {
    final t = L10n.of(context);
    final balance = (account['balance'] is num) ? (account['balance'] as num).toDouble() : double.tryParse(account['balance'].toString()) ?? 0;
    final currency = account['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(children: [
            // Dynamic background based on saved preference
            Positioned.fill(
              child: _buildDynamicBg(account['id']),
            ),

            // Content overlay
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(height: 8),
                // Account name (centered like Lunar)
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.person, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                  const SizedBox(width: 6),
                  Text(
                    '${t.account} $currency',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 14, color: Colors.white.withValues(alpha: 0.6)),
                ]),
                const SizedBox(height: 8),

                // Big balance (centered)
                Text(
                  '$symbol${_formatNumber(balance)}',
                  style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                ),
                const Spacer(),

                // Action buttons at bottom (Lunar style: Betal, Kort, ...)
                Row(children: [
                  _balanceAction(Icons.swap_vert_rounded, t.send, () => Navigator.pushNamed(context, '/transfer')),
                  const SizedBox(width: 10),
                  _balanceAction(Icons.credit_card_rounded, t.navCards, () => widget.onTabChange?.call(1)),
                  const SizedBox(width: 10),
                  _balanceAction(Icons.add_rounded, '+ ${t.addMoney}', () => Navigator.pushNamed(context, '/deposit')),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showReceive(List<Map<String, dynamic>>.from(_data?['accounts'] ?? []), t),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(22)),
                      child: Icon(Icons.more_horiz_rounded, size: 22, color: Colors.white.withValues(alpha: 0.9)),
                    ),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _balanceAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(24)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  // ── Quick Action ──
  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            color: color == AppTheme.primary ? AppTheme.primary : AppTheme.bgMuted,
            borderRadius: BorderRadius.circular(16),
            boxShadow: color == AppTheme.primary ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3))] : null,
          ),
          child: Icon(icon, size: 22, color: color == AppTheme.primary ? Colors.white : (color == const Color(0xFF8B5CF6) ? color : AppTheme.textSecondary)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  // ── Mini Card (Lunar style: varied colors, bigger) ──
  Widget _buildMiniCard(Map<String, dynamic> card, int index) {
    final last4 = _last4(card);
    final isFrozen = card['status'] == 'frozen';

    // Varied card colors like Lunar (Black, Orange, Blue)
    final cardColors = [
      [const Color(0xFF0F172A), const Color(0xFF1E293B)], // Black
      [const Color(0xFFEA580C), const Color(0xFFF97316)],  // Orange
      [const Color(0xFF1E40AF), const Color(0xFF3B82F6)],  // Blue gradient
      [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],  // Purple
    ];
    final colors = isFrozen
        ? [const Color(0xFF94A3B8), const Color(0xFF64748B)]
        : cardColors[index % cardColors.length];

    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('SDB', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
          if (isFrozen) Icon(Icons.ac_unit_rounded, size: 14, color: Colors.white.withValues(alpha: 0.7)),
        ]),
        const SizedBox(height: 4),
        Text('•••• $last4', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1)),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('VISA', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ]),
      ]),
    );
  }

  // ── Transaction Item ──
  Widget _buildTransactionItem(Map<String, dynamic> tx, List<Map<String, dynamic>> accounts) {
    final accountIds = accounts.map((a) => a['id']).toSet();
    final isIncoming = accountIds.contains(tx['to_account_id']);
    final amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
    final currency = tx['currency']?['code'] ?? tx['from_account']?['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);
    final status = tx['status'] ?? 'completed';
    final desc = tx['description'] ?? (tx['type'] ?? 'Transfer');
    final date = tx['created_at'] ?? '';
    final initial = desc.toString().isNotEmpty ? desc.toString().substring(0, _min(2, desc.toString().length)).toUpperCase() : 'TX';

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => TransactionDetailPage(tx: tx, isIncoming: isIncoming),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: isIncoming ? const Color(0xFFE8F5F0) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(
                isIncoming ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                size: 18, color: isIncoming ? AppTheme.primary : AppTheme.danger,
              )),
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
                decoration: BoxDecoration(color: AppTheme.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(L10n.of(context).pending, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.warning)),
              ),
            ]),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 16, color: AppTheme.textMuted.withValues(alpha: 0.5)),
          ]),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Center(child: Column(children: [
        Icon(Icons.receipt_long_rounded, size: 48, color: AppTheme.textMuted.withValues(alpha: 0.3)),
        const SizedBox(height: 12),
        Text(L10n.of(context).noTransactions, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
      ])),
    );
  }

  // ── Receive ──
  void _showReceive(List<Map<String, dynamic>> accounts, AppStrings t) {
    final acc = accounts.isNotEmpty && _activeWallet < accounts.length ? accounts[_activeWallet] : null;
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
          onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.detailsCopied), backgroundColor: AppTheme.primary)); },
          icon: const Icon(Icons.copy, size: 16),
          label: Text(t.copyDetails),
        )),
      ]),
    ));
  }

  // ── Helpers ──
  int _min(int a, int b) => a < b ? a : b;

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

  String _currencySymbol(String code) => {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[code] ?? code;
  String _currencyFlag(String code) => {'EUR': '🇪🇺', 'USD': '🇺🇸', 'SYP': '🇸🇾', 'GBP': '🇬🇧', 'DKK': '🇩🇰'}[code] ?? '💰';

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
      if (dt.day == yesterday.day && dt.month == yesterday.month && dt.year == yesterday.year) return 'أمس';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return d; }
  }

  String _last4(Map<String, dynamic> card) {
    final m = card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '';
    return m.length >= 4 ? m.substring(m.length - 4) : m;
  }
}

// ── Ocean Wave Background Painter (Lunar-style) ──
class _OceanWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Deep ocean base
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0C2D48), Color(0xFF145369), Color(0xFF0A3D5C)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), basePaint);

    // Wave layer 1 (deep teal, bottom)
    final wave1 = Paint()..color = const Color(0xFF0E4D64).withValues(alpha: 0.7);
    final p1 = Path();
    p1.moveTo(0, h * 0.55);
    p1.cubicTo(w * 0.2, h * 0.45, w * 0.35, h * 0.65, w * 0.5, h * 0.55);
    p1.cubicTo(w * 0.65, h * 0.45, w * 0.8, h * 0.6, w, h * 0.5);
    p1.lineTo(w, h);
    p1.lineTo(0, h);
    p1.close();
    canvas.drawPath(p1, wave1);

    // Wave layer 2 (lighter teal, mid)
    final wave2 = Paint()..color = const Color(0xFF1A7C8E).withValues(alpha: 0.4);
    final p2 = Path();
    p2.moveTo(0, h * 0.65);
    p2.cubicTo(w * 0.15, h * 0.55, w * 0.3, h * 0.72, w * 0.5, h * 0.62);
    p2.cubicTo(w * 0.7, h * 0.52, w * 0.85, h * 0.68, w, h * 0.6);
    p2.lineTo(w, h);
    p2.lineTo(0, h);
    p2.close();
    canvas.drawPath(p2, wave2);

    // Wave layer 3 (dark bottom)
    final wave3 = Paint()..color = const Color(0xFF0A2A3C).withValues(alpha: 0.6);
    final p3 = Path();
    p3.moveTo(0, h * 0.78);
    p3.cubicTo(w * 0.25, h * 0.72, w * 0.4, h * 0.82, w * 0.55, h * 0.76);
    p3.cubicTo(w * 0.7, h * 0.7, w * 0.85, h * 0.78, w, h * 0.74);
    p3.lineTo(w, h);
    p3.lineTo(0, h);
    p3.close();
    canvas.drawPath(p3, wave3);

    // Subtle light reflection spots
    final spot1 = Paint()..color = const Color(0xFF5DBED2).withValues(alpha: 0.12);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.3, h * 0.3), width: w * 0.4, height: h * 0.25), spot1);

    final spot2 = Paint()..color = const Color(0xFF7DD3E7).withValues(alpha: 0.08);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.7, h * 0.2), width: w * 0.3, height: h * 0.2), spot2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
