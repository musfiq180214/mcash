import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallet/data/models/transaction.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../data/models/mobile_operator.dart';

final rechargeProvider =
    StateNotifierProvider.autoDispose<RechargeNotifier, RechargeState>((ref) {
  return RechargeNotifier(ref);
});

@immutable
class RechargeState {
  const RechargeState({
    this.connectionType = ConnectionType.prepaid,
    this.operator,
    this.mobile = '',
    this.amount,
    this.isSubmitting = false,
  });

  final ConnectionType connectionType;
  final MobileOperator? operator;
  final String mobile;
  final double? amount;
  final bool isSubmitting;

  RechargeState copyWith({
    ConnectionType? connectionType,
    MobileOperator? operator,
    String? mobile,
    double? amount,
    bool? isSubmitting,
  }) {
    return RechargeState(
      connectionType: connectionType ?? this.connectionType,
      operator: operator ?? this.operator,
      mobile: mobile ?? this.mobile,
      amount: amount ?? this.amount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class RechargeNotifier extends StateNotifier<RechargeState> {
  RechargeNotifier(this._ref)
      : super(RechargeState(operator: MobileOperator.all.first));

  final Ref _ref;

  void selectConnection(ConnectionType type) =>
      state = state.copyWith(connectionType: type);

  void selectOperator(MobileOperator operator) =>
      state = state.copyWith(operator: operator);

  void setMobile(String value) => state = state.copyWith(mobile: value);

  void setAmount(double? value) => state = state.copyWith(amount: value);

  Future<TransactionModel?> submit() async {
    final operator = state.operator;
    final amount = state.amount;
    if (operator == null || amount == null || amount <= 0) return null;

    state = state.copyWith(isSubmitting: true);
    final transaction = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.mobileRecharge,
      amount: amount,
      counterparty: '${operator.name} · ${state.mobile}',
      createdAt: DateTime.now(),
      note: state.connectionType.name,
      reference: 'RC${DateTime.now().millisecondsSinceEpoch % 1000000}',
    );

    final committed =
        await _ref.read(walletProvider.notifier).commit(transaction);
    if (mounted) state = state.copyWith(isSubmitting: false);
    return committed;
  }
}
