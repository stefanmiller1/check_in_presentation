part of check_in_presentation;

class RoomsScreen extends StatefulWidget {

  final DashboardModel model;
  final String? initialSelectedRoomId;
  final Function(types.Room room, UserProfileModel profile) didSelectRoom;

  const RoomsScreen({super.key, required this.model, this.initialSelectedRoomId, required this.didSelectRoom});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {

  final List<RoomsFilter> _roomsFilters = [
    RoomsFilter(
      filterTitle: 'All',
      filterType: null,
      roleType: null,
      activityState: ReservationSlotState.values,
    ),
    RoomsFilter(
      filterTitle: 'Direct',
      filterType: types.RoomType.direct,
      roleType: null,
      activityState: null,
    ),
    RoomsFilter(
      filterTitle: 'Activities',
      filterType: types.RoomType.group,
      roleType: [types.Role.admin, types.Role.user],
      activityState: ReservationSlotState.values,
      showArchiveButton: true,
    ),
    RoomsFilter(
      filterTitle: 'Circles',
      filterType: types.RoomType.channel,
      roleType: [types.Role.admin, types.Role.user],
      activityState: null,
    ),
  ];

  final double loadingHeight = 100;
  late bool isLoading = false;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: retrieveAuthenticationState(context, kIsWeb)
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, bool isBrowser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => emptyLargeListView(context, 10, loadingHeight, Axis.vertical, kIsWeb),
              loadProfileFailure: (_) => (isBrowser) ? GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },) : emptyLargeListView(context, 10, loadingHeight, Axis.vertical, kIsWeb),
              loadUserProfileSuccess: (item) => listOfRooms(context, item.profile),
              orElse: () {
                return emptyLargeListView(context, 10, loadingHeight, Axis.vertical, kIsWeb);
            }
          );
        },
      ),
    );
  }

  Widget listOfRooms(BuildContext context, UserProfileModel currentUser) {
      return Column(
        children: [
          RoomsFilterHeader(
            initialFilterModel: RoomsHelperCore.currentFilterModel,
            filterItem: _roomsFilters.firstWhere((filter) => filter.filterType == RoomsHelperCore.currentFilterModel?.roomType,
            orElse: () => _roomsFilters.first),
            defaultFilterList: _roomsFilters,
            currentUser: currentUser,
            model: widget.model,
            didUpdateFilterModel: (filterModel) { 
              setState(() {
                  isLoading = true;
                  // RoomsHelperCore.allRooms.clear();
                  RoomsHelperCore.groupRooms.clear();
                  // RoomsHelperCore.directRooms.clear();
                  
                  RoomsHelperCore.currentFilterModel = filterModel;
                  Future.delayed(const Duration(milliseconds: 600), () {
                    setState(() {
                      isLoading = false;
                    });
                  });
              });
          }
        ),
        const SizedBox(height: 15),
        if (isLoading == true) Expanded(child: emptyLargeListView(context, 10, loadingHeight, Axis.vertical, kIsWeb)),
        if (isLoading == false) Expanded(child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: getRoomsByFilterType(context, RoomsHelperCore.currentFilterModel, currentUser)),
          )
        )
      ]
    );
  }

  Widget getRoomsByFilterType(BuildContext context, RoomsFilterObject? filter,  UserProfileModel currentUser) {
      switch (filter?.roomType) {
        case null:
        return getAllRooms(currentUser);
        case types.RoomType.channel:
        return getChannelRooms(currentUser);
        case types.RoomType.direct:
        return getDirectRooms(currentUser);
        case types.RoomType.group:
        return getGroupRooms(currentUser);
    }
  }

  Widget getAllRooms(UserProfileModel currentUser) {
    return AllRoomsList(
      model: widget.model,
      currentUser: currentUser,
      currentFilterObject: RoomsHelperCore.currentFilterModel,
      didSelectRoom: (room, profile) {
      if (Responsive.isMobile(context)) {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) {
              return DirectChatScreen(
                model: widget.model,
                roomId: room.id,
                currentUser: profile,
                showOptions: null,
                reservationItem: null,
                isFromReservation: false,
              );
            }));
          } else {
            widget.didSelectRoom(room, currentUser);
        }
      },
    );
  }

  Widget getDirectRooms(UserProfileModel currentUser) {
    return DirectRoomsList(
          model: widget.model,
          currentUser: currentUser,
          currentFilterObject: RoomsHelperCore.currentFilterModel,
          isLoading: isLoading,
          didSelectRoom: (room, profile) {
          if (Responsive.isMobile(context)) {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return DirectChatScreen(
                    model: widget.model,
                    roomId: room.id,
                    currentUser: profile,
                    showOptions: null,
                    reservationItem: null,
                    isFromReservation: false,
                  );
                }));
          } else {
            widget.didSelectRoom(room, currentUser);
        }
      },
    );
  }

  Widget getGroupRooms(UserProfileModel currentUser) {
      return GroupRoomsList(
          model: widget.model,
          currentUser: currentUser,
          currentFilterObject: RoomsHelperCore.currentFilterModel,
          didSelectRoom: (room, profile) {
          if (Responsive.isMobile(context)) {
            Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return DirectChatScreen(
                    model: widget.model,
                    roomId: room.id,
                    currentUser: profile,
                    showOptions: null,
                    reservationItem: null,
                    isFromReservation: false,
                  );
                }));
          } else {
              widget.didSelectRoom(room, currentUser);
          }
        },
      );
  }

  Widget getChannelRooms(UserProfileModel currentUser) {
    return Container();
  }

}