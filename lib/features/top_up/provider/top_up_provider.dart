import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../wallet/domain/transaction.dart';
import '../../wallet/provider/wallet_provider.dart';
import '../data/i_top_up_repository.dart';
import '../data/top_up_repository.dart';
import '../domain/top_up_method.dart';

final topUpRepositoryProvider = Provider<ITopUpRepository>((ref) {
  return TopUpRepository();
});

final topUpProvider =
    StateNotifierProvider.autoDispose<TopUpNotifier, TopUpState>(
  (ref) => TopUpNotifier(ref),
);

@immutable
class TopUpState {
  const TopUpState({
    required this.method,
    this.amount,
    this.isSubmitting = false,
  });

  final TopUpMethod method;
  final double? amount;
  final bool isSubmitting;

  TopUpState copyWith({
    TopUpMethod? method,
    double? amount,
    bool? isSubmitting,
  }) {
    return TopUpState(
      method: method ?? this.method,
      amount: amount ?? this.amount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class TopUpNotifier extends StateNotifier<TopUpState> {
  TopUpNotifier(this._ref)
      : super(TopUpState(method: TopUpMethod.all.first));

  final Ref _ref;

  void selectMethod(TopUpMethod method) => state = state.copyWith(method: method);

  void setAmount(double? value) => state = state.copyWith(amount: value);

  Future<TransactionModel?> submit() async {
    final amount = state.amount;
    if (amount == null || amount <= 0) return null;

    state = state.copyWith(isSubmitting: true);
    final transaction = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.topUp,
      amount: amount,
      counterparty: state.method.name,
      createdAt: DateTime.now(),
      reference: 'TU${DateTime.now().millisecondsSinceEpoch % 1000000}',
    );

    final committed =
        await _ref.read(walletProvider.notifier).commit(transaction);
    if (mounted) state = state.copyWith(isSubmitting: false);
    return committed;
  }
}
