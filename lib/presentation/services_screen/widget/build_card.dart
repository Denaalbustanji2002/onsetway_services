// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constitem/const_colors.dart';
import '../../../helper/responsive_ui.dart';

Widget buildStatItem(
  String value,
  String label,
  ResponsiveUi responsive, {
  double factor = 1.0,
}) {
  final double valueFont = (responsive.isMobile ? 18.0 : 22.0) * factor;
  final double labelFont = (responsive.isMobile ? 12.0 : 14.0) * factor;
  final double spacing = 6.0 * factor;

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        value,
        style: TextStyle(
          fontSize: valueFont,
          fontWeight: FontWeight.w700,
          color: ConstColor.gold,
          letterSpacing: .3,
        ),
      ),
      SizedBox(height: spacing),
      Text(
        label,
        style: TextStyle(
          fontSize: labelFont,
          color: ConstColor.white.withOpacity(0.8),
          fontWeight: FontWeight.w500,
          letterSpacing: .2,
        ),
      ),
    ],
  );
}

Widget buildEnhancedCategoryCard(
  Map<String, dynamic> category,
  int index,
  ResponsiveUi responsive,
  BuildContext context, {
  double factor = 1.0,
}) {
  // Helper
  double sf(double v) => v * factor;

  final double cardHeight = sf(200);
  final double radius = sf(24);
  final double padAll = sf(24);
  final double iconWrapPad = sf(10);
  final double iconSize = sf(22);
  final double badgeH = sf(6);
  final double badgeW = sf(12);

  final double titleSize = (responsive.isMobile ? 18.0 : 20.0) * factor;
  final double subtitleSize = (responsive.isMobile ? 12.0 : 14.0) * factor;

  return Container(
    height: cardHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: sf(20),
          offset: const Offset(0, 10),
          spreadRadius: sf(2),
        ),
        BoxShadow(
          color: ConstColor.gold.withOpacity(0.1),
          blurRadius: sf(30),
          offset: const Offset(0, 0),
          spreadRadius: sf(3),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // الخلفية
          // الخلفية باستخدام ResizeImage لتقليل استهلاك الذاكرة
          Image(
            image: ResizeImage(
              AssetImage(category['imagePath'] as String),
              width: 400,  // حجم افتراضي مناسب للكرت
              height: 200, // نفس ارتفاع الكرت تقريبًا
            ),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),


          // طبقة التدرّج
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                  ConstColor.gold.withOpacity(0.1),
                ],
                stops: const [0.0, 0.5, 0.8, 1.0],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),

          // المحتوى
          Padding(
            padding: EdgeInsets.all(padAll),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة + البادج
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(iconWrapPad),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(sf(16)),
                        border: Border.all(
                          color: ConstColor.gold.withOpacity(0.4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ConstColor.gold.withOpacity(0.3),
                            blurRadius: sf(10),
                            spreadRadius: sf(1),
                          ),
                        ],
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: ConstColor.gold,
                        size: iconSize, // ← الأيقونة الآن أصغر
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: badgeW,
                        vertical: badgeH,
                      ),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(sf(20)),
                        border: Border.all(
                          color: ConstColor.gold.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${index + 1}'.padLeft(2, '0'),
                        style: TextStyle(
                          color: ConstColor.gold,
                          fontSize: sf(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // العنوان + الوصف
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                        colors: [ConstColor.white, ConstColor.gold],
                      ).createShader(rect),
                      child: Text(
                        category['title'] as String,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    SizedBox(height: sf(8)),

                    Container(
                      padding: EdgeInsets.all(sf(12)),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(sf(12)),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category['subtitle'] as String,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.bold,
                          color: ConstColor.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tap overlay
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: () {
                HapticFeedback.lightImpact();
                if (category['onTap'] != null) {
                  category['onTap'](context);
                }
              },
              child: Container(),
            ),
          ),
        ],
      ),
    ),
  );
}
