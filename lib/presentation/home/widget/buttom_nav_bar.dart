// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

// Define bottom navigation bar items
const List<TabItem> baseItems = [
  TabItem(icon: Icons.home_rounded, title: 'Home'),
  TabItem(icon: Icons.local_offer_outlined, title: 'My Offer'),
  TabItem(icon: Icons.event_available_outlined, title: 'Appointment'),
  TabItem(icon: Icons.person_outline, title: 'Be Partner'),
  TabItem(icon: Icons.settings_outlined, title: 'Settings'),
];

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    List<TabItem> items = List.from(baseItems);

    // فحص المنصة
    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    const double factor = 0.7;

    // القيم الأساسية
    const double baseIconSize = 29;
    const double baseFontSize = 14;
    const double basePaddingV = 13;
    const double baseMargin = 16;

    // إذا Android، نضرب بالـ factor
    final double iconSize = isAndroid ? baseIconSize * factor : baseIconSize;
    final double fontSize = isAndroid ? baseFontSize * factor : baseFontSize;
    final double paddingV = isAndroid ? basePaddingV * factor : basePaddingV;
    final double margin = isAndroid ? baseMargin * factor : baseMargin;

    return Container(
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomBarFloating(
        items: items,
        backgroundColor: const Color(0xFF222222),
        color: Colors.white.withOpacity(0.7),
        colorSelected: const Color(0xFF987A28),
        indexSelected: selectedIndex,
        paddingVertical: paddingV,
        borderRadius: BorderRadius.circular(30),
        iconSize: iconSize,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }
}
