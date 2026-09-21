import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/amount_chips.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/section_card.dart';
import '../../../core/widgets/contacts_list.dart';
import '../../wallet/provider/wallet_provider.dart';
import '../provider/send_money_provider.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  int? _selectedPreset;

  static const _presets = [100, 500, 1000, 5000];

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final notifier = ref.read(sendMoneyProvider.notifier)
      ..setRecipient(_recipientController.text.trim())
      ..setAmount(double.tryParse(_amountController.text.trim()))
      ..setNote(_noteController.text.trim());

    final transaction = await notifier.submit();
    if (!mounted) return;

    if (transaction == null) {
      final message = ref.read(walletProvider).errorMessage ??
          'The transfer did not go through. Try again.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    context.go(AppRoutes.success, extra: transaction);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sendMoneyProvider);
    final balance = ref.watch(balanceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SegmentedTabs(
                labels: const ['Mobile Number', 'Account Number', 'Scan QR'],
                selectedIndex: state.method.index,
                isPill: false,
                onChanged: (index) => ref
                    .read(sendMoneyProvider.notifier)
                    .selectMethod(SendMoneyMethod.values[index]),
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionCard(
                child: Column(
                  children: [
                    AppTextField(
                      label: state.method == SendMoneyMethod.accountNumber
                          ? 'Account Number'
                          : 'Mobile Number',
                      controller: _recipientController,
                      hint: '01XXXXXXXXX',
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
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
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Add a note (optional)',
                      controller: _noteController,
                      hint: 'e.g. রিকশা ভাড়া',
                      maxLength: 60,
                    ),
                  ],
                ),
              ),
              if (state.method == SendMoneyMethod.mobileNumber) ...[
                const SizedBox(height: AppSpacing.lg),
                ContactsList(
                  onContactSelected: _onContactSelected,
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: 'Send Money',
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
      _recipientController.text = number;
      _recipientController.selection = TextSelection.fromPosition(
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
