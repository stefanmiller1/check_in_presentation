part of check_in_presentation;

Widget profileHeaderContainer(UserProfileModel profile, DashboardModel model, bool isCurrentUser, int? listingCount, int? joinedResCount, String userId, {required Function() editProfile, required Function() didSelectShare}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              mobileUserProfileWidget(
                  model,
                  profile: profile,
                  showBadge: true,
                  radius: 80,
                  onTapUserProfile: (UserProfileModel profile) {

                }
              ),
              IconButton(
                  onPressed: () => didSelectShare(),
                  icon: Icon(CupertinoIcons.share, color: model.disabledTextColor)
              ),
            ],
          ),

          Row(
            children: [
              if (listingCount != null) Column(
                children: [
                  Icon(Icons.home_outlined, color: model.paletteColor),
                  Text('Hosting', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                  Text(listingCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(width: 14),
              Column(
                children: [
                  Icon(Icons.calendar_today_outlined, color: model.paletteColor),
                  Text('Activities', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                  FutureBuilder<int>(
                    future: facade.ReservationFacade.instance.getNumberOfReservationsBooked(
                        listingId: null,
                        statusType: [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current],
                        hoursTimeAhead: null,
                        hoursTimeBefore: null,
                        isActivity: null,
                        userId: userId
                    ),
                    builder: (context, snap) {
                      if (!(snap.hasData) || snap.data == null) {
                        return Text('0', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold));
                      }
                      return Text('${snap.data}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold));
                    }
                  ),
                ],
              ),
              const SizedBox(width: 14),
              if (joinedResCount != null) Column(
                children: [
                  Icon(Icons.accessibility_new_rounded, color: model.paletteColor),
                  Text('Joined', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                  Text(joinedResCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                ],
              )
            ],
          )
        ],
      ),
      SizedBox(height: 12),
      Text(profile.legalName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
      SizedBox(height: 2),
      Text('Joined in ${DateFormat.y().format(profile.joinedDate)}', style: TextStyle(color: model.disabledTextColor)),
      // SizedBox(height: 12),

       if (isCurrentUser) Column(
         children: [
           const SizedBox(height: 12),
           InkWell(
             onTap: () {
               editProfile();
             },
             child: Container(
               height: 50,
               decoration: BoxDecoration(
                 color: model.accentColor,
                 borderRadius: BorderRadius.circular(15),
                 // border: Border.all(color: model.disabledTextColor)
               ),
               child: Center(
                 child: Text('Edit My Profile', style: TextStyle(color: model.paletteColor)),
               ),
             ),
           ),
         ],
       )
    ],
  );
}

Widget mainPagedListViewContainer(BuildContext context, bool isMobileOnly, double width, double subWidth, int index, Widget pagedList, Widget subContainer) {
  /// if mobile (column condition)
  /// if desktop (row condition)
  final isMobile = isMobileOnly || Responsive.isMobile(context);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Flexible(
        child: Container(
          width: (isMobileOnly) ? (isMobile) ? 500 : MediaQuery.of(context).size.width : subWidth + 150,
          // constraints: (isMobile) ? BoxConstraints(
          //   maxWidth: 500
          // ) : null,
          child: Column(
            children: [
              if (index == 0) const SizedBox(height: 10),
              if (isMobile && index == 0) subContainer,
              pagedList,
            ]
          ),
        ),
      ),
      if (!(isMobile)) Flexible(
        child: SizedBox(
          width: width,
        ),
      ),
    ]
  );
}

Widget getVendorMerchProfileHeader(DashboardModel model, bool isOwner, EventMerchantVendorProfile profile, int? resJoinedCount, {required Function() didSelectShare, required Function() didSelectAddPartners, required Function() didSelectEdit}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CachedNetworkImage(
                imageUrl: profile.uriImage?.uriPath ?? '',
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 40,
                  backgroundColor: model.accentColor,
                  backgroundImage: imageProvider, // Cached image as the background
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: model.paletteColor)
                  ),
                  child: Center(
                    child: Text(profile.brandName.getOrCrash()[0], style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => didSelectShare(),
                      icon: Icon(CupertinoIcons.share, color: model.disabledTextColor)
                  ),
                  if (isOwner) IconButton(
                      onPressed: () => didSelectAddPartners(),
                      icon: Icon(CupertinoIcons.person_crop_circle_badge_plus, color: model.disabledTextColor)
                  ),
                ],
              )
            ],
          ),
          if (resJoinedCount != null) Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Column(
              children: [
                Icon(Icons.accessibility_new_rounded, color: model.paletteColor),
                Text('Joined', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                Text(resJoinedCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
              ],
            ),
          ),

        ],
      ),
      const SizedBox(height: 8),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profile.brandName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
                child: Text(profile.backgroundInfo.getOrCrash(), style: TextStyle(color: model.disabledTextColor))
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 4,
        runSpacing: 2,
        children: [
          if (profile.instagramLink != null && profile.instagramLink!.isNotEmpty) InkWell(
            mouseCursor: WidgetStateMouseCursor.clickable,
            onTap: () async {
              if (await canLaunchUrlString('https://www.instagram.com/${profile.instagramLink}')) {
                launchUrlString('https://www.instagram.com/${profile.instagramLink}');
              }
            },
            child: Chip(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              backgroundColor: model.accentColor,
              avatar: Icon(Icons.photo_camera_outlined, size: 25, color: model.disabledTextColor),
              label: Text('${profile.instagramLink!}  ', style: TextStyle(fontSize: 17.5)),
              labelPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            ),
            if (profile.websiteLink != null) InkWell(
            mouseCursor: WidgetStateMouseCursor.clickable,
            onTap: () async {
              if (await canLaunchUrlString('https://www.${profile.websiteLink}')) {
              launchUrlString('https://www.${profile.websiteLink}');
              }
            },
            child: Chip(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              backgroundColor: model.accentColor,
              avatar: Icon(CupertinoIcons.globe, size: 25, color: model.disabledTextColor),
              label: Text('${profile.websiteLink!} ', style: TextStyle(fontSize: 17.5)),
              labelPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          )
        ],
      ),
      if (isOwner) Column(
        children: [
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              didSelectEdit();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.circular(15),
                // border: Border.all(color: model.disabledTextColor)
              ),
              child: Center(
                child: Text('Edit My Profile', style: TextStyle(color: model.paletteColor)),
              ),
            ),
          ),
        ],
      )
    ]
  );
}


