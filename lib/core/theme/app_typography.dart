import 'package:flutter/material.dart';

import 'app_colors.dart';

/// One family, three weights. Numbers lead the hierarchy in a wallet, so the
/// display sizes are reserved for balances and amounts.
class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Inter';

  static const TextStyle balance = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    color: Colors.white,
  );

  static const TextStyle amount = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle screenTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.5,
    color: AppColors.textTertiary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
