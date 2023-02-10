part of check_in_presentation;


List<DateTime> getSlotsForDate(DateTime? selectedDate, int? openTo, int? openFrom, int selectedIntervalType, List<DateTime> bookedDates) {
  List<DateTime> _slotList = [];


  if (selectedDate != null) {
    DateTime dateTimeToStart = selectedDate.add(Duration(hours: openFrom ?? 7)).subtract(Duration(minutes: selectedIntervalType));
    int hoursOpenDuration = ((openTo ?? 17) - (openFrom ?? 7));
    DateTime dateTimeToEnd = dateTimeToStart.add(Duration(hours: hoursOpenDuration));
    Duration interval = Duration(minutes: selectedIntervalType);

    while(dateTimeToStart.millisecondsSinceEpoch < dateTimeToEnd.millisecondsSinceEpoch){
      dateTimeToStart = dateTimeToStart.add(interval);
      _slotList.add(dateTimeToStart);
    }
  }

  return _slotList;
}


List<TimeRegion> getAvailabilityHoursTimeRegion(DashboardModel model, int durationType, DateTimeRange startEndDate, List<DayOptionItem> hours) {
  final List<TimeRegion> availabilityRegions = [];

  for (MapEntry date in List<DateTime>.generate((24 * (60 ~/durationType)) * startEndDate.duration.inDays, (i) => DateTime.now()).asMap().entries) {

    final DateTime durationDate = (date.value as DateTime).roundMin.add(Duration(minutes: durationType * date.key as int));

    if (hours.map((e) => e.dayOfWeek).contains(durationDate.weekday)) {
      final DayOptionItem dayItem = hours.firstWhere((element) => element.dayOfWeek == durationDate.weekday);

      if (dayItem.isClosed) {
        availabilityRegions.add(TimeRegion(
            startTime: durationDate,
            endTime: (date.value as DateTime).roundMin.add(Duration(minutes: (durationType * date.key as int) + durationType)),
            enablePointerInteraction: true,
            color: model.accentColor.withOpacity(0.3),
            iconData: Icons.monetization_on_outlined,
            text: 'Blocked')
        );
      } else if (dayItem.isTwentyFourHour) {
        availabilityRegions.removeWhere((element) => element.startTime.day == dayItem.dayOfWeek);
      } else if (dayItem.hoursOpen.isNotEmpty){
        for (MapEntry openHours in dayItem.hoursOpen.asMap().entries) {

          if (openHours.key == 0) {
            if ((DateTime(durationDate.year, durationDate.month, durationDate.day, durationDate.hour, durationDate.minute).isBefore(DateTime(durationDate.year, durationDate.month, durationDate.day, openHours.value.start.hour, openHours.value.start.minute))) || (DateTime(durationDate.year, durationDate.month, durationDate.day, durationDate.hour, durationDate.minute).isAfter(DateTime(durationDate.year, durationDate.month, durationDate.day, dayItem.hoursOpen.last.end.hour, dayItem.hoursOpen.last.end.minute - 30)))) {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(minutes: (durationType * date.key as int) + durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Blocked')
              );
            } else {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(
                      minutes: (durationType * date.key as int) +
                          durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Fee')
              );
            }
          } else if (openHours.key == 1) {
            if ((DateTime(durationDate.year, durationDate.month, durationDate.day, durationDate.hour, durationDate.minute).isBetween(DateTime(durationDate.year, durationDate.month, durationDate.day, dayItem.hoursOpen[0].end.hour, dayItem.hoursOpen[0].end.minute), DateTime(durationDate.year, durationDate.month, durationDate.day,  openHours.value.start.hour, openHours.value.start.minute - 30))) ?? false) {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(minutes: (durationType * date.key as int) + durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Blocked')
              );
            } else {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(
                      minutes: (durationType * date.key as int) +
                          durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Fee')
              );
            }
          } else if (openHours.key == 2) {
            if ((DateTime(durationDate.year, durationDate.month, durationDate.day, durationDate.hour, durationDate.minute).isBetween(DateTime(durationDate.year, durationDate.month, durationDate.day, dayItem.hoursOpen[1].end.hour, dayItem.hoursOpen[1].end.minute), DateTime(durationDate.year, durationDate.month, durationDate.day,  openHours.value.start.hour, openHours.value.start.minute - 30))) ?? false) {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(minutes: (durationType * date.key as int) + durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Blocked')
              );
            } else {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(
                      minutes: (durationType * date.key as int) +
                          durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Fee')
              );
            }
          } else if (openHours.key == 3) {
            if ((DateTime(durationDate.year, durationDate.month, durationDate.day, durationDate.hour, durationDate.minute).isBetween(DateTime(durationDate.year, durationDate.month, durationDate.day, dayItem.hoursOpen[2].end.hour, dayItem.hoursOpen[2].end.minute), DateTime(durationDate.year, durationDate.month, durationDate.day,  openHours.value.start.hour, openHours.value.start.minute - 30))) ?? false) {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(minutes: (durationType * date.key as int) + durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Blocked')
              );
            } else {
              availabilityRegions.add(TimeRegion(
                  startTime: durationDate,
                  endTime: (date.value as DateTime).roundMin.add(Duration(
                      minutes: (durationType * date.key as int) +
                          durationType)),
                  enablePointerInteraction: true,
                  color: model.accentColor.withOpacity(0.3),
                  iconData: Icons.monetization_on_outlined,
                  text: 'Fee')
              );
            }
          }
        }
      }
    }
  }
  return availabilityRegions;
}