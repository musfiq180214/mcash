import 'package:flutter_test/flutter_test.dart';
import 'package:mcash/features/wallet/domain/transaction.dart';
import 'package:mcash/features/wallet/domain/wallet_snapshot.dart';

void main() {
  group('TransactionType', () {
    test('money leaving the wallet is a debit', () {
      expect(TransactionType.sendMoney.isDebit, isTrue);
      expect(TransactionType.cashOut.isDebit, isTrue);
      expect(TransactionType.billPayment.isDebit, isTrue);
    });

    test('incoming money is a credit', () {
      expect(TransactionType.cashIn.isDebit, isFalse);
      expect(TransactionType.receiveMoney.isDebit, isFalse);
      expect(TransactionType.topUp.isDebit, isFalse);
    });
  });

  group('TransactionModel', () {
    final transaction = TransactionModel(
      id: 'tx_test',
      type: TransactionType.cashOut,
      amount: 1000,
      fee: 18.5,
      counterparty: 'bKash Agent',
      createdAt: DateTime(2026, 1, 1),
    );

    test('total includes the fee', () {
      expect(transaction.total, 1018.5);
    });

    test('signed amount is negative for a debit', () {
      expect(transaction.signedAmount, -1000);
    });

    test('survives a json round trip', () {
      final restored = TransactionModel.fromJson(transaction.toJson());
      expect(restored.id, transaction.id);
      expect(restored.type, transaction.type);
      expect(restored.fee, transaction.fee);
      expect(restored.createdAt, transaction.createdAt);
    });

    test('filters match the tabs shown in history', () {
      expect(transaction.matches(TransactionFilter.all), isTrue);
      expect(transaction.matches(TransactionFilter.send), isTrue);
      expect(transaction.matches(TransactionFilter.receive), isFalse);
    });
  });

  test('WalletSnapshot round trips through json', () {
    final snapshot = WalletSnapshot(
      balance: 12450,
      transactions: [
        TransactionModel(
          id: 'tx_1',
          type: TransactionType.sendMoney,
          amount: 500,
          counterparty: '01712345678',
          createdAt: DateTime(2026, 1, 2),
        ),
      ],
    );

    final restored = WalletSnapshot.fromJson(snapshot.toJson());
    expect(restored.balance, 12450);
    expect(restored.transactions.single.amount, 500);
  });
}
