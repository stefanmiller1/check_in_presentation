part of check_in_presentation;

enum ReservationEditMarker {editReservation, reviewChanges, submit}
enum ReservationEditChangeMarker {selectChangeType, addNewSlot, removeExistingSlot}
enum ReservationCancelMarker {cancelReason, cancelMessage, submit, finished}


Map<String, List<CalendarReservation>> getListByDate(List<ReservationItem> reservations, List<UniqueId> spaceOptionToFilter, int durationType, bool showAll) {

  Map<String, List<CalendarReservation>> dateTimeList = HashMap<String, List<CalendarReservation>>();

  for (ReservationItem res in reservations) {
    for (ReservationSlotItem resSlot in res.reservationSlotItem.where((element) => spaceOptionToFilter.isNotEmpty ? spaceOptionToFilter.contains(element.selectedSpaceId) : true)) {
      for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots.where((element) => (showAll) ? element.slotRange.start.isAfter(DateTime.now()) : true)) {
        final DateTime day = DateTime(resFeeTime.slotRange.start.year, resFeeTime.slotRange.start.month, resFeeTime.slotRange.start.day);


          dateTimeList.putIfAbsent(day.toString(), () => []).add(
              CalendarReservation(
                  eventId: res.reservationId.getOrCrash(),
                  eventState: retrieveReservationSlotState(res.reservationState, resFeeTime.slotRange.start, durationType).toString(),
                  organizerId: res.reservationOwnerId.getOrCrash(),
                  slotInfo: resFeeTime.fee,
                  eventType: resSlot.selectedActivityType,
                  eventSpace: resSlot.selectedSpaceId,
                  from: resFeeTime.slotRange.start,
                  to: resFeeTime.slotRange.end,
                  isAllDay: false
              )
          );

      }
    }
  }
  return dateTimeList;
}

/// *** function to return state based on reservation slot time or manually updated settings *** ///
ReservationSlotState retrieveReservationSlotState(ReservationSlotState currentState, DateTime slotDateTime, int duration) {

  switch (currentState) {

    case ReservationSlotState.requested:
      return currentState;
    case ReservationSlotState.confirmed:
      if (slotDateTime.isBefore(DateTime.now().subtract(Duration(minutes: 30)))) {
        return ReservationSlotState.completed;
      } else if (slotDateTime.isBefore(DateTime.now()) && slotDateTime.isAfter(DateTime.now().subtract(Duration(minutes: duration)))) {
        return ReservationSlotState.current;
      }
      return currentState;
    case ReservationSlotState.current:
      return currentState;
    case ReservationSlotState.completed:
      return currentState;
    case ReservationSlotState.cancelled:
      return currentState;
    case ReservationSlotState.refunded:
      return currentState;
  }
}

/// retrieve color for reservation state ///
Color getColorForReservationState(ReservationSlotState currentState, DashboardModel model) {
  switch (currentState) {

    case ReservationSlotState.requested:
      return model.paletteColor;
    case ReservationSlotState.confirmed:
      return model.paletteColor;
    case ReservationSlotState.current:
      return model.paletteColor;
    case ReservationSlotState.completed:
      return model.disabledTextColor;
    case ReservationSlotState.cancelled:
      return model.disabledTextColor;
    case ReservationSlotState.refunded:
      return model.disabledTextColor;
  }
}

bool isReservationSlotItemComplete(ReservationSlotItem reservation) {
  List<bool> isFinished = [];

      for (ReservationTimeFeeSlotItem resFeeTime in reservation.selectedSlots) {
        isFinished.add(resFeeTime.slotRange.start.isAfter(DateTime.now()));
      }

  return !isFinished.contains(true);
}

/// retrieve container for reservation state ///
Widget getContainerForReservationState(ReservationSlotState currentState) {
  switch (currentState) {

    case ReservationSlotState.requested:
      // TODO: Handle this case.
      break;
    case ReservationSlotState.confirmed:
      // TODO: Handle this case.
      break;
    case ReservationSlotState.current:
      // TODO: Handle this case.
      break;
    case ReservationSlotState.completed:
      // TODO: Handle this case.
      break;
    case ReservationSlotState.cancelled:
      // TODO: Handle this case.
      break;
    case ReservationSlotState.refunded:
      // TODO: Handle this case.
      break;
  }
  return Container();
}


