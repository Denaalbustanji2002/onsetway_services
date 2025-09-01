// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';

class EnhancedTabHeader extends StatelessWidget {
  const EnhancedTabHeader({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[850]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ConstColor.gold.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [ConstColor.gold, ConstColor.darkGold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: ConstColor.gold.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorWeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white60,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: const [
          Tab(
            icon: Icon(Icons.event_available, size: 20),
            text: 'Available',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
          Tab(
            icon: Icon(Icons.book_online_outlined, size: 20),
            text: 'My Bookings',
            iconMargin: EdgeInsets.only(bottom: 2),
          ),
        ],
      ),
    );
  }
}
