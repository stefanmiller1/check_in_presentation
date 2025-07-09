// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:flutter/foundation.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:flutter/material.dart';

// import 'send_new_chat_container.dart';

part of check_in_presentation;

String getUrlForRoom(String roomId) => (kIsWeb) ? Uri.base.origin + chatWithIdRoute(roomId) : 'https://cincout.ca/${chatWithIdRoute(roomId)}';


class SendNewChatMessage {
  final String hintText;
  final List<String> sampleQuestions;
  final List<String>? possibleAnswers;
  final NewMessageTypes messageType;
  final String messageFrom;
  final types.SystemMessage? systemMessage;

  const SendNewChatMessage({
    required this.hintText,
    required this.sampleQuestions,
    this.possibleAnswers,
    required this.messageType,
    required this.messageFrom,
    this.systemMessage,
  });
}

BorderRadius getBorderRadiusForIndex(int idx, int length) {
    if (length == 1) {
      // Single bubble, all corners rounded
      return BorderRadius.circular(20);
    } else if (length == 2) {
      if (idx == 0) {
        // First of two
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(0),
        );
      } else {
        // Last of two
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        );
      }
    } else {
      // Three or more
      if (idx == 0) {
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(0),
        );
      } else if (idx == length - 1) {
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        );
      } else {
        // Middle bubbles
        return const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(0),
        );
      }
    }
  }

String getVendorTypesName(List<MerchantVendorTypes> vendorTypes) {
  return vendorTypes.map((e) => getMerchantVendorTypeDescribed(e)).join(', ');
}

