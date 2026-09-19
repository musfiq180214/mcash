import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/i_offers_repository.dart';
import '../data/offers_repository.dart';
import '../domain/offer.dart';

final offersRepositoryProvider = Provider<IOffersRepository>((ref) {
  return OffersRepository();
});

final offerFilterProvider =
    StateProvider.autoDispose<OfferCategory?>((ref) => null);

final offersProvider = Provider<List<OfferModel>>((ref) {
  return ref.watch(offersRepositoryProvider).getOffers();
});

final filteredOffersProvider = Provider.autoDispose<List<OfferModel>>((ref) {
  final offers = ref.watch(offersProvider);
  final filter = ref.watch(offerFilterProvider);
  if (filter == null) return offers;
  return offers.where((offer) => offer.category == filter).toList();
});
