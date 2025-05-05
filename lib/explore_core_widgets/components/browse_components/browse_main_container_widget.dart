part of check_in_presentation;

class BrowseMainContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final bool? isLoading;
  final ExploreFilterObject? initialFilterObject;
  final List<ReservationPreviewer>? initialActivityItems;
  final DocumentSnapshot? initialActivityLastDoc;  // Initial list of items
  final int? initialActivityPageKey;
  final List<EventMerchVendorPreview>? initialVendorProfiles;
  final DocumentSnapshot? initialVendorLastDoc;
  final int? initialVendorPageKey;
  final Function(ExploreSearchQueryObject) didUpdateQueryObject; 
  final Function(List<EventMerchVendorPreview> list, int pageKey, DocumentSnapshot? lastDoc) didRecieveVendorItems;
  final Function(List<ReservationPreviewer> list, int pageKey, DocumentSnapshot? lastDoc) didRecieveActivityItems;
 
  const BrowseMainContainerWidget({super.key, 
    required this.model, 
    this.initialFilterObject, 
    this.isLoading, 
    this.initialVendorProfiles,
    this.initialVendorPageKey,
    this.initialVendorLastDoc,
    this.initialActivityItems, 
    this.initialActivityPageKey, 
    this.initialActivityLastDoc,
    required this.didUpdateQueryObject,
    required this.didRecieveActivityItems,
    required this.didRecieveVendorItems,
    });
  
  @override
  State<StatefulWidget> createState() => _BrowseMainContainerWidgetState();

}


class _BrowseMainContainerWidgetState extends State<BrowseMainContainerWidget> {
  
  late double widthConstraint = 1500;
  late DateRangePickerController _datePickerController = DateRangePickerController();

  @override
    void initState() {
      super.initState();
    }

    dispose() {
     _datePickerController.dispose();
      super.dispose();
    }


