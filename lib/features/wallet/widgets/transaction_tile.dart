import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../domain/transaction.dart';

/// One row of history: what happened, with whom, when, and the signed amount.
class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, this.onTap, super.key});

  final TransactionModel transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.type.isDebit;
    final accent = _accentFor(transaction.type);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(_iconFor(transaction.type), size: 19, color: accent),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.type.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    transaction.counterparty,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.signedMoney(transaction.signedAmount),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDebit ? AppColors.danger : AppColors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.transactionDate(transaction.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static IconData _iconFor(TransactionType type) => switch (type) {
        TransactionType.sendMoney => Icons.arrow_upward_rounded,
        TransactionType.receiveMoney => Icons.arrow_downward_rounded,
        TransactionType.mobileRecharge => Icons.smartphone_rounded,
        TransactionType.billPayment => Icons.receipt_long_rounded,
        TransactionType.cashOut => Icons.account_balance_wallet_rounded,
        TransactionType.cashIn => Icons.savings_rounded,
        TransactionType.topUp => Icons.add_card_rounded,
        TransactionType.merchantPay => Icons.storefront_rounded,
      };

  static Color _accentFor(TransactionType type) => switch (type) {
        TransactionType.receiveMoney ||
        TransactionType.cashIn =>
          AppColors.success,
        TransactionType.billPayment => AppColors.warning,
        TransactionType.mobileRecharge => AppColors.info,
        TransactionType.topUp => AppColors.violet,
        _ => AppColors.primary,
      };
}
