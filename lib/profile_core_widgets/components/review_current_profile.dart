part of check_in_presentation;

// class ReviewCurrentProfile extends StatefulWidget {
//
//   final UserProfileModel currentUser;
//   final DashboardModel model;
//   final bool showBack;
//   final Function(UserProfileModel user) didSelectEditProfile;
//
//
//   const ReviewCurrentProfile({super.key, required this.currentUser, required this.model, required this.didSelectEditProfile, required this.showBack});
//
//   @override
//   State<ReviewCurrentProfile> createState() => _ReviewCurrentProfileState();
// }
//
// class _ReviewCurrentProfileState extends State<ReviewCurrentProfile> {
//
//   late PageController pageController;
//   /// is profile owner
//   /// is editing profile (show expandable headers)
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     pageController = PageController(viewportFraction: 0.85);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     if (!(Responsive.isMobile(context))) {
//       pageController = PageController(viewportFraction: 0.75);
//     }
//
//     return ClipRRect(
//       borderRadius: (kIsWeb) ? BorderRadius.circular(20) : BorderRadius.zero,
//       child: Scaffold(
//           backgroundColor: (kIsWeb) ? Colors.transparent : null,
//           appBar: (!kIsWeb) ? AppBar(
//             backgroundColor: widget.model.mobileBackgroundColor,
//             elevation: 0,
//             title: Text(widget.currentUser.legalName.getOrCrash()),
//             titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
//             centerTitle: true,
//             leading: (widget.showBack) ? IconButton(icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor), onPressed: () => Navigator.of(context).pop(),) : null,
//           ) : null,
//           body: MultiBlocProvider(
//             providers: [
//               BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(const PublicListingWatcherEvent.watchAllPublicListingsStarted(['']))),
//               BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current, ReservationSlotState.confirmed, ReservationSlotState.completed], widget.currentUser, false)))
//             ],
//             child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
//                 builder: (context, state) {
//                   return state.maybeMap(
//                       loadAllPublicListingItemsSuccess: (e) => getAllReservation(context, e.items.where((element) => element.listingProfileService.backgroundInfoServices.listingOwner == widget.currentUser.userId).toList()),
//                       loadAllPublicListingItemsFailure: (e) => getAllReservation(context, []),
//                       orElse: () => getAllReservation(context, []));
//             }
//           ),
//         )
//       ),
//     );
//   }
//
//   Widget getAllReservation(BuildContext context, List<ListingManagerForm> listings) {
//     return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
//       builder: (context, state) {
//         return state.maybeMap(
//             resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
//             loadCurrentUserReservationsSuccess: (e) => getMainReviewProfile(context, widget.model, listings, e.item),
//             orElse: () => getMainReviewProfile(context, widget.model, listings, [])
//         );
//       }
//     );
//   }
//
//   Widget getMainReviewProfile(BuildContext context, DashboardModel model, List<ListingManagerForm> listings, List<ReservationItem> reservations) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//               if (kIsWeb) const SizedBox(height: 25),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Flexible(
//                     child: Container(
//                       constraints: BoxConstraints(
//                         maxWidth: 750,
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: widget.model.webBackgroundColor,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: profileHeaderContainer(
//                                   widget.currentUser,
//                                   model,
//                                   widget.currentUser.userId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid,
//                                   listings.length,
//                                   reservations.length,
//                                   0,
//                                   editProfile: () {
//                                       widget.didSelectEditProfile(widget.currentUser);
//                                       Navigator.push(context, MaterialPageRoute(
//                                           builder: (_) {
//                                             return EditCurrentProfile(
//                                               profile: widget.currentUser,
//                                               model: widget.model,
//                                               didFinishSaving: (profile) {
//                                                 setState(() {
//                                                   Navigator.of(context).pop();
//                                                 });
//                                               },
//                                             );
//                                           }
//                                          )
//                                       );
//                                   }
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 18),
//                           Divider(color: model.disabledTextColor),
//                           const SizedBox(height: 18),
//                           verificationsAndConfirmations(model, widget.currentUser),
//                           const SizedBox(height: 18),
//                           Divider(color: model.disabledTextColor),
//                           const SizedBox(height: 18),
//                           // VendorProfileSection(
//                           //     model: model,
//                           //     vendorProfile: [],
//                           // ),
//                           const SizedBox(height: 18),
//                           Divider(color: model.disabledTextColor),
//                           const SizedBox(height: 18),
//                           Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: widget.model.webBackgroundColor,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: getHostingListings(context, widget.currentUser, listings, model),
//                             )
//                           ),
//                           const SizedBox(height: 18),
//                           Divider(color: model.disabledTextColor),
//                           const SizedBox(height: 18),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: widget.model.webBackgroundColor,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: getUpComingReservations(context,
//                                   widget.currentUser,
//                                   pageController,
//                                   reservations,
//                                   model,
//                                   didSelectResDetail: (model, listing, reservation, isResOwner, isFromChat, currentUser) {
//
//                                   },
//                                   didSelectReservation: (listing, reservation) {
//
//                                   }
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 32),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }