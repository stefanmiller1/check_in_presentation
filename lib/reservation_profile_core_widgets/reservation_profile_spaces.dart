part of check_in_presentation;


List<SpaceOptionSizeDetail> retrieveReservationSpacesFromListing(ReservationItem reservationItem, ListingManagerForm listing) {

  final List<SpaceOptionSizeDetail> reservationSpaces = [];

  for (UniqueId spaceId in reservationItem.reservationSlotItem.map((e) => e.selectedSportSpaceId ?? UniqueId())) {
    for (SpaceOption spaceOptions in listing.listingProfileService.spaceSetting.spaceTypes.getOrCrash()) {
      for (SpaceOptionSizeDetail spaceDetail in spaceOptions.quantity.where((element) => element.spaceId == spaceId)) {
          if (!(reservationSpaces.map((e) => e.spaceId).contains(spaceId))) {
          reservationSpaces.add(spaceDetail);
        }
      }
    }
  }

  // print(reservationSpaces);
  return reservationSpaces;

}

