import 'package:flutter/material.dart';

/// Safe Mother Malawi — Design System Color Tokens
/// Based on "The Clinical Authority" design spec
class AppColors {
  AppColors._();

  // --- Primary Palette ---
  static const Color primary = Color(0xFF003178);
  static const Color primaryContainer = Color(0xFF0D47A1);
  static const Color secondary = Color(0xFF455F87);
  static const Color tertiary = Color(0xFF003D36);
  static const Color accent = Color(0xFF00897B);

  // --- Surface Hierarchy ---
  static const Color pageBg = Color(0xFFF0F6FF);
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);

  // --- On Colors ---
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color headings = Color(0xFF212121);
  static const Color bodyText = Color(0xFF424242);
  static const Color mutedText = Color(0xFF757575);
  static const Color outlineVariant = Color(0x26455F87); // 15% opacity

  // --- Status / Clinical Indicators ---
  static const Color successText = Color(0xFF4CAF50);
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color warningText = Color(0xFFFF9800);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color criticalText = Color(0xFFF44336);
  static const Color criticalBg = Color(0xFFFFEBEE);
  static const Color infoText = Color(0xFF1565C0);
  static const Color infoBg = Color(0xFFE3F2FD);

  // --- Shadow ---
  static const Color shadowColor = Color(0x0F1A2E4A); // 6% navy

  // --- Gradient (Primary CTA) ---
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );

  // --- Sidebar ---
  static const Color sidebarBg = Color(0xFF455F87);
  static const Color sidebarActive = Color(0xFF003178);
  static const Color sidebarText = Color(0xFFE8EEF7);
  static const Color sidebarMuted = Color(0xFFB0BEC5);
}
