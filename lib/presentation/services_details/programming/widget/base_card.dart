import 'package:flutter/cupertino.dart';
import 'package:onsetway_services/helper/responsive_ui.dart';
import 'package:onsetway_services/presentation/services_details/programming/widget/card_model.dart';

abstract class BaseCardWidget extends StatelessWidget {
  final FeatureCardModel feature;

  final ResponsiveUi responsive;
  final bool isActive;
  final double scaleFactor;

  const BaseCardWidget({
    required this.feature,
    required this.responsive,
    required this.isActive,
    required this.scaleFactor,
  });

  double scale(double value) => value * scaleFactor;
}
