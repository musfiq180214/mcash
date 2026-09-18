import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/authHelper/auth_state.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/network_exceptions.dart';
import 'models/auth_session.dart';

typedef AuthSessionResult = ApiResult<AuthSession>;

/// Swap the implementation here to move from the bundled demo data to the
/// live gateway — nothing above the repository layer changes.
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => DemoAuthRepository(),
  // Live: (ref) => RemoteAuthRepository(ref.watch(dioClientProvider)),
);

abstract interface class AuthRepository {
  Future<AuthSessionResult> login({required String mobile, required String pin});

  Future<AuthSessionResult> signup({
    required String name,
    required String mobile,
    required String pin,
  });

  Future<ApiResult<void>> forgotPassword({required String mobile});

  Future<void> logout();
}

class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository(this._dio);

  final Dio _dio;

  @override
  Future<AuthSessionResult> login({
    required String mobile,
    required String pin,
  }) =>
      _session(ApiEndpoints.login, {'mobile': mobile, 'pin': pin});

  @override
  Future<AuthSessionResult> signup({
    required String name,
    required String mobile,
    required String pin,
  }) =>
      _session(ApiEndpoints.signup, {
        'name': name,
        'mobile': mobile,
        'pin': pin,
      });

  @override
  Future<ApiResult<void>> forgotPassword({required String mobile}) async {
    try {
      await _dio.post<dynamic>(
        ApiEndpoints.forgotPassword,
        data: {'mobile': mobile},
      );
      return const ApiResult.success(null);
    } on DioException catch (error) {
      return ApiResult.failure(NetworkException.fromDio(error));
    }
  }

  @override
  Future<void> logout() async {}

  Future<AuthSessionResult> _session(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      return ApiResult.success(AuthSession.fromJson(response.data!));
    } on DioException catch (error) {
      return ApiResult.failure(NetworkException.fromDio(error));
    }
  }
}

/// Offline implementation used by the demo build. Any 11-digit number with a
/// 4-digit PIN signs in as the seeded account.
class DemoAuthRepository implements AuthRepository {
  static const _delay = Duration(milliseconds: 700);

  @override
  Future<AuthSessionResult> login({
    required String mobile,
    required String pin,
  }) async {
    await Future<void>.delayed(_delay);
    if (pin.length < 4) {
      return const ApiResult.failure(
        NetworkException('That PIN does not match. Try again.'),
      );
    }
    return ApiResult.success(_sessionFor('Musfiq Rahman', mobile));
  }

  @override
  Future<AuthSessionResult> signup({
    required String name,
    required String mobile,
    required String pin,
  }) async {
    await Future<void>.delayed(_delay);
    return ApiResult.success(_sessionFor(name, mobile));
  }

  @override
  Future<ApiResult<void>> forgotPassword({required String mobile}) async {
    await Future<void>.delayed(_delay);
    return const ApiResult.success(null);
  }

  @override
  Future<void> logout() async {}

  AuthSession _sessionFor(String name, String mobile) => AuthSession(
        accessToken: 'demo.access.token',
        refreshToken: 'demo.refresh.token',
        user: AuthUser(
          id: 'usr_001',
          name: name,
          mobile: mobile,
          isVerified: true,
        ),
      );
}
