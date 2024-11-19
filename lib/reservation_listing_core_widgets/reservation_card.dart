part of check_in_presentation;

Widget noItemsFound(DashboardModel model, IconData icon, String mainTitle, String subTitle, String buttonTitle,  {required Function() didTapStartButton}) {
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: model.accentColor
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 18),
          Icon(icon, color: model.paletteColor),
          const SizedBox(height: 18),
          Text(mainTitle, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subTitle, style: TextStyle(color: model.disabledTextColor)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              didTapStartButton();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: model.paletteColor
                ),
                child: Center(
                  child: Text(buttonTitle, style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget LoadingReservationCard(BuildContext context) {
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          Container(
              height: 80,
              width: 80,
          ),
          Expanded(
            child: Container(
              height: 80,
              width: MediaQuery.of(context).size.width - 100,
            ),
          )
        ],
      ),
    ),
  );
}




Widget getReservationCardListing(BuildContext context, bool isMessenger, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, bool endedReservation, bool isSelected, List<AccountNotificationItem> notifications, {required Function(DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem, bool isReservationOwner, bool isFromChat, UserProfileModel currentUser) didSelectResDetail, required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendee, List<TicketItem> activityTickets) didSelectReservation}) {
  return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservationItem.instanceId.getOrCrash())),
    child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadListingManagerItemFailure: (_) => LoadingReservationCard(context),
          loadListingManagerItemSuccess: (item) {
            return getReservationCardAttendance(context, isMessenger, item.failure, reservationItem, currentUser, model, endedReservation, isSelected, notifications, didSelectResDetail: didSelectResDetail, didSelectReservation: (listing, reservation, activity, attendee, activityTickets) => didSelectReservation(listing, reservation, activity, attendee, activityTickets));
          },
          orElse: () => LoadingReservationCard(context),
        );
      },
    ),
  );
}


/// check current users [UserProfileModel]'s [AttendeeItem] for [ReservationItem]
Widget getReservationCardAttendance(BuildContext context, bool isMessenger, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel currentUser, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem, bool isReservationOwner, bool isFromChat, UserProfileModel currentUser) didSelectResDetail, required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendance, List<TicketItem> currentAttTickets) didSelectReservation}) {
  if (reservationItem.reservationOwnerId == currentUser.userId) {
    final ownerAttendee = AttendeeItem(attendeeId: UniqueId(), attendeeOwnerId: currentUser.userId, contactStatus: ContactStatus.joined, reservationId: reservationItem.reservationId, cost: '', paymentStatus: PaymentStatusType.noStatus, attendeeType: AttendeeType.free, paymentIntentId: '', dateCreated: DateTime.now(), );
    return getReservationCardActivity(context, isMessenger, listing, reservationItem, currentUser, ownerAttendee,  model, isEnded, isSelected, notifications, didSelectResDetail: didSelectResDetail, didSelectReservation: didSelectReservation);
  } else {
  return BlocProvider(create: (_) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(reservationItem.reservationId.getOrCrash(), currentUser.userId.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadAttendeeItemSuccess: (item) => getReservationCardActivity(context, isMessenger, listing, reservationItem, currentUser, item.item,  model, isEnded, isSelected, notifications, didSelectResDetail: didSelectResDetail, didSelectReservation: didSelectReservation),
            orElse: () => getReservationCardActivity(context, isMessenger, listing, reservationItem, currentUser, AttendeeItem.empty(),  model, isEnded, isSelected, notifications, didSelectResDetail: didSelectResDetail, didSelectReservation: didSelectReservation),
          );
        },
      ),
    );
  }
}


Widget getReservationCardActivity(BuildContext context, bool isMessenger, ListingManagerForm listing, ReservationItem reservationItem, UserProfileModel currentUser, AttendeeItem? attendance, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem, bool isReservationOwner, bool isFromChat, UserProfileModel currentUser) didSelectResDetail, required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendance, List<TicketItem> currentAttTickets) didSelectReservation}) {
  return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservationItem.reservationId.getOrCrash())),
    child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadActivityManagerFormSuccess: (item) {
              return getReservationCardActivityTickets(context, isMessenger, listing, item.item, reservationItem, attendance, currentUser, model, isEnded, isSelected, notifications, didSelectResDetail: didSelectResDetail, didSelectReservation: didSelectReservation);
            },
            orElse: () {
              return getReservationCardActivityTickets(context, isMessenger, listing, ActivityManagerForm.empty(), reservationItem, attendance, currentUser, model, isEnded, isSelected, notifications, didSelectResDetail: didSelectResDetail, didSelectReservation: didSelectReservation);
            }
        );
      },
    ),
  );
}





