import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../wallet/domain/transaction.dart';
import '../../wallet/provider/wallet_provider.dart';
import '../data/bill_payment_repository.dart';
import '../data/i_bill_payment_repository.dart';
import '../domain/biller.dart';

final billPaymentRepositoryProvider = Provider<IBillPaymentRepository>((ref) {
  return BillPaymentRepository();
});

final billPaymentProvider =
    StateNotifierProvider.autoDispose<BillPaymentNotifier, BillPaymentState>(
  (ref) => BillPaymentNotifier(ref),
);

@immutable
class BillPaymentState {
  const BillPaymentState({
    required this.category,
    required this.provider,
    this.accountNumber = '',
    this.amount,
    this.isSubmitting = false,
  });

  final BillerCategory category;
  final String provider;
  final String accountNumber;
  final double? amount;
  final bool isSubmitting;

  BillPaymentState copyWith({
    BillerCategory? category,
    String? provider,
    String? accountNumber,
    double? amount,
    bool? isSubmitting,
  }) {
    return BillPaymentState(
      category: category ?? this.category,
      provider: provider ?? this.provider,
      accountNumber: accountNumber ?? this.accountNumber,
      amount: amount ?? this.amount,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class BillPaymentNotifier extends StateNotifier<BillPaymentState> {
  BillPaymentNotifier(this._ref)
      : super(
          BillPaymentState(
            category: BillerCategory.all.first,
            provider: BillerCategory.all.first.providers.first,
          ),
        );

  final Ref _ref;

  /// Changing the category resets the provider, otherwise a DESCO account
  /// could end up filed under a water bill.
  void selectCategory(BillerCategory category) {
    state = state.copyWith(
      category: category,
      provider: category.providers.first,
    );
  }

  void selectProvider(String provider) =>
      state = state.copyWith(provider: provider);

  void setAccountNumber(String value) =>
      state = state.copyWith(accountNumber: value);

  void setAmount(double? value) => state = state.copyWith(amount: value);

  Future<TransactionModel?> submit() async {
    final amount = state.amount;
    if (amount == null || amount <= 0) return null;

    state = state.copyWith(isSubmitting: true);
    final transaction = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      type: TransactionType.billPayment,
      amount: amount,
      counterparty: '${state.provider} (${state.category.name})',
      createdAt: DateTime.now(),
      note: 'A/C ${state.accountNumber}',
      reference: 'BP${DateTime.now().millisecondsSinceEpoch % 1000000}',
    );

    final committed =
        await _ref.read(walletProvider.notifier).commit(transaction);
    if (mounted) state = state.copyWith(isSubmitting: false);
    return committed;
  }
}
