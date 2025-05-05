part of check_in_presentation;

class ChatHeaderWidget extends StatelessWidget {
  final types.Room room;
  final bool showDetails;
  final DashboardModel model;
  final VoidCallback onShowDetails;

  const ChatHeaderWidget({
    Key? key,
    required this.room,
    required this.model,
    required this.showDetails,
    required this.onShowDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isGroup = room.type == types.RoomType.group;
    final usersCount = room.users.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: model.accentColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: model.disabledTextColor.withOpacity(0.15),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                if (room.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      room.imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: model.disabledTextColor.withOpacity(0.1),
                    child: Icon(Icons.chat, color:  model.paletteColor),
                  ),
                const SizedBox(width: 12),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              room.name ?? 'Chat',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: model.secondaryQuestionTitleFontSize,
                                color: model.paletteColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          if (isGroup)
                            Text(
                              '$usersCount members',
                              style: TextStyle(
                                color: model.disabledTextColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
          
          SizedBox(
            // width: 200,
            height: 50,
            child: HoverButton(
              onpressed: onShowDetails,
              animationDuration: Duration.zero,
              color: showDetails ? model.paletteColor : model.webBackgroundColor,
              hoverColor: model.disabledTextColor.withOpacity(0.2),
              hoverElevation: 0,
              highlightElevation: 0,
              hoverShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.info_circle, color: showDetails ? model.accentColor : model.paletteColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      ' Show Details',
                      style: TextStyle(
                        color: showDetails ? model.accentColor : model.paletteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
