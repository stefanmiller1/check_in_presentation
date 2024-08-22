part of check_in_presentation;

/// based on original reservation list - return list of reservation items for new selected reservations only
List<ReservationSlotItem> newReservationsOnly(List<ReservationSlotItem> original, List<ReservationSlotItem> current) {
  final List<ReservationSlotItem> reservations = [];

  for (ReservationSlotItem slot in current) {

    reservations.add(ReservationSlotItem(
        selectedActivityType: slot.selectedActivityType,
        selectedSportSpaceId: slot.selectedSportSpaceId,
        selectedSpaceId: slot.selectedSpaceId,
        selectedDate: slot.selectedDate,
        selectedSlots: []
    ));

    final List<ReservationTimeFeeSlotItem> timeSlots = [];
    timeSlots.addAll(slot.selectedSlots);
    timeSlots.removeWhere((elements) => original.firstWhere((element) => DateTime(element.selectedDate.year, element.selectedDate.month, element.selectedDate.day) == DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day), orElse: () => ReservationSlotItem.empty()).selectedSlots.contains(elements));
    final index = reservations.indexWhere((element) =>
    element.selectedActivityType == slot.selectedActivityType &&
        element.selectedSportSpaceId == slot.selectedSportSpaceId &&
        element.selectedDate == slot.selectedDate &&
        element.selectedSpaceId == slot.selectedSpaceId
    );

    reservations[index] = reservations[index].copyWith(
      selectedSlots: timeSlots
    );
  }
  return reservations;
}

Widget viewListOfSelectedSlots(
    BuildContext context,
    DashboardModel model,
    List<ReservationItem> bookedReservations,
    List<ReservationSlotItem> reservations,
    List<ReservationSlotItem> cancelledReservations,
    bool isRemovingReservation,
    String profileFacilitySlotTime,
    String profileFacilitySlotBookingLocation,
    String profileFacilitySlotBookingDate,
    ListingManagerForm? listing, {
      required Function(ReservationSlotItem) didSelectReservation,
      required Function(ReservationTimeFeeSlotItem, ReservationSlotItem) didSelectCancelResSlot,
      required Function(ReservationTimeFeeSlotItem, ReservationSlotItem) didSelectRemoveResSlot}) {

  return Column(
    children: [
        for (var entry in getGroupOfSelectedReservations(reservations).entries.toList(
          growable: false)..sort((a,b) {
            return a.key.compareTo(b.key);
        }))

          if (entry.value.isNotEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ...entry.value.map((e) {

                  final String? spaceBackgroundImage = listing?.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => null, (r) => r.where((element) => element.uid == e.selectedSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == e.selectedSpaceId).quantity.where((element) => element.spaceId == e.selectedSportSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == e.selectedSpaceId).quantity.firstWhere((element) => element.spaceId == e.selectedSportSpaceId).photoUri : null : null);


                  return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    visible: e.selectedSlots.isNotEmpty,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// *** Present if slot items is not empty *** ///
                        if (entry.value.map((e) => e.selectedSlots.isNotEmpty).contains(true)) reservationSlotItemWidget(
                          context,
                          model,
                          e,
                          bookedReservations,
                          listing,
                          cancelledReservations,
                          isRemovingReservation,
                          profileFacilitySlotTime,
                          profileFacilitySlotBookingLocation,
                          profileFacilitySlotBookingDate,
                          spaceBackgroundImage,
                          didSelectReservation: (e) {
                            return didSelectReservation(e);
                          },
                          didSelectCancelResSlot: (f, e) {
                            return didSelectCancelResSlot(f, e);
                          }
                      )
                    ],
                  ),
                ),
              );
            }
          )
        ],
      ),

      SizedBox(height: 15),
      Visibility(
        visible: cancelledReservations.isNotEmpty,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: model.disabledTextColor),
            SizedBox(height: 15),
            if (cancelledReservations.map((e) => e.selectedSlots.isNotEmpty).contains(true)) Text('Cancelled Reservations', style: TextStyle(color: model.disabledTextColor, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      for (var entry in getGroupOfSelectedReservations(cancelledReservations).entries.toList(
          growable: false)..sort((a,b) {
        return a.key.compareTo(b.key);
      }))

      Visibility(
        visible: entry.value.isNotEmpty,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ...entry.value.map((e) {

                final String? spaceBackgroundImage = listing?.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => null, (r) => r.where((element) => element.uid == e.selectedSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == e.selectedSpaceId).quantity.where((element) => element.spaceId == e.selectedSportSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == e.selectedSpaceId).quantity.firstWhere((element) => element.spaceId == e.selectedSportSpaceId).photoUri : null : null);

                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                  visible: e.selectedSlots.isNotEmpty,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IgnorePointer(
                        ignoring: e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1))),
                        child: Container(
                          child: TextButton(
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
                                      RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      )
                                  )
                              ),
                              onPressed: () {
                                didSelectReservation(e);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (spaceBackgroundImage != null) CircleAvatar(
                                              foregroundImage: Image.network(spaceBackgroundImage, fit: BoxFit.cover).image,
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              height: 40,
                                              width: 40,

                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('$profileFacilitySlotBookingLocation ${getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).isNotEmpty ? getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).first.spaceTitle : ''}', style: TextStyle(color: model.disabledTextColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                                Text('$profileFacilitySlotBookingDate ${DateFormat.MMMMd().format(e.selectedDate)}', style: TextStyle(color: model.disabledTextColor, fontSize: 25, fontWeight: FontWeight.bold, decoration: (e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) ? TextDecoration.lineThrough : null)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) Text('Ended', style: TextStyle(color: model.disabledTextColor))
                                      ],
                                    ),


                                    for (var f in e.selectedSlots.toList()..sort((a,b) => b.slotRange.start.compareTo(a.slotRange.start)))
                                      Container(
                                        height: 40,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Visibility(
                                                visible: f.slotRange.start.isAfter(DateTime.now()),
                                                child: IconButton(
                                                    onPressed: () {
                                                      didSelectCancelResSlot(f, e);
                                                    },
                                                    icon:  Icon(Icons.cancel), color: model.disabledTextColor, padding: EdgeInsets.zero
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Icon(Icons.calendar_today_outlined, color: model.disabledTextColor,),
                                              SizedBox(width: 5),
                                              // if (retrieveHourToUpdate(e.selectedSlots, f.start.hour) == f.start.hour) Text('${AppLocalizations.of(context)!.profileFacilitySlotTime}: ${DateFormat.jm().format(f.start)} - ${DateFormat.jm().format(f.start.add(Duration(minutes: 60)))}', style: TextStyle(color: model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis) else
                                              Text('$profileFacilitySlotTime: ${DateFormat.jm().format(f.slotRange.start)} - ${DateFormat.jm().format(f.slotRange.end)}', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough), overflow: TextOverflow.ellipsis),
                                              SizedBox(width: 5),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            )
          ],
        )
      ),
    ],
  );
}


