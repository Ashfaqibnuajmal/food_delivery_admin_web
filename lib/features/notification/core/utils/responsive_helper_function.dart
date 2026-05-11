import 'package:flutter/material.dart';

class ResponsiveHelper {
  // MOBILE
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  // TABLET
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 768 &&
        MediaQuery.of(context).size.width < 1200;
  }

  // DESKTOP
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
}
