import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

// Define bottom navigation bar items
const List<TabItem> baseItems = [
  TabItem(icon: Icons.home_rounded, title: 'Home'),
  TabItem(icon: Icons.local_offer_outlined, title: 'My Offer'),
  TabItem(icon: Icons.event_available_outlined, title: 'Appointment'),
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

    return Container(
      margin: const EdgeInsets.all(16),
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
        paddingVertical: 16.0, // زيادة المسافة الرأسية
        //paddingHorizontal: 24.0, // إضافة padding أفقي لجعل العناصر متباعدة أكثر
        borderRadius: BorderRadius.circular(30), // جعل الحواف أكثر استدارة
        iconSize: 27, // تكبير حجم الأيقونات
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }
}