Widget reservationSlotItemWidget(
    BuildContext context,
    DashboardModel model,
    ReservationSlotItem e,
    List<ReservationItem> bookedReservations,
    ListingManagerForm? listing,
    List<ReservationSlotItem> cancelledReservations,
    bool isRemovingReservation,
    String profileFacilitySlotTime,
    String profileFacilitySlotBookingLocation,
    String profileFacilitySlotBookingDate,
    String? spaceImage, {
     required Function(ReservationSlotItem) didSelectReservation,
     required Function(ReservationTimeFeeSlotItem, ReservationSlotItem) didSelectCancelResSlot,
    }) {

   List<ReservationTimeFeeSlotItem> selectedSlots = [];
   selectedSlots.addAll(e.selectedSlots);
   // selectedSlots.sort((a,b) => a.slotRange.start.compareTo(b.slotRange.start));


  return IgnorePointer(
    ignoring: e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1))),
    child: Container(
      decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 0.5, color: model.paletteColor)
      ),
      child: TextButton(
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
                  RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  )
              )
          ),
          onPressed: () {
            didSelectReservation(e);
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (spaceImage != null) CircleAvatar(
                          foregroundImage: Image.network(spaceImage, fit: BoxFit.cover).image,
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: model.paletteColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: SvgPicture.asset(getIconPathForActivity(context, e.selectedActivityType) ?? '', color: model.accentColor,
                            ),
                          )
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$profileFacilitySlotBookingLocation ${getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).isNotEmpty ? getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).first.spaceTitle : ''}', style: TextStyle(color: model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                            Text('$profileFacilitySlotBookingDate ${DateFormat.MMMMd().format(e.selectedDate)}', style: TextStyle(color: model.paletteColor, fontSize: 25, fontWeight: FontWeight.bold, decoration: (e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) ? TextDecoration.lineThrough : null)),
                            // Text(AppLocalizations.of(context)!.profileFacilitySlotBooking(e.selectedSideOption ?? ''), style: TextStyle(color: model.paletteColor)),
                          ],
                        ),
                      ),
                    ),
                    if (e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) Text('Ended', style: TextStyle(color: model.disabledTextColor))
                  ],
                ),



                Wrap(
                    direction: Axis.horizontal,
                    spacing: 4,
                    runSpacing: 4,
                    children: groupConsecutiveSlots(selectedSlots).map((f) {

                      bool isReservationUnavailable = false;
                      AvailabilityHoursSettings? availabilityHours = listing?.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => null, (r) => r.where((element) => element.uid == e.selectedSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == e.selectedSpaceId).quantity.where((element) => element.spaceId == e.selectedSportSpaceId).isNotEmpty ? r.firstWhere((element) => element.uid == e.selectedSpaceId).quantity.firstWhere((element) => element.spaceId == e.selectedSportSpaceId).availabilityHoursSettings : null : null);
                      ReservationItem? reservationItem = (bookedReservations.where((element) => element.reservationSlotItem.map((slot) => DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day)).contains(DateTime(e.selectedDate.year, e.selectedDate.month, e.selectedDate.day))).isNotEmpty) ? bookedReservations.where((element) => element.reservationSlotItem.map((slot) => DateTime(slot.selectedDate.year, slot.selectedDate.month, slot.selectedDate.day)).contains(DateTime(e.selectedDate.year, e.selectedDate.month, e.selectedDate.day))).first : null;
                      // List<DayOptionItem> spaceHours = availabilityHours?.availabilityPeriod.hoursOpen.openHours ?? [];
                      // DayOptionItem? dayHours = spaceHours.where((element) => element.dayOfWeek == f.slotRange.start.weekday).isNotEmpty ? spaceHours.firstWhere((element) => element.dayOfWeek == f.slotRange.start.weekday) : null;
                      // int? currentSpaceStartTimeHour = availabilityHours?.startHour.toInt();
                      // int? currentSpaceEndTimeHour = availabilityHours?.endHour.toInt();

                      /// see if reservation is already booked...or if reservation is outside selected space hours, or outside of selected space start/end time.

                     isReservationUnavailable =
                          /// if slot is already booked
                     isReservationBooked(
                         currentRes: e,
                         reservations: reservationItem?.reservationSlotItem ?? [],
                         currentSlot: f,
                         reservationTimeSlots: retrieveReservationTimeSlots(
                         reservationItem?.reservationSlotItem ?? [], e))||
                          /// if space has set weekday to open 24 hours - is not available if time is before the space has opened
                     isSlotUnavailableBasedOnHours(availabilityHours, f);
                          // if time slot has started


                      if (isReservationBooked(
                          currentRes: e,
                          reservations: cancelledReservations,
                          currentSlot: f,
                          reservationTimeSlots: retrieveReservationTimeSlots(
                              cancelledReservations, e))) {
                        return Container();
                        /// unavailable res slot
                      } else if (isReservationUnavailable || (f.slotRange.start.isBefore(DateTime.now()))) {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: model.paletteColor.withOpacity(0.86),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible: f.slotRange.start.isAfter(DateTime.now()) && isRemovingReservation,
                                  child: IconButton(
                                      onPressed: () {
                                        didSelectCancelResSlot(f, e);
                                      },
                                      icon:  Icon(Icons.cancel), color: model.accentColor, padding: EdgeInsets.zero
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.edit_calendar_outlined, color: model.accentColor,),
                                SizedBox(width: 5),
                                // if (retrieveHourToUpdate(e.selectedSlots, f.start.hour) == f.start.hour) Text('${AppLocalizations.of(context)!.profileFacilitySlotTime}: ${DateFormat.jm().format(f.start)} - ${DateFormat.jm().format(f.start.add(Duration(minutes: 60)))}', style: TextStyle(color: model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis) else
                                Text('$profileFacilitySlotTime: ${DateFormat.jm().format(f.slotRange.start)} - ${DateFormat.jm().format(f.slotRange.end)}', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold, decoration: (f.slotRange.start.isBefore(DateTime.now())) ? TextDecoration.lineThrough : null), overflow: TextOverflow.ellipsis),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text('Unavailble', style: TextStyle(color: model.accentColor), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                )
                              ],
                            ),
                          ),
                        );
                      } else {

                      return Container(
                        height: 40,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(
                                visible: f.slotRange.start.isAfter(DateTime.now()) && isRemovingReservation,
                                child: IconButton(
                                    onPressed: () {
                                      didSelectCancelResSlot(f, e);
                                    },
                                    icon:  Icon(Icons.cancel), color: model.paletteColor, padding: EdgeInsets.zero
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.calendar_today_outlined, color: model.paletteColor,),
                              SizedBox(width: 5),
                              // if (retrieveHourToUpdate(e.selectedSlots, f.start.hour) == f.start.hour) Text('${AppLocalizations.of(context)!.profileFacilitySlotTime}: ${DateFormat.jm().format(f.start)} - ${DateFormat.jm().format(f.start.add(Duration(minutes: 60)))}', style: TextStyle(color: model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis) else
                              Text('$profileFacilitySlotTime: ${DateFormat.jm().format(f.slotRange.start)} - ${DateFormat.jm().format(f.slotRange.end)}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, decoration: (f.slotRange.start.isBefore(DateTime.now())) ? TextDecoration.lineThrough : null), overflow: TextOverflow.ellipsis),
                              SizedBox(width: 5),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  ).toList()
                )
              ],
            ),
          )
      ),
    ),
  );
}