Widget getReservationContainerForState(BuildContext context, String slotTimeString, ReservationSlotState state, DashboardModel model, bool isSelectedReservation, String fee, DateTimeRange slotRange) {

  switch (state) {
    case ReservationSlotState.requested:
      return Container(
        // height: 60,
        // width: 275,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: isSelectedReservation ? model.paletteColor : Colors.transparent,
          //     border: Border.all(width: 1, color: model.paletteColor)
        ),
        child: DottedBorder(
          color: model.paletteColor,
          strokeWidth: 1.5,
          dashPattern: [2,5],
          radius: Radius.circular(20),
          borderType: BorderType.RRect,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$slotTimeString: ${DateFormat.jm().format(slotRange.start)} - ${DateFormat.jm().format(slotRange.end)}",
                      style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor :  model.disabledTextColor, fontSize: 16.5, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis),
                  Text("Earnings: ${fee}", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.disabledTextColor), overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ),
    );
    case ReservationSlotState.confirmed:
      return Container(
        // height: 60,
        // width: 275,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: isSelectedReservation ? model.paletteColor : Colors.transparent,
        //     border: Border.all(width: 1, color: model.paletteColor)
        ),
        child: DottedBorder(
          color: model.paletteColor,
          strokeWidth: 1.5,
          dashPattern: [2,5],
          radius: Radius.circular(20),
          borderType: BorderType.RRect,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$slotTimeString: ${DateFormat.jm().format(slotRange.start)} - ${DateFormat.jm().format(slotRange.end)}",
                      style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor :  model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text("Earnings: ${fee}", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.paletteColor), overflow: TextOverflow.ellipsis)
              ],
            ),
          ),
        ),
      );
    case ReservationSlotState.current:
      return Container(
        // height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: isSelectedReservation ? model.paletteColor : Colors.transparent,
              border: Border.all(width: 1, color: model.paletteColor)
          ),
          child: CustomPaint(
            painter: (isSelectedReservation) ? ContainerPatternPainter(model: model.webBackgroundColor.withOpacity(0.45)) : ContainerPatternPainter(model: model.paletteColor.withOpacity(0.25)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$slotTimeString: ${DateFormat.jm().format(slotRange.start)} - ${DateFormat.jm().format(slotRange.end)}",
                      style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor :  model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text("Earnings: ${fee}", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.paletteColor), overflow: TextOverflow.ellipsis)
                ],
              ),
            ),
          ),
        );
    case ReservationSlotState.completed:
      return Container(
        // height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: isSelectedReservation ? model.paletteColor : Colors.transparent,
            border: Border.all(width: 1, color: model.disabledTextColor)
        ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$slotTimeString: ${DateFormat.jm().format(slotRange.start)} - ${DateFormat.jm().format(slotRange.end)}",
                style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor :  model.disabledTextColor, fontSize: 16.5, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis),
            Text("Earnings: +${fee}", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.disabledTextColor), overflow: TextOverflow.ellipsis)
                ],
              ),
            ),
          );
    case ReservationSlotState.cancelled:
      return Container(
        // height: 60,
        // width: 275,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: isSelectedReservation ? model.paletteColor : Colors.transparent,
            border: Border.all(width: 1, color: model.disabledTextColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$slotTimeString: ${DateFormat.jm().format(slotRange.start)} - ${DateFormat.jm().format(slotRange.end)}",
                  style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor :  model.disabledTextColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              Text("Earnings: ${fee}", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.disabledTextColor), overflow: TextOverflow.ellipsis)
          ],
        ),
      ),
    );
    case ReservationSlotState.refunded:
      return Container(
        // height: 60,
        // width: 275,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: isSelectedReservation ? model.paletteColor : Colors.transparent,
            border: Border.all(width: 1, color: model.disabledTextColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("$slotTimeString: ${DateFormat.jm().format(slotRange.start)} - ${DateFormat.jm().format(slotRange.end)}",
                      style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor :  model.disabledTextColor, fontSize: 16.5, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis),
                  Text("Earnings: - $fee", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.disabledTextColor), overflow: TextOverflow.ellipsis)
                ],
              ),
              Text("Refunded", style: TextStyle(color: isSelectedReservation ? model.webBackgroundColor : model.disabledTextColor, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      );
  }
}

