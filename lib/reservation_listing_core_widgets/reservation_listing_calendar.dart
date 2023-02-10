part of check_in_presentation;

Widget selectedCalendarDatesSlotReservations(DashboardModel model, DateTime initialSelection, List<DateTime> blockedDates, DateRangePickerController? dateRangePicker, DateTimeRange startEndTime, {required Function(DateTime) selectedDateTime}) {

  /// setup calendar list with specific available reservation dates
  /// remove dates that are blocked based on open hours
  /// remove dates that are blocked based on visible hours & week days (based on calendar settings)
  /// remove dates that are manually blocked out
  /// remove dates that are already reserved and therefore should be blocked out

  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              // color: model.cardColor,
            ),
            height: 135,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SfDateRangePicker(
                initialSelectedDate: initialSelection,
                view: DateRangePickerView.month,
                selectionColor: model.paletteColor,
                allowViewNavigation: false,
                navigationMode: DateRangePickerNavigationMode.snap,
                navigationDirection: DateRangePickerNavigationDirection.horizontal,
                enablePastDates: true,
                showNavigationArrow: true,
                controller: dateRangePicker,
                minDate: startEndTime.start,
                maxDate: startEndTime.end,
                selectionMode: DateRangePickerSelectionMode.single,
                headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)
                ),
                headerHeight: 40,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  viewHeaderHeight: 40,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(color: model.disabledTextColor)
                  ),
                  dayFormat: 'EEE',
                  blackoutDates: blockedDates,
                  numberOfWeeksInView: 1,
                ),
                todayHighlightColor: model.paletteColor,
                monthCellStyle: DateRangePickerMonthCellStyle(
                todayCellDecoration: BoxDecoration(
                color: model.paletteColor.withOpacity(0.15),
                shape: BoxShape.circle
                ),
                textStyle: TextStyle(color: model.paletteColor),
                todayTextStyle: TextStyle(
                  color: model.paletteColor,
                  fontWeight: FontWeight.bold
                ),
                  blackoutDatesDecoration: BoxDecoration(
                      color: model.accentColor,
                      shape: BoxShape.circle
                  ),
                  blackoutDateTextStyle: TextStyle(color: model
                      .disabledTextColor, decoration: TextDecoration.lineThrough),
                ),
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is DateTime) {
                    final DateTime day = args.value as DateTime;
                    selectedDateTime(DateTime(day.year, day.month, day.day));
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}



/// FILTERS FOR DATES TO SHOW
bool blockedOutDate(DateTime currentDate, List<ReservationItem> reserved, UniqueId spaceId) {
  for (ReservationItem reservation in reserved) {
    for (ReservationSlotItem slotItem in reservation.reservationSlotItem) {
      if (slotItem.selectedSportSpaceId == spaceId) {
        if (slotItem.selectedSlots.map((e) => e.slotRange.start).contains(
            currentDate)) {
          return true;
        }
      }
    }
  }
  return currentDate.isBefore(DateTime.now());
}


bool highlightSelectedDates(List<DateTime> selected, DateTime date) {
  return selected.contains(date);
}


Widget calendarListOfSelectableReservations(
    BuildContext context,
    DashboardModel model,
    int durationType, List<ReservationItem>
    reservations, UniqueId currentSpaceOption,
    List<ReservationTimeFeeSlotItem> listOfReservationOptions,
    List<ReservationTimeFeeSlotItem> listOfSelectedReservations,
    bool isRepeatShown,
    String slotTimeString,
    String addLocationString,
    {required Function(ReservationTimeFeeSlotItem) selectedReservation}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          // color: model.cardColor,
        ),
        width: 600,
        height: 475,
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              direction: Axis.horizontal,
              children: listOfReservationOptions.map(
                      (e) => IgnorePointer(
                        ignoring: blockedOutDate(e.slotRange.start, reservations, currentSpaceOption),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            // width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start) ? blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? model.webBackgroundColor : model.paletteColor : Colors.transparent,
                              border: Border.all(width: 1, color: highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start) ? model.webBackgroundColor : blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? model.disabledTextColor : model.paletteColor)
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
                                selectedReservation(e);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("$slotTimeString: ${DateFormat.jm().format(e.slotRange.start)} - ${DateFormat.jm().format(e.slotRange.start.add(Duration(minutes: durationType)))}",
                                            style: TextStyle(color: highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start) ? model.webBackgroundColor : blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? model.disabledTextColor : model.paletteColor, fontSize: 16.5, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                          Text("Price: ${e.fee}", style: TextStyle(color: highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start) ? model.webBackgroundColor : blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? model.disabledTextColor : model.paletteColor), overflow: TextOverflow.ellipsis)
                                        ],
                                      ),
                                    ),

                                    Visibility(
                                      visible: !(highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color: blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? model.accentColor : Colors.transparent,
                                            border: blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? null : Border.all(width: 1, color: model.paletteColor)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(addLocationString, style: TextStyle(color: highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start) ? model.webBackgroundColor : blockedOutDate(e.slotRange.start, reservations, currentSpaceOption) ? model.disabledTextColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),

                                    Visibility(
                                        visible: highlightSelectedDates(listOfSelectedReservations.map((e) => e.slotRange.start).toList(), e.slotRange.start),
                                        child: Icon(Icons.cancel, color: model.webBackgroundColor, size: 35)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                )
              ).toList(),
            ),
          ),
        ),
      ),

      Visibility(
        visible: isRepeatShown,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Available Dates', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
            SizedBox(height: 10),
            Container(
              width: 300,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                      offset: const Offset(-10,-15),
                      isDense: true,
                      buttonElevation: 0,
                      buttonDecoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      customButton: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: model.accentColor,
                          border: Border.all(color: model.disabledTextColor),
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.normal),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.keyboard_arrow_down_rounded, color: model.paletteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onChanged: (Object? navItem) {
                      },
                      buttonWidth: 80,
                      buttonHeight: 70,
                      dropdownElevation: 1,
                      dropdownPadding: const EdgeInsets.all(1),
                      dropdownDecoration: BoxDecoration(
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(0, 2)
                          )
                          ],
                          color: model.accentColor,
                          border: Border.all(color: model.disabledTextColor),
                          borderRadius: BorderRadius.circular(20)),
                      itemHeight: 50,
                      // dropdownWidth: mainWidth,
                      focusColor: Colors.grey.shade100,
                      items: RepeatType.values.map(
                              (e) {
                            return DropdownMenuItem<RepeatType>(
                                onTap: () {

                                },
                                value: e,
                                child: Text(e.toString(), style: TextStyle(color: model.disabledTextColor))
                            );
                          }
                      ).toList()
                  )
              ),
            ),
          ],
        ),
      )

    ],
  );
}


/// SUMMARY LIST BASED ON SELECTIONS



Widget selectedCalendarDatesRepeatSlots() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      ],
    ),
  );
}


Widget selectedCalendarDatesSessions() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      ],
    ),
  );
}

