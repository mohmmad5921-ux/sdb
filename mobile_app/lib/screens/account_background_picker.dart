import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/app_theme.dart';

class AccountBackgroundPicker extends StatefulWidget {
  final Map<String, dynamic> account;
  const AccountBackgroundPicker({super.key, required this.account});
  @override
  State<AccountBackgroundPicker> createState() => _AccountBackgroundPickerState();

  // ══════════ PUBLIC Static helpers for other screens ══════════
  static Future<int> getSavedBgIndex(dynamic accountId) async {
    const storage = FlutterSecureStorage();
    final val = await storage.read(key: 'account_bg_$accountId');
    return int.tryParse(val ?? '0') ?? 0;
  }

  static List<Color> getBgColors(int index) {
    if (index < 0 || index >= backgrounds.length) return List<Color>.from(backgrounds[0]['colors']);
    return List<Color>.from(backgrounds[index]['colors']);
  }

  static bool hasBgWaves(int index) {
    if (index < 0 || index >= backgrounds.length) return true;
    return backgrounds[index]['hasWaves'] == true;
  }

  static String? getBgImage(int index) {
    if (index < 0 || index >= backgrounds.length) return null;
    return backgrounds[index]['image'] as String?;
  }

  // ══════════ Background Data ══════════
  static const List<Map<String, dynamic>> backgrounds = [
    {'name': 'Ocean', 'category': 'SDB', 'colors': [Color(0xFF0A3D5C), Color(0xFF0C4A6E), Color(0xFF155E75)], 'hasWaves': true, 'image': null},
    {'name': 'Dark', 'category': 'SDB', 'colors': [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)], 'hasWaves': false, 'image': null},
    {'name': 'Lime', 'category': 'Color', 'colors': [Color(0xFF84CC16), Color(0xFF65A30D), Color(0xFF4D7C0F)], 'hasWaves': false, 'image': null},
    {'name': 'Purple', 'category': 'Color', 'colors': [Color(0xFF7C3AED), Color(0xFF6D28D9), Color(0xFF5B21B6)], 'hasWaves': false, 'image': null},
    {'name': 'Blue', 'category': 'Color', 'colors': [Color(0xFF2563EB), Color(0xFF1D4ED8), Color(0xFF1E40AF)], 'hasWaves': false, 'image': null},
    {'name': 'Rose', 'category': 'Color', 'colors': [Color(0xFFF43F5E), Color(0xFFE11D48), Color(0xFFBE123C)], 'hasWaves': false, 'image': null},
    {'name': 'Amber', 'category': 'Color', 'colors': [Color(0xFFF59E0B), Color(0xFFD97706), Color(0xFFB45309)], 'hasWaves': false, 'image': null},
    {'name': 'Emerald', 'category': 'Color', 'colors': [Color(0xFF10B981), Color(0xFF059669), Color(0xFF047857)], 'hasWaves': false, 'image': null},
    {'name': 'Indigo', 'category': 'Color', 'colors': [Color(0xFF6366F1), Color(0xFF4F46E5), Color(0xFF4338CA)], 'hasWaves': false, 'image': null},
    {'name': 'Pink', 'category': 'Color', 'colors': [Color(0xFFEC4899), Color(0xFFDB2777), Color(0xFFBE185D)], 'hasWaves': false, 'image': null},
    {'name': 'غابة', 'category': 'Nature', 'colors': [Color(0xFF064E3B), Color(0xFF065F46), Color(0xFF047857)], 'hasWaves': false, 'image': 'assets/backgrounds/forest.png'},
    {'name': 'جبال', 'category': 'Nature', 'colors': [Color(0xFF3B1F6E), Color(0xFF5B3A8C), Color(0xFF7C5FAF)], 'hasWaves': false, 'image': 'assets/backgrounds/mountains.png'},
    {'name': 'غروب', 'category': 'Nature', 'colors': [Color(0xFFB91C1C), Color(0xFFDC2626), Color(0xFFF97316)], 'hasWaves': false, 'image': 'assets/backgrounds/sunset.png'},
    {'name': 'منظر بحري', 'category': 'Nature', 'colors': [Color(0xFF0E7490), Color(0xFF0891B2), Color(0xFF06B6D4)], 'hasWaves': false, 'image': 'assets/backgrounds/ocean_aerial.png'},
  ];

  // ══════════ Icon Data ══════════
  static const List<Map<String, dynamic>> icons = [
    {'icon': Icons.block_rounded, 'category': 'None', 'label': 'بدون'},
    {'icon': Icons.person_rounded, 'category': 'Popular', 'label': 'شخص'},
    {'icon': Icons.people_rounded, 'category': 'Popular', 'label': 'مجموعة'},
    {'icon': Icons.home_rounded, 'category': 'Popular', 'label': 'منزل'},
    {'icon': Icons.savings_rounded, 'category': 'Popular', 'label': 'ادخار'},
    {'icon': Icons.spa_rounded, 'category': 'Popular', 'label': 'صحة'},
    {'icon': Icons.shopping_basket_rounded, 'category': 'Popular', 'label': 'تسوق'},
    {'icon': Icons.fastfood_rounded, 'category': 'Popular', 'label': 'طعام'},
    {'icon': Icons.shopping_cart_rounded, 'category': 'Popular', 'label': 'عربة'},
    {'icon': Icons.cake_rounded, 'category': 'Popular', 'label': 'احتفال'},
    {'icon': Icons.card_giftcard_rounded, 'category': 'Popular', 'label': 'هدية'},
    {'icon': Icons.attach_money_rounded, 'category': 'Money', 'label': 'دولار'},
    {'icon': Icons.lock_rounded, 'category': 'Money', 'label': 'مقفل'},
    {'icon': Icons.currency_exchange_rounded, 'category': 'Money', 'label': 'صرف'},
    {'icon': Icons.redeem_rounded, 'category': 'Money', 'label': 'استرداد'},
    {'icon': Icons.schedule_rounded, 'category': 'Money', 'label': 'مجدول'},
    {'icon': Icons.pedal_bike_rounded, 'category': 'Travel', 'label': 'دراجة'},
    {'icon': Icons.pets_rounded, 'category': 'Travel', 'label': 'حيوان'},
    {'icon': Icons.directions_car_rounded, 'category': 'Travel', 'label': 'سيارة'},
    {'icon': Icons.directions_bus_rounded, 'category': 'Travel', 'label': 'حافلة'},
    {'icon': Icons.flight_rounded, 'category': 'Travel', 'label': 'طيران'},
  ];
}

