import 'package:flutter/material.dart';

class ResponsiveUi {
  final BuildContext context;

  ResponsiveUi(this.context);

  bool get isMobile => MediaQuery.of(context).size.width < 500;
  bool get isTablet =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1200;
  bool get isDesktop => MediaQuery.of(context).size.width >= 1200;

  double width(double percentage) {
    return MediaQuery.of(context).size.width * (percentage / 100);
  }

  double height(double percentage) {
    return MediaQuery.of(context).size.height * (percentage / 100);
  }

  double fontSize(double scale) {
    return MediaQuery.of(context).size.width * (scale / 100);
  }
}