import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = false;
  bool _sending = false;
  bool _adminActive = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    // Poll for new messages every 5 seconds (for admin replies)
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _loadMessages(silent: true));
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    try {
      final res = await ApiService.getSupportMessages();
      if (res['success'] == true && mounted) {
        final msgs = (res['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final hadMessages = _messages.length;
        setState(() {
          _messages = msgs;
          _loading = false;
        });
        if (msgs.length > hadMessages) _scrollToBottom();
      } else if (mounted) {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    _controller.clear();

    // Optimistic add
    setState(() {
      _sending = true;
      _messages.add({'sender_type': 'user', 'content': text, 'created_at': DateTime.now().toIso8601String()});
    });
    _scrollToBottom();

    try {
      final res = await ApiService.sendSupportMessage(text);
      if (res['success'] == true && mounted) {
        final aiReply = res['ai_reply'] as Map<String, dynamic>?;
        setState(() {
          _adminActive = res['admin_active'] == true;
          if (aiReply != null) {
            _messages.add(aiReply);
          }
          _sending = false;
        });
        _scrollToBottom();
      } else {
        if (mounted) setState(() => _sending = false);
      }
    } catch (e) {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(child: Text('💬', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('الدعم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(
              _adminActive ? '👤 موظف متصل' : '🤖 SDB AI',
              style: const TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ]),
        ]),
      ),
      body: Column(children: [
        // Admin takeover banner
        if (_adminActive)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
            child: const Row(children: [
              Icon(Icons.person_rounded, color: Color(0xFF3B82F6), size: 18),
              SizedBox(width: 8),
              Text('تم تحويلك لموظف دعم', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ),

        // Chat messages
        Expanded(
          child: _loading && _messages.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : _messages.isEmpty ? _buildWelcome() : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_sending ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length && _sending) return _buildTyping();
                return _buildMessage(_messages[i]);
              },
            ),
        ),

        // Input bar
        _buildInput(),
      ]),
    );
  }

  Widget _buildWelcome() => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(children: [
      const SizedBox(height: 40),
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Center(child: Text('💬', style: TextStyle(fontSize: 40))),
      ),
      const SizedBox(height: 16),
      const Text('مرحباً بك في الدعم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
      const SizedBox(height: 8),
      const Text('اسأل أي سؤال — سيجيبك مساعدنا الذكي\nأو سيتولى موظف الرد عليك', style: TextStyle(fontSize: 13, color: AppTheme.textMuted), textAlign: TextAlign.center),
      const SizedBox(height: 28),
      _buildSuggestion('❓', 'متى يتم تفعيل حسابي؟'),
      _buildSuggestion('📄', 'ما المستندات المطلوبة؟'),
      _buildSuggestion('💳', 'كيف أحصل على بطاقة؟'),
      _buildSuggestion('🔒', 'هل بياناتي آمنة؟'),
    ]),
  );

  Widget _buildSuggestion(String icon, String text) => GestureDetector(
    onTap: () { _controller.text = text; _send(); },
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
      ]),
    ),
  );

  Widget _buildMessage(Map<String, dynamic> msg) {
    final type = msg['sender_type'] ?? 'user';
    final isUser = type == 'user';
    final isAdmin = type == 'admin';
    final senderName = isUser ? null : (isAdmin ? '👤 ${msg['sender_name'] ?? 'موظف'}' : '🤖 SDB AI');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
        if (senderName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(senderName, style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600,
              color: isAdmin ? const Color(0xFF3B82F6) : AppTheme.primary,
            )),
          ),
        Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: BoxDecoration(
              color: isUser ? AppTheme.primary : (isAdmin ? const Color(0xFF3B82F6).withValues(alpha: 0.1) : AppTheme.bgCard),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: isAdmin ? Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)) : null,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Text(msg['content'] ?? '', style: TextStyle(
              fontSize: 14, height: 1.5,
              color: isUser ? Colors.white : AppTheme.textPrimary,
            )),
          ),
        ),
      ]),
    );
  }

  Widget _buildTyping() => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(16)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _dot(0), const SizedBox(width: 4), _dot(200), const SizedBox(width: 4), _dot(400),
      ]),
    ),
  );

  Widget _dot(int delay) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: Duration(milliseconds: 600 + delay),
    builder: (_, v, child) => Opacity(opacity: 0.3 + 0.7 * v, child: child),
    child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppTheme.textMuted, borderRadius: BorderRadius.circular(4))),
  );

  Widget _buildInput() => Container(
    padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10 + MediaQuery.of(context).padding.bottom),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
    ),
    child: Row(children: [
      Expanded(child: TextField(
        controller: _controller,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'اكتب رسالتك...',
          hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
          filled: true, fillColor: AppTheme.bgLight,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.primary, width: 1.5)),
        ),
        onSubmitted: (_) => _send(),
      )),
      const SizedBox(width: 8),
      GestureDetector(
        onTap: _send,
        child: Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)]),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(_sending ? Icons.hourglass_top_rounded : Icons.send_rounded, color: Colors.white, size: 22),
        ),
      ),
    ]),
  );
}
