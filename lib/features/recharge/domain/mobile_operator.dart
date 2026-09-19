import 'package:flutter/material.dart';

/// Operators are static reference data; the remote catalogue can override
/// this list without changing any widget.
class MobileOperator {
  const MobileOperator({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;

  static const all = <MobileOperator>[
    MobileOperator(
      id: 'gp',
      name: 'Grameenphone',
      icon: Icons.signal_cellular_alt_rounded,
      color: Color(0xFF00A6E3),
    ),
    MobileOperator(
      id: 'robi',
      name: 'Robi',
      icon: Icons.circle_rounded,
      color: Color(0xFFE2231A),
    ),
    MobileOperator(
      id: 'bl',
      name: 'Banglalink',
      icon: Icons.podcasts_rounded,
      color: Color(0xFFF26522),
    ),
    MobileOperator(
      id: 'teletalk',
      name: 'Teletalk',
      icon: Icons.cell_tower_rounded,
      color: Color(0xFF1C9E5A),
    ),
  ];
}

enum ConnectionType { prepaid, postpaid }
