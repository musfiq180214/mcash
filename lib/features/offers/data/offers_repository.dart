import 'package:flutter/material.dart';
import '../domain/offer.dart';
import 'i_offers_repository.dart';

class OffersRepository implements IOffersRepository {
  @override
  List<OfferModel> getOffers() {
    final now = DateTime.now();
    return [
      OfferModel(
        id: 'of_1',
        title: 'Mobile Recharge',
        cashback: 10,
        validTill: now.add(const Duration(days: 13)),
        category: OfferCategory.recharge,
        icon: Icons.smartphone_rounded,
        color: const Color(0xFF2563EB),
      ),
      OfferModel(
        id: 'of_2',
        title: 'Bill Payment',
        cashback: 20,
        validTill: now.add(const Duration(days: 13)),
        category: OfferCategory.billPay,
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFF16A34A),
      ),
      OfferModel(
        id: 'of_3',
        title: 'Send Money',
        cashback: 5,
        validTill: now.add(const Duration(days: 8)),
        category: OfferCategory.sendMoney,
        icon: Icons.send_rounded,
        color: const Color(0xFF7C3AED),
      ),
      OfferModel(
        id: 'of_4',
        title: 'Merchant Pay',
        cashback: 15,
        validTill: now.add(const Duration(days: 3)),
        category: OfferCategory.merchantPay,
        icon: Icons.storefront_rounded,
        color: const Color(0xFFF97316),
      ),
    ];
  }
}
