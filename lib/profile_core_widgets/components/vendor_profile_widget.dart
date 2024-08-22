part of check_in_presentation;

class VendorMerchantProfileWidget extends StatefulWidget {

  final UserProfileModel currentUser;
  final DashboardModel model;
  final bool isOwner;
  final bool isMobileOnly;
  final List<EventMerchantVendorProfile> vendorProfiles;
  final List<AttendeeItem> attending;
  final Function() didSelectAppearancesGetStarted;
  final Function() didSelectCreateNew;
  final Function() didSelectShare;
  final Function() didSelectAddPartners;
  final Function() didSelectReveiewApplication;
  final Function(EventMerchantVendorProfile profile) didSelectEdit;

  const VendorMerchantProfileWidget({super.key, required this.currentUser, required this.model, required this.didSelectShare, required this.didSelectAddPartners, required this.didSelectEdit, required this.didSelectCreateNew, required this.vendorProfiles, required this.attending, required this.isOwner, required this.didSelectReveiewApplication, required this.isMobileOnly, required this.didSelectAppearancesGetStarted});

  @override
  State<VendorMerchantProfileWidget> createState() => _VendorMerchantProfileWidgetState();
}

class _VendorMerchantProfileWidgetState extends State<VendorMerchantProfileWidget> {

  late bool isLoading = false;
  late AppOption? appOptionSettings = null;

