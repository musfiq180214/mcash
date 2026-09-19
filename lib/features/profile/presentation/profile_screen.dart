import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/authHelper/auth_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/selectable_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            120,
          ),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primarySoft,
                  child: Text(
                    (user?.name.isNotEmpty ?? false)
                        ? user!.name.substring(0, 1).toUpperCase()
                        : 'M',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'MCash user',
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        Formatters.maskedMobile(user?.mobile ?? ''),
                        style: AppTypography.label,
                      ),
                      if (user?.isVerified ?? false) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.pill),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded,
                                  size: 13, color: AppColors.success),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _Group(
              children: [
                const NavigationTile(
                  title: 'Personal information',
                  icon: Icons.person_outline_rounded,
                ),
                const NavigationTile(
                  title: 'Security & privacy',
                  icon: Icons.shield_outlined,
                ),
                const NavigationTile(
                  title: 'Linked accounts',
                  icon: Icons.link_rounded,
                ),
                const NavigationTile(
                  title: 'Notifications',
                  icon: Icons.notifications_none_rounded,
                ),
                NavigationTile(
                  title: 'Language',
                  icon: Icons.language_rounded,
                  subtitle: context.locale.languageCode == 'bn'
                      ? 'বাংলা'
                      : 'English',
                  onTap: () => _toggleLanguage(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _Group(
              children: [
                NavigationTile(
                  title: 'Help & support',
                  icon: Icons.headset_mic_outlined,
                  onTap: () => context.push(AppRoutes.support),
                ),
                const NavigationTile(
                  title: 'About MCash',
                  icon: Icons.info_outline_rounded,
                ),
                NavigationTile(
                  title: 'Log out',
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.danger,
                  trailing: const SizedBox.shrink(),
                  onTap: () => _confirmLogout(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleLanguage(BuildContext context) async {
    final next = context.locale.languageCode == 'bn'
        ? const Locale('en')
        : const Locale('bn');
    await context.setLocale(next);
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out of MCash?'),
        content: const Text(
          'You will need your PIN to sign back in on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay signed in'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(indent: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}
