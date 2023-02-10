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
    List<ReservationSlotItem> reservations,
    List<ReservationSlotItem> cancelledReservations,
    bool isRemovingReservation,
    String profileFacilitySlotTime,
    String profileFacilitySlotBookingLocation,
    String profileFacilitySlotBookingDate,
    {required Function(ReservationSlotItem) didSelectReservation,
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    visible: e.selectedSlots.isNotEmpty,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// *** Present if slot items is not empty *** ///
                        if (entry.value.map((e) => e.selectedSlots.isNotEmpty).contains(true)) IgnorePointer(
                          ignoring: e.selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1))),
                          child: Container(
                            decoration: BoxDecoration(
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


                                      // for (var f in e.selectedSlots.toList()..sort((a,b) => b.slotRange.start.compareTo(a.slotRange.start)))
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: e.selectedSlots.map((f) {

                                          if (checkIsReservationIsCancelled(
                                              currentRes: e,
                                              cancelledRes: cancelledReservations,
                                              currentSlot: f,
                                              cancelledSlot: retrieveCancelledSlot(
                                                  cancelledReservations, e))) {
                                            return Container();
                                          }

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
                                      ).toList()
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

              ...entry.value.map((e) => Padding(
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
              )
            )
          ],
        )
      ),



    ],
  );

}