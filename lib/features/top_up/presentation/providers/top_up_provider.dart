import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallet/data/models/transaction.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

/// Funding sources for topping the wallet up.
class TopUpMethod {
  const TopUpMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;

  static const all = <TopUpMethod>[
    TopUpMethod(
      id: 'bkash',
      name: 'bKash',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFFE2136E),
    ),
    TopUpMethod(
      id: 'nagad',
      name: 'Nagad',
      icon: Icons.wallet_rounded,
      color: Color(0xFFF15A29),
    ),
    TopUpMethod(
      id: 'bank',
      name: 'Bank Transfer',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF2563EB),
    ),
    TopUpMethod(
      id: 'card',
      name: 'Card',
      icon: Icons.credit_card_rounded,
      color: Color(0xFF7C3AED),
    ),
  ];
}

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
  TopUpNotifier(this._ref) : super(TopUpState(method: TopUpMethod.all.first));

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
