import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/selectable_tile.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../data/models/biller.dart';
import '../providers/bill_payment_provider.dart';

class BillPaymentScreen extends ConsumerStatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  ConsumerState<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends ConsumerState<BillPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(billPaymentProvider.notifier)
      ..setAccountNumber(_accountController.text.trim())
      ..setAmount(double.tryParse(_amountController.text.trim()));

    final transaction = await notifier.submit();
    if (!mounted) return;

    if (transaction == null) {
      final message = ref.read(walletProvider).errorMessage ??
          'The bill was not paid. Try again.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    context.go(AppRoutes.success, extra: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billPaymentProvider);
    final balance = ref.watch(balanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bill Payment')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: BillerCategory.all.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final category = BillerCategory.all[index];
                  return SelectableTile(
                    label: category.name,
                    icon: category.icon,
                    color: category.color,
                    isSelected: state.category.id == category.id,
                    onTap: () => ref
                        .read(billPaymentProvider.notifier)
                        .selectCategory(category),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select provider', style: AppTypography.label),
                    const SizedBox(height: AppSpacing.sm),
                    DropdownButtonFormField<String>(
                      value: state.provider,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      items: [
                        for (final provider in state.category.providers)
                          DropdownMenuItem(
                            value: provider,
                            child: Text('$provider (${state.category.name})'),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(billPaymentProvider.notifier)
                            .selectProvider(value);
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Account / Customer Number',
                      controller: _accountController,
                      hint: '1234567890',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => Validators.notEmpty(
                        value,
                        label: 'Account number',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AmountField(
                      controller: _amountController,
                      validator: (value) => Validators.amount(
                        value,
                        max: 100000,
                        balance: balance,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Pay Now',
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
