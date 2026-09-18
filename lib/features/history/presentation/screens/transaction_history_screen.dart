import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../wallet/data/models/transaction.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../../wallet/presentation/widgets/transaction_tile.dart';
import '../providers/history_provider.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  static const _filters = ['All', 'Send', 'Receive', 'Bill Pay'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(historyFilterProvider);
    final transactions = ref.watch(filteredHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) =>
                        ref.read(historyQueryProvider.notifier).state = value,
                    decoration: const InputDecoration(
                      hintText: 'Search by number or service',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedTabs(
                    labels: _filters,
                    selectedIndex: filter.index,
                    onChanged: (index) => ref
                        .read(historyFilterProvider.notifier)
                        .state = TransactionFilter.values[index],
                  ),
                ],
              ),
            ),
            Expanded(
              child: transactions.isEmpty
                  ? const _EmptyHistory()
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () =>
                          ref.read(walletProvider.notifier).load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          0,
                          AppSpacing.lg,
                          120,
                        ),
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.radiusMd,
                              ),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: TransactionTile(
                              transaction: transaction,
                              onTap: () => _showDetail(context, transaction),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, TransactionModel transaction) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.type.label, style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.xs),
            Text(
              Formatters.money(transaction.amount),
              style: AppTypography.amount,
            ),
            const SizedBox(height: AppSpacing.lg),
            _DetailRow(label: 'To', value: transaction.counterparty),
            _DetailRow(
              label: 'Date',
              value: Formatters.transactionDate(transaction.createdAt),
            ),
            if (transaction.fee > 0)
              _DetailRow(
                label: 'Fee',
                value: Formatters.money(transaction.fee),
              ),
            _DetailRow(
              label: 'Status',
              value: transaction.status.name,
            ),
            _DetailRow(
              label: 'Reference',
              value: transaction.reference ?? transaction.id,
            ),
            if (transaction.note != null && transaction.note!.isNotEmpty)
              _DetailRow(label: 'Note', value: transaction.note!),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.label),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 32, color: AppColors.textTertiary),
            SizedBox(height: AppSpacing.md),
            Text(
              'Nothing matches this filter yet.',
              style: AppTypography.body,
            ),
          ],
        ),
      ),
    );
  }
}
