import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveServiceProvider = Provider<HiveService>((ref) => HiveService());

/// Offline-first cache. Boxes hold plain JSON maps so the app stays free of
/// generated type adapters and stays forward compatible with API changes.
class HiveService {
  static const String userBox = 'user_box';
  static const String walletBox = 'wallet_box';
  static const String settingsBox = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(userBox),
      Hive.openBox<dynamic>(walletBox),
      Hive.openBox<dynamic>(settingsBox),
    ]);
  }

  Box<dynamic> box(String name) => Hive.box<dynamic>(name);

  T? read<T>(String boxName, String key) => box(boxName).get(key) as T?;

  Future<void> write(String boxName, String key, Object? value) =>
      box(boxName).put(key, value);

  Future<void> delete(String boxName, String key) => box(boxName).delete(key);

  Future<void> clearAll() async {
    await Future.wait([
      box(userBox).clear(),
      box(walletBox).clear(),
    ]);
  }
}