// - [ ] Non-profile owner:
   // - [ ] Send invite 
   // - [ ] Send Msg Request
   // - [ ] Send message 
   // - [ ] View circles 
   // - [ ] Join public circles 
   // - [ ] View status (looking, planning?)
   // - [ ] View interests…product types…
// - [ ] Profile Owner:
   // - [ ] Create a group (Circle) 
   // - [ ] Create Activity 
   // - [ ] Create Appearance
   // - [ ] Update/delete/leave circles 
   // - [ ] Change status 
   // - [ ] Update interests 
   // - [ ] Update. Calendar (unavailable/free)
   // - [ ] Review Invites 
   // - [ ] Add appearance
   // - [ ] Get verified 

String getLastSeenText(DateTime lastSeen) {
  final now = DateTime.now();
  final difference = now.difference(lastSeen);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()} months ago';
  } else {
    return '${(difference.inDays / 365).floor()} years ago';
  }
}

Widget buildProfileVisitorActionButtons(BuildContext context, DashboardModel model, bool isOwner, List<CircleProfileItem> circleProfiles, UserProfileModel userProfile, EventMerchantVendorProfile? vendorProfile, ProfileTypeMarker userType, {required Function() didSelectSendMessage}) {
  final List<CircleData> circles = [
      CircleData(
        imageUrl: null,
        score: 5,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 3,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 8,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 7,
        isElevated: false,
        color: model.accentColor
      ),
      CircleData(
        imageUrl: null,
        score: 15,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 1,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 2,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 10,
        isElevated: false,
        color: model.accentColor,
      ),
      CircleData(
        imageUrl: null,
        score: 10,
        isGetStarted: true,
        isElevated: false,
        color: model.accentColor,
      ),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 18),
      // if (userProfile.lastSeen != null) Padding(
      //   padding: const EdgeInsets.all(4.0),
      //   child: Container(
      //     height: 60,
      //     constraints: BoxConstraints(maxWidth: 500),
      //     child: ListTile(
      //       leading: Icon(Icons.access_time, color: model.disabledTextColor),
      //       title: Text('Last seen', style: TextStyle(color: model.disabledTextColor)),
      //       subtitle: Text(getLastSeenText(userProfile.lastSeen!), style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold))
      //     ),
      //   ),
      // ),
      if (userType == ProfileTypeMarker.vendorProfile && vendorProfile != null) Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 60,
          constraints: BoxConstraints(maxWidth: 500),
          child: ListTile(
            leading: Icon(
              vendorProfile.workStatus == WorkAvailabilityStatus.available ? Icons.check_circle_outline :
              vendorProfile.workStatus == WorkAvailabilityStatus.booked ? Icons.work_off :
              vendorProfile.workStatus == WorkAvailabilityStatus.lookingForWork ? Icons.search :
              Icons.work, // default icon
              color: model.disabledTextColor
              ),
              title: Text('Work Status', style: TextStyle(color: model.disabledTextColor)),
                trailing: (isOwner) ? InkWell(
                  onTap: () {
                  // Handle edit status action
                  },
                  child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: model.accentColor,
                  ),
                  child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Edit Status', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                        ),
                      ),
                    ),
                  ) : Visibility(
                  visible: vendorProfile.workStatus == WorkAvailabilityStatus.available || vendorProfile.workStatus == WorkAvailabilityStatus.lookingForWork || vendorProfile.workStatus == null,
                  child: InkWell(
                    onTap: () { 
                      // Handle send invite action
                    },
                    child: Container(
                      height: 45,
                      width: 150,
                      constraints: BoxConstraints(maxWidth: 500),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: model.paletteColor,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Send Invite',
                            style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              subtitle: Text((vendorProfile.workStatus != null) ? getWorkAvailabilityStatusTitle(vendorProfile.workStatus!) : 'Looking For Work', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      const SizedBox(height: 8),
      if (circleProfiles.isEmpty) Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 60,
              constraints: BoxConstraints(maxWidth: 500),
              child: ListTile(
                leading: Icon(Icons.circle_outlined, color: model.disabledTextColor),
                title: Text('O\'s Joined and Started', style: TextStyle(color: model.disabledTextColor)),
                trailing: (isOwner || circleProfiles.isNotEmpty) ? InkWell(
                  onTap: () {
                    // Handle the button action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black,
                        content: Text('The ability to create ACIRCLE is coming soon!', style: TextStyle(color: Colors.white),),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: (!isOwner) ? model.paletteColor : model.accentColor,
                    ),
                    child: Center(
                      child: Text(isOwner ? 'Create' : 'Join', style: TextStyle(color: (!isOwner) ? model.accentColor : model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                    ),
                  ),
                ) : null,
                // subtitle: Text('View all circles and activities', style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold)),
                // onTap: () {
                //   // Handle the tap action
                // },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 160,
              constraints: BoxConstraints(maxWidth: 500),
              child: CircleClusterWidget(
                circles: circles,
                circlePadding: 15,
                minWidth: 15,
                maxWidth: 40,
                width: (MediaQuery.of(context).size.width <= 500) ? MediaQuery.of(context).size.width - 50 : 500,
                height: 150
              ),
            ),
          ),
        ],
      ),

      if (!isOwner) Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: () {
            didSelectSendMessage();
          },
          child: Container(
            height: 45,
            constraints: BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: model.paletteColor,
            ),
            child: Center(
              child: Text('Send Message', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget verificationsAndConfirmations(DashboardModel model, UserProfileModel profile) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text('Confirmations', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 18),
      if (profile.isPhoneAuth && profile.isEmailAuth) Row(
        children: [
          Icon(Icons.verified, color: model.paletteColor,),
          const SizedBox(width: 8),
          Text('Verified Identity', style: TextStyle(color: model.paletteColor))
        ],
      ),
      if (profile.isPhoneAuth && !profile.isEmailAuth || !profile.isPhoneAuth && profile.isEmailAuth || !profile.isPhoneAuth && !profile.isEmailAuth) Row(
        children: [
          Icon(Icons.verified_outlined, color: model.disabledTextColor),
          const SizedBox(width: 8),
          Text('Identity Not Yet Verified', style: TextStyle(color: model.disabledTextColor))
        ],
      ),
      const SizedBox(height: 12),
      if (profile.isPhoneAuth) Row(
        children: [
          Icon(Icons.info, color: model.paletteColor,),
          const SizedBox(width: 8),
          Text('Verified Phone Number', style: TextStyle(color: model.paletteColor))
        ],
      ),
      if (!profile.isPhoneAuth) Row(
        children: [
          Icon(Icons.info, color: model.disabledTextColor,),
          const SizedBox(width: 8),
          Text('Phone Number Not Yet Verified', style: TextStyle(color: model.disabledTextColor))
        ],
      ),

      const SizedBox(height: 12),
      if (profile.isEmailAuth) Row(
        children: [
          Icon(Icons.privacy_tip, color: model.paletteColor,),
          const SizedBox(width: 8),
          Text('Verified Email', style: TextStyle(color: model.paletteColor))
        ],
      ),
      if (!profile.isEmailAuth) Row(
        children: [
          Icon(Icons.privacy_tip, color: model.disabledTextColor,),
          const SizedBox(width: 8),
          Text('Email Not Yet Verified', style: TextStyle(color: model.disabledTextColor))
        ],
      ),
    ],
  );
}

// Widget getCircleCommunity(BuildContext context, DashboardModel model) {
//   return
// }

Widget getHostingListings(BuildContext context, UserProfileModel profile, List<ListingManagerForm> listings, DashboardModel model) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${profile.legalName.getOrCrash()}\'s Facilities', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
        const SizedBox(height: 18),
        if (listings.isEmpty) widgetForEmptyReturns(
            context,
            model,
            Icons.event,
            'No Facilities Yet!',
            'Make your space available for any activity you\'d like to support, if the space is yours let people temporarily co-opt it into their needs.',
            'Create a Facility'
        ),
      ],
    ),
  );
}


