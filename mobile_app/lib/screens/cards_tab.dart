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
    if (cardId == 0) return;
    try {
      final r = await ApiService.toggleCardFreeze(cardId);
      if (mounted) {
        final msg = r['success'] == true 
          ? (r['data']?['status'] == 'frozen' ? 'تم تجميد البطاقة ❄️' : 'تم تفعيل البطاقة ✅')
          : 'فشل: ${r['data']?['message'] ?? 'خطأ غير معروف'}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: r['success'] == true ? const Color(0xFF10B981) : const Color(0xFFEF4444)));
        _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ اتصال: $e'), backgroundColor: const Color(0xFFEF4444)));
    }
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
    final cardId = int.tryParse(card['id'].toString()) ?? 0;
    bool online = card['online_payment_enabled'] ?? true;
    bool contactless = card['contactless_enabled'] ?? true;
    bool atm = card['atm_enabled'] ?? true;
    bool notifications = card['transaction_notifications'] ?? true;
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
            ApiService.updateCardSettings(cardId, {'online_payment_enabled': v}).then((r) {
              if (mounted && r['success'] != true) {
                setS(() => online = !v);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فشل تحديث الإعداد'), backgroundColor: Color(0xFFEF4444)));
              }
            });
          }),
          const SizedBox(height: 12),
          _controlToggle('الدفع بدون تلامس', 'السماح بمعاملات NFC', Icons.contactless_rounded, contactless, (v) {
            setS(() => contactless = v);
            ApiService.updateCardSettings(cardId, {'contactless_enabled': v}).then((r) {
              if (mounted && r['success'] != true) setS(() => contactless = !v);
            });
          }),
          const SizedBox(height: 12),
          _controlToggle('السحب من ATM', 'السماح بالسحب من الصراف الآلي', Icons.atm_rounded, atm, (v) {
            setS(() => atm = v);
            ApiService.updateCardSettings(cardId, {'atm_enabled': v}).then((r) {
              if (mounted && r['success'] != true) setS(() => atm = !v);
            });
          }),
          const SizedBox(height: 12),
          _controlToggle('إشعارات المعاملات', 'إشعار فوري عند كل عملية', Icons.notifications_active_outlined, notifications, (v) {
            setS(() => notifications = v);
            ApiService.updateCardSettings(cardId, {'transaction_notifications': v}).then((r) {
              if (mounted && r['success'] != true) setS(() => notifications = !v);
            });
          }),
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
    if (_cards.isEmpty || _activeIndex >= _cards.length) return;
    final cardId = int.tryParse(_cards[_activeIndex]['id'].toString()) ?? 0;
    if (cardId == 0) return;

    showDialog(context: context, builder: (dCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(children: [
        Icon(Icons.delete_forever_rounded, color: Color(0xFFEF4444), size: 28),
        SizedBox(width: 8),
        Text('حذف البطاقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFEF4444))),
      ]),
      content: const Text('هل أنت متأكد؟ لا يمكن التراجع عن هذا الإجراء.\nسيتم إلغاء البطاقة نهائياً.',
        style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('إلغاء', style: TextStyle(color: Color(0xFF9CA3AF)))),
        TextButton(
          onPressed: () async {
            Navigator.pop(dCtx);
            try {
              final r = await ApiService.deleteCard(cardId);
              if (mounted) {
                final ok = r['success'] == true;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(ok ? 'تم حذف البطاقة ✅' : 'فشل: ${r['data']?['message'] ?? r.toString()}'),
                  backgroundColor: ok ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  duration: const Duration(seconds: 3),
                ));
                if (ok) { setState(() => _activeIndex = 0); _load(); }
              }
            } catch (e) {
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('خطأ: $e'),
                backgroundColor: const Color(0xFFEF4444),
                duration: const Duration(seconds: 5),
              ));
            }
          },
          child: const Text('حذف نهائياً', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w800)),
        ),
      ],
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
    final type = (card['card_type'] ?? '').toString().contains('virtual') ? 'رقمية' : 'فعلية';
    final cvv = card['cvv']?.toString() ?? '${(card['id'].hashCode % 900 + 100).abs()}';
    final createdAt = card['created_at']?.toString().split('T').first ?? '';
    final online = card['online_payment_enabled'] ?? true;
    final contactless = card['contactless_enabled'] ?? true;
    final atm = card['atm_enabled'] ?? true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) {
          bool cvvVisible = false;
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.85,
            expand: false,
            builder: (_, scrollCtrl) => StatefulBuilder(
              builder: (ctx2, setS2) => ListView(
                controller: scrollCtrl,
                padding: const EdgeInsets.all(24),
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE5E7EB), borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  const Center(child: Text('تفاصيل البطاقة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF111827)))),
                  const SizedBox(height: 24),

                  // Card Info Section
                  _detailSectionHeader('معلومات البطاقة'),
                  const SizedBox(height: 8),
                  _detailItem(Icons.credit_card_rounded, 'رقم البطاقة', masked),
                  _detailItem(Icons.person_outline_rounded, 'اسم حامل البطاقة', name),
                  _detailItem(Icons.calendar_today_rounded, 'تاريخ الانتهاء', expiry),
                  // CVV with reveal
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.security_rounded, size: 18, color: Color(0xFF10B981)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('CVV', style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text(cvvVisible ? cvv : '•••', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827), letterSpacing: 2)),
                      ])),
                      GestureDetector(
                        onTap: () => setS2(() => cvvVisible = !cvvVisible),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                          child: Icon(cvvVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 16, color: const Color(0xFF10B981)),
                        ),
                      ),
                    ]),
                  ),

                  // Card Type & Status Section
                  const SizedBox(height: 12),
                  _detailSectionHeader('النوع والحالة'),
                  const SizedBox(height: 8),
                  _detailItem(Icons.style_rounded, 'نوع البطاقة', '$type • Mastercard Debit'),
                  _detailItem(
                    status == 'active' ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                    'الحالة',
                    status == 'active' ? 'نشطة ✅' : status == 'frozen' ? 'مجمّدة ❄️' : status,
                  ),
                  if (createdAt.isNotEmpty) _detailItem(Icons.date_range_rounded, 'تاريخ الإصدار', createdAt),

                  // Settings Status Section
                  const SizedBox(height: 12),
                  _detailSectionHeader('إعدادات البطاقة'),
                  const SizedBox(height: 8),
                  _detailStatusItem('الدفع أونلاين', online),
                  _detailStatusItem('الدفع بدون تلامس', contactless),
                  _detailStatusItem('السحب من ATM', atm),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF6B7280))),
  );

  Widget _detailStatusItem(String label, bool enabled) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(14)),
    child: Row(children: [
      Container(
        width: 8, height: 8,
        decoration: BoxDecoration(shape: BoxShape.circle, color: enabled ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
      ),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF111827))),
      const Spacer(),
      Text(enabled ? 'مفعّل' : 'معطّل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: enabled ? const Color(0xFF10B981) : const Color(0xFFEF4444))),
    ]),
  );

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
                      () => _toggleFreeze(int.tryParse(_cards[_activeIndex]['id'].toString()) ?? 0),
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
                    onTap: () => _addToAppleWallet(int.tryParse(_cards[_activeIndex]['id'].toString()) ?? 0),
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

    // Format number in groups of 4
    String fmtNum = masked.replaceAll(RegExp(r'[^\d•*]'), '');
    if (fmtNum.length >= 16) {
      fmtNum = '${fmtNum.substring(0,4)}  ${fmtNum.substring(4,8)}  ${fmtNum.substring(8,12)}  ${fmtNum.substring(12,16)}';
    } else if (fmtNum.isEmpty) {
      fmtNum = '••••  ••••  ••••  $last4';
    } else {
      fmtNum = masked;
    }

    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0A0A0A).withValues(alpha: 0.45), blurRadius: 24, offset: const Offset(0, 12)),
          BoxShadow(color: const Color(0xFF1A1A2E).withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(children: [
          // ── Base gradient: dark premium ──
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF1A1A2E)],
            stops: [0.0, 0.5, 1.0], begin: Alignment.topLeft, end: Alignment.bottomRight,
          ))),

          // ── Subtle arc light effect ──
          Positioned(right: -60, top: -60, child: Container(width: 200, height: 200, decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [Colors.white.withValues(alpha: 0.04), Colors.transparent]),
          ))),
          Positioned(left: -40, bottom: -80, child: Container(width: 220, height: 220, decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [const Color(0xFF3B82F6).withValues(alpha: 0.06), Colors.transparent]),
          ))),

          // ── Holographic accent line ──
          Positioned(top: 70, left: 0, right: 0, child: Container(height: 0.5, decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.12),
              Colors.white.withValues(alpha: 0.06),
              Colors.transparent,
            ]),
          ))),

          // ── SDB Bank branding ──
          Positioned(left: 24, top: 22, child: Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Text('SDB', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.95), fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.5,
            )),
            const SizedBox(width: 5),
            Text('Bank', style: TextStyle(
              color: Colors.white.withValues(alpha: 0.50), fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 1.0,
            )),
          ])),

          // ── DEBIT label ──
          Positioned(right: 24, top: 24, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('DEBIT', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          )),

          // ── EMV Chip ──
          Positioned(left: 24, top: 58, child: Container(
            width: 45, height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: const LinearGradient(colors: [Color(0xFFD4A843), Color(0xFFC49B38), Color(0xFFE0BE68), Color(0xFFD4A843)],
                stops: [0, 0.3, 0.6, 1], begin: Alignment.topLeft, end: Alignment.bottomRight),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 2, offset: const Offset(0, 1))],
            ),
            child: CustomPaint(painter: _ChipPainter()),
          )),

          // ── NFC contactless ──
          Positioned(left: 76, top: 62, child: Transform.rotate(
            angle: math.pi / 2,
            child: Icon(Icons.wifi_rounded, color: Colors.white.withValues(alpha: 0.5), size: 22),
          )),

          // ── Card Number ──
          Positioned(left: 24, top: 108, child: Text(fmtNum, style: TextStyle(
            color: Colors.white.withValues(alpha: 0.92), fontSize: 17, fontWeight: FontWeight.w600, letterSpacing: 1.8,
            fontFamily: 'monospace',
            shadows: [Shadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 3, offset: const Offset(0, 1))],
          ))),

          // ── VALID THRU + Expiry ──
          Positioned(left: 24, bottom: 38, child: Row(children: [
            Text('VALID\nTHRU', style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 6.5, fontWeight: FontWeight.w500, letterSpacing: 0.8, height: 1.3)),
            const SizedBox(width: 6),
            Text(expiry, style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ])),

          // ── Cardholder Name ──
          Positioned(left: 24, bottom: 16, child: Text(
            (name.isNotEmpty ? name : 'CARD HOLDER').toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.8,
              shadows: [Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 2)],
            ),
          )),

          // ── Mastercard Logo ──
          Positioned(right: 20, bottom: 20, child: SizedBox(
            width: 58, height: 40,
            child: CustomPaint(painter: _MastercardLogoPainter()),
          )),

          // ── Frozen Overlay ──
          if (isFrozen) Positioned.fill(child: Container(
            decoration: BoxDecoration(color: const Color(0xFF0F172A).withValues(alpha: 0.75), borderRadius: BorderRadius.circular(16)),
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

/// Realistic EMV chip contact pads
class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final goldenLine = Paint()
      ..color = const Color(0xFFB8860B).withValues(alpha: 0.45)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    // Horizontal lines
    canvas.drawLine(Offset(0, size.height * 0.28), Offset(size.width, size.height * 0.28), goldenLine);
    canvas.drawLine(Offset(0, size.height * 0.50), Offset(size.width, size.height * 0.50), goldenLine);
    canvas.drawLine(Offset(0, size.height * 0.72), Offset(size.width, size.height * 0.72), goldenLine);

    // Vertical lines
    canvas.drawLine(Offset(size.width * 0.33, 0), Offset(size.width * 0.33, size.height), goldenLine);
    canvas.drawLine(Offset(size.width * 0.66, 0), Offset(size.width * 0.66, size.height), goldenLine);

    // Center rectangle (the main contact pad)
    final padPaint = Paint()
      ..color = const Color(0xFFB8860B).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.25, size.height * 0.20, size.width * 0.50, size.height * 0.60),
        const Radius.circular(2),
      ),
      padPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Mastercard interlocking circles logo with "mastercard" text
class _MastercardLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final r = size.height * 0.35; // circle radius
    final cx = size.width / 2;
    final cy = size.height * 0.42;
    final gap = r * 0.7; // overlap distance

    // Red circle (left)
    final redPaint = Paint()..color = const Color(0xFFEB001B);
    canvas.drawCircle(Offset(cx - gap, cy), r, redPaint);

    // Amber circle (right)
    final amberPaint = Paint()..color = const Color(0xFFF79E1B);
    canvas.drawCircle(Offset(cx + gap, cy), r, amberPaint);

    // Overlap blend (darker orange)
    final overlapPaint = Paint()..color = const Color(0xFFFF5F00);
    canvas.save();
    // Clip to left circle, then draw right circle intersection
    final leftPath = Path()..addOval(Rect.fromCircle(center: Offset(cx - gap, cy), radius: r));
    canvas.clipPath(leftPath);
    canvas.drawCircle(Offset(cx + gap, cy), r, overlapPaint);
    canvas.restore();

    // "mastercard" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'mastercard',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.95),
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(cx - textPainter.width / 2, cy + r + 3));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
