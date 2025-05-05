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
                backgroundColor: model.accentColor,
                initialSelectedDate: initialSelection,
                view: DateRangePickerView.month,
                selectionColor: model.paletteColor,
                allowViewNavigation: true,
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
                    backgroundColor: model.accentColor,
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
  int durationType,
  List<ReservationItem> reservations,
  UniqueId currentSpaceOption,
  List<ReservationTimeFeeSlotItem> listOfReservationOptions,
  List<ReservationTimeFeeSlotItem> listOfSelectedReservations,
  bool isRepeatShown,
  String slotTimeString,
  String addLocationString,
  {required Function(ReservationTimeFeeSlotItem) selectedReservation}
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final crossAxisCount = kIsWeb ? 2 : 1; // At least 2 columns on web
      final double childAspectRatio = (kIsWeb ? 3 : 3); // Adjust aspect ratio based on platform

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Container with GridView
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            width: constraints.maxWidth,
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listOfReservationOptions.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final e = listOfReservationOptions[index];
                final isBlocked = blockedOutDate(e.slotRange.start, reservations, currentSpaceOption);
                final isSelected = highlightSelectedDates(
                  listOfSelectedReservations.map((e) => e.slotRange.start).toList(),
                  e.slotRange.start,
                );

                return IgnorePointer(
                  ignoring: isBlocked,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: isSelected
                          ? (isBlocked ? model.webBackgroundColor : model.paletteColor)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? model.webBackgroundColor
                            : (isBlocked ? model.disabledTextColor : model.paletteColor),
                        width: 1,
                      ),
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered)) {
                              return model.paletteColor.withOpacity(0.1);
                            }
                            return Colors.transparent;
                          },
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () => selectedReservation(e),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Flexible(
                              child: Text(
                                "$slotTimeString: ${DateFormat.jm().format(e.slotRange.start)} - ${DateFormat.jm().format(e.slotRange.start.add(Duration(minutes: durationType)))}",
                                style: TextStyle(
                                  color: isSelected
                                      ? model.webBackgroundColor
                                      : (isBlocked
                                          ? model.disabledTextColor
                                          : model.paletteColor),
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Price: \$0.00",
                                style: TextStyle(
                                  color: isSelected
                                      ? model.webBackgroundColor
                                      : (isBlocked
                                          ? model.disabledTextColor
                                          : model.paletteColor),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Additional Section for Repeat Options
          if (isRepeatShown)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Available Dates',
                    style: TextStyle(
                      color: model.disabledTextColor,
                      fontSize: model.secondaryQuestionTitleFontSize,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 300,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isDense: true,
                      items: RepeatType.values.map((e) {
                        return DropdownMenuItem<RepeatType>(
                          value: e,
                          child: Text(
                            e.toString(),
                            style: TextStyle(color: model.disabledTextColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ],
            ),
        ],
      );
    },
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

