part of check_in_presentation;

class ReservationActivityInfoWidget extends StatelessWidget {
  final DashboardModel model;
  final bool showSuggestions;
  final bool isOwner;
  final bool activitySetupComplete;
  final bool isLoading;
  final ListingManagerForm listingForm;
  final ActivityManagerForm activityForm;
  final ReservationItem reservation;
  final UserProfileModel? activityOwner;
  final List<AttendeeItem> allAttendees;
  final List<EventMerchantVendorProfile> allVendors;
  final List<UniqueId> linkedCommunities;
  final Function(ActivityTicketOption) didSelectActivityTicket;
  final Function() didSelectShowReservation;
  final Function() didSelectSeeMoreReservations;
  final Function(ReservationPreviewer) didSelectSimilarRes;

  const ReservationActivityInfoWidget({
    super.key,
    required this.model,
    required this.activityForm,
    required this.activityOwner,
    required this.listingForm,
    required this.reservation,
    required this.didSelectActivityTicket,
    required this.allAttendees,
    required this.showSuggestions,
    required this.isOwner,
    required this.activitySetupComplete,
    required this.linkedCommunities,
    required this.didSelectShowReservation,
    required this.didSelectSeeMoreReservations,
    required this.didSelectSimilarRes,
    required this.isLoading,
    required this.allVendors,
  });

  @override
  Widget build(BuildContext context) {
    final isWebMobile = kIsWeb && Responsive.isMobile(context);
    final String? currentUser = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    final AttendeeItem? currentAttendee = allAttendees.firstWhereOrNull((element) => element.attendeeOwnerId.getOrCrash() == currentUser);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: kIsWeb ? 80 : 155),
        _buildActivitySetupStack(context),
        const SizedBox(height: 8),
        _buildActivityBackgroundInfo(context),
        if (!kIsWeb) _buildMoreInfoButton(context),
        const SizedBox(height: 5),
        // Divider(color: model.paletteColor.withOpacity(0.1)),
        // const SizedBox(height: 5),
        // _buildActivityType(context),
        // const SizedBox(height: 5),
        Divider(color: model.paletteColor.withOpacity(0.1)),
        const SizedBox(height: 5),
        if (_shouldShowHostColumn(context)) _buildHostColumn(context, currentUser, currentAttendee),
        if (_shouldShowPostedOnBehalfColumn(context)) _buildPostedOnBehalfColumn(context, currentUser, currentAttendee),