Widget getUpComingReservations(BuildContext context, UserProfileModel currentUser,  PageController? pageController, List<ReservationItem> reservations, DashboardModel model, {required Function(DashboardModel model, ListingManagerForm listing, ReservationItem reservationItem, bool isReservationOwner, bool isFromChat, UserProfileModel currentUser) didSelectResDetail, required Function(ListingManagerForm listing, ReservationItem res) didSelectReservation}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${currentUser.legalName.getOrCrash()}\'s Reservations/Posts', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
      const SizedBox(height: 18),

      if (reservations.isEmpty) InkWell(
        onTap: () async {
          final Uri params = Uri(
            scheme: 'mailto',
            path: 'hello@cincout.ca',
            query: encodeQueryParameters(<String, String>{
              'subject':'Looking To Join The Beta! - Circle Activities',
              'body': 'Hey! - Use my email to add me to the wait-list!'
            }),
          );

          if (await canLaunchUrl(params)) {
          launchUrl(params);
          }
        },
        child: widgetForEmptyReturns(
          context,
          model,
            Icons.event,
            'No Reservations Yet',
            'If You know of an up-comning reservation or activity or if you\'re planning your own we will be letting anyone post or reserve - everything will be saved here under your profile',
            'Create or Post Reservation'
        ),
      ),

      // if (reservations.isNotEmpty)
      //     Wrap(
      //       alignment: WrapAlignment.center,
      //       spacing: 14,
      //       children: reservations.map(
      //         (e) {
      //               return baseSearchItemContainer(
      //                 model: model,
      //                 backgroundWidget: getReservationMediaFrameFlexible(context, model, 400, 400, listing, activity, e, false, didSelectItem: () {
      //                   Navigator.of(context).push(MaterialPageRoute(
      //                       builder: (_) {
      //                         return ActivityPreviewScreen(
      //                           model: model,
      //                           listing: null,
      //                           reservation: e,
      //                           currentReservationId: e.reservationId,
      //                           currentListingId: e.instanceId,
      //                             didSelectBack: () {}
      //                         );
      //                       }
      //                     )
      //                   );
      //                 }),
      //                 bottomWidget: getSearchFooterWidget(
      //                     context,
      //                     model,
      //                     currentUser.userId,
      //                     model.paletteColor,
      //                     model.disabledTextColor,
      //                     model.accentColor,
      //                     listing,
      //                     activity,
      //                     e,
      //                     false,
      //                     didSelectItem: () {
      //                     },
      //                     didSelectInterested: () {
      //
      //                     }
      //                 )
      //             );
      //         }
      //       ).toList()
      //     ),
          // Container(
          //   height: 143,
          //   child: PageView.builder(
          //       controller: pageController,
          //       itemCount: reservations.length,
          //       scrollDirection: Axis.horizontal,
          //       allowImplicitScrolling: true,
          //       itemBuilder: (_, index) {
          //         final ReservationItem reservation = reservations[index];
          //         return Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //           child: getReservationCardListing(
          //               context,
          //               false,
          //               reservation,
          //               currentUser,
          //               model,
          //               false,
          //               reservation.reservationSlotItem.map((e) => e.selectedDate).where((element) => element.isBefore(DateTime.now())).isNotEmpty,
          //               [],
          //               didSelectResDetail: (model, listing, reservation, isResOwner, isFromChat, currentUser) {
          //                 didSelectResDetail(model, listing, reservation, isResOwner, isFromChat, currentUser);
          //               },
          //               didSelectReservation: (listing, reservation, activity, attendeeItem, activityTickets) {
          //                 didSelectReservation(listing, reservation);
          //           }
          //         ),
          //       );
          //     }
          //   ),
          // )
    ],
  );
}

Widget widgetForEmptyCircleCommunities(BuildContext context, DashboardModel model) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: model.accentColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Icon(Icons.circle_outlined, color: model.disabledTextColor),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('No Circles Joined Yet!', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                const SizedBox(height: 8),
                Text('Find a Circle to get the latest updates about organizers and the activities, discussions and attendees that they have created.', style: TextStyle(color: model.disabledTextColor)),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget widgetForEmptyReturns(BuildContext context, DashboardModel model, IconData icon, String title, String description, String buttonText) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: model.accentColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: model.disabledTextColor),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                    const SizedBox(height: 8),
                    Text(description, style: TextStyle(color: model.disabledTextColor)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          /// Create Your Own
          Container(
              decoration: BoxDecoration(
                color: model.paletteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(buttonText, style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)),
              )
          )
        ],
      ),
    ),
  );
}
// Widget getConversations(List<> profile, DashboardModel model) {
//   return Column(
//     children: [
//       Text('Conversations', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
//
//     ],
//   );
// }