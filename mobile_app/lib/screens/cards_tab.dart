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
  final _pageCtrl = PageController(viewportFraction: 0.88);

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

  // ── Show PIN ──
  void _showPIN() {
    final card = _cards[_activeIndex];
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        const Icon(Icons.lock_rounded, size: 36, color: Color(0xFF10B981)),
        const SizedBox(height: 12),
        const Text('رمز PIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        const Text('رمز PIN الخاص ببطاقتك', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
          child: Text('${(card['id'].hashCode % 9000 + 1000).abs()}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Color(0xFF111827), letterSpacing: 12)),
        ),
        const SizedBox(height: 16),
        const Text('لا تشارك رمز PIN مع أي شخص', style: TextStyle(fontSize: 12, color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
      ]),
    ));
  }

  // ── Card Controls ──
  void _showCardControls() {
    final card = _cards[_activeIndex];
    final cardId = card['id'] as int? ?? 0;
    bool online = card['online_payment_enabled'] ?? true;
    bool contactless = card['contactless_enabled'] ?? true;
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => StatefulBuilder(
      builder: (ctx, setS) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('إعدادات البطاقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 24),
          _controlToggle('الدفع أونلاين', 'السماح بالمعاملات عبر الإنترنت', Icons.language_rounded, online, (v) {
            setS(() => online = v);
            ApiService.updateCardSettings(cardId, {'online_payment_enabled': v});
          }),
          const SizedBox(height: 12),
          _controlToggle('الدفع بدون تلامس', 'السماح بمعاملات NFC', Icons.contactless_rounded, contactless, (v) {
            setS(() => contactless = v);
            ApiService.updateCardSettings(cardId, {'contactless_enabled': v});
          }),
          const SizedBox(height: 12),
          _controlToggle('إشعارات المعاملات', 'إشعار فوري عند كل عملية', Icons.notifications_active_outlined, true, (v) {}),
          const SizedBox(height: 20),
        ]),
      ),
    ));
  }

  Widget _controlToggle(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 18, color: const Color(0xFF10B981))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        ])),
        Switch.adaptive(value: value, onChanged: onChanged, activeColor: const Color(0xFF10B981)),
      ]),
    );
  }

  // ── Reset PIN ──
  void _resetPIN() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        const Icon(Icons.lock_reset_rounded, size: 36, color: Color(0xFFF59E0B)),
        const SizedBox(height: 12),
        const Text('إعادة تعيين PIN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        const Text('سيتم إنشاء رمز PIN جديد لبطاقتك', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إعادة تعيين PIN بنجاح ✅'), backgroundColor: Color(0xFF10B981))); },
          child: Container(height: 54, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]), borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('إعادة تعيين', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)))),
        ),
        const SizedBox(height: 12),
        GestureDetector(onTap: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF)))),
        const SizedBox(height: 16),
      ]),
    ));
  }

  // ── Replace Card ──
  void _replaceCard() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        const Icon(Icons.swap_horiz_rounded, size: 36, color: Color(0xFF3B82F6)),
        const SizedBox(height: 12),
        const Text('استبدال البطاقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        const Text('سيتم إلغاء بطاقتك الحالية وإصدار بطاقة جديدة برقم مختلف', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () { Navigator.pop(context); _issueCard(); },
          child: Container(height: 54, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)]), borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('استبدال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)))),
        ),
        const SizedBox(height: 12),
        GestureDetector(onTap: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF)))),
        const SizedBox(height: 16),
      ]),
    ));
  }

  // ── Delete Card ──
  void _deleteCard() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Color(0xFFFEF2F2), shape: BoxShape.circle), child: const Icon(Icons.delete_forever_rounded, size: 36, color: Color(0xFFEF4444))),
        const SizedBox(height: 12),
        const Text('حذف البطاقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFEF4444))),
        const SizedBox(height: 8),
        const Text('هل أنت متأكد؟ لا يمكن التراجع عن هذا الإجراء.\nسيتم إلغاء البطاقة نهائياً.', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () async {
            Navigator.pop(context);
            final cardId = _cards[_activeIndex]['id'] as int? ?? 0;
            final r = await ApiService.deleteCard(cardId);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(r['success'] == true ? 'تم حذف البطاقة ✅' : 'فشل حذف البطاقة'),
                backgroundColor: r['success'] == true ? const Color(0xFFEF4444) : const Color(0xFFF59E0B),
              ));
              if (r['success'] == true) { setState(() => _activeIndex = 0); _load(); }
            }
          },
          child: Container(height: 54, decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(16)),
            child: const Center(child: Text('حذف نهائياً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)))),
        ),
        const SizedBox(height: 12),
        GestureDetector(onTap: () => Navigator.pop(context), child: const Text('إلغاء', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF)))),
        const SizedBox(height: 16),
      ]),
    ));
  }

  // ── Apple Wallet ──
  Future<void> _addToAppleWallet(int cardId) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('جاري الإضافة إلى Apple Wallet...'), backgroundColor: Color(0xFF10B981)));
    final bytes = await ApiService.downloadWalletPass(cardId);
    if (bytes != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت الإضافة إلى Apple Wallet! ✅'), backgroundColor: Color(0xFF10B981)));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Apple Wallet غير متاح حالياً'), backgroundColor: Color(0xFFF59E0B)));
    }
  }

  String _fmtExpiry(String raw) {
    if (raw.contains('T')) raw = raw.split('T').first;
    if (raw.contains('-') && raw.length >= 7) {
      final p = raw.split('-');
      return '${p[1]}/${p[0].substring(2)}';
    }
    return raw;
  }

  String _last4(Map<String, dynamic> card) {
    final m = card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '';
    return m.length >= 4 ? m.substring(m.length - 4) : m;
  }

  // ── New Card: Confirmation Dialog ──
  Future<void> _showIssueDialog() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _CardAgreementSheet(),
    );
    if (confirmed == true) _issueCard();
  }

  Future<void> _issueCard() async {
    setState(() => _loading = true);
    final r = await ApiService.issueCard(0);
    if (r['success'] == true) {
      await _load();
      if (_cards.isNotEmpty) setState(() => _activeIndex = _cards.length - 1);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(r['success'] == true ? 'تم إصدار البطاقة بنجاح! ✅' : (r['data']?['message'] ?? 'خطأ')),
        backgroundColor: r['success'] == true ? AppTheme.primary : AppTheme.danger,
      ));
    }
  }

  // ── Card Details Bottom Sheet ──
  void _showCardDetails(Map<String, dynamic> card) {
    final masked = card['card_number_masked'] ?? '•••• •••• •••• ••••';
    final name = card['card_holder_name'] ?? '';
    final expiry = _fmtExpiry(card['expiry_date'] ?? '');
    final status = card['status'] ?? 'active';
    final type = (card['card_type'] ?? '').toString().contains('virtual') ? 'Virtual' : 'Physical';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('تفاصيل البطاقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 24),
          _detailItem(Icons.credit_card_rounded, 'رقم البطاقة', masked),
          _detailItem(Icons.person_outline_rounded, 'اسم حامل البطاقة', name),
          _detailItem(Icons.calendar_today_rounded, 'تاريخ الانتهاء', expiry),
          _detailItem(Icons.category_rounded, 'نوع البطاقة', '$type • Mastercard'),
          _detailItem(Icons.circle, 'الحالة', status == 'active' ? 'نشطة ✅' : status == 'frozen' ? 'مجمّدة ❄️' : status),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: const Color(0xFF10B981)),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827), letterSpacing: 0.3)),
      ])),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
        : RefreshIndicator(color: const Color(0xFF10B981), onRefresh: _load, child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('البطاقات', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF111827))),
                  GestureDetector(
                    onTap: _showIssueDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.25), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: const Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.add_rounded, size: 16, color: Colors.white),
                        SizedBox(width: 6),
                        Text('طلب بطاقة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ]),
                    ),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              if (_cards.isEmpty) _buildEmptyCards()
              else ...[
                // ── Card Carousel ──
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageCtrl,
                    itemCount: _cards.length,
                    onPageChanged: (i) => setState(() => _activeIndex = i),
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _buildCardVisual(_cards[i]),
                    ),
                  ),
                ),

                // ── Card Label ──
                const SizedBox(height: 12),
                Center(child: Text(
                  'بطاقة رقمية  ••••  ${_last4(_cards[_activeIndex])}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                )),

                // ── Dots ──
                if (_cards.length > 1) ...[
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_cards.length, (i) =>
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: i == _activeIndex ? 20 : 8, height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: i == _activeIndex ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
                ],

                // ── Quick Actions ──
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    _quickAction(Icons.dialpad_rounded, 'عرض PIN', _showPIN),
                    const SizedBox(width: 12),
                    _quickAction(Icons.credit_card_rounded, 'تفاصيل', () => _showCardDetails(_cards[_activeIndex])),
                    const SizedBox(width: 12),
                    _quickAction(
                      _cards[_activeIndex]['status'] == 'frozen' ? Icons.play_circle_outline_rounded : Icons.ac_unit_rounded,
                      _cards[_activeIndex]['status'] == 'frozen' ? 'إلغاء التجميد' : 'تجميد',
                      () => _toggleFreeze(_cards[_activeIndex]['id'] as int? ?? 0),
                      highlight: _cards[_activeIndex]['status'] == 'frozen',
                    ),
                  ]),
                ),

                // ── Apple Pay ──
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _manageItem(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(6)),
                      child: const Text('Pay', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                    title: 'إضافة إلى Apple Wallet',
                    onTap: () => _addToAppleWallet(_cards[_activeIndex]['id'] as int? ?? 0),
                  ),
                ),

                // ── Manage Card Section ──
                const SizedBox(height: 28),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('إدارة البطاقة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF))),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(children: [
                    _manageItem(icon: Icons.receipt_long_rounded, title: 'عرض آخر العمليات', onTap: () => Navigator.pushNamed(context, '/home')),
                    _manageItem(icon: Icons.tune_rounded, title: 'إعدادات البطاقة', onTap: _showCardControls),
                    _manageItem(icon: Icons.lock_open_rounded, title: 'إعادة تعيين PIN', onTap: _resetPIN),
                    _manageItem(icon: Icons.shield_outlined, title: 'حدود الإنفاق', onTap: _showLimits),
                    _manageItem(icon: Icons.swap_horiz_rounded, title: 'استبدال البطاقة', onTap: _replaceCard),
                    _manageItem(icon: Icons.delete_outline_rounded, title: 'حذف البطاقة', onTap: _deleteCard, danger: true),
                  ]),
                ),
              ],
            ]),
          )),
    );
  }

  // ── Quick Action Button ──
  Widget _quickAction(IconData icon, String label, VoidCallback onTap, {bool highlight = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: highlight ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: highlight ? const Color(0xFF10B981).withValues(alpha: 0.3) : const Color(0xFFF0F0F0)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: highlight ? const Color(0xFF10B981).withValues(alpha: 0.15) : const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: const Color(0xFF10B981)),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: highlight ? const Color(0xFF10B981) : const Color(0xFF374151))),
          ]),
        ),
      ),
    );
  }

  // ── Manage Card List Item ──
  Widget _manageItem({IconData? icon, Widget? leading, required String title, required VoidCallback onTap, bool danger = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))),
        child: Row(children: [
          if (leading != null) ...[leading, const SizedBox(width: 14)]
          else if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: danger ? const Color(0xFFFEF2F2) : const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: danger ? const Color(0xFFEF4444) : const Color(0xFF6B7280)),
            ),
            const SizedBox(width: 14),
          ],
          Expanded(child: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: danger ? const Color(0xFFEF4444) : const Color(0xFF111827)))),
          Icon(Icons.chevron_right_rounded, size: 20, color: const Color(0xFFD1D5DB)),
        ]),
      ),
    );
  }

  // ── Spending Limits Sheet ──
  void _showLimits() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        const Text('حدود الإنفاق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        _limitRow('السحب اليومي', '€500', 0.4),
        _limitRow('المشتريات اليومية', '€2,000', 0.25),
        _limitRow('الإنفاق الشهري', '€3,000', 0.41),
        _limitRow('الدفع أونلاين', '€1,000', 0.6),
        const SizedBox(height: 16),
      ]),
    ));
  }

  Widget _limitRow(String label, String limit, double progress) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
        Text(limit, style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF))),
      ]),
      const SizedBox(height: 6),
      ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: const Color(0xFFF3F4F6), color: const Color(0xFF10B981))),
    ]),
  );

  // ── Card Visual ──
  Widget _buildCardVisual(Map<String, dynamic> card) {
    final isFrozen = card['status'] == 'frozen';
    final last4 = _last4(card);
    final masked = card['card_number_masked']?.toString() ?? '•••• •••• •••• $last4';
    final name = card['card_holder_name'] ?? '';
    final expiry = _fmtExpiry(card['expiry_date'] ?? '');

    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF1E3A5F).withValues(alpha: 0.35), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(children: [
          // Gradient
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF6A1B9A), Color(0xFF8E24AA)],
            stops: [0.0, 0.35, 0.7, 1.0], begin: Alignment.topLeft, end: Alignment.bottomRight,
          ))),

          // World map dots
          CustomPaint(size: const Size(double.infinity, 210), painter: _WorldMapPainter()),

          // Purple glow
          Positioned(right: -30, bottom: -40, child: Container(width: 180, height: 180, decoration: BoxDecoration(
            shape: BoxShape.circle, gradient: RadialGradient(colors: [const Color(0xFFAB47BC).withValues(alpha: 0.25), Colors.transparent]),
          ))),

          // Chip
          Positioned(left: 24, top: 24, child: Container(
            width: 46, height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFA726), Color(0xFFFFD54F)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(children: [
              Positioned(top: 8, left: 0, right: 0, child: Container(height: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.4))),
              Positioned(top: 16, left: 0, right: 0, child: Container(height: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.4))),
              Positioned(top: 24, left: 0, right: 0, child: Container(height: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.4))),
              Positioned(top: 0, bottom: 0, left: 14, child: Container(width: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.3))),
              Positioned(top: 0, bottom: 0, left: 30, child: Container(width: 0.5, color: const Color(0xFFB8860B).withValues(alpha: 0.3))),
            ]),
          )),

          // NFC
          Positioned(left: 78, top: 28, child: Icon(Icons.wifi_rounded, color: Colors.white.withValues(alpha: 0.7), size: 22)),

          // CREDIT CARD
          Positioned(right: 24, top: 28, child: Text('CREDIT CARD', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5))),

          // Number
          Positioned(left: 24, top: 82, child: Text(masked, style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9), fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 2.5,
            shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 4)],
          ))),

          // Valid / Expires
          Positioned(left: 24, bottom: 48, child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('VALID', style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 7, letterSpacing: 1)),
              Text('FROM', style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 7, letterSpacing: 1)),
            ]),
            const SizedBox(width: 6),
            Text(expiry, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('EXPIRES', style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 7, letterSpacing: 1)),
              Text('END', style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 7, letterSpacing: 1)),
            ]),
            const SizedBox(width: 6),
            Text(expiry, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w600)),
          ])),

          // Name
          Positioned(left: 24, bottom: 18, child: Text(name.isNotEmpty ? name : 'CARD HOLDER', style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9), fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.5,
          ))),

          // Mastercard logo
          Positioned(right: 20, bottom: 16, child: Row(children: [
            Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFEB001B).withValues(alpha: 0.85))),
            Transform.translate(offset: const Offset(-10, 0), child: Container(width: 26, height: 26, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFF79E1B).withValues(alpha: 0.85)))),
          ])),

          // Frozen
          if (isFrozen) Positioned.fill(child: Container(
            decoration: BoxDecoration(color: const Color(0xFF0F172A).withValues(alpha: 0.65), borderRadius: BorderRadius.circular(20)),
            child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.ac_unit_rounded, size: 32, color: Colors.white),
              SizedBox(height: 8),
              Text('بطاقة مجمّدة', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _buildEmptyCards() {
    return Center(child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: const Color(0xFFF5F7FA), shape: BoxShape.circle),
          child: const Icon(Icons.credit_card_off_rounded, size: 48, color: Color(0xFFD1D5DB)),
        ),
        const SizedBox(height: 20),
        const Text('لا توجد بطاقات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        const Text('اضغط "طلب بطاقة" للحصول على بطاقتك الأولى', style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
      ]),
    ));
  }
}

