import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constitem/const_colors.dart';
import '../../../helper/responsive_ui.dart';

Widget buildStatItem(String value, String label, ResponsiveUi responsive) {
  return Column(
    children: [
      ShaderMask(
        shaderCallback: (rect) => LinearGradient(
          colors: [ConstColor.gold, ConstColor.darkGold],
        ).createShader(rect),
        child: Text(
          value,
          style: TextStyle(
            fontSize: responsive.isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: responsive.isMobile ? 12 : 14,
          color: ConstColor.white.withOpacity(0.7),
        ),
      ),
    ],
  );
}

Widget buildEnhancedCategoryCard(
    Map<String, dynamic> category,
    int index,
    ResponsiveUi responsive,
    BuildContext context, // لازم تمرر الكونتكست
    ) {
  return Container(
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
          spreadRadius: 2,
        ),
        BoxShadow(
          color: ConstColor.gold.withOpacity(0.1),
          blurRadius: 30,
          offset: const Offset(0, 0),
          spreadRadius: 3,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            category['imagePath'] as String,
            width: 300,
            height: 90,
            fit: BoxFit.cover,
          ),

          // Enhanced gradient overlay
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

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and number badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ConstColor.gold.withOpacity(0.4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ConstColor.gold.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        category['icon'] as IconData,
                        color: ConstColor.gold,
                        size: 28,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ConstColor.gold.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${index + 1}'.padLeft(2, '0'),
                        style: TextStyle(
                          color: ConstColor.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Title and subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) => LinearGradient(
                        colors: [
                          ConstColor.white,
                          ConstColor.gold,
                        ],
                      ).createShader(rect),
                      child: Text(
                        category['title'] as String,
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        category['subtitle'] as String,
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 12 : 14,
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
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                HapticFeedback.lightImpact();
                if (category['onTap'] != null) {
                  category['onTap'](context); // ← يستدعي onTap من الماب
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
