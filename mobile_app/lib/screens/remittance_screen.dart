import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../services/biometric_service.dart';
import '../theme/app_theme.dart';
import '../widgets/syria_flag.dart';
import 'remittance_receipt_screen.dart';

class RemittanceScreen extends StatefulWidget {
  const RemittanceScreen({super.key});
  @override
  State<RemittanceScreen> createState() => _RemittanceScreenState();
}

class _RemittanceScreenState extends State<RemittanceScreen> {
  int _step = 0; // 0=governorate, 1=district, 2=agent, 3=recipient, 4=confirm
  bool _loading = true;
  bool _sending = false;
  List<dynamic> _governorates = [];
  Map<String, dynamic>? _selectedGov;
  Map<String, dynamic>? _selectedDistrict;
  Map<String, dynamic>? _selectedAgent;
  List<dynamic> _accounts = [];
  Map<String, dynamic>? _selectedAccount;

  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  String _receiveCurrency = 'SYP';
  Map<String, Map<String, dynamic>> _receiveCurrencies = {
    'SYP': {'name': 'ليرة سورية', 'flag': 'SY', 'rate': 13500.0},
    'USD': {'name': 'دولار أمريكي', 'flag': '🇺🇸', 'rate': 1.08},
    'TRY': {'name': 'ليرة تركية', 'flag': '🇹🇷', 'rate': 34.2},
  };
  double get _currentRate => (_receiveCurrencies[_receiveCurrency]?['rate'] as num?)?.toDouble() ?? 13500;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ApiService.getGovernorates(),
        ApiService.getDashboard(),
      ]);
      final govRes = results[0];
      final dashRes = results[1];

      if (govRes['success'] == true) {
        _governorates = govRes['data']['governorates'] ?? [];
      }
      if (dashRes['success'] == true && dashRes['data'] != null) {
        _accounts = dashRes['data']['accounts'] ?? [];
        if (_accounts.isNotEmpty) _selectedAccount = _accounts[0];
      }
      // Fetch live exchange rates
      try {
        final ratesRes = await http.get(Uri.parse('https://sdb-bank.com/api/public/rates'));
        if (ratesRes.statusCode == 200) {
          final ratesData = jsonDecode(ratesRes.body);
          final rates = ratesData['rates'];
          if (rates != null) {
            if (rates['SYP'] != null) _receiveCurrencies['SYP']!['rate'] = (rates['SYP'] as num).toDouble();
            if (rates['USD'] != null) _receiveCurrencies['USD']!['rate'] = (rates['USD'] as num).toDouble();
            if (rates['TRY'] != null) _receiveCurrencies['TRY']!['rate'] = (rates['TRY'] as num).toDouble();
          }
        }
      } catch (_) {}
    } catch (e) {
      debugPrint('Error loading remittance data: $e');
    }
    setState(() => _loading = false);
  }

  void _selectGovernorate(Map<String, dynamic> gov) {
    setState(() { _selectedGov = gov; _step = 1; });
  }

  void _selectDistrict(Map<String, dynamic> dist) {
    setState(() { _selectedDistrict = dist; _step = 2; });
  }

  void _selectAgent(Map<String, dynamic> agent) {
    setState(() { _selectedAgent = agent; _step = 3; });
  }

  void _goToConfirm() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty || _amountCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('يرجى ملء جميع الحقول المطلوبة'), backgroundColor: Colors.red.shade600),
      );
      return;
    }
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('يرجى اختيار الحساب المرسل'), backgroundColor: Colors.red.shade600),
      );
      return;
    }
    setState(() => _step = 4);
  }

  Future<void> _sendRemittance() async {
    // Face ID / Biometric verification (optional - proceed if not available)
    try {
      final canAuth = await BiometricService.isAvailable();
      if (canAuth) {
        final authenticated = await BiometricService.authenticate(
          reason: 'تحقق من هويتك لتأكيد الحوالة',
        );
        if (!authenticated) {
          _showError('تم إلغاء التحقق');
          return;
        }
      }
    } catch (e) {
      debugPrint('Biometric skipped: $e');
      // Continue without biometric if not available
    }

    setState(() => _sending = true);
    try {
      final res = await ApiService.sendRemittance({
        'agent_id': _selectedAgent!['id'],
        'account_id': _selectedAccount!['id'],
        'recipient_name': _nameCtrl.text,
        'recipient_phone': _phoneCtrl.text,
        'amount': double.parse(_amountCtrl.text),
        'receive_currency': _receiveCurrency,
        'notes': _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
      });

      if (res['success'] == true) {
        final remittance = res['data']['remittance'];
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (_) => RemittanceReceiptScreen(remittance: remittance),
          ));
        }
      } else {
        _showError(res['data']?['message'] ?? 'فشل إرسال الحوالة');
      }
    } catch (e) {
      _showError('خطأ في الاتصال: $e');
    }
    if (mounted) setState(() => _sending = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red.shade600,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  if (_step > 0) { setState(() => _step--); } else { Navigator.pop(context); }
                },
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.chevron_right_rounded, size: 22, color: AppTheme.textSecondary),
                ),
              ),
              const Spacer(),
              Text(_stepTitle(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const Spacer(),
              const SizedBox(width: 36),
            ]),
          ),
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(5, (i) => Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _step ? AppTheme.primary : AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),
          const SizedBox(height: 8),
          // ── Body ──
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : _buildStep(),
          ),
        ]),
      ),
    );
  }

  String _stepTitle() {
    switch (_step) {
      case 0: return 'اختر المحافظة';
      case 1: return _selectedGov?['name_ar'] ?? 'اختر المنطقة';
      case 2: return _selectedDistrict?['name_ar'] ?? 'اختر الوكيل';
      case 3: return 'بيانات المستلم';
      case 4: return 'تأكيد الحوالة';
      default: return 'حوالات سوريا';
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _buildGovernorateList();
      case 1: return _buildDistrictList();
      case 2: return _buildAgentList();
      case 3: return _buildRecipientForm();
      case 4: return _buildConfirmation();
      default: return const SizedBox();
    }
  }

  // ── Step 0: Select Governorate ──
  Widget _buildGovernorateList() {
    return Column(children: [
      // Header hint
      Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          const SyriaFlag(size: 18),
          const SizedBox(width: 8),
          Text('اختر المحافظة التي يتواجد فيها المستلم', style: TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.w600)),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _governorates.length,
          itemBuilder: (_, i) {
            final gov = _governorates[i];
            final distCount = (gov['districts'] as List?)?.length ?? 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('🏛️', style: TextStyle(fontSize: 20))),
                ),
                title: Text(gov['name_ar'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                subtitle: Text('${gov['name_en']} • $distCount مناطق', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                trailing: const Icon(Icons.chevron_left_rounded, color: AppTheme.textMuted, size: 22),
                onTap: () => _selectGovernorate(gov),
              ),
            );
          },
        ),
      ),
    ]);
  }

  // ── Step 1: Select District ──
  Widget _buildDistrictList() {
    final districts = (_selectedGov?['districts'] as List?) ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: districts.length,
      itemBuilder: (_, i) {
        final dist = districts[i];
        final agentCount = (dist['agents'] as List?)?.length ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text('📍', style: TextStyle(fontSize: 18))),
            ),
            title: Text(dist['name_ar'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            subtitle: Text('$agentCount وكلاء متاحين', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            trailing: const Icon(Icons.chevron_left_rounded, color: AppTheme.textMuted, size: 22),
            onTap: () => _selectDistrict(dist),
          ),
        );
      },
    );
  }

  // ── Step 2: Select Agent ──
  Widget _buildAgentList() {
    final agents = (_selectedDistrict?['agents'] as List?) ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agents.length,
      itemBuilder: (_, i) {
        final ag = agents[i];
        return GestureDetector(
          onTap: () => _selectAgent(ag),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('🏬', style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(ag['name_ar'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                  if (ag['phone'] != null)
                    Text(ag['phone'], style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ])),
                const Icon(Icons.chevron_left_rounded, color: AppTheme.textMuted, size: 22),
              ]),
              if (ag['address_ar'] != null) ...[
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Expanded(child: Text(ag['address_ar'], style: const TextStyle(fontSize: 12, color: AppTheme.textMuted))),
                ]),
              ],
            ]),
          ),
        );
      },
    );
  }

  // ── Step 3: Recipient Form ──
  Widget _buildRecipientForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Selected path
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withOpacity(0.15)),
          ),
          child: Row(children: [
            const Text('🏛️', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(child: Text(
              '${_selectedGov?['name_ar']} → ${_selectedDistrict?['name_ar']} → ${_selectedAgent?['name_ar']}',
              style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w600),
            )),
          ]),
        ),
        const SizedBox(height: 20),

        // Account selector
        const Text('الحساب المرسل', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showAccountPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('💳', style: TextStyle(fontSize: 16))),
              ),
              const SizedBox(width: 10),
              Expanded(child: _selectedAccount != null
                ? Text(
                    '${_selectedAccount!['currency']?['code'] ?? 'EUR'} — ${_selectedAccount!['balance'] ?? '0.00'}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  )
                : const Text('اختر الحساب', style: TextStyle(fontSize: 15, color: AppTheme.textMuted)),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
            ]),
          ),
        ),
        const SizedBox(height: 16),

        // Recipient name
        _buildField('اسم المستلم', _nameCtrl, Icons.person_outline_rounded),
        const SizedBox(height: 12),

        // Recipient phone
        _buildField('رقم هاتف المستلم', _phoneCtrl, Icons.phone_outlined, keyboard: TextInputType.phone),
        const SizedBox(height: 12),

        // Amount
        _buildField('المبلغ (${_selectedAccount?['currency']?['code'] ?? 'EUR'})', _amountCtrl, Icons.attach_money_rounded, keyboard: TextInputType.number),
        const SizedBox(height: 12),

        // Receive currency selector
        const Text('عملة الاستلام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showCurrencyPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(children: [
              if (_receiveCurrency == 'SYP') const SyriaFlag(size: 20) else Text(_receiveCurrencies[_receiveCurrency]?['flag'] ?? '🏳️', style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(child: Text(
                '$_receiveCurrency — ${_receiveCurrencies[_receiveCurrency]?['name'] ?? ''}',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              )),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.textMuted),
            ]),
          ),
        ),
        const SizedBox(height: 8),

        // Conversion preview
        if (_amountCtrl.text.isNotEmpty && (double.tryParse(_amountCtrl.text) ?? 0) > 0)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.success.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (_receiveCurrency == 'SYP') const SyriaFlag(size: 14) else Text('${_receiveCurrencies[_receiveCurrency]?['flag'] ?? '🏳️'} ', style: const TextStyle(fontSize: 14)),
              Text(
                'المستلم يحصل على: ${_formatNumber((double.tryParse(_amountCtrl.text) ?? 0) * _currentRate)} $_receiveCurrency',
                style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ]),
          ),
        const SizedBox(height: 12),

        // Notes
        _buildField('ملاحظات (اختياري)', _notesCtrl, Icons.note_alt_outlined, maxLines: 2),
        const SizedBox(height: 24),

        // Continue button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _goToConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text('متابعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  void _showAccountPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('اختر الحساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          ..._accounts.map((acc) {
            final curr = acc['currency']?['code'] ?? 'EUR';
            final bal = acc['balance'] ?? '0.00';
            final symbol = acc['currency']?['symbol'] ?? '';
            final isSelected = _selectedAccount?['id'] == acc['id'];
            return ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.bgMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(symbol.isNotEmpty ? symbol : '💳', style: const TextStyle(fontSize: 18))),
              ),
              title: Text('$curr', style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              subtitle: Text('الرصيد: $bal', style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
              onTap: () {
                setState(() => _selectedAccount = acc);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, IconData icon, {TextInputType? keyboard, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20),
        filled: true,
        fillColor: AppTheme.bgCard,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
      ),
    );
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('عملة الاستلام', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 12),
          ..._receiveCurrencies.entries.map((e) {
            final code = e.key;
            final info = e.value;
            final isSelected = _receiveCurrency == code;
            return ListTile(
              leading: Text(info['flag'], style: const TextStyle(fontSize: 24)),
              title: Text('$code — ${info['name']}', style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
              subtitle: Text('1 EUR = ${_formatNumber((info['rate'] as num).toDouble())} $code', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
              onTap: () {
                setState(() => _receiveCurrency = code);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  // ── Step 4: Confirmation ──
  Widget _buildConfirmation() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final fee = (amount * 0.02);
    final total = amount + fee;
    final receiveAmount = amount * _currentRate;
    final curr = _selectedAccount?['currency']?['code'] ?? 'EUR';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(children: [
            const SyriaFlag(size: 32),
            const SizedBox(height: 6),
            const Text('تأكيد الحوالة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const Divider(height: 24, color: AppTheme.border),

            _confirmRow('المستلم', _nameCtrl.text),
            _confirmRow('هاتف المستلم', _phoneCtrl.text),
            _confirmRow('المحافظة', _selectedGov?['name_ar'] ?? ''),
            _confirmRow('المنطقة', _selectedDistrict?['name_ar'] ?? ''),
            _confirmRow('مكتب الوكيل', _selectedAgent?['name_ar'] ?? ''),
            const Divider(height: 20, color: AppTheme.border),
            _confirmRow('المبلغ المرسل', '${amount.toStringAsFixed(2)} $curr'),
            _confirmRow('العمولة (2%)', '${fee.toStringAsFixed(2)} $curr'),
            _confirmRow('المجموع', '${total.toStringAsFixed(2)} $curr', bold: true),
            const Divider(height: 20, color: AppTheme.border),
            _confirmRow('عملة الاستلام', '$_receiveCurrency — ${_receiveCurrencies[_receiveCurrency]?['name'] ?? ''}'),
            _confirmRow('المستلم يحصل على', '${_formatNumber(receiveAmount)} $_receiveCurrency', bold: true, color: AppTheme.success),
            _confirmRow('سعر الصرف', '1 $curr = ${_formatNumber(_currentRate)} $_receiveCurrency'),
          ]),
        ),
        const SizedBox(height: 14),

        // Expiry notice
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.3)),
          ),
          child: Row(children: [
            Icon(Icons.schedule, color: Colors.amber.shade700, size: 18),
            const SizedBox(width: 8),
            Text('صلاحية الحوالة 72 ساعة', style: TextStyle(color: Colors.amber.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ),
        const SizedBox(height: 20),

        // Send button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _sending ? null : _sendRemittance,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
              disabledBackgroundColor: AppTheme.textMuted,
            ),
            child: _sending
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('إرسال الحوالة 💸', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }

  Widget _confirmRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
        Flexible(child: Text(value, style: TextStyle(
          color: color ?? AppTheme.textPrimary,
          fontSize: bold ? 15 : 13,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
        ), textAlign: TextAlign.left)),
      ]),
    );
  }

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) {
      final thousands = (n / 1000).floor();
      final remainder = (n % 1000).floor();
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return n.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }
}