Widget reservationSelectionHeader(
    BuildContext context,
    DashboardModel model,
    bool isPerSlotBased,
    bool showSpaceType,
    ReservationSlotItem? selectedRes,
    ReservationTimeFeeSlotItem? selectedResTimeSlot,
    Map<String, List<ReservationSlotItem>> reservations,
    {required Function(ReservationSlotItem) didSelectRes,
    required Function(ReservationSlotItem, ReservationTimeFeeSlotItem) didSelectResTime,
    }) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        for (var entry in reservations.entries.toList()..sort((a,b) => b.key.compareTo(a.key)))

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: showSpaceType,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getSpaceTypeOptions(context).where((i) => i.uid.getOrCrash() == entry.key).first.spaceTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),
                      const SizedBox(height: 8),
                ],
              ),
            ),

           if (!(isPerSlotBased)) Row(
              children: entry.value.map(
                      (e) {
                        late bool isSelected = e == selectedRes;

                          return InkWell(
                            onTap: () {
                              didSelectRes(e);
                            },
                            child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: (isSelected) ? model.paletteColor : Colors.transparent),
                            ),
                              child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: model.paletteColor.withOpacity(0.075),
                                        borderRadius: BorderRadius.all(Radius.circular(25),
                                        )
                                    ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${DateFormat.MMMEd().format(e.selectedDate)} X ${e.selectedSlots.length}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 5),
                                        Icon(Icons.calendar_today_outlined, size: 20, color: model.paletteColor),
                              ],
                            ),
                          )
                        )
                      )
                    )
                  );
                }
              ).toList()
            ),


            if (isPerSlotBased) Row(
              children: entry.value.map(
                      (e) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(DateFormat.MMMEd().format(e.selectedDate), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            ...e.selectedSlots.map((f) {

                              bool isSelected = f == selectedResTimeSlot;

                                return InkWell(
                                  onTap: () {
                                    didSelectResTime(e,f);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(color: (isSelected) ? model.paletteColor : Colors.transparent),
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: model.paletteColor.withOpacity(0.075),
                                                  borderRadius: BorderRadius.all(Radius.circular(25),
                                                  )
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(9.0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${DateFormat.jm().format(f.slotRange.start)} - ${DateFormat.jm().format(f.slotRange.end)}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                                                    const SizedBox(width: 5),
                                                    Icon(Icons.calendar_today_outlined, size: 20, color: model.paletteColor),
                                            ],
                                          ),
                                        )
                                      )
                                    )
                                  )
                                );
                            }).toList()
                          ],
                        );
                      }
              ).toList(),
            )
          ],
        ),
      ]
    )
  );
}

