part of check_in_presentation;


enum ResSettingMarker {details, manageActivity, manageAttendance, manageActivityTickets, manageActivityAttendees, manageActivityPasses, messageOwner, sendInvites, addCalendar, receipts, showListing, leaveReservation}
enum ResOverviewMarker {messageHost, receipts, showListing, getSupport}

class ReservationSettingListModel {

  final String title;
  final IconData icon;
  final ResSettingMarker marker;

  ReservationSettingListModel({
    required this.title,
    required this.icon,
    required this.marker
  });
}

class ReservationOverviewModel {

  final String title;
  final IconData icon;
  final ResOverviewMarker marker;

  ReservationOverviewModel({
    required this.title,
    required this.icon,
    required this.marker
  });
}

bool showAffiliateOnBoarding(AttendeeType type) {
  switch (type) {
    case AttendeeType.free:
      return false;
    case AttendeeType.tickets:
      return false;
    case AttendeeType.pass:
      return false;
    case AttendeeType.instructor:
      return true;
    case AttendeeType.vendor:
      return true;
    case AttendeeType.partner:
      return true;
    case AttendeeType.organization:
      return true;
    case AttendeeType.interested:
      return true;
  }
}



List<ReservationSettingListModel> resSettingsList(BuildContext context, ActivityManagerForm? activity, bool isOwner, bool isAttendee) {
  return [
    if (activity != null && activity.activityAttendance.isTicketBased == true && isOwner) ReservationSettingListModel(title: 'Manage Tickets', icon: Icons.airplane_ticket_outlined, marker: ResSettingMarker.manageActivityTickets),
    ReservationSettingListModel(title: (isOwner) ? 'Manage Attendees' : 'Attendees', icon: Icons.people_outline, marker: ResSettingMarker.manageActivityAttendees),
    if (activity != null && activity.activityAttendance.isPassBased == true && isOwner) ReservationSettingListModel(title: 'Manage Passes', icon: Icons.credit_card, marker: ResSettingMarker.manageActivityPasses),
    if (isOwner) ReservationSettingListModel(title: 'Manage Activity', icon: Icons.directions_run_outlined, marker: ResSettingMarker.manageActivity),
    if (isAttendee && !(isOwner)) ReservationSettingListModel(title: 'Manage Attendance', icon: Icons.directions_run_outlined, marker: ResSettingMarker.manageAttendance),
    ReservationSettingListModel(title: 'Reservation Details', icon: Icons.info_outline_rounded, marker: ResSettingMarker.details),
    if (isOwner) ReservationSettingListModel(title: 'Listing Manager', icon: Icons.messenger_outline, marker: ResSettingMarker.messageOwner),
    if (isOwner || activity != null && activity.activityAttendance.isLimitedAttendance == true) ReservationSettingListModel(title: 'Send Invites', icon: Icons.group_outlined, marker: ResSettingMarker.sendInvites),
    ReservationSettingListModel(title: 'Add Dates to Calendar', icon: Icons.calendar_today_outlined, marker: ResSettingMarker.addCalendar),
    if (isOwner) ReservationSettingListModel(title: 'Get Receipt', icon: Icons.receipt_long_rounded, marker: ResSettingMarker.receipts),
    ReservationSettingListModel(title: 'Show Listing', icon: Icons.home_outlined, marker: ResSettingMarker.showListing),
    if (!isOwner) ReservationSettingListModel(title: 'Leave Listing', icon: Icons.cancel_outlined, marker: ResSettingMarker.leaveReservation),
  ];
}


