import '../../../core/network/api_result.dart';
import '../domain/transaction.dart';
import '../domain/wallet_snapshot.dart';

abstract interface class IWalletRepository {
  Future<ApiResult<WalletSnapshot>> loadWallet();

  /// Applies a transaction and returns the wallet as it stands afterwards.
  Future<ApiResult<WalletSnapshot>> commit(TransactionModel transaction);
}
