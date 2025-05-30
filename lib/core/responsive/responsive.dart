part of check_in_presentation;

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
  super.key,
  required this.mobile,
  required this.tablet,
  required this.desktop});

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 950;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1200 &&
          MediaQuery.of(context).size.width >= 950;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // If our width is more than 1100 then we consider it a desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        }
        // If width it less then 1100 and more then 650 we consider it as tablet
        else if (constraints.maxWidth >= 950) {
          return tablet;
        }
        // Or less then that we called it mobile
        else if (!(kIsWeb)) {
          return mobile;
        } else {
          return desktop;
        }
      },
    );
  }

}