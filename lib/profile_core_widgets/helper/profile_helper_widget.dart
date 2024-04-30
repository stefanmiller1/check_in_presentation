part of check_in_presentation;

Widget profileHeaderContainer(UserProfileModel profile, DashboardModel model, bool isCurrentUser, int listingCount, int reservationCount, int joinedResCount, {required Function() editProfile}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mobileUserProfileWidget(
              model,
              profile: profile,
              showBadge: true,
              radius: 80,
              onTapUserProfile: (UserProfileModel profile) {

            }
          ),

          Row(
            children: [
              Column(
                children: [
                  Icon(Icons.home_outlined, color: model.paletteColor),
                  Text('Hosting'),
                  Text(listingCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(width: 14),
              Column(
                children: [
                  Icon(Icons.calendar_today_outlined, color: model.paletteColor),
                  Text('Reservations'),
                  Text(reservationCount.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(width: 14),
              Column(
                children: [
                  Icon(Icons.accessibility_new_rounded, color: model.paletteColor),
                  Text('Joined'),
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

      // if (isCurrentUser) InkWell(
      //   onTap: () {
      //     editProfile();
      //   },
      //   child: Container(
      //     height: 45,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(15),
      //       color: model.accentColor
      //     ),
      //     child: Center(
      //       child: Text('Edit Profile', style: TextStyle(color: model.paletteColor)),
      //     ),
      //   ),
      // )
    ],
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
              CircleAvatar(
                radius: 40,
                foregroundImage: (profile.uriImage?.uriPath != null) ? Image.network(profile.uriImage!.uriPath!).image : null,
                backgroundColor: model.accentColor,
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
                  if (isOwner) IconButton(
                      onPressed: () => didSelectEdit(),
                      icon: Icon(CupertinoIcons.settings, color: model.disabledTextColor)
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
                Text('Joined'),
                Text(resJoinedCount!.toString(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
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
                child: Text(profile.backgroundInfo.getOrCrash())
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 4,
        runSpacing: 2,
        children: [
          if (profile.instagramLink != null) InkWell(
            onTap: () async {
              if (await canLaunchUrlString('https://www.instagram.com/${profile.instagramLink}')) {
                launchUrlString('https://www.instagram.com/${profile.instagramLink}');
              }
            },
            child: Chip(
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: model.mobileBackgroundColor.withOpacity(0.3),
                avatar: Icon(Icons.photo_camera_outlined, color: model.disabledTextColor),
                label: Text(profile.instagramLink!)
            ),
          ),
          if (profile.websiteLink != null) InkWell(
            onTap: () async {
              if (await canLaunchUrlString('https://www.${profile.websiteLink}')) {
                launchUrlString('https://www.${profile.websiteLink}');
              }
            },
            child: Chip(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: model.mobileBackgroundColor.withOpacity(0.3),
              avatar: Icon(CupertinoIcons.globe, color: model.disabledTextColor),
              label: Text(profile.websiteLink!)
            ),
          )
        ],
      )

    ]
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

      if (reservations.isNotEmpty)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 14,
            children: reservations.map(
              (e) {
                return FutureBuilder<ListingManagerForm?>(
                  future: facade.ListingFacade.instance.getListingManagerItem(listingId: e.instanceId.getOrCrash()),
                  builder: (context, listingSnap) {
                    if (listingSnap.connectionState == ConnectionState.waiting) {
                      // return JumpingDots(color: model.paletteColor, numberOfDots: 3);
                    } else if (listingSnap.data == null) {

                    }

                    final listing = listingSnap.data;

                    return FutureBuilder<ActivityManagerForm?>(
                        future: facade.ActivitySettingsFacade.instance.getActivitySettings(reservationId: e.reservationId.getOrCrash()),
                          builder: (context, activitySnap) {
                            if (activitySnap.connectionState == ConnectionState.waiting) {
                            // return JumpingDots(color: model.paletteColor, numberOfDots: 3);
                            } else if (activitySnap.data == null) {
                              return Container();
                            }

                          final activity = activitySnap.data;

                          return baseSearchItemContainer(
                            model: model,
                            backgroundWidget: getReservationMediaFrameFlexible(context, model, 400, 400, listing, activity, e, false, didSelectItem: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) {
                                    return ActivityPreviewScreen(
                                      model: model,
                                      listing: null,
                                      reservation: e,
                                      currentReservationId: e.reservationId,
                                      currentListingId: e.instanceId,
                                        didSelectBack: () {}
                                    );
                                  }
                                )
                              );
                            }),
                            bottomWidget: getSearchFooterWidget(
                                context,
                                model,
                                currentUser.userId,
                                model.paletteColor,
                                model.disabledTextColor,
                                model.accentColor,
                                listing,
                                activity,
                                e,
                                false,
                                didSelectItem: () {
                                },
                                didSelectInterested: () {

                                }
                            )
                        );
                      }
                    );
                  }
                );
              }
            ).toList()
          ),
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