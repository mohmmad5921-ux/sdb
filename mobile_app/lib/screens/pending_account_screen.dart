import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'dart:async';

class PendingAccountScreen extends StatefulWidget {
  const PendingAccountScreen({super.key});
  @override
  State<PendingAccountScreen> createState() => _PendingAccountScreenState();
}

class _PendingAccountScreenState extends State<PendingAccountScreen> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _fadeCtrl;
  Timer? _checkTimer;
  String _userName = '';
  String? _docRequestMessage; // طلب مستندات إضافية
  bool _hasDocRequest = false;
  bool _uploading = false;
  bool _uploadSuccess = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    _loadProfile();
    _checkNotifications();
    // Check status every 30 seconds
    _checkTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkStatus();
      _checkNotifications();
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _fadeCtrl.dispose();
    _checkTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final res = await ApiService.getProfile();
    if (res['success'] == true) {
      final user = res['data']?['user'] ?? res['data'];
      setState(() => _userName = user?['full_name'] ?? '');
    }
  }

  Future<void> _checkStatus() async {
    final res = await ApiService.getProfile();
    if (res['success'] == true) {
      final user = res['data']?['user'] ?? res['data'];
      if (user?['status'] == 'active' && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Future<void> _checkNotifications() async {
    try {
      final res = await ApiService.getNotifications();
      if (res['success'] == true) {
        final data = res['data'];
        final List notifs = data is Map ? (data['data'] ?? []) : (data is List ? data : []);
        // ابحث عن آخر إشعار طلب مستندات
        for (final n in notifs) {
          final title = (n['title'] ?? '').toString();
          final body = (n['body'] ?? '').toString();
          if (title.contains('مستندات') || title.contains('Documents') || title.contains('📄')) {
            if (mounted) {
              setState(() {
                _hasDocRequest = true;
                _docRequestMessage = body;
              });
            }
            break;
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _pickAndUploadDoc() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppTheme.bgLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('اختر طريقة الرفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          const SizedBox(height: 20),
          ListTile(
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: AppTheme.primary.withAlpha(25), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.camera_alt_rounded, color: AppTheme.primary),
            ),
            title: const Text('الكاميرا', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('التقط صورة للمستند'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0xFFF59E0B).withAlpha(25), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.photo_library_rounded, color: Color(0xFFF59E0B)),
            ),
            title: const Text('معرض الصور', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('اختر صورة من المعرض'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
    if (source == null || !mounted) return;

    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null || !mounted) return;

    setState(() => _uploading = true);
    try {
      final r = await ApiService.uploadKycDocuments(
        idFrontPath: picked.path,
        idBackPath: picked.path,
        selfiePath: picked.path,
      );
      if (mounted) {
        setState(() {
          _uploading = false;
          if (r['success'] == true) {
            _uploadSuccess = true;
            _hasDocRequest = false;
          }
        });
      }
    } catch (_) {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _logout() async {
    await ApiService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                // Animated hourglass
                ScaleTransition(
                  scale: _pulseAnim,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [AppTheme.primary.withValues(alpha: 0.15), AppTheme.primary.withValues(alpha: 0.05)],
                      ),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Center(
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                        ),
                        child: const Center(child: Text('⏳', style: TextStyle(fontSize: 36))),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome text
                if (_userName.isNotEmpty) ...[
                  Text('مرحباً، $_userName 👋', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
                  const SizedBox(height: 12),
                ],

                const Text('حسابك قيد المراجعة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
                const SizedBox(height: 12),
                Text(
                  'يتم مراجعة حسابك من قبل فريقنا.\nسيتم إشعارك فور تفعيل حسابك.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.7),
                ),
                const SizedBox(height: 36),

                // Status steps
                _statusStep('✅', 'تم إنشاء الحساب', true),
                _statusStep('✅', 'تم التحقق من رقم الهاتف', true),
                _statusStep(_hasDocRequest ? '📄' : '⏳', 'مراجعة الحساب من الإدارة', false),
                _statusStep('🔒', 'تفعيل الحساب', false),

                // Document request alert
                if (_uploadSuccess) ...[                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.success, width: 1.5),
                    ),
                    child: const Column(children: [
                      Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 40),
                      SizedBox(height: 10),
                      Text('شكراً لك! 🎉', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF166534))),
                      SizedBox(height: 6),
                      Text('تم رفع المستند بنجاح. سيتم مراجعته من قبل فريقنا.', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Color(0xFF166534), height: 1.5)),
                    ]),
                  ),
                ] else if (_hasDocRequest) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFFD93D), width: 1.5),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Row(children: [
                        Icon(Icons.warning_amber_rounded, color: Color(0xFFB8860B), size: 22),
                        SizedBox(width: 8),
                        Text('📄 مطلوب مستندات إضافية', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF856404))),
                      ]),
                      const SizedBox(height: 10),
                      Text(
                        _docRequestMessage ?? 'يرجى رفع المستندات المطلوبة لإكمال عملية التحقق.',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF856404), height: 1.6),
                      ),
                      const SizedBox(height: 14),
                      GestureDetector(
                        onTap: _uploading ? null : _pickAndUploadDoc,
                        child: Container(
                          width: double.infinity, height: 44,
                          decoration: BoxDecoration(
                            gradient: _uploading ? null : const LinearGradient(colors: [Color(0xFFf59e0b), Color(0xFFd97706)]),
                            color: _uploading ? const Color(0xFFd97706).withAlpha(128) : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            if (_uploading) ...[                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                              const SizedBox(width: 8),
                              const Text('جاري الرفع...', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                            ] else ...[                              const Icon(Icons.upload_file_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              const Text('رفع المستندات', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                            ],
                          ]),
                        ),
                      ),
                    ]),
                  ),
                ],

                const SizedBox(height: 36),

                // Support chat button
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/support-chat'),
                  child: Container(
                    width: double.infinity, height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text('تواصل مع الدعم', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),

                const SizedBox(height: 40),

                // Logout
                TextButton(
                  onPressed: _logout,
                  child: const Text('تسجيل الخروج', style: TextStyle(color: AppTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 30),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusStep(String icon, String label, bool done) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600,
          color: done ? AppTheme.textPrimary : AppTheme.textMuted,
        ))),
        if (!done && icon == '⏳')
          SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary.withValues(alpha: 0.5))),
      ]),
    );
  }
}
