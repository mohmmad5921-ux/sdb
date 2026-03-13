import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class BetalTab extends StatelessWidget {
  const BetalTab({super.key});

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, bottom: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Header (Lunar: person icon + "Betal" + "+" button) ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.textSecondary),
                ),
                const SizedBox(width: 10),
                Text(t.navPayments, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
              ]),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/transfer'),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.add_rounded, size: 22, color: AppTheme.textSecondary),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),

          // ── Payment Options (Lunar style: full-width list in a card) ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              _buildPaymentOption(
                context,
                Icons.swap_horiz_rounded,
                t.send,
                'تحويل إلى حساب آخر',
                () => Navigator.pushNamed(context, '/transfer'),
              ),
              _divider(),
              _buildPaymentOption(
                context,
                Icons.receipt_long_rounded,
                'دفع الفواتير',
                'دفع فاتورة',
                () => Navigator.pushNamed(context, '/transfer'),
              ),
              _divider(),
              _buildPaymentOption(
                context,
                Icons.add_circle_outline_rounded,
                t.addMoney,
                'إضافة أموال لحسابك',
                () => Navigator.pushNamed(context, '/deposit'),
              ),
              _divider(),
              _buildPaymentOption(
                context,
                Icons.currency_exchange_rounded,
                t.exchange,
                'تحويل بين العملات',
                () => Navigator.pushNamed(context, '/exchange'),
              ),
            ]),
          ),
          const SizedBox(height: 28),

          // ── Recurring Section (Lunar: "Faste betalinger") ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('عمليات متكررة', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              _buildPaymentOption(
                context,
                Icons.repeat_rounded,
                'التحويلات المجدولة',
                'إدارة المدفوعات المتكررة',
                () => Navigator.pushNamed(context, '/transfer'),
              ),
            ]),
          ),
          const SizedBox(height: 28),

          // ── Recipients Section (Lunar: "Modtagere") ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('المستلمون', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(children: [
              _buildPaymentOption(
                context,
                Icons.people_outline_rounded,
                'جهات اتصالي',
                'إدارة المستلمين المحفوظين',
                () => Navigator.pushNamed(context, '/contacts'),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppTheme.bgMuted,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 20, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          ])),
          const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textMuted),
        ]),
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: AppTheme.border, indent: 70);
}
