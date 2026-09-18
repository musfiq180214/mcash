import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/models/transaction.dart';

/// Shared confirmation for every money flow. The receipt mirrors what was
/// committed, so no flow has to build its own success screen.
class TransactionSuccessScreen extends StatelessWidget {
  const TransactionSuccessScreen({required this.transaction, super.key});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 88,
                width: 88,
                decoration: const BoxDecoration(
                  gradient: AppColors.brandGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                '${transaction.type.label} successful',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                Formatters.money(transaction.amount),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _Row(label: 'To', value: transaction.counterparty),
                    if (transaction.fee > 0)
                      _Row(
                        label: 'Fee',
                        value: Formatters.money(transaction.fee),
                      ),
                    _Row(
                      label: 'Total',
                      value: Formatters.money(transaction.total),
                    ),
                    _Row(
                      label: 'Date',
                      value: Formatters.transactionDate(transaction.createdAt),
                    ),
                    _Row(
                      label: 'Reference',
                      value: transaction.reference ?? transaction.id,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Back to home',
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'View history',
                onPressed: () => context.go(AppRoutes.history),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
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
