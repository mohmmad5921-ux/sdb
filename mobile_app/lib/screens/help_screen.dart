import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String _category = 'account';

  static const _categories = [
    {'key': 'account', 'label': 'حساب', 'labelEn': 'Account'},
    {'key': 'card', 'label': 'بطاقة', 'labelEn': 'Card'},
    {'key': 'transfer', 'label': 'تحويلات', 'labelEn': 'Transfers'},
    {'key': 'security', 'label': 'الأمان', 'labelEn': 'Security'},
  ];

  static const _articles = {
    'account': [
      {
        'title': 'كيفية إنشاء حساب جديد',
        'titleEn': 'How to create a new account',
        'icon': '📱',
        'color': 0xFFE8F5E9,
        'time': '2',
        'content': '''
لإنشاء حساب جديد في SDB:

1. اضغط على "افتح حساب" في أسفل صفحة تسجيل الدخول
2. أدخل اسمك الكامل
3. اختر رمز بلدك وأدخل رقم هاتفك
4. أدخل بريدك الإلكتروني
5. اختر كلمة مرور قوية وأكدها
6. اضغط "إنشاء حساب"

سيتم إرسال رمز تحقق إلى هاتفك لتأكيد حسابك.
''',
      },
      {
        'title': 'كيفية تسجيل الدخول',
        'titleEn': 'How to sign in',
        'icon': '🔐',
        'color': 0xFFF3E5F5,
        'time': '1',
        'content': '''
لتسجيل الدخول:

• عبر البريد الإلكتروني: أدخل بريدك وكلمة المرور
• عبر الهاتف: اختر تبويب "رقم الهاتف" وأدخل رقمك

يمكنك أيضاً استخدام Face ID أو بصمة الإصبع للدخول السريع.
''',
      },
      {
        'title': 'التحقق من الهوية (KYC)',
        'titleEn': 'Identity Verification (KYC)',
        'icon': '🪪',
        'color': 0xFFE3F2FD,
        'time': '3',
        'content': '''
لتفعيل حسابك بالكامل، ستحتاج لإكمال التحقق:

1. صورة هوية سارية (جواز سفر أو بطاقة هوية)
2. صورة شخصية (سيلفي)
3. إثبات عنوان (فاتورة أو كشف حساب)

يتم مراجعة الوثائق خلال 24 ساعة.
''',
      },
    ],
    'card': [
      {
        'title': 'أنواع البطاقات المتاحة',
        'titleEn': 'Available card types',
        'icon': '💳',
        'color': 0xFFFFF3E0,
        'time': '2',
        'content': '''
تقدم SDB ثلاثة أنواع من البطاقات:

• Standard — بطاقة أساسية مجانية
• Premium — ميزات إضافية وحدود أعلى
• Elite — بطاقة معدنية مع مزايا حصرية

يمكنك طلب بطاقتك من تبويب "البطاقات" بعد تفعيل حسابك.
''',
      },
      {
        'title': 'تفعيل البطاقة',
        'titleEn': 'Activate your card',
        'icon': '✅',
        'color': 0xFFE8F5E9,
        'time': '1',
        'content': '''
عند استلام بطاقتك:

1. افتح التطبيق وادخل لحسابك
2. اذهب إلى قسم البطاقات
3. اضغط "تفعيل البطاقة"
4. أدخل آخر 4 أرقام من البطاقة
5. اختر رمز PIN خاص بك
''',
      },
    ],
    'transfer': [
      {
        'title': 'كيفية إرسال تحويل',
        'titleEn': 'How to send money',
        'icon': '💸',
        'color': 0xFFE0F7FA,
        'time': '2',
        'content': '''
لإرسال تحويل:

1. اضغط على "تحويل" من الشاشة الرئيسية
2. أدخل رقم حساب أو IBAN المستلم
3. أدخل المبلغ
4. أضف ملاحظة (اختياري)
5. راجع التفاصيل واضغط "تأكيد"

التحويلات داخل SDB فورية ومجانية!
''',
      },
      {
        'title': 'رسوم التحويلات',
        'titleEn': 'Transfer fees',
        'icon': '📊',
        'color': 0xFFFCE4EC,
        'time': '1',
        'content': '''
• تحويلات داخل SDB: مجانية
• تحويلات SEPA: €0.50
• تحويلات دولية: حسب البلد والعملة

الأسعار والعمولات متاحة في قسم "المزيد" > "الرسوم والعمولات"
''',
      },
    ],
    'security': [
      {
        'title': 'حماية حسابك',
        'titleEn': 'Protect your account',
        'icon': '🛡️',
        'color': 0xFFEDE7F6,
        'time': '2',
        'content': '''
نصائح لحماية حسابك:

• استخدم كلمة مرور قوية وفريدة
• فعّل Face ID أو بصمة الإصبع
• لا تشارك رمز التحقق مع أحد
• تأكد من تحديث التطبيق دائماً

SDB لن يطلب منك كلمة المرور عبر الهاتف أو البريد أبداً.
''',
      },
      {
        'title': 'نسيت كلمة المرور',
        'titleEn': 'Forgot password',
        'icon': '🔑',
        'color': 0xFFFFF8E1,
        'time': '1',
        'content': '''
لاستعادة كلمة المرور:

1. اضغط "نسيت كلمة المرور" في صفحة الدخول
2. أدخل بريدك الإلكتروني المسجل
3. ستصلك رسالة بريدية مع رابط إعادة التعيين
4. اختر كلمة مرور جديدة
''',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final articles = _articles[_category] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_forward_rounded, size: 24, color: Color(0xFF333333)),
              ),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              const Text('تعرّف', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              Text(
                'استكشف الدروس والموارد لمعرفة المزيد حول استخدام SDB Bank.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                textAlign: TextAlign.end,
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // Category tabs
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: _categories.map((cat) {
                final isActive = _category == cat['key'];
                return GestureDetector(
                  onTap: () => setState(() => _category = cat['key']!),
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF1A1A1A) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isActive ? const Color(0xFF1A1A1A) : const Color(0xFFE0E0E0)),
                    ),
                    child: Center(child: Text(
                      cat['label']!,
                      style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : const Color(0xFF666666),
                      ),
                    )),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Articles
          Expanded(child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final article = articles[i];
              return GestureDetector(
                onTap: () => _showArticle(article),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(article['color'] as int),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(children: [
                    // Icon
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Text(article['icon'] as String, style: const TextStyle(fontSize: 24))),
                    ),
                    const SizedBox(width: 14),
                    // Content
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(
                        article['title'] as String,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                        textAlign: TextAlign.end,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${article['time']} دقيقة للقراءة',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ])),
                  ]),
                ),
              );
            },
          )),
        ],
      )),
    );
  }

  void _showArticle(Map<String, dynamic> article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(100))),
          const SizedBox(height: 20),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(article['title'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A))),
                const SizedBox(height: 4),
                Text('${article['time']} دقيقة للقراءة', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ])),
              const SizedBox(width: 14),
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: Color(article['color'] as int),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text(article['icon'] as String, style: const TextStyle(fontSize: 24))),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: const Color(0xFFF0F0F0)),
          const SizedBox(height: 16),
          // Content
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              article['content'] as String,
              style: const TextStyle(fontSize: 15, color: Color(0xFF333333), height: 1.8),
              textDirection: TextDirection.rtl,
            ),
          )),
        ]),
      ),
    );
  }
}