/// an optional watcher in the case that an activity is ticket based
Widget getReservationCardActivityTickets(BuildContext context, bool isMessenger, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, AttendeeItem? attendeeItem, UserProfileModel currentUser, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem, bool isReservationOwner, bool isFromChat, UserProfileModel currentUser) didSelectResDetail, required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendeeItem, List<TicketItem> tickets) didSelectReservation}) {
  return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchCurrentUserTicketsStarted(currentUser.userId.getOrCrash(), reservationItem.reservationId.getOrCrash())),
    child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
      builder: (context, state) {
          return state.maybeWhen(
            loadCurrentUsersTicketsSuccess: (item) {
              if (isMessenger) {
                return getMessengerReservationHeader(context, listing, activity, reservationItem, attendeeItem, currentUser, model, didSelectResDetail: didSelectResDetail, didSelectReservation: (listing, reservation, activity, attendeeItem) => didSelectReservation(listing, reservation, activity, attendeeItem, item));
              }
              return getReservationCardItem(context, listing, activity, reservationItem, attendeeItem, item, model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
            },
            orElse: () {
              if (isMessenger) {
                return getMessengerReservationHeader(context, listing, activity, reservationItem, attendeeItem, currentUser, model, didSelectResDetail: didSelectResDetail, didSelectReservation: (listing, reservation, activity, attendeeItem) => didSelectReservation(listing, reservation, activity, attendeeItem, []));
              }
              return getReservationCardItem(context, listing, activity, reservationItem, attendeeItem, [], model, isEnded, isSelected, notifications, didSelectReservation: didSelectReservation);
            }
          );
      }
    )
  );
}


