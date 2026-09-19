import '../domain/mobile_operator.dart';
import 'i_recharge_repository.dart';

class RechargeRepository implements IRechargeRepository {
  @override
  List<MobileOperator> getOperators() => MobileOperator.all;
}
