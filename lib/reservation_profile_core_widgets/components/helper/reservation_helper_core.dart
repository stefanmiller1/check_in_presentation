part of check_in_presentation;

class ReservationHelperCore {

  static AttendeeItem? selectedReservationAttendeeItem;
  static ReservationItem? selectedReservationItem;
  static ActivityManagerForm? currentActivityForm;
  static ListingManagerForm? currentListingManagerForm;
  static List<TicketItem>? currentAttendeeTicketItems = [];
  static UserProfileModel? currentUserProfile;
  static bool isLoading = false;
  static bool didPresentSidePanel = true;
  static double previewerWidth = 470;
  static SettingsItemModel currentSettingsItemModel = subActivitySettingItems(null)[0];

}