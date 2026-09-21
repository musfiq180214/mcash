import 'package:easy_localization/easy_localization.dart';
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
    _Service('service.send_money', 'assets/images/send_money_icon.jpeg', AppRoutes.sendMoney, AppColors.primary),
    _Service('service.recharge', 'assets/images/mobile_recharge_icon.jpg', AppRoutes.recharge, AppColors.info),
    _Service('service.bill', 'assets/images/bill_payment_icon.jpeg', AppRoutes.billPayment, AppColors.success),
    _Service('service.cash_out', 'assets/images/cash_out_icon.jpg', AppRoutes.cashOut, AppColors.warning),
    _Service('service.qr_pay', 'assets/images/qr_pay_icon.jpg', AppRoutes.qrPay, AppColors.violet),
    _Service('service.merchant_pay', 'assets/images/marchant_pay.jpg', AppRoutes.qrPay, AppColors.navy),
    _Service('service.top_up', 'assets/images/top_up.jpg', AppRoutes.topUp, Color(0xFF009688)),
    _Service('service.more', null, null, AppColors.textSecondary),
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
    final color = service.color;

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
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: service.imagePath != null
                ? ColorFiltered(
                    colorFilter: ColorFilter.matrix(<double>[
                      1.0 - (color.r), 0, 0, 0, color.r * 255.0,
                      0, 1.0 - (color.g), 0, 0, color.g * 255.0,
                      0, 0, 1.0 - (color.b), 0, color.b * 255.0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: Image.asset(
                      service.imagePath!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.apps_rounded,
                    size: 26,
                    color: color,
                  ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            service.label.tr(),
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
  const _Service(this.label, this.imagePath, this.route, this.color);

  final String label;
  final String? imagePath;
  final String? route;
  final Color color;
}
