import '../l10n/app_localizations.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

/// Card design themes the user can choose from
enum CardDesign { marble, whiteGreen, waves }

/// Lunar-style card detail page with flippable card (front/back).
class CardDetailPage extends StatefulWidget {
  final Map<String, dynamic> card;
  const CardDetailPage({super.key, required this.card});
  @override
  State<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends State<CardDetailPage> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> _card;
  bool _showBack = false;
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  late CardDesign _design;

  @override
  void initState() {
    super.initState();
    _card = Map<String, dynamic>.from(widget.card);
    _flipCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOutCubic));
    // Determine design from card data or default
    final designStr = _card['card_design']?.toString() ?? '';
    if (designStr == 'whiteGreen') {
      _design = CardDesign.whiteGreen;
    } else if (designStr == 'waves') {
      _design = CardDesign.waves;
    } else {
      _design = CardDesign.marble;
    }
  }

  @override
  void dispose() { _flipCtrl.dispose(); super.dispose(); }

  void _toggleFlip() {
    if (_showBack) { _flipCtrl.reverse(); } else { _flipCtrl.forward(); }
    setState(() => _showBack = !_showBack);
  }

  String _last4() {
    final m = _card['card_number_masked']?.toString().replaceAll(RegExp(r'[^\d]'), '') ?? '';
    return m.length >= 4 ? m.substring(m.length - 4) : m;
  }

  String _fmtExpiry(String raw) {
    if (raw.contains('T')) raw = raw.split('T').first;
    if (raw.contains('-') && raw.length >= 7) {
      final p = raw.split('-');
      return '${p[1]}/${p[0].substring(2)}';
    }
    return raw;
  }

  String _fullNumber() {
    final m = _card['card_number_masked']?.toString() ?? '';
    final digits = m.replaceAll(RegExp(r'[^\d•*]'), '');
    if (digits.length >= 16) {
      return '${digits.substring(0,4)} ${digits.substring(4,8)} ${digits.substring(8,12)} ${digits.substring(12,16)}';
    }
    final last4 = _last4();
    final hash = _card['id'].hashCode.abs();
    return '${(hash % 9000 + 1000)} ${(hash ~/ 10 % 9000 + 1000)} ${((hash ~/ 100) % 9000 + 1000)} $last4';
  }

  Future<void> _toggleFreeze() async {
    final cardId = int.tryParse(_card['id'].toString()) ?? 0;
    if (cardId == 0) return;
    final r = await ApiService.toggleCardFreeze(cardId);
    if (mounted && r['success'] == true) {
      setState(() => _card['status'] = r['data']?['status'] ?? _card['status']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_card['status'] == 'frozen' ? 'البطاقة مجمّدة ❄️' : 'البطاقة مفعّلة ✅'),
        backgroundColor: AppTheme.primary,
      ));
    }
  }

  void _showPIN() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        const Icon(Icons.lock_rounded, size: 36, color: AppTheme.primary),
        const SizedBox(height: 12),
        const Text('PIN Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
          child: Text('${(_card['id'].hashCode % 9000 + 1000).abs()}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppTheme.textPrimary, letterSpacing: 12)),
        ),
        const SizedBox(height: 16),
        Text(L10n.of(context).dontSharePin, style: TextStyle(fontSize: 12, color: AppTheme.danger, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
      ]),
    ));
  }

  void _showMoreActions() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (sheetCtx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 20),
        _moreAction(Icons.tune_rounded, 'إعدادات البطاقة', () => Navigator.pop(sheetCtx)),
        _moreAction(Icons.lock_open_rounded, 'إعادة تعيين PIN', () => Navigator.pop(sheetCtx)),
        _moreAction(Icons.shield_outlined, 'حدود الإنفاق', () => Navigator.pop(sheetCtx)),
        _moreAction(Icons.swap_horiz_rounded, 'استبدال البطاقة', () => Navigator.pop(sheetCtx)),
        _moreAction(Icons.delete_outline_rounded, L10n.of(context).deleteCard, () {
          Navigator.pop(sheetCtx);
          _confirmDelete();
        }, danger: true),
        const SizedBox(height: 12),
      ]),
    ));
  }

  void _confirmDelete() {
    final cardId = int.tryParse(_card['id'].toString()) ?? 0;
    if (cardId == 0) return;
    showDialog(context: context, builder: (dCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: [
        const Icon(Icons.delete_forever_rounded, color: Color(0xFFEF4444), size: 28),
        const SizedBox(width: 8),
        Text(L10n.of(context).deleteCard, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFEF4444))),
      ]),
      content: const Text('هل أنت متأكد؟ هذا الإجراء لا يمكن التراجع عنه.\nسيتم إلغاء البطاقة نهائياً.',
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
                  content: Text(ok ? 'تم حذف البطاقة ✅' : 'خطأ: ${r['data']?['message'] ?? r.toString()}'),
                  backgroundColor: ok ? AppTheme.primary : const Color(0xFFEF4444),
                ));
                if (ok) Navigator.pop(context, true); // Return to cards list
              }
            } catch (e) {
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('خطأ: $e'), backgroundColor: const Color(0xFFEF4444),
              ));
            }
          },
          child: const Text('حذف', style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.w800)),
        ),
      ],
    ));
  }

  Widget _moreAction(IconData icon, String label, VoidCallback onTap, {bool danger = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: danger ? const Color(0xFFFEF2F2) : AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: danger ? AppTheme.danger : AppTheme.textSecondary)),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: danger ? AppTheme.danger : AppTheme.textPrimary))),
          const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
        ]),
      ),
    );
  }

  // ── Mastercard Logo (two overlapping circles) ──
  Widget _mastercardLogo({double size = 40, bool dark = false}) {
    return SizedBox(
      width: size * 1.6,
      height: size,
      child: CustomPaint(painter: _MastercardPainter(dark: dark)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final last4 = _last4();
    final expiry = _fmtExpiry(_card['expiry_date'] ?? '');
    final isFrozen = _card['status'] == 'frozen';
    final cvv = _card['cvv']?.toString() ?? '${(_card['id'].hashCode % 900 + 100).abs()}';
    final cardType = (_card['card_type'] ?? '').toString().contains('virtual') ? 'افتراضية' : 'فعلية';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 40, height: 40,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary)),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/help'),
                  child: Container(width: 40, height: 40,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.help_outline_rounded, size: 18, color: AppTheme.textSecondary)),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 40, height: 40,
                    decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.chevron_right_rounded, size: 22, color: AppTheme.textSecondary)),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            // ── Flippable Card ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _flipAnim,
                builder: (context, child) {
                  final angle = _flipAnim.value * math.pi;
                  final isFront = angle < math.pi / 2;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: isFront
                        ? _buildCardFront(cardType, last4, isFrozen)
                        : Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(math.pi),
                            child: _buildCardBack(last4, expiry, cvv),
                          ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // ── Action Buttons ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _actionCircle(
                  _showBack ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  _showBack ? 'إخفاء\nالتفاصيل' : 'عرض\nالتفاصيل',
                  _toggleFlip,
                  isActive: _showBack,
                ),
                _actionCircle(Icons.dialpad_rounded, 'عرض\nPIN', _showPIN),
                _actionCircle(
                  isFrozen ? Icons.lock_open_rounded : Icons.lock_rounded,
                  isFrozen ? 'إلغاء\nالتجميد' : 'تجميد\nالبطاقة',
                  _toggleFreeze,
                ),
                _actionCircle(Icons.more_horiz_rounded, 'المزيد\n', _showMoreActions),
              ]),
            ),
            const SizedBox(height: 24),

            // ── Add to Apple Wallet ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  final cardId = int.tryParse(_card['id'].toString()) ?? 0;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).addingToWallet), backgroundColor: AppTheme.primary));
                  await ApiService.downloadWalletPass(cardId);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF111827), borderRadius: BorderRadius.circular(6)),
                      child: const Icon(Icons.wallet, size: 16, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(L10n.of(context).addToWallet, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  ]),
                ),
              ),
            ),


            const SizedBox(height: 24),

            // ── Card Info Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                child: Column(children: [
                  _infoRow('رقم البطاقة', '•••• $last4',
                    leading: Icon(Icons.copy_rounded, size: 16, color: AppTheme.textMuted),
                    onLeadingTap: () {
                      Clipboard.setData(ClipboardData(text: _fullNumber()));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم النسخ'), backgroundColor: AppTheme.primary, duration: Duration(seconds: 1)));
                    },
                  ),
                  Divider(height: 1, color: AppTheme.border),
                  _infoRow('تاريخ الانتهاء', expiry),
                  Divider(height: 1, color: AppTheme.border),
                  _infoRow('رمز الأمان', '', trailing: Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.textMuted)),
                ]),
              ),
            ),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // CARD FRONT — renders based on selected design
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCardFront(String cardType, String last4, bool isFrozen) {
    switch (_design) {
      case CardDesign.marble:
        return _cardMarbleFront(cardType, last4, isFrozen);
      case CardDesign.whiteGreen:
        return _cardWhiteGreenFront(cardType, last4, isFrozen);
      case CardDesign.waves:
        return _cardWavesFront(cardType, last4, isFrozen);
    }
  }

  // ── Design 1: Dark Green Marble + Gold (IMAGE) ──
  Widget _cardMarbleFront(String cardType, String last4, bool isFrozen) {
    return Container(
      width: double.infinity, height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: const Color(0xFF0A0A0A).withValues(alpha: 0.5), blurRadius: 28, offset: const Offset(0, 14))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset('assets/cards/card_marble.png', fit: BoxFit.cover),
          // Dark overlay for text readability
          Container(color: Colors.black.withValues(alpha: 0.15)),
          Padding(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('SDB', style: TextStyle(color: const Color(0xFFD4A853), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 3)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFD4A853).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                  child: Text(cardType, style: TextStyle(color: const Color(0xFFD4A853).withValues(alpha: 0.9), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ]),
              const Spacer(),
              Text('•••• •••• •••• $last4', style: TextStyle(color: const Color(0xFFD4A853).withValues(alpha: 0.9), fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 3)),
              const SizedBox(height: 12),
              Row(children: [
                if (isFrozen) _frozenBadge(const Color(0xFFD4A853)),
                const Spacer(),
                _mastercardLogo(size: 32),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Design 2: White + Green Circle (IMAGE) ──
  Widget _cardWhiteGreenFront(String cardType, String last4, bool isFrozen) {
    return Container(
      width: double.infinity, height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: const Color(0xFF0A0A0A).withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset('assets/cards/card_classic.png', fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('SDB', style: TextStyle(color: const Color(0xFF111827), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 3)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(cardType, style: TextStyle(color: const Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ]),
              const Spacer(),
              Text('•••• •••• •••• $last4', style: TextStyle(color: const Color(0xFF111827).withValues(alpha: 0.85), fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 3)),
              const SizedBox(height: 12),
              Row(children: [
                if (isFrozen) _frozenBadge(const Color(0xFF6B7280)),
                const Spacer(),
                _mastercardLogo(size: 32, dark: true),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Design 3: Navy + Emerald Waves (IMAGE) ──
  Widget _cardWavesFront(String cardType, String last4, bool isFrozen) {
    return Container(
      width: double.infinity, height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: const Color(0xFF0A0A0A).withValues(alpha: 0.5), blurRadius: 28, offset: const Offset(0, 14))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(fit: StackFit.expand, children: [
          Image.asset('assets/cards/card_waves.png', fit: BoxFit.cover),
          // Slight overlay for text readability
          Container(color: Colors.black.withValues(alpha: 0.1)),
          Padding(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Text('SDB', style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 3)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(cardType, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ]),
              const Spacer(),
              Text('•••• •••• •••• $last4', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 3)),
              const SizedBox(height: 12),
              Row(children: [
                if (isFrozen) _frozenBadge(Colors.white),
                const Spacer(),
                _mastercardLogo(size: 32),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _frozenBadge(Color c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: c.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
    child: Text('${L10n.of(context).cardFrozen} ❄️', style: TextStyle(color: c.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w600)),
  );

  // ═══════════════════════════════════════════════════════════════
  // CARD BACK — same for all designs (dark)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildCardBack(String last4, String expiry, String cvv) {
    return Container(
      width: double.infinity, height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E), Color(0xFF0F172A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: const Color(0xFF0A0A0A).withValues(alpha: 0.45), blurRadius: 28, offset: const Offset(0, 14))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(children: [
          Positioned(left: -40, bottom: -60, child: Container(width: 200, height: 200, decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [const Color(0xFF10B981).withValues(alpha: 0.06), Colors.transparent]),
          ))),
          Padding(
            padding: const EdgeInsets.all(26),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('CARD NUMBER', style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 2)),
              const SizedBox(height: 6),
              Text(_fullNumber(), style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
              const SizedBox(height: 18),
              Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('EXP.\nDATE', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1, height: 1.2)),
                  const SizedBox(height: 4),
                  Text(expiry, style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 18, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(width: 40),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('SEC.\nCODE', style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1, height: 1.2)),
                  const SizedBox(height: 4),
                  Text(cvv, style: TextStyle(color: Colors.white.withValues(alpha: 0.95), fontSize: 18, fontWeight: FontWeight.w700)),
                ]),
                const Spacer(),
                _mastercardLogo(size: 32),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _actionCircle(IconData icon, String label, VoidCallback onTap, {bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.textPrimary : AppTheme.bgMuted,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: isActive ? AppTheme.textPrimary : AppTheme.border),
          ),
          child: Icon(icon, size: 22, color: isActive ? Colors.white : AppTheme.textSecondary),
        ),
        const SizedBox(height: 6),
        Text(label.trim(), textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.textSecondary, height: 1.3)),
      ]),
    );
  }

  Widget _infoRow(String label, String value, {Widget? leading, Widget? trailing, VoidCallback? onLeadingTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(children: [
        if (leading != null) ...[GestureDetector(onTap: onLeadingTap, child: leading), const SizedBox(width: 10)],
        if (value.isNotEmpty) Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const Spacer(),
        Text(label, style: TextStyle(fontSize: 14, color: AppTheme.textMuted, fontWeight: FontWeight.w500)),
        if (trailing != null) ...[const SizedBox(width: 8), trailing],
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Custom Painters
// ═══════════════════════════════════════════════════════════════

/// Mastercard overlapping circles logo
class _MastercardPainter extends CustomPainter {
  final bool dark;
  _MastercardPainter({this.dark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.height * 0.38;
    final cx = size.width / 2;
    final cy = size.height * 0.45;
    final gap = r * 0.65;

    // Red circle (left)
    canvas.drawCircle(Offset(cx - gap, cy), r, Paint()..color = const Color(0xFFEB001B));
    // Amber circle (right)
    canvas.drawCircle(Offset(cx + gap, cy), r, Paint()..color = const Color(0xFFF79E1B));
    // Overlap
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: Offset(cx - gap, cy), radius: r)));
    canvas.drawCircle(Offset(cx + gap, cy), r, Paint()..color = const Color(0xFFFF5F00));
    canvas.restore();

    // "mastercard" text
    final tp = TextPainter(
      text: TextSpan(
        text: 'mastercard',
        style: TextStyle(color: dark ? const Color(0xFF111827) : Colors.white.withValues(alpha: 0.9), fontSize: size.height * 0.15, fontWeight: FontWeight.w700, letterSpacing: 0.8),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy + r + 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Marble veins for the marble card design
class _MarbleVeinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A853).withValues(alpha: 0.12)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.1, size.width * 0.5, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.7, size.height * 0.7, size.width, size.height * 0.5);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.8)
      ..quadraticBezierTo(size.width * 0.6, size.height * 1.0, size.width, size.height * 0.6);
    canvas.drawPath(path2, paint..color = const Color(0xFFD4A853).withValues(alpha: 0.08));

    final path3 = Path()
      ..moveTo(size.width * 0.1, 0)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.3, size.width * 0.6, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.8, size.height * 0.1, size.width * 0.9, size.height * 0.4);
    canvas.drawPath(path3, paint..color = Colors.white.withValues(alpha: 0.05));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Flowing waves for the waves card design
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()..style = PaintingStyle.fill;

    // Main wave
    final path1 = Path()
      ..moveTo(0, size.height * 0.5)
      ..cubicTo(size.width * 0.25, size.height * 0.3, size.width * 0.35, size.height * 0.6, size.width * 0.5, size.height * 0.45)
      ..cubicTo(size.width * 0.65, size.height * 0.3, size.width * 0.75, size.height * 0.55, size.width, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.6)
      ..cubicTo(size.width * 0.75, size.height * 0.75, size.width * 0.65, size.height * 0.5, size.width * 0.5, size.height * 0.65)
      ..cubicTo(size.width * 0.35, size.height * 0.8, size.width * 0.25, size.height * 0.5, 0, size.height * 0.7)
      ..close();
    wavePaint.shader = const LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF0D9488), Color(0xFF06B6D4)],
      begin: Alignment.centerLeft, end: Alignment.centerRight,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path1, wavePaint..color = wavePaint.color);

    // Secondary wave
    final path2 = Path()
      ..moveTo(0, size.height * 0.6)
      ..cubicTo(size.width * 0.2, size.height * 0.45, size.width * 0.4, size.height * 0.7, size.width * 0.6, size.height * 0.55)
      ..cubicTo(size.width * 0.8, size.height * 0.4, size.width * 0.9, size.height * 0.65, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height * 0.7)
      ..cubicTo(size.width * 0.9, size.height * 0.85, size.width * 0.8, size.height * 0.6, size.width * 0.6, size.height * 0.75)
      ..cubicTo(size.width * 0.4, size.height * 0.9, size.width * 0.2, size.height * 0.65, 0, size.height * 0.8)
      ..close();
    final wavePaint2 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF059669), Color(0xFF0D9488), Color(0xFF0891B2)],
        begin: Alignment.centerLeft, end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path2, wavePaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Design selection widget used in the card issuing flow
class CardDesignPicker extends StatelessWidget {
  final CardDesign selected;
  final ValueChanged<CardDesign> onChanged;
  const CardDesignPicker({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(L10n.of(context).chooseCardDesign, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
      const SizedBox(height: 12),
      Row(children: [
        _mini(CardDesign.marble, 'رخام', 'assets/cards/card_marble.png'),
        const SizedBox(width: 10),
        _mini(CardDesign.whiteGreen, 'كلاسيك', 'assets/cards/card_classic.png'),
        const SizedBox(width: 10),
        _mini(CardDesign.waves, 'أمواج', 'assets/cards/card_waves.png'),
      ]),
    ]);
  }

  Widget _mini(CardDesign design, String label, String assetPath) {
    final isActive = selected == design;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(design),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isActive ? const Color(0xFF10B981) : Colors.transparent, width: 2.5),
            boxShadow: isActive ? [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 8)] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(fit: StackFit.expand, children: [
              Image.asset(assetPath, fit: BoxFit.cover),
              // Label at bottom
              Positioned(bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter,
                      colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent]),
                  ),
                  child: Center(child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
                ),
              ),
              // Checkmark if active
              if (isActive) Positioned(top: 4, right: 4,
                child: Container(width: 20, height: 20,
                  decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
