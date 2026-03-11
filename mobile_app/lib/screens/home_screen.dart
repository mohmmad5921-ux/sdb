import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'dashboard_tab.dart';
import 'transfer_screen.dart';
import 'cards_tab.dart';
import 'transactions_tab.dart';
import 'more_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardTab(onTabChange: (i) => setState(() => _currentIndex = i)),
      const TransferScreen(embedded: true),
      const CardsTab(),
      const TransactionsTab(),
      const MoreTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          border: Border(top: BorderSide(color: AppTheme.border, width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, t.navHome),
                _buildNavItem(1, Icons.send_rounded, t.navPayments),
                _buildNavItem(2, Icons.credit_card_rounded, t.navCards),
                _buildNavItem(3, Icons.receipt_long_rounded, t.navActivity),
                _buildNavItem(4, Icons.person_rounded, t.navProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: isActive ? AppTheme.primary : AppTheme.textMuted),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
