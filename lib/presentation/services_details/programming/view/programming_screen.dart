// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import '../../../../constitem/const_colors.dart';
import '../../../../helper/responsive_ui.dart';
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
        'Multi-Payment Support',
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
        'Boosted Engagement',
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
        'Secure and Reliable',
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

  // Android size scaling factor (0.8 = 80% of original size)
  double get androidScaleFactor {
    return Theme.of(context).platform == TargetPlatform.android ? 0.8 : 1.0;
  }

  // Helper function to scale dimensions for Android
  double s(double value) => value * androidScaleFactor;

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
          padding: EdgeInsets.all(s(14)),
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: s(20),
                  horizontal: s(16),
                ),
                margin: EdgeInsets.all(s(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(s(16)),
                  gradient: LinearGradient(
                    colors: [
                      ConstColor.gold.withOpacity(0.1),
                      ConstColor.gold.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: ConstColor.gold.withOpacity(0.3),
                    width: s(1.5),
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
                          fontSize: s(responsive.isMobile ? 20 : 28),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: s(2)),
                  ],
                ),
              ),

              // Categories Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: responsive.isMobile
                      ? 1
                      : (responsive.isTablet ? 2 : 2),
                  crossAxisSpacing: s(16),
                  mainAxisSpacing: s(16),
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

  Widget _buildCategoryCard(
    Map<String, dynamic> category,
    ResponsiveUi responsive,
    int index,
  ) {
    return GestureDetector(
      onTap: category['onTap'],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(s(24)),
          color: Colors.black,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ConstColor.black, ConstColor.black.withOpacity(0.9)],
          ),
          border: Border.all(
            color: ConstColor.gold.withOpacity(0.3),
            width: s(1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: ConstColor.gold.withOpacity(0.2),
              blurRadius: s(15),
              spreadRadius: s(2),
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: s(10),
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(s(24)),
                  topRight: Radius.circular(s(24)),
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
                      top: s(16),
                      right: s(16),
                      child: Container(
                        padding: EdgeInsets.all(s(8)),
                        decoration: BoxDecoration(
                          color: ConstColor.gold.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(s(12)),
                          boxShadow: [
                            BoxShadow(
                              color: ConstColor.gold.withOpacity(0.3),
                              blurRadius: s(8),
                              spreadRadius: s(1),
                            ),
                          ],
                        ),
                        child: Icon(
                          category['icon'],
                          color: ConstColor.black,
                          size: s(24),
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
                padding: EdgeInsets.all(s(20)),
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
                          fontSize: s(responsive.isMobile ? 20 : 22),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: s(8)),

                    // Subtitle
                    Text(
                      category['subtitle'],
                      style: TextStyle(
                        fontSize: s(responsive.isMobile ? 12 : 13),
                        color: ConstColor.white.withOpacity(0.8),
                        height: s(1.4),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: s(10)),

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
                                size: s(16),
                              ),
                              SizedBox(width: s(6)),
                              Text(
                                'Why Your Business Needs This:',
                                style: TextStyle(
                                  fontSize: s(14),
                                  fontWeight: FontWeight.w600,
                                  color: ConstColor.gold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: s(8)),
                          Expanded(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: category['benefits'].length,
                              itemBuilder: (context, benefitIndex) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: s(6)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: s(6)),
                                        width: s(4),
                                        height: s(4),
                                        decoration: BoxDecoration(
                                          color: ConstColor.gold,
                                          borderRadius: BorderRadius.circular(
                                            s(2),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: s(8)),
                                      Expanded(
                                        child: Text(
                                          category['benefits'][benefitIndex],
                                          style: TextStyle(
                                            fontSize: s(
                                              responsive.isMobile ? 11 : 12,
                                            ),
                                            color: ConstColor.white.withOpacity(
                                              0.9,
                                            ),
                                            height: s(1.3),
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
                    SizedBox(height: s(8)),
                    Container(
                      width: double.infinity,
                      height: s(36),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ConstColor.gold,
                            ConstColor.gold.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(s(18)),
                        boxShadow: [
                          BoxShadow(
                            color: ConstColor.gold.withOpacity(0.3),
                            blurRadius: s(8),
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
                            borderRadius: BorderRadius.circular(s(18)),
                          ),
                        ),
                        child: Text(
                          'Learn More',
                          style: TextStyle(
                            color: ConstColor.black,
                            fontWeight: FontWeight.w600,
                            fontSize: s(14),
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
