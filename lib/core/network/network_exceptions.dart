import 'package:dio/dio.dart';

/// A transport-agnostic failure the UI layer can render without knowing Dio.
class NetworkException implements Exception {
  const NetworkException(this.message, {this.statusCode, this.code});

  final String message;
  final int? statusCode;
  final String? code;

  bool get isUnauthorized => statusCode == 401;

  factory NetworkException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const NetworkException('The request timed out. Try again.');
      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection.');
      case DioExceptionType.cancel:
        return const NetworkException('The request was cancelled.');
      case DioExceptionType.badCertificate:
        return const NetworkException('Could not verify the server.');
      case DioExceptionType.badResponse:
        final response = error.response;
        final data = response?.data;
        final message = data is Map && data['message'] is String
            ? data['message'] as String
            : 'Something went wrong (${response?.statusCode}).';
        return NetworkException(
          message,
          statusCode: response?.statusCode,
          code: data is Map ? data['code'] as String? : null,
        );
      case DioExceptionType.unknown:
        return const NetworkException('Unexpected error. Try again.');
    }
  }

  @override
  String toString() => message;
}