Widget getMessengerReservationHeader(BuildContext context, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, AttendeeItem? attendeeItem, UserProfileModel currentUser, DashboardModel model, {required Function(DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem, bool isReservationOwner, bool isFromChat, UserProfileModel currentUser) didSelectResDetail, required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendeeItem) didSelectReservation}) {
  late List<ReservationTimeFeeSlotItem> allSlots = [];

  for (ReservationSlotItem slots in reservationItem.reservationSlotItem) {
    for (ReservationTimeFeeSlotItem slot in slots.selectedSlots) {
      allSlots.add(slot);
    }
  }
  allSlots.sort((a,b) => a.slotRange.start.compareTo(b.slotRange.start));

  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    color: model.accentColor,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) Container(
            height: 55,
            width: 55,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                imageUrl: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhereOrNull((element) => element.photoUri != null)?.photoUri ?? '',
                imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                errorWidget: (context, url, error) => getActivityTypeTabOption(
                    context, model,
                    55,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                ),
              ),
            ),
          ),
          if (retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isEmpty) getActivityTypeTabOption(
              context, model,
              40,
              false,
              getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// name of facility
                Text('Booking: ${listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash()}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                const SizedBox(height: 4),
                /// dates
                if (reservationItem.reservationState == ReservationSlotState.refunded) Text('Booking has been Refunded', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                if (reservationItem.reservationState == ReservationSlotState.cancelled) Text('Booking has been Cancelled', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                if (reservationItem.reservationState == ReservationSlotState.confirmed) Text('You Booked ${allSlots.length} slots -- Starting: ${DateFormat.MMMd().format(allSlots.first.slotRange.start)} and Ending: ${DateFormat.MMMd().format(allSlots.last.slotRange.end)}', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                if (reservationItem.reservationState == ReservationSlotState.completed) Text('Booking Completed on ${DateFormat.MMMd().format(allSlots.last.slotRange.end)}', style: TextStyle(color: model.paletteColor.withOpacity(0.6), overflow: TextOverflow.ellipsis), maxLines: 1),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      /// go to reservation
                      InkWell(
                        onTap: () {
                          didSelectReservation(listing, reservationItem, activity, attendeeItem);
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: model.disabledTextColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month_outlined, color: model.disabledTextColor,),
                                const SizedBox(width: 8),
                                Text('See Reservation', style: TextStyle(color: model.disabledTextColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          didSelectResDetail(
                            model,
                            listing,
                            reservationItem,
                            false,
                            true,
                            currentUser
                          );
                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          //   return ReservationDetailsWidget(
                          //     model: model,
                          //     listing: listing,
                          //     reservationItem: reservationItem,
                          //     isReservationOwner: false,
                          //     allAttendees: [],
                          //     isFromChat: true,
                          //     currentUser: currentUser,
                          //     );
                          //   })
                          // );
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: model.disabledTextColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, color: model.disabledTextColor),
                                Text('Review Reservation', style: TextStyle(color: model.disabledTextColor)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      /// share reservation

                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}



Widget getReservationCardItem(BuildContext context, ListingManagerForm listing, ActivityManagerForm activity, ReservationItem reservationItem, AttendeeItem? attendeeItem, List<TicketItem> ticketsCurrentAttendee, DashboardModel model, bool isEnded, bool isSelected, List<AccountNotificationItem> notifications, {required Function(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activity, AttendeeItem? attendeeItem, List<TicketItem> currentAttendeeTickets) didSelectReservation}) {

  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(reservationItem.reservationSlotItem);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));
  final bool isPrivate = (activity.rulesService.accessVisibilitySetting.isPrivateOnly == true || activity.rulesService.accessVisibilitySetting.isInviteOnly == true);

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
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            )
        )
    ),
    onPressed: () {
      didSelectReservation(listing, reservationItem, activity, attendeeItem, ticketsCurrentAttendee);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: (isSelected) ? Border.all(color: model.paletteColor, width: 1.5) : null
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getReservationMediaFrame(
                    context,
                    model,
                    100,
                    100,
                    listing,
                    activity,
                    reservationItem,
                    didSelectItem: () {
                      // didSelectReservation(listing, reservationItem, activity, attendeeItem, ticketsCurrentAttendee);
                  }
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(activity.profileService.activityBackground.activityTitle.value.fold((l) => listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), (r) => r), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                if (isPrivate) Padding(
                                  padding: const EdgeInsets.only(left: 9.0),
                                  child: Icon(Icons.lock, color: model.paletteColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            /// number of attendees

                            reservationInviteNotificationTitle(
                              model,
                              Row(
                                children: [
                                  ///  free
                                  Visibility(
                                    visible: activity.activityAttendance.isLimitedAttendance == true || activity.activityAttendance.isTicketBased == null || activity.activityAttendance.isPassBased == null || activity.activityAttendance.isLimitedAttendance == null,
                                    child: getReservationCardActivityAttendees(context, model, activity),
                                  ),
                                  ///  tickets
                                  Visibility(
                                    visible: activity.activityAttendance.isTicketBased == true,
                                    child: getReservationCardActivityTicketAttendees(context, model, activity),
                                  ),
                                  Icon(Icons.favorite, color: model.paletteColor, size: 14),
                                  const SizedBox(width: 4),
                                  Text('1', style: TextStyle(color: model.paletteColor))
                                ],
                              ),
                              notifications.length
                            ),
                            const SizedBox(height: 4),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isEnded) Text('Starting: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                                if (resSorted.first.selectedDate != resSorted.last.selectedDate) Text('Ending: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,),
                                if (isEnded) Text('Ended: ${DateFormat.yMMMd().format(resSorted.last.selectedDate)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1,)
                              ],
                            ),
                          ],
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: model.paletteColor.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (getNumberOfSlotsToGo(reservationItem) == 1) ? Text('${getNumberOfSlotsToGo(reservationItem)} Slot Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : (getNumberOfSlotsToGo(reservationItem) == 0) ? Text('Finished', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,) : Text('${getNumberOfSlotsToGo(reservationItem)} Slots Remaining', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                            )
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    ),
  );
}

Widget getReservationMediaFrame(BuildContext context, DashboardModel model, double height, double width, ListingManagerForm? listing, ActivityManagerForm? activity, ReservationItem reservationItem, {required Function() didSelectItem}) {
  return InkWell(
    onTap: didSelectItem,
    child: Column(
      children: [
        if (activity?.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) SizedBox(
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: activity?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
              imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit:BoxFit.cover),
              errorWidget: (context, url, error) => getActivityTypeTabOption(
                  context,
                  model,
                  height,
                  false,
                  getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
              )
            )
          ),
        ) else if (listing != null && retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) SizedBox(
          height: height,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
                  imageUrl: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhereOrNull((element) => element.photoUri != null)?.photoUri ?? '',
                  imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                  errorWidget: (context, url, error) => getActivityTypeTabOption(
                    context,
                    model,
                    height,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                )
              )
            ),
          ) else getActivityTypeTabOption(
            context, model,
            height,
            false,
            getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
        ),
      ],
    ),
  );
}

