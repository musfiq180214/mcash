import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/i_qr_pay_repository.dart';
import '../data/qr_pay_repository.dart';

final qrPayRepositoryProvider = Provider<IQrPayRepository>((ref) {
  return QrPayRepository();
});
