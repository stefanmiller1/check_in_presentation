part of check_in_presentation;

class FacilityActivityProgramming extends StatefulWidget {

  final DashboardModel model;
  final UniqueId currentUserId;
  final ListingManagerForm listing;
  final List<ReservationItem> reservations;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectReservation;
  
  const FacilityActivityProgramming({super.key, required this.reservations, required this.model, required this.currentUserId, required this.listing, required this.didSelectReservation});

  @override
  State<FacilityActivityProgramming> createState() => _FacilityActivityProgrammingState();
}

class _FacilityActivityProgrammingState extends State<FacilityActivityProgramming> {

  late SpaceOptionSizeDetail? currentSpaceOption = null;

  // List<SearchExploreItem> createListItemsForReservations(List<ReservationItem> reservations) {
  //
  //   final List<SearchExploreItem> searchItems = [];
  //   searchItems.clear();
  //
  //   for (ReservationItem reservation in reservations) {
  //     final listingToAdd = SearchExploreItem(
  //       exploreItemId: reservation.reservationId,
  //       exploreItemSubId: reservation.instanceId,
  //       userId: reservation.reservationOwnerId,
  //       exploreType: SearchExploreType.activity
  //     );
  //     searchItems.add(listingToAdd);
  //   }
  //   return searchItems;
  // }
  
  @override
  Widget build(BuildContext context) {
    // if (widget.reservations.where((element) => element.isInternalProgram == true || element.reservationOwnerId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        
      );
    // }
    // return Column(
    //   children: [
    //     if (kIsWeb) const SizedBox(height: 80),
    //     if (!(kIsWeb)) const SizedBox(height: 155),
    //     Wrap(
    //       alignment: WrapAlignment.center,
    //       spacing: 18.0,
    //       children: createListItemsForReservations(widget.reservations.where((element) => element.isInternalProgram == true || element.reservationOwnerId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).toList()).map(
    //           (e) {
    //               return getSearchComponentListItem(
    //                   context,
    //                   widget.model,
    //                   widget.currentUserId,
    //                   e.exploreType,
    //                   widget.listing,
    //                   widget.reservations.where((element) => element.reservationId == e.exploreItemId).isNotEmpty ? widget.reservations.where((element) => element.reservationId == e.exploreItemId).first : null,
    //                   currentSpaceOption,
    //                   didSelectListing: (listing) {
    //
    //                   },
    //                   didSelectReservation: (listing, res) {
    //                   if (listing != null) {
    //                     widget.didSelectReservation(listing, res);
    //                   }
    //                 },
    //                   currentSpaceOptionSizeDetail: (space) {
    //                     setState(() {
    //                       currentSpaceOption = space;
    //                     });
    //                   }
    //               );
    //           }
    //       ).toList(),
    //     ),
    //     Container(
    //       height: 120,
    //     )
    //   ],
    // );
  }
}