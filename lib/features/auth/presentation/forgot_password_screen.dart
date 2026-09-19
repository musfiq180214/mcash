import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/authHelper/auth_controller.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/auth_scaffold.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    final sent = await ref
        .read(authControllerProvider.notifier)
        .requestPasswordReset(_mobileController.text.trim());
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          sent
              ? 'We sent a reset code to your number.'
              : 'We could not send the code. Try again.',
        ),
      ),
    );
    if (sent) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Reset your PIN',
      subtitle: 'Enter your registered number and we will text a reset code.',
      child: Form(
        key: _formKey,
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
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Send reset code',
              isLoading: auth.isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
