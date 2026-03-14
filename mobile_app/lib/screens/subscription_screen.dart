import '../l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'dart:math';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> with TickerProviderStateMixin {
  int _selectedPlan = 1; // Default to Premium
  bool _loading = false;
  String? _error;
  late AnimationController _shimmerCtrl;

  final List<_Plan> _plans = [
    _Plan(
      id: 'basic',
      nameAr: 'أساسي',
      nameEn: 'Basic',
      priceMonthly: 0,
      currency: 'kr',
      icon: Icons.account_balance_wallet_rounded,
      color: const Color(0xFF6B7280),
      features: [
        'محفظة واحدة (DKK)',
        'تحويلات محدودة (5/شهر)',
        'دعم عبر الإيميل',
      ],
      featuresEn: [
        '1 Wallet (DKK)',
        'Limited transfers (5/mo)',
        'Email support',
      ],
    ),
    _Plan(
      id: 'premium',
      nameAr: 'بريميوم',
      nameEn: 'Premium',
      priceMonthly: 29,
      currency: 'kr',
      icon: Icons.diamond_rounded,
      color: const Color(0xFF10B981),
      badge: '⭐ الأكثر شعبية',
      badgeEn: '⭐ Most Popular',
      features: [
        'محافظ متعددة (5 عملات)',
        'تحويلات غير محدودة',
        'بطاقة افتراضية',
        'خدمة الحوالات الدولية',
        'دعم أولوية',
      ],
      featuresEn: [
        'Multi-currency wallets (5)',
        'Unlimited transfers',
        'Virtual card',
        'International remittance',
        'Priority support',
      ],
    ),
    _Plan(
      id: 'vip',
      nameAr: 'VIP',
      nameEn: 'VIP',
      priceMonthly: 79,
      currency: 'kr',
      icon: Icons.workspace_premium_rounded,
      color: const Color(0xFFD97706),
      features: [
        'كل مميزات بريميوم',
        'بطاقة VISA فيزيائية',
        'كاش باك 2%',
        'حوالات مجانية',
        'مدير حساب شخصي',
        'تقارير مالية متقدمة',
      ],
      featuresEn: [
        'All Premium features',
        'Physical VISA card',
        '2% Cashback',
        'Free remittances',
        'Personal account manager',
        'Advanced financial reports',
      ],
    ),
    _Plan(
      id: 'business',
      nameAr: 'أعمال',
      nameEn: 'Business',
      priceMonthly: 149,
      currency: 'kr',
      icon: Icons.business_center_rounded,
      color: const Color(0xFF7C3AED),
      features: [
        'كل مميزات VIP',
        'حسابات شركات',
        'فواتير وإيصالات',
        'محاسبة تلقائية',
        'API للمطورين',
        'دعم 24/7',
      ],
      featuresEn: [
        'All VIP features',
        'Business accounts',
        'Invoicing & receipts',
        'Auto accounting',
        'Developer API',
        '24/7 Support',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  bool get _isArabic => L10n.of(context).navHome == 'الرئيسية';

  Future<void> _subscribe() async {
    final plan = _plans[_selectedPlan];
    
    // Free plan — just activate
    if (plan.priceMonthly == 0) {
      setState(() { _loading = true; _error = null; });
      try {
        final res = await ApiService.subscribeToPlan(plan.id);
        if (res['success'] == true && mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() { _error = res['data']?['message'] ?? 'فشل تفعيل الاشتراك'; _loading = false; });
        }
      } catch (e) {
        setState(() { _error = '$e'; _loading = false; });
      }
      return;
    }

    // Paid plan — use Stripe
    setState(() { _loading = true; _error = null; });
    try {
      final intentRes = await ApiService.createSubscriptionIntent(plan.id);
      if (intentRes['success'] != true) {
        setState(() { _error = intentRes['data']?['message'] ?? 'فشل إنشاء عملية الدفع'; _loading = false; });
        return;
      }

      final clientSecret = intentRes['data']['client_secret'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'SDB Bank',
          style: ThemeMode.light,
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'DK', currencyCode: 'DKK', testEnv: true),
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'DK'),
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: plan.color,
              background: Colors.white,
              componentBackground: const Color(0xFFF5F7FA),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(background: plan.color, text: Colors.white),
              ),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Confirm on backend
      final confirmRes = await ApiService.confirmSubscription(
        intentRes['data']['payment_intent_id'],
        plan.id,
      );

      if (confirmRes['success'] == true && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() { _error = confirmRes['data']?['message'] ?? 'فشل تأكيد الاشتراك'; _loading = false; });
      }
    } on StripeException catch (e) {
      setState(() {
        _error = e.error.code == FailureCode.Canceled ? 'تم إلغاء العملية' : (e.error.localizedMessage ?? 'فشل الدفع');
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = _plans[_selectedPlan];
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(children: [
              // Logo
              Image.asset('assets/images/sdb-logo.png', width: 100, fit: BoxFit.contain),
              const SizedBox(height: 16),
              Text(
                _isArabic ? 'اختر خطتك' : 'Choose Your Plan',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
              const SizedBox(height: 6),
              Text(
                _isArabic ? 'اختر الباقة المناسبة لتفعيل حسابك' : 'Select a plan to activate your account',
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ]),
          ),
          const SizedBox(height: 20),

          // Plan cards (horizontal scroll)
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _plans.length,
              itemBuilder: (context, i) => _buildPlanChip(i),
            ),
          ),
          const SizedBox(height: 16),

          // Plan details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildPlanDetails(plan),
            ),
          ),

          // Bottom CTA
          _buildBottomCTA(plan),
        ]),
      ),
    );
  }

  Widget _buildPlanChip(int index) {
    final p = _plans[index];
    final sel = _selectedPlan == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: sel ? p.color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: sel ? p.color : const Color(0xFFE5E7EB), width: sel ? 2.5 : 1),
          boxShadow: sel ? [BoxShadow(color: p.color.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 4))] : [],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Badge
          if (p.badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: p.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
              child: Text(_isArabic ? p.badge! : (p.badgeEn ?? p.badge!), style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: p.color)),
            ),
            const SizedBox(height: 4),
          ],
          // Icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [p.color.withValues(alpha: 0.2), p.color.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(p.icon, size: 20, color: p.color),
          ),
          const SizedBox(height: 8),
          // Name
          Text(_isArabic ? p.nameAr : p.nameEn, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: sel ? p.color : const Color(0xFF374151))),
          const SizedBox(height: 2),
          // Price
          Text(
            p.priceMonthly == 0 ? (_isArabic ? 'مجاني' : 'Free') : '${p.priceMonthly} ${p.currency}/${_isArabic ? "شهر" : "mo"}',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sel ? p.color : const Color(0xFF9CA3AF)),
          ),
        ]),
      ),
    );
  }

  Widget _buildPlanDetails(_Plan plan) {
    final features = _isArabic ? plan.features : plan.featuresEn;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Plan header card
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [plan.color, plan.color.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: plan.color.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(plan.icon, size: 28, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_isArabic ? plan.nameAr : plan.nameEn, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 2),
              Text(
                plan.priceMonthly == 0
                  ? (_isArabic ? 'مجاناً — بدون رسوم' : 'Free — no charges')
                  : '${plan.priceMonthly} ${plan.currency} / ${_isArabic ? "شهرياً" : "monthly"}',
                style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.85), fontWeight: FontWeight.w500),
              ),
            ])),
          ]),
          if (plan.priceMonthly > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
              child: Text(
                _isArabic ? '${(plan.priceMonthly * 12 * 0.8).toInt()} kr/سنوياً — وفّر 20%' : '${(plan.priceMonthly * 12 * 0.8).toInt()} kr/year — Save 20%',
                style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 20),

      // Features list
      Text(_isArabic ? 'المميزات' : 'Features', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
      const SizedBox(height: 12),
      ...features.map((f) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(children: [
          Container(
            width: 24, height: 24,
            decoration: BoxDecoration(color: plan.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(7)),
            child: Icon(Icons.check_rounded, size: 14, color: plan.color),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(f, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF374151)))),
        ]),
      )),
      const SizedBox(height: 20),

      // Error
      if (_error != null) ...[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFECACA))),
          child: Row(children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(_error!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12, fontWeight: FontWeight.w600))),
          ]),
        ),
        const SizedBox(height: 16),
      ],
    ]);
  }

  Widget _buildBottomCTA(_Plan plan) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Subscribe button
        GestureDetector(
          onTap: _loading ? null : _subscribe,
          child: Container(
            width: double.infinity, height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [plan.color, plan.color.withValues(alpha: 0.8)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: plan.color.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 6))],
            ),
            child: Center(child: _loading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(plan.priceMonthly == 0 ? Icons.rocket_launch_rounded : Icons.lock_rounded, size: 20, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    plan.priceMonthly == 0
                      ? (_isArabic ? 'ابدأ مجاناً' : 'Start Free')
                      : (_isArabic ? 'اشترك الآن — ${plan.priceMonthly} ${plan.currency}/شهر' : 'Subscribe — ${plan.priceMonthly} ${plan.currency}/mo'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ])),
          ),
        ),
        const SizedBox(height: 8),
        // Payment methods hint
        if (plan.priceMonthly > 0)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.credit_card_rounded, size: 14, color: const Color(0xFF9CA3AF)),
            const SizedBox(width: 6),
            Icon(Icons.apple_rounded, size: 16, color: const Color(0xFF9CA3AF)),
            const SizedBox(width: 6),
            Icon(Icons.g_mobiledata_rounded, size: 18, color: const Color(0xFF9CA3AF)),
            const SizedBox(width: 8),
            Text(_isArabic ? 'دفع آمن ومشفر' : 'Secure encrypted payment', style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
          ]),
      ]),
    );
  }
}

class _Plan {
  final String id, nameAr, nameEn, currency;
  final int priceMonthly;
  final IconData icon;
  final Color color;
  final String? badge, badgeEn;
  final List<String> features, featuresEn;

  const _Plan({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.priceMonthly,
    required this.currency,
    required this.icon,
    required this.color,
    required this.features,
    required this.featuresEn,
    this.badge,
    this.badgeEn,
  });
}
