import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/hive_service.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final hive = ref.watch(hiveServiceProvider);
  return ThemeModeNotifier(hive);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._hive) : super(ThemeMode.system) {
    _init();
  }

  final HiveService _hive;
  static const _key = 'theme_mode';

  void _init() {
    final saved = _hive.read<String>(HiveService.settingsBox, _key);
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = next;
    await _hive.write(HiveService.settingsBox, _key, next.name);
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _hive.write(HiveService.settingsBox, _key, mode.name);
  }
}
