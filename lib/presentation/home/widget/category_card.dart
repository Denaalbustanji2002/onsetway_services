// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:io' show Platform; // Add platform detection

class CategoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String imagePath;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imagePath,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;
  double _scaleFactor = 1.0; // Added scale factor variable

  @override
  void initState() {
    super.initState();
    // Set scale factor based on platform
    _scaleFactor = Platform.isAndroid ? 0.7 : 1.0;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper method to scale values for Android
  double _scaled(double value) => value * _scaleFactor;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _animationController.forward(),
        onTapUp: (_) {
          _animationController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _animationController.reverse(),
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                height: _isHovered
                    ? _scaled(190) // Scaled height
                    : _scaled(180), // Scaled height
                margin: EdgeInsets.symmetric(
                  horizontal: _isHovered
                      ? _scaled(4) // Scaled margin
                      : _scaled(8), // Scaled margin
                  vertical: _isHovered
                      ? _scaled(4) // Scaled margin
                      : _scaled(8), // Scaled margin
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _scaled(24),
                  ), // Scaled radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.4 : 0.25),
                      blurRadius: _isHovered
                          ? _scaled(20)
                          : _scaled(15), // Scaled blur
                      offset: Offset(
                        0,
                        _isHovered ? _scaled(10) : _scaled(8),
                      ), // Scaled offset
                      spreadRadius: _isHovered
                          ? _scaled(2)
                          : 0, // Scaled spread
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: _scaled(2), // Scaled blur
                      offset: Offset(0, _scaled(-2)), // Scaled offset
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    _scaled(24),
                  ), // Scaled radius
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image
                      Transform.scale(
                        scale: _isHovered ? 1.05 : 1.0,
                        child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                      ),

                      // Gradient overlay
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(_isHovered ? 0.7 : 0.6),
                              Colors.black.withOpacity(_isHovered ? 0.3 : 0.2),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),

                      // Shimmer effect on hover
                      if (_isHovered)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),

                      // Content
                      Padding(
                        padding: EdgeInsets.all(_scaled(20)), // Scaled padding
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Icon container
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()
                                    ..rotateZ(_rotationAnimation.value),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      _isHovered ? 0.25 : 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      _scaled(16),
                                    ), // Scaled radius
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: _scaled(1), // Scaled width
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: _scaled(8), // Scaled blur
                                        offset: Offset(
                                          0,
                                          _scaled(4),
                                        ), // Scaled offset
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(
                                    _scaled(12),
                                  ), // Scaled padding
                                  child: Icon(
                                    widget.icon,
                                    color: Colors.white,
                                    size: _isHovered
                                        ? _scaled(32) // Scaled size
                                        : _scaled(28), // Scaled size
                                  ),
                                ),

                                // Arrow
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.identity()
                                    ..translate(
                                      _isHovered ? _scaled(4.0) : 0.0,
                                      0.0,
                                    ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(
                                      _scaled(12),
                                    ), // Scaled radius
                                  ),
                                  padding: EdgeInsets.all(
                                    _scaled(8),
                                  ), // Scaled padding
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: _scaled(16), // Scaled size
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _isHovered
                                        ? _scaled(22) // Scaled size
                                        : _scaled(20), // Scaled size
                                    color: Colors.white,
                                    letterSpacing: _scaled(
                                      0.5,
                                    ), // Scaled spacing
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.8),
                                        blurRadius: _scaled(4), // Scaled blur
                                        offset: Offset(
                                          0,
                                          _scaled(2),
                                        ), // Scaled offset
                                      ),
                                    ],
                                  ),
                                  child: Text(widget.title),
                                ),

                                SizedBox(height: _scaled(8)), // Scaled spacing

                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: _isHovered ? 1.0 : 0.9,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _scaled(12), // Scaled padding
                                      vertical: _scaled(6), // Scaled padding
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(
                                        _scaled(20),
                                      ), // Scaled radius
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: _scaled(1), // Scaled width
                                      ),
                                    ),
                                    child: Text(
                                      widget.subtitle,
                                      style: TextStyle(
                                        fontSize: _scaled(12), // Scaled size
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: _scaled(
                                          0.3,
                                        ), // Scaled spacing
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Border highlight
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            _scaled(24),
                          ), // Scaled radius
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              _isHovered ? 0.3 : 0.1,
                            ),
                            width: _isHovered
                                ? _scaled(2) // Scaled width
                                : _scaled(1), // Scaled width
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
