part of check_in_presentation;


String formatLastMessageTime(int? timestamp) {
  if (timestamp == null) return '';

  final DateTime messageDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(messageDate);

  if (difference.inDays == 0) {
    return DateFormat.jm().format(messageDate); // Show time of day (e.g., 5:08 PM)
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays < 7) {
    return DateFormat.EEEE().format(messageDate); // Show day of the week
  } else if (difference.inDays < 30) {
    return DateFormat('dd/MM').format(messageDate); // Show date (day/month)
  } else if (difference.inDays < 365) {
    return DateFormat('MMMM').format(messageDate); // Show month
  } else {
    return DateFormat.y().format(messageDate); // Show year
  }
}

bool areAllRoomsContained(List<types.Room>? snapshotRooms, List<types.Room> roomsToCheck) {
  if (snapshotRooms == null) return false;

  // Build a map of the rooms to check for quick lookup by room ID
  final Map<String, types.Room> roomsToCheckMap = {
    for (final room in roomsToCheck) room.id: room,
  };

  for (final snapshotRoom in snapshotRooms) {
    final matchingRoom = roomsToCheckMap[snapshotRoom.id];

    // Room does not exist in roomsToCheck
    if (matchingRoom == null) return false;

      // Compare list of lastMessage createdAt timestamps and statuses (null-safe)
      final snapshotMessages = snapshotRoom.lastMessages ?? [];
      final matchingMessages = matchingRoom.lastMessages ?? [];

      // Check if lengths match
      if (snapshotMessages.length != matchingMessages.length) return false;

      // Check if all createdAt timestamps and statuses match in order
      for (int i = 0; i < snapshotMessages.length; i++) {
        if (snapshotMessages[i].createdAt != matchingMessages[i].createdAt ||
            snapshotMessages[i].status != matchingMessages[i].status || 
            snapshotMessages[i].updatedAt != matchingMessages[i].updatedAt) {
          return false;
        }
      }
  }

  return true;
}

 bool hasUnreadMessagesInRoom(types.RoomType? type, UserProfileModel currentUser) {
    final currentUserId = currentUser.userId.getOrCrash();
 
    return RoomsHelperCore.allRooms.any((room) {
      if (room.type != type || room.lastMessages?.isEmpty != false) {
        return false;
      }
 
      return room.lastMessages!.any((msg) {

        if (msg.author.id == currentUserId) {
          return false; // Skip messages sent by the current user
        } 
        // Then, check if the current user has not seen the message
        final userStatus = (msg.metadata?['userStatus'] as Map?)?.cast<String, String>() ?? {};
        return userStatus[currentUserId] != types.Status.seen.name && msg.status == types.Status.delivered;
      });
    });
  }


  bool hasUnreadMessage(List<types.Message>? messages, UserProfileModel currentUser) {
    final currentUserId = currentUser.userId.getOrCrash();

   return (messages ?? []).where((element) {
      if (element.author.id == facade.FirebaseChatCore.instance.firebaseUser?.uid) {
        return false; // Skip messages sent by the current user
      }
      if (element.status != types.Status.delivered) {
        return false;
      }

      final userStatus = (element.metadata?['userStatus'] as Map?)?.cast<String, String>() ?? {};
      
      return userStatus[currentUserId] != types.Status.seen.name;
    }).isNotEmpty;

  }

Widget getDirectRoomListTile(DashboardModel model, Room room, bool selected, bool hasNewMessage, List<types.User> users, List<types.Message> messages, {required Function(Room) didSelectRoom}) {

  final hasImage = room.imageUrl != null;
  final hasMessages = messages.isNotEmpty;
  final types.Message? lastMessage = hasMessages ? messages.first : null;
  final textMessage = (lastMessage != null) ? lastMessage as types.TextMessage : null;
  final String lastMessageTime = formatLastMessageTime(lastMessage?.createdAt);

  return HoverButton(
    onpressed: () {
      didSelectRoom(room);
    },
    animationDuration: Duration.zero,
    color: selected ? model.disabledTextColor.withOpacity(0.3) : Colors.transparent,
    hoverColor: model.paletteColor.withOpacity(0.1),
    hoverElevation: 0,
    highlightElevation: 0,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.5),
    ),
    padding: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              if (room.users.isNotEmpty) Container(
                height: 50,
                width: 50,
                child: AvatarStack(
                  infoWidgetBuilder: (surplus) {
                    return Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: model.paletteColor,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Center(
                        child: Text('+$surplus', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    );
                  },
                  avatars: users.map((e) => (e.imageUrl != null) ? Image.network(e.imageUrl!).image : Image.asset('assets/profile-avatar.png').image).toList(),
                ),
              ),
              if (room.users.isEmpty) CircleAvatar(
                backgroundImage: Image.asset('assets/profile-avatar.png').image,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
    
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${room.name ?? 'a New Listing'}',style: TextStyle(
                              color: selected ? model.paletteColor : model.disabledTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lastMessageTime,
                          style: TextStyle(
                            color: model.disabledTextColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(textMessage?.text ?? 'Start Chatting', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: hasNewMessage ? FontWeight.bold : FontWeight.normal), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (hasNewMessage) Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5)
            ),
          ),
        ]
      )
    )
  );
}