Widget getHostColumn(BuildContext context, UserProfileModel resOwnerProfile, bool isHost, DashboardModel model) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(isHost ? 'Hosted By ${resOwnerProfile.legalName.getOrCrash()}' : 'Posted By ${resOwnerProfile.legalName.getOrCrash()}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 2,),
                Text('Joined ${DateFormat.MMMM().format(resOwnerProfile.joinedDate)} ${DateFormat.y().format(resOwnerProfile.joinedDate)}', style: TextStyle(color: model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1),
              ],
            ),
          ),
          if (resOwnerProfile.profileImage != null) CircleAvatar(radius: 30, foregroundImage: (resOwnerProfile.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image)),
          if (resOwnerProfile.profileImage == null) Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: model.paletteColor)
            ),
            child: Center(
              child: Text(resOwnerProfile.legalName.getOrCrash()[0], style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize)),
            ),
          ),
        ],
      ),
      /// include organization if exists, and all listing owners
      const SizedBox(height: 14),
      Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                if (resOwnerProfile.isEmailAuth && resOwnerProfile.isPhoneAuth) Row(
                  children: [
                    Icon(Icons.verified, color: model.paletteColor,),
                    const SizedBox(width: 6),
                    Text('Verified Listing Host', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))
                  ],
                ),
                if (!(resOwnerProfile.isEmailAuth && resOwnerProfile.isPhoneAuth)) Row(
                  children: [
                    Icon(Icons.verified_outlined, color: model.disabledTextColor),
                    const SizedBox(width: 6),
                    Text('Host is not yet Verified', style: TextStyle(color: model.disabledTextColor),)
                  ],
                )

              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: model.disabledTextColor),
                    const SizedBox(width: 6),
                    Text('No Reviews Yet', style: TextStyle(color: model.disabledTextColor))
                  ],
                )
              ],
            )
          ],
        ),
      ),
      const SizedBox(height: 16),
      Text('Response Rate: --', style: TextStyle(color: model.paletteColor)),
      const SizedBox(height: 8),
      Text('Response Time: --', style: TextStyle(color: model.paletteColor)),

      const SizedBox(height: 18),
      InkWell(
        onTap: () {
          dedSelectProfilePopOverOnly(context, model, resOwnerProfile);
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: model.paletteColor, width: 0.5)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Contact Info', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))),
          ),
        ),
      ),
      const SizedBox(height: 18),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_rounded, color: model.disabledTextColor),
          const SizedBox(width: 4),
          Expanded(
              child: Text('To protect all payments between you and the host, never send or transfer money outside of the CICO app or website.', style: TextStyle(color: model.disabledTextColor)))
        ],
      ),
    ],
  );
}

Widget getPostedOnBehalfColumn(BuildContext context, DashboardModel model, UserProfileModel resOwner, ActivityManagerForm activityForm) {

  bool hasOrganizerDetails = (activityForm.profileService.postContactEmail != null && activityForm.profileService.postContactEmail?.isNotEmpty == true) || (activityForm.profileService.postContactSocialInstagram != null && activityForm.profileService.postContactSocialInstagram?.isNotEmpty == true) || (activityForm.profileService.postContactSocialInstagram != null && activityForm.profileService.postContactSocialInstagram?.isNotEmpty == true);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(40),
      color: model.disabledTextColor.withOpacity(0.2),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          /// who created and posted.
          getHostColumn(
              context,
              resOwner,
              false,
              model
          ),

          /// possible organizer contact details for host
          if (hasOrganizerDetails) Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Organizer Info', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 2,),
                  Text('details about the organizer until - this post can be claimed if you or someone you know is the organizer', style: TextStyle(color: model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                ],
              ),
              //     Column(
              //       children: [
              if (activityForm.profileService.postContactEmail != null && activityForm.profileService.postContactEmail?.isNotEmpty == true) Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: model.disabledTextColor.withOpacity(0.2)
                  ),
                  child: ListTile(
                    onTap: () async {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: activityForm.profileService.postContactEmail!,
                        query: encodeQueryParameters(<String, String>{
                          'subject':'Hello! - ${activityForm.profileService.activityBackground.activityTitle.getOrCrash()}',
                        }),
                      );

                      if (await canLaunchUrl(params)) {
                      launchUrl(params);
                      }
                    },
                    titleTextStyle: TextStyle(color: model.disabledTextColor, decoration: TextDecoration.underline),
                    leading: Icon(CupertinoIcons.mail_solid, color: model.disabledTextColor),
                    title: Text('Organizer Email'),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              if (activityForm.profileService.postContactWebsite != null && activityForm.profileService.postContactWebsite?.isNotEmpty == true) Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: model.disabledTextColor.withOpacity(0.2)
                  ),
                  child: ListTile(
                    onTap: () async {
                      if (await canLaunchUrlString(activityForm.profileService.postContactWebsite!)) {
                        launchUrlString(activityForm.profileService.postContactWebsite!);
                      }
                    },
                    titleTextStyle: TextStyle(color: model.disabledTextColor, decoration: TextDecoration.underline),
                    leading: Icon(CupertinoIcons.globe, color: model.disabledTextColor),
                    title: Text('Organizer Website'),
                  ),
                ),
              ),
              //         const SizedBox(height: 5),
              if (activityForm.profileService.postContactSocialInstagram != null && activityForm.profileService.postContactSocialInstagram?.isNotEmpty == true) Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: model.disabledTextColor.withOpacity(0.2)
                  ),
                  child: ListTile(
                    onTap: () async {
                      if (await canLaunchUrlString('https://instagram.com/${activityForm.profileService.postContactSocialInstagram!}')) {
                        launchUrlString('https://instagram.com/${activityForm.profileService.postContactSocialInstagram!}');
                      }
                    },
                    titleTextStyle: TextStyle(color: model.disabledTextColor),
                    leading: Icon(CupertinoIcons.photo_camera, color: model.disabledTextColor),
                    title: Text('Instagram: ${activityForm.profileService.postContactSocialInstagram!}'),
                  ),
                ),
              ),
              //       ],
              //     )
            ],
          ),

          const SizedBox(height: 18),
          InkWell(
            onTap: () async {
              final Uri params = Uri(
                scheme: 'mailto',
                path: 'hello@cincout.ca',
                query: encodeQueryParameters(<String, String>{
                  'subject':'This Belongs to me! ${activityForm.activityFormId.getOrCrash()}',
                  'body': 'Hey Circle, \n would I be able to claim this reservation?'
                }),
              );
                if (await canLaunchUrl(params)) {
                launchUrl(params);
              }
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color:  model.paletteColor,
                  border: Border.all(color: model.paletteColor, width: 0.5)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Claim Now', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    ),
  );
}

