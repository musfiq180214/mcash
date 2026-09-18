import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/transaction.dart';
import '../../data/models/wallet_snapshot.dart';
import '../../data/wallet_repository.dart';

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier(ref.watch(walletRepositoryProvider))..load();
});

/// Balance for the header, read without rebuilding on history changes.
final balanceProvider = Provider<double>(
  (ref) => ref.watch(walletProvider).snapshot.balance,
);

final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  return ref.watch(walletProvider).snapshot.transactions.take(5).toList();
});

@immutable
class WalletState {
  const WalletState({
    this.snapshot = WalletSnapshot.empty,
    this.isLoading = false,
    this.isCommitting = false,
    this.errorMessage,
  });

  final WalletSnapshot snapshot;
  final bool isLoading;
  final bool isCommitting;
  final String? errorMessage;

  WalletState copyWith({
    WalletSnapshot? snapshot,
    bool? isLoading,
    bool? isCommitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WalletState(
      snapshot: snapshot ?? this.snapshot,
      isLoading: isLoading ?? this.isLoading,
      isCommitting: isCommitting ?? this.isCommitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// The only writer of wallet state. Feature notifiers build a transaction and
/// hand it here, which keeps balance arithmetic in exactly one place.
class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier(this._repository) : super(const WalletState());

  final WalletRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.loadWallet();
    state = result.when(
      success: (snapshot) => state.copyWith(
        snapshot: snapshot,
        isLoading: false,
      ),
      failure: (error) => state.copyWith(
        isLoading: false,
        errorMessage: error.message,
      ),
    );
  }

  /// Returns the committed transaction, or null with [WalletState.errorMessage]
  /// set when the wallet rejected it.
  Future<TransactionModel?> commit(TransactionModel transaction) async {
    state = state.copyWith(isCommitting: true, clearError: true);
    final result = await _repository.commit(transaction);

    return result.when(
      success: (snapshot) {
        state = state.copyWith(snapshot: snapshot, isCommitting: false);
        return transaction;
      },
      failure: (error) {
        state = state.copyWith(
          isCommitting: false,
          errorMessage: error.message,
        );
        return null;
      },
    );
  }
}
