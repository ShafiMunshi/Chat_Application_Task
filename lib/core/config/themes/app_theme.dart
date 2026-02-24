import 'package:chat_application_task/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  // ── ThemeData ──────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      background: AppColors.background,
      surface: AppColors.surface,
      primary: AppColors.accent,
      error: AppColors.error,
    ),
    fontFamily: 'DMSans',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    dividerColor: AppColors.divider,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
