part of check_in_presentation;

bool areAllMessagesContained(List<types.Message>? snapshotMessages, List<types.Message> messagesToCheck) {
  if (snapshotMessages == null) return false;

  // Build a map of the rooms to check for quick lookup by room ID
  final Map<String, types.Message> roomsToCheckMap = {
    for (final room in messagesToCheck) room.id: room,
  };

  for (final snapshotRoom in snapshotMessages) {
    final matchingRoom = roomsToCheckMap[snapshotRoom.id];

    // Room does not exist in roomsToCheck
    if (matchingRoom == null) return false;
    if (matchingRoom.status != snapshotRoom.status) return false;
    if (matchingRoom.updatedAt != snapshotRoom.updatedAt) return false;
    if (matchingRoom.metadata?['userStatus'] != snapshotRoom.metadata?['userStatus']) return false;
  }

  return true;
}

Widget getMessageStatus(DashboardModel model, types.Message message, types.Message? lastMessage, Map<String, String> userIdToNameMap) {
  switch (message.status) {
    case null:
      // TODO: Handle this case.
      return Container();
    case Status.delivered:
        if (message.id != lastMessage?.id) return Container();


      final statusMap = message.metadata?['userStatus'] as Map<String, dynamic>? ?? {};
      if (statusMap.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Delivered',
            style: TextStyle(
            fontSize: 11,
            color: model.disabledTextColor,
            ),
          ),
        );
      }

      final seenUserIds = statusMap.entries
          .where((entry) => entry.value == types.Status.seen.name)
          .map((entry) => entry.key)
          .toList();

      final seenUsernames = seenUserIds.map((id) => userIdToNameMap[id] ?? 'Unknown').toList();

      if (seenUsernames.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Delivered',
            style: TextStyle(
            fontSize: 11,
            color: model.disabledTextColor,
            ),
          ),
        );
      }

      final displayNames = seenUsernames.take(2).join(', ');
      final remaining = seenUsernames.length - 2;

      final label = remaining > 0
          ? 'Seen by $displayNames +$remaining'
          : 'Seen by $displayNames';

      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      );

    case Status.error:
      return Padding(
      padding: const EdgeInsets.all(4.0),
        child: Icon(Icons.cancel_outlined, color: Colors.red, size: 16),
      );
    case Status.seen:
      return Container();
    case Status.sending:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
          child: SizedBox(
            height: 10,
            width: 10,
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              strokeWidth: 1.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                  model.disabledTextColor,
                ),
              ),
            ),
          ),
        );
    case Status.sent:
      // TODO: Handle this case.
      return Container();
  }
}