Widget getReservationMediaFrameFlexible(
    BuildContext context,
    DashboardModel model,
    double height,
    double width,
    ListingManagerForm? listing,
    ActivityManagerForm? activity,
    ReservationItem reservationItem,
    bool isLoading,
    {required Function() didSelectItem}) {
  return InkWell(
    onTap: didSelectItem,
    child: Column(
      children: [
        if (activity?.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) Flexible(
          child: SizedBox(
            height: height,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: activity?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
                imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                errorWidget: (context, url, error) => getActivityTypeTabOption(
                    context,
                    model,
                    height,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                )
              ),
            )
          )
        ) else if (listing != null && retrieveReservationSpacesFromListing(reservationItem, listing).where((element) => element.photoUri != null).isNotEmpty) Flexible(
          child: SizedBox(
            height: height,
            width: width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
              imageUrl: retrieveReservationSpacesFromListing(reservationItem, listing).firstWhereOrNull((element) => element.photoUri != null)?.photoUri ?? '',
              imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
              errorWidget: (context, url, error) {
                  return getActivityTypeTabOption(
                    context,
                    model,
                    height,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
                  );
                },
              )
            ),
          ),
        ) else Flexible(
          child: getActivityTypeTabOption(
              context, model,
              height,
              false,
              getActivityOptions().firstWhere((element) => element.activityId == reservationItem.reservationSlotItem.first.selectedActivityType)
          ),
        ),
      ],
    ),
  );
}

bool hasReservationToday(List<ReservationSlotItem> reservationSlots) {
  // Get current date without time
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  // Check if any reservation slot is for today
  return reservationSlots.any((slot) {
    DateTime slotDate = DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day);
    return slotDate == today;
  });
}

