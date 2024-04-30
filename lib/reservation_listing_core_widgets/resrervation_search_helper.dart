part of check_in_presentation;

List<ReservationSlotItem> getReservationSlotItemForSearch(
    BuildContext context,
    List<ReservationTimeFeeSlotItem> slots,
    UniqueId? activityId,
    UniqueId? spaceId,
    UniqueId? sportSpaceId,
    String? spaceTitle,
    ) {

  List<ReservationSlotItem> newItems = [];

  newItems.addAll(slots.map(
          (e) => DateTime(e.slotRange.start.year, e.slotRange.start.month, e.slotRange.start.day))
      .toSet()
      .toList().map(
          (e) => ReservationSlotItem(
          selectedActivityType: activityId ?? getActivityOptions()[0].activityId,
          selectedSportSpaceId: sportSpaceId,
          selectedSpaceId: spaceId ?? UniqueId(),
          selectedDate: e,
          selectedSideOption: spaceTitle,
          selectedSlots: slots.where((element) => element.slotRange.start.year == e.year && element.slotRange.start.month == e.month && element.slotRange.start.day == e.day).toList())).toList());

  return newItems;
}