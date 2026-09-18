import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

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
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: const BoxDecoration(
          gradient: AppColors.brandGradient,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.push(AppRoutes.qrPay),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
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
    );
  }

  Widget _tab(BuildContext context, _Destination destination) {
    final isActive = navigationShell.currentIndex == destination.branch;
    final color = isActive ? AppColors.primary : AppColors.textTertiary;

    return Expanded(
      child: InkWell(
        onTap: () => navigationShell.goBranch(
          destination.branch,
          initialLocation: destination.branch == navigationShell.currentIndex,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(destination.icon, size: 22, color: color),
            const SizedBox(height: AppSpacing.xs),
            Text(
              destination.label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: color,
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
