part of check_in_presentation;

class BrowseHeroMainWidget extends StatefulWidget {

  final DashboardModel model;
  final double widgetWidth;
  final double widthConstraint;
  final List<ReservationItem> reservations;

  const BrowseHeroMainWidget({super.key, required this.reservations, required this.model, required this.widgetWidth, required this.widthConstraint});

  @override
  State<BrowseHeroMainWidget> createState() => _BrowseHeroMainWidgetState();
}

class _BrowseHeroMainWidgetState extends State<BrowseHeroMainWidget> {

  int _currentPage = 0;
  late bool showButton = false;
  late final Future<List<ReservationPreviewer>> getReservationList;
  late PageController _reservationPageController;


  Future<List<ReservationPreviewer>> getWeightedBrowseFeed(List<ReservationItem> reservations) async {
    final reservationPreviews = await Future.wait(reservations.map((reservationItem) async {
      int weight = 0;

      ReservationPreviewer resPreview = ReservationPreviewer(reservation: reservationItem, previewWeight: weight);

      try {
        final reservationOwnerProfile = await facade.UserProfileFacade.instance
            .getCurrentUserProfile(userId: reservationItem.reservationOwnerId.getOrCrash());
        resPreview = resPreview.copyWith(reservationOwnerProfile: reservationOwnerProfile);
      } catch (e) {
        print('Error fetching user profile: $e');
      }

      try {
        final listingManagerForm = await facade.ListingFacade.instance
            .getListingManagerItem(listingId: reservationItem.instanceId.getOrCrash());
        resPreview = resPreview.copyWith(listing: listingManagerForm);
      } catch (e) {
        print('Error fetching listing: $e');
      }

      try {
        final activityManagerForm = await facade.ActivitySettingsFacade.instance
            .getActivitySettings(reservationId: reservationItem.reservationId.getOrCrash());
        resPreview = resPreview.copyWith(activityManagerForm: activityManagerForm);

        // Update weight based on activityManagerForm conditions
        if (activityManagerForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true) {
          weight += 2; // Supported merchant: 2 points
        }
        if (activityManagerForm.profileService.activityBackground.activityProfileImages?.isNotEmpty ?? false) {
          weight += 10; // Hero images: 10 points
        }
      } catch (e) {
        print('Error fetching activity settings: $e');
      }

      try {
        final attendeesCount = await facade.ActivitySettingsFacade.instance
            .getNumberOfActivityAttendees(reservationId: reservationItem.reservationId.getOrCrash());
        resPreview = resPreview.copyWith(attendeesCount: attendeesCount);

        // Update weight based on attendees count
        if (attendeesCount != 0) {
          weight += attendeesCount; // 1 point per attendee
        }
      } catch (e) {
        print('Error fetching attendees count: $e');
      }

      // Finalize preview with calculated weight
      return resPreview.copyWith(previewWeight: weight);
    }));

    // Sort by weight in descending order
    return reservationPreviews.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
  }

  @override
  void initState() {

    getReservationList = getWeightedBrowseFeed(widget.reservations);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize or update PageController when dependencies change
    _reservationPageController = PageController(
      viewportFraction: (MediaQuery.of(context).size.width >= widget.widthConstraint)
          ? widget.widgetWidth / widget.widthConstraint
          : widget.widgetWidth / MediaQuery.of(context).size.width,
    );
  }

  @override
  void dispose() {
    _reservationPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ReservationPreviewer>>(
        future: getReservationList,
        builder: (context, snap) {
          final reservationList = snap.data ?? [];
    
          if (snap.connectionState == ConnectionState.waiting) {
            return emptyLargeListView(context, 4, 500, Axis.horizontal, kIsWeb);
          }
    
          return Stack(
            alignment: Alignment.topCenter,
            children: [
    
              PageView.builder(
                  padEnds: false,
                  // physics: (Responsive.isMobile(context)) ? null : NeverScrollableScrollPhysics(),
                  controller: _reservationPageController,
                  itemCount: reservationList.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ReservationPreviewer preview = reservationList[index];
    
    
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          didSelectReservationPreview(context, widget.model, preview);
                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: widget.widgetWidth,
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
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                    imageUrl: (preview.activityManagerForm?.profileService.activityBackground.activityProfileImages?.isNotEmpty ?? false) ? preview.activityManagerForm?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '' : '',
                                    imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                                    errorWidget: (context, url, error) => getActivityTypeTabOption(
                                        context,
                                        widget.model,
                                        40,
                                        false,
                                        getActivityOptions().firstWhere((element) => element.activityId == preview.reservation?.reservationSlotItem.first.selectedActivityType)
                                  )
                                )
                              ),
                            ),
                            Container(
                              width: widget.widgetWidth,
                              child: bottomFooterDetails(
                                  context,
                                  widget.model,
                                  preview,
                                  UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
                                  didSelectItem: () {
                                    didSelectReservationPreview(context, widget.model, preview);
                                  },
                                  didSelectInterested: () {
    
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),

              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left MouseRegion
                MouseRegion(
                onEnter: (_) => setState(() => showButton = true),
                onExit: (_) => setState(() => showButton = false),
                  child: Container(
                    width: 100,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
                // Right MouseRegion
                MouseRegion(
                onEnter: (_) => setState(() => showButton = true),
                onExit: (_) => setState(() => showButton = false),
                  child: Container(
                    width: 100,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
    
              AnimatedOpacity(
                duration: Duration(milliseconds: 350),
                opacity: (showButton) ? 1 : 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MouseRegion(
                          onEnter: (_) => setState(() => showButton = true),
                          onHover: (_) => setState(() => showButton = true),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color:  widget.model.paletteColor,
                                border: Border.all(color: widget.model.paletteColor, width: 0.5),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _reservationPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                                });
                              },
                              icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.model.disabledTextColor),
                            ),
                          ),
                        ),

                        MouseRegion(
                          onEnter: (_) => setState(() => showButton = true),
                          onHover: (_) => setState(() => showButton = true),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: widget.model.paletteColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _reservationPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                                });
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded, color: widget.model.disabledTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }
    );
  }
}
