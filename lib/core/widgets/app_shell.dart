import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_routes.dart';
import '../services/haptic_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'glass_card.dart';

/// Persistent bottom navigation. Four destinations keep their own stack via
/// [StatefulNavigationShell]; the raised QR button is an action, not a tab, so
/// it pushes on top of whichever tab you are in.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = <_Destination>[
    _Destination(label: 'Home', icon: Icons.home_rounded, branch: 0),
    _Destination(label: 'History', icon: Icons.history_rounded, branch: 1),
    _Destination(label: 'Offers', icon: Icons.card_giftcard_rounded, branch: 2),
    _Destination(label: 'Profile', icon: Icons.person_rounded, branch: 3),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: navigationShell,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: AppColors.cyberGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.cyberBlue.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticService.medium();
              context.push(AppRoutes.qrPay);
            },
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: GlassCard(
          borderRadius: AppSpacing.pill,
          opacity: 0.1,
          blur: 20,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  _tab(context, _destinations[0]),
                  _tab(context, _destinations[1]),
                  const SizedBox(width: 64),
                  _tab(context, _destinations[2]),
                  _tab(context, _destinations[3]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, _Destination destination) {
    final isActive = navigationShell.currentIndex == destination.branch;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isActive
        ? AppColors.cyberBlue
        : (isDark ? Colors.white.withOpacity(0.5) : AppColors.textTertiary);

    return Expanded(
      child: InkWell(
        onTap: () {
          HapticService.light();
          navigationShell.goBranch(
            destination.branch,
            initialLocation: destination.branch == navigationShell.currentIndex,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isActive ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(destination.icon, size: 24, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              destination.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
                letterSpacing: 0.2,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 3,
                decoration: const BoxDecoration(
                  color: AppColors.cyberBlue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({
    required this.label,
    required this.icon,
    required this.branch,
  });

  final String label;
  final IconData icon;
  final int branch;
}
