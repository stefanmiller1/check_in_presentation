part of check_in_presentation;

class GeneralProfileWidget extends StatefulWidget {

  final UserProfileModel currentUser;
  final bool isOwner;
  final DashboardModel model;
  final bool isMobileOnly;
  final Function(UserProfileModel) didSelectEditProfile;
  final List<AccountNotificationItem> notifications;
  final List<ListingManagerForm> facilities;
  final List<ReservationItem> reservations;
  final List<ReservationItem> completedReservations;
  final List<AttendeeItem> attending;

  const GeneralProfileWidget({super.key,
    required this.currentUser,
    required this.isOwner,
    required this.model,
    required this.isMobileOnly,
    required this.notifications,
    required this.facilities,
    required this.reservations,
    required this.attending,
    required this.completedReservations,
    required this.didSelectEditProfile,
  });

  @override
  State<GeneralProfileWidget> createState() => _GeneralProfileWidgetState();
}

class _GeneralProfileWidgetState extends State<GeneralProfileWidget> {


  final List<ReservationItem> reservationList = [];
  // final List<ReservationItem>
  late bool isLoading = false;
  late AppOption? appOptionSettings = null;

  @override
  void initState() {

    initLoading();
    _fetchAppOption();
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

  Future<void> _fetchAppOption() async {
    try {
      AppOption? appOption = await widget.model.getCurrentAppOption();
      setState(() {
        appOptionSettings = appOption;
      });
    } catch (e) {
      print('Error fetching app option: $e');
    }
  }


  @override
  void didUpdateWidget(covariant GeneralProfileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reservations.length != oldWidget.reservations.length) {
      setState(() {
        reservationList.clear();
        reservationList.addAll(widget.reservations);
      });
    }

    // if (widget.completedReservations.length != oldWidget.completedReservations.length) {
    //   setState(() {
    //     reservationsCompletedList.clear();
    //     reservationsCompletedList.addAll(widget.completedReservations);
    //   });
    // }
  }




