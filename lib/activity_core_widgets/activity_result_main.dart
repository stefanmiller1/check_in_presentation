part of check_in_presentation;

class ActivityResultMain extends StatefulWidget {

  final ListingManagerForm? listing;
  final List<ReservationItem> reservations;
  final DashboardModel model;
  final UniqueId? currentUserId;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes;

  const ActivityResultMain({super.key, required this.reservations, required this.model, required this.listing, required this.didSelectEmbeddedRes, this.currentUserId});

  @override
  State<ActivityResultMain> createState() => _ActivityResultMainState();
}

class _ActivityResultMainState extends State<ActivityResultMain> with TickerProviderStateMixin {

  late bool isLoading = false;

  Random random = Random();
  late AnimationController _initAnimateController;
  late AnimationController _animationController;
  late AnimationController _progressAnimationController;

  int _currentPage = 0;
  late final PageController _activityPageController = PageController(initialPage: 0);
  late final Future<List<ReservationPreviewer>> getReservationList;


  void updateStateSafely() {
      Future.delayed(const Duration(milliseconds: 750), () {
          isLoading = false;
      });
  }

  @override
  void initState() {
    getReservationList = getActivitiesInOrderOfWeight(widget.reservations);
    // updateStateSafely();

    int randomNumber = 5 + random.nextInt(10 - 5);
    _initAnimateController = AnimationController(vsync: this, duration: const Duration(seconds: 1, milliseconds: 300));
    //Start at the controller and set the time to switch pages
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: randomNumber));
    _progressAnimationController = AnimationController(vsync: this, duration: Duration(seconds: randomNumber), value: 1.0);

    //Add listener to AnimationController for know when end the count and change to the next page
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reset(); //
        // Reset the controller
        final int page = widget.reservations.length; //Number of pages in your PageView
        if (_currentPage < page - 1) {
          _currentPage++;
          _activityPageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);

        } else  {
          _currentPage = 0;
          if (_activityPageController.positions.isNotEmpty) {
            _activityPageController.animateToPage(0,
                duration: const Duration(milliseconds: 300), curve: Curves.easeInSine);
          }
        }
      }
    });

    if (mounted) {
      _initAnimateController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _initAnimateController.dispose();
    _animationController.dispose();
    _progressAnimationController.dispose();
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();

    return SlideTransition(
        position: Tween<Offset>(
        begin: Offset(0.1, 0.0), // Start from below
        end: Offset.zero).animate(_initAnimateController),
      child: FadeTransition(
        opacity: _initAnimateController,
        child: FutureBuilder<List<ReservationPreviewer>>(
          future: getReservationList,
          builder: (context, snap) {
            final reservationList = snap.data ?? [];

            return SizedBox(
              // height: panelHeight(context) - listingHeaderHeight - 125,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _animationController.stop();
                        _progressAnimationController.stop();
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _animationController.forward();
                        _progressAnimationController.forward();
                      });
                    },
                    child: GestureDetector(
                      onLongPressStart: (_) {
                        setState(() {
                          _animationController.stop();
                          _progressAnimationController.stop();
                        });
                      },
                      onLongPressEnd: (_) {
                        setState(() {
                          _animationController.forward();
                          _progressAnimationController.forward();
                        });
                      },
                      onLongPressCancel: () {
                        setState(() {
                          _animationController.forward();
                          _progressAnimationController.forward();
                        });
                      },
                      child: PageView.builder(
                          controller: _activityPageController,
                          itemCount: reservationList.length,
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                              if (kIsWeb) _animationController.stop();
                            });
                          },
                          itemBuilder: (context, index) {

                            final ReservationPreviewer preview = reservationList[index];

                            /// happening now!
                            /// most anticipated
                            /// media
                            /// when reservation starts
                            /// reservation owner
                            /// current attendees?
                            /// become a vendor/partner/instructor?
                            /// if over threshold show main image as discussion media
                            /// if over threshold show discussion text

                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                getActivityResultsWidget(
                                  context,
                                  widget.model,
                                  widget.currentUserId,
                                  preview,
                                didSelectInterested: () {

                                },
                                didSelectItem: () {
                                    if (widget.listing != null) {
                                      widget.didSelectEmbeddedRes(widget.listing!, preview.reservation!);
                                    }
                                  }
                                ),

                                if (reservationList.length != 1) Container(
                                  height: 3,
                                  width: MediaQuery.of(context).size.width,
                                  child: TweenAnimationBuilder<double>(
                                    duration: _progressAnimationController.duration ?? Duration(seconds: 3),
                                    curve: Curves.easeInOut,
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: _progressAnimationController.value,
                                    ),
                                    builder: (context, value, _) =>
                                        LinearProgressIndicator(
                                            minHeight: 3,
                                            backgroundColor: widget.model.paletteColor,
                                            value: value,
                                            valueColor: AlwaysStoppedAnimation<Color>(widget.model.accentColor),
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<int>.generate(reservationList.length, (int index) => index + 1).asMap().map(
                                (index, e) => MapEntry(index,
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Container(
                                    height: 6,
                                    // width: ((MediaQuery.of(context).size.width ~/ reservations.length) * 0.75).toDouble(),
                                    decoration: BoxDecoration(
                                        color: (index == _currentPage) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ).values.toList(),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}


Future<List<ReservationPreviewer>> getActivitiesInOrderOfWeight(List<ReservationItem> reservations) async {
  late List<ReservationPreviewer> resToPreview = [];

  for (ReservationItem reservationItem in reservations) {
    late int weight = 0;

    ReservationPreviewer resPreview = ReservationPreviewer(
        reservation: reservationItem,
        previewWeight: 0
    );

    try {
      final activityManagerForm = await facade.ActivitySettingsFacade.instance
          .getActivitySettings(
          reservationId: reservationItem.reservationId.getOrCrash()
      );
      resPreview = resPreview.copyWith(
          activityManagerForm: activityManagerForm
      );
      /// has hero images (10 points)
      if (activityManagerForm?.profileService.activityBackground.activityProfileImages?.isNotEmpty ?? false) {
        weight += 10;
      }
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

    try {

      final activityDiscussionChats = await facade.ActivitySettingsFacade.instance
          .getNumberOfChatsInDiscussion(
          reservationId: reservationItem.reservationId.getOrCrash()
      );
      /// has discussions (2 points)
      if (activityDiscussionChats != 0) {
        weight += (1* activityDiscussionChats);
      }
    } catch (e) {}


    resPreview = resPreview.copyWith(
        previewWeight: weight
    );

    resToPreview.add(resPreview);
  }

  /// order from highest weight to smallest
  return resToPreview.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
}