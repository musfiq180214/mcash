# MCash

Digital wallet app built on the `flutter_base` Feature-Driven Clean Architecture.
Eleven screens from the product design are implemented end to end: home, send
money, mobile recharge, bill payment, cash out, transaction history, QR pay,
top up, offers, profile and support, plus login, signup and PIN reset.

## Run it

```bash
flutter pub get

# Staging
flutter run --flavor staging -t lib/main_staging.dart

# Production
flutter run --flavor prod -t lib/main_production.dart

flutter test
```

The build ships with offline repositories, so it runs without a backend. Sign in
with any valid Bangladeshi number (`01XXXXXXXXX`) and any 4–6 digit PIN. The
seeded wallet starts at ৳ 12,450.00 with six transactions.

## How money moves

Every flow — send, recharge, bill, cash out, top up — builds a
`TransactionModel` and hands it to `WalletNotifier.commit()`. That notifier is
the only writer of balance state, so balance arithmetic, insufficient-funds
checks and history all live in one place. Add a flow by writing a form notifier
that produces a transaction; nothing else needs to change.

```
Screen → Feature Notifier → WalletNotifier → WalletRepository → Hive / API
```

## Layout

```text
lib/
├── core/
│   ├── config/          FlavorConfig — staging vs production
│   ├── network/         Dio client, interceptors (auth/log/error), ApiResult
│   ├── navigation/      GoRouter + the authorization observer, AppRoutes
│   ├── theme/           Colors, typography, spacing, ThemeData
│   ├── authHelper/      AuthUser, AuthState, AuthController
│   ├── storage/         Hive cache + secure token storage
│   ├── connectivity/    Network status stream and the global offline banner
│   ├── utils/           Validators, money and date formatters
│   └── widgets/         PrimaryButton, AppTextField, AmountChips, AppShell …
├── features/
│   ├── auth/            Login, signup, forgot PIN
│   ├── landing/         Home dashboard
│   ├── wallet/          Shared transaction domain, balance, receipts
│   ├── send_money/      recharge/  bill_payment/  cash_out/  top_up/
│   ├── history/         qr_pay/  offers/  profile/  support/
│   └── …                each: data/ (models, repository) + presentation/
└── main_staging.dart | main_production.dart → bootstrap.dart → app.dart
```

## Decisions worth knowing

**Repositories are swappable.** `walletRepositoryProvider` and
`authRepositoryProvider` currently return the local/demo implementations. Each
file also contains the Dio-backed implementation — change the one line in the
provider to go live. No widget or notifier is aware of the difference.

**Routing enforces access, screens don't.** `routerProvider` listens to
`authControllerProvider` and redirects on every auth change. A signed-out user
cannot reach a wallet route, and logging out from Profile drops the whole stack
back to login without any screen calling `pop`.

**No generated code required.** Models carry hand-written `fromJson`/`toJson`
and Hive stores plain maps, so `build_runner` is optional rather than a
prerequisite for a first run.

**Fees are shown before approval.** Cash out prints the agent fee and the total
deduction above the button, and `TransactionModel.total` is what the wallet
debits.

## What is stubbed

Camera scanning, gallery import, sharing and the contact picker show a message
instead of acting — they need platform plugins and permissions wired per
platform. The remaining screens are functional.

## Localization

English and Bangla, via `easy_localization` with JSON in
`assets/translations/`. Switch language from Profile → Language.
