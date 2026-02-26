import 'package:flutter/material.dart';
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
      if (r['success'] == true) setState(() => cards = r['data']?['cards'] ?? r['data'] ?? []);
    } catch (_) {}
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💳 بطاقاتي')),
      body: loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : RefreshIndicator(
            color: AppTheme.primary,
            onRefresh: _load,
            child: cards.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 100),
                  Center(child: Column(children: [
                    const Text('💳', style: TextStyle(fontSize: 60)),
                    const SizedBox(height: 16),
                    const Text('لا توجد بطاقات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('أصدر بطاقتك الأولى من الرئيسية', style: TextStyle(color: Colors.white.withValues(alpha: 0.4))),
                  ])),
                ])
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: cards.length,
                  itemBuilder: (_, i) => _cardWidget(cards[i]),
                ),
          ),
    );
  }

  Widget _cardWidget(Map<String, dynamic> card) {
    final isVirtual = card['card_type'] == 'virtual';
    final isFrozen = card['status'] == 'frozen';
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(children: [
        // Visual Card
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: isVirtual ? [const Color(0xFF5B21B6), const Color(0xFF7C3AED), const Color(0xFF8B5CF6)] : [const Color(0xFF1A1A2E), const Color(0xFF0F0F1E), const Color(0xFF16162A)],
            ),
            boxShadow: [BoxShadow(color: (isVirtual ? const Color(0xFF7C3AED) : Colors.black).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Stack(children: [
            if (isFrozen) Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xFF172554).withValues(alpha: 0.9)),
              child: const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('❄️', style: TextStyle(fontSize: 40)), SizedBox(height: 8), Text('البطاقة مجمّدة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF93C5FD)))])),
            ),
            if (!isFrozen) Padding(
              padding: const EdgeInsets.all(22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(isVirtual ? 'Virtual' : 'Physical', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7))),
                  const Spacer(),
                  Text('SDB', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.5), letterSpacing: 2)),
                ]),
                const SizedBox(height: 24),
                Text(card['card_number_masked'] ?? '•••• •••• •••• ••••', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9), letterSpacing: 3, fontFamily: 'monospace')),
                const Spacer(),
                Row(children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('HOLDER', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1)),
                    Text(card['card_holder_name'] ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                  ]),
                  const Spacer(),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('EXPIRES', style: TextStyle(fontSize: 8, color: Colors.white.withValues(alpha: 0.4), letterSpacing: 1)),
                    Text(card['formatted_expiry'] ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                  ]),
                ]),
              ]),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        // Action buttons
        Row(children: [
          Expanded(child: _actionBtn(isFrozen ? '🔓 تفعيل' : '❄️ تجميد', () async {
            await ApiService.toggleCardFreeze(card['id']);
            _load();
          })),
          const SizedBox(width: 10),
          Expanded(child: _actionBtn('⚙️ إدارة', () {})),
        ]),
      ]),
    );
  }

  Widget _actionBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: Center(child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.7)))),
      ),
    );
  }
}
