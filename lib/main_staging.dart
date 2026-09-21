import 'core/utils/enums.dart';
import 'flavor_config.dart';
import 'main.dart';
import 'core/constants/urls.dart';

void main() async {
 FlavorConfig.instantiate(
   flavor: Flavor.staging,
   baseUrl: baseUrlDevelopment,
   appTitle: 'MCash Staging',
   enableLogging: true,
 );
 await mcash();
}
