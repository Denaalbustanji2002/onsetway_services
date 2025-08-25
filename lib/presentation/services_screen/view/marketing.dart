// ignore_for_file: unused_import, unnecessary_import, deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

import '../../../constitem/const_colors.dart';
import '../../../helper/responsive_ui.dart';
import '../../services_details/core_categ/maintenance_screen.dart';
import '../../services_details/marketing_services/view/create_content.dart';
import '../../services_details/marketing_services/view/design_and_branding.dart';
import '../../services_details/marketing_services/view/digital_marketing.dart';
import '../../services_details/marketing_services/view/photography_screen.dart';
import '../../services_details/marketing_services/view/seo_screen.dart';
import '../../services_details/marketing_services/view/social_media.dart';
import '../../services_details/programming/widget/appbar_pop.dart';
import '../widget/build_card.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _cardsAnimationController;
  late AnimationController _backgroundAnimationController;

  late Animation<double> _headerScaleAnimation;
  late Animation<double> _headerOpacityAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _cardsStaggerAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _headerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _headerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    _cardsStaggerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundAnimationController,
        curve: Curves.linear,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _backgroundAnimationController.repeat();
    await Future.delayed(const Duration(milliseconds: 200));
    _headerAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _cardsAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardsAnimationController.dispose();
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUi(context);

    final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final double factor = isAndroid ? 0.7 : 1.0;

    double sf(double v) => v * factor;

    final coreCategories = [
      {
        'title': 'Design & Branding',
        'subtitle': 'Your business is real. Shouldn’t your brand be too?',
        'icon': Icons.design_services,
        'imagePath': 'assets/picture/design.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DesignAndBrandingScreen()),
          );
        },
      },
      {
        'title': 'Digital Marketing & Advertising',
        'subtitle': 'Struggling to get your ads noticed by potential customers?',
        'icon': Icons.campaign_outlined,
        'imagePath': 'assets/picture/ai-integration-.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DigitalMarketingAdvertisingScreen()),
          );
        },
      },

      {
        'title': 'Social Media Management',
        'subtitle': 'Are your social media accounts not delivering real business results?',
        'icon': Icons.people_alt,
        'imagePath': 'assets/picture/social.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SocialMediaScreen()),
          );
        },
      },
      {
        'title': 'SEO (search engine optimization)',
        'subtitle': 'Not getting enough organic traffic to your website?',
        'icon': Icons.search,
        'imagePath': 'assets/picture/seo5.png',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const SeoScreen()),
          );
        },
      },
      {
        'title': 'Content Creation',
        'subtitle': 'Posting just to post?',
        'icon': Icons.article_outlined,
        'imagePath': 'assets/picture/content.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateContentScreen()),
          );
        },
      },
      {
        'title': 'Photography & Videography',
        'subtitle': 'Is your brand being seen… or just looked at?',
        'icon': Icons.camera_alt_outlined,
        'imagePath': 'assets/picture/ph2.jpg',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PhotographyAndVideographyScreen()),
          );
        },
      },
    ];

    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.95),
                Colors.grey[900]!.withOpacity(0.9),
                Colors.black.withOpacity(0.95),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: GradientRotation(_backgroundAnimation.value * 0.2),
            ),
          ),
          child: OWPScaffold(
            title: "Marketing Services",
            canPop: true,
            body: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(responsive.width(4) * factor),
              itemCount: coreCategories.length + 2, // header + back button
              itemBuilder: (context, index) {
                if (index == 0) {
                  // ====== Header Animation ======
                  return AnimatedBuilder(
                    animation: _headerAnimationController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _headerSlideAnimation,
                        child: Transform.scale(
                          scale: _headerScaleAnimation.value,
                          child: FadeTransition(
                            opacity: _headerOpacityAnimation,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: sf(22)),
                              padding: EdgeInsets.all(sf(22)),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ConstColor.gold.withOpacity(0.1),
                                    ConstColor.darkGold.withOpacity(0.05),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(sf(24)),
                                border: Border.all(
                                  color: ConstColor.gold.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: ConstColor.gold.withOpacity(0.1),
                                    blurRadius: sf(20),
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (rect) => LinearGradient(
                                      colors: [
                                        ConstColor.white,
                                        ConstColor.gold,
                                        ConstColor.darkGold,
                                        ConstColor.white,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(rect),
                                    child: Text(
                                      'Marketing Services',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                        (responsive.isMobile ? 22 : 28) * factor,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: sf(12)),
                                  Text(
                                    'Comprehensive solutions for modern businesses',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                      (responsive.isMobile ? 12 : 16) * factor,
                                      color: ConstColor.white.withOpacity(0.8),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(height: sf(14)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildStatItem(
                                        '${coreCategories.length}',
                                        'Services',
                                        responsive,
                                        factor: factor,
                                      ),
                                      buildStatItem(
                                        '100+',
                                        'Projects',
                                        responsive,
                                        factor: factor,
                                      ),
                                      buildStatItem(
                                        '24/7',
                                        'Support',
                                        responsive,
                                        factor: factor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (index == coreCategories.length + 1) {
                  // ====== Back Button ======
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: sf(20)),
                      padding: EdgeInsets.symmetric(vertical: sf(16)),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(sf(16)),
                        border: Border.all(
                          color: ConstColor.gold.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: ConstColor.gold,
                            size: sf(20),
                          ),
                          SizedBox(width: sf(8)),
                          Text(
                            'Back to Home',
                            style: TextStyle(
                              color: ConstColor.gold,
                              fontSize: sf(16),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // ====== Category Cards ======
                  final category = coreCategories[index - 1];
                  final progress =
                  (_cardsStaggerAnimation.value - ((index - 1) * 0.1))
                      .clamp(0.0, 1.0);
                  final cardAnimation = Curves.easeOutCubic.transform(progress);

                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - cardAnimation)),
                    child: Opacity(
                      opacity: cardAnimation,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: responsive.height(2.5) * factor,
                        ),
                        child: buildEnhancedCategoryCard(
                          category,
                          index,
                          responsive,
                          context,
                          factor: factor,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
