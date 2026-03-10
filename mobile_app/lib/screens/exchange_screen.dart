import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({super.key});
  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  List<Map<String, dynamic>> _accounts = [];
  int _fromIdx = 0;
  int _toIdx = 1;
  String _amount = '100';
  double _rate = 0;
  bool _loading = true;
  bool _exchanging = false;
  bool _rateLoading = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final r = await ApiService.getAccounts();
    if (r['success'] == true) {
      final list = List<Map<String, dynamic>>.from(r['data']?['accounts'] ?? []);
      setState(() { _accounts = list; _loading = false; _toIdx = list.length > 1 ? 1 : 0; });
      _fetchRate();
    } else { setState(() => _loading = false); }
  }

  Future<void> _fetchRate() async {
    if (_accounts.length < 2) return;
    setState(() => _rateLoading = true);
    final from = _accounts[_fromIdx]['currency']?['code'] ?? 'EUR';
    final to = _accounts[_toIdx]['currency']?['code'] ?? 'USD';
    final r = await ApiService.getLiveRate(from, to);
    setState(() { _rate = (r['rate'] as num?)?.toDouble() ?? 0; _rateLoading = false; });
  }

  Future<void> _doExchange() async {
    if (_exchanging) return;
    setState(() => _exchanging = true);
    final r = await ApiService.exchange({
      'from_account_id': _accounts[_fromIdx]['id'],
      'to_account_id': _accounts[_toIdx]['id'],
      'amount': double.parse(_amount),
      'rate': _rate,
    });
    setState(() => _exchanging = false);
    if (mounted) {
      if (r['success'] == true) {
        showDialog(context: context, builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(28)),
              child: const Icon(Icons.check_rounded, size: 32, color: AppTheme.primary)),
            const SizedBox(height: 16),
            const Text('Exchange Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('${_sym(_fromIdx)}$_amount → ${_sym(_toIdx)}${_result()}', style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
          ]),
          actions: [TextButton(onPressed: () { Navigator.pop(context); if (Navigator.canPop(context)) Navigator.pop(context); }, child: const Text('Done'))],
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r['data']?['message'] ?? 'Error'), backgroundColor: AppTheme.danger));
      }
    }
  }

  void _swap() {
    setState(() { final t = _fromIdx; _fromIdx = _toIdx; _toIdx = t; });
    _fetchRate();
  }

  String _result() {
    final a = double.tryParse(_amount) ?? 0;
    return (a * _rate).toStringAsFixed(2);
  }

  String _sym(int idx) {
    final code = _accounts.length > idx ? (_accounts[idx]['currency']?['code'] ?? 'EUR') : 'EUR';
    return {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[code] ?? code;
  }

  String _code(int idx) => _accounts.length > idx ? (_accounts[idx]['currency']?['code'] ?? 'EUR') : 'EUR';
  String _flag(int idx) {
    final code = _code(idx);
    return {'EUR': '🇪🇺', 'USD': '🇺🇸', 'SYP': '🇸🇾', 'GBP': '🇬🇧', 'DKK': '🇩🇰'}[code] ?? '💰';
  }
  String _bal(int idx) {
    if (_accounts.length <= idx) return '0.00';
    final b = _accounts[idx]['balance'] ?? 0;
    return (b is num ? b.toDouble() : double.tryParse(b.toString()) ?? 0).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        // Header
        Row(children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
              child: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppTheme.textSecondary)),
          ),
          const SizedBox(width: 12),
          const Text('Exchange', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        ]),
        const SizedBox(height: 20),

        // You sell
        _buildCurrencyCard('You sell', _fromIdx, true),
        const SizedBox(height: 8),

        // Swap button
        GestureDetector(
          onTap: _swap,
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))]),
            child: const Icon(Icons.swap_vert_rounded, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(height: 8),

        // You get
        _buildCurrencyCard('You get', _toIdx, false),
        const SizedBox(height: 16),

        // Rate info
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Exchange rate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary)),
            _rateLoading
              ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: AppTheme.primary))
              : Text('1 ${_code(_fromIdx)} = ${_rate.toStringAsFixed(4)} ${_code(_toIdx)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          ]),
        ),
        const Spacer(),

        // Exchange button
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _rate > 0 && !_exchanging && _amount.isNotEmpty && (double.tryParse(_amount) ?? 0) > 0 ? _doExchange : null,
          child: _exchanging
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : const Text('Exchange Now'),
        )),
      ]))),
    );
  }

  Widget _buildCurrencyCard(String label, int idx, bool editable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        const SizedBox(height: 8),
        Row(children: [
          // Currency selector
          GestureDetector(
            onTap: () => _showCurrencyPicker(idx, editable),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Text(_flag(idx), style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(_code(idx), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 16, color: AppTheme.textMuted),
              ]),
            ),
          ),
          const Spacer(),
          if (editable)
            SizedBox(width: 120, child: TextField(
              controller: TextEditingController(text: _amount)..selection = TextSelection.fromPosition(TextPosition(offset: _amount.length)),
              onChanged: (v) { setState(() => _amount = v); _fetchRate(); },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
              decoration: const InputDecoration(border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
            ))
          else
            Text(_result(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.primary)),
        ]),
        const SizedBox(height: 4),
        Text('Balance: ${_sym(idx)}${_bal(idx)}', style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
      ]),
    );
  }

  void _showCurrencyPicker(int currentIdx, bool isFrom) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_) {
      return Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Select Currency', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...List.generate(_accounts.length, (i) => ListTile(
          leading: Text(_flag(i), style: const TextStyle(fontSize: 20)),
          title: Text(_code(i), style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('Balance: ${_sym(i)}${_bal(i)}'),
          trailing: i == currentIdx ? const Icon(Icons.check, color: AppTheme.primary) : null,
          onTap: () { setState(() { if (isFrom) _fromIdx = i; else _toIdx = i; }); Navigator.pop(context); _fetchRate(); },
        )),
      ]));
    });
  }
}
