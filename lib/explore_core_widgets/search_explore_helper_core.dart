part of check_in_presentation;

class ExploreWebHelperCore {

  static late bool isLoading = false;
  // static late bool selectedListing = false;
  // static late bool selectedSearch = false;
  static late ExploreFilterObject? currentFilterObject = null;
  static SearchExploreHelperMarker searchExploreMarker = SearchExploreHelperMarker.search;
  static UniqueId? currentFacilityItemId = null;
  static UniqueId? currentReservationItemId = null;
  static late ListingManagerForm? selectedFacilityItem = null;
  static late ReservationItem? selectedReservationItem = null;


  static void didSelectFacilityItem(BuildContext context, ListingManagerForm listing) {
    ExploreWebHelperCore.isLoading = true;
    // ExploreWebHelperCore.selectedSearch = false;
    searchExploreMarker = SearchExploreHelperMarker.listing;
    ExploreWebHelperCore.selectedFacilityItem = listing;
    ExploreWebHelperCore.currentFacilityItemId = listing.listingServiceId;
    ExploreWebHelperCore.selectedReservationItem = null;
    ExploreWebHelperCore.currentReservationItemId = null;

    Beamer.of(context).update(
        configuration: RouteInformation(
            location: searchedListingRoute(listing.listingServiceId.getOrCrash())
        ),
        rebuild: false
    );
  }

  static void didSelectReservationItem(BuildContext context, ListingManagerForm? listing, ReservationItem reservation) {
    ExploreWebHelperCore.isLoading = true;
    searchExploreMarker = SearchExploreHelperMarker.activity;
    ExploreWebHelperCore.selectedFacilityItem = listing;
    ExploreWebHelperCore.currentFacilityItemId = reservation.instanceId;
    ExploreWebHelperCore.selectedReservationItem = reservation;
    ExploreWebHelperCore.currentReservationItemId = reservation.reservationId;

    Beamer.of(context).update(
        configuration: RouteInformation(
            location: searchedReservationRoute(reservation.instanceId.getOrCrash(), reservation.reservationId.getOrCrash())
        ),
      rebuild: false
    );
  }
}

