/// Form validation shared by every money-movement flow.
class Validators {
  const Validators._();

  static final RegExp _bdMobile = RegExp(r'^01[3-9]\d{8}$');
  static final RegExp _email = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');

  static String? mobile(String? value) {
    final input = value?.trim().replaceAll(RegExp(r'[\s-]'), '') ?? '';
    if (input.isEmpty) return 'Enter a mobile number';
    if (!_bdMobile.hasMatch(input)) return 'Enter a valid 11-digit number';
    return null;
  }

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return 'Enter your email';
    if (!_email.hasMatch(input)) return 'Enter a valid email';
    return null;
  }

  static String? pin(String? value) {
    final input = value?.trim() ?? '';
    if (input.length < 4) return 'PIN must be at least 4 digits';
    return null;
  }

  static String? notEmpty(String? value, {String label = 'This field'}) {
    if ((value ?? '').trim().isEmpty) return '$label is required';
    return null;
  }

  static String? amount(
    String? value, {
    double min = 10,
    double max = 50000,
    double? balance,
  }) {
    final parsed = double.tryParse((value ?? '').trim());
    if (parsed == null) return 'Enter an amount';
    if (parsed < min) return 'Minimum amount is ৳${min.toStringAsFixed(0)}';
    if (parsed > max) return 'Maximum amount is ৳${max.toStringAsFixed(0)}';
    if (balance != null && parsed > balance) return 'Not enough balance';
    return null;
  }
}
