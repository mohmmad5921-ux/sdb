import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _searchCtrl = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _searching = false;
  bool _hasSearched = false;
  List<Map<String, dynamic>> _recentContacts = [];

  @override
  void initState() {
    super.initState();
    _loadRecent();
  }

  Future<void> _loadRecent() async {
    // Load recent transfers as recent contacts
    final r = await ApiService.getTransactions(page: 1);
    if (r['success'] == true && mounted) {
      final txs = List<Map<String, dynamic>>.from(r['data']?['data'] ?? r['data']?['transactions'] ?? []);
      final seen = <String>{};
      final contacts = <Map<String, dynamic>>[];
      for (final tx in txs) {
        final name = tx['to_user']?['full_name'] ?? tx['description'] ?? '';
        final username = tx['to_user']?['username'] ?? '';
        final phone = tx['to_user']?['phone'] ?? '';
        if (name.isNotEmpty && !seen.contains(name)) {
          seen.add(name);
          contacts.add({'full_name': name, 'username': username, 'phone': phone, 'is_member': true});
        }
        if (contacts.length >= 10) break;
      }
      setState(() => _recentContacts = contacts);
    }
  }

  Future<void> _search(String query) async {
    if (query.length < 2) return;
    setState(() { _searching = true; _hasSearched = true; });

    // Search by username or phone
    final r = await ApiService.post('/users/search', {'query': query});
    if (r['success'] == true && mounted) {
      setState(() {
        _results = List<Map<String, dynamic>>.from(r['data']?['users'] ?? []);
        _searching = false;
      });
    } else if (mounted) {
      // Fallback: try direct username lookup
      final r2 = await ApiService.findByUsername(query.replaceAll('@', ''));
      if (r2['success'] == true && mounted) {
        final user = r2['data']?['user'] ?? r2['data'];
        setState(() {
          _results = user != null ? [Map<String, dynamic>.from(user)] : [];
          _searching = false;
        });
      } else {
        setState(() { _results = []; _searching = false; });
      }
    }
  }

  void _sendToUser(Map<String, dynamic> user) {
    Navigator.pushNamed(context, '/transfer', arguments: {
      'username': user['username'] ?? '',
      'phone': user['phone'] ?? '',
      'name': user['full_name'] ?? '',
    });
  }

  Future<void> _inviteVia(String phone) async {
    final t = L10n.of(context);
    final uri = Uri(scheme: 'sms', path: phone, queryParameters: {'body': t.inviteMessage});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = L10n.of(context);
    final displayList = _hasSearched ? _results : _recentContacts;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: Column(children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 12),
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(children: [
            Expanded(child: Text(t.contacts, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary))),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/qr'),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.qr_code_scanner_rounded, size: 20, color: AppTheme.primary),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 14),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) {
                if (v.length >= 2) _search(v);
                if (v.isEmpty) setState(() { _hasSearched = false; _results = []; });
              },
              onSubmitted: _search,
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: t.searchContacts,
                hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppTheme.textMuted),
                suffixIcon: _searchCtrl.text.isNotEmpty ? GestureDetector(
                  onTap: () { _searchCtrl.clear(); setState(() { _hasSearched = false; _results = []; }); },
                  child: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textMuted),
                ) : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Quick send by phone
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/transfer'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.primary.withValues(alpha: 0.05), AppTheme.primary.withValues(alpha: 0.02)]),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.15)),
              ),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.send_rounded, size: 18, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t.sendMoney, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  Text(t.sendViaPhone, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                ])),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Section label
        if (!_hasSearched && _recentContacts.isNotEmpty) Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(children: [
            Icon(Icons.history_rounded, size: 14, color: AppTheme.textMuted),
            const SizedBox(width: 6),
            Text('آخر التحويلات', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
          ]),
        ),

        // Results
        if (_searching)
          const Expanded(child: Center(child: CircularProgressIndicator(color: AppTheme.primary)))
        else
          Expanded(
            child: displayList.isEmpty && _hasSearched
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.person_search_rounded, size: 48, color: AppTheme.textMuted.withValues(alpha: 0.3)),
                  const SizedBox(height: 12),
                  Text(t.noContactsFound, style: const TextStyle(color: AppTheme.textMuted)),
                  const SizedBox(height: 16),
                  // Invite button
                  if (_searchCtrl.text.isNotEmpty) GestureDetector(
                    onTap: () => _inviteVia(_searchCtrl.text),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.person_add_rounded, size: 16, color: AppTheme.primary),
                        const SizedBox(width: 6),
                        Text(t.inviteToSdb, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                      ]),
                    ),
                  ),
                ]))
              : displayList.isEmpty && !_hasSearched
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.people_outline_rounded, size: 48, color: AppTheme.textMuted.withValues(alpha: 0.3)),
                    const SizedBox(height: 12),
                    Text(t.searchContacts, style: const TextStyle(color: AppTheme.textMuted)),
                  ]))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: displayList.length,
                    itemBuilder: (_, i) => _buildContactTile(displayList[i], t),
                  ),
          ),
      ]),
    );
  }

  Widget _buildContactTile(Map<String, dynamic> user, AppStrings t) {
    final name = user['full_name'] ?? user['name'] ?? '';
    final username = user['username'] ?? '';
    final phone = user['phone'] ?? '';
    final isMember = user['is_member'] == true || username.isNotEmpty;
    final initials = _getInitials(name);

    return GestureDetector(
      onTap: () => isMember ? _sendToUser(user) : _inviteVia(phone),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isMember ? AppTheme.primary.withValues(alpha: 0.04) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: isMember ? Border.all(color: AppTheme.primary.withValues(alpha: 0.12)) : null,
        ),
        child: Row(children: [
          // Avatar
          Stack(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: isMember ? AppTheme.primary : AppTheme.bgMuted,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(child: Text(initials, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isMember ? Colors.white : AppTheme.textSecondary))),
            ),
            if (isMember) Positioned(bottom: 0, right: 0, child: Container(
              width: 14, height: 14,
              decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(7), border: Border.all(color: Colors.white, width: 1.5)),
              child: const Icon(Icons.check, size: 8, color: Colors.white),
            )),
          ]),
          const SizedBox(width: 12),
          // Info
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Flexible(child: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary), overflow: TextOverflow.ellipsis)),
              if (isMember) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(t.sdbMember, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                ),
              ],
            ]),
            if (username.isNotEmpty) Text('@$username', style: const TextStyle(fontSize: 11, color: AppTheme.primary)),
            if (phone.isNotEmpty && username.isEmpty) Text(phone, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          // Action
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isMember ? AppTheme.primary : AppTheme.bgMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isMember ? t.send : t.inviteToSdb,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isMember ? Colors.white : AppTheme.textSecondary),
            ),
          ),
        ]),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }
}
