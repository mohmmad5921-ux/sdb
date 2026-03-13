import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../services/api_service.dart';

class TransactionDetailPage extends StatefulWidget {
  final Map<String, dynamic> tx;
  final bool isIncoming;

  const TransactionDetailPage({super.key, required this.tx, required this.isIncoming});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late Map<String, dynamic> tx;
  late bool isIncoming;
  String? _savedNote;

  @override
  void initState() {
    super.initState();
    tx = Map<String, dynamic>.from(widget.tx);
    isIncoming = widget.isIncoming;
    // Load saved note from metadata
    final metadata = tx['metadata'];
    if (metadata is Map) {
      _savedNote = metadata['note']?.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
    final fee = (tx['fee'] is num) ? (tx['fee'] as num).toDouble() : double.tryParse(tx['fee']?.toString() ?? '0') ?? 0;

    // Currency: try multiple sources
    final currency = tx['currency']?['code'] ?? tx['from_account']?['currency']?['code'] ?? tx['to_account']?['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);
    final desc = tx['description'] ?? (tx['type'] ?? 'تحويل');
    final status = tx['status'] ?? 'completed';
    final date = tx['created_at'] ?? '';
    final type = tx['type'] ?? 'transfer';
    final fromAccount = tx['from_account'];
    final toAccount = tx['to_account'];
    final reference = tx['reference_number'] ?? tx['reference'] ?? tx['id']?.toString() ?? '';

    // Wallet / account info
    final fromCurrency = fromAccount?['currency']?['code'] ?? '';
    final toCurrency = toAccount?['currency']?['code'] ?? '';
    final fromAccountNum = fromAccount?['account_number']?.toString() ?? fromAccount?['iban']?.toString() ?? '-';
    final toAccountNum = toAccount?['account_number']?.toString() ?? toAccount?['iban']?.toString() ?? '-';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            backgroundColor: AppTheme.bgLight,
            elevation: 0,
            pinned: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppTheme.textPrimary),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => _showOptions(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.more_horiz_rounded, size: 20, color: AppTheme.textPrimary),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 8),

                // ── Amount Hero ──
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      '${isIncoming ? "+" : "-"}$symbol${_formatNumber(amount)}',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: isIncoming ? AppTheme.primary : AppTheme.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc.toString().toUpperCase(),
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textMuted, letterSpacing: 0.5),
                    ),
                  ])),
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: isIncoming ? const Color(0xFFE8F5F0) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      isIncoming ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      size: 24,
                      color: isIncoming ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                  ),
                ]),

                const SizedBox(height: 28),

                // ── Status Badge ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_statusIcon(status), size: 14, color: _statusColor(status)),
                    const SizedBox(width: 6),
                    Text(_statusText(status), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor(status))),
                  ]),
                ),

                const SizedBox(height: 28),

                // ── Quick Actions ──
                Row(children: [
                  _actionButton(context, Icons.note_add_outlined, 'إضافة ملاحظة', () => _addNote(context)),
                  const SizedBox(width: 12),
                  _actionButton(context, Icons.receipt_long_outlined, 'إضافة إيصال', () => _addReceipt(context)),
                  const SizedBox(width: 12),
                  _actionButton(context, Icons.forward_rounded, 'إعادة إرسال', () => Navigator.pushNamed(context, '/transfer')),
                ]),

                // ── Saved Note Display ──
                if (_savedNote != null && _savedNote!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF9C3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Icon(Icons.sticky_note_2_rounded, size: 16, color: Color(0xFFB45309)),
                      const SizedBox(width: 8),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('ملاحظة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB45309))),
                        const SizedBox(height: 2),
                        Text(_savedNote!, style: const TextStyle(fontSize: 13, color: Color(0xFF92400E))),
                      ])),
                      GestureDetector(
                        onTap: () => _addNote(context),
                        child: const Icon(Icons.edit_rounded, size: 14, color: Color(0xFFB45309)),
                      ),
                    ]),
                  ),
                ],

                const SizedBox(height: 28),

                // ── Details Section ──
                const Text('التفاصيل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
                  ),
                  child: Column(children: [
                    _detailRow('التاريخ', _formatFullDate(date)),
                    _divider(),
                    _detailRow('المبلغ', '$symbol${_formatNumber(amount)} $currency'),
                    if (fee > 0) ...[
                      _divider(),
                      _detailRow('الرسوم', '$symbol${_formatNumber(fee)}'),
                    ],
                    _divider(),
                    _detailRow('النوع', _typeText(type)),
                    _divider(),
                    _detailRow('الحالة', _statusText(status)),
                    if (fromAccount != null) ...[
                      _divider(),
                      _detailRow(
                        'من حساب',
                        fromCurrency.isNotEmpty ? '$fromAccountNum ($fromCurrency ${_currencyFlag(fromCurrency)})' : fromAccountNum,
                      ),
                    ],
                    if (toAccount != null) ...[
                      _divider(),
                      _detailRow(
                        'إلى حساب',
                        toCurrency.isNotEmpty ? '$toAccountNum ($toCurrency ${_currencyFlag(toCurrency)})' : toAccountNum,
                      ),
                    ],
                    if (reference.isNotEmpty) ...[
                      _divider(),
                      _detailRow('المرجع', reference, copyable: true),
                    ],
                    _divider(),
                    _detailRow('العملة', '$currency ${_currencyFlag(currency)}'),
                  ]),
                ),

                const SizedBox(height: 28),

                // ── Options Section ──
                const Text('خيارات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
                  ),
                  child: Column(children: [
                    _optionItem(Icons.file_download_outlined, 'تصدير الإيصال', () => _exportReceipt(context)),
                    _divider(),
                    _optionItem(Icons.repeat_rounded, 'تكرار العملية', () => Navigator.pushNamed(context, '/transfer')),
                    _divider(),
                    _optionItem(Icons.flag_outlined, 'الإبلاغ عن مشكلة', () => _reportProblem(context), danger: true),
                  ]),
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick Action Button ──
  Widget _actionButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 22, color: AppTheme.textSecondary),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  // ── Detail Row ──
  Widget _detailRow(String label, String value, {bool copyable = false}) {
    return Builder(builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        const Spacer(),
        Flexible(child: Row(mainAxisSize: MainAxisSize.min, children: [
          Flexible(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), textAlign: TextAlign.end, overflow: TextOverflow.ellipsis)),
          if (copyable) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم النسخ ✅'), backgroundColor: AppTheme.primary, duration: Duration(seconds: 1)),
                );
              },
              child: const Icon(Icons.copy_rounded, size: 14, color: AppTheme.primary),
            ),
          ],
        ])),
      ]),
    ));
  }

  Widget _divider() => Divider(height: 1, color: AppTheme.border.withValues(alpha: 0.3));

  // ── Option Item ──
  Widget _optionItem(IconData icon, String title, VoidCallback onTap, {bool danger = false}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, size: 20, color: danger ? AppTheme.danger : AppTheme.textSecondary),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: danger ? AppTheme.danger : AppTheme.textPrimary))),
          Icon(Icons.chevron_right_rounded, size: 18, color: danger ? AppTheme.danger.withValues(alpha: 0.5) : AppTheme.textMuted),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════
  // ── Add Note (saves to backend) ──
  // ══════════════════════════════════════════
  void _addNote(BuildContext ctx) {
    final ctrl = TextEditingController(text: _savedNote ?? '');
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('إضافة ملاحظة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          TextField(
            controller: ctrl,
            maxLines: 4,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'اكتب ملاحظتك هنا...',
              hintStyle: const TextStyle(color: AppTheme.textMuted),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primary)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
            onPressed: () async {
              final note = ctrl.text.trim();
              if (note.isEmpty) return;
              Navigator.pop(sheetCtx);

              // Save to backend
              final txId = tx['id']?.toString() ?? '';
              if (txId.isNotEmpty) {
                try {
                  await ApiService.post('/transactions/$txId/note', {'note': note});
                } catch (_) {}
              }

              // Update local state immediately
              if (mounted) {
                setState(() => _savedNote = note);
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('تم حفظ الملاحظة ✅'), backgroundColor: AppTheme.primary),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: const Text('حفظ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          )),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════
  // ── Add Receipt (open camera/gallery) ──
  // ══════════════════════════════════════════
  void _addReceipt(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('إضافة إيصال', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 20),
          _optionItem(Icons.camera_alt_rounded, 'التقاط صورة', () {
            Navigator.pop(sheetCtx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text('📸 ميزة الكاميرا ستكون متاحة قريباً'), backgroundColor: AppTheme.primary),
            );
          }),
          _divider(),
          _optionItem(Icons.photo_library_rounded, 'اختيار من المعرض', () {
            Navigator.pop(sheetCtx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text('🖼️ ميزة المعرض ستكون متاحة قريباً'), backgroundColor: AppTheme.primary),
            );
          }),
          _divider(),
          _optionItem(Icons.description_rounded, 'مستند PDF', () {
            Navigator.pop(sheetCtx);
            ScaffoldMessenger.of(ctx).showSnackBar(
              const SnackBar(content: Text('📄 ميزة PDF ستكون متاحة قريباً'), backgroundColor: AppTheme.primary),
            );
          }),
        ]),
      ),
    );
  }

  // ══════════════════════════════════════════
  // ── Export Receipt (via Share sheet) ──
  // ══════════════════════════════════════════
  void _exportReceipt(BuildContext ctx) {
    final amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
    final currency = tx['currency']?['code'] ?? tx['from_account']?['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);
    final desc = tx['description'] ?? (tx['type'] ?? 'تحويل');
    final status = tx['status'] ?? 'completed';
    final date = tx['created_at'] ?? '';
    final type = tx['type'] ?? 'transfer';
    final reference = tx['reference_number'] ?? tx['reference'] ?? tx['id']?.toString() ?? '';
    final fromAccount = tx['from_account'];
    final toAccount = tx['to_account'];
    final fromCurrency = fromAccount?['currency']?['code'] ?? '';
    final toCurrency = toAccount?['currency']?['code'] ?? '';
    final fee = (tx['fee'] is num) ? (tx['fee'] as num).toDouble() : double.tryParse(tx['fee']?.toString() ?? '0') ?? 0;

    final receiptText = '''
═══════════════════════════
      إيصال معاملة - SDB Bank
═══════════════════════════

المبلغ: ${isIncoming ? "+" : "-"}$symbol${_formatNumber(amount)} $currency
النوع: ${_typeText(type)}
الوصف: $desc
الحالة: ${_statusText(status)}
التاريخ: ${_formatFullDate(date)}
${fee > 0 ? 'الرسوم: $symbol${_formatNumber(fee)}\n' : ''}المرجع: $reference
${fromAccount != null ? 'من حساب: ${fromAccount['account_number'] ?? '-'}${fromCurrency.isNotEmpty ? ' ($fromCurrency)' : ''}\n' : ''}${toAccount != null ? 'إلى حساب: ${toAccount['account_number'] ?? '-'}${toCurrency.isNotEmpty ? ' ($toCurrency)' : ''}\n' : ''}${_savedNote != null && _savedNote!.isNotEmpty ? 'ملاحظة: $_savedNote\n' : ''}
═══════════════════════════
      SDB Bank - بنك سوريا الرقمي
      https://sdb-bank.com
═══════════════════════════
''';

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetCtx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('إيصال المعاملة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  child: Text(receiptText, style: const TextStyle(fontSize: 13, height: 1.6, color: AppTheme.textPrimary, fontFamily: 'Courier')),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: receiptText));
                  Navigator.pop(sheetCtx);
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الإيصال ✅'), backgroundColor: AppTheme.primary),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white),
                label: const Text('نسخ الإيصال', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Report Problem ──
  void _reportProblem(BuildContext ctx) {
    showDialog(context: ctx, builder: (dCtx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(children: [
        Icon(Icons.flag_outlined, color: AppTheme.danger, size: 24),
        SizedBox(width: 8),
        Text('الإبلاغ عن مشكلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ]),
      content: const Text('هل تريد الإبلاغ عن هذه المعاملة؟\nسيتم مراجعتها من قبل فريق الدعم.',
        style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('إلغاء', style: TextStyle(color: AppTheme.textMuted))),
        TextButton(onPressed: () {
          Navigator.pop(dCtx);
          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم إرسال البلاغ ✅'), backgroundColor: AppTheme.primary));
        }, child: const Text('إبلاغ', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700))),
      ],
    ));
  }

  // ── Options sheet ──
  void _showOptions(BuildContext ctx) {
    showModalBottomSheet(context: ctx, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          _optionItem(Icons.file_download_outlined, 'تصدير الإيصال', () { Navigator.pop(ctx); _exportReceipt(ctx); }),
          _divider(),
          _optionItem(Icons.copy_rounded, 'نسخ المرجع', () {
            Navigator.pop(ctx);
            final ref = tx['reference_number']?.toString() ?? tx['reference']?.toString() ?? tx['id']?.toString() ?? '';
            Clipboard.setData(ClipboardData(text: ref));
            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('تم النسخ ✅'), backgroundColor: AppTheme.primary, duration: Duration(seconds: 1)));
          }),
          _divider(),
          _optionItem(Icons.repeat_rounded, 'تكرار العملية', () { Navigator.pop(ctx); Navigator.pushNamed(ctx, '/transfer'); }),
          _divider(),
          _optionItem(Icons.flag_outlined, 'الإبلاغ عن مشكلة', () { Navigator.pop(ctx); _reportProblem(ctx); }, danger: true),
        ]),
      ),
    );
  }

  // ── Helpers ──
  String _currencySymbol(String code) => {'EUR': '€', 'USD': '\$', 'SYP': 'ل.س', 'GBP': '£', 'DKK': 'kr'}[code] ?? code;
  String _currencyFlag(String code) => {'EUR': '🇪🇺', 'USD': '🇺🇸', 'SYP': '🇸🇾', 'GBP': '🇬🇧', 'DKK': '🇩🇰'}[code] ?? '💰';

  String _formatNumber(dynamic n) {
    final d = (n is num) ? n.toDouble() : double.tryParse(n.toString()) ?? 0;
    return d.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  String _formatFullDate(String d) {
    if (d.isEmpty) return '-';
    try {
      final dt = DateTime.parse(d);
      final months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) { return d; }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'completed': return AppTheme.primary;
      case 'pending': return AppTheme.warning;
      case 'failed': return AppTheme.danger;
      default: return AppTheme.textMuted;
    }
  }

  IconData _statusIcon(String s) {
    switch (s) {
      case 'completed': return Icons.check_circle_rounded;
      case 'pending': return Icons.access_time_rounded;
      case 'failed': return Icons.cancel_rounded;
      default: return Icons.info_outline_rounded;
    }
  }

  String _statusText(String s) {
    switch (s) {
      case 'completed': return 'مكتملة';
      case 'pending': return 'قيد المعالجة';
      case 'failed': return 'فاشلة';
      default: return s;
    }
  }

  String _typeText(String t) {
    switch (t) {
      case 'transfer': return 'تحويل';
      case 'deposit': return 'إيداع';
      case 'withdrawal': return 'سحب';
      case 'exchange': return 'تحويل عملات';
      case 'card_payment': return 'دفع بالبطاقة';
      default: return t;
    }
  }
}
