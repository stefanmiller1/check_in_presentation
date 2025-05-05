part of check_in_presentation;

class PagingSmallActivitiesWidget extends StatefulWidget {

  final DashboardModel model;
  final bool isMobile;
  final bool isWrapper;
  final bool isOwner;
  final double height;
  final UserProfileModel currentUser;
  final Function(ReservationPreviewer) didSelectReservation;
  final List<ReservationItem> reservations;

  const PagingSmallActivitiesWidget({super.key, required this.model, required this.height, required this.reservations, required this.currentUser, required this.didSelectReservation, required this.isMobile, required this.isOwner, required this.isWrapper});

  @override
  State<PagingSmallActivitiesWidget> createState() => _PagingSmallActivitiesWidgetState();
}

class _PagingSmallActivitiesWidgetState extends State<PagingSmallActivitiesWidget> {

  int _currentPage = 0;
  late bool showButton = false;
  late final Future<List<ReservationPreviewer>> _getReservationForSmallWidgetList;
  late PageController _reservationPageController;

  /// see more activities

  Future<List<ReservationPreviewer>> _getReservationPreviewerFeed(List<ReservationItem> reservations) async {
    late List<ReservationPreviewer> resToPreview = [];

    for (ReservationItem reservationItem in reservations) {
      late int weight = 0;

      ReservationPreviewer resPreview = ReservationPreviewer(
          reservation: reservationItem,
          previewWeight: weight
      );


      try {
        final listingManagerForm = await facade.ListingFacade.instance.getListingManagerItem(listingId: reservationItem.instanceId.getOrCrash());
        resPreview = resPreview.copyWith(
            listing: listingManagerForm
        );
      } catch (e) {}

      try {
        final reservationOwnerProfile = await facade.UserProfileFacade.instance.getCurrentUserProfile(userId: reservationItem.reservationOwnerId.getOrCrash());
        resPreview = resPreview.copyWith(
            reservationOwnerProfile: reservationOwnerProfile
        );

      } catch(e) {}

      try {
        final activityManagerForm = await facade.ActivitySettingsFacade.instance
            .getActivitySettings(
            reservationId: reservationItem.reservationId.getOrCrash()
        );

        resPreview = resPreview.copyWith(
            activityManagerForm: activityManagerForm
        );

        resPreview = resPreview.copyWith(
            lookingForVendors: getHasPublishedVendorForms(activityManagerForm?.rulesService.vendorMerchantForms ?? [])
        );

      } catch (e) {}

      try {
        final activityAttendeesCount = await facade.ActivitySettingsFacade.instance
            .getNumberOfActivityAttendees(
            reservationId: reservationItem.reservationId.getOrCrash()
        );
        resPreview = resPreview.copyWith(
            attendeesCount: activityAttendeesCount
        );
        /// has attendees (1 point per attendee - or 5 points flat?)
        if (activityAttendeesCount != 0) {
          weight += (1 * activityAttendeesCount);
        }
      } catch (e) {}

      resPreview = resPreview.copyWith(
          previewWeight: weight
      );
      resToPreview.add(resPreview);
    }

    return resToPreview.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
  }


  @override
  void initState() {
    super.initState();
    _getReservationForSmallWidgetList = _getReservationPreviewerFeed(widget.reservations);
  }


@override
  void dispose() {
    _reservationPageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize or update PageController when dependencies change
    _reservationPageController = (kIsWeb) ? PageController(viewportFraction: (Responsive.isDesktop(context)) ? 1/2.1 : 450 / MediaQuery.of(context).size.width) : PageController(viewportFraction: 0.9);
  }



  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ReservationPreviewer>>(
        future: _getReservationForSmallWidgetList,
        builder: (context, snap) {

          final List<ReservationPreviewer> reservationPreview = snap.data ?? [];
          final bool reservationsHasVendorForm = reservationPreview.any((e) => getHasPublishedVendorForms(e.activityManagerForm?.rulesService.vendorMerchantForms ?? []));

          if (snap.connectionState == ConnectionState.waiting) {
            return Container(
              height: widget.height,
              child: emptyLargeListView(context, 3, 300, Axis.horizontal, kIsWeb),
            );
          }



       return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [


          if (reservationsHasVendorForm) Chip(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: widget.model.webBackgroundColor,
              avatar: Icon(
                  Icons.note_alt_outlined,
                  color: widget.model.disabledTextColor
              ),
            label: Text('We are Looking For Vendors', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))
          ),

            if (widget.isWrapper) Wrap(
              direction: Axis.horizontal,
              children: reservationPreview.map((item) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: baseSearchItemContainer(
                      height: 380,
                      width: 380,
                      model: widget.model,
                      isSelected: null,
                      backgroundWidget: getReservationMediaFrameFlexible(context, widget.model, 400, 400, null, item.activityManagerForm, item.reservation!, false,
                          didSelectItem: () {
                            widget.didSelectReservation(item);
                          }),
                      bottomWidget: getSearchFooterWidget(
                          context,
                          widget.model,
                          widget.currentUser.userId,
                          widget.model.paletteColor,
                          widget.model.disabledTextColor,
                          widget.model.accentColor,
                          item,
                          false,
                          didSelectItem: () {
                            widget.didSelectReservation(item);
                          },
                          didSelectInterested: () {

                          }
                      )
                  ),
                );
              }).toList()
            ),

