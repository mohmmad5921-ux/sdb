import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Distribution page matching Lunar's "Fordeling"
/// Shows: Available balance, Goals, Total Saldo
class AccountDistributionPage extends StatelessWidget {
  final Map<String, dynamic> account;
  const AccountDistributionPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final balance = (account['balance'] is num)
        ? (account['balance'] as num).toDouble()
        : double.tryParse(account['balance'].toString()) ?? 0;
    final currency = account['currency']?['code'] ?? 'EUR';
    final symbol = {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[currency] ?? currency;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text('التوزيع', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 20),

            // Distribution Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(children: [
                _row('المتاح للإنفاق', '$symbol${_format(balance)}'),
                Divider(height: 1, color: AppTheme.border, indent: 16, endIndent: 16),
                _row('مخصص للأهداف', '$symbol${_format(0)}'),
                Divider(height: 1, color: AppTheme.border, indent: 16, endIndent: 16),
                _row('الرصيد', '$symbol${_format(balance)}', bold: true),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(
          fontSize: 15,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: AppTheme.textPrimary,
        )),
        Text(value, style: TextStyle(
          fontSize: 15,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: AppTheme.textPrimary,
        )),
      ]),
    );
  }

  String _format(double n) {
    return n.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }
}
