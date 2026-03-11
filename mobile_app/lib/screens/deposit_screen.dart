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

  Future<void> _handleStripeDeposit() async {
    if (selectedAccount == null || _amount.text.isEmpty) {
      setState(() => error = 'يرجى ملء جميع الحقول');
      return;
    }
    final amount = double.tryParse(_amount.text) ?? 0;
    if (amount < 1 || amount > 50000) {
      setState(() => error = 'المبلغ يجب أن يكون بين 1 و 50,000');
      return;
    }

    setState(() { loading = true; error = null; success = null; });

    try {
      // 1. Create PaymentIntent on server
      final intentRes = await ApiService.createStripeIntent(selectedAccount!['id'] as int, amount);
      if (intentRes['success'] != true) {
        setState(() { error = intentRes['data']?['message'] ?? 'فشل إنشاء عملية الدفع'; loading = false; });
        return;
      }

      final clientSecret = intentRes['data']['client_secret'];

      // 2. Initialize PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'SDB Bank',
          style: ThemeMode.light,
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
            shapes: PaymentSheetShape(
              borderRadius: 16,
              borderWidth: 1,
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: const Color(0xFF10B981),
                  text: Colors.white,
                ),
              ),
              shapes: PaymentSheetPrimaryButtonShape(
                borderRadius: 14,
              ),
            ),
          ),
        ),
      );

      // 3. Present PaymentSheet
      setState(() => processing = true);
      await Stripe.instance.presentPaymentSheet();

      // 4. Payment succeeded — confirm on backend
      final confirmRes = await ApiService.confirmStripeDeposit(
        intentRes['data']['payment_intent_id'],
        selectedAccount!['id'] as int,
      );

      if (confirmRes['success'] == true) {
        setState(() {
          success = 'تم الإيداع بنجاح! ✅\nتمت إضافة ${fmt(net > 0 ? net : amount)} ${selectedAccount!['currency']?['symbol'] ?? ''}';
          processing = false;
          loading = false;
        });
        _amount.clear();
        _loadAccounts();
      } else {
        setState(() { error = confirmRes['data']?['message'] ?? 'فشل تأكيد الإيداع'; processing = false; loading = false; });
      }
    } on StripeException catch (e) {
      setState(() {
        if (e.error.code == FailureCode.Canceled) {
          error = 'تم إلغاء العملية';
        } else {
          error = e.error.localizedMessage ?? 'فشل الدفع';
        }
        processing = false;
        loading = false;
      });
    } catch (e) {
      setState(() { error = 'خطأ: $e'; processing = false; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('إيداع', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF111827), fontSize: 20)),
        backgroundColor: Colors.white, elevation: 0, scrolledUnderElevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF111827), size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: loadingAccounts
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Stripe badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [const Color(0xFF10B981).withValues(alpha: 0.06), const Color(0xFF10B981).withValues(alpha: 0.02)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.15)),
              ),
              child: const Row(children: [
                Icon(Icons.lock_rounded, size: 16, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text('مدفوعات آمنة عبر ', style: TextStyle(fontSize: 13, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
                Text('Stripe', style: TextStyle(fontSize: 13, color: Color(0xFF635BFF), fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(height: 24),

            // Account selector
            _label('إيداع إلى'),
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
            _label('المبلغ'),
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
                  hintStyle: TextStyle(color: const Color(0xFFD1D5DB), fontSize: 28, fontWeight: FontWeight.w800),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 14),
                    child: Text(selectedAccount?['currency']?['symbol'] ?? '€', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF10B981))),
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
                  _feeRow('المبلغ', '${fmt(double.tryParse(_amount.text) ?? 0)} ${selectedAccount?['currency']?['symbol'] ?? '€'}'),
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
                  _feeRow('رسوم المعالجة', '-${fmt(fee)} ${selectedAccount?['currency']?['symbol'] ?? '€'}'),
                  const Divider(height: 16, color: Color(0xFFF3F4F6)),
                  _feeRow('المبلغ الصافي', '${fmt(net)} ${selectedAccount?['currency']?['symbol'] ?? '€'}', bold: true, color: const Color(0xFF10B981)),
                ]),
              ),
              const SizedBox(height: 20),
            ],

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
              onTap: loading || processing ? null : _handleStripeDeposit,
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
                  boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Center(child: loading || processing
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.credit_card_rounded, size: 20, color: Colors.white),
                      SizedBox(width: 10),
                      Text('إيداع عبر Stripe', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
                    ])),
              ),
            ),

            const SizedBox(height: 20),
            // Test cards hint
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE9E5FF))),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFF7C3AED)),
                  SizedBox(width: 8),
                  Text('وضع الاختبار', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED))),
                ]),
                SizedBox(height: 6),
                Text('بطاقة تجريبية: 4242 4242 4242 4242\nتاريخ: 12/27  |  CVC: 123', style: TextStyle(fontSize: 12, color: Color(0xFF6D28D9), fontWeight: FontWeight.w500, height: 1.5)),
              ]),
            ),
            const SizedBox(height: 30),
          ])),
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
