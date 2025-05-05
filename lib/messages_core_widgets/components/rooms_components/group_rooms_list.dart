part of check_in_presentation;

class GroupRoomsList extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final RoomsFilterObject? currentFilterObject;
  final Function(types.Room room, UserProfileModel user) didSelectRoom;

  const GroupRoomsList({super.key, required this.model, required this.currentUser, this.currentFilterObject, required this.didSelectRoom}); 
  
  @override
  State<GroupRoomsList> createState() => _GroupRoomsListState();
}

class _GroupRoomsListState extends State<GroupRoomsList> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Room>>(
          stream: facade.FirebaseChatCore.instance.rooms(orderByUpdatedAt: (widget.currentFilterObject?.reverseQueryOrder != null) ? (widget.currentFilterObject?.reverseQueryOrder == true) : true, roomType: types.RoomType.group, isArchived: widget.currentFilterObject?.isArchive == true),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting && RoomsHelperCore.groupRooms.isEmpty) {
              return emptyLargeListView(context, 10, 100, Axis.vertical, kIsWeb);
            }

            if (areAllRoomsContained(snapshot.data ?? [], RoomsHelperCore.directRooms) == false) {
              RoomsHelperCore.groupRooms = snapshot.data ?? [];
            }

             if (RoomsHelperCore.groupRooms.where((room) => (widget.currentFilterObject?.showUnreadOnly == true) ? hasUnreadMessage(room.lastMessages, widget.currentUser) : true).toList().isEmpty) {
                if (widget.currentFilterObject?.showUnreadOnly == true) {
                  return noItemsFound(
                      widget.model,
                      Icons.chat_outlined,
                      'You\'re All Caught Up!',
                      'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                      'See All Chats',
                      didTapStartButton: () {
                        setState(() {

                      });
                    }
                  );
                }
                return noItemsFound(
                    widget.model,
                    Icons.chat_outlined,
                    'No Chats Yet!',
                    'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                    'Start a New Activity',
                    didTapStartButton: () {
                      setState(() {
                        
                  });
                }
              );
            }
  
              return Container(
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: RoomsHelperCore.groupRooms.where((room) => (widget.currentFilterObject?.showUnreadOnly == true) ? hasUnreadMessage(room.lastMessages, widget.currentUser) : true).length,
                    itemBuilder: (context, index) {
                      final room = RoomsHelperCore.groupRooms.where((room) => (widget.currentFilterObject?.showUnreadOnly == true) ? hasUnreadMessage(room.lastMessages, widget.currentUser) : true).toList()[index];
                      final List<types.Message>? lastMessages = room.lastMessages;
                      late List dateSlotsData = [];
                        if (room.metadata?['reservationSlot'] != null) {
                          dateSlotsData.addAll(room.metadata?['reservationSlot']);
                        }
                        final List<ReservationSlotItem> dates = dateSlotsData.isNotEmpty ? dateSlotsData.map((e) => ReservationSlotItemDto.fromJson(e).toDomain()).toList() : [];


                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                            child: getGroupRoomListTile(
                                widget.model,
                                room,
                                RoomsHelperCore.selectedRoomId == room.id,
                                hasUnreadMessage(lastMessages, widget.currentUser),
                                widget.currentFilterObject?.isArchive == true,
                                lastMessages ?? [],
                                dates,
                                didSelectRoom: (e) {
                                    widget.didSelectRoom(e, widget.currentUser);
                            }
                          )
                        );
  
            }
          ),
        );
      }
    );
  }
}