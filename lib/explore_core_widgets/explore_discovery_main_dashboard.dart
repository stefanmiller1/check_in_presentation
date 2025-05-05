part of check_in_presentation;

class ExploreSearchMainDashboard extends StatefulWidget {

  final DashboardModel model;
  final ExploreFilterObject? initialFilterObject;
  // final Widget defaultContainerModel;
  // final List<ExploreSearchContainerModel>? filterMainContainerModels;
  
  const ExploreSearchMainDashboard({super.key, required this.model, this.initialFilterObject});

  @override
  State<ExploreSearchMainDashboard> createState() => _ExploreSearchMainDashboardState();
}

class _ExploreSearchMainDashboardState extends State<ExploreSearchMainDashboard> {


  late bool? isLoading = false;
  late bool? isLoadingMain = false;
  late List<ReservationPreviewer>? activitiesFeedLoaded = [];
  late List<EventMerchVendorPreview>? vendorsFeedLoaded = [];
  late int? activitiesFeedPageKeyLoaded = null;
  late int? vendorsFeedPageKeyLoaded = null;
  late DocumentSnapshot? activitiesLastDoc = null;
  late DocumentSnapshot? vendorsLastDoc = null;
  // late ExploreSearchQueryObject? currentQueryObject = null;

  @override
  void initState() {
    // currentFilterObject = widget.initialFilterObject;
    // currentQueryObject = widget.initialSearchQueryObject;
    ExploreWebHelperCore.currentFilterObject = widget.initialFilterObject ?? ExploreFilterObject.empty();
    super.initState();
  }


