// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
part of check_in_presentation;


class RoomsFilter {

  final String filterTitle;
  final types.RoomType? filterType;
  final bool? showArchiveButton;
  final List<types.Role>? roleType;
  final List<ReservationSlotState>? activityState;

  RoomsFilter({required this.filterTitle, required this.filterType, this.showArchiveButton, required this.roleType, required this.activityState});
  
}

class RoomsHelperCore {

  static String? selectedRoomId;
  static UserProfileModel? currentUserProfile;
  static List<types.Room> groupRooms = [];
  static List<types.Room> directRooms = [];
  static List<types.Room> channelRooms = [];
  static List<types.Room> allRooms = [];
  static bool isLoading = false;
  static int currentPageIndex = 0;
  static RoomsFilterObject? currentFilterModel = RoomsFilterObject(
    roomType: null,
    reverseQueryOrder: null,
    currentSearchTerm: null,
    showUnreadOnly: null,
    isArchive: null,
  );
  
}

