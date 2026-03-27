import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color teal = Color(0xFF1D9E75);
  static const Color tealDark = Color(0xFF085041);
  static const Color tealLight = Color(0xFFE1F5EE);
  static const Color rose = Color(0xFFC2506F);
  static const Color red = Color(0xFFE24B4A);
  static const Color amber = Color(0xFFEF9F27);
  static const Color blue = Color(0xFF378ADD);
  static const Color background = Color(0xFFF7F6F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color outline = Color(0xFFCAC4D0);
  static const Color error = Color(0xFFE24B4A);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      primary: AppColors.teal,
      onPrimary: Colors.white,
      primaryContainer: AppColors.tealLight,
      onPrimaryContainer: AppColors.tealDark,
      secondary: AppColors.rose,
      error: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(),
      cardTheme: _buildCardTheme(),
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Fraunces', fontSize: 57, fontWeight: FontWeight.w400),
      displayMedium: TextStyle(fontFamily: 'Fraunces', fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontFamily: 'Fraunces', fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontFamily: 'Fraunces', fontSize: 32, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontFamily: 'Fraunces', fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontFamily: 'Fraunces', fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontFamily: 'DM Sans', fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontFamily: 'DM Sans', fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: 'DM Sans', fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: 'DM Sans', fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontFamily: 'DM Sans', fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontFamily: 'DM Sans', fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontFamily: 'DM Sans', fontSize: 14, fontWeight: FontWeight.w600),
      labelMedium: TextStyle(fontFamily: 'DM Sans', fontSize: 12, fontWeight: FontWeight.w600),
      labelSmall: TextStyle(fontFamily: 'DM Sans', fontSize: 11, fontWeight: FontWeight.w600),
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.teal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(fontFamily: 'DM Sans', color: AppColors.onSurfaceVariant),
      hintStyle: const TextStyle(fontFamily: 'DM Sans', color: AppColors.onSurfaceVariant),
    );
  }
}