  @override
  void initState() {

    _fetchAppOption();
    initLoading();
    super.initState();
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

    List<ProfileSectionObject> profileSectionsList = [
      /// appearances

      // _buildAttendingReservations
      ProfileSectionObject(
          hasValues: widget.attending.isNotEmpty,
          sectionTitle: 'Appearances',
          sectionDescription: 'Activities where you can find ${widget.currentUser.legalName.getOrCrash()}',
          sectionIcon: CupertinoIcons.calendar,
          editButtonTitle: '',
          isOwner:  widget.isOwner,
          isLoading: isLoading,
          mainSectionWidget: _buildAttendingReservations(),
          emptyMainSectionWidget: (widget.isOwner) ? _buildEmptyAttendingOwner() : _buildEmptyAttendingNonOwner(),
          onEditPressed: () {
            setState(() {
              didSelectSeeVendorsAppearances(widget.currentUser);
            });
          }
      ),
      ProfileSectionObject(
          hasValues: false,
          sectionTitle: 'Thoughts and Feedback - Coming Soon',
          sectionDescription: 'Take a look at what Organizers have said',
          sectionIcon: CupertinoIcons.chat_bubble_2,
          editButtonTitle: (widget.isOwner) ? 'Review' : 'See More',
          isLoading: isLoading,
          isOwner: false,
          mainSectionWidget: Container(
          ),
          /// participate to
          emptyMainSectionWidget: _buildNoReviewsYet(),
          onEditPressed: () {

          }
      ),
      ProfileSectionObject(
          hasValues: false,
          sectionTitle: 'My Setup - Coming Soon',
          sectionDescription: 'My gear and daily equipment',
          sectionIcon: CupertinoIcons.hammer,
          editButtonTitle: (widget.isOwner) ? 'Edit' : 'See More',
          isLoading: isLoading,
          isOwner: false,
          mainSectionWidget: Container(
          ),
          /// participate to
          emptyMainSectionWidget: _buildNoSetup(),
          onEditPressed: () {

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
              child: _buildVendorProfile(),
            )
          ),
          if (widget.isOwner) Column(
            children: [
                const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  widget.didSelectReveiewApplication();
                },
                child: Container(
                  width: 500,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.model.webBackgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Align(
                    child: Text('Review My Applications', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          reportProfileWidget(widget.model, widget.currentUser.userId.getOrCrash())

        ]
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

  /// create new vendor profile setup
  Widget _buildVendorProfile() {
    if (widget.vendorProfiles.isNotEmpty) {

      final EventMerchantVendorProfile profile = widget.vendorProfiles[0];

      return getVendorMerchProfileHeader(
          widget.model,
          widget.isOwner,
          profile,
          widget.attending.length,
          didSelectShare: () {
            widget.didSelectShare();
          },
          didSelectAddPartners: () {
            widget.didSelectAddPartners();
          },
          didSelectEdit: () {
            widget.didSelectEdit(profile);
        },
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: widget.model.accentColor,
                ),
              ),
              const SizedBox(width: 20),
            Expanded(
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: widget.model.accentColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 30,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.model.accentColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 30,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: widget.model.accentColor,
          ),
        ),
        /// create new profile
        Visibility(
          visible: widget.isOwner,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: widget.model.mobileBackgroundColor.withOpacity(0.35),
                ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text('If your\'re a vendor or merchant - you can create a custom profile for showcasing your shop. Your community will get to see upcoming reservations, where they can find you and what you\'ve been apart of.', style: TextStyle(color: widget.model.disabledTextColor)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => widget.didSelectCreateNew(),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: widget.model.accentColor,
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(color: model.disabledTextColor)
                        ),
                        child: Center(
                          child: Text('Create New Profile', style: TextStyle(color: widget.model.disabledTextColor)),
                        ),
                      ),
                    ),
                  ]
                ),
              )
            ),
          ),
        ),

        const SizedBox(height: 18),
        // Divider(color: widget.model.disabledTextColor),
        // const SizedBox(height: 18),
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //       color: widget.model.mobileBackgroundColor.withOpacity(0.35),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const SizedBox(height: 8),
        //         Text('Appearances', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
        //         const SizedBox(height: 18),
        //         Padding(
        //           padding: const EdgeInsets.all(15.0),
        //           child: widgetForEmptyReturns(
        //               context,
        //               widget.model,
        //               Icons.date_range_rounded,
        //               'No Reservations Joined Yet!',
        //               'Let your community know exactly where to find you by joining the reservations you plan to be at - all Reservations you join as a Vendor will show up here.',
        //               'Join as Vendor'
        //           ),
        //         ),
        //       ],
        //     )
        //   ),
        // ),
      ],
    );
  }

  //// --- APPEARANCES --- ////

  Widget _buildAttendingReservations() {
    return ReservationAttendingPreviewerListWidget(
      model: widget.model,
      showLoadingList: true,
      titleText: 'Appearances',
      isPagingView: true,
      selectedReservationId: null,
      currentUserId: widget.currentUser.userId,
      didSelectReservation: (item) async {
        didSelectReservationPreview(context, widget.model, item);
      },
      reservations: widget.attending.where((e) => e.contactStatus == ContactStatus.joined).map((f) => f.reservationId).toList(),
    );
  }

  Widget _buildEmptyAttendingOwner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Thinking of Participating in an Activity??',
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
            'heck out Organizers and Activities Happening soon near you - find one and apply!.',
            style: TextStyle(color: widget.model.disabledTextColor),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              _fetchAppOption();
              // Handle access request logic here
              if (appOptionSettings == null) {
                widget.didSelectAppearancesGetStarted();
                return;
              }
              switch (appOptionSettings!) {
                case AppOption.activities:
                // TODO: Handle this case.
                  widget.didSelectAppearancesGetStarted();
                  break;
                case AppOption.organizers:
                  final newUrl = Uri.base.origin + searchExploreRoute();
                  final canLaunch = await canLaunchUrlString(newUrl);

                  if (canLaunch) {
                    await launchUrlString(newUrl);
                  }
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
                child: Text('Get Started', style: TextStyle(color: widget.model.disabledTextColor)),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEmptyAttendingNonOwner() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Vending Yet!',
            style: TextStyle(
              color: widget.model.disabledTextColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.model.secondaryQuestionTitleFontSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to know when ${widget.currentUser.legalName.getOrCrash()} plans to participate in their first & second & third &...activity',
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


  //// ----- MY SETUP ----- /////
  Widget _buildNoSetup() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No Setups Added Yet',
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

}

