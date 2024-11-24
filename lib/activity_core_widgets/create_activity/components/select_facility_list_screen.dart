part of check_in_presentation;


class SelectFacilityListScreen extends StatelessWidget {

  final DashboardModel model;
  final ListingManagerForm? selectedListing;
  final UserProfileModel currentUser;
  final Function(ListingManagerForm) didSelectListing;

  const SelectFacilityListScreen({super.key, required this.model, required this.currentUser, required this.didSelectListing, this.selectedListing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsSearchStarted([ManagerListingStatusType.finishSetup], null, null, null)),
        child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadAllSearchedPublicListingItemsSuccess: (e) => getListingsSelectionList(context, e.items),
                orElse: () => Container()
          );
        },
      )
    );
  }

  Widget getListingsSelectionList(BuildContext context, List<ListingManagerForm> listings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Pick Your Space!', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), textAlign: TextAlign.center),
            ),
            Text('Select at least one Space to continue..or..', style: TextStyle(color: model.disabledTextColor)),
            const SizedBox(height: 8),

            /// request a new space
            InkWell(
              onTap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'hello@cincout.ca',
                  query: encodeQueryParameters(<String, String>{
                    'subject':'Hello! - New Space Request',
                    'body': 'I have a space i\'d like to add to the map! - \nAddress & postal code*: , \nName*: , \nOwnerInfo (optional): \nWebsite: , \nAdditional info/Description: , \npaces Offered: , that\'s all the info I have.'
                  }),
                );

                if (await canLaunchUrl(params)) {
                  launchUrl(params);
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  color: model.paletteColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text('Request a New Space', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Text('What is the map?', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Places we\'ve hand picked and recognized as either vacant, adaptive or re-usable - this list is ${listings.length} long and growing!. if you dont\'nt see the space on the map (or own a space that you are offering up for use) please send us a request and we\'ll update the list for you', style: TextStyle(color: model.paletteColor)),

            const SizedBox(height: 18),
            Wrap(
              // spacing: 12,
              // runSpacing: 12,
              children: listings.asMap().map((i, e) {
                  return MapEntry(i, SlideInTransitionWidget(
                    durationTime: (i < 15) ? 300 * i : 0,
                    offset: Offset(0, 0.25),
                    transitionWidget: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: (e.listingServiceId == selectedListing?.listingServiceId) ? model.paletteColor : Colors.transparent)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 320,
                              width: 320,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.11),
                                        spreadRadius: 1,
                                        blurRadius: 15,
                                        offset: Offset(0, 2)
                                  )
                                ]
                              ),
                              child: ListingResultMainCard(
                                listing: e,
                                showReservations: false,
                                model: model,
                                isLoading: false,
                                didSelectEmbeddedRes: (listing, res) {

                                },
                                didSelectMainImage: (listing) {
                                  didSelectListing(listing);
                                },
                                didSelectFooter: (ListingManagerForm listing) {
                                  didSelectListing(listing);
                                },
                              ),
                            ),
                        ),
                      ),
                    ),
                  ),
                  );
                }
              ).values.toList(),
            ),
            const SizedBox(height: 80)
          ],
        ),
      ),
    );
  }

}