int getTotalNumberOfReservationSlots(List<ReservationItem> reservations, List<UniqueId> spaceOptionToFilter, int durationType, bool showAll) {
  int total = 0;

  for (ReservationItem res in reservations) {
    for (ReservationSlotItem resSlot in res.reservationSlotItem.where((element) => spaceOptionToFilter.isNotEmpty ? spaceOptionToFilter.contains(element.selectedSpaceId) : true).toList()) {
      for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots.where((element) => (showAll) ? element.slotRange.start.isAfter(DateTime.now()) : true).toList()) {

        total += 1;

      }
    }
  }


  return total;
}


int getTotalReservationSlotHours(List<ReservationItem> reservations, List<UniqueId> spaceOptionToFilter, int durationType, bool showAll) {
  int total = 0;
  int totalLength = 0;

  for (ReservationItem res in reservations) {
    for (ReservationSlotItem resSlot in res.reservationSlotItem.where((element) => spaceOptionToFilter.isNotEmpty ? spaceOptionToFilter.contains(element.selectedSpaceId) : true)) {
      for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots.where((element) => (showAll) ? element.slotRange.start.isAfter(DateTime.now()) : true)) {

        totalLength += 1;

      }
    }
  }

  total = Duration(minutes: totalLength * durationType).inHours ;
  return total;
}

String getTotalReservationEarnings(List<ReservationItem> reservations, List<UniqueId> spaceOptionToFilter, int durationType, bool showAll) {
  String total = '';
  int feeTotal = 0;

  for (ReservationItem res in reservations) {
    for (ReservationSlotItem resSlot in res.reservationSlotItem.where((element) => spaceOptionToFilter.isNotEmpty ? spaceOptionToFilter.contains(element.selectedSpaceId) : true)) {
      for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots.where((element) => (showAll) ? element.slotRange.start.isAfter(DateTime.now()) : true)) {

        feeTotal += int.parse(resFeeTime.fee.replaceAll(new RegExp(r'[^0-9]'),''));
        total = resFeeTime.fee[0];

      }
    }
  }

  return '$total$feeTotal';
}


/// for retrieving the number of slots remaining - based on current time, determined by counting number of items remaining after current datetime
int getNumberOfSlotsToGo(ReservationItem reservation) {
  int total = 0;

    for (ReservationSlotItem resSlot in reservation.reservationSlotItem) {
      for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots.where((element) => element.slotRange.start.isAfter(DateTime.now()))) {
        total += 1;
    }
  }
  return total;
}


/// for retrieve remaining dates in a reservation - based on current time, count number of date items left in [ReservationSlotItem]
List<DateTime> getAllRemainingDates(List<ReservationSlotItem> reservationSlots) {
  List<DateTime> datesTogo = [];

  for (ReservationSlotItem resSlot in reservationSlots) {
  for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots.where((element) => element.slotRange.end.isAfter(DateTime.now()))) {
    datesTogo.add(resFeeTime.slotRange.start);
    }
  }

  return datesTogo;
}


/// for retrieving the total number of slots in a reservation
int getNumberOfSlotsTotal(ReservationItem reservation) {
  int total = 0;

  for (ReservationSlotItem resSlot in reservation.reservationSlotItem) {
    for (ReservationTimeFeeSlotItem resFeeTime in resSlot.selectedSlots) {
      total += 1;
    }
  }
  return total;
}


