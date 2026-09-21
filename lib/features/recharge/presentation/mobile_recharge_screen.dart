import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/amount_chips.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/contacts_list.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/selectable_tile.dart';
import '../../wallet/provider/wallet_provider.dart';
import '../domain/mobile_operator.dart';
import '../provider/recharge_provider.dart';

class MobileRechargeScreen extends ConsumerStatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  ConsumerState<MobileRechargeScreen> createState() =>
      _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends ConsumerState<MobileRechargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _amountController = TextEditingController();
  int? _selectedPreset;

  static const _presets = [50, 100, 200, 500];

  @override
  void dispose() {
    _mobileController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(rechargeProvider.notifier)
      ..setMobile(_mobileController.text.trim())
      ..setAmount(double.tryParse(_amountController.text.trim()));

    final transaction = await notifier.submit();
    if (!mounted) return;

    if (transaction == null) {
      final message = ref.read(walletProvider).errorMessage ??
          'The recharge did not complete. Try again.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    context.go(AppRoutes.success, extra: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rechargeProvider);
    final balance = ref.watch(balanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Recharge')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SegmentedTabs(
                labels: const ['Prepaid', 'Postpaid'],
                selectedIndex: state.connectionType.index,
                onChanged: (index) => ref
                    .read(rechargeProvider.notifier)
                    .selectConnection(ConnectionType.values[index]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('Select operator', style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.md),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: MobileOperator.all.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.92,
                ),
                itemBuilder: (context, index) {
                  final operator = MobileOperator.all[index];
                  return SelectableTile(
                    label: operator.name,
                    icon: operator.icon,
                    color: operator.color,
                    isSelected: state.operator?.id == operator.id,
                    onTap: () => ref
                        .read(rechargeProvider.notifier)
                        .selectOperator(operator),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionCard(
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Mobile Number',
                      controller: _mobileController,
                      hint: '01XXXXXXXXX',
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: Validators.mobile,
                      suffix: IconButton(
                        icon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: _pickFromContacts,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AmountField(
                      controller: _amountController,
                      label: 'Recharge Amount',
                      validator: (value) => Validators.amount(
                        value,
                        min: 20,
                        max: 5000,
                        balance: balance,
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
              const SizedBox(height: AppSpacing.lg),
              ContactsList(
                onContactSelected: _onContactSelected,
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

  void _onContactSelected(String number) {
    setState(() {
      _mobileController.text = number;
      _mobileController.selection = TextSelection.fromPosition(
        TextPosition(offset: number.length),
      );
    });
    _autoDetectOperator(number);
  }

  void _autoDetectOperator(String number) {
    final cleaned = cleanPhoneNumber(number);
    if (cleaned.length >= 3) {
      final prefix = cleaned.substring(0, 3);
      MobileOperator? detected;
      if (prefix == '017' || prefix == '013') {
        detected = MobileOperator.all.firstWhere((o) => o.id == 'gp',
            orElse: () => MobileOperator.all.first);
      } else if (prefix == '018' || prefix == '016') {
        detected = MobileOperator.all.firstWhere((o) => o.id == 'robi',
            orElse: () => MobileOperator.all.first);
      } else if (prefix == '019' || prefix == '014') {
        detected = MobileOperator.all.firstWhere((o) => o.id == 'bl',
            orElse: () => MobileOperator.all.first);
      } else if (prefix == '015') {
        detected = MobileOperator.all.firstWhere((o) => o.id == 'teletalk',
            orElse: () => MobileOperator.all.first);
      }
      if (detected != null) {
        ref.read(rechargeProvider.notifier).selectOperator(detected);
      }
    }
  }

  Future<void> _pickFromContacts() async {
    final number = await pickContactFromDevice();
    if (!mounted) return;
    if (number != null) {
      _onContactSelected(number);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a contact from the list below.'),
        ),
      );
    }
  }
}
