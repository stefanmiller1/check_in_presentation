part of check_in_presentation;

class ReservationHelperCore {

  static AttendeeItem? selectedReservationAttendeeItem;
  static ReservationItem? selectedReservationItem;
  static ActivityManagerForm? currentActivityForm;
  static ListingManagerForm? currentListingManagerForm;
  static List<TicketItem>? currentAttendeeTicketItems = [];
  // static UserProfileModel? currentUserProfile;
  // static UniqueId? selectedReservationId;
  static bool isLoadingSelectedReservation = false;
  static bool isLoading = false;
  static bool didPresentSidePanel = true;
  static double previewerWidth = 510;
  static SettingsItemModel currentSettingsItemModel = subActivitySettingItems(null)[0];
  static ProfileSettingMarker currentProfileSettingsMarker = accountSettingsList(false)[0].marker;


  // static void setupSelectedReservationNavBar(ListingManagerForm listing, ReservationItem reservation, UserProfileModel currentUser, ActivityManagerForm? activityForm) {
  //   /// set other tabs to this current reservation
  //   if (currentListingManagerForm == null || currentListingManagerForm?.listingServiceId != listing.listingServiceId) {
  //     currentListingManagerForm = listing;
  //   }
  //
  //   if (currentUserProfile == null || currentUserProfile?.userId != currentUser.userId) {
  //     currentUserProfile = currentUser;
  //   }
  //
  //   if (selectedReservationItem == null || selectedReservationItem?.reservationId != reservation.reservationId) {
  //     selectedReservationItem = reservation;
  //   }
  //
  //   if (currentActivityForm == null || currentActivityForm?.activityFormId != activityForm?.activityFormId) {
  //     currentActivityForm = activityForm;
  //   }
  //
  // }
}