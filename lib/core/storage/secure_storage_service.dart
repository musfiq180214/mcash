import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(const FlutterSecureStorage()),
);

/// Keychain / Keystore backed store for credentials only. Never cache
/// transaction data here — use [HiveService] for that.
class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'mcash.access_token';
  static const _refreshTokenKey = 'mcash.refresh_token';
  static const _pinKey = 'mcash.pin_hash';

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);
  Future<String?> readPinHash() => _storage.read(key: _pinKey);

  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<void> writePinHash(String hash) =>
      _storage.write(key: _pinKey, value: hash);

  Future<void> clear() => _storage.deleteAll();
}
