import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  String? _selectedLanguage;
  Map<String, String>? _selectedCountry;
  String? _selectedProvince;

  // Total pages: Language(1) + 3 Welcome + Country(1) + Province(0 or 1)
  int get _totalPages => _selectedCountry?['code'] == 'SY' ? 6 : 5;

  // Syria provinces
  static const _syriaProvinces = [
    'دمشق', 'ريف دمشق', 'حلب', 'حمص', 'حماة', 'اللاذقية',
    'طرطوس', 'إدلب', 'دير الزور', 'الرقة', 'الحسكة',
    'درعا', 'السويداء', 'القنيطرة',
  ];

  // Countries with currency
  static const _countries = [
    {'name': 'سوريا', 'nameEn': 'Syria', 'flag': '🇸🇾', 'code': 'SY', 'phone': '+963', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'SYP'},
    {'name': 'لبنان', 'nameEn': 'Lebanon', 'flag': '🇱🇧', 'code': 'LB', 'phone': '+961', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'USD'},
    {'name': 'الأردن', 'nameEn': 'Jordan', 'flag': '🇯🇴', 'code': 'JO', 'phone': '+962', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'JOD'},
    {'name': 'العراق', 'nameEn': 'Iraq', 'flag': '🇮🇶', 'code': 'IQ', 'phone': '+964', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'IQD'},
    {'name': 'السعودية', 'nameEn': 'Saudi Arabia', 'flag': '🇸🇦', 'code': 'SA', 'phone': '+966', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'SAR'},
    {'name': 'الإمارات', 'nameEn': 'UAE', 'flag': '🇦🇪', 'code': 'AE', 'phone': '+971', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'AED'},
    {'name': 'مصر', 'nameEn': 'Egypt', 'flag': '🇪🇬', 'code': 'EG', 'phone': '+20', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'EGP'},
    {'name': 'الكويت', 'nameEn': 'Kuwait', 'flag': '🇰🇼', 'code': 'KW', 'phone': '+965', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'KWD'},
    {'name': 'قطر', 'nameEn': 'Qatar', 'flag': '🇶🇦', 'code': 'QA', 'phone': '+974', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'QAR'},
    {'name': 'البحرين', 'nameEn': 'Bahrain', 'flag': '🇧🇭', 'code': 'BH', 'phone': '+973', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'BHD'},
    {'name': 'عُمان', 'nameEn': 'Oman', 'flag': '🇴🇲', 'code': 'OM', 'phone': '+968', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'OMR'},
    {'name': 'ليبيا', 'nameEn': 'Libya', 'flag': '🇱🇾', 'code': 'LY', 'phone': '+218', 'lang': 'العربية', 'region': 'middle_east', 'currency': 'LYD'},
    {'name': 'الدنمارك', 'nameEn': 'Denmark', 'flag': '🇩🇰', 'code': 'DK', 'phone': '+45', 'lang': 'Dansk', 'region': 'europe', 'currency': 'DKK'},
    {'name': 'ألمانيا', 'nameEn': 'Germany', 'flag': '🇩🇪', 'code': 'DE', 'phone': '+49', 'lang': 'Deutsch', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'السويد', 'nameEn': 'Sweden', 'flag': '🇸🇪', 'code': 'SE', 'phone': '+46', 'lang': 'Svenska', 'region': 'europe', 'currency': 'SEK'},
    {'name': 'النرويج', 'nameEn': 'Norway', 'flag': '🇳🇴', 'code': 'NO', 'phone': '+47', 'lang': 'Norsk', 'region': 'europe', 'currency': 'NOK'},
    {'name': 'هولندا', 'nameEn': 'Netherlands', 'flag': '🇳🇱', 'code': 'NL', 'phone': '+31', 'lang': 'Nederlands', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'فرنسا', 'nameEn': 'France', 'flag': '🇫🇷', 'code': 'FR', 'phone': '+33', 'lang': 'Français', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'بريطانيا', 'nameEn': 'United Kingdom', 'flag': '🇬🇧', 'code': 'GB', 'phone': '+44', 'lang': 'English', 'region': 'europe', 'currency': 'GBP'},
    {'name': 'النمسا', 'nameEn': 'Austria', 'flag': '🇦🇹', 'code': 'AT', 'phone': '+43', 'lang': 'Deutsch', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'سويسرا', 'nameEn': 'Switzerland', 'flag': '🇨🇭', 'code': 'CH', 'phone': '+41', 'lang': 'Deutsch', 'region': 'europe', 'currency': 'CHF'},
    {'name': 'بلجيكا', 'nameEn': 'Belgium', 'flag': '🇧🇪', 'code': 'BE', 'phone': '+32', 'lang': 'Français', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'إيطاليا', 'nameEn': 'Italy', 'flag': '🇮🇹', 'code': 'IT', 'phone': '+39', 'lang': 'Italiano', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'إسبانيا', 'nameEn': 'Spain', 'flag': '🇪🇸', 'code': 'ES', 'phone': '+34', 'lang': 'Español', 'region': 'europe', 'currency': 'EUR'},
    {'name': 'تركيا', 'nameEn': 'Turkey', 'flag': '🇹🇷', 'code': 'TR', 'phone': '+90', 'lang': 'Türkçe', 'region': 'other', 'currency': 'TRY'},
    {'name': 'أمريكا', 'nameEn': 'United States', 'flag': '🇺🇸', 'code': 'US', 'phone': '+1', 'lang': 'English', 'region': 'other', 'currency': 'USD'},
    {'name': 'كندا', 'nameEn': 'Canada', 'flag': '🇨🇦', 'code': 'CA', 'phone': '+1', 'lang': 'English', 'region': 'other', 'currency': 'CAD'},
  ];

  static const _languages = [
    {'name': 'العربية', 'nameEn': 'Arabic', 'flag': '🇸🇾', 'direction': 'rtl'},
    {'name': 'English', 'nameEn': 'English', 'flag': '🇬🇧', 'direction': 'ltr'},
    {'name': 'Dansk', 'nameEn': 'Danish', 'flag': '🇩🇰', 'direction': 'ltr'},
    {'name': 'Deutsch', 'nameEn': 'German', 'flag': '🇩🇪', 'direction': 'ltr'},
    {'name': 'Français', 'nameEn': 'French', 'flag': '🇫🇷', 'direction': 'ltr'},
    {'name': 'Türkçe', 'nameEn': 'Turkish', 'flag': '🇹🇷', 'direction': 'ltr'},
    {'name': 'Svenska', 'nameEn': 'Swedish', 'flag': '🇸🇪', 'direction': 'ltr'},
    {'name': 'Norsk', 'nameEn': 'Norwegian', 'flag': '🇳🇴', 'direction': 'ltr'},
  ];

  // 3 Welcome slides content
  static const _welcomeSlides = [
    {
      'emoji': '💳',
      'titleAr': 'حسابات رقمية',
      'titleEn': 'Digital Accounts',
      'descAr': 'افتح حسابك الرقمي في دقائق من أي مكان في العالم. بطاقات Visa افتراضية وحقيقية.',
      'descEn': 'Open your digital account in minutes from anywhere in the world. Virtual and physical Visa cards.',
    },
    {
      'emoji': '🔄',
      'titleAr': 'تحويلات فورية وآمنة',
      'titleEn': 'Instant & Secure Transfers',
      'descAr': 'أرسل واستقبل الأموال فوراً بأقل العمولات. تحويلات محلية ودولية بسهولة.',
      'descEn': 'Send and receive money instantly with minimal fees. Easy local and international transfers.',
    },
    {
      'emoji': '💰',
      'titleAr': 'صرف عملات وأكثر',
      'titleEn': 'Currency Exchange & More',
      'descAr': 'بدّل بين العملات بأسعار تنافسية. تداول العملات الرقمية والاستفادة من خدماتنا المتنوعة.',
      'descEn': 'Exchange currencies at competitive rates. Trade crypto and enjoy our diverse services.',
    },
  ];

  void _nextPage() {
    if (_page < _totalPages - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _onCountrySelected(Map<String, String> country) {
    setState(() {
      _selectedCountry = country;
      _selectedProvince = null;
    });
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (_selectedLanguage != null) {
      await prefs.setString('app_language', _selectedLanguage!);
      if (mounted) {
        final provider = L10n.providerOf(context);
        provider.setLanguage(_selectedLanguage!);
      }
    }

    if (_selectedCountry != null) {
      await prefs.setString('user_country', _selectedCountry!['nameEn']!);
      await prefs.setString('user_country_code', _selectedCountry!['code']!);
      await prefs.setString('user_phone_code', _selectedCountry!['phone']!);
      await prefs.setString('user_country_flag', _selectedCountry!['flag']!);
      await prefs.setString('user_country_name', _selectedCountry!['name']!);
      await prefs.setString('user_currency', _selectedCountry!['currency']!);
    }

    if (_selectedProvince != null) {
      await prefs.setString('user_province', _selectedProvince!);
    }

    // Clear any old auth tokens so user must log in fresh
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'biometric_enabled');

    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  bool get _isArabic => _selectedLanguage == 'العربية' || _selectedLanguage == null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: List.generate(_totalPages, (i) => Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: i <= _page ? AppTheme.primary : AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
          ),
          // Pages
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _page = i),
              children: [
                // Page 0: Language
                _buildLanguagePage(),
                // Pages 1-3: Welcome slides
                _buildWelcomeSlide(0),
                _buildWelcomeSlide(1),
                _buildWelcomeSlide(2),
                // Page 4: Country
                _buildCountryPage(),
                // Page 5: Province (Syria only)
                if (_totalPages == 6) _buildProvincePage(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // ─── PAGE 0: LANGUAGE ───
  Widget _buildLanguagePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 20),
        const Center(child: Text('🌍', style: TextStyle(fontSize: 48))),
        const SizedBox(height: 16),
        const Center(child: Text('اختر لغتك', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
        const SizedBox(height: 4),
        Center(child: Text('Choose your language', style: TextStyle(fontSize: 15, color: AppTheme.textMuted))),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: _languages.length,
            itemBuilder: (_, i) {
              final lang = _languages[i];
              final isSelected = _selectedLanguage == lang['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedLanguage = lang['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: isSelected ? 2 : 1),
                  ),
                  child: Row(children: [
                    Text(lang['flag']!, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(lang['name']!, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppTheme.primary : AppTheme.textPrimary)),
                      Text(lang['nameEn']!, style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                    ])),
                    if (isSelected)
                      Container(width: 24, height: 24, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.check, size: 16, color: Colors.white))
                    else
                      Container(width: 24, height: 24, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border, width: 2))),
                  ]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildButton(
          _selectedLanguage != null ? 'التالي  ·  Next' : 'اختر لغة  ·  Select a language',
          _selectedLanguage != null ? _nextPage : null,
        ),
        const SizedBox(height: 16),
      ]),
    );
  }

  // ─── PAGES 1-3: WELCOME SLIDES ───
  Widget _buildWelcomeSlide(int index) {
    final slide = _welcomeSlides[index];
    final isLast = index == 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Spacer(flex: 2),
        // Logo on first slide
        if (index == 0) ...[
          Image.asset('assets/images/sdb-logo.png', width: 220, fit: BoxFit.contain),
          const SizedBox(height: 40),
        ],
        // Emoji icon
        Text(slide['emoji']!, style: const TextStyle(fontSize: 64)),
        const SizedBox(height: 24),
        // Title
        Text(
          _isArabic ? slide['titleAr']! : slide['titleEn']!,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        // Description
        Text(
          _isArabic ? slide['descAr']! : slide['descEn']!,
          style: TextStyle(fontSize: 15, color: AppTheme.textMuted, height: 1.7),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        // Slide indicator dots
        Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Container(
          width: i == index ? 24 : 8, height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: i == index ? AppTheme.primary : AppTheme.border,
            borderRadius: BorderRadius.circular(4),
          ),
        ))),
        const Spacer(flex: 3),
        _buildButton(
          isLast ? (_isArabic ? 'اختر دولتك' : 'Choose your country') : (_isArabic ? 'التالي' : 'Next'),
          _nextPage,
        ),
        const SizedBox(height: 24),
      ]),
    );
  }

  // ─── PAGE 4: COUNTRY ───
  Widget _buildCountryPage() {
    final isSyria = _selectedCountry?['code'] == 'SY';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 20),
        const Center(child: Text('📍', style: TextStyle(fontSize: 48))),
        const SizedBox(height: 16),
        Center(child: Text(_isArabic ? 'أين تقيم؟' : 'Where do you live?', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
        const SizedBox(height: 4),
        Center(child: Text(
          _isArabic ? 'في أوروبا ستكون معلوماتك بلغة الدولة' : 'In Europe, your info will be in the country\'s language',
          style: TextStyle(fontSize: 13, color: AppTheme.textMuted), textAlign: TextAlign.center,
        )),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(children: [
            _buildSectionLabel(_isArabic ? '🇪🇺 أوروبا' : '🇪🇺 Europe'),
            ..._countries.where((c) => c['region'] == 'europe').map((c) => _buildCountryTile(c)),
            const SizedBox(height: 12),
            _buildSectionLabel(_isArabic ? '🌍 الشرق الأوسط' : '🌍 Middle East'),
            ..._countries.where((c) => c['region'] == 'middle_east').map((c) => _buildCountryTile(c)),
            const SizedBox(height: 12),
            _buildSectionLabel(_isArabic ? '🌐 أخرى' : '🌐 Other'),
            ..._countries.where((c) => c['region'] == 'other').map((c) => _buildCountryTile(c)),
          ]),
        ),
        const SizedBox(height: 12),
        if (_selectedCountry != null && _selectedCountry!['region'] == 'europe')
          Container(
            padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: const Color(0xFFFEFCE8), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFDE68A))),
            child: Row(children: [
              const Text('ℹ️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(child: Text(
                _isArabic
                  ? 'بما أنك في ${_selectedCountry!['name']}, معلوماتك ستكون باللغة ${_selectedCountry!['lang']}'
                  : 'Since you\'re in ${_selectedCountry!['nameEn']}, your info will be in ${_selectedCountry!['lang']}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF92400E), height: 1.4),
              )),
            ]),
          ),
        _buildButton(
          _selectedCountry != null
            ? (isSyria
                ? (_isArabic ? 'التالي — اختيار المحافظة' : 'Next — Select Province')
                : (_isArabic ? 'متابعة' : 'Continue'))
            : (_isArabic ? 'اختر دولتك' : 'Select your country'),
          _selectedCountry != null ? (isSyria ? _nextPage : _complete) : null,
        ),
        const SizedBox(height: 16),
      ]),
    );
  }

  // ─── PAGE 5: SYRIA PROVINCES ───
  Widget _buildProvincePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 20),
        const Center(child: Text('🇸🇾', style: TextStyle(fontSize: 48))),
        const SizedBox(height: 16),
        Center(child: Text(_isArabic ? 'اختر محافظتك' : 'Select your province', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.textPrimary))),
        const SizedBox(height: 4),
        Center(child: Text(_isArabic ? 'المحافظة التي تقيم فيها' : 'The province where you live', style: TextStyle(fontSize: 13, color: AppTheme.textMuted))),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: _syriaProvinces.length,
            itemBuilder: (_, i) {
              final province = _syriaProvinces[i];
              final isSelected = _selectedProvince == province;
              return GestureDetector(
                onTap: () => setState(() => _selectedProvince = province),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bgCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: isSelected ? 2 : 1),
                  ),
                  child: Row(children: [
                    const Text('🏙️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(province, style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppTheme.primary : AppTheme.textPrimary))),
                    if (isSelected)
                      Container(width: 22, height: 22, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.check, size: 14, color: Colors.white))
                    else
                      Container(width: 22, height: 22, decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppTheme.border, width: 2))),
                  ]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _buildButton(
          _selectedProvince != null ? (_isArabic ? 'متابعة' : 'Continue') : (_isArabic ? 'اختر محافظتك' : 'Select your province'),
          _selectedProvince != null ? _complete : null,
        ),
        const SizedBox(height: 16),
      ]),
    );
  }

  // ─── Shared widgets ───
  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMuted)),
    );
  }

  Widget _buildCountryTile(Map<String, String> country) {
    final isSelected = _selectedCountry?['code'] == country['code'];
    return GestureDetector(
      onTap: () => _onCountrySelected(country),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.06) : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.border, width: isSelected ? 2 : 1),
        ),
        child: Row(children: [
          Text(country['flag']!, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_isArabic ? country['name']! : country['nameEn']!, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? AppTheme.primary : AppTheme.textPrimary)),
            if (country['region'] == 'europe')
              Text(country['lang']!, style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
          ])),
          if (isSelected)
            Container(width: 22, height: 22, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.check, size: 14, color: Colors.white))
          else
            Container(width: 22, height: 22, decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: AppTheme.border, width: 2))),
        ]),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: enabled ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]) : null,
          color: enabled ? null : AppTheme.bgMuted,
          boxShadow: enabled ? [BoxShadow(color: const Color(0xFF10B981).withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 8))] : null,
        ),
        child: Center(child: Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: enabled ? Colors.white : AppTheme.textMuted))),
      ),
    );
  }
}

/// Check if onboarding has been completed
Future<bool> isOnboardingCompleted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_completed') ?? false;
}
