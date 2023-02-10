part of check_in_presentation;

/// steps for processing reservations
enum ReservationStepsMarker {listingUnavailable, listingDetails, selectDates, addAdditionalDetails, selectFromPaymentMethods, addPaymentMethod, processPayment}
enum ReservationMobileCreateNewMarker {listingDetails, additionalDetails, paymentReview, listingNoLongerAvailable}


class NewReservationModel {

  final ReservationMobileCreateNewMarker markerItem;
  final Widget childWidget;


  NewReservationModel({required this.markerItem, required this.childWidget});

}

/// --------------------------------------------
/// retrieve day option item to display hours
DayOptionItem getDayOptionFromList(List<DayOptionItem> dayOption, int day) {
  if (dayOption.isNotEmpty) {
    if (dayOption.map((e) => e.dayOfWeek).contains(day)) {
      return dayOption.firstWhere((element) => element.dayOfWeek == day);
    }
    return dayOption[0];
  } else {
    return DayOptionItem.empty();
  }
}

/// --------------------------------------------
/// helper functions for reservation calendar
/// on init select one space option and space type


/// generate live calendar with information on booked and unbooked slots in real-time
List<ReservationTimeFeeSlotItem> getLiveCalendarList({
  required DashboardModel model,
  required String fee,
  required String currency,
  required int durationType,
  required int minHour,
  required int maxHour,
  required List<int> weekDaysToRemove,
  required DateTime currentDateTime,
  required List<PricingRuleSettings> pricingRulesSettings,
  required bool isPricingRuleFixed,
  required DateTimeRange startEnd,
  required ReservationFormState state}) {


  var numberFormat = NumberFormat('#,##0.00', currency);
  List<ReservationTimeFeeSlotItem> listForCalendar = [];

  for (DateTime generateDates in getSlotsForDate(currentDateTime, state.currentSelectedSpaceOption?.availabilityHoursSettings?.endHour.toInt(), state.currentSelectedSpaceOption?.availabilityHoursSettings?.startHour.toInt(), durationType, [])) {
    listForCalendar.add(ReservationTimeFeeSlotItem(fee: '${NumberFormat.simpleCurrency(locale: currency).currencySymbol}${numberFormat.format(double.parse(getPricingForSlot(pricingRulesSettings, isPricingRuleFixed, fee, state))/STRIPE_FEE_TO_CENTS)} ${NumberFormat.simpleCurrency(locale: currency).currencyName ?? ''}', slotRange: DateTimeRange(start: generateDates, end: generateDates.add(Duration(minutes: durationType)))));
  }

  listForCalendar.sort((a, b) => a.slotRange.start.compareTo(b.slotRange.start));


  for (DateTime blockedDates in getAvailabilityHoursTimeRegion(
      model,
      durationType,
      DateTimeRange(start: startEnd.start, end: startEnd.end),
      state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours ?? []).where((element) => element.text == 'Blocked').map((e) => e.startTime)) {

    if (listForCalendar.map((e) => e.slotRange.start).contains(blockedDates)) {
      final index = listForCalendar.map((e) => e.slotRange.start).toList().indexOf(blockedDates);
      listForCalendar.removeAt(index);
    }

  }

  /// update inserted times based on Calendar - TimeRegions

  /// update start and end time of the day based on settings
  listForCalendar.where((element) => (element.slotRange.start.hour + element.slotRange.start.minute) > (minHour));
  listForCalendar.where((element) => (element.slotRange.end.hour + element.slotRange.end.minute) < (maxHour));


  /// remove weekday based on settings
  for (int day in weekDaysToRemove) {
    listForCalendar.removeWhere((element) => element.slotRange.start.weekday == day);
  }

  return listForCalendar;
}


/// Retrieve Dates that are closed
List<DateTime> getClosedDatesForCalendar(
    DashboardModel model,
    ReservationFormState state,
    int durationType,
    DateTimeRange startEnd,
    ) {
  List<DateTime> listForCalendar = [];

  for (DateTime closedDates in getAvailabilityHoursTimeRegion(model, durationType, DateTimeRange(start: startEnd.start, end: startEnd.end), state.currentSelectedSpaceOption?.availabilityHoursSettings?.availabilityPeriod.hoursOpen.openHours.where((element) => element.isClosed).toList() ?? []).where((element) => element.text == 'Blocked').map((e) => e.startTime)) {
    listForCalendar.add(closedDates);
  }
  return listForCalendar;
}



