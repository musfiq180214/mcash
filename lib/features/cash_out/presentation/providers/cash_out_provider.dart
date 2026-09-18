import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallet/data/models/transaction.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../data/models/agent.dart';

final cashOutProvider =
    StateNotifierProvider.autoDispose<CashOutNotifier, CashOutState>(
  (ref) => CashOutNotifier(ref),
);

@immutable
class CashOutState {
  const CashOutState({
    required this.agent,
    this.agentNumber = '',
    this.amount,
    this.isSubmitting = false,
  });

  final CashOutAgent agent;
  final String agentNumber;
  final double? amount;
  final bool isSubmitting;

  double get fee => agent.feeFor(amount ?? 0);
  double get total => (amount ?? 0) + fee;

  CashOutState copyWith({
    CashOutAgent? agent,
    String? agentNumber,
    double? amount,
    bool? isSubmitting,
  }) {
    return CashOutState(
      agent: agent ?? this.agent,
      agentNumber: agentNumber ?? this.agentNumber,
      amount: amount ?? this.amount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CashOutNotifier extends StateNotifier<CashOutState> {
  CashOutNotifier(this._ref)
      : super(CashOutState(agent: CashOutAgent.all.first));

  final Ref _ref;

  void selectAgent(CashOutAgent agent) => state = state.copyWith(agent: agent);

  void setAgentNumber(String value) =>
      state = state.copyWith(agentNumber: value);

  void setAmount(double? value) => state = state.copyWith(amount: value);

  Future<TransactionModel?> submit() async {
    final amount = state.amount;
    if (amount == null || amount <= 0) return null;

    state = state.copyWith(isSubmitting: true);
    final transaction = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.cashOut,
      amount: amount,
      fee: state.fee,
      counterparty: '${state.agent.name} · ${state.agentNumber}',
      createdAt: DateTime.now(),
      reference: 'CO${DateTime.now().millisecondsSinceEpoch % 1000000}',
    );

    final committed =
        await _ref.read(walletProvider.notifier).commit(transaction);
    if (mounted) state = state.copyWith(isSubmitting: false);
    return committed;
  }
}
