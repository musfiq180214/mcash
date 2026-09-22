import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/glass_card.dart';

/// The balance is the first thing a wallet user looks for, so it gets the
/// darkest surface on the screen and the largest type in the app.
class BalanceCard extends StatefulWidget {
  const BalanceCard({
    required this.balance,
    required this.onAddMoney,
    this.isLoading = false,
    super.key,
  });

  final double balance;
  final VoidCallback onAddMoney;
  final bool isLoading;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isHidden = false;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Balance',
                      style: AppTypography.label.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: () => setState(() => _isHidden = !_isHidden),
                      child: Icon(
                        _isHidden
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                if (widget.isLoading)
                  const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  Text(
                    _isHidden ? '৳ ••••••' : Formatters.money(widget.balance),
                    style: AppTypography.balance.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          _AddMoneyButton(onTap: widget.onAddMoney),
        ],
      ),
    );
  }
}

class _AddMoneyButton extends StatelessWidget {
  const _AddMoneyButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.18),
      borderRadius: BorderRadius.circular(AppSpacing.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.pill),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline_rounded,
                  size: 16, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Add Money',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
