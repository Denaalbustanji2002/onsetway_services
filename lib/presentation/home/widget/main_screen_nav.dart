import 'package:flutter/material.dart';

import '../../appointment/view/appointment.dart';
import '../../myoffer/view/myoffer.dart';
import '../../settings_main/view/setting_nav.dart';
import '../view/home_page.dart';
import 'buttom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;



  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomePage(),
      MyOffer(),
      Appointment(),
      SettingNav(),

    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // خلفية سوداء كاملة
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        color: const Color(0xFF000000), // يخلي الخلفية تحت البار سوداء
        child: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
  }