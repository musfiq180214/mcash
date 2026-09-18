import 'dart:async';
import 'dart:developer' as developer;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/flavor_config.dart';
import 'core/storage/hive_service.dart';

/// Shared startup for every flavor: bind the framework, resolve the
/// environment, warm up local storage, then hand off to [MCashApp].
Future<void> bootstrap(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig.initialize(flavor);

  await EasyLocalization.ensureInitialized();
  await HiveService.init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  FlutterError.onError = (details) {
    developer.log(
      details.exceptionAsString(),
      name: 'MCash.error',
      stackTrace: details.stack,
    );
  };

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('bn')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: const MCashApp(),
      ),
    ),
  );
}
