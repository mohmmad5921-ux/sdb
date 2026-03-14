import '../l10n/app_localizations.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class DocumentScannerScreen extends StatefulWidget {
  final String docType;
  final bool isFront;
  final bool isSelfie;

  const DocumentScannerScreen({
    super.key,
    required this.docType,
    this.isFront = true,
    this.isSelfie = false,
  });

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isCaptured = false;
  bool _autoDetecting = true;
  File? _capturedImage;
  String? _error;
  String _statusText = 'جاري التحضير...';

  double _scanLinePos = 0;
  bool _scanDown = true;
  Timer? _scanTimer;

  final _textRecognizer = TextRecognizer();
  int _textDetectCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _startScanAnimation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scanTimer?.cancel();
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  void _startScanAnimation() {
    _scanTimer = Timer.periodic(const Duration(milliseconds: 25), (_) {
      if (!mounted || _isCaptured) return;
      setState(() {
        if (_scanDown) {
          _scanLinePos += 1.5;
          if (_scanLinePos >= 100) _scanDown = false;
        } else {
          _scanLinePos -= 1.5;
          if (_scanLinePos <= 0) _scanDown = true;
        }
      });
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = 'لم يتم العثور على كاميرا');
        return;
      }

      final camera = widget.isSelfie
        ? cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front, orElse: () => cameras.first)
        : cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);

      _controller = CameraController(camera, ResolutionPreset.high, enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
      await _controller!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _statusText = widget.isSelfie ? 'ضع وجهك داخل الإطار' : 'وجّه الكاميرا نحو المستند';
        });
        if (!widget.isSelfie) _startAutoDetection();
      }
    } catch (e) {
      setState(() => _error = 'فشل تشغيل الكاميرا');
    }
  }

  void _startAutoDetection() async {
    while (mounted && !_isCaptured && _autoDetecting) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted || _isCaptured || !_autoDetecting) break;
      if (_controller == null || !_controller!.value.isInitialized || _isProcessing) continue;

      try {
        _isProcessing = true;
        final xFile = await _controller!.takePicture();
        final inputImage = InputImage.fromFilePath(xFile.path);
        final recognized = await _textRecognizer.processImage(inputImage);

        final wordCount = recognized.text.split(RegExp(r'\s+')).where((w) => w.length > 2).length;

        if (wordCount >= 5) {
          _textDetectCount++;
          if (mounted) setState(() => _statusText = 'تم اكتشاف مستند... جاري المسح');
        } else {
          _textDetectCount = 0;
          if (mounted) setState(() => _statusText = 'وجّه الكاميرا نحو المستند');
        }

        if (_textDetectCount >= 2) {
          _autoDetecting = false;
          final file = File(xFile.path);
          if (mounted) {
            setState(() {
              _capturedImage = file;
              _isCaptured = true;
              _statusText = 'تم المسح!';
            });
          }
          break;
        } else {
          try { File(xFile.path).deleteSync(); } catch (_) {}
        }

        _isProcessing = false;
      } catch (e) {
        _isProcessing = false;
      }
    }
  }

  Future<void> _manualCapture() async {
    if (_isProcessing || _controller == null || !_controller!.value.isInitialized) return;
    setState(() { _isProcessing = true; _statusText = 'جاري التقاط الصورة...'; });

    try {
      _autoDetecting = false;
      final xFile = await _controller!.takePicture();
      final file = File(xFile.path);
      setState(() {
        _capturedImage = file;
        _isCaptured = true;
        _isProcessing = false;
        _statusText = 'تم المسح!';
      });
    } catch (e) {
      setState(() { _isProcessing = false; _statusText = 'فشل التقاط الصورة'; });
    }
  }

  void _retake() {
    setState(() {
      _capturedImage = null;
      _isCaptured = false;
      _autoDetecting = true;
      _textDetectCount = 0;
      _scanLinePos = 0;
      _scanDown = true;
      _statusText = widget.isSelfie ? 'ضع وجهك داخل الإطار' : 'وجّه الكاميرا نحو المستند';
    });
    if (!widget.isSelfie) _startAutoDetection();
  }

  void _confirm() {
    if (_capturedImage != null) Navigator.pop(context, _capturedImage);
  }

  String get _title {
    if (widget.isSelfie) return 'صورة سيلفي';
    final doc = switch (widget.docType) {
      'passport' => 'جواز السفر',
      'residence' => 'بطاقة الإقامة',
      'license' => 'رخصة القيادة',
      _ => 'المستند',
    };
    return widget.isFront ? 'مسح $doc' : 'مسح الوجه الخلفي';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        if (_isInitialized && _controller != null && !_isCaptured)
          Positioned.fill(child: ClipRect(child: FittedBox(fit: BoxFit.cover, child: SizedBox(
            width: _controller!.value.previewSize?.height ?? 1920,
            height: _controller!.value.previewSize?.width ?? 1080,
            child: CameraPreview(_controller!),
          )))),

        if (_isCaptured && _capturedImage != null)
          Positioned.fill(child: Image.file(_capturedImage!, fit: BoxFit.cover)),

        if (!_isCaptured)
          Positioned.fill(child: CustomPaint(
            painter: widget.isSelfie ? _SelfiePainter() : _ScannerPainter(_scanLinePos / 100),
          )),

        if (_error != null)
          Center(child: Container(
            margin: const EdgeInsets.all(40), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(16)),
            child: Text(_error!, style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
          )),

        // Top Bar
        Positioned(top: 0, left: 0, right: 0, child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.close_rounded, color: Colors.white, size: 22)),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
              child: Text(_title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
            const Spacer(),
            const SizedBox(width: 40),
          ]),
        ))),

        // Status
        Positioned(
          top: MediaQuery.of(context).padding.top + 60, left: 0, right: 0,
          child: Center(child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(_statusText),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: _isCaptured ? const Color(0xFF10B981).withValues(alpha: 0.85) : Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (_isCaptured) ...[const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18), const SizedBox(width: 6)],
                Text(_statusText, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ),
          )),
        ),

        // Bottom
        Positioned(bottom: 0, left: 0, right: 0, child: SafeArea(child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isCaptured ? _buildConfirm() : _buildCapture(),
        ))),
      ]),
    );
  }

  Widget _buildCapture() => Column(mainAxisSize: MainAxisSize.min, children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: _autoDetecting ? const Color(0xFF10B981) : Colors.orange, borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 8),
      Text(_autoDetecting ? 'المسح التلقائي مفعّل' : 'اضغط للمسح يدوياً',
        style: TextStyle(color: _autoDetecting ? const Color(0xFF10B981) : Colors.orange, fontSize: 12, fontWeight: FontWeight.w600)),
    ]),
    const SizedBox(height: 16),
    GestureDetector(
      onTap: _isProcessing ? null : _manualCapture,
      child: Container(width: 76, height: 76,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(38), border: Border.all(color: Colors.white, width: 4)),
        child: Center(child: Container(width: 62, height: 62,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(31)),
          child: _isProcessing
            ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white)))
            : const Icon(Icons.camera_rounded, color: Colors.white, size: 28),
        )),
      ),
    ),
    const SizedBox(height: 8),
    Text('أو اضغط للتصوير يدوياً', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
  ]);

  Widget _buildConfirm() => Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(16)),
      child: const Text('هل الصورة والمعلومات واضحة؟', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
    ),
    const SizedBox(height: 16),
    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      GestureDetector(
        onTap: _retake,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
          child: const Row(children: [Icon(Icons.refresh_rounded, color: Colors.white, size: 20), SizedBox(width: 8), Text('إعادة التصوير', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600))]),
        ),
      ),
      GestureDetector(
        onTap: _confirm,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: const Row(children: [Icon(Icons.check_rounded, color: Colors.white, size: 20), SizedBox(width: 8), Text('نعم، واضحة', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))]),
        ),
      ),
    ]),
  ]);
}

