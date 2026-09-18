import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../wallet/data/models/transaction.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

final historyFilterProvider = StateProvider.autoDispose<TransactionFilter>(
  (ref) => TransactionFilter.all,
);

final historyQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// History is a view over wallet state, never a second copy of it.
final filteredHistoryProvider = Provider.autoDispose<List<TransactionModel>>(
  (ref) {
    final transactions = ref.watch(walletProvider).snapshot.transactions;
    final filter = ref.watch(historyFilterProvider);
    final query = ref.watch(historyQueryProvider).trim().toLowerCase();

    return transactions.where((transaction) {
      if (!transaction.matches(filter)) return false;
      if (query.isEmpty) return true;
      return transaction.counterparty.toLowerCase().contains(query) ||
          transaction.type.label.toLowerCase().contains(query);
    }).toList();
  },
);
