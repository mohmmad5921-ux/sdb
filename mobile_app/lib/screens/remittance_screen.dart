import 'package:flutter/material.dart';
import '../services/api_service.dart';
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

  double _sypRate = 13500;

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

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
      if (dashRes != null) {
        _accounts = dashRes['accounts'] ?? [];
        if (_accounts.isNotEmpty) _selectedAccount = _accounts[0];
      }
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
        const SnackBar(content: Text('يرجى ملء جميع الحقول المطلوبة')),
      );
      return;
    }
    setState(() => _step = 4);
  }

  Future<void> _sendRemittance() async {
    setState(() => _sending = true);
    try {
      final res = await ApiService.sendRemittance({
        'agent_id': _selectedAgent!['id'],
        'account_id': _selectedAccount!['id'],
        'recipient_name': _nameCtrl.text,
        'recipient_phone': _phoneCtrl.text,
        'amount': double.parse(_amountCtrl.text),
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
      backgroundColor: Colors.red.shade700,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _stepTitle(),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00D4AA)))
          : _buildStep(),
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

  // Step 0: Select Governorate
  Widget _buildGovernorateList() {
    return Column(
      children: [
        // Search hint
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF00D4AA), size: 20),
                SizedBox(width: 8),
                Text('🇸🇾 اختر محافظة في سوريا', style: TextStyle(color: Color(0xFF00D4AA), fontSize: 14)),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _governorates.length,
            itemBuilder: (_, i) {
              final gov = _governorates[i];
              final distCount = (gov['districts'] as List?)?.length ?? 0;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF1A2A44), const Color(0xFF1E3050)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00D4AA).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('🏛️', style: TextStyle(fontSize: 22))),
                  ),
                  title: Text(gov['name_ar'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: Text('${gov['name_en']} • $distCount مناطق', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFF00D4AA)),
                  onTap: () => _selectGovernorate(gov),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Step 1: Select District
  Widget _buildDistrictList() {
    final districts = (_selectedGov?['districts'] as List?) ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: districts.length,
      itemBuilder: (_, i) {
        final dist = districts[i];
        final agentCount = (dist['agents'] as List?)?.length ?? 0;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2A44),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('📍', style: TextStyle(fontSize: 20))),
            ),
            title: Text(dist['name_ar'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            subtitle: Text('$agentCount وكلاء متاحين', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF2563EB)),
            onTap: () => _selectDistrict(dist),
          ),
        );
      },
    );
  }

  // Step 2: Select Agent
  Widget _buildAgentList() {
    final agents = (_selectedDistrict?['agents'] as List?) ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: agents.length,
      itemBuilder: (_, i) {
        final ag = agents[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF1A2A44), const Color(0xFF162238)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.2)),
          ),
          child: InkWell(
            onTap: () => _selectAgent(ag),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D4AA).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('🏬', style: TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ag['name_ar'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                          if (ag['phone'] != null)
                            Text(ag['phone'], style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF00D4AA)),
                  ],
                ),
                if (ag['address_ar'] != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 14, color: Colors.white.withOpacity(0.4)),
                      const SizedBox(width: 4),
                      Expanded(child: Text(ag['address_ar'], style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12))),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // Step 3: Recipient Form
  Widget _buildRecipientForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected path
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A44),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Text('🏛️', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${_selectedGov?['name_ar']} → ${_selectedDistrict?['name_ar']} → ${_selectedAgent?['name_ar']}',
                    style: const TextStyle(color: Color(0xFF00D4AA), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Account selector
          const Text('الحساب المرسل', style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A2A44),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: DropdownButton<int>(
              value: _selectedAccount?['id'],
              isExpanded: true,
              dropdownColor: const Color(0xFF1A2A44),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white),
              items: _accounts.map<DropdownMenuItem<int>>((acc) {
                final curr = acc['currency']?['code'] ?? 'EUR';
                final bal = acc['balance'] ?? '0.00';
                return DropdownMenuItem(value: acc['id'], child: Text('$curr — $bal', style: const TextStyle(color: Colors.white)));
              }).toList(),
              onChanged: (v) => setState(() => _selectedAccount = _accounts.firstWhere((a) => a['id'] == v)),
            ),
          ),
          const SizedBox(height: 20),

          // Recipient name
          _buildTextField('اسم المستلم', _nameCtrl, Icons.person_outline),
          const SizedBox(height: 14),

          // Recipient phone
          _buildTextField('رقم هاتف المستلم', _phoneCtrl, Icons.phone_outlined, keyboardType: TextInputType.phone),
          const SizedBox(height: 14),

          // Amount
          _buildTextField('المبلغ (${_selectedAccount?['currency']?['code'] ?? 'EUR'})', _amountCtrl, Icons.attach_money, keyboardType: TextInputType.number),
          const SizedBox(height: 8),

          // SYP conversion preview
          if (_amountCtrl.text.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00D4AA).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🇸🇾 ', style: TextStyle(fontSize: 16)),
                  Text(
                    'المستلم يحصل على: ${_formatNumber((double.tryParse(_amountCtrl.text) ?? 0) * _sypRate)} ل.س',
                    style: const TextStyle(color: Color(0xFF00D4AA), fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),

          // Notes
          _buildTextField('ملاحظات (اختياري)', _notesCtrl, Icons.note_alt_outlined, maxLines: 2),
          const SizedBox(height: 24),

          // Continue button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _goToConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4AA),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('متابعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: const Color(0xFF1A2A44),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00D4AA))),
      ),
    );
  }

  // Step 4: Confirmation
  Widget _buildConfirmation() {
    final amount = double.tryParse(_amountCtrl.text) ?? 0;
    final fee = (amount * 0.015);
    final total = amount + fee;
    final receiveAmount = amount * _sypRate;
    final curr = _selectedAccount?['currency']?['code'] ?? 'EUR';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Summary card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A3A5C), Color(0xFF0D2137)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00D4AA).withOpacity(0.3)),
              boxShadow: [BoxShadow(color: const Color(0xFF00D4AA).withOpacity(0.1), blurRadius: 20, spreadRadius: 2)],
            ),
            child: Column(
              children: [
                const Text('🇸🇾', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                const Text('تأكيد الحوالة', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.white24, height: 24),

                _confirmRow('المستلم', _nameCtrl.text),
                _confirmRow('هاتف المستلم', _phoneCtrl.text),
                _confirmRow('المحافظة', _selectedGov?['name_ar'] ?? ''),
                _confirmRow('المنطقة', _selectedDistrict?['name_ar'] ?? ''),
                _confirmRow('مكتب الوكيل', _selectedAgent?['name_ar'] ?? ''),
                const Divider(color: Colors.white24, height: 20),
                _confirmRow('المبلغ المرسل', '${amount.toStringAsFixed(2)} $curr'),
                _confirmRow('العمولة (1.5%)', '${fee.toStringAsFixed(2)} $curr'),
                _confirmRow('المجموع', '${total.toStringAsFixed(2)} $curr', bold: true),
                const Divider(color: Colors.white24, height: 20),
                _confirmRow('المستلم يحصل على', '${_formatNumber(receiveAmount)} ل.س', bold: true, color: const Color(0xFF00D4AA)),
                _confirmRow('سعر الصرف', '1 $curr = ${_formatNumber(_sypRate)} ل.س'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Warning
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.schedule, color: Colors.amber, size: 18),
                SizedBox(width: 8),
                Expanded(child: Text('صلاحية الحوالة 72 ساعة', style: TextStyle(color: Colors.amber, fontSize: 13))),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Send button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _sending ? null : _sendRemittance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4AA),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                disabledBackgroundColor: Colors.grey,
              ),
              child: _sending
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : const Text('إرسال الحوالة 💸', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _confirmRow(String label, String value, {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
          Text(value, style: TextStyle(
            color: color ?? Colors.white,
            fontSize: bold ? 15 : 13,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          )),
        ],
      ),
    );
  }

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)},${(n % 1000).toStringAsFixed(0).padLeft(3, '0')}';
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
