import 'core/utils/enums.dart';

class FlavorConfig {
 final Flavor flavor;
 final String baseUrl;
 final String appTitle;
 final bool enableLogging;

 static FlavorConfig? _instance;

 FlavorConfig._internal(this.flavor, this.baseUrl, this.appTitle, this.enableLogging);

 static void instantiate({
   required Flavor flavor,
   required String baseUrl,
   required String appTitle,
   bool enableLogging = false,
 }) {
   _instance = FlavorConfig._internal(flavor, baseUrl, appTitle, enableLogging);
 }

 static FlavorConfig get instance {
   return _instance!;
 }

 static bool isStaging() => _instance?.flavor == Flavor.staging;
 static bool isProduction() => _instance?.flavor == Flavor.production;
}
