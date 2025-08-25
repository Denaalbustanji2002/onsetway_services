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

class SeoScreen extends StatefulWidget {
  const SeoScreen({super.key});

  @override
  State<SeoScreen> createState() => _SeoScreenState();
}

class _SeoScreenState extends State<SeoScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;
  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "SEO Solutions That Drive Results",
      description: "Boost visibility, attract qualified visitors, and convert them into customers",
      bulletPoints: [
        "Conduct targeted keyword research",
        "Optimize on-page elements for search engines",
        "Create SEO-friendly blog content",
        "Improve website speed and performance",
      ],
      icon: Icons.search_off_outlined, // رمز البحث والتحسين لمحركات البحث
      image: "assets/marketing/seo1.jpg",
      accentColor: Colors.blue,
    ),

    FeatureCardModel(
      title: "Why Choose Our SEO?",
      description: "Professional strategies that grow organic traffic and visibility",
      bulletPoints: [
        "Attract more targeted website visitors",
        "Enhance online credibility and trust",
        "Reduce long-term advertising costs",
        "Outrank competitors consistently",
      ],
      icon: Icons.bar_chart_outlined, // رمز الأداء والنمو
      image: "assets/picture/about us.webp",
      accentColor: Colors.green,
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
      title: 'SEO',
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

