import 'package:flutter/material.dart';

/// MCash brand palette, taken from the product design system.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFED1E79);
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color primarySoft = Color(0xFFFFE5F0);
  static const Color violet = Color(0xFF7B2FF7);
  static const Color navy = Color(0xFF130F40);

  static const Color scaffold = Color(0xFFF6F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6E8F0);
  static const Color field = Color(0xFFF9FAFC);

  static const Color textPrimary = Color(0xFF191A2E);
  static const Color textSecondary = Color(0xFF7A7F9A);
  static const Color textTertiary = Color(0xFFA9AEC2);

  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFE11D48);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF2563EB);

  // Futuristic "Cyber" Palette
  static const Color cyberBlue = Color(0xFF00D2FF);
  static const Color cyberViolet = Color(0xFF9D50BB);
  static const Color cyberPink = Color(0xFFE5157C);
  static const Color cyberNavy = Color(0xFF0F0C29);
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x4DFFFFFF);

  // Dark Mode Semantic Colors
  static const Color scaffoldDark = Color(0xFF0F0C29);
  static const Color surfaceDark = Color(0x1AFFFFFF); // Transparent for glass effect
  static const Color borderDark = Color(0x33FFFFFF);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B3C7);

  static const LinearGradient cyberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cyberBlue, cyberViolet, cyberPink],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x33FFFFFF),
      Color(0x0FFFFFFF),
    ],
  );

  static const List<Color> meshColors = [
    cyberBlue,
    cyberViolet,
    cyberPink,
    navy,
  ];

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B2FF7), Color(0xFFED1E79)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2186B), Color(0xFFE5157C)],
  );

  static const LinearGradient balanceGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFD4146A), Color(0xFFB0125F)],
  );
}
