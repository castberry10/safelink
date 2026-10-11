import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primaryColor = Color(0xFF667AE9);
  static const Color red = Color(0xFFFF4141);

  // ── Light mode ──────────────────────────────────
  /// Scaffold background: soft lavender-white
  static const Color lightBg = Color(0xFFF5F5FA);

  /// Card / surface background
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Secondary card background
  static const Color lightCard = Color(0xFFEDEDF5);

  /// Body text
  static const Color lightText = Color(0xFF1A1A2E);

  /// Secondary text
  static const Color lightTextSecondary = Color(0xFF8D8E98);

  // ── Dark mode ──────────────────────────────────
  /// Scaffold background: deep navy
  static const Color darkBg = Color(0xFF0F0F17);

  /// Card / surface background
  static const Color darkSurface = Color(0xFF1A1A28);

  /// Secondary card background
  static const Color darkCard = Color(0xFF252538);

  /// Body text
  static const Color darkText = Color(0xFFE4E4F0);

  /// Secondary text
  static const Color darkTextSecondary = Color(0xFF9090A8);

  // ── Legacy aliases ──────────────────────────────
  static const Color white = lightSurface;
  static const Color whiteGray = lightCard;
  static const Color black = lightText;
  static const Color gray = lightTextSecondary;
  static const Color whiteBlue = Color(0xFFECEDFD);
}

/// BuildContext extension: single-line access to theme-aware colors
extension AppThemeExt on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Scaffold background color
  Color get bgColor =>
      isDark ? AppColors.darkBg : AppColors.lightBg;

  /// Card / surface background color
  Color get surfaceColor =>
      isDark ? AppColors.darkSurface : AppColors.lightSurface;

  /// Secondary card background color
  Color get cardColor =>
      isDark ? AppColors.darkCard : AppColors.lightCard;

  /// Body text color
  Color get textColor =>
      isDark ? AppColors.darkText : AppColors.lightText;

  /// Secondary text color
  Color get textSecondaryColor =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get primaryColor => AppColors.primaryColor;
}