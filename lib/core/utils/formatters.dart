import 'package:intl/intl.dart';

/// Display helpers. Money is always rendered with the ৳ sign in front.
class Formatters {
  const Formatters._();

  static final NumberFormat _money = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _compact = NumberFormat('#,##0', 'en_US');

  static String money(num value) => '৳ ${_money.format(value)}';

  static String compactMoney(num value) => '৳ ${_compact.format(value)}';

  static String signedMoney(num value) {
    final sign = value < 0 ? '-' : '+';
    return '$sign৳ ${_compact.format(value.abs())}';
  }

  static String maskedMobile(String mobile) {
    if (mobile.length < 11) return mobile;
    return '${mobile.substring(0, 2)}XXXXXXX${mobile.substring(9)}';
  }

  static String transactionDate(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(time.year, time.month, time.day);
    final clock = DateFormat('h:mm a').format(time);

    if (that == today) return 'Today, $clock';
    if (that == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, $clock';
    }
    return DateFormat('MMM d, yyyy').format(time);
  }

  static String shortDate(DateTime time) => DateFormat('d MMM yyyy').format(time);
}
