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
  // State
  String _view = 'home'; // home, send, exchange
  String _step = 'recipient'; // recipient, amount, confirm
  String _recipient = '';
  String _amount = '';
  String _currency = 'SYP';
  List<Map<String, dynamic>> _accounts = [];
  int _selectedAccountId = 0;
  bool _loading = true;
  bool _sending = false;

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

  Future<void> _doTransfer() async {
    if (_sending) return;
    setState(() => _sending = true);
    final r = await ApiService.post('/banking/transfer/execute', {
      'from_account_id': _selectedAccountId,
      'to_identifier': _recipient,
      'amount': double.parse(_amount),
      'description': 'Transfer to $_recipient',
    });
    setState(() => _sending = false);
    if (mounted) {
      if (r['success'] == true) {
        _showSuccess();
      } else {
        // Fallback to IBAN transfer
        final r2 = await ApiService.transfer({
          'from_account_id': _selectedAccountId,
          'to_iban': _recipient,
          'amount': double.parse(_amount),
          'description': 'Transfer',
        });
        if (r2['success'] == true) _showSuccess();
        else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r2['data']?['message'] ?? 'Error'), backgroundColor: AppTheme.danger));
      }
    }
  }

  void _showSuccess() {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 56, height: 56, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(28)),
          child: const Icon(Icons.check_rounded, size: 32, color: AppTheme.primary)),
        const SizedBox(height: 16),
        const Text('Transfer Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('$_sym$_amount sent to $_recipient', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
      ]),
      actions: [TextButton(onPressed: () { Navigator.pop(context); setState(() { _view = 'home'; _step = 'recipient'; _recipient = ''; _amount = ''; }); }, child: const Text('Done'))],
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
            // Recipient
            Container(
              height: 52,
              decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
              child: TextField(
                controller: schedCtrl,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '@يوزرنيم أو IBAN...',
                  hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: Icon(Icons.person_outline_rounded, size: 18, color: AppTheme.textMuted),
                  border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Amount
            Container(
              height: 52,
              decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
              child: TextField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '${t.amount}...',
                  hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.attach_money, size: 18, color: AppTheme.textMuted),
                  border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Date picker
            GestureDetector(
              onTap: () async {
                final date = await showDatePicker(
                  context: ctx, initialDate: DateTime.now().add(const Duration(days: 1)),
                  firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) setSheetState(() => selectedDate = date);
              },
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
                child: Row(children: [
                  const Icon(Icons.calendar_today_rounded, size: 18, color: AppTheme.textMuted),
                  const SizedBox(width: 10),
                  Text(
                    selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : 'اختر التاريخ...',
                    style: TextStyle(fontSize: 13, color: selectedDate != null ? AppTheme.textPrimary : AppTheme.textMuted),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            // Frequency
            Text(L10n.of(context).repetition, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
            const SizedBox(height: 8),
            Row(children: ['مرة واحدة', 'أسبوعي', 'شهري'].map((f) {
              final isActive = freq == f;
              return Expanded(child: GestureDetector(
                onTap: () => setSheetState(() => freq = f),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? AppTheme.primary : AppTheme.bgMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.white : AppTheme.textPrimary))),
                ),
              ));
            }).toList()),
            const Spacer(),
            // Schedule button
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(L10n.of(context).transferScheduled), backgroundColor: AppTheme.primary),
                );
              },
              child: Text(L10n.of(context).scheduleTransfer),
            )),
          ]),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(child: _view == 'send' ? _buildSend() : _view == 'exchange' ? _buildExchangeView() : _buildHome()),
    );
  }

  // HOME — Payments overview
  Widget _buildHome() {
    return SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t.navPayments, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 16),
      // Primary actions
      Row(children: [
        Expanded(child: _buildActionCard(t.sendMoney, t.sendViaPhone, Icons.send_rounded, true, () => setState(() { _view = 'send'; _step = 'recipient'; }))),
        const SizedBox(width: 10),
        Expanded(child: _buildActionCard(t.exchange, t.exchangeRate, Icons.swap_horiz_rounded, false, () => Navigator.pushNamed(context, '/exchange'))),
      ]),
      const SizedBox(height: 12),
      // Secondary
      Row(children: [
        _buildSmallAction(Icons.add_circle_outline, t.deposit, () => Navigator.pushNamed(context, '/deposit')),
        const SizedBox(width: 8),
        _buildSmallAction(Icons.qr_code_rounded, 'QR', () => Navigator.pushNamed(context, '/qr')),
        const SizedBox(width: 8),
        _buildSmallAction(Icons.schedule, t.scheduled, () => _showScheduledTransfers()),
      ]),
      const SizedBox(height: 24),
      // Live Rates
      Text(t.exchangeRate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      const SizedBox(height: 10),
      _buildRateRow('EUR / USD', '1.0842', '+0.12%'),
      _buildRateRow('EUR / GBP', '0.8571', '-0.08%'),
      _buildRateRow('USD / SYP', '14,500', '+0.04%'),
    ]));
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isPrimary ? AppTheme.primary : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: isPrimary ? null : Border.all(color: AppTheme.border),
          boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: isPrimary ? Colors.white.withValues(alpha: 0.2) : AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 16, color: isPrimary ? Colors.white : AppTheme.primary),
          ),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isPrimary ? Colors.white : AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, color: isPrimary ? Colors.white70 : AppTheme.textMuted)),
        ]),
      ),
    );
  }

  Widget _buildSmallAction(IconData icon, String label, VoidCallback onTap) {
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          Icon(icon, size: 18, color: AppTheme.primary),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
        ]),
      ),
    ));
  }

  Widget _buildRateRow(String pair, String rate, String change) {
    final isPositive = change.startsWith('+');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
      child: Row(children: [
        Text(pair, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        const Spacer(),
        Text(change, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isPositive ? AppTheme.primary : AppTheme.danger)),
        const SizedBox(width: 10),
        Text(rate, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]),
    );
  }

  // SEND — 3-step flow
  Widget _buildSend() {
    return Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _backButton(() => setState(() { if (_step == 'recipient') _view = 'home'; else if (_step == 'amount') _step = 'recipient'; else _step = 'amount'; })),
        const SizedBox(width: 12),
        const Text('إرسال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ]),
      const SizedBox(height: 16),
      Expanded(child: _step == 'recipient' ? _buildRecipientStep() : _step == 'amount' ? _buildAmountStep() : _buildConfirmStep()),
    ]));
  }

  Widget _backButton(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
      child: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppTheme.textSecondary),
    ));
  }

  Widget _buildRecipientStep() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
        child: TextField(
          onChanged: (v) => setState(() => _recipient = v),
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Name, @username, IBAN or phone...',
            hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            prefixIcon: Icon(Icons.search, size: 18, color: AppTheme.textMuted),
            border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Text('إرسال عبر', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 1)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: GestureDetector(
          onTap: () {
            // Focus on username search
            setState(() => _recipient = '@');
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('@يوزرنيم', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/contacts'),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('رقم هاتف', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/qr'),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.qr_code_rounded, size: 14, color: AppTheme.primary),
              const SizedBox(width: 4),
              Text('QR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primary)),
            ])),
          ),
        )),
      ]),
      const Spacer(),
      if (_recipient.isNotEmpty) SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: () => setState(() => _step = 'amount'),
        child: const Text('Continue'),
      )),
    ]);
  }

  Widget _buildAmountStep() {
    return Column(children: [
      // Recipient badge
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFE8F5F0), borderRadius: BorderRadius.circular(16)),
            child: Center(child: Text(_recipient.isNotEmpty ? _recipient[0].toUpperCase() : '?', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)))),
          const SizedBox(width: 10),
          Expanded(child: Text(_recipient, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          GestureDetector(onTap: () => setState(() => _step = 'recipient'), child: const Icon(Icons.close, size: 16, color: AppTheme.textMuted)),
        ]),
      ),
      const SizedBox(height: 24),
      // Amount
      Text(t.amount, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(_sym, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(width: 4),
        SizedBox(width: 140, child: TextField(
          onChanged: (v) => setState(() => _amount = v),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
          decoration: const InputDecoration(hintText: '0.00', border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none, hintStyle: TextStyle(color: AppTheme.textMuted)),
        )),
      ]),
      const SizedBox(height: 12),
      // Currency chips
      Row(mainAxisAlignment: MainAxisAlignment.center, children: ['EUR', 'USD', 'SYP'].map((c) => GestureDetector(
        onTap: () => setState(() => _currency = c),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: _currency == c ? AppTheme.primary : AppTheme.bgMuted, borderRadius: BorderRadius.circular(20)),
          child: Text(c, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _currency == c ? Colors.white : AppTheme.textMuted)),
        ),
      )).toList()),
      const SizedBox(height: 16),
      // Quick amounts
      Row(children: ['50', '100', '200', '500'].map((v) => Expanded(child: GestureDetector(
        onTap: () => setState(() => _amount = v),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('$_sym$v', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary))),
        ),
      ))).toList()),
      const Spacer(),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _amount.isNotEmpty && (double.tryParse(_amount) ?? 0) > 0 ? () => setState(() => _step = 'confirm') : null,
        child: Text(t.continueBtn),
      )),
    ]);
  }

  Widget _buildConfirmStep() {
    return Column(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(16)),
        child: Column(children: [
          const Text('إرسال', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          const SizedBox(height: 4),
          Text('$_sym${double.parse(_amount).toStringAsFixed(2)}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text('to $_recipient', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        ]),
      ),
      const SizedBox(height: 16),
      Container(
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
        child: Column(children: [
          _confirmRow(t.transferFee, t.free),
          Divider(height: 0.5, color: AppTheme.border),
          _confirmRow(t.exchangeRate, 'N/A'),
          Divider(height: 0.5, color: AppTheme.border),
          _confirmRow(t.arrives, t.instantly),
        ]),
      ),
      const Spacer(),
      SizedBox(width: double.infinity, child: ElevatedButton(
        onPressed: _sending ? null : _doTransfer,
        child: _sending ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(t.confirmSend),
      )),
    ]);
  }

  Widget _confirmRow(String label, String value) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
    ]));
  }

  Widget _buildExchangeView() {
    return const Center(child: Text('Exchange'));
  }
}
