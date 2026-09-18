import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Labelled field used across the wallet flows. The label sits above the box
/// so long Bangla strings never truncate inside the input.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffix,
    this.prefixText,
    this.maxLength,
    this.obscureText = false,
    this.enabled = true,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final String? prefixText;
  final int? maxLength;
  final bool obscureText;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.label),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          enabled: enabled,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            counterText: '',
            suffixIcon: suffix,
            prefixIcon: prefixText == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.sm,
                    ),
                    child: Text(
                      prefixText!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
          ),
        ),
      ],
    );
  }
}

/// Numeric money input with a permanent ৳ prefix.
class AmountField extends StatelessWidget {
  const AmountField({
    required this.controller,
    this.label = 'Amount',
    this.validator,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      controller: controller,
      hint: '0',
      prefixText: '৳',
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      validator: validator,
      onChanged: onChanged,
    );
  }
}
