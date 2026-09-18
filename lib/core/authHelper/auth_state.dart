import 'package:flutter/foundation.dart';

/// The signed-in identity. Kept in `core` so routing, networking and every
/// feature can depend on it without depending on the auth feature itself.
@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.avatarUrl,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final String mobile;
  final String? email;
  final String? avatarUrl;
  final bool isVerified;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String,
        name: json['name'] as String,
        mobile: json['mobile'] as String,
        email: json['email'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        isVerified: json['isVerified'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
        'email': email,
        'avatarUrl': avatarUrl,
        'isVerified': isVerified,
      };
}

enum AuthStatus { unknown, authenticated, unauthenticated }

@immutable
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final AuthUser? user;
  final bool isSubmitting;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isResolving => status == AuthStatus.unknown;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
