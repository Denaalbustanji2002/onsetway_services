// ignore_for_file: deprecated_member_use, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';

class SmartNavigation extends StatelessWidget {
  final List<FeatureCardModel> features;
  final int currentPage;
  final ResponsiveUi responsive;
  final double Function(double) scale;
  final AnimationController indicatorController;
  final PageController pageController;

  const SmartNavigation({
    required this.features,
    required this.currentPage,
    required this.responsive,
    required this.scale,
    required this.indicatorController,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: scale(24), horizontal: scale(20)),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: indicatorController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(features.length, (index) {
                  final isActive = currentPage == index;
                  return GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: scale(8)),
                      width: isActive ? scale(40) : scale(12),
                      height: scale(12),
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? LinearGradient(
                                colors: [ConstColor.gold, ConstColor.darkGold],
                              )
                            : null,
                        color: isActive
                            ? null
                            : ConstColor.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(scale(6)),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: ConstColor.gold.withOpacity(0.6),
                                  blurRadius: scale(12),
                                  offset: Offset(0, scale(3)),
                                  spreadRadius: scale(1),
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
          SizedBox(height: scale(16)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: scale(16),
              vertical: scale(8),
            ),
            decoration: BoxDecoration(
              color: ConstColor.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(scale(20)),
              border: Border.all(
                color: ConstColor.gold.withOpacity(0.3),
                width: scale(1),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_rounded,
                  color: ConstColor.gold.withOpacity(0.8),
                  size:
                      responsive.fontSize(4) * (Platform.isAndroid ? 0.8 : 1.0),
                ),
                SizedBox(width: scale(8)),
                Text(
                  '${currentPage + 1} of ${features.length}',
                  style: TextStyle(
                    color: ConstColor.white.withOpacity(0.8),
                    fontSize:
                        responsive.fontSize(3.5) *
                        (Platform.isAndroid ? 0.8 : 1.0),
                    fontWeight: FontWeight.w600,
                    letterSpacing: scale(0.5),
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
