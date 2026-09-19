import '../domain/offer.dart';

abstract interface class IOffersRepository {
  List<OfferModel> getOffers();
}
