import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final Gradient? gradient;

  const GlassCard({
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.1,
    this.borderRadius = AppSpacing.radiusLg,
    this.padding,
    this.border,
    this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ?? Border.all(color: AppColors.glassBorder, width: 0.5),
            gradient: gradient ?? AppColors.glassGradient,
          ),
          child: child,
        ),
      ),
    );
  }
}
