// ignore_for_file: deprecated_member_use

import 'dart:io'; // For platform detection
import 'package:flutter/material.dart';
import '../../../constitem/const_colors.dart';
import '../../../helper/responsive_ui.dart';

import '../../services_screen/view/core_screen.dart';
import '../../services_screen/view/marketing.dart';
import '../widget/appbar_widget.dart';
import '../widget/category_card.dart';
import '../widget/videobackground.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroAnimationController;
  late AnimationController _titleAnimationController;
  late AnimationController _cardAnimationController;

  late Animation<double> _heroScaleAnimation;
  late Animation<double> _heroOpacityAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<double> _cardStaggerAnimation;

  @override
  void initState() {
    super.initState();

    _heroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _heroScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _heroOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _heroAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _titleSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _titleAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    _titleOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _titleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _cardStaggerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _startAnimations();
  }

  void _startAnimations() {
    Future.wait([
      Future.delayed(const Duration(milliseconds: 300)).then((_) {
        if (!mounted) return;
        _heroAnimationController.forward();
      }),
      Future.delayed(const Duration(milliseconds: 900)).then((_) {
        if (!mounted) return;
        _titleAnimationController.forward();
      }),
      Future.delayed(const Duration(milliseconds: 1300)).then((_) {
        if (!mounted) return;
        _cardAnimationController.forward();
      }),
    ]);
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _titleAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUi(context);

    // درجات التصغير للأندرويد
    final androidReduction = Platform.isAndroid ? 4.0 : 0.0;

    // Calculate video height with 40% reduction for Android
    final double videoHeight = Platform.isAndroid
        ? (responsive.isMobile ? 220 : 320) *
              0.7 // 40% reduction
        : (responsive.isMobile ? 220 : 320) - androidReduction;

    return OWScaffold(
      title: 'OnsetWay',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Hero Section with Video
            AnimatedBuilder(
              animation: _heroAnimationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _heroScaleAnimation.value,
                  child: Opacity(
                    opacity: _heroOpacityAnimation.value,
                    child: Container(
                      height: videoHeight, // Use reduced height for Android
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 25,
                            offset: const Offset(0, 15),
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: ConstColor.gold.withOpacity(0.1),
                            blurRadius: 40,
                            offset: const Offset(0, 0),
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          const VideoBackground(),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.4),
                                  Colors.transparent,
                                  ConstColor.gold.withOpacity(0.1),
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                          ),
                          ...List.generate(
                            6,
                            (index) => TweenAnimationBuilder<double>(
                              duration: Duration(seconds: 3 + index),
                              tween: Tween<double>(begin: 0, end: 1),
                              builder: (context, value, child) {
                                return Positioned(
                                  left: 50.0 + (index * 60) + (value * 30),
                                  top: 40.0 + (index * 20) + (value * 50),
                                  child: Opacity(
                                    opacity: 0.3 + (value * 0.4),
                                    child: Container(
                                      width:
                                          (4 + (index * 2).toDouble()) -
                                          androidReduction,
                                      height:
                                          (4 + (index * 2).toDouble()) -
                                          androidReduction,
                                      decoration: BoxDecoration(
                                        color: ConstColor.gold.withOpacity(0.6),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ConstColor.gold.withOpacity(
                                              0.4,
                                            ),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onEnd: () {
                                setState(() {});
                              },
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(24 - androidReduction),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ConstColor.gold.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Technology is the\nfoundation; innovation\nis the journey.\nAt Onset Way we\nbuild both.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'MAIAN',
                                  color: Colors.white,
                                  fontSize:
                                      (responsive.isMobile ? 16 : 24) -
                                      androidReduction,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20 - 8), // نقص 4 للأندرويد
            AnimatedBuilder(
              animation: _titleAnimationController,
              builder: (context, child) {
                return SlideTransition(
                  position: _titleSlideAnimation,
                  child: FadeTransition(
                    opacity: _titleOpacityAnimation,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Our Services',
                          style: TextStyle(
                            fontFamily: 'MAIAN',
                            fontSize:
                                (responsive.isMobile ? 26 : 32) -
                                androidReduction,
                            fontWeight: FontWeight.bold,
                            color: ConstColor.gold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(
              height: (12 - androidReduction).clamp(0.0, 12),
            ), // نفس الشي

            AnimatedBuilder(
              animation: _cardStaggerAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    Transform.translate(
                      offset: Offset(
                        0,
                        50 * (1 - _cardStaggerAnimation.value) -
                            androidReduction,
                      ),
                      child: Opacity(
                        opacity: _cardStaggerAnimation.value,
                        child: CategoryCard(
                          title: 'Core Services',
                          subtitle: 'Programming • Hardware • More',
                          icon: Icons.layers_rounded,
                          imagePath: 'assets/picture/AI.webp',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CoreScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: (2 - androidReduction).clamp(0.0, 2)),
                    Transform.translate(
                      offset: Offset(
                        0,
                        50 *
                                (1 -
                                    Curves.easeOut.transform(
                                      (_cardStaggerAnimation.value - 0.3).clamp(
                                            0.0,
                                            1.0,
                                          ) /
                                          0.7,
                                    )) -
                            androidReduction,
                      ),
                      child: Opacity(
                        opacity: Curves.easeOut.transform(
                          (_cardStaggerAnimation.value - 0.3).clamp(0.0, 1.0) /
                              0.7,
                        ),
                        child: CategoryCard(
                          title: 'Marketing Services',
                          subtitle: 'Design & Branding • SEO • More',
                          icon: Icons.campaign_rounded,
                          imagePath: 'assets/picture/2.webp',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MarketingScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
