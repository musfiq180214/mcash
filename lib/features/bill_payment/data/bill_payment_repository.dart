import '../domain/biller.dart';
import 'i_bill_payment_repository.dart';

class BillPaymentRepository implements IBillPaymentRepository {
  @override
  List<BillerCategory> getCategories() => BillerCategory.all;
}
