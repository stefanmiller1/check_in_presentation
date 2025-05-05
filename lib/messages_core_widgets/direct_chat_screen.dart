part of check_in_presentation;

class DirectChatScreen extends StatefulWidget {

  final String? roomId;
  final DashboardModel model;
  final bool? showOptions;
  final UserProfileModel currentUser;
  final ReservationItem? reservationItem;
  final bool isFromReservation;

  const DirectChatScreen({Key? key,
    required this.roomId,
    required this.model,
    required this.showOptions,
    required this.currentUser,
    required this.reservationItem,
    required this.isFromReservation}) : super(key: key);


  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {

  bool _isAttachmentUploading = false;

  final ImagePicker _imagePicker = ImagePicker();

  /// selected photos for post.
  late List<XFile> _selectedFileSpaceImage = [];

  /// see [isImageVideoAttachmentUploading]
  late bool isImageVideoAttachmentUploading = false;

  /// see [isCameraImageAttachmentUploading]
  late bool isCameraImageAttachmentUploading = false;

  /// see [isAudioAttachmentUploading]
  late bool isAudioAttachmentUploading = false;

  /// messages
  List<types.Message> systemMessages = [];
  List<types.Message> messages = [];
  List<User> usersInRoom = [];
  Map<String, String> userIdToNameMap = {};

  types.Message? _repliedMessage = null;
  bool? showDetails = false;
  late double sideBarWidth = 350;

  @override
  void initState() {
    systemMessages.clear();
    messages.clear();
    _repliedMessage = null;
    userIdToNameMap = {};
    super.initState();
  }

  @override
  void dispose() {
    systemMessages.clear();
    messages.clear();
    _repliedMessage = null;
    userIdToNameMap = {};
    usersInRoom.clear();
    showDetails = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      if (RoomsHelperCore.isLoading == true) {
        systemMessages.clear();
        messages.clear();
        _repliedMessage = null;
        userIdToNameMap = {};
        usersInRoom.clear();
        showDetails = false;
        return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: (widget.roomId != null) ? BlocProvider(create: (_) => getIt<NotificationWatcherBloc>()..add(NotificationWatcherEvent.watchAllAccountNotificationAmountByType([AccountNotificationType.message], UniqueId.fromUniqueString(widget.roomId!))),
              child: BlocBuilder<NotificationWatcherBloc, NotificationWatcherState>(
                  builder: (context, authState) {
                    return authState.maybeMap(
                        loadAllAccountNotificationByTypeSuccess: (item) {
                          return mainContainer(item.notifications, widget.roomId!);
                        },
                        orElse: () {
                          return mainContainer([], widget.roomId!);
                  }
                );
              }
            )
          ) : noItemsFound(
              widget.model,
              Icons.chat_outlined,
              'No Chats Yet!',
              '',
              'Go Back',
              didTapStartButton: () {
              setState(() {
                Navigator.of(context).pop();
                });
            }
          ),
        )
      );
  }