Widget headerFilterItemsContainerMain(BuildContext context, DashboardModel model, bool isFacility, List<ReservationItem> currentReservations, List<FacilityActivityCreatorForm> supportedActivityOptions, ListK<SpaceOption> spaceOptionType, List<UniqueId> supportedToFilter, List<UniqueId> spaceOptionToFilter, {required Function(FacilityActivityCreatorForm) supportedActivityToFilter, required Function(SpaceOption) spaceTypeToFilter}) {

  /// facility only
  /// on hover present button to create facility support options / show facility support options (and edit)

  /// facility only
  /// start internal programs (new activity) for facility specifically
  //// show (small icon) for additional internal programs (let filter by each internal program?)???

  /// both
  /// on hover present button to edit/create additional show filter option buttons for reservations based on space option

  /// both
  /// show filter option for filter option buttons for reservations based on space name/side options


  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Icon(Icons.sort, size: 25, color: model.paletteColor),
        //     SizedBox(width: 10),
        //     Text('Filter Your Reservations: ', style: TextStyle(color: model.paletteColor.withOpacity(0.5))),
        //   ],
        // ),
        SizedBox(height: 10),
        if (isFacility) Column(
          children: [
            // FilterSelectionList(
            //     model: model,
            //     createTitle: '+ New Supported Activity',
            //     filterItems: supportedActivityOptions.map(
            //             (supportedActivity) => Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 2.0),
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 border: (supportedToFilter.contains(supportedActivity.activity.activityId)) ? Border.all(color: model.paletteColor, width: 1) : null,
            //                 borderRadius: BorderRadius.all(Radius.circular(25.0)),
            //                 color: model.accentColor
            //             ),
            //             child: Padding(
            //               padding: const EdgeInsets.all(3.0),
            //               child: TextButton(
            //                 style: ButtonStyle(
            //                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
            //                           (Set<MaterialState> states) {
            //                         if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
            //                           return model.disabledTextColor.withOpacity(0.25);
            //                         }
            //                         if (states.contains(MaterialState.hovered)) {
            //                           return model.disabledTextColor.withOpacity(0.25);
            //                         }
            //                         return model.accentColor.withOpacity(0.4); // Use the component's default.
            //                       },
            //                     ),
            //                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                         RoundedRectangleBorder(
            //                           borderRadius: const BorderRadius.all(Radius.circular(15)),
            //                         )
            //                     )
            //                 ),
            //                 onPressed: () {
            //                   supportedActivityToFilter(supportedActivity);
            //                 },
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(4.0),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       // Padding(
            //                       //   padding: const EdgeInsets.only(right: 10.0),
            //                       //   child: Container(
            //                       //     decoration: BoxDecoration(
            //                       //         borderRadius: BorderRadius.all(Radius.circular(25.0)),
            //                       //         color: (supportedToFilter.contains(supportedActivity.activity.activityId)) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45)
            //                       //     ),
            //                       //     child: Align(
            //                       //       alignment: Alignment.center,
            //                       //       child: Padding(
            //                       //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //                       //         child: Text('${currentReservations.where((element) => element.activityTypeId == supportedActivity.activity.activityId).length}', style: TextStyle(color: (supportedToFilter.contains(supportedActivity.activity.activityId)) ? model.accentColor : model.webBackgroundColor, fontWeight: FontWeight.bold)),
            //                       //       ),
            //                       //     ),
            //                       //   ),
            //                       // ),
            //                       Padding(
            //                         padding: const EdgeInsets.only(right: 10.0),
            //                         child: Icon(getActivityOptions(context).where((element) => element.activityId == supportedActivity.activity.activityId).first.icon, size: 20, color: (supportedToFilter.contains(supportedActivity.activity.activityId)) ? model.paletteColor : model.disabledTextColor),
            //                       ),
            //                       Text(getActivityOptions(context).where((element) => element.activityId == supportedActivity.activity.activityId).first.title ?? '', style: TextStyle(color: (supportedToFilter.contains(supportedActivity.activity.activityId)) ? model.paletteColor : model.disabledTextColor, fontWeight: FontWeight.bold))
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         )
            //     ).toList(),
            //     didSelectCreateNew: () {
            //
            //     }
            // ),
            SizedBox(height: 10),
            FilterSelectionList(
                model: model,
                createTitle: '+ Add Another Court, Studio...',
                filterItems: spaceOptionType.value.fold((l) => [], (r) => r).map(
                        (e)  {
                      final SpaceOption option = e;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: (spaceOptionToFilter.contains(option.uid)) ? Border.all(color: model.paletteColor, width: 1) : null,
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              color: model.accentColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                        return model.disabledTextColor.withOpacity(0.25);
                                      }
                                      if (states.contains(MaterialState.hovered)) {
                                        return model.disabledTextColor.withOpacity(0.25);
                                      }
                                      return model.accentColor.withOpacity(0.4); // Use the component's default.
                                    },
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      )
                                  )
                              ),
                              onPressed: () {
                                spaceTypeToFilter(option);

                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(getSpaceTypeOptions(context).where((element) => element.uid == e.uid).isNotEmpty ?
                                getSpaceTypeOptions(context).where((element) => element.uid == e.uid).first.spaceTitle : '',
                                  style: TextStyle(color: (spaceOptionToFilter.contains(option.uid)) ? model.paletteColor : model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                ).toList(),
                didSelectCreateNew: () {

              }
            ),
            SizedBox(width: 50)
          ],
        ),

      ],
    ),
  );
}

