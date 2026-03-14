import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/biometric_service.dart';
import '../services/api_service.dart';
import 'dashboard_tab.dart';
import 'wallet_tab.dart';
import 'betal_tab.dart';
import 'insights_tab.dart';
import 'more_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  bool _isLocked = false;
  bool _wasInBackground = false;
  bool _isFaceId = false;
  String _userName = '';
  String _userInitials = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserName();
    _checkInitialBiometric();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadUserName() async {
    try {
      final r = await ApiService.getProfile();
      if (mounted && r['success'] == true) {
        final user = r['data']?['user'] ?? r['data'];
        final name = user?['full_name'] ?? '';
        setState(() {
          _userName = name.toString().split(' ').first;
          final parts = name.toString().trim().split(' ');
          _userInitials = parts.length >= 2
            ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
            : (name.toString().isNotEmpty ? name.toString()[0].toUpperCase() : 'U');
        });
      }
    } catch (_) {}
  }

  Future<void> _checkInitialBiometric() async {
    final enabled = await BiometricService.isEnabled();
    final faceId = await BiometricService.isFaceId();
    if (mounted) {
      setState(() => _isFaceId = faceId);
      if (enabled) {
        setState(() => _isLocked = true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _authenticateWithBiometric();
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed && _wasInBackground) {
      _wasInBackground = false;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _checkBiometricLock();
      });
    }
  }

  Future<void> _checkBiometricLock() async {
    final enabled = await BiometricService.isEnabled();
    if (enabled && mounted) {
      setState(() => _isLocked = true);
      _authenticateWithBiometric();
    }
  }

  Future<void> _authenticateWithBiometric() async {
    try {
      final authenticated = await BiometricService.authenticate(
        reason: L10n.of(context).biometricLogin,
      );
      if (mounted && authenticated) {
        setState(() => _isLocked = false);
      }
    } catch (e) {
      debugPrint('🔐 Biometric auth error: $e');
      if (mounted) setState(() => _isLocked = false);
    }
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0: return DashboardTab(onTabChange: (i) => setState(() => _currentIndex = i));
      case 1: return const WalletTab();
      case 2: return const BetalTab();
      case 3: return const InsightsTab();
      case 4: return const MoreTab();
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    return Scaffold(
      body: Stack(children: [
        _getScreen(_currentIndex),
        if (_isLocked) _buildLockOverlay(),
      ]),
      bottomNavigationBar: _isLocked ? null : Container(
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
                _buildNavItem(1, Icons.account_balance_wallet_rounded, t.myWallets),
                _buildNavItem(2, Icons.swap_vert_rounded, t.navPayments),
                _buildNavItem(3, Icons.insights_rounded, t.navActivity),
                _buildNavItem(4, Icons.person_rounded, t.navProfile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════ Lunar-style Lock Screen ═══════

  Widget _buildLockOverlay() {
    final t = L10n.of(context);
    return GestureDetector(
      onTap: _authenticateWithBiometric,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Column(children: [
            const SizedBox(height: 20),

            // Face ID / Fingerprint icon at top center (Lunar: dark rounded square)
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                _isFaceId ? Icons.face_rounded : Icons.fingerprint_rounded,
                size: 50,
                color: AppTheme.primary,
              ),
            ),

            const Spacer(),

            // User avatar + welcome (Lunar: pink circle with initials + welcome text)
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFF9A8D4),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Center(
                child: Text(
                  _userInitials.isNotEmpty ? _userInitials : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              '${t.welcomeBack}, $_userName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
            ),

            const Spacer(),
            const SizedBox(height: 40),
          ]),
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
