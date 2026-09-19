import 'package:flutter/material.dart';

/// A biller category (electricity, water, …) and the providers under it.
class BillerCategory {
  const BillerCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.providers,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> providers;

  static const all = <BillerCategory>[
    BillerCategory(
      id: 'electricity',
      name: 'Electricity',
      icon: Icons.bolt_rounded,
      color: Color(0xFFE11D48),
      providers: ['DESCO', 'DPDC', 'NESCO', 'Palli Bidyut'],
    ),
    BillerCategory(
      id: 'water',
      name: 'Water',
      icon: Icons.water_drop_rounded,
      color: Color(0xFF2563EB),
      providers: ['Dhaka WASA', 'Chattogram WASA'],
    ),
    BillerCategory(
      id: 'gas',
      name: 'Gas',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFF97316),
      providers: ['Titas Gas', 'Jalalabad Gas'],
    ),
    BillerCategory(
      id: 'internet',
      name: 'Internet',
      icon: Icons.wifi_rounded,
      color: Color(0xFF0EA5E9),
      providers: ['Link3', 'Amber IT', 'Carnival'],
    ),
    BillerCategory(
      id: 'tv',
      name: 'TV',
      icon: Icons.tv_rounded,
      color: Color(0xFF7C3AED),
      providers: ['Akash DTH', 'Bengal Digital'],
    ),
    BillerCategory(
      id: 'education',
      name: 'Education',
      icon: Icons.school_rounded,
      color: Color(0xFF0891B2),
      providers: ['BRAC University', 'NSU', 'Scholastica'],
    ),
    BillerCategory(
      id: 'landline',
      name: 'Landline',
      icon: Icons.phone_in_talk_rounded,
      color: Color(0xFF16A34A),
      providers: ['BTCL'],
    ),
    BillerCategory(
      id: 'others',
      name: 'Others',
      icon: Icons.more_horiz_rounded,
      color: Color(0xFF64748B),
      providers: ['Municipality', 'Insurance'],
    ),
  ];
}
