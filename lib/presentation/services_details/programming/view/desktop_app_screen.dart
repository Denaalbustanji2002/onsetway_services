import 'dart:io';

import 'package:flutter/material.dart';

import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/Smart_header.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/enhanced_pattern_painter.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/smart_navigation.dart';
import 'package:onsetway_services/presentation/services_screen/widget/contact_qoute.dart';

class DesktopAppScreen extends StatefulWidget {
  const DesktopAppScreen({super.key});

  @override
  State<DesktopAppScreen> createState() => _DesktopAppScreenState();
}

class _DesktopAppScreenState extends State<DesktopAppScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;
  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  final _serviceName = 'Desktop Application';

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "Designed for Every Business Type",
      description: "Perfect solution for all business categories",
      bulletPoints: [
        "Industrial & Manufacturing",
        "Clinics & Healthcare Systems",
        "HR, Payroll & Finance",
        "Educational Institutions",
        "Warehousing, Stock & Logistics",
      ],
      icon: Icons.store_outlined,
      image: "assets/programming/desktop/desktop3.webp",
      accentColor: Colors.blue,
    ),
    FeatureCardModel(
      title: "Features of Onset Way's desktop Apps",
      description: "Cutting-edge technology with enterprise-grade capabilities",
      bulletPoints: [
        "C#, .NET, VB,Futter , WPF & WinForms",
        "Clinics, Salons & Booking Platforms",
        "Advanced Reporting & Data Export",
        "Automatic Update Capability",
        "Encryption & Security Features",
      ],
      icon: Icons.desktop_windows_outlined, // updated to a web-related icon
      image: "assets/programming/desktop/desktop4.webp",
      accentColor: Colors.green,
    ),

    FeatureCardModel(
      title: "Why Choose Onset Way?",
      description: "Trusted partner with proven track record of excellence",
      bulletPoints: [
        "Local support and development",
        "Secure, scalable code",
        "Full training & documentation",
        "Long-term support & upgrades",
        "Deep hardware + system integration",
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

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUi(context);
    final double androidScaleFactor = Platform.isAndroid ? 0.7 : 1.0;
    double scale(double value) => value * androidScaleFactor;

    return OWPScaffold(
      title: 'Desktop Application',
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
                  onContactUs: () =>
                      handleContactUs(context, serviceName: _serviceName),
                  onGetQuote: () =>
                      handleGetQuote(context, serviceName: _serviceName),
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
