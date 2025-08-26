// ignore_for_file: deprecated_member_use, unused_field

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:onsetway_services/constitem/const_colors.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/action_button.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/animation_manger.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/feature_card.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/features_list.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/image_section.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/title_section.dart';

class FeatureCard extends StatefulWidget {
  final FeatureCardModel feature;
  final ResponsiveUi responsive;
  final bool isActive;
  final VoidCallback? onContactUs;
  final VoidCallback? onGetQuote;

  const FeatureCard({
    super.key,
    required this.feature,
    required this.responsive,
    this.isActive = false,
    this.onContactUs,
    this.onGetQuote,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with TickerProviderStateMixin {
  late CardAnimationManager _animationManager;
  bool _isHovered = false;
  late double _scaleFactor;
  late double _spacingFactor;

  @override
  void initState() {
    super.initState();
    // Android: أصغر شوية
    _scaleFactor = Platform.isAndroid ? 0.85 : 1.0;
    _spacingFactor = Platform.isAndroid ? 0.6 : 1.0;

    _animationManager = CardAnimationManager(this, _scaleFactor);
    if (widget.isActive) {
      _animationManager.updateState(true);
    }
  }

  @override
  void didUpdateWidget(FeatureCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationManager.updateState(widget.isActive);
  }

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }

  double scale(double value) => value * _scaleFactor;
  double spacing(double value) => value * _spacingFactor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _animationManager.mainController,
        _animationManager.pulseController,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _animationManager.slideAnimation,
          child: Transform.scale(
            scale: widget.isActive
                ? _animationManager.scaleAnimation.value
                : 0.92,
            child: Transform.rotate(
              angle: widget.isActive
                  ? _animationManager.rotationAnimation.value
                  : 0,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isHovered = true),
                onTapUp: (_) => setState(() => _isHovered = false),
                onTapCancel: () => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: widget.responsive.width(80) * _scaleFactor,
                  margin: EdgeInsets.symmetric(
                    horizontal: spacing(8),
                    vertical: widget.isActive ? spacing(8) : spacing(16),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(scale(24)),
                    color: ConstColor.black, // 👈 الخلفية صارت بيضاء
                    boxShadow: [
                      BoxShadow(
                        color: ConstColor.darkGold.withOpacity(
                          widget.isActive ? 0.4 : 0.2,
                        ),
                        blurRadius: widget.isActive ? scale(30) : scale(15),
                        offset: Offset(
                          0,
                          widget.isActive ? scale(15) : scale(8),
                        ),
                        spreadRadius: widget.isActive ? scale(3) : scale(1),
                      ),
                    ],
                    border: widget.isActive
                        ? Border.all(
                            color: ConstColor.gold.withOpacity(0.6),
                            width: scale(2),
                          )
                        : null,
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(scale(24)),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: EnhancedPatternPainter(
                              color: ConstColor.white.withOpacity(0.08),
                              isActive: widget.isActive,
                              animationValue: widget.isActive
                                  ? _animationManager.pulseAnimation.value
                                  : 1.0,
                              scaleFactor: _scaleFactor,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageSection(
                              feature: widget.feature,
                              responsive: widget.responsive,
                              isActive: widget.isActive,
                              scaleFactor: _scaleFactor,
                              pulseAnimation: _animationManager.pulseAnimation,
                            ),
                            SizedBox(height: spacing(12)), // أقل من 16
                            TitleSection(
                              feature: widget.feature,
                              responsive: widget.responsive,
                              isActive: widget.isActive,
                              scaleFactor: _scaleFactor,
                            ),
                            SizedBox(height: spacing(12)),
                            FeatureList(
                              feature: widget.feature,
                              responsive: widget.responsive,
                              isActive: widget.isActive,
                              scaleFactor: _scaleFactor,
                            ),
                            SizedBox(height: spacing(14)), // أقل من 20
                            ActionButtons(
                              feature: widget.feature,
                              responsive: widget.responsive,
                              isActive: widget.isActive,
                              scaleFactor: _scaleFactor,
                              onContactUs: widget.onContactUs,
                              onGetQuote: widget.onGetQuote,
                            ),
                            SizedBox(height: spacing(12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
