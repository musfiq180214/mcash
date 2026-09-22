import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/authHelper/auth_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        color: AppColors.cyberBlue,
        onRefresh: () => ref.read(walletProvider.notifier).load(),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyberBlue.withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyberViolet.withOpacity(0.1),
                ),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                _Header(
                  name: user?.name ?? 'there',
                  balance: wallet.snapshot.balance,
                  isLoading: wallet.isLoading,
                  onAddMoney: () {
                    HapticService.light();
                    context.push(AppRoutes.topUp);
                  },
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
                        onMore: () {
                          HapticService.selection();
                          _showMoreServices(context);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PromoBanner(onTap: () {
                        HapticService.light();
                        context.go(AppRoutes.offers);
                      }),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent activity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              HapticService.selection();
                              context.go(AppRoutes.history);
                            },
                            child: const Text(
                              'See all',
                              style: TextStyle(color: AppColors.cyberBlue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (recent.isEmpty)
                        const _EmptyActivity()
                      else
                        GlassCard(
                          opacity: 0.05,
                          child: Column(
                            children: [
                              for (var i = 0; i < recent.length; i++) ...[
                                TransactionTile(transaction: recent[i]),
                                if (i != recent.length - 1)
                                  Divider(
                                    indent: AppSpacing.lg,
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
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
      decoration: BoxDecoration(
        gradient: AppColors.cyberGradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppSpacing.radiusXl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyberBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Text(
                    'M',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'MCash',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  HapticService.selection();
                },
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticService.selection();
                },
                icon: const Icon(Icons.grid_view_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: Text(
                    name.isEmpty ? 'M' : name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Futuristic Wallet Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
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
