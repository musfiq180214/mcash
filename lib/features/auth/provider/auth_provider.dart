import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../data/i_auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>(
  (ref) => DemoAuthRepository(),
  // Live: (ref) => AuthRepository(ref.watch(dioClientProvider)),
);
