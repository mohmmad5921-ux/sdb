import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'dashboard_tab.dart';
import 'cards_tab.dart';
import 'transactions_tab.dart';
import 'more_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  final _tabs = const [DashboardTab(), CardsTab(), TransactionsTab(), MoreTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgSurface,
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, -5))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _navItem(0, Icons.home_rounded, 'الرئيسية'),
              _navItem(1, Icons.credit_card_rounded, 'البطاقات'),
              _navItem(2, Icons.swap_horiz_rounded, 'المعاملات'),
              _navItem(3, Icons.more_horiz_rounded, 'المزيد'),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int i, IconData icon, String label) {
    final active = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: active ? 20 : 12, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: active ? AppTheme.primary.withValues(alpha: 0.12) : Colors.transparent),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 22, color: active ? AppTheme.primary : AppTheme.textMuted),
          if (active) ...[const SizedBox(width: 8), Text(label, style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w700))],
        ]),
      ),
    );
  }
}
