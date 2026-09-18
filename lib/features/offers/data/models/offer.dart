import 'package:flutter/material.dart';

enum OfferCategory { recharge, billPay, sendMoney, merchantPay, others }

class OfferModel {
  const OfferModel({
    required this.id,
    required this.title,
    required this.cashback,
    required this.validTill,
    required this.category,
    required this.icon,
    required this.color,
  });

  final String id;
  final String title;
  final double cashback;
  final DateTime validTill;
  final OfferCategory category;
  final IconData icon;
  final Color color;
}
