import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/Smart_header.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/appbar_pop.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/enhanced_pattern_painter.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/smart_navigation.dart';

class PhotographyAndVideographyScreen extends StatefulWidget {
  const PhotographyAndVideographyScreen({super.key});

  @override
  State<PhotographyAndVideographyScreen> createState() =>
      _PhotographyAndVideographyScreenState();
}

class _PhotographyAndVideographyScreenState
    extends State<PhotographyAndVideographyScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;
  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "Professional Visual Solutions",
      description:
          "Stunning visuals that capture your brand and engage your audience",
      bulletPoints: [
        "High-quality product photography for websites and e-commerce",
        "lifestyle shoots to build trust",
        "Short promo videos with cinematic storytelling",
        "Engaging social media reels to boost reach",
      ],
      icon: Icons.photo_camera_back_outlined, // رمز التصوير والفيديو
      image: "assets/marketing/photo.jpeg",
      accentColor: Colors.blue,
    ),

    FeatureCardModel(
      title: "Why Choose Us?",
      description:
          "Professional visuals that elevate your brand and connect with your audience",
      bulletPoints: [
        "Capture attention and enhance professionalism",
        "Increase engagement across channels",
        "Support marketing campaigns with compelling visuals",
      ],
      icon: Icons.visibility_outlined, // رمز الرؤية والجذب البصري
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
      title: 'Photography & Videography',
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