List<SendNewChatMessage> getPresetMessages({ReservationItem? reservation, EventMerchantVendorProfile? eventMerchantVendorProfile, required String currentUserName}) {
  return [
    SendNewChatMessage(
      hintText: 'Say hello or ask a question...',
      sampleQuestions: [
        'Hey there! Got a second?',
        'Can I ask you something?',
        'Hope you’re doing well!'
      ],
      messageType: NewMessageTypes.direct,
      messageFrom: 'user',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName wants to start a direct conversation.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Ask the host about the reservation...',
      sampleQuestions: [
        'When does the event start?',
        'Are there any rules I should know?',
        'Where will the event be?'
      ],
      possibleAnswers: reservation != null ? [
        '',
        'You’ll get a list of rules closer to the event date.',
        'Setup is typically 1 hour before start.'
      ] : null,
      messageType: NewMessageTypes.userInquireReservationHost,
      messageFrom: 'user',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName is inquiring about your activity.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Ask a vendor about what they plan to sell....',
      sampleQuestions: [
        'What will you be selling?',
        'Do you have any more of a specific product left?',
        'What time will you arrive?'
      ],
      possibleAnswers: (eventMerchantVendorProfile?.type ?? []).isNotEmpty ? [
        'We specialize in ${getVendorTypesName(eventMerchantVendorProfile?.type ?? [])}.',
        'Expect us to bring products related to our category.',
        'We plan to arrive early for setup.'
      ] : null,
      messageType: NewMessageTypes.userInquireVendorAttendee,
      messageFrom: 'user',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName is asking about your vendor products.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Ask the vendor if they’re available...',
      sampleQuestions: [
        'Are you available for our upcoming event?',
        'Would you be interested in a vendor spot?',
        'Can you share samples of your merchandise?'
      ],
      possibleAnswers: eventMerchantVendorProfile?.isLookingForWork != null
          ? [
              (eventMerchantVendorProfile?.isLookingForWork == true)
                  ? 'Yes, we are currently looking for new events.'
                  : 'We are currently not seeking new vendor opportunities.',
              'Feel free to share more details about your event.',
              'We can send over examples of our setup.'
            ]
          : null,
      messageType: NewMessageTypes.hostInquireVendor,
      messageFrom: 'host',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName is checking your availability for their event.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Check in with a vendor attendee...',
      sampleQuestions: [
        'Will you be attending with your vendor?',
        'Do you need any special access?',
        'Do you have dietary restrictions?'
      ],
      messageType: NewMessageTypes.hostInquireVendorAttendee,
      messageFrom: 'host',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName is checking in about your attendance.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Start a partnership conversation...',
      sampleQuestions: [
        'Would you be interested in co-hosting an event?',
        'Do you collaborate with other organizers?',
        'Could we chat about partnering this summer?'
      ],
      messageType: NewMessageTypes.hostInquirePartnership,
      messageFrom: 'host',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName wants to start a partnership with you for their event.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Ask another vendor about collaborating or carpooling...',
      sampleQuestions: [
        'Want to share a booth?',
        'Interested in teaming up for setup?',
        'Are you bringing signage?'
      ],
      messageType: NewMessageTypes.vendorInquireVendorAttendee,
      messageFrom: 'vendor',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName wants to discuss vending.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Ask the host about a vendor opportunity...',
      sampleQuestions: [
        'Is this event still looking for vendors?',
        'Where can I find more info?',
        'Will overnight storage be available?'
      ],
      messageType: NewMessageTypes.vendorInquireReservationHost,
      messageFrom: 'vendor',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName has questions about vending opportunities.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
    SendNewChatMessage(
      hintText: 'Ask the host about anything event related...',
      sampleQuestions: [
        'Where can I park?',
        'What time will setup start?',
        'Where can I find outlets or extension cables?'
      ],
      messageType: NewMessageTypes.vendorAttendeeInquireReservationHost,
      messageFrom: 'vendor-attendee',
      systemMessage: types.SystemMessage(
        author: User(id: 'system'),
        text: '$currentUserName has event-related questions.',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: UniqueId().getOrCrash(),
      ),
    ),
  ];
}

void showNewMessagePopOver(BuildContext context, UserProfileModel userProfile, ReservationItem? reservationItem, EventMerchantVendorProfile? eventMerchantVendorProfile, NewMessageTypes type, DashboardModel model) {
  if (kIsWeb && (Responsive.isMobile(context) == false)) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'New Message',
        barrierColor: model.disabledTextColor.withOpacity(0.34),
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return  Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: model.webBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 550,
                    height: 800,
                    child: SendNewChatContainer(
                        userProfile: userProfile,
                        messageType: type,
                        reservation: reservationItem,
                        eventMerchantVendorProfile: eventMerchantVendorProfile,
                        showHeader: true,
                        model: model,
                )
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
              opacity: anim1.value,
              child: child
            )
          );
        },
      );
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
        return SendNewChatContainer(
            userProfile: userProfile,
            messageType: type,
            reservation: reservationItem,
            eventMerchantVendorProfile: eventMerchantVendorProfile,
            showHeader: true,
            model: model,
          );
      }));
  }
}


void didSelectOpRoom(BuildContext context, DashboardModel model, UserProfileModel currentUser, String roomId) async {
  if (kIsWeb) {
    final newUrl = getUrlForRoom(roomId);
    final canLaunch = await canLaunchUrlString(newUrl);

    if (canLaunch) {
      await launchUrlString(newUrl);
    }
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return DirectChatScreen(
              roomId: roomId,
              model: model,
              currentUser: currentUser,
              showOptions: null,
              reservationItem: null,
              isFromReservation: false
          );
        }
      )
    );
  }
}


void showCreateNewChatPopOver(BuildContext context, DashboardModel model) {
  if (kIsWeb && (Responsive.isMobile(context) == false)) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'New Message',
      barrierColor: model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: Container(
              decoration: BoxDecoration(
                color: model.webBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(17.5))
              ),
              width: 550,
              height: 800,
              child: CreateNewChatContainer(
                  model: model,
              )
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child
          )
        );
      },
    );
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
        return CreateNewChatContainer(
            model: model
        );
      }));
  }
}