import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// White panel that holds a form or a list. One radius, one hairline border,
/// no shadow stack — depth comes from the coloured header instead.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    super.key,
  });

  final Widget child;
  final String? title;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: title == null
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!, style: AppTypography.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                child,
              ],
            ),
    );
  }
}

/// Segmented control used for Prepaid/Postpaid and the history filters.
class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.isPill = true,
    super.key,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool isPill;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(
          isPill ? AppSpacing.pill : AppSpacing.radiusMd,
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      isPill ? AppSpacing.pill : AppSpacing.radiusSm,
                    ),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: i == selectedIndex
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
