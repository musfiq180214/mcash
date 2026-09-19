import '../domain/top_up_method.dart';
import 'i_top_up_repository.dart';

class TopUpRepository implements ITopUpRepository {
  @override
  List<TopUpMethod> getMethods() => TopUpMethod.all;
}
