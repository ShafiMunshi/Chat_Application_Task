import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF6200EE);

  static const Color grey = Colors.grey;
  static const Color greyShade400 = Color(0xFFBDBDBD);
  static const Color greyShade50 = Color(0xFFFAFAFA);
  static const Color greyShade300 = Color(0xFFE0E0E0);
  static const Color blue = Colors.blue;

  static const Color red = Colors.red;

  // ── Palette ────────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0D0F1A);
  static const Color surface = Color(0xFF141624);
  static const Color bubbleSurface = Color(0xFF1C1F33);
  static const Color inputBackground = Color(0xFF1A1D2E);

  static const Color accent = Color(0xFF6C72FF);
  static const Color accentDeep = Color(0xFF9747FF);
  static const Color error = Color(0xFFFF5A5A);
  static const Color online = Color(0xFF4ADBA2);
  static const Color success = Color(0xFF4ADBA2);

  static const Color textPrimary = Color(0xFFF0F2FF);
  static const Color textSecondary = Color(0xFFB0B5D8);
  static const Color textMuted = Color(0xFF5A6080);
  static const Color divider = Color(0xFF252840);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient bubbleGradient = LinearGradient(
    colors: [Color(0xFF6C72FF), Color(0xFF9747FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient avatarGradient = LinearGradient(
    colors: [Color(0xFF6C72FF), Color(0xFF3ECFCF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