  Widget getMainContainerByType(ExploreBrowseType? browseType) {
    switch (browseType) {
      case null:
        // TODO: Handle this case.
        return getDiscoveryMainContainer();
      case ExploreBrowseType.activity:
        // TODO: Handle this case.
        return ActivitiesFeedWidget(
          model: widget.model,
          currentUserId: null,
          filterModel: widget.initialFilterObject,
          initialItems: widget.initialActivityItems,
          initialLastDoc: widget.initialActivityLastDoc,
          initialPageKey: widget.initialActivityPageKey,
          didRecieveActivityItems: (items, key, doc) => widget.didRecieveActivityItems(items, key, doc)
        );
      case ExploreBrowseType.user:
        return VendorFeedWidget(
          model: widget.model,
          currentUserId: null,
          filterModel: widget.initialFilterObject,
          initialItems: widget.initialVendorProfiles,
          initialLastDoc: widget.initialVendorLastDoc,
          initialPageKey: widget.initialVendorPageKey,
          didUpdateQueryObject: (queryObject) => widget.didUpdateQueryObject(queryObject),
          didRecieveVendorItems: (items, key, doc) => widget.didRecieveVendorItems(items, key, doc)
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return getMainContainerByType(widget.initialFilterObject?.filterByExplorBrowseType);

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getMainContainerByType(widget.initialFilterObject?.filterByExplorBrowseType),
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
    );
  }


  Widget getDiscoveryMainContainer() {
    /// limit query to reservations happening over the next 7 days.
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchDiscoveryReservationsList([ReservationSlotState.confirmed], 5840, null, null)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadDiscoveryReservationItemSuccess: (e) {
                return getVendorProfilesMainContainer(e.item);
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


  Widget getMainContainer(List<ReservationItem>  upcomingRes, List<ReservationItem>  currentRes, List<EventMerchantVendorProfile> vendors, List<ListingManagerForm> facilities) {
    List<BrowseSectionObject> discoverySectionsList = [
      // BrowseSectionObject(
      //     hasValues: true,
      //     sectionTitle: 'The best Vendors in Town',
      //     sectionDescription: 'Preview our favourite vendors to work with',
      //     sectionIcon: Icons.store,
      //     editButtonTitle: 'Preview More Profiles',
      //     isLoading: widget.isLoading ?? false,
      //     mainSectionWidget: Center(
      //       child: Container(
      //           height: 410,
      //           child: BrowseVendorMainWidget(
      //               model: widget.model,
      //               widgetWidth: 400,
      //               widthConstraint: widthConstraint,
      //               profiles: vendors
      //         )
      //       ),
      //     ),
      //     onEditPressed: () {}
      // ),
      // BrowseSectionObject(
      //     hasValues: true,
      //     sectionTitle: 'Calendar and Dates',
      //     sectionDescription: 'Filter by date range to find the best activities',
      //     sectionIcon: CupertinoIcons.calendar,
      //     editButtonTitle: ' Update the Calendar ',
      //     isLoading: widget.isLoading ?? false,
      //     mainSectionWidget:  getFilterByCalendarSelectionWidget(),
      //     onEditPressed: () {}
      // ),
      if (upcomingRes.isNotEmpty) BrowseSectionObject(
          hasValues: true,
          sectionTitle: 'Unforgettable Experiences Starting Soon',
          sectionDescription: 'Events and Activities coming up this year',
          sectionIcon: CupertinoIcons.calendar,
          editButtonTitle: '',
          isLoading: widget.isLoading ?? false,
          mainSectionWidget: getDiscoveryFeedHeader(upcomingRes),
          onEditPressed: () {}
      ),
      if (currentRes.isNotEmpty) BrowseSectionObject(
          hasValues: true,
          sectionTitle: 'Happening Right Now!',
          sectionDescription: 'Don\'t miss out while these activities last',
          sectionIcon: CupertinoIcons.dot_radiowaves_left_right,
          editButtonTitle: ' Preview More Activities ',
          isLoading: widget.isLoading ?? false,
          mainSectionWidget: getDiscoveryUpComingTodayOrHalfDay(currentRes),
          onEditPressed: () {}
      ),
      /// create section for likes that include
      /// add section for circles you're in
      /// add section for vendors you bookmarked
    ];

    return BrowseFullBleedWidget(
      model: widget.model,
      reservations: upcomingRes
    );

    return Column(
        children: [
          // getDiscoveryFeedCircles(),
          const SizedBox(height: 20),
          ...discoverySectionsList.map((e) => BrowseSectionWidget(model: widget.model, discoverySectionObject: e)),
      ]
    );
  }

  Widget getFilterByCalendarSelectionWidget() {
    return Container(
      decoration: BoxDecoration(
        color: widget.model.accentColor,
        borderRadius: BorderRadius.circular(25),
      ),
      height: 150,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 18.0, top: 8.0),
          child: SfDateRangePicker(
          backgroundColor: widget.model.accentColor,
          showNavigationArrow: true,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          selectionColor: widget.model.paletteColor,
          initialSelectedDate: DateTime.now(),
          enablePastDates: false,
          navigationMode: DateRangePickerNavigationMode.snap,
          navigationDirection: DateRangePickerNavigationDirection.horizontal,
          minDate: DateTime.now(), 
          // maxDate: DateTime.now().subtract(const Duration(days: 365)),
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor),
              backgroundColor: widget.model.accentColor,
          ),
          headerHeight: 40,
          monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderHeight: 40,
            viewHeaderStyle: DateRangePickerViewHeaderStyle(
              textStyle: TextStyle(color: widget.model.disabledTextColor),
              backgroundColor: widget.model.accentColor,
            ),
            dayFormat: 'EEE',
            // blackoutDates: blockedDates,
            numberOfWeeksInView: 1,
          ),
          todayHighlightColor: widget.model.paletteColor,
          monthCellStyle: DateRangePickerMonthCellStyle(
          todayCellDecoration: BoxDecoration(
          color: widget.model.paletteColor.withOpacity(0.15),
            shape: BoxShape.circle
          ),
          textStyle: TextStyle(color: widget.model.paletteColor),
          todayTextStyle: TextStyle(
            color: widget.model.paletteColor,
            fontWeight: FontWeight.bold
          ),
            blackoutDatesDecoration: BoxDecoration(
                color: widget.model.accentColor,
                shape: BoxShape.circle
            ),
            blackoutDateTextStyle: TextStyle(
              color: widget.model.disabledTextColor, 
              decoration: TextDecoration.lineThrough
            ),
          ),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
            if (args.value is DateTime) {
              final DateTime day = args.value as DateTime;
              // selectedDateTime(DateTime(day.year, day.month, day.day));
            }
          },  
                ),
        )  
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
        child: BrowseHeroMainWidget(
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
        child: BrowseHeroMainWidget(
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
              child: BrowseListingWidget(
                listings: listings,
                model: widget.model,
                activityFilterType: ProfileActivityOption.toRent,
                didSelectListing: (ListingManagerForm listing) {
                  didSelectCreateNewActivity(
                      context,
                      widget.model,
                      null,
                      listing,
                      didSaveActivity: (res) {

                      },
                      didPublishActivity: (res) {

                      },
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
        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/cico-8298b.appspot.com/o/circles%2F464103827_1863863300769835_1795315889839197114_n.jpg?alt=media&token=58bb8cfe-1515-4679-9828-c6fa8b60f057',
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
      ...getActivityOptions().map((e) => CircleData(score: 55, color: Colors.white, isSvg: true, imageUrl: getIconPathForActivity(e.activity)))
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Create \nor Join a', style: TextStyle(color: widget.model.paletteColor,  fontWeight: FontWeight.bold, fontSize: 50)),
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
                  circlePadding: 8,
                  minWidth: 15,
                  maxWidth: 90,
                  width: (Responsive.isMobile(context)) ? MediaQuery.of(context).size.width : (MediaQuery.of(context).size.width >= 1500) ? 1500 : MediaQuery.of(context).size.width - 500,
                  height: 350
                ),
            ],
          ),
        ),
      ],
    );
  }
}