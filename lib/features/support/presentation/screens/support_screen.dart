import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/selectable_tile.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      gradient: AppColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.headset_mic_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Need help?', style: AppTypography.sectionTitle),
                        SizedBox(height: 2),
                        Text(
                          'We are here for you, 24 hours a day.',
                          style: AppTypography.label,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  NavigationTile(
                    title: 'Live chat',
                    subtitle: 'Chat with our support team',
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () => _open(context, 'Live chat'),
                  ),
                  const Divider(indent: AppSpacing.lg),
                  NavigationTile(
                    title: 'FAQs',
                    subtitle: 'Find quick answers',
                    icon: Icons.help_outline_rounded,
                    onTap: () => _open(context, 'FAQs'),
                  ),
                  const Divider(indent: AppSpacing.lg),
                  NavigationTile(
                    title: 'Call us',
                    subtitle: '16167',
                    icon: Icons.call_rounded,
                    onTap: () => _open(context, 'Dialer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String destination) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$destination opens once the channel is live.')),
    );
  }
}
