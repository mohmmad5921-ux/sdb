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
  bool loadingAccounts = true;

  // Transfer state
  String step = 'lookup'; // lookup → confirm → done
  String method = 'account'; // account | phone | business
  final _value = TextEditingController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  Map<String, dynamic>? recipient;
  bool loading = false;
  String? error, success;
  String? newBalance;

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

  Future<void> _lookupRecipient() async {
    setState(() { loading = true; error = null; recipient = null; });
    try {
      final r = await ApiService.post('/banking/transfer/lookup', {
        'type': method, 'value': _value.text.trim(),
      });
      if (r['success'] == true && r['data']?['found'] == true) {
        setState(() { recipient = r['data']['recipient']; step = 'confirm'; });
      } else {
        setState(() => error = r['data']?['message'] ?? 'المستلم غير موجود');
      }
    } catch (e) {
      setState(() => error = 'خطأ في الاتصال');
    }
    setState(() => loading = false);
  }

  Future<void> _executeTransfer() async {
    final amount = double.tryParse(_amount.text) ?? 0;
    if (amount <= 0) { setState(() => error = 'المبلغ غير صحيح'); return; }
    setState(() { loading = true; error = null; });
    try {
      final r = await ApiService.post('/banking/transfer/execute', {
        'from_account_id': selectedAccount!['id'],
        'to_account_id': recipient!['account_id'],
        'amount': amount,
        'note': _note.text,
      });
      if (r['success'] == true && r['data']?['success'] == true) {
        setState(() { step = 'done'; success = 'تم التحويل بنجاح!'; newBalance = '${r['data']?['new_balance']}'; });
      } else {
        setState(() => error = r['data']?['message'] ?? 'فشل التحويل');
      }
    } catch (e) {
      setState(() => error = 'خطأ في الاتصال');
    }
    setState(() => loading = false);
  }

  void _reset() {
    setState(() { step = 'lookup'; method = 'account'; _value.clear(); _amount.clear(); _note.clear(); recipient = null; error = null; success = null; newBalance = null; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(step == 'lookup' ? 'تحويل' : step == 'confirm' ? 'تأكيد التحويل' : 'تم!',
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary),
          onPressed: () { if (step == 'confirm') { setState(() => step = 'lookup'); } else { Navigator.pop(context); } }),
      ),
      body: loadingAccounts
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: _buildStep()),
    );
  }

  Widget _buildStep() {
    if (step == 'lookup') return _buildLookup();
    if (step == 'confirm') return _buildConfirm();
    return _buildDone();
  }

  // ===== STEP 1: LOOKUP =====
  Widget _buildLookup() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Method Selector
      Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(children: [
          _methodTab('🔢', 'رقم حساب', 'account', const Color(0xFF10b981)),
          const SizedBox(width: 8),
          _methodTab('📱', 'هاتف', 'phone', const Color(0xFF3B82F6)),
          const SizedBox(width: 8),
          _methodTab('🏪', 'تاجر', 'business', const Color(0xFF8B5CF6)),
        ]),
      ),

      // Input field
      _label(method == 'account' ? 'رقم الحساب (10 أرقام)' : method == 'phone' ? 'رقم الهاتف' : 'كود التاجر (4 أرقام)'),
      _field(_value,
        method == 'account' ? '30XXXXXXXX' : method == 'phone' ? '+963...' : '1234',
        method == 'account' ? Icons.tag_rounded : method == 'phone' ? Icons.phone_rounded : Icons.store_rounded,
        TextInputType.number, direction: TextDirection.ltr),
      const SizedBox(height: 20),

      if (error != null) _msg(error!, AppTheme.danger),

      _submitBtn(loading ? 'جاري البحث...' : '🔍 بحث عن المستلم',
        Icons.search_rounded, loading, _lookupRecipient,
        const [Color(0xFF10b981), Color(0xFF059669)]),
    ]);
  }

  Widget _methodTab(String emoji, String label, String m, Color c) {
    final active = method == m;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => method = m),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? c.withValues(alpha: 0.1) : AppTheme.bgSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: active ? c.withValues(alpha: 0.4) : AppTheme.border),
          ),
          child: Column(children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: active ? c : AppTheme.textMuted)),
          ]),
        ),
      ),
    );
  }

  // ===== STEP 2: CONFIRM =====
  Widget _buildConfirm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Recipient card
      Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [const Color(0xFF10b981).withValues(alpha: 0.08), const Color(0xFF059669).withValues(alpha: 0.04)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.2)),
        ),
        child: Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF10b981), Color(0xFF0d9488)]),
              borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: Text(recipient?['name']?.toString().substring(0, 1) ?? '?',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(recipient?['name'] ?? '', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 2),
            Text('${recipient?['account_number']} · ${recipient?['currency']}',
              style: TextStyle(fontSize: 12, color: AppTheme.textMuted, fontFamily: 'monospace')),
          ])),
          const Icon(Icons.check_circle_rounded, color: Color(0xFF10b981), size: 24),
        ]),
      ),

      // From account
      _label('من حساب'),
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), decoration: _boxDeco(),
        child: DropdownButton<int>(isExpanded: true, underline: const SizedBox(), dropdownColor: AppTheme.bgCard,
          value: selectedAccount?['id'], style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          items: accounts.map<DropdownMenuItem<int>>((a) => DropdownMenuItem(value: a['id'] as int,
            child: Text('${a['currency']?['code'] ?? ''} — ${fmt(a['balance'])} ${a['currency']?['symbol'] ?? ''}', style: const TextStyle(color: AppTheme.textPrimary)))).toList(),
          onChanged: (v) => setState(() => selectedAccount = accounts.firstWhere((a) => a['id'] == v)))),
      const SizedBox(height: 16),

      // Amount
      _label('المبلغ'),
      Container(
        decoration: _boxDeco(),
        child: TextField(controller: _amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textDirection: TextDirection.ltr, textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.w900),
          decoration: InputDecoration(hintText: '0.00', hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.3), fontSize: 28, fontWeight: FontWeight.w900),
            border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 20)))),
      const SizedBox(height: 16),

      // Note
      _label('ملاحظة (اختياري)'),
      _field(_note, 'تحويل...', Icons.note_alt_outlined, TextInputType.text),
      const SizedBox(height: 8),

      // Balance info
      if (selectedAccount != null) Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.04), borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Icon(Icons.account_balance_wallet_rounded, size: 16, color: AppTheme.primary.withValues(alpha: 0.5)),
          const SizedBox(width: 8),
          Text('الرصيد المتاح: ${fmt(selectedAccount!['balance'])} ${selectedAccount!['currency']?['symbol'] ?? ''}',
            style: TextStyle(fontSize: 12, color: AppTheme.primary.withValues(alpha: 0.6))),
        ])),
      const SizedBox(height: 16),

      if (error != null) _msg(error!, AppTheme.danger),

      _submitBtn(loading ? 'جاري التحويل...' : '✓ تأكيد التحويل',
        Icons.send_rounded, loading, _executeTransfer,
        const [Color(0xFF10b981), Color(0xFF059669)]),
    ]);
  }

  // ===== STEP 3: DONE =====
  Widget _buildDone() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 40),
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [const Color(0xFF10b981).withValues(alpha: 0.2), const Color(0xFF059669).withValues(alpha: 0.1)]),
        ),
        alignment: Alignment.center,
        child: const Text('🎉', style: TextStyle(fontSize: 50)),
      ),
      const SizedBox(height: 24),
      const Text('تم التحويل بنجاح!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
      const SizedBox(height: 4),
      Text('Transfer Successful', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          color: const Color(0xFF10b981).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF10b981).withValues(alpha: 0.2)),
        ),
        child: Column(children: [
          Text('${_amount.text} ${selectedAccount?['currency']?['symbol'] ?? '€'}',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF10b981))),
          const SizedBox(height: 6),
          Text('→ ${recipient?['name']}', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
        ]),
      ),
      const SizedBox(height: 16),
      if (newBalance != null) Text('رصيدك الجديد: $newBalance',
        style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
      const SizedBox(height: 30),
      Row(children: [
        Expanded(child: _submitBtn('تحويل جديد', Icons.replay_rounded, false, _reset,
          const [Color(0xFF1E5EFF), Color(0xFF3B82F6)])),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('العودة'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textPrimary,
            side: BorderSide(color: AppTheme.border),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        )),
      ]),
    ]);
  }

  // Helpers
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
