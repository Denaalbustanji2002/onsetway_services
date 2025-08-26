// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';

class EnhancedPatternPainter extends CustomPainter {
  final Color color;
  final bool isActive;
  final double animationValue;
  final double scaleFactor;

  const EnhancedPatternPainter({
    required this.color,
    this.isActive = false,
    this.animationValue = 1.0,
    this.scaleFactor = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(isActive ? 0.12 : 0.06)
      ..strokeWidth = 1.0 * scaleFactor;

    final spacing = (isActive ? 25.0 : 35.0) * animationValue * scaleFactor;

    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    if (isActive) {
      paint.style = PaintingStyle.fill;
      final dotSize = 1.5 * animationValue * scaleFactor;
      for (double x = 30 * scaleFactor; x < size.width; x += 80 * scaleFactor) {
        for (
          double y = 30 * scaleFactor;
          y < size.height;
          y += 80 * scaleFactor
        ) {
          canvas.drawCircle(Offset(x, y), dotSize, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
