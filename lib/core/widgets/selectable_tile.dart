import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Square picker used for operators, billers and agents.
class SelectableTile extends StatelessWidget {
  const SelectableTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.subLabel,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final String? subLabel;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? accent.withOpacity(0.08)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? accent
                : (isDark ? Colors.white.withOpacity(0.1) : AppColors.border),
            width: isSelected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: accent),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (subLabel != null)
              Text(
                subLabel!,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white54 : AppColors.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Row entry for settings, linked accounts and support options.
class NavigationTile extends StatelessWidget {
  const NavigationTile({
    required this.title,
    required this.icon,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.trailing,
    super.key,
  });

  final String title;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.cyberBlue : AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        leading: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: (iconColor ?? primaryColor).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, size: 19, color: iconColor ?? primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
        trailing: trailing ??
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.white38 : AppColors.textTertiary,
            ),
      ),
    );
  }
}
