part of check_in_presentation;

class DiscoverySearchComponent extends StatefulWidget {

  final DashboardModel model;

  const DiscoverySearchComponent({super.key, required this.model});

  @override
  State<DiscoverySearchComponent> createState() => _DiscoverySearchComponentState();
}

class _DiscoverySearchComponentState extends State<DiscoverySearchComponent> {

  late bool isLoading = false;
  late List<ReservationPreviewer> discoveryFeed = [];
  late String? selectedDiscoveryFilterType;
  late double widthConstraint = 1500;

  @override
  void initState() {
    initLoading();
    super.initState();
  }

  void initLoading() {
    setState(() {
      isLoading = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.model.webBackgroundColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 105),
                            getDiscoveryFeedCircles(),
                            /// create my o
                            /// claim my o
                            const SizedBox(height: 55),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 15),
                            activityAttendingToggle(),
                            const SizedBox(height: 15),
                            filterByVendorType(),
                            const SizedBox(height: 55),
                            getDiscoveryMainContainer(),


                            // Visibility(
                            //     visible: (!(kIsWeb) && Responsive.isMobile(context)),
                            //     child: getListingsBasedOnTypeMainContainer()
                            // ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () {
                  // didSelectSearchedUser(
                  //     context: context,
                  //     model: widget.model,
                  //     currentUserId: facade.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                  //     didSelectContact: (contact) {
                  //       Navigator.of(context).pop();
                  //
                  //   }
                  // );
                },
                child: Container(
                  height: 55,
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: widget.model.disabledTextColor.withOpacity(0.25), width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: widget.model.paletteColor.withOpacity(0.08),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Icon(Icons.search_rounded, color: widget.model.disabledTextColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Search Communities or People - Coming Soon', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor,  overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Positioned(
          //   right: 350,
          //   top: 25,
          //   child: Container(
          //     child: Text('Switch to Organizing', style: TextStyle(decoration: TextDecoration.underline, fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)),
          //   )
          // )
        ],
      ),
    );
  }

  Widget activityAttendingToggle() {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: widget.model.accentColor,
            // border: Border.all(color: widget.model.paletteColor),
            borderRadius: BorderRadius.circular(40),
          ),
          child: IconButton(
            onPressed: () {  },
            icon: Icon(CupertinoIcons.slider_horizontal_3, color: widget.model.paletteColor),
            iconSize: 30,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                color: widget.model.accentColor,
                // border: Border.all(color: widget.model.paletteColor),
                borderRadius: BorderRadius.circular(40),
              ),
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.local_activity_outlined, color: widget.model.paletteColor),
                      const SizedBox(width: 8),
                      Text(' Activities ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                color: widget.model.accentColor,
                // border: Border.all(color: widget.model.paletteColor),
                borderRadius: BorderRadius.circular(40),
              ),
              child: InkWell(
                onTap: () {

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.storefront, color: widget.model.paletteColor),
                      const SizedBox(width: 8),
                      Text(' Vendors ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget filterByVendorType() {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 6,
      spacing: 8,
      children: MerchantVendorTypes.values.map(
              (e) => InkWell(
            onTap: () {

            },
            child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Text(' ${getVendorMerchTitle(e)}  ', textAlign: TextAlign.center, style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            )
          ),
        )
      ).toList(),
    );
  }
  /// retrieve all reservations based on listings & confirmed, completed & current bookings that will happen between now and 7 days and that have happened in the last 7 days. sort by preview alg.
  /// is there a way to get the best 10?
  Widget getDiscoveryMainContainer() {
    /// limit query to reservations happening over the next 7 days.
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchDiscoveryReservationsList([ReservationSlotState.confirmed] ,1416, null, true)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadDiscoveryReservationItemSuccess: (e) {
                return getVendorProfilesMainContainer(e.item);

                // return (e.item.isNotEmpty) ? getDiscoveryFeedHeader(e.item) : Container();
              },
              orElse: () => getVendorProfilesMainContainer([])
          );
        },
      ),
    );
  }


  /// retrieve 8 vendor profiles
  Widget getVendorProfilesMainContainer(List<ReservationItem> upcomingRes) {
    return BlocProvider(create: (_) => getIt<VendorMerchProfileWatcherBloc>()..add((const VendorMerchProfileWatcherEvent.watchAllEventMerchProfileFiltered(null, null, null, 11))),
      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadAllMerchVendorFilteredListSuccess: (e) {
                      return getNextFewHoursMainContainer(upcomingRes, e.items);
              // if (e.items.isEmpty) {
              //   return Container();
              // }
              //
              // return Center(
              //   child: Container(
              //     height: 410,
              //     child: DiscoveryVendorMainWidget(
              //       model: widget.model,
              //       profiles: e.items
              //     )
              //   ),
              // );
            },
            orElse: () => getNextFewHoursMainContainer(upcomingRes, [])
          );
        }
      )
    );
  }

  Widget getNextFewHoursMainContainer(List<ReservationItem>  upcomingRes, List<EventMerchantVendorProfile> vendors) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchDiscoveryReservationsList([ReservationSlotState.current], null, null, true)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadDiscoveryReservationItemSuccess: (e) {
                return getListingsBasedOnTypeMainContainer(upcomingRes, e.item, vendors);
                // return (e.item.isNotEmpty) ? getDiscoveryUpComingTodayOrHalfDay(e.item) : Container();
              },
              orElse: () => getListingsBasedOnTypeMainContainer(upcomingRes, [], vendors)
          );
        },
      ),
    );
  }


  Widget getListingsBasedOnTypeMainContainer(List<ReservationItem>  upcomingRes, List<ReservationItem>  currentRes, List<EventMerchantVendorProfile> vendors) {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(const PublicListingWatcherEvent.watchAllPublicListingsSearchStarted([ManagerListingStatusType.finishSetup], null, null, null)),
          child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadAllSearchedPublicListingItemsSuccess: (e) => getMainContainer(upcomingRes, currentRes, vendors, e.items),
                  // getListingsThisWeekForDiscovery(e.items),
                  orElse: () => getMainContainer(upcomingRes, currentRes, vendors, []),
          );
        },
      )
    );
  }

  /// filter by user activity
  /// option to show all
  /// organize by
  /// video horizontal paging controller (on mobile)
  /// call all listings? (sort/order by latest first? or last booking made time?)



  Widget getDiscoveryFeedCircles() {
    final List<CircleData> circlePreviews = [
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F278458119_293601586243417_1935417759819638200_n.jpg?alt=media&token=72fc5e3a-638a-4023-bc70-f6fa8b60f057',
        score: 90,
        color: Colors.red,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F394500268_700890831636224_410666712687644964_n.jpg?alt=media&token=51788a05-379f-4e3e-973f-55817db7327f',
        score: 70,
        color: Colors.purple,
      ),
      CircleData(
        imageUrl: null,
        score: 20,
        isElevated: false,
        color: Colors.white,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F386286820_686383676743010_3296018315711328992_n.jpg?alt=media&token=090f3c8b-ac0e-4347-a701-852b671b9d0b',
        score: 90,
        color: Colors.blue,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F464103827_1863863300769835_1795315889839197114_n.jpg?alt=media&token=58bb8cfe-1515-4679-9828-c6a7211200e1',
        score: 60,
        color: Colors.blue,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F429452240_342801092081450_6936037854342767450_n.jpg?alt=media&token=63ccce20-0564-475f-8b49-95903faa94ec',
        score: 150,
        color: Colors.green,
      ),
      CircleData(
        imageUrl: null,
        score: 35,
        isElevated: false,
        color: Colors.white,
      ),
      CircleData(
        imageUrl: null,
        score: 15,
        isElevated: false,
        color: Colors.white,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F461775397_2548611618655468_5086929840873626567_n.jpg?alt=media&token=45285b04-5c1b-4c42-9ca3-470081395248',
        score: 110,
        color: Colors.orange,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F355054805_590508983066379_2170496248670869927_n.jpg?alt=media&token=6ab72268-f79a-4e21-9fd9-8ec62ac8d019',
        score: 60,
        color: Colors.purple,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F283611147_1210244429793758_6081237890748820101_n.jpg?alt=media&token=785ac692-a5b7-4828-ac16-1f263cd624cc',
        score: 80,
        color: Colors.orange,
      ),
      CircleData(
        imageUrl: null,
        score: 15,
        isElevated: false,
        color: Colors.white,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F338574109_167875329090509_335916262957097691_n.jpg?alt=media&token=6d922abf-602f-4ff5-923e-81b9d1533bcb',
        score: 30,
        color: Colors.purple,
      ),
      CircleData(
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F336018549_3680065348884110_3899269140271980847_n.jpg?alt=media&token=2adf2430-2e24-439b-b8b2-c5aa9adb7e9f',
        score: 50,
        color: Colors.purple,
      ),
      ...getActivityOptions().map((e) => CircleData(score: 55, color: Colors.white, isSvg: true, imageUrl: getIconPathForActivity(context, e.activityId)))
    ];

    return Row(
      children: [
        Container(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Create a', style: TextStyle(color: widget.model.paletteColor,  fontWeight: FontWeight.bold, fontSize: 50)),
                  const SizedBox (width: 8),
                  Icon(Icons.circle_outlined, size: 65, color: widget.model.paletteColor),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 60,
                // width: 200,
                decoration: BoxDecoration(
                  color: widget.model.accentColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                  onTap: () {

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(' Get Started ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                  ),
                ),
              ),
            ]
          )
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // const SizedBox(height: 12),
              // Text('Circles You Might Know?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
              CircleClusterWidget(
                  circles: circlePreviews,
                  circlePadding: 8
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMainContainer(List<ReservationItem>  upcomingRes, List<ReservationItem>  currentRes, List<EventMerchantVendorProfile> vendors, List<ListingManagerForm> facilities) {
    List<DiscoverySectionObject> discoverySectionsList = [
      if (vendors.isNotEmpty) DiscoverySectionObject(
          hasValues: true,
          sectionTitle: 'The best Vendors in Town',
          sectionDescription: 'Preview our favourite vendors to work with',
          sectionIcon: Icons.store,
          editButtonTitle: 'Preview More Profiles',
          isLoading: isLoading,
          mainSectionWidget: Center(
            child: Container(
                height: 410,
                child: DiscoveryVendorMainWidget(
                    model: widget.model,
                    widgetWidth: 400,
                    widthConstraint: widthConstraint,
                    profiles: vendors
                )
            ),
          ),
          onEditPressed: () {}
      ),
      if (upcomingRes.isNotEmpty) DiscoverySectionObject(
          hasValues: true,
          sectionTitle: 'Unforgettable Experiences Starting Soon',
          sectionDescription: 'Events and Activities coming up this year',
          sectionIcon: CupertinoIcons.calendar,
          editButtonTitle: '',
          isLoading: isLoading,
          mainSectionWidget: getDiscoveryFeedHeader(upcomingRes),
          onEditPressed: () {}
      ),
      if (currentRes.isNotEmpty) DiscoverySectionObject(
          hasValues: true,
          sectionTitle: 'Happening Right Now!',
          sectionDescription: 'Don\'t miss out while these activities last',
          sectionIcon: CupertinoIcons.dot_radiowaves_left_right,
          editButtonTitle: '',
          isLoading: isLoading,
          mainSectionWidget: getDiscoveryUpComingTodayOrHalfDay(currentRes),
          onEditPressed: () {}
      ),
      /// create section for likes that include
      /// add section for circles you're in
      /// add section for vendors you bookmarked
    ];

    return Column(
        children: [
          ...discoverySectionsList.map((e) => DiscoverySectionWidget(model: widget.model, discoverySectionObject: e)),
        ]
    );
  }

  Widget getDiscoveryFeedHeader(List<ReservationItem> resPreview) {

    if (resPreview.isEmpty) {
      return Container();
    }

    return Center(
      child: SizedBox(
        height: 565,
        width: MediaQuery.of(context).size.width,
        child: DiscoveryHeroMainWidget(
          widgetWidth: 380,
          widthConstraint: widthConstraint,
          reservations: resPreview,
          model: widget.model,
        ),
      ),
    );
  }

  /// see all options
  /// show number of all
  Widget getDiscoveryUpComingTodayOrHalfDay(List<ReservationItem> reservations) {
    if (reservations.isEmpty) {
      return Container();
    }
    return Center(
      child: Container(
        height: 565,
        width: MediaQuery.of(context).size.width,
        child: DiscoveryHeroMainWidget(
          widgetWidth: 380,
          widthConstraint: widthConstraint,
          reservations: reservations,
          model: widget.model,
        ),
      ),
    );
  }


  Widget getListingsThisWeekForDiscovery(List<ListingManagerForm> listings) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Great for Organizers', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
          const SizedBox(height: 8),

          /// number of slots this week?
          Center(
            child: Container(
              height: 360,
              width: MediaQuery.of(context).size.width,
              child: DiscoveryListingWidget(
                listings: listings,
                model: widget.model,
                activityFilterType: ProfileActivityOption.toRent,
                didSelectListing: (ListingManagerForm listing) {
                  didSelectCreateNewActivity(
                      context,
                      widget.model,
                      listing,
                      2
                  );
                  // widget.didSelectListing(listing);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}