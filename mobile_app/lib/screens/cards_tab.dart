import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class CardsTab extends StatefulWidget {
  const CardsTab({super.key});
  @override
  State<CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<CardsTab> {
  List cards = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final r = await ApiService.getCards();
      if (r['success'] == true) {
        final d = r['data'];
        setState(() => cards = d is List ? d : d?['cards'] ?? d?['data'] ?? []);
      }
    } catch (_) {}
    setState(() => loading = false);
  }

  void _showIssueDialog() async {
    // Fetch accounts first
    List accounts = [];
    bool loadingAccounts = true;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setSheetState) {
        if (loadingAccounts) {
          ApiService.getAccounts().then((r) {
            if (r['success'] == true) {
              final d = r['data'];
              final list = d is List ? d : d?['accounts'] ?? d?['data'] ?? [];
              setSheetState(() { accounts = List.from(list); loadingAccounts = false; });
            } else {
              setSheetState(() => loadingAccounts = false);
            }
          });
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Handle bar
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
                child: Icon(Icons.credit_card_rounded, color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('إصدار بطاقة جديدة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                Text('اختر الحساب المرتبط', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ]),
            ]),
            const SizedBox(height: 20),

            if (loadingAccounts)
              const Padding(padding: EdgeInsets.all(30), child: CircularProgressIndicator(color: AppTheme.primary))
            else if (accounts.isEmpty)
              Padding(padding: const EdgeInsets.all(20), child: GestureDetector(
                onTap: () => _issueCard(0, ctx),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
                  ),
                  child: Column(children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(18)),
                      child: Icon(Icons.credit_card_rounded, size: 28, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 14),
                    const Text('إصدار بطاقة رقمية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 4),
                    Text('سيتم إنشاء حساب EUR تلقائياً', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
                      child: const Text('إصدار الآن', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ]),
                ),
              ))
            else
              ...accounts.map((acc) {
                final code = acc['currency']?['code'] ?? '';
                final symbol = acc['currency']?['symbol'] ?? '€';
                final balance = acc['balance'] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _issueCard(acc['id'], ctx),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
                          child: Center(child: Text(symbol, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.primary))),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('حساب $code', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                          Text('الرصيد: $balance $symbol', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        ])),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
                      ]),
                    ),
                  ),
                );
              }),
          ]),
        );
      }),
    );
  }

  Future<void> _issueCard(int accountId, BuildContext sheetCtx) async {
    Navigator.pop(sheetCtx);
    // Show loading
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: Colors.white)));

    final r = await ApiService.issueCard(accountId);

    if (mounted) Navigator.pop(context); // close loading

    if (r['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('✅ تم إصدار البطاقة بنجاح!'), backgroundColor: AppTheme.success, behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        );
      }
      _load(); // Refresh cards
    } else {
      final msg = r['data']?['message'] ?? 'فشل إصدار البطاقة';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ $msg'), backgroundColor: AppTheme.danger, behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: _load,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  const Text('بطاقاتي', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showIssueDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(100)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add_rounded, size: 16, color: AppTheme.primary),
                        const SizedBox(width: 4),
                        const Text('إصدار بطاقة', style: TextStyle(fontSize: 12, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ),
                ]),
              )),

              if (cards.isEmpty)
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Center(child: Column(children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(24)),
                      child: Icon(Icons.credit_card_off_outlined, size: 36, color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 16),
                    const Text('لا توجد بطاقات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    const SizedBox(height: 6),
                    Text('أصدر بطاقتك الرقمية الأولى', style: TextStyle(color: AppTheme.textMuted)),
                  ])),
                )),

              SliverList(delegate: SliverChildBuilderDelegate(
                (_, i) => _cardWidget(cards[i]),
                childCount: cards.length,
              )),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ]),
          )),
    );
  }

  Widget _cardWidget(Map<String, dynamic> card) {
    final isFrozen = card['status'] == 'frozen';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(children: [
        Container(
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: isFrozen
              ? const LinearGradient(colors: [Color(0xFF64748B), Color(0xFF94A3B8)])
              : const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF334155)]),
            boxShadow: [BoxShadow(color: const Color(0xFF0F172A).withValues(alpha: 0.15), blurRadius: 25, offset: const Offset(0, 10))],
          ),
          child: Stack(children: [
            Positioned(right: -30, top: -30, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.03)))),
            Positioned(left: -20, bottom: -40, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.02)))),
            if (isFrozen) Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.ac_unit_rounded, size: 40, color: const Color(0xFF93C5FD).withValues(alpha: 0.7)),
              const SizedBox(height: 8),
              const Text('البطاقة مجمّدة', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF93C5FD))),
            ])),
            if (!isFrozen) Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('SDB', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 3)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(100)),
                  child: Text('✓ نشطة', style: TextStyle(fontSize: 10, color: AppTheme.success, fontWeight: FontWeight.w600)),
                ),
              ]),
              const Spacer(),
              Text(card['card_number_masked'] ?? '•••• •••• •••• ••••', style: TextStyle(fontSize: 22, letterSpacing: 4, fontFamily: 'monospace', color: Colors.white.withValues(alpha: 0.85))),
              const SizedBox(height: 18),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('CARD HOLDER', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.25), letterSpacing: 1.5)),
                  const SizedBox(height: 3),
                  Text('${card['card_holder_name'] ?? ''}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
                ]),
                const Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('EXPIRES', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.25), letterSpacing: 1.5)),
                  const SizedBox(height: 3),
                  Text(_fmtExpiry(card['expiry_date']), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
                ]),
              ]),
            ])),
          ]),
        ),
        const SizedBox(height: 14),
        Row(children: [
          _cardAction(isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded, isFrozen ? 'تفعيل' : 'تجميد', () async {
            await ApiService.toggleCardFreeze(card['id']);
            _load();
          }),
          const SizedBox(width: 10),
          _cardAction(Icons.visibility_outlined, 'التفاصيل', () {}),
          const SizedBox(width: 10),
          _cardAction(Icons.settings_outlined, 'الحدود', () {}),
        ]),
      ]),
    );
  }

  String _fmtExpiry(dynamic raw) {
    if (raw == null) return '';
    final s = '$raw';
    // Already short format like "12/28"
    if (s.length <= 5) return s;
    try {
      final d = DateTime.parse(s);
      return DateFormat('MM/yy').format(d);
    } catch (_) {
      // Fallback: extract from ISO string "2028-12-31..."
      if (s.length >= 7) return '${s.substring(5, 7)}/${s.substring(2, 4)}';
      return s;
    }
  }

  Widget _cardAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4)],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
        ]),
      ),
    ));
  }
}
