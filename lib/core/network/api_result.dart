import 'network_exceptions.dart';

/// Result wrapper so repositories never throw across layer boundaries.
sealed class ApiResult<T> {
  const ApiResult();

  const factory ApiResult.success(T data) = ApiSuccess<T>;
  const factory ApiResult.failure(NetworkException error) = ApiFailure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(NetworkException error) failure,
  }) {
    return switch (this) {
      ApiSuccess<T>(:final data) => success(data),
      ApiFailure<T>(:final error) => failure(error),
    };
  }

  T? get dataOrNull => this is ApiSuccess<T> ? (this as ApiSuccess<T>).data : null;
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);
  final T data;
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.error);
  final NetworkException error;
}
