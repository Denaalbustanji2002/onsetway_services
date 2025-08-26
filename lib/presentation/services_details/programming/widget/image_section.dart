// ignore_for_file: deprecated_member_use, unnecessary_import, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/base_card.dart';

class ImageSection extends BaseCardWidget {
  final Animation<double> pulseAnimation;

  const ImageSection({
    required super.feature,
    required super.responsive,
    required super.isActive,
    required super.scaleFactor,
    required this.pulseAnimation,
  });

  double get _spacingFactor => Platform.isAndroid ? 0.7 : 1.0;

  double spacing(double value) => value * _spacingFactor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: scale(200),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(scale(24)),
            ),
            boxShadow: [
              BoxShadow(
                color: ConstColor.black.withOpacity(0.3),
                blurRadius: scale(16),
                offset: Offset(0, scale(4)),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(scale(24)),
            ),
            child: Stack(
              children: [
                Image.asset(
                  feature.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  cacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
                  cacheHeight: (200 * 2).toInt(),
                ),

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
        Positioned(
          top: spacing(16), // أصغر في Android
          right: spacing(16), // أصغر في Android
          child: AnimatedBuilder(
            animation: pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isActive ? pulseAnimation.value : 1.0,
                child: Container(
                  padding: EdgeInsets.all(spacing(14)), // أصغر في Android
                  decoration: BoxDecoration(
                    color: ConstColor.gold,
                    borderRadius: BorderRadius.circular(spacing(20)),
                    boxShadow: [
                      BoxShadow(
                        color: ConstColor.gold.withOpacity(0.4),
                        blurRadius: spacing(12),
                        offset: Offset(0, spacing(4)),
                        spreadRadius: spacing(2),
                      ),
                      BoxShadow(
                        color: ConstColor.black.withOpacity(0.3),
                        blurRadius: spacing(8),
                        offset: Offset(0, spacing(2)),
                      ),
                    ],
                  ),
                  child: Icon(
                    feature.icon,
                    color: ConstColor.black,
                    size:
                        responsive.fontSize(6.5) *
                        scaleFactor *
                        _spacingFactor, // أيقونة أصغر على Android
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
