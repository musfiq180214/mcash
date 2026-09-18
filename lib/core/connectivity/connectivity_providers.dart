import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  final connectivity = Connectivity();
  return connectivity.onConnectivityChanged.map(_normalise);
});

/// True whenever the device has no usable transport. Defaults to online while
/// the first event is still in flight so the UI never flashes an error.
final isOfflineProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).maybeWhen(
        data: (results) =>
            results.every((result) => result == ConnectivityResult.none),
        orElse: () => false,
      );
});

List<ConnectivityResult> _normalise(dynamic event) {
  if (event is List<ConnectivityResult>) return event;
  if (event is ConnectivityResult) return [event];
  return const [ConnectivityResult.none];
}
