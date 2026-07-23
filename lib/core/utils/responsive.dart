import 'package:flutter/material.dart';

import 'app_constants.dart';

class Responsive {
  Responsive._();

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        AppConstants.desktopWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return width >= AppConstants.tabletWidth &&
        width < AppConstants.desktopWidth;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <
        AppConstants.tabletWidth;
  }
}