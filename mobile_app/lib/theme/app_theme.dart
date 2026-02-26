import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // SDB Brand Colors
  static const Color primary = Color(0xFF1E5EFF);
  static const Color primaryDark = Color(0xFF0B1F3A);
  static const Color accent = Color(0xFF00C2FF);
  static const Color gold = Color(0xFFC6A75E);
  static const Color success = Color(0xFF10B981);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color bgDark = Color(0xFF060B18);
  static const Color bgCard = Color(0xFF0F1629);
  static const Color bgSurface = Color(0xFF0A0F1F);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color border = Color(0x15FFFFFF);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDark,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: accent,
      surface: bgCard,
      error: danger,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: bgDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primary)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.cairo(color: textMuted, fontSize: 14),
      labelStyle: GoogleFonts.cairo(color: textSecondary, fontSize: 14),
    ),
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: border)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: bgSurface,
      selectedItemColor: primary,
      unselectedItemColor: textMuted,
      type: BottomNavigationBarType.fixed,
      elevation: 20,
    ),
  );
}