/// Retrieve current session selected dates
List<ReservationTimeFeeSlotItem> getSelectedDates(List<ReservationSlotItem> reservations, ReservationFormState state, DateTime currentDateTime) {
  List<ReservationTimeFeeSlotItem> selected = [];

  if (reservations.where(
          (element) =>
      element.selectedActivityType == (state.currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId) &&
          element.selectedDate == (currentDateTime) &&
          element.selectedSpaceId == (state.currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId) &&
          element.selectedSportSpaceId == state.currentSelectedSpaceOption?.spaceId
  ).isNotEmpty) {
    selected.addAll(reservations.firstWhere(
            (element) => element.selectedActivityType == (state.currentListingActivityOption?.activity.activityId ?? FacilityActivityCreatorForm.empty().activity.activityId) &&
            element.selectedDate == (currentDateTime) &&
            element.selectedSpaceId == (state.currentSelectedSpace?.uid ?? ReservationSlotItem.empty().selectedSpaceId) &&
            element.selectedSportSpaceId == state.currentSelectedSpaceOption?.spaceId
    ).selectedSlots);
  }

  return selected;
}


/// --------------------------------------------
/// Helper functions for Pricing and Payment Details
/// Retrieve slot pricing
String getPricingForSlot(List<PricingRuleSettings> pricingList, bool isDynamicPricing, String defaultPricing, ReservationFormState state) {
  return (!(isDynamicPricing) && pricingList.map((e) => e.spaceId).contains(state.currentSelectedSpaceOption?.spaceId) ?
  pricingList.firstWhere((element) => element.spaceId == state.currentSelectedSpaceOption?.spaceId).defaultPricingRate.toString() : defaultPricing);
}



/// retrieve current number of selected slots
int numberOfSlotsSelected(List<ReservationSlotItem> allSlots) {
  int slotCount = 0;

  for (ReservationSlotItem slot in allSlots) {
    slotCount += slot.selectedSlots.length;
  }
  return slotCount;
}


/// retrieve reservation item with reservations that have already passed only
List<ReservationSlotItem> getReservationsForPastDatesOnly(List<ReservationSlotItem> original) {
  List<ReservationSlotItem> reservations = [];

  for (ReservationSlotItem slot in original) {
    reservations.add(ReservationSlotItem(
          selectedActivityType: slot.selectedActivityType,
          selectedSportSpaceId: slot.selectedSportSpaceId,
          selectedSpaceId: slot.selectedSpaceId,
          selectedDate: slot.selectedDate,
          selectedSlots: []
      ));

      final List<ReservationTimeFeeSlotItem> timeSlots = [];
      timeSlots.addAll(slot.selectedSlots);
      timeSlots.removeWhere((element) => element.slotRange.start.isAfter(DateTime.now()));
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

/// retrieve reservation item with reservations that have yet to start only
List<ReservationSlotItem> getReservationsForFutureDatesOnly(List<ReservationSlotItem> original) {
  List<ReservationSlotItem> reservations = [];

  for (ReservationSlotItem slot in original) {
    reservations.add(ReservationSlotItem(
        selectedActivityType: slot.selectedActivityType,
        selectedSportSpaceId: slot.selectedSportSpaceId,
        selectedSpaceId: slot.selectedSpaceId,
        selectedDate: slot.selectedDate,
        selectedSlots: []
    ));

    final List<ReservationTimeFeeSlotItem> timeSlots = [];
    timeSlots.addAll(slot.selectedSlots);
    timeSlots.removeWhere((element) => element.slotRange.start.isBefore(DateTime.now()));
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

/// --------------------------------------------
/// Helper functions for container navigation and form completion
bool checkCompletion(ReservationStepsMarker page, ReservationFormState state) {
  switch (page) {
    case ReservationStepsMarker.listingUnavailable:
    // TODO: Handle this case.
      break;
    case ReservationStepsMarker.selectDates:

      return (getTotalPriceDouble(state.newFacilityBooking.reservationSlotItem, state.newFacilityBooking.cancelledSlotItem ?? []) != 0);
    case ReservationStepsMarker.addAdditionalDetails:
      return true;
    case ReservationStepsMarker.addPaymentMethod:
      return true;
    case ReservationStepsMarker.processPayment:
    // TODO: Handle this case.
      break;
    case ReservationStepsMarker.selectFromPaymentMethods:
      return (state.cardItem != null);
  }
  return false;
}



enum RepeatType {daily, weekly, monthly}

RepeatType getRepeatType(String type) {
  for (RepeatType item in RepeatType.values) {
    if (type == item.toString()) {
      return item;
    }
  }
  return RepeatType.daily;
}

Map<String, List<ReservationSlotItem>> getGroupOfSelectedReservations(List<ReservationSlotItem> list) {
  Map<String, List<ReservationSlotItem>> selection = HashMap<String, List<ReservationSlotItem>>();

  for (ReservationSlotItem item in list) {
    selection.putIfAbsent('${item.selectedDate.toString()}${item.selectedSideOption}', () => []).add(item);
  }
  return selection;
}