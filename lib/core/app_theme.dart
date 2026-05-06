import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static const Color sage = Color(0xFF8DAA91);
  static const Color darkGreen = Color(0xFF264D3C);
  static const Color cream = Color(0xFFFFFAF0);
  static const Color softAmber = Color(0xFFF2B84B);
  static const Color tomato = Color(0xFFD96C4A);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.light,
      primary: darkGreen,
      secondary: sage,
      tertiary: softAmber,
      surface: const Color(0xFFFFFCF6),
      error: tomato,
    );

    final textTheme = GoogleFonts.nunitoSansTextTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: cream,
        foregroundColor: darkGreen,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: darkGreen,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: darkGreen.withValues(alpha: 0.08)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF3EBD9),
        selectedColor: sage.withValues(alpha: 0.28),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        side: BorderSide.none,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: darkGreen.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: darkGreen.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkGreen, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFFFFCF6),
        indicatorColor: sage.withValues(alpha: 0.24),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