class _AccountBackgroundPickerState extends State<AccountBackgroundPicker> {
  int _activeTab = 0;
  int _selectedBg = 0;
  int _selectedIcon = 0;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() { super.initState(); _loadSaved(); }

  Future<void> _loadSaved() async {
    final bgIdx = await _storage.read(key: 'account_bg_${widget.account['id']}');
    final iconIdx = await _storage.read(key: 'account_icon_${widget.account['id']}');
    if (mounted) {
      setState(() {
        _selectedBg = int.tryParse(bgIdx ?? '0') ?? 0;
        _selectedIcon = int.tryParse(iconIdx ?? '0') ?? 0;
      });
    }
  }

  Future<void> _save() async {
    await _storage.write(key: 'account_bg_${widget.account['id']}', value: _selectedBg.toString());
    await _storage.write(key: 'account_icon_${widget.account['id']}', value: _selectedIcon.toString());
    if (mounted) {
      Navigator.pop(context, {'bgIndex': _selectedBg, 'iconIndex': _selectedIcon});
    }
  }

  List<Map<String, dynamic>> _bgsByCategory(String cat) => AccountBackgroundPicker.backgrounds.where((b) => b['category'] == cat).toList();

  @override
  Widget build(BuildContext context) {
    final balance = (widget.account['balance'] is num)
        ? (widget.account['balance'] as num).toDouble()
        : double.tryParse(widget.account['balance'].toString()) ?? 0;
    final currency = widget.account['currency']?['code'] ?? 'EUR';
    final symbol = {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[currency] ?? currency;
    final currentBg = AccountBackgroundPicker.backgrounds[_selectedBg];
    final bgColors = List<Color>.from(currentBg['colors']);
    final bgImage = currentBg['image'] as String?;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(children: [
          // Back button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(alignment: Alignment.centerLeft, child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary),
              ),
            )),
          ),
          const SizedBox(height: 8),