  void didUpdateByFilter(ExploreFilterObject? filter) {
    setState(() {
        isLoading = true;
        clearActivitiesFeed(filter);
        clearVendorsFeed(filter);
        ExploreWebHelperCore.currentFilterObject = filter;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            isLoading = false;
        });
      });
    });
  }

  // void didUpdateByExploreType

  void clearActivitiesFeed(ExploreFilterObject? newFilter) {
      if (ExploreWebHelperCore.currentFilterObject?.activitiesFilter != newFilter?.activitiesFilter) {
        activitiesFeedLoaded?.clear();
        activitiesFeedPageKeyLoaded = null;
        activitiesLastDoc = null;
      }
  }

  void clearVendorsFeed(ExploreFilterObject? newFilter) {
      if (ExploreWebHelperCore.currentFilterObject?.vendorFilter != newFilter?.vendorFilter) {
        vendorsFeedLoaded?.clear();
        vendorsFeedPageKeyLoaded = null;
        vendorsLastDoc = null;
      }
  }
  

  @override
  Widget build(BuildContext context) {

    if (isLoadingMain == true) {
      return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
    }

    return ExploreSearchhMainLayout(
        model: widget.model,
        initialQuery: ExploreWebHelperCore.currentFilterObject?.searchQuery,
        initialContainerType: ExploreWebHelperCore.currentFilterObject?.filterByExploreType,
        exploreMainContainer: [
          ExploreContainerModel(
            containerType: ExploreContainerType.browse,
            bottomAppBarWidget: FilterAppBarWidget(
              initialFilterObject: ExploreWebHelperCore.currentFilterObject, 
              didUpdateFilterModel: (filter) {
                didUpdateByFilter(filter);
              },
               model: widget.model
            ),
            mainContainerWidget: BrowseMainContainerWidget(
              model: widget.model,
              initialFilterObject: ExploreWebHelperCore.currentFilterObject,
              initialActivityItems: activitiesFeedLoaded,
              initialActivityPageKey: activitiesFeedPageKeyLoaded,
              initialActivityLastDoc: activitiesLastDoc,
              initialVendorProfiles: vendorsFeedLoaded,
              initialVendorPageKey: vendorsFeedPageKeyLoaded,
              initialVendorLastDoc: vendorsLastDoc,
              didUpdateQueryObject: (filter) {
                setState(() {
                  // isLoading = true;
                  isLoadingMain = true;
                  ExploreWebHelperCore.currentFilterObject = ExploreWebHelperCore.currentFilterObject?.copyWith(
                    filterByExploreType: filter.exploreType,
                    userProfileId: filter.profileId?.getOrCrash(),
                    profileType: filter.userProfileType,
                  );  
                  
                  // didUpdateByFilter(currentFilterObject);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    setState(() {
                    // isLoading = false;
                    isLoadingMain = false;
                    });
                  });
                });
              },
              didRecieveVendorItems: (items, key, lastDoc) {
                setState(() {
                  // Add only new items to `vendorsFeedLoaded`
                  final newItems = items.where((item) => !vendorsFeedLoaded!.any((existing) => existing.vendorToPreview?.profileId == item.vendorToPreview?.profileId));
                  vendorsFeedLoaded?.addAll(newItems);
                  vendorsFeedPageKeyLoaded = key;
                  vendorsLastDoc = lastDoc;
                });
              },
              didRecieveActivityItems: (items, key, lastDoc) {
                setState(() {
                   // Add only new items to `activitiesFeedLoaded`
                  final newItems = items.where((item) => !activitiesFeedLoaded!.any((existing) => existing.reservation?.reservationId == item.reservation?.reservationId));
                  activitiesFeedLoaded?.addAll(newItems);
                  activitiesFeedPageKeyLoaded = key;
                  activitiesLastDoc = lastDoc;

                });
              }
            ),
            isLoading: isLoading,
            containerTitle: 'Browse',
          ),
          ExploreContainerModel(
            containerType: ExploreContainerType.activityProfile,
            mainContainerWidget: const Center(
              child: Text('No content available'),
            ),
            containerTitle: 'Unavailable',
          ),
          ExploreContainerModel(
            containerType: ExploreContainerType.circleProfile,
            mainContainerWidget: const Center(
              child: Text('No content available'),
            ),
            containerTitle: 'Unavailable',
          ),
          ExploreContainerModel(
            containerType: ExploreContainerType.userProfile,
            mainContainerWidget: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 170,
                    width: MediaQuery.of(context).size.width,
                    // constraints: const BoxConstraints(maxWidth: 1500),
                    child: ProfileMainContainer(
                      model: widget.model,
                      currentUserId: (ExploreWebHelperCore.currentFilterObject?.userProfileId != null) ? ExploreWebHelperCore.currentFilterObject!.userProfileId! : '',
                      currentUserProfile: null,
                      profileType: ExploreWebHelperCore.currentFilterObject?.profileType,
                      isMobileViewOnly: false,
                      didSelectAppearancesGetStarted: () {},
                    ),
                  ),
                ),
              ],
            ),
          containerTitle: 'Profile',
          isLoading: isLoading,
        ),
      ], 
      didUpdateQueryObject: (queryObject) {  
        setState(() {
          isLoading = true;
          ExploreWebHelperCore.currentFilterObject = ExploreWebHelperCore.currentFilterObject?.copyWith(
            filterByExploreType: queryObject.exploreType,
            userProfileId: queryObject.profileId?.getOrCrash(),
            profileType: queryObject.userProfileType,
          );

          // currentQueryObject = queryObject;

          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              isLoading = false;
            });
          });
          // isLoading = true;
          // clearActivitiesFeed(filter);
          // clearVendorsFeed(filter);
          // currentFilterObject = filter;
          // Future.delayed(const Duration(milliseconds: 800), () {
          //   setState(() {
          //     isLoading = false;
          //   });
          // });

        });
      },
    );


    // return Scaffold(
    //   backgroundColor: widget.model.webBackgroundColor,
    //   body: Stack(
    //     alignment: Alignment.topCenter,
    //     children: [
    //       Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height,
    //       ),

    //       SingleChildScrollView(
    //         child: Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Flexible(
    //                 child: Center(
    //                   child: Container(
    //                     constraints: const BoxConstraints(maxWidth: 1500),
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         const SizedBox(height: 105),
    //                         getDiscoveryFeedCircles(),
    //                         /// create my o
    //                         /// claim my o
    //                         const SizedBox(height: 55),
    //                         Divider(color: widget.model.disabledTextColor),
    //                         const SizedBox(height: 15),
    //                         activityAttendingToggle(),
    //                         const SizedBox(height: 15),
    //                         filterByVendorType(),
    //                         const SizedBox(height: 55),
    //                         getDiscoveryMainContainer(),


    //                         // Visibility(
    //                         //     visible: (!(kIsWeb) && Responsive.isMobile(context)),
    //                         //     child: getListingsBasedOnTypeMainContainer()
    //                         // ),
    //                         const SizedBox(height: 12),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),

    //       Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 8.0),
    //           child: InkWell(
    //             onTap: () {
    //               // didSelectSearchedUser(
    //               //     context: context,
    //               //     model: widget.model,
    //               //     currentUserId: facade.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
    //               //     didSelectContact: (contact) {
    //               //       Navigator.of(context).pop();
    //               //
    //               //   }
    //               // );
    //             },
    //             child: Container(
    //               height: 55,
    //               constraints: const BoxConstraints(maxWidth: 500),
    //               decoration: BoxDecoration(
    //                 color: widget.model.accentColor,
    //                   borderRadius: BorderRadius.circular(30),
    //                   border: Border.all(color: widget.model.disabledTextColor.withOpacity(0.25), width: 1),
    //                   boxShadow: [
    //                     BoxShadow(
    //                         color: widget.model.paletteColor.withOpacity(0.08),
    //                         spreadRadius: 2,
    //                         blurRadius: 8,
    //                         offset: Offset(0, 2)
    //                   )
    //                 ]
    //               ),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Row(
    //                   children: [
    //                     const SizedBox(width: 8),
    //                     Icon(Icons.search_rounded, color: widget.model.disabledTextColor),
    //                     const SizedBox(width: 8),
    //                     Expanded(
    //                       child: Text('Search Communities or People - Coming Soon', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor,  overflow: TextOverflow.ellipsis),
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),

    //       // Positioned(
    //       //   right: 350,
    //       //   top: 25,
    //       //   child: Container(
    //       //     child: Text('Switch to Organizing', style: TextStyle(decoration: TextDecoration.underline, fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)),
    //       //   )
    //       // )
    //     ],
    //   ),
    // );
  }



  /// retrieve all reservations based on listings & confirmed, completed & current bookings that will happen between now and 7 days and that have happened in the last 7 days. sort by preview alg.
  /// is there a way to get the best 10?
  

}