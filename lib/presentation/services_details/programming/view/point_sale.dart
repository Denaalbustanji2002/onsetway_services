// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../../constitem/const_colors.dart';
import '../../../../helper/responsive_ui.dart';
import '../widget/appbar_pop.dart';

class FeatureCardModel {
  final String title;
  final String description;
  final IconData icon;
  final String image;
  final Color accentColor;
  final List<String> bulletPoints;

  FeatureCardModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.image,
    required this.bulletPoints,
    this.accentColor = Colors.white,
  });
}

// ==================== ENHANCED FEATURE CARD WIDGET ====================
class FeatureCard extends StatefulWidget {
  final FeatureCardModel feature;
  final ResponsiveUi responsive;
  final bool isActive;
  final VoidCallback? onContactUs;
  final VoidCallback? onGetQuote;

  const FeatureCard({
    super.key,
    required this.feature,
    required this.responsive,
    this.isActive = false,
    this.onContactUs,
    this.onGetQuote,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _slideController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: -0.02,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FeatureCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _mainController.forward();
      _slideController.forward();
      _pulseController.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _mainController.reverse();
      _slideController.reverse();
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_mainController, _pulseController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: Transform.scale(
            scale: widget.isActive ? _scaleAnimation.value : 0.92,
            child: Transform.rotate(
              angle: widget.isActive ? _rotationAnimation.value : 0,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isHovered = true),
                onTapUp: (_) => setState(() => _isHovered = false),
                onTapCancel: () => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: widget.responsive.width(80),
                  margin: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: widget.isActive ? 8 : 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: widget.isActive
                          ? [
                        ConstColor.darkGold.withOpacity(0.95),
                        ConstColor.gold.withOpacity(0.85),
                        ConstColor.darkGold.withOpacity(0.75),
                      ]
                          : [
                        ConstColor.darkGold.withOpacity(0.7),
                        ConstColor.gold.withOpacity(0.5),
                        ConstColor.darkGold.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ConstColor.darkGold.withOpacity(widget.isActive ? 0.4 : 0.2),
                        blurRadius: widget.isActive ? 30 : 15,
                        offset: Offset(0, widget.isActive ? 15 : 8),
                        spreadRadius: widget.isActive ? 3 : 1,
                      ),
                      if (widget.isActive)
                        BoxShadow(
                          color: ConstColor.gold.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                    ],
                    border: widget.isActive
                        ? Border.all(
                      color: ConstColor.gold.withOpacity(0.6),
                      width: 2,
                    )
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Enhanced Background Pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: EnhancedPatternPainter(
                              color: ConstColor.white.withOpacity(0.08),
                              isActive: widget.isActive,
                              animationValue: widget.isActive ? _pulseAnimation.value : 1.0,
                            ),
                          ),
                        ),

                        // Main Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Enhanced Image Section with Parallax Effect
                            _buildImageSection(),

                            const SizedBox(height: 16),

                            // Smart Title Section
                            _buildTitleSection(),

                            const SizedBox(height: 16),

                            // Enhanced Feature List
                            _buildFeatureList(),

                            const SizedBox(height: 20),

                            // Smart Action Buttons
                            _buildActionButtons(),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: ConstColor.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.asset(
                  widget.feature.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),

                // Smart Overlay Gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                        ConstColor.darkGold.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Icon with Pulse Effect
        Positioned(
          top: 16,
          right: 16,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isActive ? _pulseAnimation.value : 1.0,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ConstColor.gold,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: ConstColor.gold.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: ConstColor.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.feature.icon,
                    color: ConstColor.black,
                    size: widget.responsive.fontSize(6.5),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Smart Indicator Line
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: widget.isActive ? 6 : 4,
            height: widget.isActive ? 30 : 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ConstColor.gold,
                  ConstColor.darkGold,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.gold.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.feature.title,
                  style: TextStyle(
                    fontFamily: 'MAIAN',
                    color: ConstColor.white,
                    fontSize: widget.responsive.fontSize(4.5),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: ConstColor.black.withOpacity(0.5),
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                if (widget.isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      height: 2,
                      width: 60,
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ConstColor.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: ConstColor.gold.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ConstColor.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.feature.bulletPoints.asMap().entries.map((entry) {
            int index = entry.key;
            String point = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < widget.feature.bulletPoints.length - 1 ? 12 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ConstColor.gold, ConstColor.darkGold],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ConstColor.gold.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        color: ConstColor.white.withOpacity(0.95),
                        fontSize: widget.responsive.fontSize(3.4),
                        height: 1.4,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildSmartButton(
              text: 'Contact Us',
              icon: Icons.support_agent_outlined,
              isPrimary: false,
              onPressed: widget.onContactUs ?? () {},
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: _buildSmartButton(
              text: 'Get Quote',
              icon: Icons.arrow_forward_rounded,
              isPrimary: true,
              onPressed: widget.onGetQuote ?? () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartButton({
    required String text,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? ConstColor.gold
              : Colors.transparent,
          foregroundColor: isPrimary ? ConstColor.black : ConstColor.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isPrimary
                  ? ConstColor.darkGold
                  : ConstColor.gold.withOpacity(0.6),
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: widget.responsive.fontSize(4.2),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: widget.responsive.fontSize(3.2),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== ENHANCED PATTERN PAINTER ====================
class EnhancedPatternPainter extends CustomPainter {
  final Color color;
  final bool isActive;
  final double animationValue;

  EnhancedPatternPainter({
    required this.color,
    this.isActive = false,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(isActive ? 0.12 : 0.06)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final spacing = (isActive ? 25.0 : 35.0) * animationValue;

    // Diagonal pattern
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    if (isActive) {
      // Animated dots pattern
      paint.style = PaintingStyle.fill;
      final dotSize = 1.5 * animationValue;
      for (double x = 30; x < size.width; x += 80) {
        for (double y = 30; y < size.height; y += 80) {
          canvas.drawCircle(Offset(x, y), dotSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ==================== MAIN POS SCREEN WITH SMART FEATURES ====================
class PosFeatureScreen extends StatefulWidget {
  const PosFeatureScreen({super.key});

  @override
  State<PosFeatureScreen> createState() => _PosFeatureScreenState();
}

class _PosFeatureScreenState extends State<PosFeatureScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int currentPage = 0;

  late AnimationController _headerController;
  late AnimationController _indicatorController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final List<FeatureCardModel> features = [
    FeatureCardModel(
      title: "Designed for Every Business Type",
      description: "Perfect solution for all business categories with customizable features",
      bulletPoints: [
        "Retail Stores & Supermarkets",
        "Cafés & Restaurants",
        "Pharmacies & Health Centers",
        "Beauty Salons & Barbershops",
        "Fashion & Shoe Boutiques",
        "Warehouses & Showrooms"
      ],
      icon: Icons.store_outlined,
      image: "assets/picture/4.webp",
      accentColor: Colors.blue,
    ),
    FeatureCardModel(
      title: "Advanced POS Features",
      description: "Cutting-edge technology with enterprise-grade capabilities",
      bulletPoints: [
        "Cloud-Based Real-time Access",
        "Intuitive Touch Interface",
        "Bank-Level Security System",
        "Seamless Hardware Integration",
        "Fully Customizable Dashboard",
        "Advanced Analytics & Reports"
      ],
      icon: Icons.point_of_sale,
      image: "assets/programming/pos/pos4.webp",
      accentColor: Colors.green,
    ),
    FeatureCardModel(
      title: "Why Choose Onset Way?",
      description: "Trusted partner with proven track record of excellence",
      bulletPoints: [
        "Trusted by 1000+ Local Businesses",
        "Lightning-Fast Setup & Training",
        "24/7 Local Support Team",
        "Scalable & Budget-Friendly",

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

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));

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
    // Handle contact us action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Contact form opened'),
        backgroundColor: ConstColor.gold,
      ),
    );
  }

  void _handleGetQuote() {
    // Handle get quote action
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

    return OWPScaffold(
      title: 'Point Of Sales',
      body: Column(
        children: [
          // Smart Header Section
          SlideTransition(
            position: _headerSlideAnimation,
            child: FadeTransition(
              opacity: _headerFadeAnimation,
              child: _buildSmartHeader(responsive),
            ),
          ),

          // Enhanced Cards Section
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

          // Smart Navigation Section
          _buildSmartNavigation(responsive),
        ],
      ),
    );
  }

  Widget _buildSmartHeader(ResponsiveUi responsive) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Main Title with Glow
          Text(
            'Revolutionize Your Business',
            style: TextStyle(
              fontFamily: 'MAIAN',
              color: ConstColor.gold,
              fontSize: responsive.fontSize(5.4),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  blurRadius: 15,
                  color: ConstColor.gold.withOpacity(0.8),
                  offset: const Offset(0, 4),
                ),
                Shadow(
                  blurRadius: 25,
                  color: ConstColor.darkGold.withOpacity(0.6),
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),









        ],
      ),
    );
  }

  Widget _buildSmartNavigation(ResponsiveUi responsive) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          // Smart Dots Indicator
          AnimatedBuilder(
            animation: _indicatorController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(features.length, (index) {
                  final isActive = currentPage == index;
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: isActive ? 40 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? LinearGradient(
                          colors: [ConstColor.gold, ConstColor.darkGold],
                        )
                            : null,
                        color: isActive ? null : ConstColor.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: isActive
                            ? [
                          BoxShadow(
                            color: ConstColor.gold.withOpacity(0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                            spreadRadius: 1,
                          ),
                        ]
                            : null,
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          const SizedBox(height: 16),

          // Smart Page Counter with Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: ConstColor.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ConstColor.gold.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_rounded,
                  color: ConstColor.gold.withOpacity(0.8),
                  size: responsive.fontSize(4),
                ),
                const SizedBox(width: 8),
                Text(
                  '${currentPage + 1} of ${features.length}',
                  style: TextStyle(
                    color: ConstColor.white.withOpacity(0.8),
                    fontSize: responsive.fontSize(3.5),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}