Widget getSearchFooterWidget(BuildContext context, DashboardModel model, UniqueId? currentUserId, Color textColor, Color secondaryTextColor, Color backgroundColor, ReservationPreviewer resPreviewer, bool isLoading, {required Function() didSelectItem, required Function() didSelectInterested}) {


  final List<ReservationSlotItem> reservationSlots = [];
  reservationSlots.addAll(resPreviewer.reservation?.reservationSlotItem ?? []);
  late List<ReservationSlotItem> resSorted = reservationSlots..sort(((a,b) => a.selectedDate.compareTo(b.selectedDate)));

  final bool isEnded = resPreviewer.reservation?.reservationState == ReservationSlotState.completed;

  if (resPreviewer.reservation == null) {
    return Container();
  }

  final String? listingTitle = resPreviewer.listing?.listingProfileService.backgroundInfoServices.listingName.getOrCrash();
  final String activityTitle = getTitleForActivityOption(context, resPreviewer.reservation!.reservationSlotItem.first.selectedActivityType) ?? 'rent';

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 6,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: const BorderRadius.all(Radius.circular(35)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1.25),
                        child: Container(
                        width: 30,
                        height: 30,
                        decoration:  BoxDecoration(
                            color: backgroundColor,
                            border: Border.all(color: textColor),
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: CachedNetworkImage(
                          imageUrl: resPreviewer.reservationOwnerProfile?.photoUri ?? '',
                          imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                          placeholder: (context, url) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image),
                          errorWidget: (context, url, error) => Center(child: Text((resPreviewer.reservationOwnerProfile?.legalName.isValid() == true) ? resPreviewer.reservationOwnerProfile!.legalName.value.fold((l) => resPreviewer.reservationOwnerProfile?.emailAddress.value.fold((l) => '..', (r) => r)[0] ?? '..', (r) => r)[0] : resPreviewer.reservationOwnerProfile?.emailAddress.value.fold((l) => '..', (r) => r)[0] ?? '..', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15))),
                          )
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: didSelectItem,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(resPreviewer.activityManagerForm?.profileService.activityBackground.activityTitle.value.fold((l) => (resPreviewer.listing != null) ? '$activityTitle at $listingTitle' : '$activityTitle Activity', (r) => r) ?? '$activityTitle at $listingTitle', style: TextStyle(color: textColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                            Text(resPreviewer.activityManagerForm?.profileService.activityBackground.activityDescription1.value.fold((l) => 'Get Activity Started', (r) => r) ?? 'Get Activity Started', style: TextStyle(color: secondaryTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)
                            // if (!isEnded) Text('Starts: ${DateFormat.yMMMd().format(resSorted.first.selectedDate)}', style: TextStyle(color: secondaryTextColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
               // Container(
               //   height: 40,
               //   width: 40,
               //   decoration: BoxDecoration(
               //     borderRadius: BorderRadius.circular(30),
               //     color: textColor.withOpacity(0.07),
               //   ),
               //   child: IconButton(
               //     padding: EdgeInsets.zero,
               //     onPressed: () {
               //
               //       for (ReservationSlotItem slotItem in reservationSlots) {
               //          for (ReservationTimeFeeSlotItem slot in groupConsecutiveSlots(slotItem.selectedSlots)) {
               //
               //
               //         }
               //       }
               //     },
               //     icon: Icon(Icons.calendar_today, size: 21, color: textColor),
               //     tooltip: 'Add to Calendar',
               //     ),
               //   ),
               //  const SizedBox(width: 8),
                watchCurrentAttendeeForInterestedState(
                    textColor,
                    backgroundColor,
                    resPreviewer.reservation!.reservationId,
                    currentUserId,
                    isLoading,
                    didSelectInterested: didSelectInterested
                )
            ],
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 5),
          if (resPreviewer.reservation!.reservationState == ReservationSlotState.confirmed && !hasReservationToday(reservationSlots)) Chip(
            padding: EdgeInsets.all(3),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: model.paletteColor,
            label: Row(
                children: [
                  Text(DateFormat.d().format(upcomingDateOrFinished(resPreviewer.reservation!) ?? DateTime.now()), style: TextStyle(color: model.accentColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  const SizedBox(width: 8),
                  Text(DateFormat.MMM().format(upcomingDateOrFinished(resPreviewer.reservation!) ?? DateTime.now()), style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)
              ]
            ),
            avatar: Icon(CupertinoIcons.calendar, size: 30, color: model.accentColor),
          ),
          if (resPreviewer.reservation!.reservationState == ReservationSlotState.confirmed && hasReservationToday(reservationSlots)) Chip(
            padding: EdgeInsets.all(10),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: model.paletteColor,
            label: Text('Starting Soon', style: TextStyle(
                color: model.accentColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            avatar: Icon(CupertinoIcons.calendar, size: 30, color: model.accentColor),
          ),
          if (resPreviewer.reservation!.reservationState == ReservationSlotState.current && hasReservationToday(reservationSlots)) Chip(
            padding: EdgeInsets.all(10),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.red,
            label: Text('Today', style: TextStyle(
                color: model.accentColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            avatar: Icon(CupertinoIcons.dot_radiowaves_left_right, color: model.accentColor),
          ),
          if (resPreviewer.reservation?.reservationState == ReservationSlotState.current && hasReservationToday(reservationSlots) == false) Chip(
            padding: EdgeInsets.all(5),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.red,
            label: Row(
                children: [
                  Text(DateFormat.d().format(upcomingDateOrFinished(resPreviewer.reservation!) ?? DateTime.now()), style: TextStyle(color: model.accentColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  const SizedBox(width: 8),
                  Text(DateFormat.MMM().format(upcomingDateOrFinished(resPreviewer.reservation!) ?? DateTime.now()), style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)
                ]
            ),
            avatar: Icon(CupertinoIcons.calendar_today, size: 30, color: model.accentColor),
          ),
          if (isEnded) Chip(
            padding: EdgeInsets.all(3),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: backgroundColor,
            label: Row(
              children: [
                Text(DateFormat.d().format(upcomingDateOrFinished(resPreviewer.reservation!) ?? DateTime.now()), style: TextStyle(color: model.disabledTextColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                const SizedBox(width: 8),
                Text(DateFormat.MMM().format(upcomingDateOrFinished(resPreviewer.reservation!) ?? DateTime.now()), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)
                ]
              ),
            avatar: Icon(CupertinoIcons.calendar, size: 30, color: model.disabledTextColor),
          ),

          const SizedBox(width: 8),
          // Visibility(
          //   visible: isEnded == false || resPreviewer.reservation!.reservationState == ReservationSlotState.current,
          //   child: Visibility(
          //       visible: resPreviewer.activityManagerForm?.activityAttendance.isLimitedAttendance == true || resPreviewer.activityManagerForm?.activityAttendance.isTicketBased == null || resPreviewer.activityManagerForm?.activityAttendance.isPassBased == null || resPreviewer.activityManagerForm?.activityAttendance.isLimitedAttendance == null,
          //       child: InkWell(
          //         onTap: didSelectItem,
          //         child: Container(
          //           width: 100,
          //           decoration: BoxDecoration(
          //             color: textColor,
          //             borderRadius: const BorderRadius.all(Radius.circular(40)),
          //           ),
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: Center(child: Text('Join', style: TextStyle(color: backgroundColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
          //         ),
          //       ),
          //     )
          //   ),
          // ),
          ///  tickets
          Visibility(
            visible: isEnded == false || resPreviewer.reservation!.reservationState == ReservationSlotState.current,
            child: Visibility(
              visible: resPreviewer.activityManagerForm?.activityAttendance.isTicketBased == true,
              child: InkWell(
                onTap: didSelectItem,
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text('Find Tickets', style: TextStyle(color: backgroundColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

Widget watchCurrentAttendeeForInterestedState(Color textColor, Color backgroundColor, UniqueId activityId, UniqueId? currentUser, bool isLoading, {required Function() didSelectInterested}) {
  if (isLoading) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: textColor,
      ),
      child: AnimatedGradientBorder(
        borderSize: 5,
        glowSize: 2,
        gradientColors: const [
          Color.fromRGBO(202, 137, 255, 1.0),
          Color.fromRGBO(255, 61, 106, 1.0),
          Color.fromRGBO(60, 11, 206, 1.0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(999)),
        child: Container(
          height: 40,
          width: 40,
          // child: IconButton(
          //   padding: EdgeInsets.only(top: 4),
          //   onPressed: didSelectInterested,
          //   tooltip: 'Bookmark',
          //   icon: Icon(CupertinoIcons.heart, color: backgroundColor),
          // ),
        ),
      ),
    );
  }
  return (currentUser != null) ? BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(activityId.getOrCrash(), currentUser.getOrCrash())),
    child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadAttendeeItemSuccess: (item) {
            if (item.item.isInterested == true) {
              return Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: textColor,
                ),
                child: IconButton(
                  padding: EdgeInsets.only(top: 4),
                  onPressed: didSelectInterested,
                  tooltip: 'Bookmark',
                  icon: Icon(CupertinoIcons.heart, color: backgroundColor),
                ),
              );
            } else {
              return Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: textColor.withOpacity(0.07),
                ),
                child: IconButton(
                  padding: EdgeInsets.only(top: 4),
                  onPressed: didSelectInterested,
                  tooltip: 'Bookmark',
                  icon: Icon(CupertinoIcons.heart, color: textColor),
                ),
              );
            }
          },
          orElse: () => Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: textColor.withOpacity(0.07),
            ),
            child: IconButton(
              padding: EdgeInsets.only(top: 4),
              onPressed: didSelectInterested,
              tooltip: 'Bookmark',
              icon: Icon(CupertinoIcons.heart, color: textColor),
            ),
          ),
        );
      },
    ),
  ) : Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: textColor.withOpacity(0.07),
    ),
    child: IconButton(
      padding: EdgeInsets.only(top: 4),
      onPressed: didSelectInterested,
      tooltip: 'Bookmark',
      icon: Icon(CupertinoIcons.heart, color: textColor),
    ),
  );
}

Widget getReservationCardActivityAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm) {
  return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.free.toString(), activityForm.activityFormId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
        return state.maybeMap(
        loadAllAttendanceSuccess: (item) {
            return Row(
              children: [
                Icon(Icons.person_sharp, color: model.paletteColor, size: 14),
                const SizedBox(width: 4),
                Text(item.item.length.toString(), style: TextStyle(color: model.paletteColor)),
                const SizedBox(width: 10),
              ],
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}


Widget getReservationCardActivityTicketAttendees(BuildContext context, DashboardModel model, ActivityManagerForm activityForm) {
return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.tickets.toString(), activityForm.activityFormId.getOrCrash())),
  child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadAllAttendanceSuccess: (item) {
            return Row(
              children: [
                Icon(Icons.airplane_ticket_outlined, color: model.paletteColor, size: 14),
                const SizedBox(width: 4),
                Text(item.item.length.toString(), style: TextStyle(color: model.paletteColor)),
                const SizedBox(width: 10),
              ],
            );
          },
          orElse: () => Container(),
        );
      },
    ),
  );
}

Widget baseSearchItemContainer({required DashboardModel model, required bool? isSelected, required Widget backgroundWidget, required Widget bottomWidget, required double height, required double width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: (isSelected == true) ? model.disabledTextColor.withOpacity(0.17) : Colors.transparent,
    ),
    child: Column(
      children: [
        Flexible(
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: backgroundWidget
              ),
              Positioned(
                top: 15,
                child: IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border_rounded, size: 25, color: model.accentColor)),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: bottomWidget,
        )
      ],
    ),
  );
}