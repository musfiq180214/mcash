import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/auth_repository.dart';
import '../storage/hive_service.dart';
import '../storage/secure_storage_service.dart';
import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    repository: ref.watch(authRepositoryProvider),
    storage: ref.watch(secureStorageServiceProvider),
    hive: ref.watch(hiveServiceProvider),
  )..restoreSession();
});

/// Owns the global auth state. Routing observes this notifier, so any change
/// here redirects the app without a screen having to push or pop anything.
class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository repository,
    required SecureStorageService storage,
    required HiveService hive,
  })  : _repository = repository,
        _storage = storage,
        _hive = hive,
        super(const AuthState());

  final AuthRepository _repository;
  final SecureStorageService _storage;
  final HiveService _hive;

  static const _cachedUserKey = 'cached_user';

  Future<void> restoreSession() async {
    final token = await _storage.readAccessToken();
    final cached = _hive.read<Map<dynamic, dynamic>>(
      HiveService.userBox,
      _cachedUserKey,
    );

    if (token == null || cached == null) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }

    state = AuthState(
      status: AuthStatus.authenticated,
      user: AuthUser.fromJson(Map<String, dynamic>.from(cached)),
    );
  }

  Future<bool> login({required String mobile, required String pin}) {
    return _run(() => _repository.login(mobile: mobile, pin: pin));
  }

  Future<bool> signup({
    required String name,
    required String mobile,
    required String pin,
  }) {
    return _run(
      () => _repository.signup(name: name, mobile: mobile, pin: pin),
    );
  }

  Future<bool> requestPasswordReset(String mobile) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await _repository.forgotPassword(mobile: mobile);
    return result.when(
      success: (_) {
        state = state.copyWith(isSubmitting: false);
        return true;
      },
      failure: (error) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage: error.message,
        );
        return false;
      },
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    await _storage.clear();
    await _hive.clearAll();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(clearError: true);

  Future<bool> _run(Future<AuthSessionResult> Function() action) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await action();

    return result.when(
      success: (session) async {
        await _storage.writeAccessToken(session.accessToken);
        await _storage.writeRefreshToken(session.refreshToken);
        await _hive.write(
          HiveService.userBox,
          _cachedUserKey,
          session.user.toJson(),
        );
        state = AuthState(
          status: AuthStatus.authenticated,
          user: session.user,
        );
        return true;
      },
      failure: (error) async {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isSubmitting: false,
          errorMessage: error.message,
        );
        return false;
      },
    );
  }
}