  @override
  Widget build(BuildContext context) {

    List<ProfileSectionObject> profileSectionsList = [
      ProfileSectionObject(
          hasValues:  widget.facilities.isNotEmpty,
          sectionTitle: 'Spaces Anyone can Access',
          sectionDescription: 'Checkout the spaces ${widget.currentUser.legalName.getOrCrash()}\'s has made available for bookings',
          sectionIcon: Icons.home_outlined,
          editButtonTitle: _getEditButtonTextForFacilities(appOptionSettings),
          isOwner:  widget.isOwner,
          emptyMainSectionWidget: widget.isOwner ? _buildEmptyFacilitiesList(appOptionSettings) : _buildEmptyNonOwnerFacilities(appOptionSettings),
          isLoading: isLoading,
          mainSectionWidget: _buildFacilitiesLocation(),
          onEditPressed: () {

          }
      ),
      ProfileSectionObject(
          hasValues: reservationList.isNotEmpty,
          sectionTitle: 'Down the Pipeline..',
          sectionDescription: '${widget.currentUser.legalName.getOrCrash()}\'s activities coming up or happening now',
          sectionIcon: CupertinoIcons.calendar,
          editButtonTitle: 'See More',
          isOwner:  widget.isOwner,
          isLoading: isLoading,
          sectionMoreWidget: _sectionMoreWidget(),
          mainSectionWidget: _buildUpcomingAndCurrentReservations(),
          emptyMainSectionWidget: ( widget.isOwner) ? _buildEmptyActivitiesOwner() : _buildEmptyActivitiesNonOwner(),
          onEditPressed: () {
            setState(() {
              didSelectShowAllReservationsByType(context, widget.model, widget.currentUser.userId, [ReservationSlotState.current, ReservationSlotState.confirmed]);
          });
        }
      ),
      ProfileSectionObject(
          hasValues: false,
          sectionTitle: 'Thoughts and Feedback - Coming Soon',
          sectionDescription: 'Take a look at hat people have said about participating in ${widget.currentUser.legalName.getOrCrash()}\'s Activities',
          sectionIcon: CupertinoIcons.chat_bubble_2,
          editButtonTitle: 'See More',
          isLoading: isLoading,
          isOwner: false,
          mainSectionWidget: Container(
          ),
          /// participate to
          emptyMainSectionWidget: _buildNoReviewsYet(),
          onEditPressed: () {

        }
      ),
      if (widget.completedReservations.isNotEmpty) ProfileSectionObject(
        hasValues: true,
        sectionTitle: 'What you Might Have Missed',
        sectionDescription: '',
        sectionIcon: CupertinoIcons.calendar,
        editButtonTitle: 'See More',
        isLoading: isLoading,
        isOwner: true,
        mainSectionWidget: _buildCompletedReservations(),
        emptyMainSectionWidget: null,
        onEditPressed: () {
          setState(() {
            didSelectShowAllReservationsByType(context, widget.model, widget.currentUser.userId, [ReservationSlotState.completed]);
          });
        }
      ),
    ];


    return CustomProfileLayout(
      profilePicture: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.model.webBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.11),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(0, 2)
                  )
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: profileHeaderContainer(
                widget.currentUser,
                widget.model,
                widget.isOwner,
                widget.facilities.length,
                attendeesOnlyList(widget.attending).length,
                widget.currentUser.userId.getOrCrash(),
                editProfile: () {
                  widget.didSelectEditProfile(widget.currentUser);
                },
                didSelectShare: () {
                  setState(() {
                    didSelectShareProfile(widget.currentUser, ProfileTypeMarker.generalProfile);
                  });
                },
              ),
            ),
          ),
          if (widget.isOwner) Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: widget.model.disabledTextColor),
                ),
                child: _buildAllCircleCommunities(),
              ),
            ],
          ),
          const SizedBox(height: 15),
          verificationsAndConfirmations(widget.model, widget.currentUser),
          const SizedBox(height: 25),
          reportProfileWidget(widget.model, widget.currentUser.userId.getOrCrash())
        ],
      ),
      profileContent: _buildMainReviewProfile(context, profileSectionsList),
      profileFooter: Container(
        child: Column(
          children: [
            const SizedBox(height: 30),
            BasicWebFooter(model: widget.model),
            const SizedBox(height: 30),
          ]
        )
      ),
      isMobileOnly: widget.isMobileOnly,
      stickyStartOffset: 50
    );

  }


  String _getEditButtonTextForFacilities(AppOption? appOption) {
    if (appOption == null) return '';
    switch (appOption) {
      case AppOption.activities:
        return '';
      case AppOption.organizers:
        return 'Switch to Hosting - Coming Soon';
      case AppOption.owners:
        return 'Review';
      default:
        return '';
    }
  }

  String _getEmptyButtonTextForUpcomingRes(AppOption? appOption) {
    if (appOption == null) return 'Switch to Organizing';
    switch (appOption) {
      case AppOption.activities:
        return 'Switch to Organizing';
      case AppOption.organizers:
        return 'Get Started';
      case AppOption.owners:
        return 'Get Started';
      default:
        return '';
    }
  }


  Widget _buildMainReviewProfile(BuildContext context, List<ProfileSectionObject> sectionList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          ...sectionList.map((e) => ProfileSectionWidget(model: widget.model, profileSectionObject: e)
          ).toList()
        ]
      ),
    );
  }

  Widget _buildAllCircleCommunities() {
    return IgnorePointer(
      ignoring: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.circle_outlined, color: widget.model.disabledTextColor, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Circles',
                  style: TextStyle(
                    color: widget.model.disabledTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Add your own communities and connect with others!',
              style: TextStyle(color: widget.model.disabledTextColor),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: widget.model.disabledTextColor),
                  ),
                  child: Center(
                    child: Text('Create My Circle - Coming Soon!', style: TextStyle(color: widget.model.disabledTextColor)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  //// ---- FACILITIES SECTION ---- /////

  Widget _buildFacilitiesLocation() {
    final isMobile = Responsive.isMobile(context) || widget.isMobileOnly;

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PagingSmallFacilitiesWidget(
          model: widget.model,
          height: 400,
          isMobile: isMobile,
          currentUser: widget.currentUser,
          didSelectFacility: (facility) {

            if (appOptionSettings == null) {
              return;
            }
            switch (appOptionSettings!) {
              case AppOption.activities:
                // TODO: Handle this case.
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: Text('Switch to a Circle for Organizers to preview Our Facilities', style: TextStyle(color: widget.model.paletteColor)));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                break;
              case AppOption.organizers:
                didSelectCreateNewActivity(
                    context,
                    widget.model,
                    facility,
                    2
                );
                break;
              case AppOption.owners:
                // TODO: Handle this case.
                break;
            }
          },
          facilities: widget.facilities,
          isOwner: widget.isOwner,
        ),
      ),
    );
  }


  Widget? _buildEmptyFacilitiesList(AppOption? appOption) {
      if (appOption == null) return null;
        switch (appOption) {
          case AppOption.activities:
            return null;
          case AppOption.organizers:
            return _buildRequestAccessToTools();
          case AppOption.owners:
            return _buildAddYourFacility();
      }

  }

  Widget? _buildEmptyNonOwnerFacilities(AppOption? appOption) {
    if (appOption == null) return null;
    switch (appOption) {
      case AppOption.activities:
        return null;
      case AppOption.organizers:
        return _buildNoFacilitiesYet();
      case AppOption.owners:
        return _buildNoFacilitiesYet();
    }
  }

  Widget _buildNoFacilitiesYet() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Listings Yet',
            style: TextStyle(
              color: widget.model.disabledTextColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.model.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This user has not posted any listings yet.  feel free to check back later.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRequestAccessToTools() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Looking to Host your Space?',
            style: TextStyle(
              color: widget.model.disabledTextColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Do you have a space you can host events in? Request access to our free tools designed to help you connect with other organizers and manage your spaces effectively.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.model.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              // Handle access request logic here
              setState(() {
                requestAccessToFacilitiesApp();
              });
            },
            child: Container(
              height: 45,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.model.accentColor,
              ),
              child: Center(
                child: Text('Request Access', style: TextStyle(color: widget.model.disabledTextColor)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAddYourFacility() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.house, color: widget.model.disabledTextColor, size: 28),
              const SizedBox(width: 10),
              Text(
                'Add Your Facility',
                style: TextStyle(
                  color: widget.model.disabledTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.model.secondaryQuestionTitleFontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Begin the process of adding your facility to the map. This will help others find and book your space for their events.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.model.accentColor,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {

            },
            child: Container(
              height: 45,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.model.accentColor,
              ),
              child: Center(
                child: Text('Get Started', style: TextStyle(color: widget.model.disabledTextColor)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  //// ---- ACTIVITIES SECTION ---- /////

  Widget _buildUpcomingAndCurrentReservations() {
    final isMobile = Responsive.isMobile(context) || widget.isMobileOnly;

    if (widget.reservations.isEmpty) return Container();

    if (reservationList.length != widget.reservations.length) {
      reservationList.clear();
      reservationList.addAll(widget.reservations);
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: PagingSmallActivitiesWidget(
        model: widget.model,
        height: 450,
        isMobile: isMobile,
        isWrapper: false,
        isOwner: widget.isOwner,
        currentUser: widget.currentUser,
        reservations: reservationList,
        didSelectReservation: (item) async {
          didSelectReservationPreview(context, widget.model, item);
        },
      ),
    );
  }

  Widget? _sectionMoreWidget() {
    final int reservationsOnNow = reservationList.where((e) => e.reservationState == ReservationSlotState.current).toList().length;

    if (reservationList.map((e) => e.reservationState).contains(ReservationSlotState.current)) {
      return Chip(
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.red,
        avatar: const Icon(
            CupertinoIcons.dot_radiowaves_left_right,
            color: Colors.white
        ),
        label: Text('${reservationsOnNow} on Now', style: TextStyle(color: Colors.white, fontSize: widget.model.secondaryQuestionTitleFontSize))
      );
    }
  }

  Widget _buildEmptyActivitiesOwner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Thinking of Starting Your Own Activity??',
            style: TextStyle(
              color: widget.model.disabledTextColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.model.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
             'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              // Handle access request logic here
              _fetchAppOption();
              if (appOptionSettings == null) {
                return;
              }
              switch (appOptionSettings!) {
                case AppOption.activities:
                  final snackBar = SnackBar(
                      backgroundColor: widget.model.webBackgroundColor,
                      content: Text('Switch to a Circle for Organizers to Publish your Activity', style: TextStyle(color: widget.model.paletteColor)));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  break;
                case AppOption.organizers:
                // Handle access request logic here
                  didSelectCreateNewActivity(
                      context,
                      widget.model,
                      null,
                      null
                  );
                  break;
                case AppOption.owners:
                // TODO: Handle this case.
                  break;
              }
            },
            child: Container(
              height: 45,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.model.accentColor,
              ),
              child: Center(
                child: Text(_getEmptyButtonTextForUpcomingRes(appOptionSettings), style: TextStyle(color: widget.model.disabledTextColor)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEmptyActivitiesNonOwner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Creations Yet!',
            style: TextStyle(
              color: widget.model.disabledTextColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to know when ${widget.currentUser.legalName.getOrCrash()} has started their first & second & third &...activity',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
          Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.model.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Handle access request logic here
            },
            child: Container(
              height: 45,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.model.accentColor,
              ),
              child: Center(
                child: Text('Send a Notification - Coming Soon!', style: TextStyle(color: widget.model.disabledTextColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //// ---- REVIEWS ---- ////
  Widget _buildNoReviewsYet() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Reviews Yet',
            style: TextStyle(
              color: widget.model.disabledTextColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 190,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.model.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Participate in one of ${widget.currentUser.legalName.getOrCrash()} Activities to be able to leave a Review',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  /// --- COMPLETED RESERVATIONS --- ////
  _buildCompletedReservations() {
    final isMobile = Responsive.isMobile(context) || widget.isMobileOnly;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: PagingSmallActivitiesWidget(
        model: widget.model,
        height: 450,
        isWrapper: true,
        isMobile: isMobile,
        isOwner: widget.isOwner,
        currentUser: widget.currentUser,
        reservations: widget.completedReservations,
        didSelectReservation: (item) async {
          didSelectReservationPreview(context, widget.model, item);
        },
      ),
    );
  }

// Widget _buildNoItemsFoundIndicator(bool isMobile) {
//   return Column(
//     children: [
//       Container(
//         width: pagedSubWidth,
//         child: noItemsFound(
//           widget.model,
//           Icons.calendar_today_outlined,
//           widget.isOwner ? 'Thinking of Starting Your Own Activity?' : 'No Creations - Just Yet',
//           'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
//           'Get access to a Circle for Organizers',
//           didTapStartButton: () {},
//         ),
//       ),
//       if (isMobile) BasicWebFooter(model: widget.model),
//     ],
//   );
// }


}