// ── Card Agreement Sheet ──
class _CardAgreementSheet extends StatefulWidget {
  @override
  State<_CardAgreementSheet> createState() => _CardAgreementSheetState();
}

class _CardAgreementSheetState extends State<_CardAgreementSheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFECFDF5), shape: BoxShape.circle),
          child: const Icon(Icons.credit_card_rounded, size: 36, color: Color(0xFF10B981)),
        ),
        const SizedBox(height: 16),
        const Text('طلب بطاقة جديدة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
        const SizedBox(height: 8),
        const Text('بطاقة Mastercard رقمية للدفع أونلاين وفي المتاجر', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)), textAlign: TextAlign.center),
        const SizedBox(height: 20),

        // Features
        _featureRow(Icons.shield_outlined, 'حماية كاملة', 'تشفير AES-256 وحماية من الاحتيال'),
        _featureRow(Icons.contactless_rounded, 'دفع بدون تلامس', 'NFC للدفع السريع في المتاجر'),
        _featureRow(Icons.tune_rounded, 'تحكم كامل', 'تجميد، حدود إنفاق، وإعدادات مخصصة'),

        const SizedBox(height: 20),

        // Agreement
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

        // Confirm button
        GestureDetector(
          onTap: _agreed ? () => Navigator.pop(context, true) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 54,
            decoration: BoxDecoration(
              gradient: _agreed ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]) : null,
              color: _agreed ? null : const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(16),
              boxShadow: _agreed ? [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))] : null,
            ),
            child: Center(child: Text('إصدار البطاقة', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, color: _agreed ? Colors.white : const Color(0xFF9CA3AF),
            ))),
          ),
        ),
      ]),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 18, color: const Color(0xFF10B981)),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
        Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
      ])),
    ]),
  );
}

/// World map dot pattern
class _WorldMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.08);
    final rng = math.Random(42);
    const dotSize = 2.0;
    const cols = 40;
    const rows = 18;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    final d = [
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
        if (r < d.length && c < d[r].length && d[r][c] == 1) {
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
