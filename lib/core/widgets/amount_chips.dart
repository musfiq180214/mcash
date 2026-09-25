import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Preset amounts. Tapping one fills the amount field; the active preset
/// stays highlighted so the chosen value is obvious at a glance.
class AmountChips extends StatelessWidget {
  const AmountChips({
    required this.presets,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<int> presets;
  final int? selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final preset in presets)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: preset == presets.last ? 0 : AppSpacing.sm,
              ),
              child: _Chip(
                value: preset,
                isSelected: preset == selected,
                onTap: () => onSelected(preset),
              ),
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.cyberBlue : AppColors.primary)
              : (isDark ? Colors.white.withOpacity(0.08) : AppColors.field),
          borderRadius: BorderRadius.circular(AppSpacing.pill),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.cyberBlue : AppColors.primary)
                : (isDark ? Colors.white.withOpacity(0.15) : AppColors.border),
          ),
        ),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text(
              '৳ $value',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