Color getBackgroundForRes(ReservationSlotState state, DashboardModel model) {
  switch (state) {

    case ReservationSlotState.requested:
      return Colors.transparent;
    case ReservationSlotState.confirmed:
      return Colors.transparent;
    case ReservationSlotState.current:
      return model.paletteColor;
    case ReservationSlotState.completed:
      return Colors.transparent;
    case ReservationSlotState.cancelled:
      return model.disabledTextColor.withOpacity(0.4);
    case ReservationSlotState.refunded:
      return Colors.transparent;
  }
}

bool isSelectedReservation(DateTime selectedDate, DateTime slotTime) {
  return (selectedDate == slotTime);
}

Widget getDetailListOfReservations(
    BuildContext context,
    DashboardModel model,
    ReservationItem reservation,
    DateTime currentSelectedDate,
    int durationType,
    MapEntry<String, List<ReservationSlotItem>> entry,
    {required Function(ReservationSlotItem) didSelectChange}
    ) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      for (var e in entry.value.toList()..sort((a,b) => b.selectedDate.compareTo(a.selectedDate)))

        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: () {
              didSelectChange(e);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: model.profileContainerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    // color: getBackgroundForRes(reservation.reservationState, model),
                    border: (reservation.reservationState == ReservationSlotState.requested) ? null : Border.all(width: 1, color: isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor),
                  ),
                  child: DottedBorder(
                    color: (reservation.reservationState == ReservationSlotState.requested) ? model.paletteColor : Colors.transparent,
                    strokeWidth: 1.5,
                    dashPattern: [2,5],
                    radius: Radius.circular(20),
                    borderType: BorderType.RRect,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IgnorePointer(
                        ignoring: isReservationSlotItemComplete(e),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                    return model.paletteColor.withOpacity(0.1);
                                  }
                                  if (states.contains(MaterialState.hovered)) {
                                    return (reservation.reservationState == ReservationSlotState.cancelled) ? Colors.transparent : model.paletteColor.withOpacity(0.1);
                                  }
                                  return Colors.transparent; // Use the component's default.
                                },
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  )
                              )
                          ),
                          onPressed: () {
                            didSelectChange(e);
                            // selectedReservation(reservation.reservationId);
                          },
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: 10),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor, width: 1),
                                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Icon(getIconDataForActivity(context, e.selectedActivityType), color: model.disabledTextColor),
                                            ),
                                            Text(getTitleForActivityOption(context, e.selectedActivityType) ?? '', style: TextStyle(color: isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text('${AppLocalizations.of(context)!.profileFacilitySlotBookingLocation} ${getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).isNotEmpty ? getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).first.spaceTitle : ''}', style: TextStyle(color: isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                            Text('Date: ${DateFormat.MMMMEEEEd().format(e.selectedDate)}', style: TextStyle(color: isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                            // Text('Type: ${e.selectedSlotInterval.toString()} minute time slot', style: TextStyle(color: model.paletteColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: (e.selectedSideOption == 'TopHalf' || e.selectedSideOption == 'Full') ? model.paletteColor : model.accentColor,
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            height: 30,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: (e.selectedSideOption == 'BottomHalf' || e.selectedSideOption == 'Full') ? model.paletteColor : model.accentColor,
                                              borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                ///number of slots
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Number of Slots: ', style: TextStyle(color: isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor)),

                                      for (var f in e.selectedSlots.toList()..sort((a,b) => b.slotRange.start.compareTo(a.slotRange.start)))

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: getReservationContainerForState(context, AppLocalizations.of(context)!.profileFacilitySlotTime, retrieveReservationSlotState(reservation.reservationState, f.slotRange.start, durationType), model, isSelectedReservation(currentSelectedDate, f.slotRange.start), f.fee, f.slotRange),
                                            ),
                                            Text(getReservationStateTitle(getBookingSlotState(retrieveReservationSlotState(reservation.reservationState, f.slotRange.start, durationType).toString())), style: TextStyle(color:  isReservationSlotItemComplete(e) ? model.disabledTextColor : model.paletteColor, fontWeight: FontWeight.bold))
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                            SizedBox(height: 10,)
                          ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ],
  );
}


