part of check_in_presentation;

enum MessengerContainerMarker {messages, support, archive}

Widget getRoomListTile(DashboardModel model, Room room, bool selected, bool hasNewMessage, bool isArchived, List<types.Message> messages, List<ReservationSlotItem> slots, {required Function(Room) didSelectRoom}) {

  final hasImage = room.imageUrl != null;
  final hasMessages = messages.isNotEmpty;
  final types.Message? lastMessage = hasMessages ? messages.first : null;
  final textMessage = (lastMessage != null) ? lastMessage as types.TextMessage : null;
  late List<ReservationSlotItem> resSorted = slots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));
  final bool resHasStarted = (resSorted.isNotEmpty && resSorted.first.selectedSlots.isNotEmpty) ? resSorted.first.selectedSlots.first.slotRange.start.isBefore(DateTime.now()) : false;

  room.users.removeWhere((element) => element.id == facade.FirebaseChatCore.instance.firebaseUser?.uid);

  return TextButton(
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
              return model.paletteColor.withOpacity(0.1);
            }
            if (states.contains(MaterialState.hovered)) {
              return model.paletteColor.withOpacity(0.1);
            }
            return Colors.transparent; // Use the component's default.
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(13.5)),
            )
        )
    ),
    onPressed: () {
      didSelectRoom(room);
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: (selected) ? Border.all(color: model.paletteColor, width: 1.5) : null
      ),
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
                    avatars: room.users.map((e) => (e.imageUrl != null) ? Image.network(e.imageUrl!).image : Image.asset('assets/profile-avatar.png').image).toList(),
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
                      Text('Reservation with ${room.name ?? 'a New Listing'}', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text(textMessage?.text ?? 'Start Chatting', style: TextStyle(color: (selected) ? model.paletteColor : model.disabledTextColor, fontWeight: hasNewMessage ? FontWeight.bold : FontWeight.normal), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                                color: (hasNewMessage) ? model.paletteColor : model.webBackgroundColor.withOpacity(0.4),
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
                                  color: (hasNewMessage) ? model.paletteColor : model.webBackgroundColor.withOpacity(0.4),
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
                                color: (hasNewMessage) ? model.paletteColor.withOpacity(0.25) : model.webBackgroundColor.withOpacity(0.4),
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
                    color: model.paletteColor,
                    borderRadius: BorderRadius.circular(5)
                ),
              ),
          ],
        ),
      ),
    )
  );
}

Widget loadingRoomItem(BuildContext context) {
  return Container(
    height: 90,
    width: MediaQuery.of(context).size.width,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.withOpacity(0.15),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width - 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.15),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ],
            )
          )
        ],
      ),
    )
  );
}

/// setup avatar for one member
Widget retrieveSystemMessageBuilder(types.SystemMessage message, BuildContext context, DashboardModel model) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 12),
        child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time_rounded, color: model.disabledTextColor),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(message.text, style: TextStyle(color: model.disabledTextColor))
              ),
            ],
          ),
        )
      )
    )
  );
}

/// setup avatar for member with multiple guests or multiple co-owners

/// retrieve reservation details

