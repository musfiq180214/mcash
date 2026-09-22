import 'package:flutter/services.dart';

class HapticService {
  const HapticService._();

  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
  static Future<void> selection() => HapticFeedback.selectionClick();
  
  static Future<void> success() async {
    await light();
    await Future.delayed(const Duration(milliseconds: 50));
    await light();
  }

  static Future<void> error() async {
    await heavy();
    await Future.delayed(const Duration(milliseconds: 50));
    await heavy();
    await Future.delayed(const Duration(milliseconds: 50));
    await heavy();
  }
}
