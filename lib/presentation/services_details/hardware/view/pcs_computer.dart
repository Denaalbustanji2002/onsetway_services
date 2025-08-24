import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/Smart_header.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/enhanced_pattern_painter.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/smart_navigation.dart';

class PcsComputerScreen extends StatefulWidget {
  const PcsComputerScreen({super.key});

  @override
  State<PcsComputerScreen> createState() => _PcsComputerScreenState();
}

class _PcsComputerScreenState extends State<PcsComputerScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;
  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "PC Components & Accessories",
      description: "Perfect solution for all business categories",
      bulletPoints: [
        "RAM, SSDs, Graphics → Performance speed reliability",
        "Monitors, Keyboards, Mice → Productivity comfort essentials",
        "Cooling Systems Upgrades → Efficient professional cooling",
        "Windows Office Licenses ",
      ],
      icon: Icons.store_outlined,
      image: "assets/hardware/pc/pc3.webp",
      accentColor: Colors.blue,
    ),
    FeatureCardModel(
      title: "PCs & Computer Hardware — Supplied by Onset Way",
      description: "Cutting-edge technology with enterprise-grade capabilities",
      bulletPoints: [
        "High-performance, reliable PCs",
        "Tailored for business, gaming, design & study",
        "Work smarter, play harder",
        "Upgrade with confidence",
      ],

      icon: Icons.desktop_windows_outlined, // updated to a web-related icon
      image: "assets/hardware/pc/pczoneaboutus.jpg",
      accentColor: Colors.green,
    ),


    FeatureCardModel(
      title: "Why Choose Onset Way?",
      description: "Trusted partner with proven track record of excellence",
      bulletPoints: [
        "Device Recommendations",
        "PC Supply & Delivery",
        "Upgrades & Customizations",
        "Setup & After-Sale Support",

      ],
      icon: Icons.verified_outlined,
      image: "assets/picture/about us.webp",
      accentColor: Colors.purple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );
    _headerController.forward();
    _indicatorController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  void _handleContactUs() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Contact form opened'),
        backgroundColor: ConstColor.gold,
      ),
    );
  }

  void _handleGetQuote() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Quote request submitted'),
        backgroundColor: ConstColor.gold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUi(context);
    final double androidScaleFactor = Platform.isAndroid ? 0.7 : 1.0;
    double scale(double value) => value * androidScaleFactor;

    return OWPScaffold(
      title: 'PC\'S & Computer',
      body: Column(
        children: [
          SlideTransition(
            position: _headerSlideAnimation,
            child: FadeTransition(
              opacity: _headerFadeAnimation,
              child: SmartHeader(responsive: responsive, scale: scale),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: features.length,
              onPageChanged: (index) {
                setState(() => currentPage = index);
                _indicatorController.reset();
                _indicatorController.forward();
              },
              itemBuilder: (context, index) {
                return FeatureCard(
                  feature: features[index],
                  responsive: responsive,
                  isActive: currentPage == index,
                  onContactUs: _handleContactUs,
                  onGetQuote: _handleGetQuote,
                );
              },
            ),
          ),
          SmartNavigation(
            features: features,
            currentPage: currentPage,
            responsive: responsive,
            scale: scale,
            indicatorController: _indicatorController,
            pageController: _pageController,
          ),
        ],
      ),
    );
  }
}