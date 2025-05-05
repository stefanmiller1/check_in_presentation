part of check_in_presentation;


class ChatDetailsSideBar extends StatefulWidget {

  final double sideBarWidth;
  final Room room;
  final bool isReservation;
  final DashboardModel model;
  final Function(User) didSelectUser;
  final Function(bool) didSelectNotificationSwitch;

  ChatDetailsSideBar({
    super.key,
      required this.model,
      required this.sideBarWidth, 
      required this.room, 
      required this.isReservation,
      required this.didSelectNotificationSwitch, 
      required this.didSelectUser,
  });

  @override
  State<ChatDetailsSideBar> createState() => _ChatDetailsSideBarState();
}

class _ChatDetailsSideBarState extends State<ChatDetailsSideBar> {
  
  bool _showLeaveOptions = false;
  bool? notificationSilenced = null;

  void _toggleLeaveOptions() {
    setState(() {
      _showLeaveOptions = !_showLeaveOptions;
    });
  }
  
  initState() {
    super.initState();
      notificationSilenced = widget.room.metadata?['notificationsSilenced']?[facade.FirebaseChatCore.instance.firebaseUser?.uid];
  }

  @override
  Widget build(BuildContext context) {

    if (!kIsWeb) {
      return _buildForMobile();
    }
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Row(
            children: [
              const SizedBox(width: 4),
              VerticalDivider(
                color: widget.model.disabledTextColor.withOpacity(0.35),
                thickness: 1,
              ),
              const SizedBox(width: 4),
            ]
          ),

           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: widget.sideBarWidth - 35,
                decoration: BoxDecoration(
                  color: widget.model.accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: widget.model.disabledTextColor.withOpacity(0.15),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Details ', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              if (widget.room.type == types.RoomType.group && widget.isReservation) buildActivityPreview(),
              _buildRoomHeaderAndActions(),
              buildNotificationSwitch(),       
              _buildMemberTitle(), 
              Expanded(child: buildRoomMembers()),
              if (_showLeaveOptions) _buildLeaveChatSection(),

            ]
          ),
        ],
      ),
    );
  }

  Widget _buildForMobile() {
    return Scaffold(
      backgroundColor: widget.model.mobileBackgroundColor,
      appBar: AppBar(
        title: Text('Chat Details', style: TextStyle(color: widget.model.paletteColor)),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
            slivers: [
              if (widget.room.type == types.RoomType.group && widget.isReservation) SliverToBoxAdapter(child: buildActivityPreview()),
              SliverToBoxAdapter(child: _buildRoomHeaderAndActions()),
              SliverToBoxAdapter(child: buildNotificationSwitch()),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildMemberTitle(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: buildRoomMembers(),
                  ),
                ]),
              ),
            ],
          ),
          if (_showLeaveOptions)
             Container(
                color: widget.model.webBackgroundColor,
                child: _buildLeaveChatSection(),
           ),
        ],
      ),
    );
  }

  Widget _buildMemberTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Text('Members', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text('(${widget.room.users.length})', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }


  Widget _buildRoomHeaderAndActions() {
    final isGroup = widget.room.type == types.RoomType.group;
    final isAdmin = widget.room.users.any(
      (u) => u.id == facade.FirebaseChatCore.instance.firebaseUser?.uid &&
             u.role == types.Role.admin,
    );
    final usersCount = widget.room.users.length;
 
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: widget.sideBarWidth - 15,
        child: Column(
          children: [
            /// Room avatar and name vertically stacked
            Column(
              children: [
                widget.room.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          widget.room.imageUrl!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundColor: widget.model.disabledTextColor.withOpacity(0.1),
                        child: Icon(Icons.chat, color: widget.model.paletteColor, size: 40),
                      ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.room.name ?? 'Chat',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                      color: widget.model.paletteColor,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (isGroup)
                  Text(
                    '$usersCount members',
                    style: TextStyle(color: widget.model.disabledTextColor),
                  ),
              ],
            ),
            const SizedBox(height: 16),
         
            /// Action icons row
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isAdmin && isGroup)
                  IconButton(
                    icon: Icon(CupertinoIcons.person_add, color: widget.model.paletteColor),
                    onPressed: () {
                      // TODO: Handle add user
                    },
                    tooltip: 'add user',
                  ),
                IconButton(
                  icon: Icon(CupertinoIcons.search, color: widget.model.paletteColor),
                  onPressed: () {
                    // TODO: Handle search
                  },
                  tooltip: 'search',
                ),
                IconButton(
                  icon: Icon(CupertinoIcons.exclamationmark_bubble, color: widget.model.paletteColor),
                  onPressed: () {
                    // TODO: Handle report
                  },
                  tooltip: 'report',
                ),
                // if (!isAdmin && isGroup && widget.reservationItem == null && widget.reservationItem?.reservationState == ReservationSlotState.completed) IconButton(
                //   icon: Icon(CupertinoIcons.arrow_right_circle, color: widget.model.paletteColor),
                //   onPressed: () {
                //     // TODO: Handle leave chat
                //   },
                // ),
                IconButton(
                  icon: Icon(
                    _showLeaveOptions ? CupertinoIcons.arrow_uturn_left_circle_fill : CupertinoIcons.arrow_uturn_left_circle,
                    color: Colors.red,
                  ),
                  tooltip: 'leave chat',
                  onPressed: _toggleLeaveOptions,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              color: widget.model.disabledTextColor.withOpacity(0.35),
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationSwitch() {
    final bool? notificationsSilenced = widget.room.metadata?['notificationsSilenced']?[facade.FirebaseChatCore.instance.firebaseUser?.uid];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: widget.sideBarWidth - 15,
        height: 60,
        child: ListTile(
          leading: Icon(
            CupertinoIcons.bell,
            color: (notificationsSilenced == true) ? widget.model.paletteColor : widget.model.disabledTextColor,
          ),
          title: Text(
            'Silence Notifications',
            style: TextStyle(
              color: (notificationsSilenced == true) ? widget.model.paletteColor : widget.model.disabledTextColor,
            ),
          ),
          trailing: Container(
            width: 60,
            child: FlutterSwitch(
              width: 60.0,
              value: (!kIsWeb) ? notificationSilenced ?? false :  notificationsSilenced ?? false, // Replace with your actual state
              activeColor: widget.model.paletteColor,
              inactiveColor: widget.model.disabledTextColor.withOpacity(0.3),
              onToggle: (val) {
                setState(() {
                  widget.didSelectNotificationSwitch(val);
                  notificationSilenced = val;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRoomMembers() {
    final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    final isAdmin = widget.room.users.any((u) => u.id == currentUserId && u.role == types.Role.admin);


    return Container(
            width: widget.sideBarWidth,
            child: ListView.builder(
              physics: (!kIsWeb) ? const NeverScrollableScrollPhysics() : null,
              shrinkWrap: true,
              itemCount: widget.room.users.length,
              itemBuilder: (context, index) {
               final user = widget.room.users[index];
               final types.Role? role = user.role;
               final isCurrentUser = user.id == currentUserId;
          
               return ListTile(
                onTap: () {
                  // TODO: Handle user tap
                  widget.didSelectUser(user);
                },
                leading: CircleAvatar(
                  backgroundImage: user.imageUrl != null && user.imageUrl!.isNotEmpty
                      ? NetworkImage(user.imageUrl!)
                      : null,
                  backgroundColor: widget.model.disabledTextColor.withOpacity(0.2),
                  child: user.imageUrl == null || user.imageUrl!.isEmpty
                      ? Icon(Icons.person, color: widget.model.webBackgroundColor)
                      : null,
                ),
                 title: Text('${user.firstName ?? ''}',
                   style: TextStyle(
                     color: widget.model.paletteColor,
                     fontSize: widget.model.secondaryQuestionTitleFontSize,
                   ),
                 ),
                 subtitle: (role == types.Role.admin)
                     ? Text('Admin',
                         style: TextStyle(
                           color: widget.model.disabledTextColor.withOpacity(0.8),
                         ),
                       )
                     : null,
                 trailing: (isAdmin && !isCurrentUser && !widget.isReservation) ? PopupMenuButton<String>(
                   icon: Icon(Icons.more_vert, color: widget.model.disabledTextColor),
                   color: widget.model.accentColor,
                   elevation: 0,
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                   ),
                   onSelected: (value) {
                   },
                   itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'profile',
                        child: Text('View Profile', style: TextStyle(color: widget.model.paletteColor)),
                        onTap: () {
                          // TODO: Handle view profile
                          didSelectProfile(context, user.id, '${user.firstName} ${user.lastName}', ProfileTypeMarker.generalProfile, widget.model);
                        }
                      ),
                      PopupMenuItem(
                       value: 'remove',
                       child: Text('Remove user', style: TextStyle(color: Colors.red)),
                       onTap: () {
                         // TODO: Handle remove user
                       }
                     ),
                      PopupMenuItem(
                       value: 'block',
                       child: Text('Block user', style: TextStyle(color: Colors.red)),
                       onTap: () {
                         // TODO: Handle block user
                       }
                     ),
                   ],
                 ) : null,
               );
              },
            ),
          
      
    );
  }

  Widget buildActivityPreview() {
    return Column(
      children: [
        Divider(
          color: widget.model.disabledTextColor.withOpacity(0.35),
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildLeaveChatSection() {
    final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    final isAdmin = widget.room.users.any((u) => u.id == currentUserId && u.role == types.Role.admin);
    final isGroup = widget.room.type == types.RoomType.group;
    final isDirect = widget.room.type == types.RoomType.direct;
    final isChannel = widget.room.type == types.RoomType.channel;
  
    String buttonText = '';
    String descriptionText = '';
    VoidCallback? onTap;

    if (isDirect) {
      buttonText = 'Delete Conversation';
      descriptionText = 'You will no longer see this chat. This does not delete it for the other user.';
      onTap = () {
        // TODO: Handle remove direct chat
      };
    } else if (isGroup) {
        if (isAdmin && !widget.isReservation) {
          buttonText = 'Delete group chat for everyone';
          descriptionText = 'This will permanently delete the chat and remove all members.';
          onTap = () {
            // TODO: Handle admin delete group chat
          };
        }
        if (isAdmin && widget.isReservation) {
          buttonText = 'Delete Activity Chat for everyone';
          descriptionText = 'This will permanently delete the chat and remove all members.';
          onTap = () {
            // TODO: Handle admin delete group chat
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: widget.model.webBackgroundColor,
                      content: Text('You can only delete an activity chat after the activity has finished or by cancelling the activity.', style: TextStyle(color: Colors.red)),
                      behavior: SnackBarBehavior.floating,
                      width: 400,
                      elevation: 16,
                      clipBehavior: Clip.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  );
              
          };
        }
        if (!isAdmin && widget.isReservation) {
          buttonText = 'Leave Activity Chat';
          descriptionText = 'You will leave the chat and lose access to this chat.';
          onTap = () {
            // TODO: Handle user leave group chat
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: widget.model.webBackgroundColor,
                content: Text('You can only leave the chat by removing yourself as an Attendee', style: TextStyle(color: Colors.red)),
                behavior: SnackBarBehavior.floating,
                width: 400,
                elevation: 16,
                clipBehavior: Clip.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            );
          };
        }
        if (!widget.isReservation && !isAdmin) {
          buttonText = 'Leave Group Chat';
          descriptionText = 'You will leave the chat and lose access to this chat.';
          onTap = () {
            // TODO: Handle admin delete group chat
          };
        }
    } else if (isChannel) {
      if (isAdmin) {
        buttonText = 'Delete channel';
        descriptionText = 'This will permanently delete the channel for all members.';
        onTap = () {
          // TODO: Handle delete channel
        };
      } else {
        buttonText = 'Unsubscribe from channel';
        descriptionText = 'You will stop receiving messages from this channel.';
        onTap = () {
          // TODO: Handle unsubscribe
        };
      }
    }

    if (buttonText.isEmpty || onTap == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        width: widget.sideBarWidth - 35,
        height: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              descriptionText,
              style: TextStyle(color: Colors.red.withOpacity(0.8), fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 50,
              child: HoverButton(
                onpressed: onTap,
                animationDuration: Duration.zero,
                color: Colors.red,
                hoverColor: Colors.red.shade200.withOpacity(0.25),
                elevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(buttonText, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}