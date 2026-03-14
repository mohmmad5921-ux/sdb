import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});
  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _loading) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _loading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final history = _messages.sublist(0, _messages.length - 1);
    final result = await ApiService.aiChat(text, history);

    setState(() {
      _messages.add({'role': 'assistant', 'content': result['reply'] ?? 'حدث خطأ، حاول مرة أخرى'});
      _loading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _askSuggestion(String q) {
    _controller.text = q;
    _send();
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
            child: const Center(child: Text('🤖', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('SDB AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(L10n.of(context).yourSmartAssistant, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 22),
            onPressed: () => setState(() => _messages.clear()),
            tooltip: 'مسح المحادثة',
          ),
        ],
      ),
      body: Column(children: [
        // Chat body
        Expanded(
          child: _messages.isEmpty ? _buildWelcome() : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length + (_loading ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == _messages.length && _loading) return _buildTyping();
              return _buildMessage(_messages[i]);
            },
          ),
        ),
        // Input bar
        _buildInput(),
      ]),
    );
  }

  Widget _buildWelcome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        const SizedBox(height: 40),
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Center(child: Text('🤖', style: TextStyle(fontSize: 40))),
        ),
        const SizedBox(height: 16),
        Text(L10n.of(context).welcomeToAI, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        const Text('مساعدك الذكي لكل ما يخص حسابك البنكي', style: TextStyle(fontSize: 13, color: AppTheme.textMuted), textAlign: TextAlign.center),
        const SizedBox(height: 28),
        _buildSuggestion('💰', 'كم رصيدي؟', 'كم رصيدي الحالي؟'),
        _buildSuggestion('📊', 'آخر المعاملات', 'اعرض لي آخر المعاملات'),
        _buildSuggestion('💳', 'بطاقاتي', 'ما هي بطاقاتي؟'),
        _buildSuggestion('🪪', 'حالة الحساب', 'ما هي حالة حسابي والتحقق؟'),
        _buildSuggestion('💱', 'العملات المتاحة', 'ما هي العملات المتاحة؟'),
        _buildSuggestion('📱', 'كيف أحوّل فلوس؟', 'كيف أحوّل فلوس لشخص آخر؟'),
      ]),
    );
  }

  Widget _buildSuggestion(String icon, String title, String query) {
    return GestureDetector(
      onTap: () => _askSuggestion(query),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary))),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
        ]),
      ),
    );
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : AppTheme.bgCard,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Text(
          msg['content'] ?? '',
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: isUser ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTyping() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _buildDot(0), const SizedBox(width: 4),
          _buildDot(200), const SizedBox(width: 4),
          _buildDot(400),
        ]),
      ),
    );
  }

  Widget _buildDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      builder: (_, v, child) => Opacity(opacity: 0.3 + 0.7 * v, child: child),
      child: Container(
        width: 8, height: 8,
        decoration: BoxDecoration(color: AppTheme.textMuted, borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 12, right: 12, top: 10,
        bottom: 10 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'اكتب سؤالك...',
              hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
              filled: true,
              fillColor: AppTheme.bgLight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: AppTheme.primary, width: 1.5)),
            ),
            onSubmitted: (_) => _send(),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _send,
          child: Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _loading ? Icons.hourglass_top_rounded : Icons.send_rounded,
              color: Colors.white, size: 22,
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
