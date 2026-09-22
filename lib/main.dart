import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/navigation/app_navigator.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/storage/hive_service.dart';
import 'flavor_config.dart';

Future<void> mcash() async {
 WidgetsFlutterBinding.ensureInitialized();
 await EasyLocalization.ensureInitialized();
 await Hive.initFlutter();

 // Open boxes for caching
 await Hive.openBox(HiveService.settingsBox);
 await Hive.openBox(HiveService.userBox);
 await Hive.openBox(HiveService.walletBox);

 runApp(
   ProviderScope(
     child: EasyLocalization(
       supportedLocales: const [
         Locale('en'),
         Locale('bn'),
       ],
       path: 'assets/translations',
       fallbackLocale: const Locale('en'),
       child: const MyApp(),
     ),
   ),
 );
}

class MyApp extends ConsumerWidget {
 const MyApp({super.key});

 @override
 Widget build(BuildContext context, WidgetRef ref) {
   final router = ref.watch(routerProvider);
   final themeMode = ref.watch(themeModeProvider);

   return MaterialApp.router(
     title: FlavorConfig.instance.appTitle,
     debugShowCheckedModeBanner: !FlavorConfig.isProduction(),
     theme: AppTheme.light,
     darkTheme: AppTheme.dark,
     themeMode: themeMode,
     routerConfig: router,
     scaffoldMessengerKey: AppNavigator.scaffoldMessengerKey,
     supportedLocales: context.supportedLocales,
     localizationsDelegates: context.localizationDelegates,
     locale: context.locale,
     builder: (context, widget) {
       Widget error = const Text('...rendering error...');
       if (widget is Scaffold || widget is Navigator) {
         error = Scaffold(body: Center(child: error));
       }
       ErrorWidget.builder = (errorDetails) => error;
       if (widget != null) return widget;
       throw StateError('widget is null');
     },
   );
 }
}
