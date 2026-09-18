import 'dart:developer' as developer;

import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';
import '../network_exceptions.dart';

/// Attaches the JWT and retries once after a silent refresh on 401.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._dio);

  final SecureStorageService _storage;
  final Dio _dio;
  bool _refreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isAuthCall = err.requestOptions.path.contains('/auth/');
    if (err.response?.statusCode != 401 || isAuthCall || _refreshing) {
      return handler.next(err);
    }

    _refreshing = true;
    try {
      final refreshToken = await _storage.readRefreshToken();
      if (refreshToken == null) {
        await _storage.clear();
        return handler.next(err);
      }
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final newToken = response.data?['accessToken'] as String?;
      if (newToken == null) {
        await _storage.clear();
        return handler.next(err);
      }
      await _storage.writeAccessToken(newToken);

      final retried = await _dio.fetch<dynamic>(
        err.requestOptions..headers['Authorization'] = 'Bearer $newToken',
      );
      return handler.resolve(retried);
    } on DioException {
      await _storage.clear();
      return handler.next(err);
    } finally {
      _refreshing = false;
    }
  }
}

/// Compact request/response logging, enabled per flavor.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '→ ${options.method} ${options.uri}',
      name: 'MCash.http',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'MCash.http',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '✕ ${err.response?.statusCode ?? '-'} ${err.requestOptions.uri} :: ${err.message}',
      name: 'MCash.http',
    );
    handler.next(err);
  }
}

/// Normalises every Dio failure into a [NetworkException].
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(
      err.copyWith(error: NetworkException.fromDio(err)),
    );
  }
}
