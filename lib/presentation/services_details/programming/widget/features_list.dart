// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';

class FeatureList extends StatefulWidget {
  const FeatureList({
    super.key,
    required this.feature,
    required this.responsive,
    required this.isActive,
    required this.scaleFactor,
  });

  final dynamic feature;
  final dynamic responsive;
  final bool isActive;
  final double scaleFactor;

  @override
  State<FeatureList> createState() => _FeatureListState();
}

class _FeatureListState extends State<FeatureList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  double get _spacingFactor => Platform.isAndroid ? 0.6 : 1.0;
  double spacing(double value) => value * _spacingFactor;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // يخلي اللون يروح ويرجع

    _colorAnimation = ColorTween(
      begin: ConstColor.gold.withOpacity(0.3),
      end: ConstColor.darkGold.withOpacity(0.8),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing(20)),
          child: Container(
            padding: EdgeInsets.all(spacing(18)),
            decoration: BoxDecoration(
              color: ConstColor.gold.withOpacity(0.25),
              borderRadius: BorderRadius.circular(spacing(18)),
              border: Border.all(
                color: _colorAnimation.value!,
                width: spacing(2),
              ),
              boxShadow: [
                BoxShadow(
                  color: ConstColor.black.withOpacity(0.2),
                  blurRadius: spacing(8),
                  offset: Offset(0, spacing(4)),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.feature.bulletPoints.asMap().entries.map<Widget>(
                (entry) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key < widget.feature.bulletPoints.length - 1
                          ? spacing(12)
                          : 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: spacing(6)),
                          width: spacing(8),
                          height: spacing(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [ConstColor.gold, ConstColor.darkGold],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: ConstColor.gold.withOpacity(0.4),
                                blurRadius: spacing(4),
                                offset: Offset(0, spacing(1)),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: spacing(12)),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontSize:
                                  widget.responsive.fontSize(3.9) *
                                  widget.scaleFactor,
                              height: 1.04,
                              letterSpacing: spacing(0.2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}
