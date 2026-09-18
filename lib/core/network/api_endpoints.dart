/// Single source of truth for every remote path the app talks to.
class ApiEndpoints {
  const ApiEndpoints._();

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String refreshToken = '/auth/refresh';
  static const String profile = '/user/profile';

  static const String wallet = '/wallet';
  static const String transactions = '/wallet/transactions';
  static const String sendMoney = '/wallet/send-money';
  static const String cashOut = '/wallet/cash-out';
  static const String topUp = '/wallet/top-up';

  static const String operators = '/recharge/operators';
  static const String recharge = '/recharge';

  static const String billers = '/bills/billers';
  static const String payBill = '/bills/pay';

  static const String offers = '/offers';
}
