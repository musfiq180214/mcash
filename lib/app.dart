import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/flavor_config.dart';
import 'core/connectivity/no_internet_banner.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class MCashApp extends ConsumerWidget {
  const MCashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: FlavorConfig.instance.appName,
      debugShowCheckedModeBanner: !FlavorConfig.isProduction,
      theme: AppTheme.light,
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) =>
          ConnectivityBanner(child: child ?? const SizedBox.shrink()),
    );
  }
}
