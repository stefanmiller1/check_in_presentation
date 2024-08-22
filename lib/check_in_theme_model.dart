part of check_in_presentation;

/// DashboardModel class is the base of the Authenticated dashboard browser
/// It contains the sizes, control, theme information
enum AppOption {activities, organizers, owners}

class DashboardModel extends Listenable {

  /// Used to create the instance of [DashboardModel]
  static DashboardModel instance = DashboardModel();

  // /// Holds the searched control list
  // late List<Control> searchControlItems;


  Future<bool> isAppCircleForActivities() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.appName == 'check_in_activities') {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> isAppCirclesForOrganizers() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.appName == 'check_in_web_mobile_explore') {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> isAppCirclesForOwners() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.appName == 'check_in_web') {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<AppOption?> getCurrentAppOption() async {

    late AppOption? currentOption = null;

    try {

      final bool isAppActivities = await isAppCircleForActivities();
      final bool isAppOrganizers = await isAppCirclesForOrganizers();
      final bool isAppOwners = await isAppCirclesForOwners();

      if (isAppActivities) {
        currentOption = AppOption.activities;
      }
      if (isAppOrganizers) {
        currentOption = AppOption.organizers;
      }
      if (isAppOwners) {
        currentOption = AppOption.owners;
      }

       return currentOption;
    } catch (e) {
      Future.error(e);
    }

    return null;
  }


  double? mainContentWidth;

  double? navDrawerWidth;

  double? helperDrawerWidth;

  /// holds container height for facility form main container
  double mainContainerHeight = 800;

  /// holds font size for facility form primary question
  double questionTitleFontSize = 25;

  /// holds font size for facility form secondary question
  double secondaryQuestionTitleFontSize = 18;


  /// holds profile container sizes values

  double profileContainerWidth = 650;
  double leftProfileContainerWidth = 340;


  /// holds container information for profile settings

  double profileSettingsMainContainerWidth = 600;
  double profileSettingsHelperContainerWidth = 300;


  ScrollController? profileControllerLeft;
  ScrollController? profileControllerRight;

  double topScrollingOffset = 30;
  double? bottomMaxOffset;

  /// holds theme based current palette color
  Color backgroundColor = Colors.red;

  /// holds light theme current palette color
  Color paletteColor = Colors.red;

  /// holds accent theme current pallete color
  Color accentColor = Colors.grey.shade200;

  /// holds current palette color
  /// on toggling the palette colors before or after apply settings
  Color currentPrimaryColor = Colors.red;

  /// holds the current theme data
  late ThemeData themeData;

  /// Holds theme based web page background color
  Color webBackgroundColor = const Color.fromRGBO(246, 246, 246, 1);

  /// Holds theme based mobile/tablet page background color
  Color mobileBackgroundColor = Colors.white;

  /// Holds theme based header text color
  Color topHeaderTextColor = Colors.black;

  /// Holds theme based color of icon
  Color webIconColor = const Color.fromRGBO(0, 0, 0, 0.54);

  /// Holds theme based input container color
  Color webInputColor = const Color.fromRGBO(242, 242, 242, 1);

  /// Holds theme based web outputcontainer color
  Color webOutputContainerColor = Colors.white;

  /// Holds the theme based card's color
  Color cardColor = Colors.white;

  /// Holds the theme based divider color
  Color dividerColor = const Color.fromRGBO(204, 204, 204, 1);

  /// Holds theme based bottom sheet color
  Color bottomSheetBackgroundColor = Colors.white;

  /// Holds theme based card color
  Color cardThemeColor = Colors.white;

  /// Holds theme based drawer text color
  Color drawerTextIconColor = Colors.black;

  /// Holds the old browser window's height and width
  Size? oldWindowSize;

  /// Holds the current visible sample, only for web
  late dynamic currentRenderSample;

  /// Holds the current rendered sample's key, only for web
  late String? currentSampleKey;

  /// Contains the light theme pallete colors
  late List<Color>? paletteColors;

  /// Contains the pallete's border colors
  late List<Color>? paletteBorderColors;

  /// Contains dark theme theme palatte colors
  late List<Color>? darkPaletteColors;

  /// Holds current pallete color
  Color currentPaletteColor = Colors.red;

  /// holds the index to finding the current theme
  /// In mobile sb - system 0, light 1, dark 2
  int selectedThemeIndex = 0;

  /// Holds current theme data
  ThemeData? currentThemeData;

  /// Holds the current system theme
  late ThemeData systemTheme;

  /// Holds theme baased color of web outputcontainer
  Color textColor = const Color.fromRGBO(51, 51, 51, 1);

  /// Holds theme baased color of disabled text
  Color disabledTextColor = Colors.grey.shade400;

  /// Holds the information of isMobileResolution or not
  /// To render the appbar and search bar based on it
  late bool isMobileResolution;

  ///check whether application is running on web/linuxOS/windowsOS/macOS
  bool isWebFullView = false;

  ///Check whether application is running on the web browser
  bool isWeb = false;

  ///Check whether application is running on the Windows desktop OS
  bool isWindows = false;

  ///Check whether application is running on the Linux desktop OS
  bool isLinux = false;

  ///Check whether application is running on the macOS desktop
  bool isMacOS = false;

  /// This controls to open / hide the property panel
  bool isPropertyPanelOpened = true;


  //-----------------------------------------//

  /// Text style used for displaying link text on sent text messages.
  /// Defaults to [sentMessageBodyTextStyle]
  late TextStyle sentMessageBodyLinkTextStyle;

  /// Text style used for displaying link description on sent messages.
  late TextStyle sentMessageLinkDescriptionTextStyle;

  /// Text style used for displaying link title on sent messages.
  late TextStyle sentMessageLinkTitleTextStyle;

  /// Body text style used for displaying text on different types
  /// of sent messages
  late TextStyle sentMessageBodyTextStyle;

  /// Body text style used for displaying bold text on sent text messages.
  /// Defaults to a bold version of [sentMessageBodyTextStyle].
  late TextStyle? sentMessageBodyBoldTextStyle;

  /// Body text style used for displaying code text on sent text messages.
  /// Defaults to a mono version of [sentMessageBodyTextStyle].
  late TextStyle? sentMessageBodyCodeTextStyle;

  /// Text style used for displaying emojis on text messages.
  late TextStyle sentEmojiMessageTextStyle;

  /// Body text style used for displaying text on different types
  /// of received messages
  late TextStyle receivedMessageBodyTextStyle;

  /// Text style used for displaying link text on received text messages.
  /// Defaults to [receivedMessageBodyTextStyle]
  late TextStyle receivedMessageBodyLinkTextStyle;

  /// Text style used for displaying link description on received messages.
  late TextStyle receivedMessageLinkDescriptionTextStyle;

  /// Text style used for displaying link title on received messages.
  late TextStyle receivedMessageLinkTitleTextStyle;

  /// Body text style used for displaying bold text on received text messages.
  /// Default to a bold version of [receivedMessageBodyTextStyle].
  late TextStyle? receivedMessageBodyBoldTextStyle;

  /// Body text style used for displaying code text on received text messages.
  /// Defaults to a mono version of [receivedMessageBodyTextStyle].
  late TextStyle? receivedMessageBodyCodeTextStyle;

  /// Text style used for displaying emojis on text messages.
  late TextStyle receivedEmojiMessageTextStyle;

  /// Switching between light, dark, system themes
  void changeTheme(ThemeData _themeData) {
    themeData = _themeData;

    sentMessageBodyBoldTextStyle = TextStyle(
      color: paletteColor,
      fontWeight: FontWeight.bold
    );

    sentMessageBodyCodeTextStyle = TextStyle(
      color: paletteColor,
      fontWeight: FontWeight.w400
    );

    sentMessageBodyLinkTextStyle = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w500
    );

    sentMessageLinkDescriptionTextStyle = TextStyle(
        color: paletteColor,
        fontWeight: FontWeight.w400
    );

    sentMessageLinkTitleTextStyle = TextStyle(
        color: paletteColor,
        fontWeight: FontWeight.w800
    );

    sentMessageBodyTextStyle = TextStyle(
        color: paletteColor,
        fontWeight: FontWeight.w500
    );

    sentEmojiMessageTextStyle = const TextStyle(fontSize: 40);

    receivedMessageBodyTextStyle = TextStyle(
      color: paletteColor,
      fontWeight: FontWeight.w500
    );

    receivedMessageLinkDescriptionTextStyle = TextStyle(
      color: accentColor,
      fontWeight: FontWeight.w400
    );

    receivedMessageLinkTitleTextStyle = TextStyle(
        color: accentColor,
        fontWeight: FontWeight.w800
    );

    receivedEmojiMessageTextStyle = const TextStyle(fontSize: 40);

    receivedMessageBodyLinkTextStyle = TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w400
    );

    receivedMessageBodyBoldTextStyle = TextStyle(
      color: accentColor,
      fontWeight: FontWeight.w800
    );


    receivedMessageBodyCodeTextStyle = TextStyle(
      color: accentColor,
      fontWeight: FontWeight.w400
    );

    switch (_themeData.brightness) {
      case Brightness.dark:
        {
          paletteColor = Colors.grey.shade200;
          accentColor = Colors.black;
          dividerColor = const Color.fromRGBO(61, 61, 61, 1);
          cardColor = const Color.fromRGBO(48, 48, 48, 1);
          webIconColor = const Color.fromRGBO(255, 255, 255, 0.65);
          webOutputContainerColor = const Color.fromRGBO(23, 23, 23, 1);
          webInputColor = const Color.fromRGBO(44, 44, 44, 1);
          webBackgroundColor = const Color.fromRGBO(30, 35, 40, 1);
          mobileBackgroundColor = Colors.black;
          drawerTextIconColor = Colors.white;
          bottomSheetBackgroundColor = const Color.fromRGBO(34, 39, 51, 1);
          topHeaderTextColor = Colors.black.withOpacity(0.3);
          textColor = Colors.deepOrange;
          disabledTextColor = const Color.fromRGBO(99, 103, 112, 1.0);
          cardThemeColor = const Color.fromRGBO(33, 33, 33, 1);
          break;
        }
      default:
        {
          paletteColor = Colors.black;
          accentColor = Colors.grey.shade200;
          dividerColor = const Color.fromRGBO(204, 204, 204, 1);
          cardColor = Colors.white;
          webIconColor = const Color.fromRGBO(0, 0, 0, 0.54);
          webOutputContainerColor = Colors.white;
          webInputColor = const Color.fromRGBO(242, 242, 242, 1);
          webBackgroundColor = Colors.grey.shade100;
          topHeaderTextColor = Colors.grey.shade300;
          drawerTextIconColor = Colors.black;
          mobileBackgroundColor = Colors.white;
          bottomSheetBackgroundColor = Colors.white;
          textColor = const Color.fromRGBO(51, 51, 51, 1);
          disabledTextColor = Colors.grey.shade400;
          cardThemeColor = Colors.white;

          break;
        }
    }
  }


  //ignore: prefer_collection_literals
  final Set<VoidCallback> _listeners = Set<VoidCallback>();

  @override

  /// [listener] will be invoked when the model changes.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override

  /// [listener] will no longer be invoked when the model changes.
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Should be called only by [Model] when the model has changed.
  @protected
  void notifyListeners() {
    _listeners.toList().forEach((VoidCallback listener) => listener());
  }
}