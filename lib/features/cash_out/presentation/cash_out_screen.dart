import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/amount_chips.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/contacts_list.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/selectable_tile.dart';
import '../../wallet/provider/wallet_provider.dart';
import '../domain/agent.dart';
import '../provider/cash_out_provider.dart';

class CashOutScreen extends ConsumerStatefulWidget {
  const CashOutScreen({super.key});

  @override
  ConsumerState<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends ConsumerState<CashOutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _agentController = TextEditingController();
  final _amountController = TextEditingController();
  int? _selectedPreset;

  static const _presets = [500, 1000, 2000, 5000];

  @override
  void dispose() {
    _agentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(cashOutProvider.notifier)
      ..setAgentNumber(_agentController.text.trim())
      ..setAmount(double.tryParse(_amountController.text.trim()));

    final transaction = await notifier.submit();
    if (!mounted) return;

    if (transaction == null) {
      final message = ref.read(walletProvider).errorMessage ??
          'The cash out request failed. Try again.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    context.go(AppRoutes.success, extra: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cashOutProvider);
    final balance = ref.watch(balanceProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Cash Out')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text(
                'Select agent',
                style: isDark
                    ? AppTypography.sectionTitle.copyWith(color: Colors.white)
                    : AppTypography.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  for (final agent in CashOutAgent.all)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: agent == CashOutAgent.all.last
                              ? 0
                              : AppSpacing.md,
                        ),
                        child: SelectableTile(
                          label: agent.name,
                          subLabel: '${agent.feePercent}% fee',
                          icon: agent.icon,
                          color: agent.color,
                          isSelected: state.agent.id == agent.id,
                          onTap: () => ref
                              .read(cashOutProvider.notifier)
                              .selectAgent(agent),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionCard(
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Agent Number',
                      controller: _agentController,
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
                      validator: (value) => Validators.amount(
                        value,
                        min: 50,
                        max: 25000,
                        balance: balance,
                      ),
                      onChanged: (value) {
                        setState(() => _selectedPreset = null);
                        ref
                            .read(cashOutProvider.notifier)
                            .setAmount(double.tryParse(value));
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AmountChips(
                      presets: _presets,
                      selected: _selectedPreset,
                      onSelected: (value) {
                        setState(() => _selectedPreset = value);
                        _amountController.text = value.toString();
                        ref
                            .read(cashOutProvider.notifier)
                            .setAmount(value.toDouble());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ContactsList(
                title: 'Contacts / Agents',
                onContactSelected: _onContactSelected,
              ),
              const SizedBox(height: AppSpacing.lg),
              _FeeSummary(
                fee: state.fee,
                total: state.total,
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Request Cash Out',
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
      _agentController.text = number;
      _agentController.selection = TextSelection.fromPosition(
        TextPosition(offset: number.length),
      );
    });
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

/// The fee is shown before the button, not after the fact — a cash out costs
/// money and the user should see the total they are approving.
class _FeeSummary extends StatelessWidget {
  const _FeeSummary({required this.fee, required this.total});

  final double fee;
  final double total;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.1)) : null,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cash out fee',
                style: AppTypography.label.copyWith(
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
              Text(
                Formatters.money(fee),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total deducted',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              Text(
                Formatters.money(total),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.cyberBlue : AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
