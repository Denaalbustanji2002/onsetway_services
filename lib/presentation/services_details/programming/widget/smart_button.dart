import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';

class SmartButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onPressed;
  final double Function(double) scale;
  final ResponsiveUi responsive;
  final double scaleFactor;

  const SmartButton({
    required this.text,
    required this.icon,
    required this.isPrimary,
    required this.onPressed,
    required this.scale,
    required this.responsive,
    required this.scaleFactor,
  });

  double get _spacingFactor => Platform.isAndroid ? 0.5 : 1.0;
  double spacing(double value) => value * _spacingFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? ConstColor.gold : Colors.transparent,
          foregroundColor: isPrimary ? ConstColor.black : ConstColor.darkGold,
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: spacing(scale(14)),
            horizontal: spacing(scale(16)),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(spacing(scale(16))),
            side: BorderSide(
              color: isPrimary
                  ? ConstColor.darkGold
                  : ConstColor.gold.withOpacity(0.6),
              width: spacing(scale(2)),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // <--- هذا يمنع Row من ملء كل العرض
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: responsive.fontSize(3.2) * scaleFactor),
            SizedBox(width: spacing(scale(8))),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.fontSize(3.2) * scaleFactor,
                  letterSpacing: spacing(scale(0.5)),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
