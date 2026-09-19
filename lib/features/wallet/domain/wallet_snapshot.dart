import 'package:flutter/foundation.dart';

import 'transaction.dart';

@immutable
class WalletSnapshot {
  const WalletSnapshot({
    required this.balance,
    required this.transactions,
  });

  final double balance;
  final List<TransactionModel> transactions;

  static const empty = WalletSnapshot(balance: 0, transactions: []);

  WalletSnapshot copyWith({
    double? balance,
    List<TransactionModel>? transactions,
  }) {
    return WalletSnapshot(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'transactions': transactions.map((tx) => tx.toJson()).toList(),
      };

  factory WalletSnapshot.fromJson(Map<String, dynamic> json) => WalletSnapshot(
        balance: (json['balance'] as num).toDouble(),
        transactions: (json['transactions'] as List<dynamic>)
            .map(
              (item) => TransactionModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(),
      );
}
