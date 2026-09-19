import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// The eight primary actions. Order matches how often people reach for them,
/// with "More" parked last so the grid stays a stable 4x2.
class ServiceGrid extends StatelessWidget {
  const ServiceGrid({this.onMore, super.key});

  final VoidCallback? onMore;

  static const _services = <_Service>[
    _Service('Send\nMoney', Icons.send_rounded, AppRoutes.sendMoney),
    _Service('Mobile\nRecharge', Icons.smartphone_rounded, AppRoutes.recharge),
    _Service('Bill\nPayment', Icons.receipt_long_rounded, AppRoutes.billPayment),
    _Service('Cash\nOut', Icons.account_balance_wallet_rounded, AppRoutes.cashOut),
    _Service('QR Pay', Icons.qr_code_scanner_rounded, AppRoutes.qrPay),
    _Service('Merchant\nPay', Icons.storefront_rounded, AppRoutes.qrPay),
    _Service('Top Up\nWallet', Icons.add_card_rounded, AppRoutes.topUp),
    _Service('More', Icons.apps_rounded, null),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final service = _services[index];
        return _ServiceButton(
          service: service,
          onTap: () {
            final route = service.route;
            if (route == null) {
              onMore?.call();
            } else {
              context.push(route);
            }
          },
        );
      },
    );
  }
}

class _ServiceButton extends StatelessWidget {
  const _ServiceButton({required this.service, required this.onTap});

  final _Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(service.icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            service.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
              height: 1.25,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Service {
  const _Service(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String? route;
}
