import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/authHelper/auth_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../wallet/provider/wallet_provider.dart';
import '../../wallet/widgets/transaction_tile.dart';
import '../widgets/balance_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/service_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final wallet = ref.watch(walletProvider);
    final recent = ref.watch(recentTransactionsProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(walletProvider.notifier).load(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _Header(
              name: user?.name ?? 'there',
              balance: wallet.snapshot.balance,
              isLoading: wallet.isLoading,
              onAddMoney: () => context.push(AppRoutes.topUp),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceGrid(
                    onMore: () => _showMoreServices(context),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PromoBanner(onTap: () => context.go(AppRoutes.offers)),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent activity',
                        style: AppTypography.sectionTitle,
                      ),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.history),
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (recent.isEmpty)
                    const _EmptyActivity()
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < recent.length; i++) ...[
                            TransactionTile(transaction: recent[i]),
                            if (i != recent.length - 1)
                              const Divider(indent: AppSpacing.lg),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreServices(BuildContext context) {
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
            const Text('More services', style: AppTypography.sectionTitle),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Shops, travel, tickets and games are rolling out region by region.',
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.name,
    required this.balance,
    required this.isLoading,
    required this.onAddMoney,
  });

  final String name;
  final double balance;
  final bool isLoading;
  final VoidCallback onAddMoney;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        MediaQuery.of(context).padding.top + AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'MCash',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: onAddMoney,
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withOpacity(0.25),
                child: Text(
                  name.isEmpty ? 'M' : name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, $name',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'আপনার অ্যাকাউন্ট নিরাপদ আছে',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          BalanceCard(
            balance: balance,
            isLoading: isLoading,
            onAddMoney: onAddMoney,
          ),
        ],
      ),
    );
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 28, color: AppColors.textTertiary),
          SizedBox(height: AppSpacing.md),
          Text(
            'Your payments will show up here.',
            style: AppTypography.body,
          ),
        ],
      ),
    );
  }
}
