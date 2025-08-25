// ignore_for_file: unnecessary_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import '../../../constitem/const_colors.dart';
import '../../../helper/responsive_ui.dart';
import '../../services_details/core_categ/ai_screen.dart';
import '../../services_details/core_categ/cloud_computing.dart';
import '../../services_details/core_categ/cyber_security.dart';
import '../../services_details/core_categ/estab_screen.dart';
import '../../services_details/core_categ/maintenance_screen.dart';
import '../../services_details/core_categ/monitoring_screen.dart';
import '../../services_details/core_categ/networking.dart';
import '../../services_details/hardware/view/hardware_screen.dart';
import '../../services_details/programming/view/programming_screen.dart';
import '../../services_details/programming/widget/appbar_pop.dart';
import '../widget/build_card.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({super.key});

  @override
  State<CoreScreen> createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _cardsAnimationController;
  late AnimationController _backgroundAnimationController;

  late Animation<double> _headerScaleAnimation;
  late Animation<double> _headerOpacityAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _cardsStaggerAnimation;
  late Animation<double> _backgroundAnimation;

  final bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
  final double factor = 0.8; // -20%

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

    final coreCategories = [
      {
        'title': 'Programming',
        'subtitle': 'Need custom software that actually fits your business?',
        'icon': Icons.code,
        'imagePath': 'assets/picture/programming4.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProgrammingScreen()),
          );
        },
      },
      {
        'title': 'Hardware',
        'subtitle': 'Looking for reliable hardware solutions?',
        'icon': Icons.computer,
        'imagePath': 'assets/picture/hardware4.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HardwareScreen()),
          );
        },
      },
      {
        'title': 'Cyber Security',
        'subtitle': 'Keep your data and systems safe from attacks.',
        'icon': Icons.security_outlined,
        'imagePath': 'assets/picture/cyber.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CyberSecurityScreen()),
          );
        },
      },
      {
        'title': 'Networking',
        'subtitle': 'Need faster, safer, and smarter connectivity?',
        'icon': Icons.network_wifi,
        'imagePath': 'assets/picture/networking.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NetworkingScreen()),
          );
        },
      },
      {
        'title': 'Artificial Intelligence',
        'subtitle': 'Stay ahead with AI-driven systems.',
        'icon': Icons.smart_toy_outlined,
        'imagePath': 'assets/picture/AI.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AiScreen()),
          );
        },
      },
      {
        'title': 'Maintenance',
        'subtitle': 'Let OneWay handle your IT maintenance.',
        'icon': Icons.settings,
        'imagePath': 'assets/picture/card1.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MaintenanceScreen()),
          );
        },
      },
      {
        'title': 'Cloud Computing',
        'subtitle': 'Unlock your business with scalable cloud.',
        'icon': Icons.cloud,
        'imagePath': 'assets/picture/cloud.webp',
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CloudComputingScreen()),
          );
        },
      },
      { 'title': 'Establish And Rebuild',
        'subtitle': 'Is it time to modernize your outdated systems?',
        'icon': Icons.settings_applications,
        'imagePath': 'assets/picture/Esta.webp',
        'onTap': (BuildContext context)
      { Navigator.push( context, MaterialPageRoute(builder: (context) => const EstablishAndRebuildScreen()), );
        }, },
      { 'title': 'Monitoring And Evaluation',
        'subtitle': 'Is your business making data-driven decisions in real time?',
        'icon': Icons.analytics, ''
          'imagePath': 'assets/picture/aaaaaaaa.webp',
        'onTap': (BuildContext context)
        { Navigator.push( context, MaterialPageRoute(builder: (context) => const MonitoringAndEvaluationScreen()), ); }, },
    ];

    return OWPScaffold(
      title: "Core Services",
      canPop: true,
      body: AnimatedBuilder(
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
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(
                responsive.width(4) * (isAndroid ? factor : 1.0),
              ),
              itemCount: coreCategories.length + 2, // +2 for header & back btn
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header section
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
                              margin: EdgeInsets.only(
                                bottom: 22 * (isAndroid ? factor : 1.0),
                              ),
                              padding: EdgeInsets.all(
                                22 * (isAndroid ? factor : 1.0),
                              ),
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
                                borderRadius: BorderRadius.circular(
                                  24 * (isAndroid ? factor : 1.0),
                                ),
                                border: Border.all(
                                  color: ConstColor.gold.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Core Technology Services',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (responsive.isMobile ? 22 : 28) *
                                          (isAndroid ? factor : 1.0),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Comprehensive solutions for modern businesses',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                      (responsive.isMobile ? 12 : 16) *
                                          (isAndroid ? factor : 1.0),
                                      color: ConstColor.white.withOpacity(0.8),
                                    ),
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
                  // Back button
                  return GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ConstColor.gold.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.arrow_back, color: Colors.amber),
                          SizedBox(width: 8),
                          Text(
                            'Back to Home',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Category card
                  final category = coreCategories[index - 1];
                  final progress =
                  (_cardsStaggerAnimation.value - ((index - 1) * 0.1))
                      .clamp(0.0, 1.0);
                  final cardAnimation =
                  Curves.easeOutCubic.transform(progress);

                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - cardAnimation)),
                    child: Opacity(
                      opacity: cardAnimation,
                      child: buildEnhancedCategoryCard(
                        category,
                        index,
                        responsive,
                        context,
                        factor: isAndroid ? factor : 1.0,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
