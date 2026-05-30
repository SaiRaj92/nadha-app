import 'package:flutter/material.dart';

class AppTheme {
  static const Color bg = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF13131A);
  static const Color card = Color(0xFF1C1C26);
  static const Color accent = Color(0xFFFFB347);
  static const Color accentSoft = Color(0xFFFFD580);
  static const Color her = Color(0xFF1C1C26);
  static const Color mine = Color(0xFF2A1F0E);
  static const Color textPrimary = Color(0xFFF5F0E8);
  static const Color textSecondary = Color(0xFF9B9BA8);
  static const Color online = Color(0xFF4ADE80);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      fontFamily: 'serif',
      colorScheme: const ColorScheme.dark(
        primary: accent,
        surface: surface,
        background: bg,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
