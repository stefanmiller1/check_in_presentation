part of check_in_presentation;

class DirectRoomsList extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final RoomsFilterObject? currentFilterObject;
  final bool isLoading;
  final Function(types.Room room, UserProfileModel user) didSelectRoom;

  const DirectRoomsList({super.key, required this.model, required this.isLoading, required this.currentUser, this.currentFilterObject, required this.didSelectRoom}); 
  
  @override
  State<DirectRoomsList> createState() => _DirectRoomsListState();
}

class _DirectRoomsListState extends State<DirectRoomsList> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<types.Room>>(
          stream: facade.FirebaseChatCore.instance.rooms(orderByUpdatedAt: (widget.currentFilterObject?.reverseQueryOrder != null) ? (widget.currentFilterObject?.reverseQueryOrder == true) : true, roomType: types.RoomType.direct, isArchived: false),
          builder: (context, snapshot) {
  
            if (snapshot.connectionState == ConnectionState.waiting && RoomsHelperCore.directRooms.isEmpty) {
              return emptyLargeListView(context, 10, 100, Axis.vertical, kIsWeb);
            }

          
            if (areAllRoomsContained(snapshot.data ?? [], RoomsHelperCore.directRooms) == false) {
              RoomsHelperCore.directRooms = snapshot.data ?? []; 
            }
            

             if (RoomsHelperCore.directRooms.where((room) => (widget.currentFilterObject?.showUnreadOnly == true) ? hasUnreadMessage(room.lastMessages, widget.currentUser) : true).toList().isEmpty) {
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
                    itemCount: RoomsHelperCore.directRooms.where((room) => (widget.currentFilterObject?.showUnreadOnly == true) ? hasUnreadMessage(room.lastMessages, widget.currentUser) : true).length,
                    itemBuilder: (context, index) {
                      final room = RoomsHelperCore.directRooms.where((room) => (widget.currentFilterObject?.showUnreadOnly == true) ? hasUnreadMessage(room.lastMessages, widget.currentUser) : true).toList()[index];
                      final List<types.Message>? lastMessages = room.lastMessages;
                      final List<types.User>? users = room.users;
                      (users ?? []).removeWhere((element) => element.id == widget.currentUser.userId.getOrCrash());
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                            child: getDirectRoomListTile(
                                widget.model,
                                room,
                                RoomsHelperCore.selectedRoomId == room.id,
                                hasUnreadMessage(lastMessages, widget.currentUser),
                                users ?? [],
                                lastMessages ?? [],
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

  