import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class TransactionDetailPage extends StatelessWidget {
  final Map<String, dynamic> tx;
  final bool isIncoming;

  const TransactionDetailPage({super.key, required this.tx, required this.isIncoming});

  @override
  Widget build(BuildContext context) {
    final amount = (tx['amount'] is num) ? (tx['amount'] as num).toDouble() : double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
    final currency = tx['currency']?['code'] ?? tx['from_account']?['currency']?['code'] ?? 'EUR';
    final symbol = _currencySymbol(currency);
    final desc = tx['description'] ?? (tx['type'] ?? 'Transfer');
    final status = tx['status'] ?? 'completed';
    final date = tx['created_at'] ?? '';
    final type = tx['type'] ?? 'transfer';
    final fromAccount = tx['from_account'];
    final toAccount = tx['to_account'];
    final reference = tx['reference'] ?? tx['id']?.toString() ?? '';
    final fee = (tx['fee'] is num) ? (tx['fee'] as num).toDouble() : double.tryParse(tx['fee']?.toString() ?? '0') ?? 0;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: CustomScrollView(
        slivers: [
          // ── Collapsed App Bar ──
          SliverAppBar(
            backgroundColor: AppTheme.bgLight,
            elevation: 0,
            pinned: true,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.bgMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppTheme.textPrimary),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => _showOptions(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.bgMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                  // Avatar
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

                // ── Quick Actions Row ──
                Row(children: [
                  _actionButton(context, Icons.note_add_outlined, 'إضافة ملاحظة', () => _addNote(context)),
                  const SizedBox(width: 12),
                  _actionButton(context, Icons.receipt_long_outlined, 'إضافة إيصال', () => _addReceipt(context)),
                  const SizedBox(width: 12),
                  _actionButton(context, Icons.forward_rounded, 'إعادة إرسال', () {
                    Navigator.pushNamed(context, '/transfer');
                  }),
                ]),

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
                      _detailRow('من حساب', fromAccount['account_number']?.toString() ?? fromAccount['iban']?.toString() ?? '-'),
                    ],
                    if (toAccount != null) ...[
                      _divider(),
                      _detailRow('إلى حساب', toAccount['account_number']?.toString() ?? toAccount['iban']?.toString() ?? '-'),
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
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
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
        ]),
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

  // ── Dialogs ──
  void _addNote(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          const Text('إضافة ملاحظة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 16),
          TextField(
            controller: ctrl,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'اكتب ملاحظتك هنا...',
              hintStyle: const TextStyle(color: AppTheme.textMuted),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.primary)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الملاحظة ✅'), backgroundColor: AppTheme.primary));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            child: const Text('حفظ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
          )),
        ]),
      ),
    );
  }

  void _addReceipt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📸 ميزة إضافة الإيصال قريباً'), backgroundColor: AppTheme.primary));
  }

  void _exportReceipt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📄 جاري تصدير الإيصال...'), backgroundColor: AppTheme.primary));
  }

  void _reportProblem(BuildContext context) {
    showDialog(context: context, builder: (dCtx) => AlertDialog(
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
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال البلاغ ✅'), backgroundColor: AppTheme.primary));
        }, child: const Text('إبلاغ', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700))),
      ],
    ));
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          _optionItem(Icons.file_download_outlined, 'تصدير الإيصال', () { Navigator.pop(context); _exportReceipt(context); }),
          _divider(),
          _optionItem(Icons.copy_rounded, 'نسخ المرجع', () {
            Navigator.pop(context);
            Clipboard.setData(ClipboardData(text: tx['reference']?.toString() ?? tx['id']?.toString() ?? ''));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم النسخ ✅'), backgroundColor: AppTheme.primary, duration: Duration(seconds: 1)));
          }),
          _divider(),
          _optionItem(Icons.repeat_rounded, 'تكرار العملية', () { Navigator.pop(context); Navigator.pushNamed(context, '/transfer'); }),
          _divider(),
          _optionItem(Icons.flag_outlined, 'الإبلاغ عن مشكلة', () { Navigator.pop(context); _reportProblem(context); }, danger: true),
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