          // Card Preview
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 200,
            decoration: BoxDecoration(
              gradient: bgImage == null ? LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: bgColors) : null,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: bgColors[0].withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(children: [
                if (bgImage != null) Positioned.fill(child: Image.asset(bgImage, fit: BoxFit.cover)),
                if (currentBg['hasWaves'] == true) Positioned.fill(child: CustomPaint(painter: _PreviewWavePainter())),
                if (bgImage != null) Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.25))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      if (_selectedIcon > 0) Icon(AccountBackgroundPicker.icons[_selectedIcon]['icon'] as IconData, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                      if (_selectedIcon > 0) const SizedBox(width: 4),
                      Text('حساب $currency', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                    ]),
                    const SizedBox(height: 8),
                    Text('$symbol${balance.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Row(children: [
                      _fadedPill('إرسال'), const SizedBox(width: 8), _fadedPill('البطاقات'),
                      const Spacer(),
                      Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)),
                        child: Icon(Icons.more_horiz, size: 16, color: Colors.white.withValues(alpha: 0.5))),
                    ]),
                  ]),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 20),

          // Picker
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), border: Border.all(color: AppTheme.border)),
              child: Column(children: [
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24), padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [_tabPill('الخلفية', 0), _tabPill('الأيقونة', 1)]),
                ),
                const SizedBox(height: 16),
                Expanded(child: _activeTab == 0 ? _buildBgTab() : _buildIconTab()),
              ]),
            ),
          ),

          // Done
          Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(24, 12, 24, 12), child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: const Text('تم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          )),
        ]),
      ),
    );
  }

  Widget _buildBgTab() {
    return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _bgSection('SDB', 'SDB'),
      const SizedBox(height: 20),
      _bgSection('ألوان', 'Color'),
      const SizedBox(height: 20),
      _bgSection('طبيعة', 'Nature'),
      const SizedBox(height: 20),
    ]));
  }

  Widget _bgSection(String title, String category) {
    final bgs = _bgsByCategory(category);
    final startIdx = AccountBackgroundPicker.backgrounds.indexOf(bgs.first);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      const SizedBox(height: 10),
      Wrap(spacing: 10, runSpacing: 10, children: bgs.asMap().entries.map((e) {
        final idx = startIdx + e.key;
        final bg = e.value;
        final colors = List<Color>.from(bg['colors']);
        final image = bg['image'] as String?;
        final selected = _selectedBg == idx;
        return GestureDetector(
          onTap: () => setState(() => _selectedBg = idx),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 95, height: 95,
            decoration: BoxDecoration(
              gradient: image == null ? LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
              borderRadius: BorderRadius.circular(16),
              border: selected ? Border.all(color: Colors.white, width: 2.5) : null,
              boxShadow: [BoxShadow(color: colors[0].withValues(alpha: selected ? 0.4 : 0.15), blurRadius: selected ? 10 : 4)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(selected ? 13 : 16),
              child: Stack(children: [
                if (image != null) Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),
                if (bg['hasWaves'] == true) Positioned.fill(child: CustomPaint(painter: _PreviewWavePainter())),
                if (selected) Center(child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.check_rounded, size: 16, color: AppTheme.primary),
                )),
              ]),
            ),
          ),
        );
      }).toList()),
    ]);
  }

  Widget _buildIconTab() {
    return SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _iconSection('بدون', 'None'),
      const SizedBox(height: 20),
      _iconSection('شائع', 'Popular'),
      const SizedBox(height: 20),
      _iconSection('مال وادخار', 'Money'),
      const SizedBox(height: 20),
      _iconSection('سفر وتنقل', 'Travel'),
      const SizedBox(height: 20),
    ]));
  }

  Widget _iconSection(String title, String category) {
    final catIcons = AccountBackgroundPicker.icons.where((i) => i['category'] == category).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      const SizedBox(height: 10),
      Wrap(spacing: 12, runSpacing: 12, children: catIcons.map((ic) {
        final idx = AccountBackgroundPicker.icons.indexOf(ic);
        final selected = _selectedIcon == idx;
        return GestureDetector(
          onTap: () => setState(() => _selectedIcon = idx),
          child: Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: selected ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.bgMuted,
              borderRadius: BorderRadius.circular(24),
              border: selected ? Border.all(color: AppTheme.primary, width: 2) : null,
            ),
            child: Icon(ic['icon'] as IconData, size: 22, color: selected ? AppTheme.primary : AppTheme.textSecondary),
          ),
        );
      }).toList()),
    ]);
  }

  Widget _tabPill(String label, int idx) {
    final active = _activeTab == idx;
    return Expanded(child: GestureDetector(
      onTap: () => setState(() => _activeTab = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: active ? AppTheme.bgCard : Colors.transparent, borderRadius: BorderRadius.circular(10),
          boxShadow: active ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null),
        child: Center(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: active ? FontWeight.w600 : FontWeight.w500, color: active ? AppTheme.textPrimary : AppTheme.textMuted))),
      ),
    ));
  }

  Widget _fadedPill(String label) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 10, fontWeight: FontWeight.w500)));
  }
}

class _PreviewWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    canvas.drawPath(Path()..moveTo(0, h * 0.5)..cubicTo(w * 0.2, h * 0.4, w * 0.5, h * 0.6, w, h * 0.45)..lineTo(w, h)..lineTo(0, h)..close(),
      Paint()..color = const Color(0xFF0891B2).withValues(alpha: 0.2));
    canvas.drawPath(Path()..moveTo(0, h * 0.7)..cubicTo(w * 0.3, h * 0.6, w * 0.7, h * 0.75, w, h * 0.65)..lineTo(w, h)..lineTo(0, h)..close(),
      Paint()..color = const Color(0xFF164E63).withValues(alpha: 0.3));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
