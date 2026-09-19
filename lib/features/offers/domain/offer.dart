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

  // Add fromJson/toJson if necessary as requested
  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id'] as String,
        title: json['title'] as String,
        cashback: (json['cashback'] as num).toDouble(),
        validTill: DateTime.parse(json['validTill'] as String),
        category: OfferCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => OfferCategory.others,
        ),
        icon: IconData(json['icon'] as int, fontFamily: 'MaterialIcons'),
        color: Color(json['color'] as int),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cashback': cashback,
        'validTill': validTill.toIso8601String(),
        'category': category.name,
        'icon': icon.codePoint,
        'color': color.value,
      };
}
