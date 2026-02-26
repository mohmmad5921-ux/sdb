import 'package:flutter/material.dart';
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
  final _cardNumber = TextEditingController();
  final _cardHolder = TextEditingController();
  final _cardExpiry = TextEditingController();
  final _cardCvv = TextEditingController();
  String paymentMethod = 'card';
  bool loading = false, loadingAccounts = true;
  String? error, success;

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

  Future<void> _submit() async {
    if (selectedAccount == null || _amount.text.isEmpty) { setState(() => error = 'يرجى ملء جميع الحقول'); return; }
    final amount = double.tryParse(_amount.text) ?? 0;
    if (amount < 1 || amount > 50000) { setState(() => error = 'المبلغ يجب أن يكون بين 1 و 50,000'); return; }
    if (paymentMethod == 'card' && (_cardNumber.text.isEmpty || _cardExpiry.text.isEmpty || _cardCvv.text.isEmpty)) {
      setState(() => error = 'يرجى ملء بيانات البطاقة'); return; }
    setState(() { loading = true; error = null; success = null; });
    final r = await ApiService.deposit({'account_id': selectedAccount!['id'], 'amount': amount, 'payment_method': paymentMethod, 'card_number': _cardNumber.text.replaceAll(' ', ''), 'card_holder': _cardHolder.text.isNotEmpty ? _cardHolder.text : 'CARD HOLDER', 'card_expiry': _cardExpiry.text, 'card_cvv': _cardCvv.text});
    setState(() => loading = false);
    if (r['success'] == true) { setState(() => success = 'تم الإيداع بنجاح! ✅ تمت إضافة ${fmt(amount)} ${selectedAccount!['currency']?['symbol'] ?? ''}'); _amount.clear(); _cardNumber.clear(); _cardExpiry.clear(); _cardCvv.clear(); _loadAccounts(); }
    else { setState(() => error = r['data']?['message'] ?? 'فشل الإيداع'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إيداع', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: loadingAccounts ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _label('إيداع إلى'),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: _boxDeco(),
              child: DropdownButton<int>(isExpanded: true, underline: const SizedBox(), dropdownColor: AppTheme.bgCard,
                value: selectedAccount?['id'], style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                items: accounts.map<DropdownMenuItem<int>>((a) => DropdownMenuItem(value: a['id'] as int,
                  child: Text('${a['currency']?['code'] ?? ''} — ${fmt(a['balance'])} ${a['currency']?['symbol'] ?? ''}', style: const TextStyle(color: AppTheme.textPrimary)))).toList(),
                onChanged: (v) => setState(() => selectedAccount = accounts.firstWhere((a) => a['id'] == v)))),
            const SizedBox(height: 16),
            _label('المبلغ'), _field(_amount, '0.00', Icons.attach_money_rounded, const TextInputType.numberWithOptions(decimal: true), dir: TextDirection.ltr),
            const SizedBox(height: 20),
            _label('طريقة الدفع'),
            Row(children: [_methodBtn('card', 'بطاقة', Icons.credit_card_rounded), const SizedBox(width: 10), _methodBtn('apple_pay', 'Apple Pay', Icons.apple_rounded), const SizedBox(width: 10), _methodBtn('google_pay', 'Google', Icons.g_mobiledata_rounded)]),
            const SizedBox(height: 16),
            if (paymentMethod == 'card') ...[
              _label('رقم البطاقة'), _field(_cardNumber, '4532 •••• •••• ••••', Icons.credit_card_rounded, TextInputType.number, dir: TextDirection.ltr),
              const SizedBox(height: 12),
              _label('اسم حامل البطاقة'), _field(_cardHolder, 'الاسم على البطاقة', Icons.person_outline_rounded, TextInputType.name, dir: TextDirection.ltr),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('تاريخ الانتهاء'), _field(_cardExpiry, 'MM/YY', Icons.calendar_today_rounded, TextInputType.datetime, dir: TextDirection.ltr)])),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_label('CVV'), _field(_cardCvv, '•••', Icons.lock_outline_rounded, TextInputType.number, dir: TextDirection.ltr)])),
              ]),
              const SizedBox(height: 8),
            ],
            if (paymentMethod != 'card') Container(padding: const EdgeInsets.all(20), margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Icon(paymentMethod == 'apple_pay' ? Icons.apple_rounded : Icons.g_mobiledata_rounded, size: 40, color: AppTheme.textMuted),
                const SizedBox(height: 10),
                Text('اضغط إيداع لاستخدام ${paymentMethod == 'apple_pay' ? 'Apple Pay' : 'Google Pay'}', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              ])),
            if (error != null) _msg(error!, AppTheme.danger),
            if (success != null) _msg(success!, AppTheme.success),
            const SizedBox(height: 16),
            Container(height: 56, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)]),
              boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))]),
            child: ElevatedButton(onPressed: loading ? null : _submit, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_rounded, size: 20), SizedBox(width: 8), Text('إيداع الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]))),
            const SizedBox(height: 30),
          ])),
    );
  }

  Widget _methodBtn(String value, String label, IconData icon) {
    final active = paymentMethod == value;
    return Expanded(child: GestureDetector(onTap: () => setState(() => paymentMethod = value),
      child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: active ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bgCard, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? AppTheme.primary.withValues(alpha: 0.3) : AppTheme.border)),
        child: Column(children: [
          Icon(icon, size: 22, color: active ? AppTheme.primary : AppTheme.textMuted),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? AppTheme.primary : AppTheme.textSecondary)),
        ]))));
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)));
  BoxDecoration _boxDeco() => BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border));
  Widget _field(TextEditingController c, String hint, IconData icon, TextInputType type, {TextDirection dir = TextDirection.rtl}) => Container(decoration: _boxDeco(),
    child: TextField(controller: c, keyboardType: type, textDirection: dir, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
      decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: AppTheme.textMuted), prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 16))));
  Widget _msg(String t, Color c) => Container(padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(color: c.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withValues(alpha: 0.15))),
    child: Text(t, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600)));
}
