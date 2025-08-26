// ignore_for_file: file_names, use_key_in_widget_constructors, deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';

class SmartHeader extends StatelessWidget {
  final ResponsiveUi responsive;
  final double Function(double) scale;

  const SmartHeader({required this.responsive, required this.scale});

  double get _spacingFactor => Platform.isAndroid ? 0.5 : 1.0;
  double spacing(double value) => value * _spacingFactor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing(18)),
      padding: EdgeInsets.symmetric(
        horizontal: spacing(28),
        vertical: spacing(32),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ConstColor.black, ConstColor.black.withOpacity(0.9)],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main headline
          Text(
            'Revolutionize Your Business',
            style: TextStyle(
              fontFamily: 'MAIAN',
              color: ConstColor.gold,
              fontSize:
                  responsive.fontSize(5.4) * (Platform.isAndroid ? 0.8 : 1.0),
              fontWeight: FontWeight.w700,
              letterSpacing: spacing(0.8),
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: spacing(10)),

          // Subtle accent line
          Container(
            width: spacing(80),
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  ConstColor.darkGold,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
