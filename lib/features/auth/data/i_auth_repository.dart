import '../../../core/network/api_result.dart';
import '../domain/auth_session.dart';

typedef AuthSessionResult = ApiResult<AuthSession>;

abstract interface class IAuthRepository {
  Future<AuthSessionResult> login({required String mobile, required String pin});

  Future<AuthSessionResult> signup({
    required String name,
    required String mobile,
    required String pin,
  });

  Future<ApiResult<void>> forgotPassword({required String mobile});

  Future<void> logout();
}
