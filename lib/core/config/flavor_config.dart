enum Flavor { staging, production }

/// Environment configuration resolved once at startup by the entry points in
/// `main_staging.dart` / `main_production.dart`.
class FlavorConfig {
  FlavorConfig._({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
  });

  static FlavorConfig? _instance;

  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableLogging;

  static FlavorConfig get instance {
    final config = _instance;
    if (config == null) {
      throw StateError('FlavorConfig.initialize() must run before use.');
    }
    return config;
  }

  static bool get isProduction => instance.flavor == Flavor.production;

  static FlavorConfig initialize(Flavor flavor) {
    _instance = switch (flavor) {
      Flavor.staging => FlavorConfig._(
          flavor: flavor,
          appName: 'MCash Staging',
          baseUrl: 'https://staging-api.mcash.app/v1',
          enableLogging: true,
        ),
      Flavor.production => FlavorConfig._(
          flavor: flavor,
          appName: 'MCash',
          baseUrl: 'https://api.mcash.app/v1',
          enableLogging: false,
        ),
    };
    return _instance!;
  }
}