        _buildActivityRequirementsColumn(context),
        if (activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true) _buildMerchantSupportColumn(context, listingForm, currentAttendee),
        if (activityForm.activityAttendance.isTicketBased == true) _buildTicketOptionsColumn(context),
        const SizedBox(height: 5),
        Divider(color: model.paletteColor.withOpacity(0.1)),
        const SizedBox(height: 5),
        _buildReportActivityColumn(reservation.reservationId.getOrCrash()),
        const SizedBox(height: 10),
        if (!isWebMobile) _buildSimilarActivitiesColumn(context, reservation),
        if (MediaQuery.of(context).size.width <= 1600) Container(
            width: MediaQuery.of(context).size.width,
            child: BasicWebFooter(model: model)
        ),
        const SizedBox(height: 190),
      ],
    );
  }

  Widget _buildActivitySetupStack(BuildContext context) {
    // final isWebMobile = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
    final isWebMobile = kIsWeb && Responsive.isMobile(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Stack(
        children: [
          Visibility(
            visible: !activitySetupComplete,
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 285,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: model.disabledTextColor.withOpacity(0.25),
                  border: Border.all(color: model.disabledTextColor),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: model.disabledTextColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, color: model.disabledTextColor),
                                const SizedBox(height: 8),
                                Text('Add Photos', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!isWebMobile) Visibility(
            visible: activitySetupComplete,
            child: ActivityBackgroundImagePreview(
              activityForm: activityForm,
              model: model,
              reservation: reservation,
            ),
          ),
          if (isWebMobile) Visibility(
            visible: activitySetupComplete,
            child: ActivityBackgroundImagePreviewMobileWeb(
              activityForm: activityForm,
              model: model,
              reservation: reservation,
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: showSuggestions ? 1 : 0,
              child: Chip(
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: model.mobileBackgroundColor,
                avatar: Icon(Icons.photo_camera_outlined, color: model.disabledTextColor),
                label: Text('Add Photos (a max. of 6)', style: TextStyle(color: model.disabledTextColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityBackgroundInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: getActivityBackgroundColumn(
        context,
        model,
        activitySetupComplete,
        showSuggestions,
        isOwner,
        activityForm,
        activityOwner,
        getPartnerAttendees(context, model, activityForm, _getPartnerAttendees(), didSelectAttendee: (attendee) {}),
        getInstructorAttendees(context, model, activityForm, _getInstructorAttendees(), didSelectAttendee: (attendee) {}),
        linkedCommunities,
        reservation,
      ),
    );
  }

  Widget _buildMoreInfoButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: didSelectShowReservation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Center(
            child: Text('More Info', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityType(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: (activityForm.activityTypes ?? []).map((activity) {
        return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: model.disabledTextColor),
            color: model.disabledTextColor.withOpacity(0.25),
          ),
          child: Center(
            child: Text(
            getTitleForActivityOption(context, activity.activity) ?? 'To Rent',
            style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
      ),
    );
  }

  bool _shouldShowHostColumn(BuildContext context) {
    return activityOwner != null && activityForm.profileService.isActivityPost == false;
  }

  Widget _buildHostColumn(BuildContext context, String? currentUserId, AttendeeItem? attendee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Responsive.isDesktop(context)
          ? SizedBox(width: 400, child: getHostColumn(context, currentUserId, activityOwner!, true, model, attendee, reservation))
          : getHostColumn(context, currentUserId, activityOwner!, true, model, attendee, reservation),
    );
  }

  bool _shouldShowPostedOnBehalfColumn(BuildContext context) {
    return activityOwner != null &&
        (activityForm.profileService.isActivityPost == true || activityForm.profileService.isActivityPost == null);
  }

  Widget _buildPostedOnBehalfColumn(BuildContext context, String? currentUserId, AttendeeItem? attendee) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Responsive.isDesktop(context)
          ? SizedBox(width: 400, child: getPostedOnBehalfColumn(context, model, activityOwner!, currentUserId, attendee, reservation, activityForm))
          : getPostedOnBehalfColumn(context, model, activityOwner!, currentUserId, attendee, reservation, activityForm),
    );
  }

  Widget _buildActivityRequirementsColumn(BuildContext context) {
    return getActivityRequirementsColumn(
      context,
      model,
      isLoading,
      showSuggestions,
      Responsive.isDesktop(context),
      activityOwner,
      activityForm,
      reservation,
      allAttendees,
      allVendors,
      facade.FirebaseChatCore.instance.firebaseUser?.uid,
      didSelectAttendees: () {
        showAttendeesList(context, model, reservation, activityForm, _getVendorAttendees(), AttendeeType.vendor);
      },
    );
  }

  Widget _buildMerchantSupportColumn(BuildContext context, ListingManagerForm listingForm, AttendeeItem? currentAttendee) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Divider(color: model.paletteColor.withOpacity(0.1)),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: getActivityVendorOptionColumn(
            context,
            model,
            listingForm,
            reservation,
            activityForm,
            activityOwner,
            showSuggestions,
            500,
            _isCurrentUserVendor(),
            didSelectManage: () {
              if (kIsWeb) {
                Beamer.of(context).update(
                    configuration: RouteInformation(
                        location: reservationSettingsRoute(reservation.reservationId.getOrCrash(), SettingNavMarker.vendorForm.name)
                    ),
                    rebuild: true
                );
                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                final SettingNavMarker navItem = getReservationSettingNavMarker(SettingNavMarker.vendorForm.name);
                ReservationHelperCore.currentSettingsItemModel = (subActivitySettingItems(null).isNotEmpty && subActivitySettingItems(null).where((e) => e.navItem == navItem).isNotEmpty) ? subActivitySettingItems(null).where((e) => e.navItem == navItem).first : subActivitySettingItems(null)[0];
                // Handle web-specific logic if any
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ManageAttendeeSettingsSubContainer(
                    model: model,
                    currentSettingItem: null,
                    reservationItem: reservation,
                    currentUser: facade.FirebaseChatCore.instance.firebaseUser?.uid,
                    // currentActivityManagerForm: activityForm,
                    // currentAttendee: currentAttendee,
                    // currentActivityOwnerProfile: activityOwner,
                    didSelectNavItem: (nav) {},
                  );
                }));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTicketOptionsColumn(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Divider(color: model.paletteColor.withOpacity(0.1)),
        const SizedBox(height: 5),
        Row(
          children: [
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: getActivityTicketOptionsColumn(
                  context,
                  model,
                  reservation,
                  activityForm,
                  didSelectTicketOption: didSelectActivityTicket,
                  true && Responsive.isDesktop(context),
                  null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportActivityColumn(String reservationId) {
    return flagOrReportActivityColumn(
      model,
      didSelectReport: () async {
        final Uri params = Uri(
          scheme: 'mailto',
          path: 'hello@cincout.ca',
          query: encodeQueryParameters(<String, String>{
            'subject':'Listing Help - Circle Activities Issue',
            'body': 'There is a problem with this listing - $reservationId'
          }),
        );

        if (await canLaunchUrl(params)) {
          launchUrl(params);
        }
        // Handle report logic if any
      },
    );
  }



  Widget _buildSimilarActivitiesColumn(BuildContext context, ReservationItem currentRes) {
    /// retrieve all reservations based on listings & confirmed, completed & current bookings that will happen between now and 7 days and that have happened in the last 7 days. sort by preview alg.
    /// is there a way to get the best 10?
    /// limit query to reservations happening over the next 7 days.
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchDiscoveryReservationsList([ReservationSlotState.confirmed, ReservationSlotState.current] ,168, null, true)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadDiscoveryReservationItemSuccess: (e) {
                return (e.item.isNotEmpty) ? _getListOfSimilarActivities(context, e.item, currentRes) : Container();
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }


  Widget _getListOfSimilarActivities(BuildContext context, List<ReservationItem> reservations, ReservationItem currentRes) {
    if (reservations.where((element) => element.reservationId != currentRes.reservationId).isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 550,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Divider(color: model.paletteColor.withOpacity(0.1)),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Similar Activities Happening Soon', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,)),
                 InkWell(
                    onTap: () {
                     didSelectSeeMoreReservations();
                     },
                   child: Text('See More', style: TextStyle(decoration: TextDecoration.underline, color: model.paletteColor)))
              ],
            ),
          ),
            const SizedBox(height: 10),
            PagingHorizontalActivitiesWidget(
              model: model,
              reservations: reservations.where((element) => element.reservationId != currentRes.reservationId).toList(),
              didSelectReservation: (res) {
                didSelectSimilarRes(res);
            },
          ),
        ],
      ),
    );
  }


  List<AttendeeItem> _getPartnerAttendees() {
    return allAttendees
        .where((element) =>
    element.attendeeType == AttendeeType.partner &&
        element.contactStatus == ContactStatus.joined)
        .toList();
  }

  List<AttendeeItem> _getInstructorAttendees() {
    return allAttendees
        .where((element) =>
    element.attendeeType == AttendeeType.instructor &&
        element.contactStatus == ContactStatus.joined)
        .toList();
  }

  List<AttendeeItem> _getVendorAttendees() {
    return allAttendees
        .where((element) =>
    element.attendeeType == AttendeeType.vendor &&
        element.contactStatus == ContactStatus.joined)
        .toList();
  }

  bool _isCurrentUserVendor() {
    return allAttendees
        .where((element) => element.attendeeType == AttendeeType.vendor)
        .any((element) =>
    element.attendeeOwnerId.getOrCrash() ==
        facade.FirebaseChatCore.instance.firebaseUser?.uid);
  }
}




// class ReservationActivityInfoWidget extends StatelessWidget {
//
//   final DashboardModel model;
//   final bool showSuggestions;
//   final bool isOwner;
//   final bool activitySetupComplete;
//   final ActivityManagerForm activityForm;
//   final ReservationItem reservation;
//   final UserProfileModel? activityOwner;
//   final List<AttendeeItem> allAttendees;
//   final List<UniqueId> linkedCommunities;
//   final Function(ActivityTicketOption) didSelectActivityTicket;
//   final Function() didSelectShowReservation;
//
//   const ReservationActivityInfoWidget({super.key,
//     required this.model,
//     required this.activityForm,
//     required this.activityOwner,
//     required this.reservation,
//     required this.didSelectActivityTicket,
//     required this.allAttendees,
//     required this.showSuggestions,
//     required this.isOwner,
//     required this.activitySetupComplete,
//     required this.linkedCommunities,
//     required this.didSelectShowReservation
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     final String? currentUser = facade.FirebaseChatCore.instance.firebaseUser?.uid;
//     final AttendeeItem? currentAttendee = allAttendees.where((element) => element.attendeeOwnerId.getOrCrash() == currentUser).isNotEmpty ? allAttendees.where((element) => element.attendeeOwnerId.getOrCrash() == currentUser).first : null;
//
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (kIsWeb) const SizedBox(height: 80),
//         if (!(kIsWeb)) const SizedBox(height: 155),
//         Stack(
//           children: [
//              Visibility(
//               visible: activitySetupComplete == false,
//               child: InkWell(
//                 onTap: () {
//
//                 },
//                 child: Container(
//                   height: 285,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: model.disabledTextColor.withOpacity(0.25),
//                       border: Border.all(color: model.disabledTextColor)
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 border: Border.all(color: model.disabledTextColor)
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Icon(Icons.add_a_photo_outlined, color: model.disabledTextColor),
//                                     const SizedBox(height: 8),
//                                     Text('Add Photos', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // const SizedBox(width: 8),
//                           // Container(
//                           //   decoration: BoxDecoration(
//                           //       borderRadius: BorderRadius.circular(20),
//                           //       border: Border.all(color: model.disabledTextColor)
//                           //   ),
//                           //   child: Padding(
//                           //     padding: const EdgeInsets.all(8.0),
//                           //     child: Column(
//                           //       mainAxisAlignment: MainAxisAlignment.center,
//                           //       crossAxisAlignment: CrossAxisAlignment.center,
//                           //       children: [
//                           //         Icon(Icons.video_camera_front_outlined, color: model.disabledTextColor),
//                           //         const SizedBox(height: 8),
//                           //         Text('Add Short Video', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: activitySetupComplete,
//               child: ActivityBackgroundImagePreview(
//                 activityForm: activityForm,
//                 model: model,
//                 reservation: reservation,
//               ),
//             ),
//             /// show options to add image (6) or video (1)
//             Positioned(
//               left: 20,
//               bottom: 20,
//               child: AnimatedOpacity(
//                 duration: Duration(milliseconds: 300),
//                 opacity: showSuggestions ? 1 : 0,
//                 child: Chip(
//                   side: BorderSide.none,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                   backgroundColor: model.mobileBackgroundColor,
//                   avatar: Icon(Icons.photo_camera_outlined, color: model.disabledTextColor),
//                   label: Text('Add Photos (a max. of 6)', style: TextStyle(color: model.disabledTextColor)),
//                 ),
//               )
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 8),
//         /// background info of activity ///
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0),
//           child: getActivityBackgroundColumn(
//               context,
//               model,
//               activitySetupComplete,
//               showSuggestions,
//               isOwner,
//               activityForm,
//               activityOwner,
//               getPartnerAttendees(context, model, activityForm, allAttendees.where((element) => element.attendeeType == AttendeeType.partner && element.contactStatus == ContactStatus.joined).toList(), didSelectAttendee: (attendee) {}),
//               getInstructorAttendees(context, model, activityForm, allAttendees.where((element) => element.attendeeType == AttendeeType.instructor && element.contactStatus == ContactStatus.joined).toList(), didSelectAttendee: (attendee) {}),
//               linkedCommunities,
//               reservation
//           ),
//         ),
//
//         /// see more
//         if (kIsWeb == false) Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: InkWell(
//             onTap: () {
//               didSelectShowReservation();
//             },
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: model.accentColor,
//                 borderRadius: const BorderRadius.all(Radius.circular(15)),
//               ),
//               child: Align(
//                 child: Text('More Info', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
//               ),
//             ),
//           ),
//         ),
//
//
//         /// activity type ///
//         /// ---------------------------------------------------- ///
//         const SizedBox(height: 5),
//         Divider(color: model.paletteColor),
//         const SizedBox(height: 5),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 2.0),
//           child: ListTile(
//               title: Text(getTitleForActivityOption(context, activityForm.activityType.activityId) ?? 'To Rent', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
//               leading: getActivityFromReservationId(
//                   context,
//                   model,
//                   25,
//                   reservation
//             )
//           ),
//         ),
//
//
//         /// activity requirements
//         /// ---------------------------------------------------- ///
//         const SizedBox(height: 5),
//         Divider(color: model.paletteColor),
//         const SizedBox(height: 5),
//         if (Responsive.isDesktop(context)) if (activityOwner != null) if (activityForm.profileService.isActivityPost == false) Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0),
//           child: SizedBox(
//               width: 400,
//               child: getHostColumn(context, activityOwner!, true, model)),
//         ),
//         if (Responsive.isMobile(context) || Responsive.isTablet(context)) if (activityOwner != null) if (activityForm.profileService.isActivityPost == false) Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 18.0),
//           child: getHostColumn(context, activityOwner!, true, model),
//         ),
//
//         if (Responsive.isDesktop(context))
//         if (activityForm.profileService.isActivityPost == true && activityOwner != null || activityForm.profileService.isActivityPost == null && activityOwner != null) Column(
//           children: [
//             const SizedBox(height: 10),
//             SizedBox(
//                 width: 400,
//                 child: getPostedOnBehalfColumn(context, model, activityOwner!, activityForm))
//             /// claim activity as organizer
//           ],
//         ),
//
//         if (Responsive.isMobile(context) || Responsive.isTablet(context))
//         if (activityForm.profileService.isActivityPost == true && activityOwner != null || activityForm.profileService.isActivityPost == null && activityOwner != null) Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18.0),
//               child: getPostedOnBehalfColumn(context, model, activityOwner!, activityForm),
//             )
//             /// claim activity as organizer
//           ],
//         ),
//
//         getActivityRequirementsColumn(
//             context,
//             model,
//             showSuggestions,
//             Responsive.isDesktop(context),
//             activityOwner,
//             activityForm,
//             reservation,
//             allAttendees.where((element) => element.attendeeType == AttendeeType.vendor && element.contactStatus == ContactStatus.joined).toList(),
//             facade.FirebaseChatCore.instance.firebaseUser?.uid,
//             didSelectAttendees: () {
//                 if (kIsWeb) {
//
//                 } else {
//                   Navigator.of(context).push(MaterialPageRoute(builder: (newContext) {
//                     return ActivityAttendeesListScreen(
//                         model: model,
//                         reservationItem: reservation,
//                         activityManagerForm: activityForm,
//                         currentUser: facade.FirebaseChatCore.instance.firebaseUser?.uid,
//                         didSelectAttendee: (AttendeeItem attendee, UserProfileModel user) {
//                             Navigator.of(newContext).push(MaterialPageRoute(builder: (_) {
//                               return Scaffold(
//                                 resizeToAvoidBottomInset: false,
//                                 appBar: AppBar(
//                                   backgroundColor: model.mobileBackgroundColor,
//                                   elevation: 0,
//                                   title: const Text('Profile'),
//                                   titleTextStyle: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),
//                                   centerTitle: true,
//                                 ),
//                                 body: ProfileMainContainer(
//                                   model: model,
//                                   currentUserProfile: user,
//                                   didSelectReviewApplications: () {  },
//                                 ),
//                               );
//                         },
//                       )
//                     );
//                   });
//               }));
//             }
//           }
//         ),
//
//         Visibility(
//           visible: activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true,
//           child: Column(
//             children: [
//               const SizedBox(height: 5),
//               Divider(color: model.paletteColor),
//               const SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: getActivityVendorOptionColumn(
//                   context,
//                   model,
//                   reservation,
//                   activityForm,
//                   activityOwner,
//                   showSuggestions,
//                   500,
//                   allAttendees.where((e) => e.attendeeType == AttendeeType.vendor).where((element) => element.attendeeOwnerId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid).isNotEmpty,
//                   didSelectManage: () {
//                     if (kIsWeb) {
//
//                     } else {
//                       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//                         return ManageAttendeeSettingsSubContainer(
//                             model: model,
//                             currentSettingItem: null,
//                             reservationItem: reservation,
//                             currentActivityManagerForm: activityForm,
//                             currentAttendee: currentAttendee,
//                             currentActivityOwnerProfile: activityOwner,
//                             didSelectNavItem: (nav) {
//
//                               }
//                             );
//                           },
//                         )
//                       );
//                     }
//                   }
//                 ),
//               ),
//             ],
//           )
//         ),
//
//         Visibility(
//           visible: activityForm.activityAttendance.isTicketBased == true,
//           child: Column(
//             children: [
//               const SizedBox(height: 5),
//               Divider(color: model.paletteColor),
//               const SizedBox(height: 5),
//               Row(
//                 children: [
//                   Flexible(
//                     child: Container(
//                       constraints: const BoxConstraints(
//                         maxWidth: 500,
//                       ),
//                       child: getActivityTicketOptionsColumn(
//                           context,
//                           model,
//                           reservation,
//                           activityForm,
//                           didSelectTicketOption: (e) {
//                             didSelectActivityTicket(e);
//                           },
//                           true && (Responsive.isDesktop(context) == true),
//                           null,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//         /// activity report
//         /// ---------------------------------------------------- ///
//         const SizedBox(height: 5),
//         Divider(color: model.paletteColor),
//         const SizedBox(height: 5),
//         flagOrReportActivityColumn(
//             model,
//             didSelectReport: () {
//
//           }
//         ),
//         const SizedBox(height: 100),
//       ],
//     );
//   }
// }