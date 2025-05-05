part of check_in_presentation;

class PagingHorizontalActivitiesWidget extends StatefulWidget {

  final DashboardModel model;
  final UniqueId? currentUserId;
  final Function(ReservationPreviewer) didSelectReservation;
  final List<ReservationItem> reservations;

  const PagingHorizontalActivitiesWidget({super.key, required this.model, required this.reservations, this.currentUserId, required this.didSelectReservation});

  @override
  State<PagingHorizontalActivitiesWidget> createState() => _PagingHorizontalActivitiesWidgetState();
}

class _PagingHorizontalActivitiesWidgetState extends State<PagingHorizontalActivitiesWidget> {

  int _currentPage = 0;
  late bool showButton = false;
  late final Future<List<ReservationPreviewer>> getReservationForRegularWidgetList;
  /// see more activities

  Future<List<ReservationPreviewer>> getWeightedDiscoveryFeed(List<ReservationItem> reservations) async {
    late List<ReservationPreviewer> resToPreview = [];

    for (ReservationItem reservationItem in reservations) {
      late int weight = 0;

      ReservationPreviewer resPreview = ReservationPreviewer(
          reservation: reservationItem,
          previewWeight: weight
      );

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
    getReservationForRegularWidgetList = getWeightedDiscoveryFeed(widget.reservations);
  }


  @override
  Widget build(BuildContext context) {
    final PageController _reservationPageController = (kIsWeb) ? PageController(viewportFraction: (Responsive.isDesktop(context)) ? 1/2.1 : 450 / MediaQuery.of(context).size.width) : PageController(viewportFraction: 0.9);

    return FutureBuilder<List<ReservationPreviewer>>(
      future: getReservationForRegularWidgetList,
      builder: (context, snap) {

        final List<ReservationPreviewer> reservationPreview = snap.data ?? [];

        if (snap.connectionState == ConnectionState.waiting) {
          return Expanded(
              child: emptyLargeListView(context, 3, 300, Axis.horizontal, kIsWeb));
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (e) {
            setState(() {
              showButton = true;
            });
          },
          onHover: (e) {
            setState(() {
              showButton = true;
            });
          },
          onExit: (e) {
            setState(() {
              showButton = false;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [

              Container(
                height: 460,
                child: PageView.builder(
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
                          height: 400,
                          width: 400,
                            model: widget.model,
                            isSelected: null,
                            backgroundWidget: getReservationMediaFrameFlexible(context, widget.model, 400, 400, null, item.activityManagerForm, item.reservation!, false,
                                didSelectItem: () {
                                  widget.didSelectReservation(item);
                                }),
                            bottomWidget: getSearchFooterWidget(
                                context,
                                widget.model,
                                widget.currentUserId,
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
                  }
                ),
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
                        Container(
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
                        Container(
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
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      }
    );
  }
}