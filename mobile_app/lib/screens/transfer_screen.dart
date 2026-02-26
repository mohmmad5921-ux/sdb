import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  List accounts = [];
  Map<String, dynamic>? selectedAccount;
  final _iban = TextEditingController();
  final _amount = TextEditingController();
  final _desc = TextEditingController();
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
    if (selectedAccount == null || _iban.text.isEmpty || _amount.text.isEmpty) { setState(() => error = 'يرجى ملء جميع الحقول'); return; }
    final amount = double.tryParse(_amount.text) ?? 0;
    if (amount <= 0) { setState(() => error = 'المبلغ غير صحيح'); return; }
    final balance = double.tryParse('${selectedAccount!['balance']}') ?? 0;
    if (amount > balance) { setState(() => error = 'الرصيد غير كافي'); return; }
    setState(() { loading = true; error = null; success = null; });
    final r = await ApiService.transfer({'from_account_id': selectedAccount!['id'], 'to_iban': _iban.text.trim(), 'amount': amount, 'description': _desc.text});
    setState(() => loading = false);
    if (r['success'] == true) { setState(() => success = 'تم التحويل بنجاح! ✅'); _amount.clear(); _iban.clear(); _desc.clear(); _loadAccounts(); }
    else { setState(() => error = r['data']?['message'] ?? 'فشل التحويل'); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحويل', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)), backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: loadingAccounts ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _label('من حساب'),
            Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: _boxDeco(),
              child: DropdownButton<int>(isExpanded: true, underline: const SizedBox(), dropdownColor: AppTheme.bgCard,
                value: selectedAccount?['id'], style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                items: accounts.map<DropdownMenuItem<int>>((a) => DropdownMenuItem(value: a['id'] as int,
                  child: Text('${a['currency']?['code'] ?? ''} — ${fmt(a['balance'])} ${a['currency']?['symbol'] ?? ''}', style: const TextStyle(color: AppTheme.textPrimary)))).toList(),
                onChanged: (v) => setState(() => selectedAccount = accounts.firstWhere((a) => a['id'] == v)))),
            const SizedBox(height: 16),
            _label('IBAN المستلم'), _field(_iban, 'أدخل رقم IBAN', Icons.account_balance_rounded, TextInputType.text, direction: TextDirection.ltr),
            const SizedBox(height: 16),
            _label('المبلغ'), _field(_amount, '0.00', Icons.attach_money_rounded, const TextInputType.numberWithOptions(decimal: true), direction: TextDirection.ltr),
            const SizedBox(height: 16),
            _label('الوصف (اختياري)'), _field(_desc, 'وصف التحويل...', Icons.description_outlined, TextInputType.text),
            const SizedBox(height: 8),
            if (selectedAccount != null) Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                Icon(Icons.info_outline_rounded, size: 16, color: AppTheme.primary.withValues(alpha: 0.5)),
                const SizedBox(width: 8),
                Text('الرصيد المتاح: ${fmt(selectedAccount!['balance'])} ${selectedAccount!['currency']?['symbol'] ?? ''}', style: TextStyle(fontSize: 12, color: AppTheme.primary.withValues(alpha: 0.6))),
              ])),
            const SizedBox(height: 16),
            if (error != null) _msg(error!, AppTheme.danger),
            if (success != null) _msg(success!, AppTheme.success),
            const SizedBox(height: 16),
            _submitBtn('تحويل الآن', Icons.arrow_upward_rounded, loading, _submit, const [Color(0xFF1E5EFF), Color(0xFF3B82F6)]),
          ])),
    );
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)));
  BoxDecoration _boxDeco() => BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border));
  Widget _field(TextEditingController c, String hint, IconData icon, TextInputType type, {TextDirection direction = TextDirection.rtl}) => Container(
    decoration: _boxDeco(),
    child: TextField(controller: c, keyboardType: type, textDirection: direction, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
      decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: AppTheme.textMuted), prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 16))));
  Widget _msg(String t, Color c) => Container(padding: const EdgeInsets.all(14), margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(color: c.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: c.withValues(alpha: 0.15))),
    child: Text(t, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600)));
  Widget _submitBtn(String label, IconData icon, bool busy, VoidCallback onTap, List<Color> colors) => Container(height: 56,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: colors),
      boxShadow: [BoxShadow(color: colors.first.withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 8))]),
    child: ElevatedButton(onPressed: busy ? null : onTap, style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      child: busy ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 20), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))])));
}
