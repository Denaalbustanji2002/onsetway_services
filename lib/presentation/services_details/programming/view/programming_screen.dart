import 'package:flutter/material.dart';
import '../../../../constitem/const_colors.dart';
import '../../../../helper/responsive_ui.dart';
import '../../../home/widget/appbar_widget.dart';
import '../widget/appbar_pop.dart';

class ProgrammingScreen extends StatefulWidget {
  const ProgrammingScreen({super.key});

  @override
  State<ProgrammingScreen> createState() => _ProgrammingScreenState();
}

class _ProgrammingScreenState extends State<ProgrammingScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'Point of Sale',
      'subtitle': 'Smarter Sales.Better Control.Seamless Experience.',
      'icon': Icons.point_of_sale,
      'imagePath': 'assets/programming/pos/pos2.jpg',
      'benefits': [
        'Real-Time Sales Tracking',
        'Automated Inventory Management',
        'Faster, Smoother Checkout',
        'Multi-Payment Support'
      ],
      'onTap': () {},
    },
    {
      'title': 'Mobile Application',
      'subtitle': 'Stronger Engagement.Smarter Access.',
      'icon': Icons.phone_iphone,
      'imagePath': 'assets/programming/mobile app/mobile4.png',
      'benefits': [
        'Instant Customer Access',
        'Online Ordering & Booking',
        'Secure Online Payments',
        'Boosted Engagement'
      ],
      'onTap': () {},
    },
    {
      'title': 'Web Applications',
      'subtitle': 'Modern Design.Powerful Code.Built for Business.',
      'icon': Icons.web,
      'imagePath': 'assets/programming/desktop/Desktop.webp',
      'benefits': [
        'Professional Online Presence',
        'Better User Experience',
        'Search Engine Friendly',
        'Secure and Reliable'
      ],
      'onTap': () {},
    },
    {
      'title': 'Desktop Applications (Windows / MacOs / Linux)',
      'subtitle': 'High Performance.Offline Functionality.',
      'icon': Icons.desktop_windows_outlined,
      'imagePath': 'assets/programming/desktop/desktop2.webp',
      'benefits': [
        'High Performance & Speed',
        'Cost-Effective Deployment',
        'Hardware Integration',
      ],
      'onTap': () {},
    },
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUi(context);

    return OWPScaffold(
      title: 'Programming',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ConstColor.black,
              ConstColor.black.withOpacity(0.95),
              ConstColor.black,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      ConstColor.gold.withOpacity(0.1),
                      ConstColor.gold.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: ConstColor.gold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                        colors: [ConstColor.gold, ConstColor.white],
                      ).createShader(rect),
                      child: Text(
                        'Transform Your Business with Technology',
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 20 : 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 2),

                  ],
                ),
              ),

              // Categories Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: responsive.isMobile ? 1 : (responsive.isTablet ? 2 : 2),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: responsive.isMobile ? 0.85 : 1.1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(category, responsive, index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, ResponsiveUi responsive, int index) {
    return GestureDetector(
      onTap: category['onTap'],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.black,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ConstColor.black,
              ConstColor.black.withOpacity(0.9),
            ],
          ),
          border: Border.all(
            color: ConstColor.gold.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: ConstColor.gold.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Image Section with Overlay
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: Stack(
                  children: [
                    Image.asset(
                      category['imagePath'],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            ConstColor.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ConstColor.gold.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: ConstColor.gold.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          category['icon'],
                          color: ConstColor.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Enhanced Content Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with Gradient Effect
                    ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                        colors: [ConstColor.gold, ConstColor.white],
                      ).createShader(rect),
                      child: Text(
                        category['title'],
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      category['subtitle'],
                      style: TextStyle(
                        fontSize: responsive.isMobile ? 12 : 13,
                        color: ConstColor.white.withOpacity(0.8),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Benefits Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: ConstColor.gold,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Why Your Business Needs This:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ConstColor.gold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: category['benefits'].length,
                              itemBuilder: (context, benefitIndex) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: ConstColor.gold,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          category['benefits'][benefitIndex],
                                          style: TextStyle(
                                            fontSize: responsive.isMobile ? 11 : 12,
                                            color: ConstColor.white.withOpacity(0.9),
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // CTA Button
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ConstColor.gold,
                            ConstColor.gold.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: ConstColor.gold.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: category['onTap'],
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Learn More',
                          style: TextStyle(
                            color: ConstColor.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}