void presentNewAttendeeJoin(BuildContext context, DashboardModel model, ListingManagerForm listingForm, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb && (Responsive.isMobile(context) == false)) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 800,
                  width: 600,
                  decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ReservationCreateNewAttendee(
                    model: model,
                    listingForm: listingForm,
                    reservation: reservation,
                    activityForm: activity,
                    resOwner: reservationOwner,
                    isFromInvite: false,
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ReservationCreateNewAttendee(
            model: model,
            listingForm: listingForm,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
        })
    );
  }
}

void presentNewTicketAttendeeJoin(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 750,
                    width: 600,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: ReservationCreateTicketAttendee(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ReservationCreateTicketAttendee(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
          );
        }
    )
    );
  }
}




void presentPartnershipRequestAttendee(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb && (Responsive.isMobile(context) == false)) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 750,
                    width: 600,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: ReservationRequestPartnershipAttendee(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                      isFromInvite: false,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ReservationRequestPartnershipAttendee(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
        }
    )
    );
  }
}



void presentNewInstructorAttendee(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb && (Responsive.isMobile(context) == false)) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 750,
                    width: 600,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: CreateNewInstructorForm(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                      isFromInvite: false,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return CreateNewInstructorForm(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            isFromInvite: false,
          );
        }
    )
    );
  }
}


void presentNewVendorAttendee(BuildContext context, DashboardModel model, VendorMerchantForm? vendorForm, ListingManagerForm listingForm, ReservationItem reservation, ActivityManagerForm activity, UserProfileModel reservationOwner) {
  if (kIsWeb && (Responsive.isMobile(context) == false)) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 925,
                    width: 590,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: CreateNewVendorMerchant(
                      model: model,
                      reservation: reservation,
                      activityForm: activity,
                      resOwner: reservationOwner,
                      listingForm: listingForm,
                      isFromInvite: false,
                      isPreview: false,
                      vendorForm: vendorForm,
                    )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return CreateNewVendorMerchant(
            model: model,
            reservation: reservation,
            activityForm: activity,
            resOwner: reservationOwner,
            listingForm: listingForm,
            isFromInvite: false,
            isPreview: false,
            vendorForm: vendorForm,
          );
        },
        fullscreenDialog: true
      )
    );
  }
}


