import 'package:dio/dio.dart';
import '../../../core/authHelper/auth_state.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/network_exceptions.dart';
import '../domain/auth_session.dart';
import 'i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  const AuthRepository(this._dio);

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

class DemoAuthRepository implements IAuthRepository {
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
