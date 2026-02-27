import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});
  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  int _step = 0; // 0=status, 1=id_front, 2=id_back, 3=selfie, 4=uploading, 5=done
  String _kycStatus = 'pending';
  List _documents = [];
  bool _loading = true;
  String? _error;

  File? _idFront, _idBack, _selfie;
  final _picker = ImagePicker();

  @override
  void initState() { super.initState(); _loadStatus(); }

  Future<void> _loadStatus() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getKycStatus();
      if (r['success'] == true) {
        setState(() {
          _kycStatus = r['data']['kyc_status'] ?? 'pending';
          _documents = r['data']['documents'] ?? [];
        });
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _pickImage(String type) async {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (ctx) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('اختر مصدر الصورة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: _sourceButton(Icons.camera_alt_rounded, 'الكاميرا', () async {
            Navigator.pop(ctx);
            final img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1920);
            if (img != null) _setImage(type, File(img.path));
          })),
          const SizedBox(width: 16),
          Expanded(child: _sourceButton(Icons.photo_library_rounded, 'المعرض', () async {
            Navigator.pop(ctx);
            final img = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1920);
            if (img != null) _setImage(type, File(img.path));
          })),
        ]),
        const SizedBox(height: 16),
      ]),
    ));
  }

  Widget _sourceButton(IconData icon, String label, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(icon, size: 32, color: AppTheme.primary),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ]),
    ),
  );

  void _setImage(String type, File file) {
    setState(() {
      if (type == 'id_front') _idFront = file;
      else if (type == 'id_back') _idBack = file;
      else if (type == 'selfie') _selfie = file;
    });
  }

  Future<void> _upload() async {
    if (_idFront == null || _idBack == null || _selfie == null) {
      setState(() => _error = 'يرجى التقاط جميع الصور المطلوبة');
      return;
    }
    setState(() { _step = 4; _error = null; });
    try {
      final r = await ApiService.uploadKycDocuments(
        idFrontPath: _idFront!.path,
        idBackPath: _idBack!.path,
        selfiePath: _selfie!.path,
      );
      if (r['success'] == true) {
        setState(() { _step = 5; _kycStatus = 'submitted'; });
      } else {
        setState(() { _step = 1; _error = r['data']?['message'] ?? 'فشل الرفع'; });
      }
    } catch (e) {
      setState(() { _step = 1; _error = 'خطأ في الاتصال'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
        title: const Text('التحقق من الهوية', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontSize: 18)),
      ),
      body: SafeArea(child: _loading
        ? const Center(child: CircularProgressIndicator())
        : _step == 5 ? _buildSuccess()
        : _step == 4 ? _buildUploading()
        : (_kycStatus == 'verified') ? _buildVerified()
        : (_kycStatus == 'submitted') ? _buildSubmitted()
        : _buildUploadFlow(),
      ),
    );
  }

  Widget _buildVerified() => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.verified_rounded, size: 56, color: AppTheme.success),
      ),
      const SizedBox(height: 24),
      const Text('✅ هويتك موثّقة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
      const SizedBox(height: 12),
      Text('تم التحقق من هويتك بنجاح.\nيمكنك استخدام جميع خدمات البنك.', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.6)),
      const SizedBox(height: 32),
      if (_documents.isNotEmpty) ...[
        const Align(alignment: Alignment.centerRight, child: Text('المستندات المرفوعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
        const SizedBox(height: 12),
        ..._documents.map((d) => _docTile(d)),
      ],
    ]),
  );

  Widget _buildSubmitted() => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(color: const Color(0xFFF59E0B).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.hourglass_top_rounded, size: 56, color: Color(0xFFF59E0B)),
      ),
      const SizedBox(height: 24),
      const Text('⏳ قيد المراجعة', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
      const SizedBox(height: 12),
      Text('تم إرسال مستنداتك وهي قيد المراجعة.\nسيتم إشعارك عند اكتمال التحقق.', textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.6)),
      const SizedBox(height: 32),
      if (_documents.isNotEmpty) ...[
        const Align(alignment: Alignment.centerRight, child: Text('المستندات المرسلة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary))),
        const SizedBox(height: 12),
        ..._documents.map((d) => _docTile(d)),
      ],
      const SizedBox(height: 24),
      SizedBox(width: double.infinity, height: 50, child: OutlinedButton(
        onPressed: () => setState(() { _step = 1; _kycStatus = 'pending'; }),
        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), side: BorderSide(color: AppTheme.primary)),
        child: const Text('إعادة إرسال المستندات', style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primary)),
      )),
    ]),
  );

  Widget _buildUploadFlow() => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Header
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1E5EFF), Color(0xFF3B82F6)]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.verified_user_rounded, color: Colors.white, size: 32),
          const SizedBox(height: 12),
          const Text('التحقق من الهوية', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text('ارفع مستنداتك لتفعيل الحساب بالكامل', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
        ]),
      ),
      const SizedBox(height: 24),

      // Step 1: ID Front
      _uploadCard('صورة الهوية - الأمامية', 'التقط صورة واضحة للوجه الأمامي من بطاقة الهوية', Icons.badge_rounded, _idFront, () => _pickImage('id_front')),
      const SizedBox(height: 14),

      // Step 2: ID Back
      _uploadCard('صورة الهوية - الخلفية', 'التقط صورة واضحة للوجه الخلفي من بطاقة الهوية', Icons.flip_rounded, _idBack, () => _pickImage('id_back')),
      const SizedBox(height: 14),

      // Step 3: Selfie
      _uploadCard('صورة شخصية (سيلفي)', 'التقط سيلفي واضح لوجهك مع الاضاءة الجيدة', Icons.face_rounded, _selfie, () => _pickImage('selfie')),
      const SizedBox(height: 20),

      if (_error != null) Container(
        padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(_error!, style: TextStyle(fontSize: 13, color: AppTheme.danger))),
        ]),
      ),

      // Upload button
      SizedBox(height: 54, child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: (_idFront != null && _idBack != null && _selfie != null)
            ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)])
            : LinearGradient(colors: [Colors.grey[300]!, Colors.grey[400]!]),
        ),
        child: ElevatedButton(
          onPressed: (_idFront != null && _idBack != null && _selfie != null) ? _upload : null,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
          child: const Text('إرسال المستندات للمراجعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      )),
      const SizedBox(height: 16),
      Center(child: Text('سيتم مراجعة مستنداتك خلال 24 ساعة', style: TextStyle(fontSize: 12, color: AppTheme.textMuted))),
    ]),
  );

  Widget _uploadCard(String title, String subtitle, IconData icon, File? file, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: file != null ? AppTheme.success.withValues(alpha: 0.04) : AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: file != null ? AppTheme.success.withValues(alpha: 0.3) : AppTheme.border),
      ),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: file != null ? AppTheme.success.withValues(alpha: 0.1) : AppTheme.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
          ),
          child: file != null
            ? ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.file(file, fit: BoxFit.cover))
            : Icon(icon, size: 28, color: AppTheme.primary),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: file != null ? AppTheme.success : AppTheme.textPrimary)),
          const SizedBox(height: 3),
          Text(file != null ? '✓ تم التقاط الصورة' : subtitle, style: TextStyle(fontSize: 12, color: file != null ? AppTheme.success : AppTheme.textMuted)),
        ])),
        Icon(file != null ? Icons.check_circle_rounded : Icons.camera_alt_rounded,
          color: file != null ? AppTheme.success : AppTheme.textMuted, size: 22),
      ]),
    ),
  );

  Widget _buildUploading() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const SizedBox(width: 60, height: 60, child: CircularProgressIndicator(strokeWidth: 4, color: AppTheme.primary)),
    const SizedBox(height: 24),
    const Text('جاري رفع المستندات...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
    const SizedBox(height: 8),
    Text('يرجى الانتظار وعدم إغلاق التطبيق', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
  ]));

  Widget _buildSuccess() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(
      width: 100, height: 100,
      decoration: BoxDecoration(color: AppTheme.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
      child: const Icon(Icons.check_circle_rounded, size: 56, color: AppTheme.success),
    ),
    const SizedBox(height: 24),
    const Text('تم إرسال المستندات!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
    const SizedBox(height: 12),
    Text('سيتم مراجعة مستنداتك وإشعارك بالنتيجة.\nعادةً ما تستغرق المراجعة 24 ساعة.', textAlign: TextAlign.center,
      style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.6)),
    const SizedBox(height: 32),
    SizedBox(width: 200, height: 50, child: ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
      child: const Text('العودة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
    )),
  ]));

  Widget _docTile(dynamic d) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
    child: Row(children: [
      Icon(_docIcon(d['type']), size: 20, color: _statusColor(d['status'])),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_docLabel(d['type']), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        Text(d['status'] == 'approved' ? '✓ مُعتمد' : d['status'] == 'rejected' ? '✗ مرفوض: ${d['rejection_reason'] ?? ''}' : '⏳ قيد المراجعة',
          style: TextStyle(fontSize: 11, color: _statusColor(d['status']))),
      ])),
    ]),
  );

  IconData _docIcon(String type) => switch (type) {
    'id_card' => Icons.badge_rounded,
    'selfie' => Icons.face_rounded,
    'address_proof' => Icons.home_rounded,
    _ => Icons.description_rounded,
  };

  String _docLabel(String type) => switch (type) {
    'id_card' => 'بطاقة الهوية',
    'selfie' => 'صورة شخصية',
    'address_proof' => 'إثبات عنوان',
    _ => 'مستند',
  };

  Color _statusColor(String status) => switch (status) {
    'approved' => AppTheme.success,
    'rejected' => AppTheme.danger,
    _ => const Color(0xFFF59E0B),
  };
}
