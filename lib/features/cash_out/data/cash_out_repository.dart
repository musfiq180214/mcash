import '../domain/agent.dart';
import 'i_cash_out_repository.dart';

class CashOutRepository implements ICashOutRepository {
  @override
  List<CashOutAgent> getAgents() => CashOutAgent.all;
}
