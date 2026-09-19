import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/section_card.dart';
import '../domain/offer.dart';
import '../provider/offers_provider.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  static const _filters = <(String, OfferCategory?)>[
    ('All', null),
    ('Recharge', OfferCategory.recharge),
    ('Bill Pay', OfferCategory.billPay),
    ('Others', OfferCategory.others),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(offerFilterProvider);
    final offers = ref.watch(filteredOffersProvider);
    final matchIndex = _filters.indexWhere((entry) => entry.$2 == filter);
    final selectedIndex = matchIndex < 0 ? 0 : matchIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Rewards'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            120,
          ),
          children: [
            const _FeaturedOffer(),
            const SizedBox(height: AppSpacing.xl),
            SegmentedTabs(
              labels: [for (final entry in _filters) entry.$1],
              selectedIndex: selectedIndex,
              onChanged: (index) => ref
                  .read(offerFilterProvider.notifier)
                  .state = _filters[index].$2,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (offers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(
                  child: Text(
                    'No running offers in this category.',
                    style: AppTypography.body,
                  ),
                ),
              )
            else
              for (final offer in offers) ...[
                _OfferTile(offer: offer),
                const SizedBox(height: AppSpacing.sm),
              ],
          ],
        ),
      ),
    );
  }
}

class _FeaturedOffer extends StatelessWidget {
  const _FeaturedOffer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special offers',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  'পেমেন্টে পান আকর্ষণীয়\nক্যাশব্যাক!',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferTile extends StatelessWidget {
  const _OfferTile({required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: offer.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(offer.icon, size: 20, color: offer.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${Formatters.compactMoney(offer.cashback)} cashback',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Valid till ${Formatters.shortDate(offer.validTill)}',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
