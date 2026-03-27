import 'package:flutter/material.dart';

/// Single source of truth for all colours in Safe Mother Malawi.
///
/// Palette spec:
///   Navigation  #1A2E4A navbar · #1E3A5F sidebar · #2A4A73 selected item
///   Primary     #0D47A1 navy (buttons, footer) · #1565C0 blue headers
///   Light blue  #E3F2FD icon backgrounds · #F0F6FF page background
///   Status      #4CAF50 stable · #FF9800 amber · #F44336 red/critical
///               #9C27B0 purple (pregnant) · #2196F3 blue (active patients)
///   Accent      #00897B green (landing tag, news dates)
///   Greys       #212121 headings · #757575 secondary · #BDBDBD muted
///               #EEEEEE borders · #F5F5F5 card/page bg
class AppColors {
  AppColors._();

  // ── Navigation ────────────────────────────────────────────────────────────
  static const Color navBar       = Color(0xFF1A2E4A);
  static const Color sidebar      = Color(0xFF1E3A5F);
  static const Color sidebarSelected = Color(0xFF2A4A73);

  // ── Primary brand ─────────────────────────────────────────────────────────
  /// Navy — used for app bars, primary buttons, footer.
  static const Color navy         = Color(0xFF0D47A1);
  static const Color navyLight    = Color(0xFF1565C0);

  // ── Teal alias (kept for backward-compat with existing screens) ───────────
  /// Maps to navy so all existing `AppColors.teal` references use the new primary.
  static const Color teal         = navy;
  static const Color tealDark     = navBar;       // #1A2E4A — darkest nav tone
  static const Color tealLight    = Color(0xFFE3F2FD); // light blue icon bg

  // ── Light backgrounds ─────────────────────────────────────────────────────
  static const Color background   = Color(0xFFF0F6FF); // page background
  static const Color surface      = Color(0xFFFFFFFF);
  static const Color cardBg       = Color(0xFFF5F5F5);

  // ── Status colours ────────────────────────────────────────────────────────
  static const Color green        = Color(0xFF4CAF50);
  static const Color greenLight   = Color(0xFFE8F5E9);

  static const Color amber        = Color(0xFFFF9800);
  static const Color amberLight   = Color(0xFFFFF3E0);

  static const Color red          = Color(0xFFF44336);
  static const Color redLight     = Color(0xFFFFEBEE);

  static const Color purple       = Color(0xFF9C27B0);
  static const Color purpleLight  = Color(0xFFF3E5F5);

  static const Color blue         = Color(0xFF2196F3);
  static const Color blueLight    = Color(0xFFE3F2FD);

  // ── Accent ────────────────────────────────────────────────────────────────
  static const Color accent       = Color(0xFF00897B); // landing tag / news dates

  // ── Aliases kept for backward-compat ─────────────────────────────────────
  static const Color rose         = purple;   // postnatal mode chip
  static const Color error        = red;

  // ── Greys ─────────────────────────────────────────────────────────────────
  static const Color onSurface        = Color(0xFF212121); // headings
  static const Color onSurfaceVariant = Color(0xFF757575); // secondary text
  static const Color muted            = Color(0xFFBDBDBD); // placeholder
  static const Color outline          = Color(0xFFEEEEEE); // borders
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      primary: AppColors.navy,
      onPrimary: Colors.white,
      primaryContainer: AppColors.blueLight,
      onPrimaryContainer: AppColors.navBar,
      secondary: AppColors.accent,
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
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.navBar,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Fraunces',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.navy,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      displayLarge:  TextStyle(fontFamily: 'Fraunces', fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      displayMedium: TextStyle(fontFamily: 'Fraunces', fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      displaySmall:  TextStyle(fontFamily: 'Fraunces', fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      headlineLarge: TextStyle(fontFamily: 'Fraunces', fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      headlineMedium:TextStyle(fontFamily: 'Fraunces', fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      headlineSmall: TextStyle(fontFamily: 'Fraunces', fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      titleLarge:    TextStyle(fontFamily: 'DM Sans',  fontSize: 22, fontWeight: FontWeight.w500, color: AppColors.onSurface),
      titleMedium:   TextStyle(fontFamily: 'DM Sans',  fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.onSurface),
      titleSmall:    TextStyle(fontFamily: 'DM Sans',  fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.onSurface),
      bodyLarge:     TextStyle(fontFamily: 'DM Sans',  fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      bodyMedium:    TextStyle(fontFamily: 'DM Sans',  fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.onSurface),
      bodySmall:     TextStyle(fontFamily: 'DM Sans',  fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.onSurfaceVariant),
      labelLarge:    TextStyle(fontFamily: 'DM Sans',  fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      labelMedium:   TextStyle(fontFamily: 'DM Sans',  fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurface),
      labelSmall:    TextStyle(fontFamily: 'DM Sans',  fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
    );
  }

  static CardThemeData _buildCardTheme() {
    return CardThemeData(
      color: AppColors.surface,
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.outline),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navy,
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

  static InputDecorationTheme _buildInputDecorationTheme() {
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
        borderSide: const BorderSide(color: AppColors.navy, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      labelStyle: const TextStyle(fontFamily: 'DM Sans', color: AppColors.onSurfaceVariant),
      hintStyle:  const TextStyle(fontFamily: 'DM Sans', color: AppColors.muted),
    );
  }
}
