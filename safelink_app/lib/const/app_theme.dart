import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.light,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightText,
        ),
        cardColor: AppColors.lightCard,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBg,
          surfaceTintColor: AppColors.lightBg,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.lightText),
          titleTextStyle: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        dividerColor: AppColors.lightCard,
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primaryColor
                : AppColors.lightTextSecondary,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primaryColor.withAlpha(80)
                : AppColors.lightCard,
          ),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: Brightness.dark,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkText,
        ),
        cardColor: AppColors.darkCard,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkBg,
          surfaceTintColor: AppColors.darkBg,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.darkText),
          titleTextStyle: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        dividerColor: AppColors.darkCard,
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primaryColor
                : AppColors.darkTextSecondary,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppColors.primaryColor.withAlpha(80)
                : AppColors.darkCard,
          ),
        ),
      );
}