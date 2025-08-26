// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/base_card.dart';

class TitleSection extends BaseCardWidget {
  const TitleSection({
    required super.feature,
    required super.responsive,
    required super.isActive,
    required super.scaleFactor,
  });

  double get _spacingFactor => Platform.isAndroid ? 0.7 : 1.0;
  double spacing(double value) => value * _spacingFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing(20)),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: isActive ? spacing(6) : spacing(4),
            height: isActive ? spacing(30) : spacing(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ConstColor.gold, ConstColor.darkGold],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(spacing(3)),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.gold.withOpacity(0.4),
                  blurRadius: spacing(6),
                  offset: Offset(0, spacing(2)),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontFamily: 'MAIAN',
                    color: const Color.fromARGB(255, 230, 229, 229),
                    fontSize: responsive.fontSize(4.5) * scaleFactor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: spacing(0.5),
                    height: Platform.isAndroid ? 1.15 : 1.2, // أقصر في Android
                    shadows: [
                      Shadow(
                        blurRadius: spacing(4),
                        color: ConstColor.black.withOpacity(0.5),
                        offset: Offset(0, spacing(2)),
                      ),
                    ],
                  ),
                ),
                if (isActive)
                  Padding(
                    padding: EdgeInsets.only(top: spacing(4)),
                    child: Container(
                      height: spacing(2),
                      width: spacing(60),
                      decoration: BoxDecoration(
                        color: ConstColor.gold.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(spacing(1)),
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
}
