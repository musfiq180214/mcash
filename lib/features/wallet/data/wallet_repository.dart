import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/storage/hive_service.dart';
import 'models/transaction.dart';
import 'models/wallet_snapshot.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => LocalWalletRepository(ref.watch(hiveServiceProvider)),
);

abstract interface class WalletRepository {
  Future<ApiResult<WalletSnapshot>> loadWallet();

  /// Applies a transaction and returns the wallet as it stands afterwards.
  Future<ApiResult<WalletSnapshot>> commit(TransactionModel transaction);
}

/// Local-first wallet. Every flow commits here, so balance and history stay
/// consistent offline; a remote implementation can replace it without any
/// change above this layer.
class LocalWalletRepository implements WalletRepository {
  LocalWalletRepository(this._hive);

  final HiveService _hive;

  static const _key = 'wallet_snapshot';
  static const _delay = Duration(milliseconds: 550);

  @override
  Future<ApiResult<WalletSnapshot>> loadWallet() async {
    final cached = _hive.read<Map<dynamic, dynamic>>(HiveService.walletBox, _key);
    if (cached != null) {
      return ApiResult.success(
        WalletSnapshot.fromJson(Map<String, dynamic>.from(cached)),
      );
    }
    final seeded = _seed();
    await _persist(seeded);
    return ApiResult.success(seeded);
  }

  @override
  Future<ApiResult<WalletSnapshot>> commit(TransactionModel transaction) async {
    await Future<void>.delayed(_delay);

    final current = (await loadWallet()).dataOrNull ?? WalletSnapshot.empty;
    final delta = transaction.type.isDebit
        ? -transaction.total
        : transaction.amount;

    if (transaction.type.isDebit && transaction.total > current.balance) {
      return const ApiResult.failure(
        NetworkException('Not enough balance for this payment.'),
      );
    }

    final updated = current.copyWith(
      balance: current.balance + delta,
      transactions: [transaction, ...current.transactions],
    );
    await _persist(updated);
    return ApiResult.success(updated);
  }

  Future<void> _persist(WalletSnapshot snapshot) =>
      _hive.write(HiveService.walletBox, _key, snapshot.toJson());

  WalletSnapshot _seed() {
    final now = DateTime.now();
    return WalletSnapshot(
      balance: 12450,
      transactions: [
        TransactionModel(
          id: 'tx_1',
          type: TransactionType.sendMoney,
          amount: 500,
          counterparty: '01712345678',
          createdAt: now.subtract(const Duration(hours: 3)),
        ),
        TransactionModel(
          id: 'tx_2',
          type: TransactionType.mobileRecharge,
          amount: 100,
          counterparty: 'Grameenphone',
          createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        ),
        TransactionModel(
          id: 'tx_3',
          type: TransactionType.billPayment,
          amount: 1200,
          counterparty: 'DESCO (Electricity)',
          createdAt: now.subtract(const Duration(days: 2)),
        ),
        TransactionModel(
          id: 'tx_4',
          type: TransactionType.cashIn,
          amount: 1000,
          counterparty: 'bKash Agent',
          createdAt: now.subtract(const Duration(days: 3)),
        ),
        TransactionModel(
          id: 'tx_5',
          type: TransactionType.receiveMoney,
          amount: 2000,
          counterparty: '01898765432',
          createdAt: now.subtract(const Duration(days: 5)),
        ),
        TransactionModel(
          id: 'tx_6',
          type: TransactionType.topUp,
          amount: 500,
          counterparty: 'bKash',
          createdAt: now.subtract(const Duration(days: 7)),
        ),
      ],
    );
  }
}
