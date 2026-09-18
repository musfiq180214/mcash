import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallet/data/models/transaction.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

enum SendMoneyMethod { mobileNumber, accountNumber, scanQr }

final sendMoneyProvider =
    StateNotifierProvider.autoDispose<SendMoneyNotifier, SendMoneyState>((ref) {
  return SendMoneyNotifier(ref);
});

@immutable
class SendMoneyState {
  const SendMoneyState({
    this.method = SendMoneyMethod.mobileNumber,
    this.recipient = '',
    this.amount,
    this.note,
    this.isSubmitting = false,
  });

  final SendMoneyMethod method;
  final String recipient;
  final double? amount;
  final String? note;
  final bool isSubmitting;

  bool get canSubmit =>
      recipient.length >= 11 && (amount ?? 0) > 0 && !isSubmitting;

  SendMoneyState copyWith({
    SendMoneyMethod? method,
    String? recipient,
    double? amount,
    String? note,
    bool? isSubmitting,
  }) {
    return SendMoneyState(
      method: method ?? this.method,
      recipient: recipient ?? this.recipient,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

/// Holds the form state only. The money itself is moved by [WalletNotifier].
class SendMoneyNotifier extends StateNotifier<SendMoneyState> {
  SendMoneyNotifier(this._ref) : super(const SendMoneyState());

  final Ref _ref;

  void selectMethod(SendMoneyMethod method) =>
      state = state.copyWith(method: method);

  void setRecipient(String value) => state = state.copyWith(recipient: value);

  void setAmount(double? value) => state = state.copyWith(amount: value);

  void setNote(String value) => state = state.copyWith(note: value);

  Future<TransactionModel?> submit() async {
    if (!state.canSubmit) return null;
    state = state.copyWith(isSubmitting: true);

    final transaction = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.sendMoney,
      amount: state.amount!,
      counterparty: state.recipient,
      createdAt: DateTime.now(),
      note: state.note,
      reference: 'SM${DateTime.now().millisecondsSinceEpoch % 1000000}',
    );

    final committed =
        await _ref.read(walletProvider.notifier).commit(transaction);
    if (mounted) state = state.copyWith(isSubmitting: false);
    return committed;
  }
}
