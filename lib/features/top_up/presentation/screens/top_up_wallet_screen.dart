import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/amount_chips.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../providers/top_up_provider.dart';

class TopUpWalletScreen extends ConsumerStatefulWidget {
  const TopUpWalletScreen({super.key});

  @override
  ConsumerState<TopUpWalletScreen> createState() => _TopUpWalletScreenState();
}

class _TopUpWalletScreenState extends ConsumerState<TopUpWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  int? _selectedPreset;

  static const _presets = [100, 500, 1000, 2000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(topUpProvider.notifier)
      ..setAmount(double.tryParse(_amountController.text.trim()));

    final transaction = await notifier.submit();
    if (!mounted) return;

    if (transaction == null) {
      final message = ref.read(walletProvider).errorMessage ??
          'The top up did not go through. Try again.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    context.go(AppRoutes.success, extra: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topUpProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Top Up Wallet')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Select method', style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              SectionCard(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Column(
                  children: [
                    for (final method in TopUpMethod.all)
                      RadioListTile<String>(
                        value: method.id,
                        groupValue: state.method.id,
                        activeColor: AppColors.primary,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        onChanged: (_) => ref
                            .read(topUpProvider.notifier)
                            .selectMethod(method),
                        title: Row(
                          children: [
                            Icon(method.icon, size: 20, color: method.color),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              method.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionCard(
                child: Column(
                  children: [
                    AmountField(
                      controller: _amountController,
                      validator: (value) => Validators.amount(
                        value,
                        min: 50,
                        max: 50000,
                      ),
                      onChanged: (_) => setState(() => _selectedPreset = null),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AmountChips(
                      presets: _presets,
                      selected: _selectedPreset,
                      onSelected: (value) {
                        setState(() => _selectedPreset = value);
                        _amountController.text = value.toString();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Proceed',
                isLoading: state.isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
