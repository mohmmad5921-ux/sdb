import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});
  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  List accounts = [];
  Map<String, dynamic>? selectedAccount;
  final _amount = TextEditingController();
  bool loading = false, loadingAccounts = true, processing = false;
  String? error, success;
  double fee = 0, net = 0;
  int _payMethod = 0; // 0=card, 1=apple, 2=google

  @override
  void initState() { super.initState(); _loadAccounts(); }

  Future<void> _loadAccounts() async {
    final r = await ApiService.getAccounts();
    if (r['success'] == true) {
      final d = r['data'];
      setState(() { accounts = d is List ? d : d?['accounts'] ?? []; if (accounts.isNotEmpty) selectedAccount = accounts.first; });
    }
    setState(() => loadingAccounts = false);
  }

  String fmt(dynamic a) => NumberFormat('#,##0.00').format(double.tryParse('$a') ?? 0);

  void _calcFee() {
    final amount = double.tryParse(_amount.text) ?? 0;
    fee = double.parse(((amount * 1.5 / 100) + 0.50).toStringAsFixed(2));
    net = double.parse((amount - fee).toStringAsFixed(2));
    if (net < 0) net = 0;
  }

  Future<void> _handleDeposit() async {
    if (selectedAccount == null || _amount.text.isEmpty) {
      setState(() => error = L10n.of(context).pleaseFillAllFields);
      return;
    }
    final amount = double.tryParse(_amount.text) ?? 0;
    if (amount < 1 || amount > 50000) {
      setState(() => error = L10n.of(context).amountMustBeBetween);
      return;
    }

    setState(() { loading = true; error = null; success = null; });

    try {
      // 1. Create PaymentIntent on server
      final intentRes = await ApiService.createStripeIntent(selectedAccount!['id'] as int, amount);
      if (intentRes['success'] != true) {
        setState(() { error = intentRes['data']?['message'] ?? L10n.of(context).depositFailed; loading = false; });
        return;
      }

      final clientSecret = intentRes['data']['client_secret'];

      // 2. Initialize PaymentSheet with Apple Pay / Google Pay support
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'SDB Bank',
          style: ThemeMode.light,
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'DK',
            currencyCode: 'DKK',
            testEnv: true,
          ),
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'DK',
          ),
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFF10B981),
              background: Colors.white,
              componentBackground: const Color(0xFFF5F7FA),
              componentBorder: const Color(0xFFE5E7EB),
              primaryText: const Color(0xFF111827),
              secondaryText: const Color(0xFF6B7280),
              placeholderText: const Color(0xFF9CA3AF),
              icon: const Color(0xFF10B981),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: const Color(0xFF10B981),
                  text: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

      // 3. Present PaymentSheet (handles Card, Apple Pay, Google Pay)
      setState(() => processing = true);
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment succeeded — confirm on backend
      final confirmRes = await ApiService.confirmStripeDeposit(
        intentRes['data']['payment_intent_id'],
        selectedAccount!['id'] as int,
      );

      if (confirmRes['success'] == true) {
        setState(() {
          success = '${L10n.of(context).depositSuccess} ✅\n${fmt(net > 0 ? net : amount)} ${selectedAccount!['currency']?['symbol'] ?? ''}';
          processing = false;
          loading = false;
        });
        _amount.clear();
        _loadAccounts();
      } else {
        setState(() { error = confirmRes['data']?['message'] ?? L10n.of(context).depositFailed; processing = false; loading = false; });
      }
    } on StripeException catch (e) {
      setState(() {
        if (e.error.code == FailureCode.Canceled) {
          error = L10n.of(context).operationCancelled;
        } else {
          error = e.error.localizedMessage ?? L10n.of(context).depositFailed;
        }
        processing = false;
        loading = false;
      });
    } catch (e) {
      setState(() { error = '${L10n.of(context).error}: $e'; processing = false; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final cur = selectedAccount?['currency']?['symbol'] ?? '€';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l.deposit, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF111827), fontSize: 20)),
        backgroundColor: Colors.white, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF111827), size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: loadingAccounts
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Secure payment badge (no Stripe branding)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFF10B981).withValues(alpha: 0.06), const Color(0xFF10B981).withValues(alpha: 0.02)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.15)),
              ),
              child: Row(children: [
                const Icon(Icons.verified_user_rounded, size: 16, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Expanded(child: Text(l.securePayment, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500))),
              ]),
            ),
            const SizedBox(height: 24),

            // Account selector
            _label(l.depositTo),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
              child: DropdownButton<int>(
                isExpanded: true, underline: const SizedBox(), dropdownColor: Colors.white,
                value: selectedAccount?['id'],
                style: const TextStyle(color: Color(0xFF111827), fontSize: 15, fontWeight: FontWeight.w600),
                items: accounts.map<DropdownMenuItem<int>>((a) => DropdownMenuItem(value: a['id'] as int,
                  child: Text('${a['currency']?['code'] ?? ''} — ${fmt(a['balance'])} ${a['currency']?['symbol'] ?? ''}',
                    style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w600)))).toList(),
                onChanged: (v) => setState(() => selectedAccount = accounts.firstWhere((a) => a['id'] == v)),
              ),
            ),
            const SizedBox(height: 20),

            // Amount
            _label(l.amount),
            Container(
              decoration: BoxDecoration(color: const Color(0xFFF5F7FA), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
              child: TextField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textDirection: TextDirection.ltr,
                style: const TextStyle(color: Color(0xFF111827), fontSize: 28, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() => _calcFee()),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: const TextStyle(color: Color(0xFFD1D5DB), fontSize: 28, fontWeight: FontWeight.w800),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 14),
                    child: Text(cur, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fee breakdown
            if (_amount.text.isNotEmpty && (double.tryParse(_amount.text) ?? 0) > 0) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                ),
                child: Column(children: [
                  _feeRow(l.amount, '${fmt(double.tryParse(_amount.text) ?? 0)} $cur'),
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
                  _feeRow(l.processingFee, '-${fmt(fee)} $cur'),
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
                  _feeRow(l.netAmount, '${fmt(net)} $cur', bold: true, color: const Color(0xFF10B981)),
                ]),
              ),
              const SizedBox(height: 20),
            ],

            // Payment methods
            _label(l.paymentMethod),
            Row(children: [
              _payMethodChip(0, Icons.credit_card_rounded, l.card),
              const SizedBox(width: 8),
              _payMethodChip(1, Icons.apple_rounded, 'Apple Pay'),
              const SizedBox(width: 8),
              _payMethodChip(2, Icons.g_mobiledata_rounded, 'Google Pay'),
            ]),
            const SizedBox(height: 20),

            // Error
            if (error != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFFECACA))),
                child: Row(children: [
                  const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(error!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w600))),
                ]),
              ),
              const SizedBox(height: 12),
            ],

            // Success
            if (success != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFBBF7D0))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(success!, style: const TextStyle(color: Color(0xFF065F46), fontSize: 13, fontWeight: FontWeight.w600))),
                ]),
              ),
              const SizedBox(height: 12),
            ],

            // Deposit button
            const SizedBox(height: 8),
            GestureDetector(
              onTap: loading || processing ? null : _handleDeposit,
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
                  boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Center(child: loading || processing
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(_payMethod == 1 ? Icons.apple_rounded : _payMethod == 2 ? Icons.g_mobiledata_rounded : Icons.lock_rounded, size: 20, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(l.depositNow, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                    ])),
              ),
            ),

            const SizedBox(height: 30),
          ])),
    );
  }

  Widget _payMethodChip(int index, IconData icon, String label) {
    final sel = _payMethod == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _payMethod = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFF10B981).withValues(alpha: 0.08) : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: sel ? const Color(0xFF10B981) : const Color(0xFFE5E7EB), width: sel ? 2 : 1),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 22, color: sel ? const Color(0xFF10B981) : const Color(0xFF9CA3AF)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: sel ? const Color(0xFF10B981) : const Color(0xFF9CA3AF))),
          ]),
        ),
      ),
    );
  }

  Widget _feeRow(String label, String value, {bool bold = false, Color? color}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 13, color: const Color(0xFF6B7280), fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
      Text(value, style: TextStyle(fontSize: 14, color: color ?? const Color(0xFF111827), fontWeight: bold ? FontWeight.w800 : FontWeight.w600)),
    ]);
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF374151))));
}
