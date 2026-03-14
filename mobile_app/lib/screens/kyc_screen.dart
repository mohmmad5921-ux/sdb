import '../l10n/app_localizations.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/mrz_parser.dart';
import 'document_scanner_screen.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});
  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  // Steps: 0=docType, 1=scanFront, 2=scanBack, 3=dataReview, 4=selfie, 5=uploading, 6=done
  int _step = 0;
  String _kycStatus = 'pending';
  bool _loading = true;
  String? _error;
  String? _userName;

  String? _docType;
  File? _docFront, _docBack, _selfie;
  String _extractedName = '';
  bool _nameMatched = false;
  bool _faceDetected = false;
  Map<String, String>? _mrzData;
  bool _savingProfile = false;

  final _textRecognizer = TextRecognizer();
  final _faceDetector = FaceDetector(options: FaceDetectorOptions(enableClassification: true, minFaceSize: 0.2));

  @override
  void initState() { super.initState(); _loadStatus(); }

  @override
  void dispose() { _textRecognizer.close(); _faceDetector.close(); super.dispose(); }

  Future<void> _loadStatus() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getKycStatus();
      if (r['success'] == true) {
        final data = r['data'];
        setState(() {
          _kycStatus = data['kyc_status'] ?? 'pending';
          _userName = data['full_name'] ?? '';
        });
      }
      // Fallback: get name from profile if KYC status didn't return it
      if (_userName == null || _userName!.isEmpty) {
        final p = await ApiService.getProfile();
        if (p['success'] == true) {
          // Profile API wraps user data in 'user' key
          final userData = p['data']?['user'] ?? p['data'];
          _userName = userData?['full_name'] ?? '';
        }
      }
    } catch (e) {
      debugPrint('KYC load error: $e');
    }
    setState(() => _loading = false);
  }

  // ─── SCAN DOCUMENT via Scanner ───
  Future<void> _captureDocument(bool isFront) async {
    final result = await Navigator.push<File>(context, MaterialPageRoute(
      builder: (_) => DocumentScannerScreen(docType: _docType!, isFront: isFront),
    ));
    if (result == null) return;
    setState(() {
      if (isFront) _docFront = result; else _docBack = result;
      _error = null;
    });
    if (isFront) await _runOCR(result);
  }

  // ─── OCR + MRZ ───
  Future<void> _runOCR(File imageFile) async {
    try {
      final input = InputImage.fromFilePath(imageFile.path);
      final recognized = await _textRecognizer.processImage(input);
      final text = recognized.text;

      if (text.isEmpty) {
        setState(() { _extractedName = ''; _nameMatched = false; _mrzData = null; });
        return;
      }

      // 1. Try MRZ parsing first (most reliable)
      final mrz = MrzParser.parse(text);
      if (mrz != null) {
        setState(() {
          _mrzData = mrz;
          _extractedName = mrz['full_name'] ?? '';
          _nameMatched = true; // MRZ data is authoritative
        });
        return;
      }

      // 2. Fallback: extract name from visible text
      String found = '';
      final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
      for (final line in lines) {
        if (line.length > 3 && line.length < 60 && RegExp(r'^[A-Za-zÀ-ÿ\s\-]+$').hasMatch(line)) {
          if (line.split(' ').length >= 2) { found = line; break; }
        }
      }
      if (found.isEmpty) {
        for (final line in lines) {
          if (RegExp(r'[ء-ي\s]{4,}').hasMatch(line) && line.split(' ').length >= 2) { found = line; break; }
        }
      }

      setState(() {
        _mrzData = null;
        _extractedName = found;
        if (found.isNotEmpty && _userName != null && _userName!.isNotEmpty) {
          final docParts = found.toLowerCase().split(RegExp(r'[\s,]+'));
          final regParts = _userName!.toLowerCase().split(RegExp(r'[\s,]+'));
          bool firstMatch = false;
          if (docParts.isNotEmpty && regParts.isNotEmpty) {
            firstMatch = docParts.first == regParts.first ||
              docParts.first.contains(regParts.first) ||
              regParts.first.contains(docParts.first);
          }
          int anyMatch = 0;
          for (final p in regParts) {
            if (p.length < 2) continue;
            if (docParts.any((d) => d.contains(p) || p.contains(d))) anyMatch++;
          }
          _nameMatched = firstMatch || anyMatch > 0;
        } else {
          _nameMatched = true;
        }
      });
    } catch (e) {
      debugPrint('OCR error: $e');
      setState(() { _extractedName = ''; _nameMatched = true; _mrzData = null; });
    }
  }

  // ─── Save extracted MRZ data to profile ───
  Future<void> _saveExtractedData() async {
    if (_mrzData == null) return;
    setState(() => _savingProfile = true);
    try {
      final data = <String, dynamic>{};
      if (_mrzData!['nationality']?.isNotEmpty == true) data['nationality'] = _mrzData!['nationality'];
      if (_mrzData!['date_of_birth']?.isNotEmpty == true) data['date_of_birth'] = _mrzData!['date_of_birth'];
      if (_mrzData!['document_number']?.isNotEmpty == true) data['document_number'] = _mrzData!['document_number'];
      if (_mrzData!['document_type']?.isNotEmpty == true) data['document_type'] = _mrzData!['document_type'];
      if (_mrzData!['expiry_date']?.isNotEmpty == true) data['document_expiry'] = _mrzData!['expiry_date'];
      if (_mrzData!['sex']?.isNotEmpty == true) data['sex'] = _mrzData!['sex'];
      if (data.isNotEmpty) {
        await ApiService.updateProfile(data);
      }
    } catch (e) {
      debugPrint('Profile update error: $e');
    }
    setState(() => _savingProfile = false);
  }

  // ─── SELFIE via Scanner ───
  Future<void> _captureSelfie() async {
    final result = await Navigator.push<File>(context, MaterialPageRoute(
      builder: (_) => DocumentScannerScreen(docType: _docType!, isSelfie: true),
    ));
    if (result == null) return;
    setState(() { _selfie = result; _error = null; });
    await _detectFace(result);
  }

  Future<void> _detectFace(File imageFile) async {
    try {
      final input = InputImage.fromFilePath(imageFile.path);
      final faces = await _faceDetector.processImage(input);
      setState(() => _faceDetected = faces.isNotEmpty);
    } catch (e) {
      debugPrint('Face detection error: $e');
      setState(() => _faceDetected = true);
    }
  }

  // ─── UPLOAD ───
  Future<void> _upload() async {
    if (_docFront == null || _selfie == null) {
      setState(() => _error = 'يرجى التقاط جميع الصور المطلوبة');
      return;
    }
    setState(() { _step = 5; _error = null; });
    try {
      final r = await ApiService.uploadKycDocuments(
        idFrontPath: _docFront!.path,
        idBackPath: _docBack?.path ?? _docFront!.path,
        selfiePath: _selfie!.path,
      );
      if (r['success'] == true) {
        setState(() { _step = 6; _kycStatus = 'submitted'; });
        // Auto-redirect to pending screen after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pushReplacementNamed(context, '/pending');
        });
      } else if (r['status'] == 401) {
        // Token expired — redirect to login
        await ApiService.clearToken();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('انتهت الجلسة — يرجى تسجيل الدخول مجدداً'),
            backgroundColor: Colors.orange,
          ));
        }
      } else {
        setState(() { _step = 4; _error = r['data']?['message'] ?? 'فشل الرفع'; });
      }
    } catch (e) {
      setState(() { _step = 4; _error = 'خطأ في الاتصال'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_rounded, color: AppTheme.textPrimary), onPressed: () {
          if (Navigator.canPop(context)) { Navigator.pop(context); } else { Navigator.pushReplacementNamed(context, '/pending'); }
        }),
        title: Text(L10n.of(context).verifyIdentityTitle, style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary, fontSize: 18)),
      ),
      body: SafeArea(child: _loading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
        : _buildCurrentStep()),
    );
  }

  Widget _buildCurrentStep() {
    if (_kycStatus == 'verified') return _buildStatus('✅ هويتك موثّقة', 'تم التحقق بنجاح. يمكنك استخدام جميع الخدمات.', Icons.verified_rounded, AppTheme.success);
    if (_kycStatus == 'submitted' && _step < 5) return _buildStatus('⏳ قيد المراجعة', 'تم إرسال مستنداتك. سيتم إشعارك عند اكتمال التحقق.', Icons.hourglass_top_rounded, const Color(0xFFF59E0B), showResend: true);
    switch (_step) {
      case 0: return _buildDocTypeSelection();
      case 1: return _buildScanStep(true);
      case 2: return _buildScanStep(false);
      case 3: return _mrzData != null ? _buildDataReview() : _buildNameVerification();
      case 4: return _buildSelfieStep();
      case 5: return _buildUploading();
      case 6: return _buildStatus('🎉 تم إرسال المستندات!', 'سيتم مراجعة مستنداتك خلال 24 ساعة.', Icons.check_circle_rounded, AppTheme.success, showBack: true);
      default: return _buildDocTypeSelection();
    }
  }

  // ─── STEP 3 (MRZ): Data Review ───
  Widget _buildDataReview() => SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    _progress(3, 4),
    const SizedBox(height: 24),
    Text(L10n.of(context).documentData, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
    const SizedBox(height: 6),
    Text('تم استخراج البيانات تلقائياً من المستند', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
    const SizedBox(height: 20),

    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
      color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppTheme.success.withValues(alpha: 0.3))),
      child: Row(children: [
        const Icon(Icons.check_circle_rounded, color: AppTheme.success, size: 22),
        const SizedBox(width: 10),
        Expanded(child: Text('تم مسح ${MrzParser.docTypeLabel(_mrzData?['document_type'])} بنجاح ✅',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF166534)))),
      ]),
    ),
    const SizedBox(height: 20),

    // Data cards
    _dataRow('📝', 'الاسم الكامل', _mrzData?['full_name'] ?? '—'),
    _dataRow('🌍', 'الجنسية', _mrzData?['nationality'] ?? '—'),
    _dataRow('📅', 'تاريخ الميلاد', _mrzData?['date_of_birth'] ?? '—'),
    _dataRow('🔢', 'رقم المستند', _mrzData?['document_number'] ?? '—'),
    _dataRow('📄', 'نوع المستند', MrzParser.docTypeLabel(_mrzData?['document_type'])),
    if (_mrzData?['sex']?.isNotEmpty == true)
      _dataRow('👤', 'الجنس', _mrzData!['sex']!),
    if (_mrzData?['expiry_date']?.isNotEmpty == true)
      _dataRow('⏰', 'تاريخ الانتهاء', _mrzData!['expiry_date']!),

    const SizedBox(height: 24),
    _btn(_savingProfile ? 'جاري الحفظ...' : 'تأكيد البيانات والمتابعة', _savingProfile ? null : () async {
      await _saveExtractedData();
      if (mounted) setState(() => _step = 4);
    }),
    const SizedBox(height: 12),
    Center(child: GestureDetector(onTap: () => setState(() => _step = 1),
      child: Text(L10n.of(context).reScanDoc, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary)))),
  ]));

  Widget _dataRow(String emoji, String label, String value) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.border)),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        const SizedBox(height: 2),
        Text(value.isEmpty ? '—' : value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ])),
    ]),
  );

  // ─── STEP 0: Doc Type ───
  Widget _buildDocTypeSelection() => SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Container(padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1E5EFF), Color(0xFF3B82F6)]), borderRadius: BorderRadius.circular(20)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 32),
        const SizedBox(height: 12),
        Text(L10n.of(context).scanDocument, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 4),
        Text('الكاميرا ستمسح مستندك تلقائياً وتتحقق من بياناتك', style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.8))),
      ]),
    ),
    const SizedBox(height: 28),
    Text(L10n.of(context).selectDocType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
    const SizedBox(height: 16),
    _docTypeCard('passport', '🛂', 'جواز السفر', 'Passport'),
    const SizedBox(height: 10),
    _docTypeCard('residence', '🪪', 'بطاقة الإقامة', 'Residence Permit'),
    const SizedBox(height: 10),
    _docTypeCard('license', '🚗', 'رخصة القيادة', 'Driver\'s License'),
    const SizedBox(height: 24),
    _btn(_docType != null ? 'بدء المسح 📷' : L10n.of(context).selectDocType, _docType != null ? () => setState(() => _step = 1) : null),
  ]));

  Widget _docTypeCard(String type, String emoji, String ar, String en) {
    final sel = _docType == type;
    return GestureDetector(onTap: () => setState(() => _docType = type),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: sel ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bgCard, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? AppTheme.primary : AppTheme.border, width: sel ? 2 : 1)),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 32)), const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(ar, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: sel ? AppTheme.primary : AppTheme.textPrimary)),
            Text(en, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
          ])),
          sel ? Container(width: 24, height: 24, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.check, size: 16, color: Colors.white))
          : Container(width: 24, height: 24, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border, width: 2))),
        ])));
  }

  // ─── STEPS 1-2: Scan Doc ───
  Widget _buildScanStep(bool isFront) {
    final file = isFront ? _docFront : _docBack;
    final title = isFront ? 'مسح ${_docName()} — الأمامي' : 'مسح ${_docName()} — الخلفي';

    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _progress(isFront ? 1 : 2, 4),
      const SizedBox(height: 24),
      Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 6),
      Text('اضغط لفتح السكانر — سيتم المسح تلقائياً عند وضع المستند', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
      const SizedBox(height: 24),

      GestureDetector(onTap: () => _captureDocument(isFront), child: Container(height: 220,
        decoration: BoxDecoration(color: file != null ? Colors.transparent : AppTheme.bgMuted, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: file != null ? AppTheme.success : AppTheme.border, width: 2)),
        child: file != null
          ? Stack(children: [
              ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(file, fit: BoxFit.cover, width: double.infinity, height: 220)),
              Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: AppTheme.success, borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check, color: Colors.white, size: 14), SizedBox(width: 4), Text(L10n.of(context).scanComplete, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))]))),
            ])
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.document_scanner_rounded, size: 32, color: AppTheme.primary)),
              const SizedBox(height: 12),
              Text(L10n.of(context).tapToOpenScanner, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
            ]),
      )),

      if (file != null) ...[
        const SizedBox(height: 12),
        Center(child: GestureDetector(onTap: () => _captureDocument(isFront),
          child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.refresh_rounded, size: 16, color: AppTheme.primary), const SizedBox(width: 4),
            Text(L10n.of(context).reScan, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary))]))),
      ],
      if (_error != null) ...[const SizedBox(height: 12), _errorBox(_error!)],
      const Spacer(),
      _btn(file != null ? 'التالي' : 'افتح السكانر أولاً', file != null ? () {
        if (isFront) setState(() => _step = _docType == 'passport' ? 3 : 2);
        else setState(() => _step = 3);
      } : null),
    ]));
  }

  // ─── STEP 3: Name Verification ───
  Widget _buildNameVerification() => Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    _progress(3, 4),
    const SizedBox(height: 24),
    Text(L10n.of(context).nameVerification, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
    const SizedBox(height: 20),
    Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(L10n.of(context).registeredName, style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        const SizedBox(height: 4),
        Text(_userName ?? 'غير متوفر', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        const SizedBox(height: 16),
        Text(L10n.of(context).nameExtracted, style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
        const SizedBox(height: 4),
        Text(_extractedName.isEmpty ? 'لم يتم استخراج اسم' : _extractedName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _extractedName.isEmpty ? AppTheme.textMuted : AppTheme.textPrimary)),
      ])),
    const SizedBox(height: 16),
    Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(
      color: _nameMatched ? const Color(0xFFF0FDF4) : const Color(0xFFFFF7ED), borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _nameMatched ? AppTheme.success.withValues(alpha: 0.3) : const Color(0xFFF59E0B).withValues(alpha: 0.3))),
      child: Row(children: [
        Icon(_nameMatched ? Icons.check_circle_rounded : Icons.warning_rounded, color: _nameMatched ? AppTheme.success : const Color(0xFFF59E0B), size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(_nameMatched ? 'الاسم متطابق ✅' : 'الاسم قد يكون غير مطابق — سيتم المراجعة يدوياً',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _nameMatched ? const Color(0xFF166534) : const Color(0xFF92400E)))),
      ])),
    const Spacer(),
    _btn('التالي — التقاط سيلفي', () => setState(() => _step = 4)),
  ]));

  // ─── STEP 4: Selfie ───
  Widget _buildSelfieStep() => Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    _progress(4, 4),
    const SizedBox(height: 24),
    Text(L10n.of(context).selfieCapture, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
    const SizedBox(height: 6),
    Text('التقط سيلفي واضح للمقارنة مع صورة المستند', style: TextStyle(fontSize: 14, color: AppTheme.textMuted)),
    const SizedBox(height: 24),

    GestureDetector(onTap: _captureSelfie, child: Container(height: 260,
      decoration: BoxDecoration(color: _selfie != null ? Colors.transparent : AppTheme.bgMuted, borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _selfie != null ? AppTheme.success : AppTheme.border, width: 2)),
      child: _selfie != null
        ? Stack(children: [
            ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(_selfie!, fit: BoxFit.cover, width: double.infinity, height: 260)),
            if (_faceDetected) Positioned(top: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppTheme.success, borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.face, color: Colors.white, size: 14), SizedBox(width: 4), Text(L10n.of(context).faceDetected, style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))]))),
          ])
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(40)),
              child: const Icon(Icons.face_rounded, size: 44, color: AppTheme.primary)),
            const SizedBox(height: 12),
            Text(L10n.of(context).tapToOpenCamera, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
          ]),
    )),

    if (_selfie != null) ...[
      const SizedBox(height: 12),
      Center(child: GestureDetector(onTap: _captureSelfie,
        child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.refresh_rounded, size: 16, color: AppTheme.primary), const SizedBox(width: 4),
          Text(L10n.of(context).reCapture, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary))]))),
    ],
    if (_error != null) ...[const SizedBox(height: 12), _errorBox(_error!)],
    const Spacer(),
    _btn(_selfie != null ? 'إرسال المستندات للمراجعة' : 'التقط سيلفي أولاً', _selfie != null ? _upload : null),
  ]));

  // ─── Status / Upload ───
  Widget _buildUploading() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const SizedBox(width: 60, height: 60, child: CircularProgressIndicator(strokeWidth: 4, color: AppTheme.primary)),
    const SizedBox(height: 24),
    Text(L10n.of(context).uploadingDocs, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
  ]));

  Widget _buildStatus(String title, String subtitle, IconData icon, Color color, {bool showResend = false, bool showBack = false}) =>
    Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 100, height: 100, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(30)),
        child: Icon(icon, size: 56, color: color)),
      const SizedBox(height: 24),
      Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppTheme.textPrimary)),
      const SizedBox(height: 12),
      Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.6)),
      if (showResend) ...[const SizedBox(height: 32), SizedBox(width: double.infinity, height: 50, child: OutlinedButton(
        onPressed: () => setState(() { _step = 0; _kycStatus = 'pending'; }),
        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), side: const BorderSide(color: AppTheme.primary)),
        child: Text(L10n.of(context).resubmitDocs, style: TextStyle(fontWeight: FontWeight.w600, color: AppTheme.primary))))],
      if (showBack) ...[const SizedBox(height: 32), SizedBox(width: 200, height: 50, child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
        child: const Text('العودة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))))],
    ]));

  // ─── Shared ───
  Widget _progress(int step, int total) => Row(children: List.generate(total, (i) => Expanded(child: Container(
    height: 4, margin: const EdgeInsets.symmetric(horizontal: 3),
    decoration: BoxDecoration(color: i < step ? AppTheme.primary : AppTheme.border, borderRadius: BorderRadius.circular(2))))));

  Widget _btn(String label, VoidCallback? onTap) {
    final en = onTap != null;
    return GestureDetector(onTap: onTap, child: Container(height: 54,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
        gradient: en ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]) : null, color: en ? null : AppTheme.bgMuted,
        boxShadow: en ? [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 6))] : null),
      child: Center(child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: en ? Colors.white : AppTheme.textMuted)))));
  }

  Widget _errorBox(String msg) => Container(padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: AppTheme.danger.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(12)),
    child: Row(children: [Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 18), const SizedBox(width: 8),
      Expanded(child: Text(msg, style: TextStyle(fontSize: 12, color: AppTheme.danger)))]));

  String _docName() => switch (_docType) { 'passport' => 'جواز السفر', 'residence' => 'بطاقة الإقامة', 'license' => 'رخصة القيادة', _ => 'المستند' };
}
