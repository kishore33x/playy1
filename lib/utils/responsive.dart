import 'package:flutter/material.dart';

/// Responsive design utility
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double scale(BuildContext context, double value) {
    final width = getWidth(context);
    if (width < 600) return value * 0.8;
    if (width < 1200) return value * 0.9;
    return value;
  }

  static double responsiveFont(BuildContext context, double baseSize) {
    final width = getWidth(context);
    if (width < 600) return baseSize * 0.85;
    if (width < 1200) return baseSize * 0.9;
    return baseSize;
  }

  static EdgeInsets getResponsivePadding(BuildContext context,
      {double mobile = 12, double tablet = 16, double desktop = 20}) {
    if (isMobile(context)) return EdgeInsets.all(mobile);
    if (isTablet(context)) return EdgeInsets.all(tablet);
    return EdgeInsets.all(desktop);
  }

  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  static int getListTileColumns(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }
}
