import '../domain/mobile_operator.dart';

abstract interface class IRechargeRepository {
  List<MobileOperator> getOperators();
}
