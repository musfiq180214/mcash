import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/authHelper/auth_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/auth_scaffold.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    await ref.read(authControllerProvider.notifier).signup(
          name: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          pin: _pinController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Open your wallet',
      subtitle: 'It takes a minute. Your number becomes your account.',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Sign in'),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: 'Full Name',
              controller: _nameController,
              hint: 'Musfiq Rahman',
              textCapitalization: TextCapitalization.words,
              validator: (value) =>
                  Validators.notEmpty(value, label: 'Name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Mobile Number',
              controller: _mobileController,
              hint: '01XXXXXXXXX',
              keyboardType: TextInputType.phone,
              maxLength: 11,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.mobile,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Create PIN',
              controller: _pinController,
              hint: '••••',
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.pin,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Confirm PIN',
              controller: _confirmPinController,
              hint: '••••',
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => value == _pinController.text
                  ? null
                  : 'Both PINs must match',
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Create account',
              isLoading: auth.isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
