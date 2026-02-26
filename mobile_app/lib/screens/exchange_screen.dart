import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});
  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> with SingleTickerProviderStateMixin {
  List accounts = [];
  Map<String, dynamic>? fromAccount, toAccount;
  final _amount = TextEditingController();
  bool loading = false, loadingAccounts = true;
  String? error, success;

  // Live rate
  double liveRate = 0;
  double prevRate = 0;
  bool rateLoading = true;
  DateTime? rateUpdatedAt;
  Timer? _rateTimer;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _amount.addListener(() => setState(() {}));
    _loadAccounts();
  }

  @override
  void dispose() {
    _rateTimer?.cancel();
    _pulseCtrl.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    final r = await ApiService.getAccounts();
    if (r['success'] == true) {
      final d = r['data'];
      setState(() {
        accounts = d is List ? d : d?['accounts'] ?? [];
        if (accounts.length >= 2) { fromAccount = accounts[0]; toAccount = accounts[1]; }
        else if (accounts.isNotEmpty) { fromAccount = accounts[0]; }
      });
    }
    setState(() => loadingAccounts = false);
    _startRatePolling();
  }

  void _startRatePolling() {
    _rateTimer?.cancel();
    _fetchRate();
    _rateTimer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchRate());
  }

  Future<void> _fetchRate() async {
    if (fromAccount == null || toAccount == null) return;
    final from = fromAccount!['currency']?['code'] ?? 'EUR';
    final to = toAccount!['currency']?['code'] ?? 'USD';
    if (from == to) { setState(() { liveRate = 1.0; rateLoading = false; rateUpdatedAt = DateTime.now(); }); return; }

    final r = await ApiService.getLiveRate(from, to);
    if (r['success'] == true && mounted) {
      setState(() {
        prevRate = liveRate;
        liveRate = (r['rate'] as num).toDouble();
        rateLoading = false;
        rateUpdatedAt = DateTime.now();
      });
    }
  }

  String fmt(dynamic a) => NumberFormat('#,##0.00').format(double.tryParse('$a') ?? 0);
  String fmtRate(double r) => r.toStringAsFixed(4);

  double get inputAmount => double.tryParse(_amount.text) ?? 0;
  double get receiveAmount => inputAmount * liveRate;
  String get fromCode => fromAccount?['currency']?['code'] ?? 'EUR';
  String get toCode => toAccount?['currency']?['code'] ?? 'USD';
  String get fromSymbol => fromAccount?['currency']?['symbol'] ?? '€';
  String get toSymbol => toAccount?['currency']?['symbol'] ?? '\$';

  Future<void> _submit() async {
    if (fromAccount == null || toAccount == null || _amount.text.isEmpty) { setState(() => error = 'يرجى تحديد الحسابات والمبلغ'); return; }
    if (fromAccount!['id'] == toAccount!['id']) { setState(() => error = 'لا يمكن الصرف لنفس العملة'); return; }
    if (inputAmount <= 0) { setState(() => error = 'المبلغ غير صحيح'); return; }
    final balance = double.tryParse('${fromAccount!['balance']}') ?? 0;
    if (inputAmount > balance) { setState(() => error = 'الرصيد غير كافي'); return; }
    if (liveRate <= 0) { setState(() => error = 'سعر الصرف غير متاح'); return; }

    setState(() { loading = true; error = null; success = null; });
    final r = await ApiService.exchange({
      'from_account_id': fromAccount!['id'],
      'to_account_id': toAccount!['id'],
      'amount': inputAmount,
      'rate': liveRate,
    });
    setState(() => loading = false);
    if (r['success'] == true) {
      setState(() => success = 'تم الصرف بنجاح! ✅\n${fmt(inputAmount)} $fromCode → ${fmt(receiveAmount)} $toCode');
      _amount.clear();
      _loadAccounts();
    } else {
      setState(() => error = r['data']?['message'] ?? 'فشل الصرف');
    }
  }

  void _swap() {
    if (fromAccount != null && toAccount != null) {
      setState(() { final t = fromAccount; fromAccount = toAccount; toAccount = t; liveRate = 0; rateLoading = true; });
      _startRatePolling();
    }
  }

  void _onAccountChanged() {
    setState(() { liveRate = 0; rateLoading = true; });
    _startRatePolling();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صرف عملات', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: loadingAccounts
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

          // ═══════════════ LIVE RATE CARD ═══════════════
          _buildRateCard(),
          const SizedBox(height: 20),

          // ═══════════════ FROM ACCOUNT ═══════════════
          _accountBox('من', fromAccount, (v) { setState(() => fromAccount = accounts.firstWhere((a) => a['id'] == v)); _onAccountChanged(); }),
          const SizedBox(height: 8),

          // ═══════════════ SWAP BUTTON ═══════════════
          Center(child: GestureDetector(
            onTap: _swap,
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.2), width: 2),
                boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.swap_vert_rounded, color: Color(0xFFF59E0B), size: 24),
            ),
          )),
          const SizedBox(height: 8),

          // ═══════════════ TO ACCOUNT ═══════════════
          _accountBox('إلى', toAccount, (v) { setState(() => toAccount = accounts.firstWhere((a) => a['id'] == v)); _onAccountChanged(); }),
          const SizedBox(height: 24),

          // ═══════════════ AMOUNT INPUT ═══════════════
          Padding(padding: const EdgeInsets.only(bottom: 8), child: Text('المبلغ المراد صرفه', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary))),
          Container(
            decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppTheme.border)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8)),
                child: Text(fromCode, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.primary)),
              ),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _amount,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textDirection: TextDirection.ltr,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.3), fontSize: 28, fontWeight: FontWeight.w800),
                  border: InputBorder.none,
                ),
              )),
              Text(fromSymbol, style: TextStyle(fontSize: 18, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 12),

          // ═══════════════ RECEIVE PREVIEW ═══════════════
          if (inputAmount > 0 && liveRate > 0) AnimatedOpacity(
            opacity: 1.0, duration: const Duration(milliseconds: 300),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.success.withValues(alpha: 0.15)),
              ),
              child: Column(children: [
                Text('ستحصل على', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(toSymbol, style: TextStyle(fontSize: 18, color: AppTheme.success.withValues(alpha: 0.5), fontWeight: FontWeight.w400)),
                  const SizedBox(width: 6),
                  Text(fmt(receiveAmount), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.success)),
                  const SizedBox(width: 8),
                  Text(toCode, style: TextStyle(fontSize: 14, color: AppTheme.success.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 4),
                Text('بسعر $fromCode 1 = ${fmtRate(liveRate)} $toCode', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ]),
            ),
          ),
          const SizedBox(height: 16),

          // ═══════════════ ERRORS/SUCCESS ═══════════════
          if (error != null) _msgBox(error!, AppTheme.danger, Icons.error_outline_rounded),
          if (success != null) _msgBox(success!, AppTheme.success, Icons.check_circle_outline_rounded),

          // ═══════════════ SUBMIT BUTTON ═══════════════
          Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)]),
              boxShadow: [BoxShadow(color: const Color(0xFFF59E0B).withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 8))],
            ),
            child: ElevatedButton(
              onPressed: loading || liveRate <= 0 ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              child: loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.currency_exchange_rounded, size: 22),
                    const SizedBox(width: 10),
                    const Text('صرف الآن', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    if (inputAmount > 0 && liveRate > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text('${fmt(receiveAmount)} $toCode', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ]),
            ),
          ),
          const SizedBox(height: 30),
        ])),
    );
  }

  // ═══════════════ LIVE RATE CARD ═══════════════
  Widget _buildRateCard() {
    final rateUp = liveRate > prevRate && prevRate > 0;
    final rateDown = liveRate < prevRate && prevRate > 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(children: [
        // Header
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.show_chart_rounded, color: Color(0xFFF59E0B), size: 20),
          ),
          const SizedBox(width: 10),
          const Text('سعر الصرف الحي', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const Spacer(),
          // Pulsing live indicator
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.success.withValues(alpha: 0.06 + (_pulseCtrl.value * 0.06)),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.success.withValues(alpha: 0.6 + (_pulseCtrl.value * 0.4)),
                    boxShadow: [BoxShadow(color: AppTheme.success.withValues(alpha: 0.3 * _pulseCtrl.value), blurRadius: 4)],
                  ),
                ),
                const SizedBox(width: 4),
                Text('LIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppTheme.success, letterSpacing: 1)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 14),

        // Rate display
        if (rateLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF59E0B))),
          )
        else
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('1 $fromCode', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded, size: 16, color: AppTheme.textMuted),
            const SizedBox(width: 8),
            Text(fmtRate(liveRate), style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w900,
              color: rateUp ? AppTheme.success : rateDown ? AppTheme.danger : AppTheme.textPrimary,
            )),
            const SizedBox(width: 6),
            Text(toCode, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            if (rateUp) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.arrow_drop_up_rounded, color: AppTheme.success, size: 28)),
            if (rateDown) const Padding(padding: EdgeInsets.only(right: 4), child: Icon(Icons.arrow_drop_down_rounded, color: AppTheme.danger, size: 28)),
          ]),
        const SizedBox(height: 10),

        // Last updated
        if (rateUpdatedAt != null) Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.access_time_rounded, size: 12, color: AppTheme.textMuted.withValues(alpha: 0.5)),
          const SizedBox(width: 4),
          Text('آخر تحديث: ${DateFormat('HH:mm:ss').format(rateUpdatedAt!)}', style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
          const SizedBox(width: 8),
          Text('ECB', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.primary.withValues(alpha: 0.4))),
        ]),
      ]),
    );
  }

  // ═══════════════ ACCOUNT BOX ═══════════════
  Widget _accountBox(String label, Map<String, dynamic>? account, ValueChanged<int?> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
        const SizedBox(height: 8),
        DropdownButton<int>(
          isExpanded: true, underline: const SizedBox(), dropdownColor: AppTheme.bgCard,
          value: account?['id'],
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          items: accounts.map<DropdownMenuItem<int>>((a) => DropdownMenuItem(
            value: a['id'] as int,
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(shape: BoxShape.circle, color: AppTheme.primary.withValues(alpha: 0.06)),
                child: Center(child: Text(a['currency']?['symbol'] ?? '?', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.primary))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${a['currency']?['code'] ?? ''}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                Text('الرصيد: ${fmt(a['balance'])}', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
              ])),
            ]),
          )).toList(),
          onChanged: onChanged,
        ),
      ]),
    );
  }

  // ═══════════════ MESSAGE BOX ═══════════════
  Widget _msgBox(String text, Color c, IconData icon) => Container(
    padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: c.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: c.withValues(alpha: 0.15)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: c, size: 20),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: TextStyle(color: c, fontSize: 13, fontWeight: FontWeight.w600))),
    ]),
  );
}
