import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/bill_payment/presentation/screens/bill_payment_screen.dart';
import '../../features/cash_out/presentation/screens/cash_out_screen.dart';
import '../../features/history/presentation/screens/transaction_history_screen.dart';
import '../../features/landing/presentation/screens/home_screen.dart';
import '../../features/offers/presentation/screens/offers_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/qr_pay/presentation/screens/qr_pay_screen.dart';
import '../../features/recharge/presentation/screens/mobile_recharge_screen.dart';
import '../../features/send_money/presentation/screens/send_money_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../../features/top_up/presentation/screens/top_up_wallet_screen.dart';
import '../../features/wallet/data/models/transaction.dart';
import '../../features/wallet/presentation/screens/transaction_success_screen.dart';
import '../authHelper/auth_controller.dart';
import '../authHelper/auth_state.dart';
import '../widgets/app_shell.dart';
import 'app_routes.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

/// The authorization observer: routing listens to [authControllerProvider] and
/// redirects on every state change, so no screen has to police access itself.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(
    authControllerProvider,
    (_, __) => refresh.value++,
  );
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isOnAuthScreen = location == AppRoutes.login ||
          location == AppRoutes.signup ||
          location == AppRoutes.forgotPassword;

      if (auth.isResolving) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (!auth.isAuthenticated) {
        return isOnAuthScreen ? null : AppRoutes.login;
      }
      if (isOnAuthScreen || location == AppRoutes.splash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const TransactionHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.offers,
                builder: (context, state) => const OffersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.sendMoney,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SendMoneyScreen(),
      ),
      GoRoute(
        path: AppRoutes.recharge,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const MobileRechargeScreen(),
      ),
      GoRoute(
        path: AppRoutes.billPayment,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const BillPaymentScreen(),
      ),
      GoRoute(
        path: AppRoutes.cashOut,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const CashOutScreen(),
      ),
      GoRoute(
        path: AppRoutes.qrPay,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const QrPayScreen(),
      ),
      GoRoute(
        path: AppRoutes.topUp,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const TopUpWalletScreen(),
      ),
      GoRoute(
        path: AppRoutes.support,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: AppRoutes.success,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => TransactionSuccessScreen(
          transaction: state.extra! as TransactionModel,
        ),
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorScreen(location: state.uri.toString()),
  );
});

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2.4),
      ),
    );
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nothing lives at $location.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
