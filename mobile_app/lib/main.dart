import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/exchange_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/phone_verification_screen.dart';
import 'screens/kyc_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/help_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/qr_profile_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/app_settings_screen.dart';
import 'screens/pending_account_screen.dart';
import 'screens/support_chat_screen.dart';
import 'services/push_notification_service.dart';

/// Global navigator key for push notification navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51T5ScmC6o4Je50IeP0X3wvj9LZgDrtb3v6EKMwglmipSWSO6QqPKjcF1Ar6TGjHzcOArefoHkmVpXcgX4LteVk2T00PtXsDSeK';
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
  ));

  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    debugPrint('🔴 Flutter Error: ${details.exceptionAsString()}');
    debugPrint('🔴 Stack: ${details.stack}');
    FlutterError.presentError(details);
  };

  runApp(const SDBApp());
}

class SDBApp extends StatefulWidget {
  const SDBApp({super.key});
  @override
  State<SDBApp> createState() => _SDBAppState();
}

class _SDBAppState extends State<SDBApp> {
  final _localeProvider = LocaleProvider();

  @override
  void initState() {
    super.initState();
    _localeProvider.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _localeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return L10n(
      strings: _localeProvider.strings,
      provider: _localeProvider,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'SDB Banking',
        theme: AppTheme.darkTheme,
        locale: _localeProvider.locale,
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/transfer': (_) => const TransferScreen(),
          '/deposit': (_) => const DepositScreen(),
          '/exchange': (_) => const ExchangeScreen(),
          '/notifications': (_) => const NotificationsScreen(),
          '/phone-verify': (_) => const PhoneVerificationScreen(),
          '/kyc': (_) => const KycScreen(),
          '/help': (_) => const HelpScreen(),
          '/contacts': (_) => const ContactsScreen(),
          '/qr': (_) => const QrProfileScreen(),
          '/ai-chat': (_) => const AiChatScreen(),
          '/explore': (_) => const ExploreScreen(),
          '/app-settings': (_) => const AppSettingsScreen(),
          '/pending': (_) => const PendingAccountScreen(),
          '/support-chat': (_) => const SupportChatScreen(),
        },
      ),
    );
  }
}
