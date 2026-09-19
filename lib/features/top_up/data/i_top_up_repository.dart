import '../domain/top_up_method.dart';

abstract interface class ITopUpRepository {
  List<TopUpMethod> getMethods();
}
