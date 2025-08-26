import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/Smart_header.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/enhanced_pattern_painter.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/smart_navigation.dart';

class EstablishAndRebuildScreen extends StatefulWidget {
  const EstablishAndRebuildScreen({super.key});

  @override
  State<EstablishAndRebuildScreen> createState() =>
      _EstablishAndRebuildScreenState();
}

class _EstablishAndRebuildScreenState extends State<EstablishAndRebuildScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;
  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "Why Your Business Needs Established & Rebuilt?",
      description:
          "Transform outdated systems into modern, efficient foundations",
      bulletPoints: [
        "Prevent failures and downtime with modern infrastructure",
        "Increase operational efficiency by up to 40%",
        "Secure, scalable, and future-ready systems",
      ],
      icon: Icons.build_circle_outlined, // رمز البناء والتجديد
      image: "assets/core/estab1.webp",
      accentColor: Colors.blue,
    ),

    FeatureCardModel(
      title: "Established & Rebuilt by Onset Way",
      description:
          "Modern solutions for businesses starting fresh or upgrading",
      bulletPoints: [
        "Transform or rebuild outdated systems",
        "Create secure, scalable, and efficient tech foundations",
        "Reduce maintenance costs and improve long-term performance",
      ],
      icon: Icons.settings_backup_restore_outlined, // رمز التجديد والاستعادة
      image: "assets/core/estab2.webp",
      accentColor: Colors.green,
    ),

    FeatureCardModel(
      title: "Why Choose Onset Way?",
      description: "Your trusted partner for innovation and security",
      bulletPoints: [
        "Proven expertise across industries",
        "End-to-end IT, cloud, AI, and app solutions",
        "Fast, scalable, and secure systems",
        "Client-centered, innovative, and security-first approach",
      ],
      icon: Icons.verified_user_outlined, // رمز الثقة والأمان
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
      title: 'Establish And Rebuild',
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
