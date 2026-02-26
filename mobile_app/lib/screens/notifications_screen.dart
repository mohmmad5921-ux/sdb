import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List notifications = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final r = await ApiService.getNotifications();
      if (r['success'] == true) {
        final d = r['data'];
        setState(() => notifications = d is List ? d : d?['data'] ?? []);
      }
    } catch (_) {}
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.w700)), backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded), onPressed: () => Navigator.pop(context))),
      body: loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : RefreshIndicator(color: AppTheme.primary, onRefresh: _load,
            child: notifications.isEmpty
              ? ListView(children: [
                  const SizedBox(height: 100),
                  Center(child: Column(children: [
                    Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(24)),
                      child: Icon(Icons.notifications_off_outlined, size: 36, color: Colors.white.withValues(alpha: 0.15))),
                    const SizedBox(height: 16),
                    Text('لا توجد إشعارات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.3))),
                    const SizedBox(height: 6),
                    Text('ستظهر إشعاراتك هنا', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.15))),
                  ])),
                ])
              : ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), itemCount: notifications.length, itemBuilder: (_, i) => _item(notifications[i]))),
    );
  }

  Widget _item(Map<String, dynamic> n) {
    final isRead = n['is_read'] == true;
    final type = '${n['type'] ?? ''}';
    final icons = {'transaction': Icons.swap_horiz_rounded, 'deposit': Icons.add_rounded, 'card': Icons.credit_card_rounded, 'security': Icons.shield_rounded, 'system': Icons.info_rounded};
    final colors = {'transaction': const Color(0xFF6366F1), 'deposit': AppTheme.success, 'card': const Color(0xFFEC4899), 'security': const Color(0xFFF59E0B), 'system': AppTheme.primary};
    final c = colors[type] ?? AppTheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white.withValues(alpha: 0.01) : c.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isRead ? Colors.white.withValues(alpha: 0.03) : c.withValues(alpha: 0.08)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Icon(icons[type] ?? Icons.notifications_rounded, color: c, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(n['title'] ?? '', style: TextStyle(fontSize: 14, fontWeight: isRead ? FontWeight.w500 : FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 3),
          Text(n['message'] ?? n['body'] ?? '', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.35))),
          const SizedBox(height: 6),
          Text(n['created_at'] != null ? DateFormat('MMM dd, HH:mm').format(DateTime.tryParse('${n['created_at']}') ?? DateTime.now()) : '',
            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.15))),
        ])),
        if (!isRead) Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: c)),
      ]),
    );
  }
}
