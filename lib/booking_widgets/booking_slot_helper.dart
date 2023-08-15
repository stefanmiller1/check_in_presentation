part of check_in_presentation;
/// change the border and type of current, requested, etc..


Map<String, List<ReservationSlotItem>> getGroupOfSelectedBookings(List<ReservationSlotItem> list) {
  Map<String, List<ReservationSlotItem>> selection = HashMap<String, List<ReservationSlotItem>>();

  for (ReservationSlotItem item in list) {
    selection.putIfAbsent('${item.selectedDate.toString()}${item.selectedSideOption}', () => []).add(item);
  }
  return selection;
}


Map<String, List<ReservationSlotItem>> getGroupBySpaceBookings(List<ReservationSlotItem> list) {
  Map<String, List<ReservationSlotItem>> selection = HashMap<String, List<ReservationSlotItem>>();

  for (ReservationSlotItem item in list) {
    selection.putIfAbsent(item.selectedSpaceId.value.fold((l) => '', (r) => r), () => []).add(item);
  }

  return selection;

}

List<String> getActiveSpaceSizes(SportSpaceOptions spaceSide) {
  List<String> activeSide = [];

  if (spaceSide.isHalfSizeOnly) {
    activeSide.add('TopHalf');
  } else if (spaceSide.isFullSizeOnly) {
    activeSide.add('Full');
  } else if (spaceSide.isBothFullHalf) {
    activeSide.add('Full');
  }
  return activeSide;
}
