part of check_in_presentation;


class SelectFacilityListScreen extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm? selectedListing;
  final UserProfileModel currentUser;
  final Function(ListingManagerForm) didSelectListing;

  const SelectFacilityListScreen({super.key, required this.model, required this.currentUser, required this.didSelectListing, this.selectedListing});

  @override
  State<SelectFacilityListScreen> createState() => _SelectFacilityListScreenState();
}

class _SelectFacilityListScreenState extends State<SelectFacilityListScreen> {
  
  late ScrollController _scrollController;
  ListingManagerForm? currentSelectedFacility;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchSelectedUsersPublicListingsStarted([ManagerListingStatusType.finishSetup], widget.currentUser.userId.getOrCrash(), null)),
            child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
              builder: (context, state) {
                return state.maybeMap(
                  loadAllSelectedUsersPublicListingsSuccess: (e) => getPublicListingList(context, e.items),
                  orElse: () => getPublicListingList(context, [])
                );
              },
            ),
          ),

          Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: Column(
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: widget.model.webBackgroundColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text('Back', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (currentSelectedFacility != null) {
                                widget.didSelectListing(currentSelectedFacility!);
                              }
                            });
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: (currentSelectedFacility != null) ? widget.model.paletteColor : widget.model.accentColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text('Confirm Existing Location', style: TextStyle(color: (currentSelectedFacility != null) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget getPublicListingList(BuildContext context, List<ListingManagerForm> usersListing) {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsSearchStarted([ManagerListingStatusType.finishSetup], null, null, null)),
        child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadAllSearchedPublicListingItemsSuccess: (e) => getListingsSelectionList(context, usersListing, e.items),
                orElse: () => 
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'No facilities could be found. Please try again later or request a new space.',
                  style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          );
        },
      )
    );
  }

  Widget getListingsSelectionList(BuildContext context, List<ListingManagerForm> usersListings, List<ListingManagerForm> listings) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Pick Your Space!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
            ),
            Text('Select at least one Space to continue..or..', style: TextStyle(color: widget.model.disabledTextColor)),
            const SizedBox(height: 8),

            // /// request a new space
            // InkWell(
            //   onTap: () async {
            //     final Uri params = Uri(
            //       scheme: 'mailto',
            //       path: 'hello@cincout.ca',
            //       query: encodeQueryParameters(<String, String>{
            //         'subject':'Hello! - New Space Request',
            //         'body': 'I have a space i\'d like to add to the map! - \nAddress & postal code*: , \nName*: , \nOwnerInfo (optional): \nWebsite: , \nAdditional info/Description: , \npaces Offered: , that\'s all the info I have.'
            //       }),
            //     );

            //     if (await canLaunchUrl(params)) {
            //       launchUrl(params);
            //     }
            //   },
            //   child: Container(
            //     height: 50,
            //     width: double.infinity,
            //     constraints: BoxConstraints(maxWidth: 300),
            //     decoration: BoxDecoration(
            //       color: widget.model.paletteColor,
            //       borderRadius: BorderRadius.all(Radius.circular(25)),
            //     ),
            //     child: Center(
            //       child: Text('Request a New Space', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 8),

            // Text('What is the map?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 4),
            // Text('Places we\'ve hand picked and recognized as either vacant, adaptive or re-usable - this list is ${listings.length} long and growing!. if you dont\'nt see the space on the map (or own a space that you are offering up for use) please send us a request and we\'ll update the list for you', style: TextStyle(color: widget.model.paletteColor)),

            if (usersListings.isNotEmpty) ...[
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: widget.model.paletteColor,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Listing',
                        style: TextStyle(
                          color: widget.model.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.model.questionTitleFontSize,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Listings added by you',
                        style: TextStyle(
                          color: widget.model.accentColor,
                          fontSize: widget.model.secondaryQuestionTitleFontSize,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: usersListings.map((listing) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (currentSelectedFacility == listing) {
                                  currentSelectedFacility = null;
                                } else {
                                  currentSelectedFacility = listing;
                                }
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2 - 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                border: Border.all(
                                  color: (listing.listingServiceId == currentSelectedFacility?.listingServiceId)
                                      ? widget.model.accentColor
                                      : Colors.transparent,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 320,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.11),
                                        spreadRadius: 1,
                                        blurRadius: 15,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListingResultMainCard(
                                    listing: listing,
                                    showReservations: false,
                                    model: widget.model,
                                    isLoading: false,
                                    didSelectEmbeddedRes: (listing, res) {},
                                    didSelectMainImage: (listing) {
                                      setState(() {
                                        if (currentSelectedFacility == listing) {
                                          currentSelectedFacility = null;
                                        } else {
                                          currentSelectedFacility = listing;
                                        }
                                      });
                                    },
                                    didSelectFooter: (ListingManagerForm listing) {
                                      setState(() {
                                        if (currentSelectedFacility == listing) {
                                          currentSelectedFacility = null;
                                        } else {
                                          currentSelectedFacility = listing;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 18),
            Wrap(
              spacing: 12,
              runSpacing: 12,
                children: listings.where((listing) => !usersListings.any((userListing) => userListing.listingServiceId == listing.listingServiceId)).toList().asMap().map((i, e) {
                return MapEntry(i, SlideInTransitionWidget(
                durationTime: (i < 15) ? 300 * i : 0,
                offset: Offset(0, 0.25),
                transitionWidget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                  width: MediaQuery.of(context).size.width / 2 - 24, // Adjust width to fit 2 items in a row
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: (e.listingServiceId == currentSelectedFacility?.listingServiceId) ? widget.model.paletteColor : Colors.transparent)
                  ),
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 320,
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
                    model: widget.model,
                    isLoading: false,
                    didSelectEmbeddedRes: (listing, res) {

                    },
                    didSelectMainImage: (listing) {
                      setState(() {
                      if (currentSelectedFacility == e) {
                        currentSelectedFacility = null;
                      } else {
                        currentSelectedFacility = e;
                      }
                      });
                    },
                    didSelectFooter: (ListingManagerForm listing) {
                        setState(() {
                          if (currentSelectedFacility == e) {
                          currentSelectedFacility = null;
                          } else {
                          currentSelectedFacility = e;
                          }
                        });
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