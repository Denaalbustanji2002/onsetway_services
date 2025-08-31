import 'dart:io';

import 'package:flutter/material.dart';

import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/Smart_header.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/enhanced_pattern_painter.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/smart_navigation.dart';
import 'package:onsetway_services/presentation/services_screen/widget/contact_qoute.dart';

class CyberSecurityScreen extends StatefulWidget {
  const CyberSecurityScreen({super.key});

  @override
  State<CyberSecurityScreen> createState() => _CyberSecurityScreenState();
}

class _CyberSecurityScreenState extends State<CyberSecurityScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;
  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  final _serviceName = 'Cyber Security';

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "Why Your Business Needs Cyber Security?",
      description: "Essential protection for every business",
      bulletPoints: [
        "95% of attacks caused by human error",
        "Stricter data protection laws (GDPR & local)",
        "60% of SMBs close after cyber incidents",
      ],
      icon: Icons.warning_amber_outlined, // أنسب للتحذير من المخاطر
      image: "assets/core/cyber1.webp",
      accentColor: Colors.blue,
    ),
    FeatureCardModel(
      title: "Cyber Security by Onset Way",
      description: "Enterprise-grade defense against threats",
      bulletPoints: [
        "Cyber threats are inevitable",
        "Ransomware, phishing & insider risks",
        "One breach = huge cost & downtime",
      ],
      icon: Icons.shield_outlined, // أنسب للحماية والدفاع
      image: "assets/core/cyber2.webp",
      accentColor: Colors.green,
    ),
    FeatureCardModel(
      title: "Why Choose Onset Way?",
      description: "Your trusted security partner",
      bulletPoints: [
        "Threat Detection & Prevention",
        "Penetration Testing & Vulnerability Assessment",
        "Network & Endpoint Protection",
        "Email Security & Anti-Phishing",
      ],
      icon: Icons.verified_outlined, // ممتاز للثقة والاعتمادية
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
      title: 'Cyber Security',
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
