import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  /// shared preferences keys
  static const String keyAppThemeMode = 'keyAppThemeMode';
  static const TYPE_QUERY_ONLY_PRODUCT = 'ONLY_PRODUCT';
}

final tabs = [
  const Tab(text: "Tout"),
  const Tab(text: "En cours"),
  const Tab(text: "Payée"),
];

const List<Map<String, dynamic>> SETTLE_ORDERS = [
  {
    'name': 'Sur place',
    'id': 'ON_PLACE',
    'icon':
        "assets/svgs/onplace.svg", // Assuming OnPlace is a Dart class or a variable holding an icon
  },
  {
    'name': 'À emporter',
    'id': 'TAKE_AWAY',
    'icon':
        "assets/svgs/take_away_icon.svg", // Assuming TakeAway is a Dart class or a variable holding an icon
  },
  {
    'name': 'À livrer',
    'id': 'DELIVERED',
    'icon': 'assets/svgs/ic_round-delivery-dining.svg',
  },
];