  Widget mainContainer(List<AccountNotificationItem> notifications, String roomId) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(roomId)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                  loadReservationItemFailure: (_) => retrieveMainChatContainer(
                    null,
                    roomId,
                    notifications
                  ),
                  loadReservationItemSuccess: (items) {
                    /// add system message
                    if (systemMessages.length != retrieveSystemMessages(items.item).length) {
                      systemMessages.addAll(retrieveSystemMessages(items.item));
                    }
                    return retrieveMainChatContainer(
                        items.item,
                        roomId,
                        notifications
                    );
                  },
                  orElse: () => retrieveMainChatContainer(
                      null,
                      roomId,
                      notifications
                  )
              );
            }
        )
    );
  }


  Widget retrieveMainChatContainer(ReservationItem? reservation, String selectedRoomId, List<AccountNotificationItem> notifications) {
    return StreamBuilder<types.Room>(
        stream: facade.FirebaseChatCore.instance.room(selectedRoomId),
        builder: (context, roomSnapshot) {
        final selectedRoom = roomSnapshot.data;

        if (selectedRoom == null) {
          return const SizedBox.shrink();
        }

        // if (userIdToNameMap.isEmpty) {
          // facade.FirebaseChatCore.instance.getUsersInRoom(selectedRoom.id).then((users) {
            // setState(() {
              // usersInRoom = users.where((e) => e.id != facade.FirebaseChatCore.instance.firebaseUser?.uid).toList();
              userIdToNameMap = {
                for (final u in selectedRoom.users)
                  u.id: '${u.firstName ?? ''} ${u.lastName ?? ''}'.trim()
              };
            // });
          // });
        // }

     return StreamBuilder<List<types.Message>>(
            stream: facade.FirebaseChatCore.instance.messages(selectedRoom),
            builder: (context, snapshot) {

              if (areAllMessagesContained(snapshot.data, messages) == false) {
               for (types.Message newMsg in snapshot.data ?? []) {

                  final existingIndex = messages.indexWhere((msg) => msg.id == newMsg.id);
                  if (!(messages.map((e) => e.id).contains(newMsg.id))) {
                    messages.add(newMsg);
                  } else { 
                    messages[existingIndex] = newMsg;
                  }
                } 
              }

              // for (types.Message systemM in systemMessages) {
              //     if (!(messages.map((e) => e.id).contains(systemM.id))) {
              //       messages.add(systemM);
              //   }
              // }

              messages = messages..sort((a,b) => (b.createdAt ?? DateTime.now().microsecondsSinceEpoch ~/ 1000).compareTo(a.createdAt ?? DateTime.now().microsecondsSinceEpoch ~/ 1000));
              final lastMessage = messages.isNotEmpty ? messages.first : null;

              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Row(
                        children: [
                          Expanded(
                            child: getMainChatContainer(
                              snapshot, 
                              selectedRoom, 
                              lastMessage, 
                              notifications
                            ),
                          ),
                          if ((showDetails ?? false) && Responsive.isDesktop(context))  SizedBox(width: sideBarWidth),
                        ],
                      ),
                    ),
                  ),

                  if (kIsWeb) Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ChatHeaderWidget(
                          room: roomSnapshot.data!,
                          showDetails: showDetails ?? false,
                          model: widget.model,
                          onShowDetails: () {
                              setState(() {
                                showDetails = !(showDetails ?? false);
                              });
                            }
                          ),
                        ),
                      ),
                      if ((showDetails ?? false) && Responsive.isDesktop(context)) SizedBox(width: sideBarWidth),
                    ],
                  ),

                  if (roomSnapshot.data != null) Positioned(
                    right: 0,
                    child: Visibility(
                      visible: (showDetails ?? false) && Responsive.isDesktop(context),
                      child: Container(
                        color: widget.model.webBackgroundColor,
                        width: sideBarWidth,
                        height: MediaQuery.of(context).size.height,
                        child: ChatDetailsSideBar(
                          model: widget.model,
                          sideBarWidth: sideBarWidth,
                          room: roomSnapshot.data!,
                          didSelectUser: (user) {
                            didSelectProfile(context, user.id, '${user.firstName} ${user.lastName}', ProfileTypeMarker.generalProfile, widget.model);
                          },
                          didSelectNotificationSwitch: (toggle) {
                            setState(() {
                              _handleSilenceNotifications(roomSnapshot.data!, toggle);
                            });
                          },
                          isReservation: roomSnapshot.data!.metadata?['reservationId'] != null,
                        )
                    ),
                  ),
                ),

                if (!kIsWeb) Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                    child: AppBar(
                      elevation: 0,
                      iconTheme: IconThemeData(
                        color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor,
                      ),
                      backgroundColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.paletteColor : widget.model.mobileBackgroundColor,
                      title: Text(selectedRoom.name ?? 'chat', style: TextStyle(color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor)),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.info_outline, color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor),
                          onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) {
                                    return ChatDetailsSideBar(
                                        model: widget.model,
                                        sideBarWidth: MediaQuery.of(context).size.width,
                                        room: roomSnapshot.data!,
                                        didSelectUser: (user) {
                                          didSelectProfile(context, user.id, '${user.firstName} ${user.lastName}', ProfileTypeMarker.generalProfile, widget.model);
                                        },
                                        didSelectNotificationSwitch: (toggle) {
                                          setState(() {
                                            _handleSilenceNotifications(roomSnapshot.data!, toggle);
                                          });
                                        },
                                        isReservation: roomSnapshot.data!.metadata?['reservationId'] != null,
                                    );
                                  }
                                )
                              );
                          },
                        ),
                      ],
                    centerTitle: true,
                  )
                ),

                //   if (reservation != null && widget.currentUser != null) Positioned(
                //     top: 0,
                //     child: getReservationCardListing(
                //       context,
                //       true,
                //       reservation,
                //       widget.currentUser!,
                //       widget.model,
                //       false,
                //       false,
                //       [],
                //       didSelectResDetail: (model, listing, reservation, isResOwner, isFromChat, currentUser) {
                //         Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                //           return ReservationDetailsWidget(
                //               model: model,
                //               listing: listing,
                //               reservationItem: reservation,
                //               isReservationOwner: false,
                //               allAttendees: [],
                //               isFromChat: true,
                //               currentUser: currentUser,
                //             );
                //           })
                //         );
                //       },
                //       didSelectReservation: (listing, res, activity, attendeeItem, activityTickets) {
                //         if (widget.isFromReservation) {
                //           return Navigator.of(context).pop();
                //         } else {
                //           Navigator.push(context, MaterialPageRoute(
                //               builder: (_) {
                //                 return ReservationResultMain(
                //                   model: widget.model,
                //                   isReply: false,
                //                   listing: listing,
                //                   currentUser: widget.currentUser,
                //                   reservationId: reservation.reservationId.getOrCrash(),
                //               );
                //             }
                //           )
                //         );
                //       }
                //     }
                //   )
                // ),
              ],
            );
          },
        );
      }
    );
  }

  Widget getMainChatContainer(AsyncSnapshot<List<types.Message>> snapshot, types.Room selectedRoom, types.Message? lastMessage, List<AccountNotificationItem> notifications) {
    return Chat(
      timeFormat: DateFormat.jm(),
      theme: DefaultChatTheme(
        backgroundColor: widget.model.webBackgroundColor,
        inputBackgroundColor: widget.model.accentColor,
        inputTextCursorColor: widget.model.paletteColor,
        inputTextColor: widget.model.paletteColor,
        userAvatarNameColors: [widget.model.paletteColor],
        primaryColor: widget.model.paletteColor,
        secondaryColor: widget.model.accentColor,
        receivedMessageBodyTextStyle: TextStyle(
          color: widget.model.paletteColor, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5
        ),
        sentMessageBodyTextStyle: TextStyle(
          color: widget.model.accentColor, fontSize: 16, fontWeight: FontWeight.w500, height: 1.5
        ),
        messageInsetsHorizontal: 16,
        messageInsetsVertical: 11,
      ),
      showUserAvatars: true,
      showUserNames: selectedRoom.type == types.RoomType.group || selectedRoom.type == types.RoomType.channel,
      customBottomWidget: retrieveInputController(selectedRoom),
      scrollToUnreadOptions: ScrollToUnreadOptions(
          lastReadMessageId: (snapshot.data?.isNotEmpty ?? false) ? snapshot.data?.first.id ?? '' : '',
          scrollOnOpen: true
      ),
      // systemMessageBuilder: (sysMessage) {
      //   return retrieveSystemMessageBuilder(sysMessage, context, widget.model);
      // },
      customStatusBuilder: (message, {required context}) {
        return getMessageStatus(widget.model, message, lastMessage, userIdToNameMap);
      },
      onMessageVisibilityChanged: (message, visible) {
        final userId = widget.currentUser.userId.getOrCrash();
    
        final userStatusMap = (message.metadata?['userStatus'] as Map?)?.cast<String, String>() ?? {};
        if (message.type != types.MessageType.system && userStatusMap[userId] != types.Status.seen.name) {
          _updateMessageStatusOnVisibilityChange(message, selectedRoom);
        }
        /// update room notification
        facade.LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
        e.reservationId == selectedRoom.id).map((e) => e.notificationId).toList(),
            widget.model.paletteColor,
            widget.model.accentColor
        );
      },
      onMessageDoubleTap: (context, message) {
        final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    
        if (currentUserId != null && message.metadata?['reactions']?.containsKey(currentUserId) == true) {
          _handleRemoveReaction(selectedRoom, message);
        } else {
          _handleSendReaction(selectedRoom, message, '❤️');
        }
      },
      onMessageReactionTap: (context, message, reaction) {
        _handleSendReaction(selectedRoom, message, reaction);
      },
      onMessageCopyTap: (contexts, message) async {
        if (message is types.TextMessage) {
          await Clipboard.setData(ClipboardData(text: message.text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: widget.model.webBackgroundColor,
              content: Text('Message copied to clipboard', style: TextStyle(color: widget.model.paletteColor)),
              behavior: SnackBarBehavior.floating,
              width: 400,
              elevation: 16,
              clipBehavior: Clip.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              // margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          );
        }
      },
      onMessageReplyTap: (context, message) {
          final author = selectedRoom.users.firstWhere(
            (u) => u.id == message.author.id,
            orElse: () => message.author,
          );

        setState(() {
          _repliedMessage = message.copyWith(
            author: author
          );
          
        });
      },
      onMessageUnsendTap: (context, message) {
        
      },
      onMessageReportTap: (context, message) {
        _handleReportMessage(selectedRoom, message);
      },
      onMessageTap: (context, message) {
        
      },
      onMessageReactionRemoveTap: (context, message) {
        _handleRemoveReaction(selectedRoom, message);
      },
      onCurrentMessageReactionsTap: (context, message) {
        setState(() {
          
        });
      },
      isAttachmentUploading: _isAttachmentUploading,
      messages: messages.toSet().toList(),
      onAvatarTap: (user) {
        didSelectProfile(context, user.id, '${user.firstName} ${user.lastName}', ProfileTypeMarker.generalProfile, widget.model);
      },
      onSendPressed: (partialText) {
        _handleSendPressed(partialText, _repliedMessage, selectedRoom);
        _repliedMessage = null;
      },
      user: types.User(
        id: facade.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
      ),
    );
  }

  void _updateMessageStatusOnVisibilityChange(types.Message message, types.Room currentRoom) {
    if (message.author.id != facade.FirebaseChatCore.instance.firebaseUser?.uid) {
      // final updatedMessage = message.copyWith(status: types.Status.seen);
      final currentUserId = facade.FirebaseChatCore.instance.firebaseUser!.uid;
      final updatedUserStatus = Map<String, String>.from(message.metadata?['userStatus'] ?? {});

      updatedUserStatus[currentUserId] = types.Status.seen.name; // Mark only this user as 'seen'
      final updatedMessage = message.copyWith(metadata: {
            ...message.metadata ?? {},
            'userStatus': updatedUserStatus,
          });

      facade.FirebaseChatCore.instance.updateMessage(
        updatedMessage,
        currentRoom.id,
      );
    }
  }

  void _handleSendPressed(types.PartialText message, types.Message? reply, types.Room currentRoom) {
    final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    if (currentUserId == null) return;

    facade.FirebaseChatCore.instance.sendMessage(
      message,
      reply,
      currentRoom.id,
    );

    final Map<String, dynamic> silencedMap = currentRoom.metadata?['notificationsSilenced'] ?? {};
    final Map<String, dynamic> metadata = {
      'reservationId': currentRoom.metadata?['reservationId'],
      'status': 'done',
      'link': chatWithIdRoute(currentRoom.id)
    };

    facade.FirebaseChatCore.instance.sendDirectNotifications(
        currentRoom.users.map((e) => e.id).where((id) => silencedMap[id] != true).toList(),
        widget.currentUser.legalName.getOrCrash(),
        message,
        chatWithIdRoute(currentRoom.id),
        metadata
      );
    }

    void _handleSendReaction(types.Room room, types.Message message, String emoji) async {
    final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    if (currentUserId == null) return;
  
    final currentReactions = (message.metadata?['reactions'] as Map?)?.cast<String, String>() ?? {};
    currentReactions[currentUserId] = emoji;
  
    final updatedMetadata = Map<String, dynamic>.from(message.metadata ?? {});
    updatedMetadata['reactions'] = currentReactions;
  
    await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .doc(message.id)
        .update({'metadata': updatedMetadata});
  }

  void _handleRemoveReaction(types.Room room, types.Message message) async {
      final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
      if (currentUserId == null) return;

      final currentReactions = (message.metadata?['reactions'] as Map?)?.cast<String, String>() ?? {};

      if (!currentReactions.containsKey(currentUserId)) return;

      currentReactions.remove(currentUserId);

      final updatedMetadata = Map<String, dynamic>.from(message.metadata ?? {});
      updatedMetadata['reactions'] = currentReactions;

      await FirebaseFirestore.instance
          .collection('rooms/${room.id}/messages')
          .doc(message.id)
          .update({'metadata': updatedMetadata});
    }
  
  void _handleReportMessage(types.Room room, types.Message message) async {
    final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    if (currentUserId == null) return;
  
    final reportedMap = (message.metadata?['reported'] as Map?)?.cast<String, String>() ?? {};
  
    // If already reported by this user, do nothing
    if (reportedMap.containsKey(currentUserId)) {
      reportedMap.remove(currentUserId);
    } else {
      reportedMap[currentUserId] = DateTime.now().toIso8601String();
    }
  
    
    final updatedMetadata = Map<String, dynamic>.from(message.metadata ?? {});
    updatedMetadata['reported'] = reportedMap;
  
    await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .doc(message.id)
        .update({'metadata': updatedMetadata});
  }

    void _handleSilenceNotifications(types.Room room, bool shouldSilence) async {

       final currentUserId = facade.FirebaseChatCore.instance.firebaseUser?.uid;
      if (currentUserId == null) return;

        await FirebaseFirestore.instance.collection('rooms').doc(room.id).update({
          'metadata.notificationsSilenced.$currentUserId': shouldSilence,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: widget.model.webBackgroundColor,
            content: Text(
              shouldSilence ? 'Notifications silenced' : 'Notifications enabled',
              style: TextStyle(color: widget.model.paletteColor),
            ),
            behavior: SnackBarBehavior.floating,
            width: 400,
            elevation: 16,
            clipBehavior: Clip.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        );
    
  }

    

  Widget retrieveInputController(types.Room currentRoom) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        children: [
            if (_repliedMessage != null) Divider(color: widget.model.disabledTextColor.withOpacity(0.4)),
            if (_repliedMessage != null) Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _repliedMessage!.author.id == facade.FirebaseChatCore.instance.firebaseUser?.uid
                              ? 'Replying to yourself'
                              : 'Replying to ${userIdToNameMap[_repliedMessage!.author.id] ?? _repliedMessage!.author.firstName ?? 'someone'}',
                          style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _repliedMessage is types.TextMessage
                              ? (_repliedMessage as types.TextMessage).text
                              : 'Media message',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: widget.model.disabledTextColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: widget.model.disabledTextColor),
                    onPressed: () {
                      setState(() {
                        _repliedMessage = null;
                      });
                    },
                  )
                ],
              ),
            ),
          post.Input(
            isAudioAttachmentUploading: isAudioAttachmentUploading,
            isCameraImageAttachmentUploading: isCameraImageAttachmentUploading,
            isImageVideoAttachmentUploading: isImageVideoAttachmentUploading,
            onSubmitPressed: (postText) async {
              _handleSendPressed(
                types.PartialText(
                    text: postText.text,
                ),
                _repliedMessage,
                currentRoom
              );
              _repliedMessage = null;
            },
            onAttachmentPressed: (type) async {
          
            },
            isSubmitting: false,
            model: widget.model
          ),
        ],
      ),
    );
  }

  List<types.SystemMessage> retrieveSystemMessages(ReservationItem reservation) {
    List<types.SystemMessage> systemMessage = [];

    if (facade.FirebaseChatCore.instance.firebaseUser?.uid == reservation.reservationOwnerId.getOrCrash()) {
      for (ReservationSlotItem resSlot in reservation.reservationSlotItem) {
        for (ReservationTimeFeeSlotItem slot in resSlot.selectedSlots) {
          if (slot.slotRange.start.isBefore(DateTime.now())) {
            systemMessage.add(types.SystemMessage(
                id: UniqueId().getOrCrash(),
                createdAt: slot.slotRange.start.microsecondsSinceEpoch ~/ 1000,
                text: 'The ${DateFormat.jm().format(slot.slotRange
                    .start)} Reservation is about to begin, if you have any issues you can contact the owner here.'
              ));
            }
          }
        }
      }
    return systemMessage;
  }
}