//// RESERVATION FUNCTION HANDLERS ////
void presentMoreOptions(BuildContext context, DashboardModel model, bool isReservationOwner, UserProfileModel currentUser, ActivityManagerForm? activity, ReservationItem reservation, ListingManagerForm listing, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendee, {required Function(ResSettingMarker) didUpdateMarkerWeb, required Function didLeaveListing}) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 600,
            decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: resSettingsList(context, activity, isReservationOwner, currentAttendee != null).map(
                        (e) => profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        true,
                        didSelectItem: () {
                          Navigator.of(context).pop();

                          if (!(kIsWeb)) {
                            switch (e.marker) {
                              case ResSettingMarker.details:
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return ReservationDetailsWidget(
                                      model: model,
                                      listing: listing,
                                      reservationItem: reservation,
                                      isReservationOwner: isReservationOwner,
                                      allAttendees: allAttendees,
                                      currentUser: currentUser,
                                      isFromChat: false
                                  );
                                })
                                );
                                break;
                              case ResSettingMarker.messageOwner:
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (_) {
                                      return DirectChatScreen(
                                        model: model,
                                        room: null,
                                        currentUser: currentUser,
                                        reservationItem: reservation,
                                        isFromReservation: true,
                                      );
                                    }));

                                break;
                              case ResSettingMarker.sendInvites:
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return SendInvitationRequest(
                                    model: model,
                                    currentUserId: currentUser.userId.getOrCrash(),
                                    attendeeType: AttendeeType.free,
                                    reservationItem: reservation,
                                    inviteType: InvitationType.reservation,
                                    didSelectInvite: (contacts) {},

                                  );
                                })
                                );
                                break;
                              case ResSettingMarker.addCalendar:
                              // TODO: Handle this case.
                                break;
                              case ResSettingMarker.receipts:
                                if (reservation.receipt_link != null) {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) {
                                        return WebViewWidgetComponent(
                                          urlString: reservation.receipt_link!,
                                          model: model,
                                        );
                                      })
                                  );
                                }
                                break;
                              case ResSettingMarker.showListing:
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return FacilityPreviewScreen(
                                    isAutoImplyLeading: true,
                                    model: model,
                                    listing: listing,
                                    selectedReservationsSlots: null,
                                    listingId: listing.listingServiceId,
                                    // marker: MapMarker(
                                    //     childMarkerId: listing.listingServiceId.getOrCrash(),
                                    //     markerId: listing.listingServiceId.getOrCrash(),
                                    //     position: LatLng(
                                    //         double.parse(listing
                                    //             .listingProfileService.listingLocationSetting.longLat
                                    //             .split(',')[0]),
                                    //         double.parse(listing
                                    //             .listingProfileService.listingLocationSetting.longLat
                                    //             .split(',')[1])),
                                    //     markerTitle: completeTotalPriceWithOutCurrency((listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate ?? 0).toDouble(), listing.listingProfileService.backgroundInfoServices.currency),
                                    //     icon: BitmapDescriptor.defaultMarker
                                    //  ).toMarker(),
                                        didSelectBack: () {

                                        },
                                        didSelectReservation: (listing, res) {

                                        },
                                      );
                                    }
                                  )
                                );
                                break;
                              case ResSettingMarker.manageActivity:
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return ActivitySettingsScreenMobile(
                                    model: model,
                                    reservationItem: reservation,
                                    activityManagerForm: activity,
                                    listing: listing,
                                    currentUser: currentUser,
                                  );
                                }));
                                break;
                              case ResSettingMarker.manageAttendance:
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return ActivitySettingsScreenMobile(
                                    model: model,
                                    reservationItem: reservation,
                                    activityManagerForm: activity,
                                    listing: listing,
                                    currentUser: currentUser,
                                  );
                                }));
                                break;
                              case ResSettingMarker.leaveReservation:
                                didLeaveListing();
                                break;
                              case ResSettingMarker.manageActivityAttendees:
                                Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
                                  return ActivityAttendeesListScreen(
                                      model: model,
                                      reservationItem: reservation,
                                      activityManagerForm: activity,
                                      attendeeTypeTab: null,
                                      currentUser: currentUser.userId.getOrCrash(),
                                      didSelectAttendee: (AttendeeItem attendee, UserProfileModel user) {
                                        dedSelectProfilePopOverOnly(context, model, user);

                                  });
                                }));
                                break;
                              case ResSettingMarker.manageActivityPasses:
                                break;
                              case ResSettingMarker.manageActivityTickets:
                                Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
                                  return ActivityTicketSubContainer(
                                      model: model,
                                      currentReservationItem: reservation,
                                      currentActivityManagerForm: activity,
                                      didSelectTicketItem: (ticket) {
                                        Navigator.of(newContext).push(MaterialPageRoute(builder: (_) {
                                          return ActivityTicketSettingsMainContainerWidget(
                                            model: model,
                                            reservationItem: reservation,
                                            activityManagerForm: activity,
                                            selectedTicketOption: ticket,
                                            rebuild: () {

                                            },
                                          );
                                        })
                                        );
                                      }
                                  );
                                }));
                                break;
                            }
                          } else {
                            didUpdateMarkerWeb(e.marker);
                          }
                        }
                    ),
                  ).toList()
              ),
            ),
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 600,
              height: 45,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
              ),
            )
          ],
        ),
      );
    }
  );
}


void didSelectSimilarReservation(BuildContext context, DashboardModel model, ReservationPreviewer res) async {
  if (res.reservation == null) {
    return;
  }

  if (kIsWeb) {
    final newUrl = getUrlForActivity(res.reservation!.instanceId.getOrCrash(), res.reservation!.reservationId.getOrCrash());
    final canLaunch = await canLaunchUrlString(newUrl);

    if (canLaunch) {
      await launchUrlString(newUrl);
    }

  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
            return ActivityPreviewScreen(
              model: model,
              listing: res.listing,
              reservation: res.reservation,
              currentReservationId: res.reservation!.reservationId,
              currentListingId: res.reservation!.instanceId,
              didSelectBack: () {

              },
            );

    }));
  }
}

void didSelectShowMoreSimilarReservations(BuildContext context) {
  if (kIsWeb) {

  } else {

  }
}