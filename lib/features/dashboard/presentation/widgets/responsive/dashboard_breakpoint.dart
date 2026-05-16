class DashboardBreakpoints {
  static bool isMobile(double width) => width < 700;

  static bool isTablet(double width) => width >= 700 && width < 1100;

  static bool isDesktop(double width) => width >= 1100;
}
