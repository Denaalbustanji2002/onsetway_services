// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:onsetway_services/presentation/services_details/hardware/view/pcs_computer.dart';
import '../../../../constitem/const_colors.dart';
import '../../../../helper/responsive_ui.dart';
import '../../programming/widget/appbar_pop.dart';
import 'cctv_system_screen.dart';
import 'networking_hardware.dart';

class HardwareScreen extends StatefulWidget {
  const HardwareScreen({super.key});

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'title': 'CCTV SYSTEMS',
      'subtitle':
          'At Onset Way, we offer smart home and CCTV solutions for seamless security and control anywhere.',
      'icon': Icons.videocam_outlined,
      'imagePath': 'assets/hardware/cctv/cctv9.webp',
      'benefits': [
        'Dome Camera',
        'PTZ Camera',
        'Night Vision & Motion Alerts',
        'Mobile Monitoring',
      ],
      'builder': (BuildContext ctx) => const CctvSystemScreen(),
    },
    {
      'title': 'PC\'S & Computer Hardware',
      'subtitle':
          'At Onset Way, we deliver reliable computers and hardware tailored to your workflow and budget.',
      'icon': Icons.computer_outlined,
      'imagePath': 'assets/hardware/pc/pc2.webp',
      'benefits': [
        'Business PCs',
        'Custom Builds',
        'Laptops & Notebooks',
        'All-in-One PCs',
      ],
      'builder': (BuildContext ctx) => const PcsComputerScreen(),
    },
    {
      'title': 'Networking Hardware',
      'subtitle':
          'At Onset Way, we provide top-tier networking hardware for secure, stable, and reliable networks.',
      'icon': Icons.router_outlined,
      'imagePath': 'assets/hardware/network/network2.jpg',
      'benefits': [
        'Routers , Switches , NAS Devices .',
        'Access Points , Firewalls .',
        'Cables & Connectors .',
        'Network Interface Cards (NICs) .',
      ],
      'builder': (BuildContext ctx) => const NetworkingHardwareScreen(),
    },
  ];

  // Android size scaling factor (0.8 = 80% of original size)
  double get androidScaleFactor {
    return Theme.of(context).platform == TargetPlatform.android ? 0.8 : 1.0;
  }

  double s(double value) => value * androidScaleFactor;

  void _comingSoon() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('قريبًا…')));
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUi(context);

    return OWPScaffold(
      title: 'Programming',
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ConstColor.black,
              ConstColor.black.withOpacity(0.95),
              ConstColor.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
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
                  return _buildCategoryCard(category, responsive);
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
      ) {
    final builder = category['builder'] as WidgetBuilder?;

    return GestureDetector(
      onTap: () {
        if (builder != null) {
          Navigator.push(context, MaterialPageRoute(builder: builder));
        } else {
          _comingSoon();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(s(32)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ConstColor.black.withOpacity(0.85),
              ConstColor.black.withOpacity(0.7),
            ],
          ),
          border: Border.all(
            color: ConstColor.gold.withOpacity(0.35),
            width: s(1.2),
          ),
          boxShadow: [
            BoxShadow(
              color: ConstColor.gold.withOpacity(0.15),
              blurRadius: s(25),
              spreadRadius: s(2),
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // صورة مع أيقونة
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(s(32)),
                  topRight: Radius.circular(s(32)),
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
                          colors: [
                            Colors.transparent,
                            ConstColor.black.withOpacity(0.8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: s(16),
                      right: s(16),
                      child: Container(
                        padding: EdgeInsets.all(s(10)),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ConstColor.gold,
                              ConstColor.gold.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(s(14)),
                          boxShadow: [
                            BoxShadow(
                              color: ConstColor.gold.withOpacity(0.4),
                              blurRadius: s(12),
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          category['icon'],
                          color: ConstColor.black,
                          size: s(26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // النصوص + المزايا + زر
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(s(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['title'],
                      style: TextStyle(
                        fontSize: s(responsive.isMobile ? 20 : 22),
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [ConstColor.gold, Colors.white],
                          ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: s(8)),
                    Text(
                      category['subtitle'],
                      style: TextStyle(
                        fontSize: s(13),
                        color: ConstColor.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: s(12)),

                    // قائمة المزايا
                    ...((category['benefits'] as List).cast<String>()).map(
                          (benefit) => Padding(
                        padding: EdgeInsets.only(bottom: s(6)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: s(14),
                              color: ConstColor.gold,
                            ),
                            SizedBox(width: s(8)),
                            Expanded(
                              child: Text(
                                benefit,
                                style: TextStyle(
                                  fontSize: s(12),
                                  color: ConstColor.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // زر Learn More
                    SizedBox(
                      width: double.infinity,
                      height: s(40),
                      child: ElevatedButton(
                        onPressed: () {
                          if (builder != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: builder),
                            );
                          } else {
                            _comingSoon();
                          }
                        },
                        style:
                        ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(s(20)),
                          ),
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          shadowColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ConstColor.gold,
                                ConstColor.gold.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(s(20)),
                          ),
                          child: Center(
                            child: Text(
                              'Learn More',
                              style: TextStyle(
                                color: ConstColor.black,
                                fontWeight: FontWeight.bold,
                                fontSize: s(14),
                              ),
                            ),
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

// ===================== شاشات بديلة (Placeholder) =====================
// استبدلها بإصداراتك/ملفاتك الفعلية عند توفرها





