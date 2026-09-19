import 'package:flutter/material.dart';

class TopUpMethod {
  const TopUpMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;

  static const all = <TopUpMethod>[
    TopUpMethod(
      id: 'bkash',
      name: 'bKash',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFFE2136E),
    ),
    TopUpMethod(
      id: 'nagad',
      name: 'Nagad',
      icon: Icons.wallet_rounded,
      color: Color(0xFFF15A29),
    ),
    TopUpMethod(
      id: 'bank',
      name: 'Bank Transfer',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF2563EB),
    ),
    TopUpMethod(
      id: 'card',
      name: 'Card',
      icon: Icons.credit_card_rounded,
      color: Color(0xFF7C3AED),
    ),
  ];
}