Widget getGroupRoomListTile(DashboardModel model, Room room, bool selected, bool hasNewMessage, bool isArchived, List<types.Message> messages, List<ReservationSlotItem> slots, {required Function(Room) didSelectRoom}) {

  final hasMessages = messages.isNotEmpty;
  final types.Message? lastMessage = hasMessages ? messages.first : null;
  final textMessage = (lastMessage != null) ? lastMessage as types.TextMessage : null;
  final String lastMessageTime = formatLastMessageTime(lastMessage?.createdAt);
  late List<ReservationSlotItem> resSorted = slots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));
  final bool resHasStarted = (resSorted.isNotEmpty && resSorted.first.selectedSlots.isNotEmpty) ? resSorted.first.selectedSlots.first.slotRange.start.isBefore(DateTime.now()) : false;

  return HoverButton(
    onpressed: () {
      didSelectRoom(room);
    },
    animationDuration: Duration.zero,
    color: selected ? model.disabledTextColor.withOpacity(0.3) : Colors.transparent,
    hoverColor: model.paletteColor.withOpacity(0.1),
    hoverElevation: 0,
    highlightElevation: 0,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(13.5),
    ),
    padding: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              if (room.users.isNotEmpty) Container(
                height: 50,
                width: 50,
                child: AvatarStack(
                  infoWidgetBuilder: (surplus) {
                    return Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                          color: model.paletteColor,
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Center(
                        child: Text('+$surplus', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    );
                  },
                  avatars: (room.imageUrl != null) ? [Image.network(room.imageUrl!).image] : [Image.asset('assets/profile-avatar.png').image],
                ),
              ),
              if (room.users.isEmpty) CircleAvatar(
                backgroundImage: Image.asset('assets/profile-avatar.png').image,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${room.name ?? 'a New Activity'}',style: TextStyle(
                              color: selected ? model.paletteColor : model.disabledTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          lastMessageTime,
                          style: TextStyle(
                            color: model.disabledTextColor,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(textMessage?.text ?? 'Start the Conversation', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: hasNewMessage ? FontWeight.bold : FontWeight.normal), maxLines: 2, overflow: TextOverflow.ellipsis),
                    /// number of reservations under current profile
                    /// reservations coming up?
                    /// reservations ended?
                    /// reservations happening now?
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isArchived && slots.isNotEmpty && !resHasStarted && resSorted.isNotEmpty && getAllRemainingDates(slots).isNotEmpty) Expanded(
                            child: Container(
                            decoration: BoxDecoration(
                              color: model.webBackgroundColor.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text('Starting: ${resSorted.first.selectedSlots.length} slot(s) on ${DateFormat.yMMMd().format(resSorted.first.selectedDate)} at ${DateFormat.jm().format(getAllRemainingDates(slots).first)}', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: hasNewMessage ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis),
                            )
                          ),
                        ),
                        if (!isArchived && slots.isNotEmpty && resHasStarted && getAllRemainingDates(slots).isNotEmpty) const SizedBox(width: 3),
                        if (!isArchived && slots.isNotEmpty && resHasStarted && getAllRemainingDates(slots).isNotEmpty) Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: model.webBackgroundColor.withOpacity(0.4),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text('Coming Up: ${DateFormat.yMMMd().format(getAllRemainingDates(slots).first)} at ${DateFormat.jm().format(getAllRemainingDates(slots).first)}', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: hasNewMessage ? FontWeight.bold : FontWeight.normal), overflow: TextOverflow.ellipsis,),
                              )
                          ),
                        ),
                        if (!isArchived) const SizedBox(width: 3),
                        if (isArchived) Container(
                            decoration: BoxDecoration(
                              color: model.webBackgroundColor.withOpacity(0.4),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text('Finished', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            )
                        ),
                      ],
                    )
                    // if (hasMessages) Text(room.lastMessages?.first. ?? '', style: TextStyle(color: model.disabledTextColor))
                ],
              ),
            ),
            if (hasNewMessage) Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5)
              ),
            ),
        ],
      ),
    )
  );
}

Widget loadingRoomItem(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
        child: ListTile(
          leading: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.withOpacity(0.15),
                  ),
                ),
            title: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.15),
        ),
      )
    ),
  );
}