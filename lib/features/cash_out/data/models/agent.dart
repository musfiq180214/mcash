import 'package:flutter/material.dart';

/// Cash-out partners. Each carries its own fee so the receipt can show the
/// real cost before the user commits.
class CashOutAgent {
  const CashOutAgent({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.feePercent,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final double feePercent;

  double feeFor(double amount) => amount * feePercent / 100;

  static const all = <CashOutAgent>[
    CashOutAgent(
      id: 'bkash',
      name: 'bKash Agent',
      icon: Icons.storefront_rounded,
      color: Color(0xFFE2136E),
      feePercent: 1.85,
    ),
    CashOutAgent(
      id: 'nagad',
      name: 'Nagad Agent',
      icon: Icons.store_mall_directory_rounded,
      color: Color(0xFFF15A29),
      feePercent: 1.5,
    ),
    CashOutAgent(
      id: 'rocket',
      name: 'Rocket Agent',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF8A2BE2),
      feePercent: 1.8,
    ),
  ];
}
