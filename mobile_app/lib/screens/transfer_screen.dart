import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class TransferScreen extends StatefulWidget {
  final bool embedded;
  const TransferScreen({super.key, this.embedded = false});
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  String _view = 'home';
  String _step = 'recipient';
  String _recipient = '';
  String _amount = '';
  String _currency = 'SYP';
  List<Map<String, dynamic>> _accounts = [];
  int _selectedAccountId = 0;
  bool _loading = true;
  bool _sending = false;

  // Recipient lookup result
  Map<String, dynamic>? _recipientInfo;
  bool _lookingUp = false;
  String? _lookupError;

  AppStrings get t => L10n.of(context);

  @override
  void initState() { super.initState(); _loadAccounts(); }

  Future<void> _loadAccounts() async {
    final r = await ApiService.getAccounts();
    if (r['success'] == true) {
      final list = List<Map<String, dynamic>>.from(r['data']?['accounts'] ?? []);
      setState(() { _accounts = list; _loading = false; if (list.isNotEmpty) _selectedAccountId = list[0]['id']; });
    } else { setState(() => _loading = false); }
  }

  String _detectLookupType(String input) {
    final trimmed = input.trim();
    if (trimmed.startsWith('+') || RegExp(r'^\d{6,}$').hasMatch(trimmed)) return 'phone';
    return 'account';
  }

  Future<void> _lookupRecipient() async {
    setState(() { _lookingUp = true; _lookupError = null; _recipientInfo = null; });

    final input = _recipient.trim();
    final type = _detectLookupType(input);
    final value = input.startsWith('@') ? input.substring(1) : input;

    final r = await ApiService.post('/banking/transfer/lookup', {
      'type': type,
      'value': value,
    });

    if (r['success'] == true && r['data']?['found'] == true) {
      setState(() { _recipientInfo = Map<String, dynamic>.from(r['data']['recipient']); _lookingUp = false; _step = 'confirm'; });
      return;
    }

    // Try phone with common prefixes
    if (type == 'phone') {
      for (final prefix in ['+45', '+963', '+964', '+49', '+90']) {
        if (!input.startsWith(prefix)) {
          final r2 = await ApiService.post('/banking/transfer/lookup', { 'type': 'phone', 'value': '$prefix$input' });
          if (r2['success'] == true && r2['data']?['found'] == true) {
            setState(() { _recipientInfo = Map<String, dynamic>.from(r2['data']['recipient']); _lookingUp = false; _step = 'confirm'; });
            return;
          }
        }
      }
    }

    setState(() { _lookingUp = false; _lookupError = 'المستلم غير موجود. تأكد من الرقم أو اسم المستخدم.'; });
  }

  Future<void> _doTransfer() async {
    if (_sending || _recipientInfo == null) return;
    setState(() => _sending = true);

    final r = await ApiService.post('/banking/transfer/execute', {
      'from_account_id': _selectedAccountId,
      'to_account_id': _recipientInfo!['account_id'],
      'amount': double.parse(_amount),
      'note': 'تحويل إلى ${_recipientInfo!['name'] ?? _recipient}',
    });

    setState(() => _sending = false);
    if (mounted) {
      if (r['success'] == true) {
        _showSuccess(r['data']);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(r['data']?['message'] ?? 'فشل التحويل'),
          backgroundColor: AppTheme.danger,
        ));
      }
    }
  }

  void _showSuccess([Map<String, dynamic>? data]) {
    final receipt = data?['receipt'];
    showDialog(context: context, barrierDismissible: false, builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 72, height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
            borderRadius: BorderRadius.circular(36)),
          child: const Icon(Icons.check_rounded, size: 40, color: Colors.white)),
        const SizedBox(height: 16),
        const Text('تم التحويل بنجاح! ✨', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        Text('$_sym${double.parse(_amount).toStringAsFixed(2)} → ${_recipientInfo?['name'] ?? _recipient}',
          style: const TextStyle(fontSize: 14, color: AppTheme.textMuted), textAlign: TextAlign.center),
        if (receipt?['reference'] != null) ...[
          const SizedBox(height: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(8)),
            child: Text('Ref: ${receipt['reference']}', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontFamily: 'monospace'))),
        ],
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: () { Navigator.pop(context); setState(() { _view = 'home'; _step = 'recipient'; _recipient = ''; _amount = ''; _recipientInfo = null; }); },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(vertical: 14)),
          child: const Text('تم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)))),
      ])),
    ));
  }

  String get _sym => {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[_currency] ?? _currency;

  void _showScheduledTransfers() {
    final schedCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    String freq = 'أسبوعي';
    DateTime? selectedDate;
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) {
      return StatefulBuilder(builder: (ctx, setSheetState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100)))),
            const SizedBox(height: 16),
            Text(t.scheduled, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(L10n.of(context).scheduleAutoTransfer, style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            const SizedBox(height: 20),
            Container(height: 52, decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
              child: TextField(controller: schedCtrl, style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(hintText: '@يوزرنيم أو IBAN...', hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.textMuted), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 16)))),
            const SizedBox(height: 12),
            Container(height: 52, decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
              child: TextField(controller: amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(hintText: '${t.amount}...', hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.attach_money, size: 18, color: AppTheme.textMuted), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 16)))),
            const SizedBox(height: 12),
            GestureDetector(onTap: () async {
              final date = await showDatePicker(context: ctx, initialDate: DateTime.now().add(const Duration(days: 1)),
                firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
              if (date != null) setSheetState(() => selectedDate = date);
            }, child: Container(height: 52, padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
              child: Row(children: [
                const Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.textMuted), const SizedBox(width: 10),
                Text(selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : 'اختر التاريخ...',
                  style: TextStyle(fontSize: 13, color: selectedDate != null ? AppTheme.textPrimary : AppTheme.textMuted)),
              ]))),
            const SizedBox(height: 12),
            Text(L10n.of(context).repetition, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
            const SizedBox(height: 8),
            Row(children: ['مرة واحدة', 'أسبوعي', 'شهري'].map((f) {
              final isActive = freq == f;
              return Expanded(child: GestureDetector(onTap: () => setSheetState(() => freq = f),
                child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: isActive ? AppTheme.primary : AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppTheme.textPrimary))))));
            }).toList()),
            const Spacer(),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.of(context).transferScheduled), backgroundColor: AppTheme.primary)); },
              child: Text(L10n.of(context).scheduleTransfer))),
          ]),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
    return Scaffold(backgroundColor: AppTheme.bgLight,
      body: SafeArea(child: _view == 'send' ? _buildSend() : _view == 'exchange' ? _buildExchangeView() : _buildHome()));
  }

  Widget _buildHome() {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t.navPayments, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: _buildActionCard(t.sendMoney, t.sendViaPhone, Icons.send_rounded, true, () => setState(() { _view = 'send'; _step = 'recipient'; }))),
        const SizedBox(width: 10),
        Expanded(child: _buildActionCard(t.exchange, t.exchangeRate, Icons.swap_horiz_rounded, false, () => Navigator.pushNamed(context, '/exchange'))),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        _buildSmallAction(Icons.add_circle_outline, t.deposit, () => Navigator.pushNamed(context, '/deposit')),
        const SizedBox(width: 8),
        _buildSmallAction(Icons.qr_code_rounded, 'QR', () => Navigator.pushNamed(context, '/qr')),
        const SizedBox(width: 8),
        _buildSmallAction(Icons.schedule, t.scheduled, () => _showScheduledTransfers()),
      ]),
      const SizedBox(height: 24),
      Text(t.exchangeRate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      const SizedBox(height: 10),
      _buildRateRow('EUR / USD', '1.0842', '+0.12%'),
      _buildRateRow('EUR / GBP', '0.8571', '-0.08%'),
      _buildRateRow('USD / SYP', '14,500', '+0.04%'),
    ]));
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: isPrimary ? AppTheme.primary : AppTheme.bgCard, borderRadius: BorderRadius.circular(16),
        border: isPrimary ? null : Border.all(color: AppTheme.border),
        boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : null),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 32, height: 32,
          decoration: BoxDecoration(color: isPrimary ? Colors.white.withValues(alpha: 0.2) : AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: isPrimary ? Colors.white : AppTheme.primary)),
        const SizedBox(height: 12),
        Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isPrimary ? Colors.white : AppTheme.textPrimary)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 11, color: isPrimary ? Colors.white70 : AppTheme.textMuted)),
      ])));
  }

  Widget _buildSmallAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(child: GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Column(children: [Icon(icon, size: 18, color: AppTheme.primary), const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))]))));
  }

  Widget _buildRateRow(String pair, String rate, String change) {
    final isPositive = change.startsWith('+');
    return Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Row(children: [
        Text(pair, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const Spacer(),
        Text(change, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isPositive ? AppTheme.primary : AppTheme.danger)),
        const SizedBox(width: 10),
        Text(rate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]));
  }

  Widget _buildSend() {
    return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backButton(() => setState(() {
          if (_step == 'recipient') { _view = 'home'; }
          else if (_step == 'amount') { _step = 'recipient'; _recipientInfo = null; _lookupError = null; }
          else { _step = 'amount'; }
        })),
        const SizedBox(width: 12),
        const Text('إرسال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]),
      const SizedBox(height: 16),
      Expanded(child: _step == 'recipient' ? _buildRecipientStep() : _step == 'amount' ? _buildAmountStep() : _buildConfirmStep()),
    ]));
  }

  Widget _backButton(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(width: 36, height: 36,
      decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
      child: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppTheme.textSecondary)));
  }

  Widget _buildRecipientStep() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: TextField(onChanged: (v) => setState(() { _recipient = v; _lookupError = null; }),
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(hintText: 'رقم هاتف، @يوزرنيم، أو رقم حساب...',
            hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            prefixIcon: Icon(Icons.search, size: 18, color: AppTheme.textMuted),
            border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none))),
      if (_lookupError != null) ...[
        const SizedBox(height: 10),
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(_lookupError!, style: TextStyle(fontSize: 13, color: AppTheme.danger))),
          ])),
      ],
      const SizedBox(height: 16),
      const Text('إرسال عبر', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 1)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: GestureDetector(onTap: () => setState(() => _recipient = '@'),
          child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('@يوزرنيم', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)))))),
        Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/contacts'),
          child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('رقم هاتف', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)))))),
        Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, '/qr'),
          child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.qr_code_rounded, size: 14, color: AppTheme.primary), const SizedBox(width: 4),
              Text('QR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary))]))))),
      ]),
      const Spacer(),
      if (_recipient.isNotEmpty) SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () => setState(() => _step = 'amount'),
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14)),
        child: const Text('متابعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)))),
    ]);
  }

  Widget _buildAmountStep() {
    final selectedAcc = _accounts.firstWhere((a) => a['id'] == _selectedAccountId, orElse: () => _accounts.isNotEmpty ? _accounts[0] : {});
    final accCurrency = selectedAcc['currency']?['code'] ?? 'EUR';

    return Column(children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
            borderRadius: BorderRadius.circular(18)),
            child: Center(child: Text(_recipient.isNotEmpty ? _recipient[0].toUpperCase() : '?',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)))),
          const SizedBox(width: 10),
          Expanded(child: Text(_recipient, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          GestureDetector(onTap: () => setState(() => _step = 'recipient'), child: const Icon(Icons.close, size: 16, color: AppTheme.textMuted)),
        ])),
      const SizedBox(height: 8),
      if (_accounts.length > 1)
        GestureDetector(onTap: _showAccountSelector,
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Row(children: [
              const Icon(Icons.account_balance_wallet_rounded, size: 18, color: AppTheme.primary), const SizedBox(width: 8),
              Text('$accCurrency — ${selectedAcc['balance'] ?? '0.00'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const Spacer(), const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppTheme.textMuted),
            ]))),
      const SizedBox(height: 16),
      Text(t.amount, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_sym, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(width: 4),
        SizedBox(width: 140, child: TextField(onChanged: (v) => setState(() => _amount = v),
          keyboardType: const TextInputType.numberWithOptions(decimal: true), textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
          decoration: const InputDecoration(hintText: '0.00', border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, hintStyle: TextStyle(color: AppTheme.textMuted)))),
      ]),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: _accounts.map((a) {
        final c = a['currency']?['code'] ?? 'EUR';
        return GestureDetector(onTap: () => setState(() { _currency = c; _selectedAccountId = a['id']; }),
          child: Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: _selectedAccountId == a['id'] ? AppTheme.primary : AppTheme.bgMuted, borderRadius: BorderRadius.circular(20)),
            child: Text(c, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _selectedAccountId == a['id'] ? Colors.white : AppTheme.textMuted))));
      }).toList()),
      const SizedBox(height: 16),
      Row(children: ['50', '100', '200', '500'].map((v) => Expanded(child: GestureDetector(
        onTap: () => setState(() => _amount = v),
        child: Container(margin: const EdgeInsets.symmetric(horizontal: 3), padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('$_sym$v', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))))))).toList()),
      if (_lookupError != null) ...[
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18), const SizedBox(width: 8),
            Expanded(child: Text(_lookupError!, style: TextStyle(fontSize: 13, color: AppTheme.danger))),
          ])),
      ],
      const Spacer(),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _amount.isNotEmpty && (double.tryParse(_amount) ?? 0) > 0 ? () => _lookupRecipient() : null,
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, disabledBackgroundColor: AppTheme.bgMuted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
        child: _lookingUp
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Text(t.continueBtn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)))),
    ]);
  }

  void _showAccountSelector() {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,
      builder: (_) => Container(padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('اختر الحساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ..._accounts.map((a) => ListTile(
            leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(a['currency']?['symbol'] ?? '€', style: const TextStyle(fontSize: 18)))),
            title: Text('${a['currency']?['code'] ?? 'EUR'}', style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('الرصيد: ${a['balance'] ?? '0.00'}', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            trailing: _selectedAccountId == a['id'] ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
            onTap: () { setState(() { _selectedAccountId = a['id']; _currency = a['currency']?['code'] ?? 'EUR'; }); Navigator.pop(context); },
          )),
          const SizedBox(height: 16),
        ])));
  }

  Widget _buildConfirmStep() {
    final amount = double.tryParse(_amount) ?? 0;
    final selectedAcc = _accounts.firstWhere((a) => a['id'] == _selectedAccountId, orElse: () => _accounts.isNotEmpty ? _accounts[0] : {});
    final accCurrency = selectedAcc['currency']?['code'] ?? 'EUR';
    final recipientName = _recipientInfo?['name'] ?? _recipient;
    final recipientAccount = _recipientInfo?['account_number'] ?? '';

    return SingleChildScrollView(child: Column(children: [
      // Amount hero card
      Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF10B981), Color(0xFF059669)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8))]),
        child: Column(children: [
          const Text('إرسال', style: TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 6),
          Text('$_sym${amount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text(accCurrency, style: const TextStyle(fontSize: 14, color: Colors.white60)),
        ])),
      const SizedBox(height: 16),

      // From/To card
      Container(decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.arrow_upward_rounded, color: AppTheme.primary, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('من', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              Text('$accCurrency — ${selectedAcc['balance'] ?? '0.00'}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            ])),
          ])),
          Container(height: 0.5, color: AppTheme.border),
          Padding(padding: const EdgeInsets.all(14), child: Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFEDE9FE), borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text(recipientName.isNotEmpty ? recipientName[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF7C3AED))))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('إلى', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              Text(recipientName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              if (recipientAccount.isNotEmpty) Text(recipientAccount, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            ])),
          ])),
        ])),
      const SizedBox(height: 12),

      // Details
      Container(decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          _confirmRow('المبلغ', '${amount.toStringAsFixed(2)} $accCurrency'),
          Divider(height: 0.5, color: AppTheme.border),
          _confirmRow(t.transferFee, t.free),
          Divider(height: 0.5, color: AppTheme.border),
          _confirmRow('المجموع', '${amount.toStringAsFixed(2)} $accCurrency', bold: true),
          Divider(height: 0.5, color: AppTheme.border),
          _confirmRow(t.arrives, t.instantly),
        ])),
      const SizedBox(height: 16),

      // Security badge
      Container(padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.shield_rounded, color: Color(0xFF10B981), size: 18), const SizedBox(width: 8),
          const Expanded(child: Text('تحويل مشفّر وآمن بين حسابات SDB', style: TextStyle(fontSize: 12, color: Color(0xFF166534), fontWeight: FontWeight.w500))),
        ])),
      const SizedBox(height: 20),

      // Send button
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _sending ? null : _doTransfer,
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, disabledBackgroundColor: AppTheme.textMuted,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
        child: _sending
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.send_rounded, size: 18, color: Colors.white), const SizedBox(width: 8),
              Text(t.confirmSend, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ]))),
    ]));
  }

  Widget _confirmRow(String label, String value, {bool bold = false}) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
      Text(value, style: TextStyle(fontSize: bold ? 15 : 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w600, color: AppTheme.textPrimary)),
    ]));
  }

  Widget _buildExchangeView() => const Center(child: Text('Exchange'));
}
