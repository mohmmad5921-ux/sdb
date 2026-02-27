import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/transfer_screen.dart';
import 'screens/deposit_screen.dart';
import 'screens/exchange_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/phone_verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const SDBApp());
}

class SDBApp extends StatelessWidget {
  const SDBApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDB Banking',
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/transfer': (_) => const TransferScreen(),
        '/deposit': (_) => const DepositScreen(),
        '/exchange': (_) => const ExchangeScreen(),
        '/notifications': (_) => const NotificationsScreen(),
        '/phone-verify': (_) => const PhoneVerificationScreen(),
      },
    );
  }
}
