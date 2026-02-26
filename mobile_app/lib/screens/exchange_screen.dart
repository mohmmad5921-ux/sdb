import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});
  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List accounts = [];
  Map<String, dynamic>? fromAccount, toAccount;
  final _amount = TextEditingController();
  bool loading = false, loadingAccounts = true;
  String? error, success;

  @override
  void initState() { super.initState(); _loadAccounts(); }

  Future<void> _loadAccounts() async {
    final r = await ApiService.getAccounts();
    if (r['success'] == true) {
      final d = r['data'];
      setState(() { accounts = d is List ? d : d?['accounts'] ?? []; if (accounts.length >= 2) { fromAccount = accounts[0]; toAccount = accounts[1]; } else if (accounts.isNotEmpty) { fromAccount = accounts[0]; } });
    }
    setState(() => loadingAccounts = false);
  }

  String fmt(dynamic a) => NumberFormat('#,##0.00').format(double.tryParse('$a') ?? 0);

  Future<void> _submit() async {
    if (fromAccount == null || toAccount == null || _amount.text.isEmpty) { setState(() => error = 'يرجى تحديد الحسابات والمبلغ'); return; }
    if (fromAccount!['id'] == toAccount!['id']) { setState(() => error = 'لا يمكن الصرف لنفس العملة'); return; }
    final amount = double.tryParse(_amount.text) ?? 0;
    if (amount <= 0) { setState(() => error = 'المبلغ غير صحيح'); return; }
    final balance = double.tryParse('${fromAccount!['balance']}') ?? 0;
    if (amount > balance) { setState(() => error = 'الرصيد غير كافي'); return; }
    setState(() { loading = true; error = null; success = null; });
    final r = await ApiService.exchange({'from_account_id': fromAccount!['id'], 'to_account_id': toAccount!['id'], 'amount': amount});
    setState(() => loading = false);
    if (r['success'] == true) { setState(() => success = 'تم الصرف بنجاح! ✅'); _amount.clear(); _loadAccounts(); }
    else { setState(() => error = r['data']?['message'] ?? 'فشل الصرف'); }
  }

  void _swap() { if (fromAccount != null && toAccount != null) setState(() { final t = fromAccount; fromAccount = toAccount; toAccount = t; }); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صرف عملات', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: loadingAccounts ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _accountBox('من', fromAccount, (v) => setState(() => fromAccount = accounts.firstWhere((a) => a['id'] == v))),
            const SizedBox(height: 8),
            Center(child: GestureDetector(onTap: _swap,
              child: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFF59E0B).withValues(alpha: 0.08), border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2))),
                child: const Icon(Icons.swap_vert_rounded, color: Color(0xFFF59E0B), size: 22)))),
            const SizedBox(height: 8),
            _accountBox('إلى', toAccount, (v) => setState(() => toAccount = accounts.firstWhere((a) => a['id'] == v))),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('المبلغ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
            Container(
              decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
              child: TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), textDirection: TextDirection.ltr,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w700), textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: '0.00', hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.4), fontSize: 24, fontWeight: FontWeight.w700),
                  border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  suffixText: fromAccount?['currency']?['code'] ?? '', suffixStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14)))),
            const SizedBox(height: 16),
            if (error != null) Container(padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14)),
              child: Text(error!, style: TextStyle(color: AppTheme.danger, fontSize: 13, fontWeight: FontWeight.w600))),
            if (success != null) Container(padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14)),
              child: Text(success!, style: TextStyle(color: AppTheme.success, fontSize: 13, fontWeight: FontWeight.w600))),
            Container(height: 56,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
                boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))]),
              child: ElevatedButton(onPressed: loading ? null : _submit,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: loading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black))
                  : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.currency_exchange_rounded, size: 20), SizedBox(width: 8), Text('صرف الآن', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]))),
          ])),
    );
  }

  Widget _accountBox(String label, Map<String, dynamic>? account, ValueChanged<int?> onChanged) {
    return Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 8),
        DropdownButton<int>(isExpanded: true, underline: const SizedBox(), dropdownColor: AppTheme.bgCard,
          value: account?['id'], style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          items: accounts.map<DropdownMenuItem<int>>((a) => DropdownMenuItem(value: a['id'] as int,
            child: Row(children: [
              Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primary.withValues(alpha: 0.08)),
                child: Center(child: Text(a['currency']?['symbol'] ?? '?', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.primary)))),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${a['currency']?['code'] ?? ''}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text(fmt(a['balance']), style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ])),
            ]))).toList(),
          onChanged: onChanged),
      ]));
  }
}