// ─── Document Scanner Frame ───
class _ScannerPainter extends CustomPainter {
  final double progress;
  _ScannerPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final fw = w * 0.88, fh = fw * 0.63;
    final l = (w - fw) / 2, t = (h - fh) / 2 - 40;
    final r = l + fw, b = t + fh;
    final rect = Rect.fromLTRB(l, t, r, b);

    canvas.drawPath(Path.combine(PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, w, h)),
      Path()..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)))),
      Paint()..color = Colors.black.withValues(alpha: 0.55));

    final bp = Paint()..color = const Color(0xFF10B981)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    const cl = 30.0, cr = 16.0;
    canvas.drawPath(Path()..moveTo(l, t + cl)..lineTo(l, t + cr)..arcToPoint(Offset(l + cr, t), radius: const Radius.circular(cr))..lineTo(l + cl, t), bp);
    canvas.drawPath(Path()..moveTo(r - cl, t)..lineTo(r - cr, t)..arcToPoint(Offset(r, t + cr), radius: const Radius.circular(cr))..lineTo(r, t + cl), bp);
    canvas.drawPath(Path()..moveTo(l, b - cl)..lineTo(l, b - cr)..arcToPoint(Offset(l + cr, b), radius: const Radius.circular(cr))..lineTo(l + cl, b), bp);
    canvas.drawPath(Path()..moveTo(r - cl, b)..lineTo(r - cr, b)..arcToPoint(Offset(r, b - cr), radius: const Radius.circular(cr))..lineTo(r, b - cl), bp);

    final sy = t + (fh * progress);
    canvas.drawLine(Offset(l + 8, sy), Offset(r - 8, sy), Paint()
      ..shader = LinearGradient(colors: [const Color(0xFF10B981).withValues(alpha: 0), const Color(0xFF10B981).withValues(alpha: 0.8), const Color(0xFF10B981).withValues(alpha: 0)])
        .createShader(Rect.fromLTRB(l + 8, sy - 1, r - 8, sy + 1))..strokeWidth = 2);

    canvas.drawRect(Rect.fromLTRB(l + 8, sy - 25, r - 8, sy + 3), Paint()
      ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [const Color(0xFF10B981).withValues(alpha: 0), const Color(0xFF10B981).withValues(alpha: 0.1), const Color(0xFF10B981).withValues(alpha: 0)])
        .createShader(Rect.fromLTRB(l + 8, sy - 25, r - 8, sy + 3)));
  }

  @override
  bool shouldRepaint(covariant _ScannerPainter old) => old.progress != progress;
}

// ─── Selfie Frame ───
class _SelfiePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cr = w * 0.35;
    final c = Offset(w / 2, h / 2 - 60);

    canvas.drawPath(Path.combine(PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, w, h)),
      Path()..addOval(Rect.fromCircle(center: c, radius: cr))),
      Paint()..color = Colors.black.withValues(alpha: 0.6));
    canvas.drawCircle(c, cr, Paint()..color = const Color(0xFF10B981)..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawCircle(c, cr - 10, Paint()..color = Colors.white.withValues(alpha: 0.2)..style = PaintingStyle.stroke..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
