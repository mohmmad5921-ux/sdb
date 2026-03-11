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
    final last4 = card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '').substring(math.max(0, card['card_number_masked'].toString().replaceAll(RegExp(r'[^\d]'), '').length - 4)) ?? '0000';
    final masked = card['card_number_masked']?.toString() ?? '•••• •••• •••• $last4';
    final name = card['card_holder_name'] ?? '';
    final expiry = card['expiry_date'] ?? '';
    // Format expiry as MM/YY
    String expiryFormatted = expiry;
    if (expiry.contains('-') && expiry.length >= 7) {
      final parts = expiry.split('-');
      expiryFormatted = '${parts[1]}/${parts[0].substring(2)}';
    }

    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF1E3A5F).withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          // Base gradient — blue to purple
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF6A1B9A), Color(0xFF8E24AA)],
                stops: [0.0, 0.35, 0.7, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // World map dot pattern
          CustomPaint(size: const Size(double.infinity, 210), painter: _WorldMapPainter()),

          // Purple glow bottom-right
          Positioned(
            right: -30, bottom: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [const Color(0xFFAB47BC).withValues(alpha: 0.3), Colors.transparent]),
              ),
            ),
          ),

          // Chip — gold with lines
          Positioned(left: 24, top: 24, child: Container(
            width: 46, height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFA726), Color(0xFFFFD54F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE0A800).withValues(alpha: 0.5), width: 0.5),
            ),
            child: Stack(children: [
              Positioned(top: 8, left: 0, right: 0, child: Container(height: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.4))),
              Positioned(top: 16, left: 0, right: 0, child: Container(height: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.4))),
              Positioned(top: 24, left: 0, right: 0, child: Container(height: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.4))),
              Positioned(top: 0, bottom: 0, left: 14, child: Container(width: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.3))),
              Positioned(top: 0, bottom: 0, left: 30, child: Container(width: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.3))),
            ]),
          )),

          // Contactless NFC icon
          Positioned(left: 78, top: 28, child: Icon(Icons.wifi_rounded, color: Colors.white.withValues(alpha: 0.7), size: 22)),

          // CREDIT CARD text
          Positioned(right: 24, top: 28, child: Text('CREDIT CARD', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5))),

          // Card number
          Positioned(left: 24, top: 80,
            child: Text(masked, style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9), fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2.5,
              shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
            )),
          ),

          // Valid From / Expires
          Positioned(left: 24, bottom: 48, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('VALID', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 7, letterSpacing: 1)),
            Text('FROM', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 7, letterSpacing: 1)),
          ])),
          Positioned(left: 52, bottom: 48, child: Text(expiryFormatted, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600))),

          Positioned(left: 100, bottom: 48, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('EXPIRES', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 7, letterSpacing: 1)),
            Text('END', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 7, letterSpacing: 1)),
          ])),
          Positioned(left: 138, bottom: 48, child: Text(expiryFormatted, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600))),

          // Card holder name
          Positioned(left: 24, bottom: 18,
            child: Text(name.isNotEmpty ? name : 'CARD HOLDER', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.5,
            )),
          ),

          // Mastercard logo
          Positioned(right: 20, bottom: 16, child: Row(children: [
            Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFEB001B).withValues(alpha: 0.85))),
            Transform.translate(offset: const Offset(-10, 0), child: Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFF79E1B).withValues(alpha: 0.85)))),
          ])),

          // Frozen overlay
          if (isFrozen) Positioned.fill(child: Container(
            decoration: BoxDecoration(color: const Color(0xFF0F172A).withValues(alpha: 0.65), borderRadius: BorderRadius.circular(20)),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.ac_unit_rounded, size: 32, color: Colors.white),
              SizedBox(height: 8),
              Text('Card Frozen', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          )),
        ]),
      ),
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
              gradient: const LinearGradient(colors: [Color(0xFF0D47A1), Color(0xFF6A1B9A)]),
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

/// World map dot pattern for credit card background
class _WorldMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.08);

    // Seed-based pattern to simulate world map continents
    final rng = math.Random(42);
    const dotSize = 2.0;
    const cols = 40;
    const rows = 18;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    // Density map — higher values = more dots (simulates land masses)
    final densityMap = [
      //  Rough representation: top rows = arctic, middle = continents, bottom = southern
      [0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0],
      [0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0],
      [0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0],
      [0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0],
      [0,0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0],
      [0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0],
      [0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0],
      [0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0],
      [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
    ];

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (r < densityMap.length && c < densityMap[r].length && densityMap[r][c] == 1) {
          // Add slight randomness to position
          final dx = c * cellW + cellW * 0.5 + (rng.nextDouble() - 0.5) * cellW * 0.4;
          final dy = r * cellH + cellH * 0.5 + (rng.nextDouble() - 0.5) * cellH * 0.4;
          canvas.drawCircle(Offset(dx, dy), dotSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