            if (widget.isWrapper == false) PagingWithArrowsCoreWidget(
              height: widget.height,
              model: widget.model,
              pagingWidget: PageView.builder(
                  physics: (kIsWeb) ? const NeverScrollableScrollPhysics() : null,
                  padEnds: false,
                  controller: _reservationPageController,
                  itemCount: reservationPreview.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final ReservationPreviewer item = reservationPreview[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: baseSearchItemContainer(
                          height: widget.height,
                          width: widget.height,
                          model: widget.model,
                          isSelected: null,
                          backgroundWidget: getReservationMediaFrameFlexible(context, widget.model, 400, 400, null, item.activityManagerForm, item.reservation!, false,
                              didSelectItem: () {
                                widget.didSelectReservation(item);
                              }),
                          bottomWidget: getSearchFooterWidget(
                              context,
                              widget.model,
                              widget.currentUser.userId,
                              widget.model.paletteColor,
                              widget.model.disabledTextColor,
                              widget.model.accentColor,
                              item,
                              false,
                              didSelectItem: () {
                                widget.didSelectReservation(item);
                              },
                              didSelectInterested: () {

                          }
                        )
                      ),
                    );


                  //   final ReservationPreviewer item = reservationPreview[index];
                  //   late Color borderColor;
                  //
                  //   if (item.reservation?.reservationState == ReservationSlotState.current) {
                  //     borderColor = Colors.red;
                  //   }
                  //
                  //   if (item.reservation?.reservationState == ReservationSlotState.confirmed) {
                  //     borderColor = widget.model.disabledTextColor;
                  //   }
                  //
                  //   return Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: InkWell(
                  //         onTap: () {
                  //           widget.didSelectReservation(item);
                  //         },
                  //         child: Stack(
                  //           alignment: Alignment.bottomCenter,
                  //           children: [
                  //             Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Container(
                  //                   width: widget.height,
                  //                   height: widget.height - 42,
                  //                   decoration: BoxDecoration(
                  //                       shape: BoxShape.circle,
                  //                       color: widget.model.accentColor,
                  //                       border: Border.all(color: borderColor, width: 2.75),
                  //                       boxShadow: [
                  //                         BoxShadow(
                  //                             color: widget.model.disabledTextColor.withOpacity(0.15),
                  //                             spreadRadius: 5,
                  //                             blurRadius: 13,
                  //                             offset: const Offset(5,0)
                  //                       )
                  //                     ]
                  //                   ),
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(4.0),
                  //                     child: CircleAvatar(
                  //                       radius: widget.height,
                  //                       backgroundColor: borderColor,
                  //                       backgroundImage: Image.network(
                  //                           item.activityManagerForm?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
                  //                           errorBuilder: (context, err, stack) {
                  //                             return getActivityTypeTabOption(
                  //                                 context,
                  //                                 widget.model,
                  //                                 widget.height,
                  //                                 false,
                  //                                 getActivityOptions().firstWhere((element) => element.activityId == item.reservation?.reservationSlotItem.first.selectedActivityType)
                  //                             );
                  //                           },
                  //                           fit: BoxFit.cover
                  //                       ).image,
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 const SizedBox(height: 5),
                  //                 Expanded(
                  //                   child: Container(
                  //                     height: 40,
                  //                     width: widget.height,
                  //                     child: Row(
                  //                       mainAxisAlignment: MainAxisAlignment.center,
                  //                       children: [
                  //                         Text(DateFormat.d().format(upcomingDateOrFinished(item.reservation!) ?? DateTime.now()), style: TextStyle(color: widget.model.disabledTextColor), overflow: TextOverflow.ellipsis),
                  //                         const SizedBox(width: 4),
                  //                         Text(DateFormat.MMM().format(upcomingDateOrFinished(item.reservation!) ?? DateTime.now()), style: TextStyle(color: widget.model.disabledTextColor), overflow: TextOverflow.ellipsis)
                  //                       ]
                  //                     ),
                  //                   ),
                  //                 ),
                  //
                  //               ],
                  //             ),
                  //             if (item.reservation?.reservationState == ReservationSlotState.current) OverflowBox(
                  //               maxWidth: double.infinity,
                  //               child: Transform.translate(
                  //                 offset: Offset(25, 25), // Adjust the offset to position the badge icon
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     color: borderColor,
                  //                   ),
                  //                   padding: EdgeInsets.all(8),
                  //                   child: Icon(
                  //                     CupertinoIcons.dot_radiowaves_left_right,
                  //                     color: Colors.white,
                  //                     size: 11, // Adjust the size of the badge icon as needed
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             if (item.reservation?.reservationState != ReservationSlotState.current && item.lookingForVendors == true) OverflowBox(
                  //               maxWidth: double.infinity,
                  //               child: Transform.translate(
                  //                 offset: Offset(25, 25), // Adjust the offset to position the badge icon
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     shape: BoxShape.circle,
                  //                     color: widget.model.webBackgroundColor,
                  //                   ),
                  //                   padding: EdgeInsets.all(8),
                  //                   child: Icon(
                  //                     Icons.note_alt_outlined,
                  //                     color: widget.model.paletteColor,
                  //                     size: 11, // Adjust the size of the badge icon as needed
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   )
                  // );
                }
              ),
              didSelectBack: () {
                setState(() {
                  _reservationPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                });
              },
              didSelectForward: () {
                setState(() {
                  _reservationPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                });
              }
            ),
          ],
        );
      }
    );
  }
}