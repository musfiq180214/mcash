import '../domain/biller.dart';

abstract interface class IBillPaymentRepository {
  List<BillerCategory> getCategories();
}