Widget reservationDatesWrapped(
    BuildContext context,
    DashboardModel model,
    Map<String, List<ReservationSlotItem>> reservations
    ) {

  return Wrap(
    children: [
      for (var entry in reservations.entries.toList()..sort((a,b) => b.key.compareTo(a.key)))

        Wrap(
          children: entry.value.map(
                  (e) {
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(45),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: model.paletteColor.withOpacity(0.025),
                                borderRadius: BorderRadius.all(Radius.circular(45))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(child: Text('${DateFormat.MMMEd().format(e.selectedDate)} ·', style: TextStyle(fontSize: 15, color: model.disabledTextColor, fontWeight: FontWeight.bold, overflow: TextOverflow.fade), maxLines: 1)),
                                  const SizedBox(width: 5),
                                  ...groupConsecutiveSlots(e.selectedSlots).map((f) => (isFullDaySlot(f)) ? Text('All Day', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, overflow: TextOverflow.fade, fontSize: 15), maxLines: 1,) : Text('${DateFormat.jm().format(f.slotRange.start)} - ${DateFormat.jm().format(f.slotRange.end)}', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, overflow: TextOverflow.fade, fontSize: 15), maxLines: 1,),
                                  ).toList(),
                                  const SizedBox(width: 10),
                                  Icon(Icons.calendar_today_outlined, size: 24, color: model.disabledTextColor),
                      ],
                    ),
                  )
                )
              )
            );
          }
        ).toList()
      ),
    ],
  );
}

