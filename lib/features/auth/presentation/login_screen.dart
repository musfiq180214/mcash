import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/authHelper/auth_controller.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isPinHidden = true;

  @override
  void dispose() {
    _mobileController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();

    await ref.read(authControllerProvider.notifier).login(
          mobile: _mobileController.text.trim(),
          pin: _pinController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in with the number linked to your wallet.',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'New to MCash?',
            style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.signup),
            child: const Text('Create an account'),
          ),
        ],
      ),
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
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'PIN',
              controller: _pinController,
              hint: '••••',
              obscureText: _isPinHidden,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.pin,
              suffix: IconButton(
                onPressed: () => setState(() => _isPinHidden = !_isPinHidden),
                icon: Icon(
                  _isPinHidden
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push(AppRoutes.forgotPassword),
                child: const Text('Forgot PIN?'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: 'Sign in',
              isLoading: auth.isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
