import 'package:flutter/foundation.dart';

enum TransactionType {
  sendMoney,
  receiveMoney,
  mobileRecharge,
  billPayment,
  cashOut,
  cashIn,
  topUp,
  merchantPay;

  String get label => switch (this) {
        TransactionType.sendMoney => 'Send Money',
        TransactionType.receiveMoney => 'Receive Money',
        TransactionType.mobileRecharge => 'Mobile Recharge',
        TransactionType.billPayment => 'Bill Payment',
        TransactionType.cashOut => 'Cash Out',
        TransactionType.cashIn => 'Cash In',
        TransactionType.topUp => 'Top Up Wallet',
        TransactionType.merchantPay => 'Merchant Pay',
      };

  /// Money leaving the wallet is a debit; everything else credits it.
  bool get isDebit => switch (this) {
        TransactionType.receiveMoney ||
        TransactionType.cashIn ||
        TransactionType.topUp =>
          false,
        _ => true,
      };
}

enum TransactionStatus { pending, completed, failed }

enum TransactionFilter { all, send, receive, bill }

@immutable
class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.counterparty,
    required this.createdAt,
    this.status = TransactionStatus.completed,
    this.note,
    this.fee = 0,
    this.reference,
  });

  final String id;
  final TransactionType type;
  final double amount;

  /// Who or what the money moved to: a number, an operator, a biller, an agent.
  final String counterparty;
  final DateTime createdAt;
  final TransactionStatus status;
  final String? note;
  final double fee;
  final String? reference;

  double get signedAmount => type.isDebit ? -amount : amount;
  double get total => amount + fee;

  bool matches(TransactionFilter filter) => switch (filter) {
        TransactionFilter.all => true,
        TransactionFilter.send => type == TransactionType.sendMoney ||
            type == TransactionType.cashOut ||
            type == TransactionType.merchantPay,
        TransactionFilter.receive => !type.isDebit,
        TransactionFilter.bill => type == TransactionType.billPayment ||
            type == TransactionType.mobileRecharge,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      counterparty: json['counterparty'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: TransactionStatus.values.byName(
        json['status'] as String? ?? 'completed',
      ),
      note: json['note'] as String?,
      fee: (json['fee'] as num?)?.toDouble() ?? 0,
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'amount': amount,
        'counterparty': counterparty,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        'note': note,
        'fee': fee,
        'reference': reference,
      };
}
