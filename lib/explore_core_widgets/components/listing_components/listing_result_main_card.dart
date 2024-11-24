// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_components/listing_result_main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
part of check_in_presentation;

class ListingResultMainCard extends StatefulWidget {

  final bool isLoading;
  final ListingManagerForm listing;
  final DashboardModel model;
  final UserProfileModel? currentUser;
  final bool showReservations;
  final Function(ListingManagerForm listing) didSelectFooter;
  final Function(ListingManagerForm listing) didSelectMainImage;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes;

  const ListingResultMainCard({super.key, required this.isLoading, required this.model, this.currentUser, required this.listing, required this.didSelectMainImage, required this.didSelectFooter, required this.didSelectEmbeddedRes, required this.showReservations});

  @override
  State<ListingResultMainCard> createState() => _ListingResultMainCardState();
}

class _ListingResultMainCardState extends State<ListingResultMainCard> {

  late SpaceOptionSizeDetail? currentSpaceOption = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.model.mobileBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: 'image_hero',
                child: ListingResultMain(
                  showReservations: widget.showReservations,
                  listing: widget.listing,
                  isLoading: widget.isLoading,
                  model: widget.model,
                  didSelectEmbeddedRes: (listing, res) => widget.didSelectEmbeddedRes(listing, res),
                  didSelectListingItem: (listing) => widget.didSelectMainImage(listing),
                  didChangeSpaceOptionItem: (SpaceOptionSizeDetail space) {
                    setState(() {
                      currentSpaceOption = space;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                height: 125,
                width: MediaQuery.of(context).size.width,
                child: widget.isLoading ? isLoading() : retrievedListingsFooter(
                    context,
                    widget.model,
                    widget.listing,
                    currentSpaceOption,
                    true,
                    didTap: () {
                      setState(() {
                        widget.didSelectFooter(widget.listing);
                    });
                })
            ),
          ],
        ),
      ),
    );
  }

  Widget isLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 15,
              ),
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 18,
                    width: 75,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }


  // Widget getDetailsForListing(BuildContext context) {
  //   return BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
  //       builder: (context, state) {
  //         return state.maybeMap(
  //             loadAllPublicListingItemsSuccess: (e) => (e.items.map((e) => e.listingServiceId).contains(UniqueId.fromUniqueString(widget.marker.markerId.value))) ? retrievedListings(context, e.items.firstWhere((element) => element.listingServiceId == UniqueId.fromUniqueString(widget.marker.markerId.value))) : cannotFindAnyListingsHeader(),
  //             loadAllPublicListingItemsFailure: (e) => cannotFindAnyListingsHeader(),
  //             orElse: () => cannotFindAnyListingsHeader());
  //     }
  //   );
  // }
  //

}