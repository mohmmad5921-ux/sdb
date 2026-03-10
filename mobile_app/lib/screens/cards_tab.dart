import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class CardsTab extends StatefulWidget {
  const CardsTab({super.key});
  @override
  State<CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<CardsTab> {
  List<Map<String, dynamic>> _cards = [];
  bool _loading = true;
  int _activeIndex = 0;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    final r = await ApiService.getCards();
    if (r['success'] == true) {
      final list = r['data']?['cards'];
      setState(() { _cards = List<Map<String, dynamic>>.from(list ?? []); _loading = false; });
    } else { setState(() => _loading = false); }
  }

  Future<void> _toggleFreeze(int cardId) async {
    final r = await ApiService.toggleCardFreeze(cardId);
    if (r['success'] == true) _load();
  }

  Future<void> _issueCard() async {
    final r = await ApiService.issueCard(0);
    if (r['success'] == true) _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(r['success'] == true ? 'Card issued!' : (r['data']?['message'] ?? 'Error')),
        backgroundColor: r['success'] == true ? AppTheme.primary : AppTheme.danger,
      ));
    }
  }

  void _showCardDetails(Map<String, dynamic> card) {
    final last4 = card['card_number_masked']?.toString() ?? '•••• ••••';
    final name = card['card_holder_name'] ?? '';
    final expiry = card['expiry_date'] ?? '';
    final type = card['card_type'] == 'virtual' ? 'Virtual' : 'Physical';
    final status = card['status'] ?? 'active';

    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Center(child: Text('Card Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
        const SizedBox(height: 20),
        _detailRow('Card Number', last4),
        _detailRow('Card Holder', name),
        _detailRow('Expiry Date', expiry),
        _detailRow('Card Type', type),
        _detailRow('Status', status.toString().toUpperCase()),
        _detailRow('Network', 'Mastercard'),
        const SizedBox(height: 16),
      ]),
    ));
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
    ]),
  );

  Future<void> _addToAppleWallet(int cardId) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adding to Apple Wallet...'), backgroundColor: AppTheme.primary));
    final bytes = await ApiService.downloadWalletPass(cardId);
    if (bytes != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card added to Apple Wallet!'), backgroundColor: AppTheme.primary));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Apple Wallet not available yet'), backgroundColor: AppTheme.warning));
    }
  }

  void _showLimits() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Card Limits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 20),
        _limitRow('Daily ATM', '€500', 0.4),
        _limitRow('Daily Purchase', '€2,000', 0.25),
        _limitRow('Monthly Spend', '€3,000', 0.41),
        _limitRow('Online Payments', '€1,000', 0.6),
        const SizedBox(height: 16),
      ]),
    ));
  }

  Widget _limitRow(String label, String limit, double progress) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        Text(limit, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ]),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: AppTheme.bgMuted, color: AppTheme.primary)),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : RefreshIndicator(color: AppTheme.primary, onRefresh: _load, child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('My Cards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                  GestureDetector(
                    onTap: _issueCard,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text('New Card', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ]),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 16),

              if (_cards.isEmpty) _buildEmptyCards()
              else ...[
                // Dots
                Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_cards.length, (i) =>
                  GestureDetector(
                    onTap: () => setState(() => _activeIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: i == _activeIndex ? 20 : 8, height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i == _activeIndex ? AppTheme.primary : AppTheme.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 16),

                // Card Visual
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _buildCardVisual(_cards[_activeIndex])),
                const SizedBox(height: 16),

                // Actions
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: _buildCardActions(_cards[_activeIndex])),
                const SizedBox(height: 24),

                // All Cards List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('All Cards', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    const SizedBox(height: 10),
                    ..._cards.asMap().entries.map((e) => _buildCardListItem(e.value, e.key)),
                  ]),
                ),
                const SizedBox(height: 20),

                // Monthly Spend
                _buildSpendingTracker(),
              ],
            ]),
          )),
    );
  }

  Widget _buildCardVisual(Map<String, dynamic> card) {
    final isFrozen = card['status'] == 'frozen';
    final isVirtual = card['card_type'] == 'virtual';
    final last4 = card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '').substring(math.max(0, card['card_number_masked'].toString().replaceAll(RegExp(r'[^\d]'), '').length - 4)) ?? '0000';
    final name = card['card_holder_name'] ?? '';
    final expiry = card['expiry_date'] ?? '';

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isVirtual ? [const Color(0xFF334155), const Color(0xFF0F172A)] : [const Color(0xFF10B981), const Color(0xFF059669)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: (isVirtual ? const Color(0xFF334155) : AppTheme.primary).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Stack(children: [
        // Decorative circles
        Positioned(right: -32, top: -32, child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
        Positioned(right: -16, bottom: -20, child: Container(width: 110, height: 110, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),

        // Network logo
        Positioned(top: 16, right: 16, child: Text('Mastercard', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11, fontWeight: FontWeight.w600))),

        // Content
        Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Chip
          Container(
            width: 36, height: 26,
            decoration: BoxDecoration(color: const Color(0xFFFCD34D).withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
            child: Center(child: Container(width: 22, height: 16, decoration: BoxDecoration(border: Border.all(color: const Color(0xFFA16207).withOpacity(0.4)), borderRadius: BorderRadius.circular(3)))),
          ),
          const SizedBox(height: 20),
          // Number
          Text('•••• •••• •••• $last4', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, letterSpacing: 3, fontWeight: FontWeight.w500)),
          const Spacer(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CARD HOLDER', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('EXPIRES', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 8, letterSpacing: 1.2)),
              const SizedBox(height: 2),
              Text(expiry, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ]),
        ])),

        // Frozen Overlay
        if (isFrozen) Positioned.fill(child: Container(
          decoration: BoxDecoration(color: const Color(0xFF0F172A).withOpacity(0.65), borderRadius: BorderRadius.circular(20)),
          child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.ac_unit_rounded, size: 32, color: Colors.white),
            SizedBox(height: 8),
            Text('Card Frozen', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        )),
      ]),
    );
  }

  Widget _buildCardActions(Map<String, dynamic> card) {
    final isFrozen = card['status'] == 'frozen';
    final cardId = card['id'] as int? ?? 0;

    final actions = [
      {'icon': Icons.ac_unit_rounded, 'label': isFrozen ? 'Unfreeze' : 'Freeze', 'highlight': isFrozen, 'onTap': () => _toggleFreeze(cardId)},
      {'icon': Icons.info_outline_rounded, 'label': 'Details', 'highlight': false, 'onTap': () => _showCardDetails(card)},
      {'icon': Icons.apple, 'label': 'Wallet', 'highlight': false, 'onTap': () => _addToAppleWallet(cardId)},
      {'icon': Icons.shield_outlined, 'label': 'Limits', 'highlight': false, 'onTap': () => _showLimits()},
    ];

    return Row(children: actions.map((a) => Expanded(child: GestureDetector(
      onTap: a['onTap'] as VoidCallback,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: (a['highlight'] as bool) ? AppTheme.primary.withOpacity(0.1) : AppTheme.bgMuted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(a['icon'] as IconData, size: 20, color: (a['highlight'] as bool) ? AppTheme.primary : AppTheme.textSecondary),
          const SizedBox(height: 6),
          Text(a['label'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: (a['highlight'] as bool) ? AppTheme.primary : AppTheme.textPrimary)),
        ]),
      ),
    ))).toList());
  }

  Widget _buildCardListItem(Map<String, dynamic> card, int index) {
    final isActive = _activeIndex == index;
    final isVirtual = card['card_type'] == 'virtual';
    final isFrozen = card['status'] == 'frozen';
    final last4 = card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '';
    final l4 = last4.length >= 4 ? last4.substring(last4.length - 4) : last4;
    final expiry = card['expiry_date'] ?? '';

    return GestureDetector(
      onTap: () => setState(() => _activeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.bgMuted : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isActive ? AppTheme.primary : AppTheme.border),
        ),
        child: Row(children: [
          Container(
            width: 42, height: 30,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: isVirtual ? [const Color(0xFF475569), const Color(0xFF0F172A)] : [const Color(0xFF10B981), const Color(0xFF059669)]),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${isVirtual ? "Virtual" : "Physical"} Card •••• $l4', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text('Mastercard · Expires $expiry', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          if (isFrozen) Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)),
            child: const Text('Frozen', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8))),
          ),
        ]),
      ),
    );
  }

  Widget _buildSpendingTracker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Monthly Spend', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text('€1,240 / €3,000', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: 0.413, minHeight: 8, backgroundColor: AppTheme.bgMuted, color: AppTheme.primary),
          ),
          const SizedBox(height: 8),
          const Align(alignment: Alignment.centerLeft, child: Text('€1,760 remaining this month', style: TextStyle(fontSize: 11, color: AppTheme.textMuted))),
        ]),
      ),
    );
  }

  Widget _buildEmptyCards() {
    return Center(child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(children: [
        Icon(Icons.credit_card_off_rounded, size: 56, color: AppTheme.textMuted.withOpacity(0.3)),
        const SizedBox(height: 16),
        const Text('No cards yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        const Text('Tap "New Card" to issue your first card', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      ]),
    ));
  }
}
