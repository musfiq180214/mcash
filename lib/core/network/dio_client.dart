import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../flavor_config.dart';
import '../storage/secure_storage_service.dart';
import 'interceptors/app_interceptors.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final config = FlavorConfig.instance;
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      contentType: Headers.jsonContentType,
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(ref.read(secureStorageServiceProvider), dio),
    if (config.enableLogging) LoggingInterceptor(),
    ErrorInterceptor(),
  ]);

  ref.onDispose(dio.close);
  return dio;
});
