import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full-screen rename account page matching Lunar's "Rediger navn"
class AccountRenamePage extends StatefulWidget {
  final Map<String, dynamic> account;
  const AccountRenamePage({super.key, required this.account});
  @override
  State<AccountRenamePage> createState() => _AccountRenamePageState();
}

class _AccountRenamePageState extends State<AccountRenamePage> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    final currency = widget.account['currency']?['code'] ?? 'EUR';
    _ctrl = TextEditingController(text: widget.account['name'] ?? 'Account $currency');
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 8),
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppTheme.bgMuted, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text('Rename Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
            const SizedBox(height: 20),

            // Input field
            Container(
              decoration: BoxDecoration(
                color: AppTheme.bgMuted,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.border),
              ),
              child: TextField(
                controller: _ctrl,
                autofocus: true,
                style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  labelText: 'Enter account name',
                  labelStyle: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  suffixIcon: _ctrl.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () => setState(() => _ctrl.clear()),
                          child: Icon(Icons.cancel_rounded, size: 20, color: AppTheme.textMuted),
                        )
                      : null,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _ctrl.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account renamed ✓'), backgroundColor: AppTheme.primary),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}
