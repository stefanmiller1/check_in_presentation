part of check_in_presentation;


class ReservationResultMain extends StatefulWidget {

  final String reservationId;
  final UserProfileModel? currentUser;
  final List<TicketItem>? currentUserTicketItems;
  final ListingManagerForm? listing;
  final DashboardModel model;
  final bool isReply;
  /// post to reply to
  final Post? replyToPost;
  final List<Post>? replyPosts;
  // final bool isReservationOwner;

  const ReservationResultMain({
    super.key,
    this.listing,
    required this.model,
    required this.isReply,
    this.replyToPost,
    this.replyPosts,
    required this.reservationId,
    this.currentUser,
    this.currentUserTicketItems,
  });



  @override
  State<ReservationResultMain> createState() => _ReservationResultMainState();
}

class _ReservationResultMainState extends State<ReservationResultMain> with TickerProviderStateMixin {

  final _controller = ScrollController();
  late TabController? _tabController;
  late TabController? _resOnlyTabController;

  double _offset = 0;
  late double _percentageOpen = 0;
  // image picker for sending photo's, videos with post.
  final ImagePicker _imagePicker = ImagePicker();

  /// selected photos for post.
  late List<XFile> _selectedFileSpaceImage = [];

  /// see [isImageVideoAttachmentUploading]
  late bool isImageVideoAttachmentUploading = false;

  /// see [isCameraImageAttachmentUploading]
  late bool isCameraImageAttachmentUploading = false;

  /// see [isAudioAttachmentUploading]
  late bool isAudioAttachmentUploading = false;

  /// check if current user is reservation owner.
  late bool isOwner = false;

  ReservationMobileCreateNewMarker reservationMarker = ReservationMobileCreateNewMarker.listingDetails;
  /// check if current user is a reservation guest or affiliate.

 @override
  void initState() {
    _selectedFileSpaceImage = [];
    int tabIndex = tabItems([]).indexWhere((element) => element.tabMarker == ReservationCoreHelper.resOverViewTabs);

    _resOnlyTabController = TabController(length: 1, vsync: this);
    _tabController = TabController(initialIndex: tabIndex, length: ResOverViewTabs.values.length, vsync: this);
    ReservationCoreHelper.pageController = PageController(initialPage: tabIndex, keepPage: true);
    facade.ActivityFormUpdateFacade.instance.updateViewCount(activityResId: widget.reservationId);

    super.initState();
  }


  @override
  void dispose() {
    _controller.dispose();
    _tabController?.dispose();
    _resOnlyTabController?.dispose();
    super.dispose();
  }



  void didSelectOptionsFromSettings(BuildContext context, DashboardModel model, bool isReservationOwner, UserProfileModel currentUser, List<UserProfileModel> users, ReservationItem reservation, ListingManagerForm listing, ResSettingMarker marker, ActivityManagerForm activityForm) async {
   switch (marker) {
     case ResSettingMarker.details:
       final index = ResOverViewTabs.values.indexWhere((element) => element == ResOverViewTabs.reservation);

       // ReservationCoreHelper.resOverViewTabs =  ReservationCoreHelper.resOverViewTabs = tabItems(activityHasNotification, discussionHasNotification, activitySetupComplete(activity))[index].tabMarker;
       _tabController?.animateTo(index);
       ReservationCoreHelper.pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
       break;
     case ResSettingMarker.manageActivity:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resSettings.name.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
       break;
     case ResSettingMarker.manageAttendance:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resSettings.name.toString()}'
           ),
         rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
       break;
     case ResSettingMarker.manageActivityAttendees:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resAttendees.name.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resAttendees));
       break;
     case ResSettingMarker.manageActivityTickets:
       Beamer.of(context).update(
           configuration: RouteInformation(
               location: '/${DashboardMarker.resTicket.name.toString()}'
           ),
           rebuild: false
       );
       context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resTicket));
       break;
     case ResSettingMarker.manageActivityPasses:
       break;
     case ResSettingMarker.messageOwner:
       showGeneralDialog(
         context: context,
         barrierDismissible: true,
         barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
         transitionDuration: Duration(milliseconds: 350),
         pageBuilder: (BuildContext contexts, anim1, anim2) {
           return StreamBuilder<types.Room>(
             stream: facade.FirebaseChatCore.instance.room(reservation.reservationId.getOrCrash()),
             builder: (context, snapshot) {
               final room = snapshot.data;

               if (!snapshot.hasData || room == null) {
                 return Scaffold(
                   backgroundColor: Colors.transparent,
                   body: noItemsFound(
                       widget.model,
                       Icons.chat_outlined,
                       'No Chats Yet!',
                       'When You book a new reservation - a chat with just you and the listing owner will appear here.',
                       'Open Archive',
                       didTapStartButton: () {
                         setState(() {
                         });
                     }
                   ),
                 );
               }

               return  Align(
                       alignment: Alignment.center,
                       child: ClipRRect(
                           borderRadius: BorderRadius.all(Radius.circular(25)),
                           child: Container(
                               decoration: BoxDecoration(
                                   color: widget.model.accentColor,
                                   borderRadius: BorderRadius.all(Radius.circular(17.5))
                               ),
                               width: 550,
                               height: 750,
                               child: Scaffold(
                                 backgroundColor: Colors.transparent,
                                 appBar: (kIsWeb) ? AppBar(
                                 backgroundColor: model.paletteColor,
                                 ) : null,
                                 body: DirectChatScreen(
                                     room: room,
                                     model: model,
                                     currentUser: currentUser,
                                     reservationItem: reservation,
                                     isFromReservation: false
                                 ),
                               )
                           )
                       )

               );
             },
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
         },
       );
       break;
     case ResSettingMarker.sendInvites:
       showGeneralDialog(
         context: context,
         barrierDismissible: false,
         barrierLabel: 'Send Invite',
         transitionDuration: Duration(milliseconds: 350),
         pageBuilder: (BuildContext contexts, anim1, anim2) {
           return  Align(
               alignment: Alignment.center,
               child: ClipRRect(
                   borderRadius: BorderRadius.all(Radius.circular(25)),
                   child: Container(
                       decoration: BoxDecoration(
                           color: widget.model.accentColor,
                           borderRadius: BorderRadius.all(Radius.circular(17.5))
                       ),
                       width: 550,
                       height: 750,
                       child: SendInvitationRequest(
                         model: widget.model,
                         currentUserId: widget.currentUser!.userId.getOrCrash(),
                         attendeeType: AttendeeType.free,
                         reservationItem: reservation,
                         inviteType: InvitationType.reservation,
                         activityForm: activityForm,
                         didSelectInvite: (contacts) {},

                       )
                   )
               )
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
         },
       );
       break;
     case ResSettingMarker.addCalendar:
       // TODO: Handle this case.
       break;
     case ResSettingMarker.receipts:
       if (reservation.receipt_link != null) {
         if (await canLaunchUrlString(reservation.receipt_link!)) {
           await launchUrlString(reservation.receipt_link!);
         }
       }
       break;
     case ResSettingMarker.showListing:
       // TODO: Handle this case.
       break;
     case ResSettingMarker.leaveReservation:
       // TODO: Handle this case.
       break;
   }
  }

  Widget getMainContainerForReservationOverview(BuildContext context, BookedReservationFormState state, bool isOwner, List<AccountNotificationItem> notifications, UserProfileModel resOwner, ListingManagerForm listing, ReservationItem reservation, UserProfileModel? reservationOwner, UserProfileModel currentUser, List<UserProfileModel> userProfiles, List<AttendeeItem> allAttendees, AttendeeItem? currentAttendee) {
   return Stack(
     children: [

       SingleChildScrollView(
         child: Center(
           child: Container(
             constraints: const BoxConstraints(maxWidth: 700),
             child: FacilityOverviewInfoWidget(
               model: widget.model,
               overViewState: FacilityPreviewState.reservation,
               newFacilityBooking: reservation,
               reservations: [],
               ///TODO: THIS NEEDS TO BE THE LISTING OWNER!!!!!
               listingOwnerProfile: currentUser,
               listing: listing,
               selectedReservationsSlots: [],
               selectedActivityType: null,
               currentListingActivityOption: null,
               currentSelectedSpace: null,
               currentSelectedSpaceOption: null,
               didSelectSpace: (space) {},
               didSelectSpaceOption: (spaceOption) {},
               updateBookingItemList: (slotItem, currency) {},
               didSelectItem: () {},
               isAttendee: true,
             ),
           ),
         ),
       ),

       Positioned(
         bottom: 0,
         child: ClipRRect(
           child: BackdropFilter(
             filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
             child: Container(
                 height: 100,
                 width: MediaQuery.of(context).size.width,
                 color: widget.model.accentColor.withOpacity(0.35)
             ),
           ),
         ),
       ),

       Column(
         mainAxisSize: MainAxisSize.max,
         mainAxisAlignment: MainAxisAlignment.end,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           getFooterForResWithoutActivity(
               context,
               widget.model,
               isOwner,
               reservation,
               allAttendees,
               reservation.reservationState == ReservationSlotState.completed,
               false,
               currentUser.userId.getOrCrash(),
               currentAttendee,
               didSelectCreateActivity: () {
                 setState(() {
                   if (kIsWeb) {
                     Beamer.of(context).update(
                         configuration: RouteInformation(
                             location: '/${DashboardMarker.resSettings.name.toString()}'
                         ),
                         rebuild: false
                     );
                     context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                   } else {
                     Navigator.push(context, MaterialPageRoute(
                         builder: (_) {
                           return ActivitySettingsScreenMobile(
                             model: widget.model,
                             reservationItem: reservation,
                             listing: listing,
                             currentUser: currentUser,
                           );
                         }
                       )
                     );
                   }
                 });
               },
               didSelectShare: () {
                 context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishCreateNewInviteLink(reservation));
               },
               didSelectMoreOptions: () {

               },
               didSelectInterested: () {}
           ),
           const SizedBox(height: 8),
         ],
       ),

       if (kIsWeb) mainContainerHeaderTabWeb(
           notifications,
           null
       ),
       if (!(kIsWeb)) mainContainerHeaderAppBarMobile(
           context,
           notifications,
           state,
           currentUser,
           reservation,
           listing,
           null,
           currentAttendee,
           userProfiles,
           allAttendees
       ),
     ],
   );
  }
  
  Widget getMainContainerForResActivityOverview(
      BuildContext context,
      BookedReservationFormState state,
      bool isOwner,
      List<AccountNotificationItem> notifications,
      UserProfileModel resOwner,
      ListingManagerForm listing,
      ReservationItem reservation,
      UserProfileModel? reservationOwner,
      UserProfileModel currentUser,
      List<Post> postList,
      List<UserProfileModel> userProfiles,
      ActivityManagerForm activityForm,
      List<AttendeeItem> allAttendees,
      List<EventMerchantVendorProfile> allAttendeeVendorProfiles,
      List<UniqueId> linkedCommunities,
      AttendeeItem? currentAttendee) {
   return Stack(
     children: [
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Expanded(
             child: Container(
                 child: mainContainerPageView(
                     context,
                     notifications,
                     listing,
                     reservation,
                     isOwner,
                     reservationOwner,
                     currentUser,
                     postList,
                     userProfiles,
                     allAttendees,
                     allAttendeeVendorProfiles,
                     linkedCommunities,
                     activityForm
               )
             ),
           )
         ]
       ),
       if (tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.discussion) Positioned(
         bottom: 0,
         child: ClipRRect(
           child: BackdropFilter(
             filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
             child: Container(
               height: (widget.isReply && widget.replyToPost != null) ? (_selectedFileSpaceImage.isNotEmpty && ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.discussion) ? 415 : 300 : (_selectedFileSpaceImage.isNotEmpty && ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.discussion) ? 220 : 80,
               width: MediaQuery.of(context).size.width,
               color: widget.model.accentColor.withOpacity(0.35)
             ),
           ),
         ),
       ),
       if (tabItems(notifications)[_tabController?.index ?? 0].tabMarker != ResOverViewTabs.discussion) Positioned(
         bottom: 0,
         child: ClipRRect(
           child: BackdropFilter(
             filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
             child: Container(
               height: 100,
               width: MediaQuery.of(context).size.width,
               color: widget.model.accentColor.withOpacity(0.35)
             ),
           ),
         ),
       ),

       AnimatedOpacity(
         opacity: (tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.reservation || tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.activity) ? 1 : 0,
         duration: const Duration(milliseconds: 900),
         child: Visibility(
           visible: (tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.reservation || tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.activity),
           child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.end,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               getReservationFooterWidget(
                   context,
                   widget.model,
                   activityForm,
                   reservation,
                   currentAttendee,
                   allAttendees,
                   currentUser.userId.getOrCrash(),
                   isOwner,
                   false,
                   didSelectJoin: () {
                     setState(() {
                       presentNewAttendeeJoin(
                         context,
                         widget.model,
                         listing,
                         reservation,
                         activityForm,
                         resOwner
                       );
                     });
                    },
                     didSelectManage: () {
                      if (kIsWeb) {
                        Beamer.of(context).update(
                            configuration: RouteInformation(
                                location: '/${DashboardMarker.resSettings.name.toString()}'
                            ),
                            rebuild: false
                        );
                        context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) {
                              /// if owner else show attendee manage options
                              return ActivitySettingsScreenMobile(
                                model: widget.model,
                                reservationItem: reservation,
                                activityManagerForm: activityForm,
                                listing: listing,
                                currentUser: currentUser,
                              );
                            })
                        );
                      }
                     },
                     didSelectManageTickets: () {
                       setState(() {
                         if (kIsWeb) {
                           Beamer.of(context).update(
                               configuration: RouteInformation(
                                   location: '/${DashboardMarker.resAttendeeTicket.name.toString()}'
                               ),
                               rebuild: false
                           );
                           context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resAttendeeTicket));
                         } else {
                           Navigator.push(context, MaterialPageRoute(
                              builder: (_) {
                                return ActivityAttendeeTicketsResultMain(
                                  model: widget.model,
                                  tickets: widget.currentUserTicketItems ?? [],
                                  reservationItem: reservation,
                                  currentUser: currentUser,
                                  activityManagerForm: activityForm,
                                );
                              })
                            );
                         }
                       });
                     },
                     didSelectFindTickets: () {
                       setState(() {
                         presentNewTicketAttendeeJoin(
                           context,
                           widget.model,
                           reservation,
                           activityForm,
                           resOwner
                         );
                       });
                    },
                    didSelectManagePasses: () {
                     setState(() {
                       if (kIsWeb) {

                       } else {

                       }
                     });
                    },
                    didSelectFindPass: () {
                      setState(() {
                        if (kIsWeb) {

                        } else {

                        }
                      });
                    },
                   didSelectShare: () {
                     presentActivityShareOptions(context, widget.model, listing, reservation, activityForm);
                     // context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishCreateNewInviteLink(reservation));
                   },
                   didSelectMoreOptions: () {
                       presentMoreOptions(
                           context,
                           widget.model,
                           isOwner,
                           currentUser,
                           activityForm,
                           reservation,
                           listing,
                           allAttendees,
                           currentAttendee,
                           didLeaveListing: () {
                             Navigator.of(context).pop();
                           },
                           didUpdateMarkerWeb: (marker) {
                             setState(() {
                               didSelectOptionsFromSettings(
                                   context,
                                   widget.model,
                                   isOwner,
                                   currentUser,
                                   userProfiles,
                                   reservation,
                                   listing,
                                   marker,
                                   activityForm
                               );
                             });
                           }
                        );

                 },
                 didSelectInterested: () {
                   if (kIsWeb) {

                   } else {

                   }
                 }
               ),
               const SizedBox(height: 8),
             ],
           ),
         ),
       ),

       AnimatedOpacity(
         opacity: (tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.discussion) ? 1 : 0,
         duration: const Duration(milliseconds: 900),
         curve: Curves.easeInOut,
         child: Visibility(
           visible: (tabItems(notifications)[_tabController?.index ?? 0].tabMarker == ResOverViewTabs.discussion),
           child: Column(
             mainAxisSize: MainAxisSize.max,
             mainAxisAlignment: MainAxisAlignment.end,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               AnimatedContainer(
                 duration: const Duration(milliseconds: 900),
                 curve: Curves.easeInOut,
                 height: (_selectedFileSpaceImage.isNotEmpty) ? 125 : 0,
                 child: MediaAttachmentPreview(
                   selectedMedia: _selectedFileSpaceImage.map((e) => Image.file(File(e.path))).toList(),
                   didRemoveMediaFromPost: (context, media) {
                     _selectedFileSpaceImage.removeWhere((element) => Image.file(File(element.path)).image == media.image);
                        setState(() {

                        });
                     },
                   model: widget.model,
                 ),
               ),
               retrieveInputForPost(
                   context,
                   state,
                   reservation.reservationId.getOrCrash(),
                   allAttendees.where((element) => element.contactStatus == ContactStatus.joined).toList()
               ),
               const SizedBox(height: 8),
             ],
           ),
         ),
       ),

       if (kIsWeb) mainContainerHeaderTabWeb(
           notifications,
           activityForm
       ),
       if (!(kIsWeb)) mainContainerHeaderAppBarMobile(
          context,
          notifications,
          state,
          currentUser,
          reservation,
          listing,
          activityForm,
          currentAttendee,
          userProfiles,
          allAttendees
       ),
     ],
   );
  }
  


  @override
  Widget build(BuildContext context) {
   if (ReservationHelperCore.isLoading) {
     return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
   }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.reservationId))),
        ],
        child:  (widget.listing != null && widget.currentUser != null) ? retrieveReservation(context, widget.listing!, widget.currentUser!) : retrieveReservationFromLink(context)
      ),
    );
  }

  /// if presented from notification - retrieve reservation, listing and current user
  Widget retrieveReservationFromLink(BuildContext context) {
    return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadReservationItemSuccess: (e) {
            return retrieveReservationListing(context, e.item);
          },
          orElse: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
        );
      },
    );
  }

  Widget retrieveReservationListing(BuildContext context, ReservationItem reservation) {
    return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(reservation.instanceId.getOrCrash())),
        child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              loadListingManagerItemFailure: (_) => LoadingReservationCard(context),
              loadListingManagerItemSuccess: (item) {
                return retrieveReservationOwnerProfile(context, reservation, item.failure);
              },
            orElse: () => Container()
          );
        },
      ),
    );
  }

  /// retrieve res owner profile
  Widget retrieveReservationOwnerProfile(BuildContext context, ReservationItem reservation, ListingManagerForm listing) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(reservation.reservationOwnerId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadSelectedProfileSuccess: (item) => retrieveCurrentUserProfile(context, reservation, listing, item.profile),
                  orElse: () => Container()
              );
            }
        )
    );
  }

  /// retrieve current user
  Widget retrieveCurrentUserProfile(BuildContext context, ReservationItem reservation, ListingManagerForm listing, UserProfileModel reservationOwner) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
            loadUserProfileSuccess: (item) => retrieveActivitySettings(context, reservation, listing, reservationOwner, item.profile),
            orElse: () => Container()
          );
        },
      ),
    );
  }


  Widget retrieveReservation(BuildContext context, ListingManagerForm listingForm, UserProfileModel currentUser) {
    return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            loadReservationItemSuccess: (e) {
              return retrieveReservationOwnerProfile(context, e.item, listingForm);
            },
            orElse: () => Container(),
        );
      },
    );
  }


  /// check if reservation has activity - if not, load main container with reservation only
  Widget retrieveActivitySettings(BuildContext context, ReservationItem reservationItem, ListingManagerForm listingForm, UserProfileModel reservationOwner, UserProfileModel currentUser) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<BookedReservationFormBloc>()..add(BookedReservationFormEvent.initializedPostForm(dart.optionOf(Post(authorId: currentUser.userId, id: UniqueId().getOrCrash(), status: PostStatus.sending, reservationId: widget.reservationId, type: PostType.text))))),
        BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservationItem.reservationId.getOrCrash()))),
      ],
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                loadActivityManagerFormFailure: (_) => mainContainer(context, listingForm, reservationItem, reservationOwner, currentUser, [], [], null, [], [], [], []),
                loadActivityManagerFormSuccess: (item) {
                  return retrieveExistingPosts(reservationItem, listingForm, reservationOwner, currentUser, item.item);
                },
                orElse: () => Container(),
          );
        },
      ),
    );
  }




  Widget retrieveExistingPosts(ReservationItem reservationItem, ListingManagerForm listingForm, UserProfileModel reservationOwner, UserProfileModel currentUser, ActivityManagerForm activityForm) {
    return  BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentReservationPosts(widget.reservationId)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadReservationPostListSuccess: (e) {
                  late List<Post> postList = [];
                  postList.addAll(e.posts);
                  postList.sort((a,b) => b.createdAt?.compareTo(a.createdAt ?? DateTime.now()) ?? 0);

                  return retrieveAllAttendees(context, listingForm, reservationItem, reservationOwner, currentUser, postList, [], activityForm);
                },
                loadReservationPostListFailure: (_) => retrieveAllAttendees(context, listingForm, reservationItem, reservationOwner, currentUser, [], [], activityForm),
                orElse: () => retrieveAllAttendees(context, listingForm, reservationItem, reservationOwner, currentUser, [], [], activityForm),
            );
        },
      ),
    );
  }


  Widget retrieveReplyPostUser(String authorId, Post replyPost, UserProfileModel currentUser, ActivityManagerForm activityForm) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(authorId)),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                loadInProgress: (_) =>  JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                loadSelectedProfileSuccess: (items) => reservationReplyContainer(context, currentUser, items.profile, replyPost),
                orElse: () => reservationReplyContainer(context, currentUser, null, replyPost)
          );
        }
      )
    );
  }


  Widget reservationReplyContainer(BuildContext context, UserProfileModel currentUser, UserProfileModel? postUser, Post replyPost) {
    return SizedBox(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: ReservationPost(
        posts: [replyPost],
        profiles: (postUser != null) ? [postUser] : [],
        model: widget.model,
        onSubmitPressed: () {

          },
          isReplyPost: true,
          user: currentUser,
          onAvatarTap: (userProfile) {
            dedSelectProfilePopOverOnly(context, widget.model, userProfile);
          }
      ),
    );
  }

/// TODO: REMOVE THIS FROM RESERVATIONS - SHOULD NOT CALL WATCH ALL USERS
//   Widget retrieveReservationPostProfiles(BuildContext context, List<Post> postList, ListingManagerForm listing,  ReservationItem reservationItem, UserProfileModel currentUser, ActivityManagerForm activityForm) {
    // return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserAllProfilesStarted()),
    //     child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
    //         builder: (context, authState) {
    //           return authState.maybeMap(
    //               loadAllUserProfilesSuccess: (items) => retrieveReservationOwnerProfile(context, listing, reservationItem, currentUser, postList, items.profile, activityForm),
    //               orElse: () => retrieveReservationOwnerProfile(context, listing, reservationItem, currentUser, postList, [], activityForm)
    //       );
    //     }
    //   )
    // );
  // }

  /// watch activity owner only



  Widget retrieveAllAttendees(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm) {
      return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(reservation.reservationId.getOrCrash())),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadAllAttendanceActivitySuccess: (attendees) {
                  return BlocProvider(create: (context) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchAllEventMerchProfileFromIds(attendees.item.where((e) => e.attendeeType == AttendeeType.vendor).map((e) => (e.eventMerchantVendorProfile != null) ? e.eventMerchantVendorProfile!.getOrCrash() : '').toList())),
                      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
                        builder: (context, state) {
                          return state.maybeMap(
                              loadAllMerchVendorFromIdsSuccess: (item) => retrieveAllNotifications(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, attendees.item, item.items),
                              orElse: () => retrieveAllNotifications(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, attendees.item, [])
                        );
                      },
                    )
                  );
                },
                orElse: () => retrieveAllNotifications(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, [], [])
          );
        },
      ),
    );
  }



  Widget retrieveAllNotifications(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm, List<AttendeeItem> allAttendees, List<EventMerchantVendorProfile> allAttendeeVendorProfiles) {
    return BlocProvider(create: (_) => getIt<NotificationWatcherBloc>()..add(NotificationWatcherEvent.watchAllAccountNotificationAmountByType([AccountNotificationType.reservation, AccountNotificationType.activity, AccountNotificationType.activityPost], reservation.reservationId)),
        child: BlocBuilder<NotificationWatcherBloc, NotificationWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadAllAccountNotificationByTypeSuccess: (item) {
                    return retrieveAllLinkedCommunityIds(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, allAttendees, allAttendeeVendorProfiles, item.notifications);
                  },
              orElse: () => retrieveAllLinkedCommunityIds(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, allAttendees, allAttendeeVendorProfiles, [])
          );
        }
      )
    );
  }


  Widget retrieveAllLinkedCommunityIds(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm activityForm, List<AttendeeItem> allAttendees, List<EventMerchantVendorProfile> allAttendeeVendorProfiles, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<CommunityManagerWatcherBloc>()..add(CommunityManagerWatcherEvent.watchReservationLinkedCommunity(reservation.reservationId)),
      child: BlocBuilder<CommunityManagerWatcherBloc, CommunityManagerWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadReservationLinkedCommunitiesSuccess: (item) => mainContainer(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, allAttendees, allAttendeeVendorProfiles, notifications, item.communityIds),
              orElse: () => mainContainer(context, listing, reservation, reservationOwner, currentUser, postList, userProfiles, activityForm, allAttendees, allAttendeeVendorProfiles, notifications, [])
          );
        }
      )
    );
  }


  Widget mainContainer(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel reservationOwner, UserProfileModel currentUser, List<Post> postList, List<UserProfileModel> userProfiles, ActivityManagerForm? activityForm, List<AttendeeItem> allAttendees, List<EventMerchantVendorProfile> allAttendeeVendorProfiles, List<AccountNotificationItem> notifications, List<UniqueId> linkedCommunities) {
        return BlocConsumer<BookedReservationFormBloc, BookedReservationFormState>(
           listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
           listener: (context, state) {
             state.authFailureOrSuccessInviteLink.fold(
                     () => null,
                     (either) => either.fold(
                             (failure) {
                               final snackBar = SnackBar(
                                   backgroundColor: widget.model.paletteColor,
                                   content: failure.maybeMap(
                                     reservationServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.accentColor)),
                                     orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.accentColor)),
                                   )
                               );
                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
                             },
                   (r) {
                           // Share.share(
                           //   r.toString(),
                           //   subject: 'You\'re Invited!');
                 }
               )
             );
             state.authFailureOrSuccess.fold(
                     () => {},
                     (either) => either.fold(
                         (failure) {
                       final snackBar = SnackBar(
                           backgroundColor: widget.model.webBackgroundColor,
                           content: failure.maybeMap(

                             reservationServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                             orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                           )
                       );
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     },
                         (_) {
                        setState(() {
                          // isAffiliate = true;
                        });
                     }
                 )
             );
           },
           buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
           builder: (context, state) {

             isOwner = currentUser.userId == reservation.reservationOwnerId;
             final isAttendee = allAttendees.map((e) => e.attendeeOwnerId).contains(currentUser.userId);
             final AttendeeItem? currentAttendee = allAttendees.where((element) => element.attendeeOwnerId == currentUser.userId).isNotEmpty ? allAttendees.where((element) => element.attendeeOwnerId == currentUser.userId).first : null;

             // (userProfiles.where((element) => element.userId == reservation.reservationOwnerId).isNotEmpty) ? userProfiles.where((element) => element.userId == reservation.reservationOwnerId).first : currentUser;


             return Stack(
               alignment: Alignment.topCenter,
               children: [
                 Container(
                   color: widget.model.webBackgroundColor,
                   width: MediaQuery.of(context).size.width,
                   height: MediaQuery.of(context).size.height,
                 ),
                 // if (activityForm != null && activitySetupComplete(activityForm)) CreateNewMain(
                 //    child: reservationContainerModel.firstWhere((element) => element.markerItem == reservationMarker).childWidget
                 // ),

                  if (activityForm == null || (activityForm != null && (activitySetupComplete(activityForm)) == false)) getMainContainerForReservationOverview(
                      context,
                      state,
                      isOwner,
                      notifications,
                      reservationOwner,
                      listing,
                      reservation,
                      reservationOwner,
                      currentUser,
                      userProfiles,
                      allAttendees,
                      currentAttendee
                  ),
                 if (activityForm != null && activitySetupComplete(activityForm)) getMainContainerForResActivityOverview(
                     context,
                     state,
                     isOwner,
                     notifications,
                     reservationOwner,
                     listing,
                     reservation,
                     reservationOwner,
                     currentUser,
                     postList,
                     userProfiles,
                     activityForm,
                     allAttendees,
                     allAttendeeVendorProfiles,
                     linkedCommunities,
                     currentAttendee
                 ),

                // handle activity attendee requirements
                if (isOwner) Positioned(
                  top: (kIsWeb) ? 90: 160,
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 800),
                      opacity: ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.activity ? 1 : 0,
                    child: Visibility(
                      visible: ReservationCoreHelper.resOverViewTabs == ResOverViewTabs.activity,
                      child: SizedBox(
                        height: 60,
                        child: FilterChip(
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 8,
                          shadowColor: widget.model.disabledTextColor.withOpacity(0.3),
                          onSelected: (e) {
                            setState(() {
                              ReservationCoreHelper.showSuggestions = !ReservationCoreHelper.showSuggestions;
                            });
                          },
                          avatar: Icon(Icons.remove_red_eye_outlined, size: 26, color: ReservationCoreHelper.showSuggestions ? widget.model.paletteColor : widget.model.accentColor ,),
                          label: ReservationCoreHelper.showSuggestions ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text('Hide Suggestions', style: TextStyle(color: widget.model.paletteColor)),
                          ) : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Text('Suggestion', style: TextStyle(color: widget.model.accentColor)),
                          ),
                          backgroundColor: ReservationCoreHelper.showSuggestions ? widget.model.accentColor : widget.model.paletteColor,
                        ),
                      ),
                    )
                  )
                ),

                /// handle invited [AttendeeItem] attendee...
                  if (isOwner == false &&
                     (currentAttendee != null) &&
                     (currentAttendee.contactStatus == ContactStatus.invited) &&
                      showAffiliateOnBoarding(currentAttendee.attendeeType) &&
                      activityForm != null)
                    OnBoardingPopOverWidget(
                        height: 750,
                        width: 600,
                        popOverWidget: ReservationAffiliateOnBoarding(
                          model: widget.model,
                          activityManagerForm: activityForm,
                          attendeeItem: currentAttendee,
                          reservation: reservation,
                          reservationOwner: reservationOwner,
                          listingForm: listing,
                        ),
                        model: widget.model
                    ),


          ]
        );
      }
    );
  }

  Widget mainContainerHeaderTabMobile(List<AccountNotificationItem> notifications, ActivityManagerForm? activity) {

   return Theme(
     data: widget.model.systemTheme.copyWith(
         colorScheme: widget.model.systemTheme.colorScheme.copyWith(
             surfaceVariant: Colors.transparent
       )
     ),
     child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 8.0),
       child: Container(
         height: 40,
         width: MediaQuery.of(context).size.width,
         child: (activity != null) && activitySetupComplete(activity) ? TabBar(
           indicatorSize: TabBarIndicatorSize.tab,
           controller: _tabController,
           onTap: (index) {
             setState(() {
               ReservationCoreHelper.resOverViewTabs = tabItems(notifications)[index].tabMarker;
               ReservationCoreHelper.pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
               updateNotifications(context, widget.model, tabItems(notifications)[index].tabMarker, notifications);
             });
           },
           tabAlignment: TabAlignment.center,
           indicatorColor: widget.model.webBackgroundColor,
           labelStyle: const TextStyle(fontWeight: FontWeight.bold),
           labelColor: widget.model.webBackgroundColor,
           unselectedLabelColor: widget.model.disabledTextColor,
           isScrollable: true,
           tabs: tabItems(notifications).map(
                   (e) => badges.Badge(
                     position: badges.BadgePosition.topEnd(top: 0),
                     showBadge: e.showBadge,
                     badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
                     badgeContent: Text(e.badgeTitle ?? '1', style: TextStyle(color: widget.model.accentColor)),
                     child: Tab(
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: Text(e.tabTitle.toUpperCase(), overflow: TextOverflow.ellipsis, maxLines: 1,),
                         )
               ),
             )
           ).toList()
         ) : TabBar(
             indicatorSize: TabBarIndicatorSize.tab,
             controller: _resOnlyTabController,
             tabAlignment: TabAlignment.fill,
             onTap: (index) {
             },
             indicatorColor: widget.model.webBackgroundColor,
             labelStyle: const TextStyle(fontWeight: FontWeight.bold),
             labelColor: widget.model.webBackgroundColor,
             unselectedLabelColor: widget.model.disabledTextColor,
             isScrollable: false,
             tabs: [
               badges.Badge(
                 position: badges.BadgePosition.topEnd(top: 0),
                 showBadge: notifications.where((element) => element.notificationType == AccountNotificationType.reservation).isNotEmpty,
                 badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
                 badgeContent: Text(notifications.where((element) => element.notificationType == AccountNotificationType.reservation).length.toString(), style: TextStyle(color: widget.model.accentColor)),
                 child: Tab(
                   text: 'Reservation'
                 ),
               )
           ]
         ),
       ),
     ),
   );
  }


  Widget mainContainerHeaderAppBarMobile(BuildContext context, List<AccountNotificationItem> notifications, BookedReservationFormState state, UserProfileModel currentUser, ReservationItem reservation, ListingManagerForm listing, ActivityManagerForm? activityForm, AttendeeItem? currentAttendee, List<UserProfileModel> userProfiles, List<AttendeeItem> allAttendees) {
   return SizedBox(
     height: 160,
     width: MediaQuery.of(context).size.width,
     child: AppBar(
       toolbarHeight: 80,
       centerTitle: true,
       leading: IconButton(onPressed: () {
         Navigator.of(context).pop();
       }, icon: Icon(Icons.cancel, size: 30, color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor)),
       title: Column(
         children: [
           Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold)),
           const SizedBox(height: 5),
           if (reservation.reservationState == ReservationSlotState.completed) Container(
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(50),
                   color: widget.model.accentColor.withOpacity(0.5)
               ),
               child: Padding(
                 padding: const EdgeInsets.all(4.0),
                 child: Text('Finished', style: TextStyle(fontSize: 14, color: widget.model.accentColor)),
               )
           ),
         ],
       ),
       bottom: PreferredSize(
         preferredSize: const Size.fromHeight(0),
         child:  Padding(
           padding: const EdgeInsets.only(bottom: 8.0),
           child: mainContainerHeaderTabMobile(
               notifications,
               activityForm
           ),
         ),
       ),
       elevation: 0,
       actions: [
         if (isOwner) if (!state.isCreatingLink) if (activityForm != null) IconButton(
           onPressed: () {
             if (activityForm != null) {
               presentActivityShareOptions(context, widget.model, listing, reservation, activityForm);
             }
               // context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishCreateNewInviteLink(reservation));

           },
           icon: Icon(Icons.ios_share_rounded, color: widget.model.accentColor),
         ),
         if (state.isCreatingLink) JumpingDots(numberOfDots: 2, color: widget.model.accentColor),
         IconButton(
           onPressed: () {
             presentMoreOptions(
                 context,
                 widget.model,
                 isOwner,
                 currentUser,
                 activityForm,
                 reservation,
                 listing,
                 allAttendees,
                 currentAttendee,
                 didLeaveListing: () {
                   // List<ContactDetails> updatedAffiliates = [];
                   // updatedAffiliates.addAll(reservation.reservationAffiliates ?? []);
                   //
                   // updatedAffiliates.removeWhere((element) => element.contactId == currentUser.userId);
                   // context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didLeaveBookedReservation(reservation, updatedAffiliates));
                   Navigator.of(context).pop();
                 },
                 didUpdateMarkerWeb: (marker) {
                   setState(() {
                     if (activityForm != null) didSelectOptionsFromSettings(
                         context,
                         widget.model,
                         isOwner,
                         currentUser,
                         userProfiles,
                         reservation,
                         listing,
                         marker,
                         activityForm
                     );
                   });
                 }
             );
           },
           icon: Icon(Icons.more_vert_rounded, color: widget.model.accentColor),
         ),
       ],
       backgroundColor: widget.model.paletteColor,
     ),
   );
  }

  Widget mainContainerHeaderTabWeb(List<AccountNotificationItem> notifications, ActivityManagerForm? activityForm) {
   return Row(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Flexible(
           child: Container(
             constraints: const BoxConstraints(maxWidth: 700),
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 4.0),
               child: Padding(
                 padding: const EdgeInsets.only(top: 18.0),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(25.0),
                   child: BackdropFilter(
                     filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                     child: Container(
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(25.0),
                           color: widget.model.accentColor.withOpacity(0.35)
                       ),
                       child: (activityForm != null) && activitySetupComplete(activityForm) ? TabBar(
                         indicatorColor: Colors.transparent,
                         indicatorSize: TabBarIndicatorSize.tab,
                         controller: _tabController,
                         onTap: (index) {
                           setState(() {
                             ReservationCoreHelper.resOverViewTabs = tabItems(notifications)[index].tabMarker;
                             ReservationCoreHelper.pageController?.jumpToPage(index);

                             updateNotifications(context, widget.model, tabItems(notifications)[index].tabMarker, notifications);

                           });
                         },
                         indicator: BoxDecoration(
                             borderRadius: BorderRadius.circular(25.0),
                             color: widget.model.paletteColor
                         ),
                         labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                         labelColor: widget.model.accentColor,
                         unselectedLabelColor: widget.model.paletteColor,
                         tabs: tabItems(notifications).map(
                                 (e) => badges.Badge(
                                   position: badges.BadgePosition.topEnd(top: 0),
                                   showBadge: e.showBadge,
                                   badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
                                   badgeContent: Text(e.badgeTitle ?? '1', style: TextStyle(color: widget.model.accentColor)),
                                   child: Tab(
                                       child: Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                         child: Text(e.tabTitle.toUpperCase(), overflow: TextOverflow.ellipsis, maxLines: 1,),
                               )
                             ),
                           )
                         ).toList()
                       ) : TabBar(
                            controller: _resOnlyTabController,
                            indicatorColor: Colors.transparent,
                            indicatorSize: TabBarIndicatorSize.tab,
                            onTap: (index) {

                              },
                            indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: widget.model.paletteColor
                            ),
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          labelColor: widget.model.accentColor,
                          unselectedLabelColor: widget.model.paletteColor,
                          tabs: [
                            badges.Badge(
                              position: badges.BadgePosition.topEnd(top: 0),
                              showBadge: notifications.where((element) => element.notificationType == AccountNotificationType.reservation).isNotEmpty,
                              badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
                              badgeContent: Text(notifications.where((element) => element.notificationType == AccountNotificationType.reservation).length.toString(), style: TextStyle(color: widget.model.accentColor)),
                              child: Tab(text: 'Reservation'),
                            )
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             )
           )
         )
       ],
     );
  }


  Widget mainContainerPageView(BuildContext context,
      List<AccountNotificationItem> notifications,
      ListingManagerForm listing,
      ReservationItem reservation,
      bool isOwner,
      UserProfileModel? reservationOwner,
      UserProfileModel currentUser,
      List<Post> postList,
      List<UserProfileModel> userProfiles,
      List<AttendeeItem> allAttendees,
      List<EventMerchantVendorProfile> allAttendeeVendorProfiles,
      List<UniqueId> linkedCommunities,
      ActivityManagerForm activityForm) {
   return PageView.builder(
       controller: ReservationCoreHelper.pageController,
       itemCount: tabItems(notifications).length,
       scrollDirection: Axis.horizontal,
       allowImplicitScrolling: true,
       physics: const NeverScrollableScrollPhysics(),
       itemBuilder: (_, index) {

         ResOverViewTabs pageIndex = tabItems(notifications)[index].tabMarker;

          Widget getMainWidget(ResOverViewTabs currentTab) {
            switch (currentTab) {
              case ResOverViewTabs.activity:
                return Flexible(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: ReservationActivityInfoWidget(
                        model: widget.model,
                        listingForm: listing,
                        activityForm: activityForm,
                        activityOwner: reservationOwner,
                        reservation: reservation,
                        allAttendees: allAttendees,
                        isLoading: false,
                        allVendors: allAttendeeVendorProfiles,
                        linkedCommunities: linkedCommunities,
                        isOwner: isOwner,
                        activitySetupComplete: activitySetupComplete(activityForm) || !isOwner,
                        showSuggestions: ReservationCoreHelper.showSuggestions && isOwner,
                        didSelectShowReservation: () {
                          setState(() {
                            _tabController?.animateTo(1);
                            ReservationCoreHelper.pageController?.animateToPage(1, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                          });
                        },
                        didSelectActivityTicket: (ticket) {
                          setState(() {
                            if (reservationOwner != null) {
                              presentNewTicketAttendeeJoin(
                                  context,
                                  widget.model,
                                  reservation,
                                  activityForm,
                                  reservationOwner
                              );
                            }
                          });
                        },
                        didSelectSeeMoreReservations: () async {
                          if (kIsWeb) {
                            final newUrl = Uri.base.origin + searchExploreRoute();
                            final canLaunch = await canLaunchUrlString(newUrl);

                            if (canLaunch) {
                              await launchUrlString(newUrl);
                            }
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) {
                                  return DiscoverySearchComponent(
                                    model: widget.model,
                                  );

                                }));
                          }
                        },
                        didSelectSimilarRes: (res) async {
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
                                return  ActivityPreviewScreen(
                                  model: widget.model,
                                  listing: res.listing,
                                  reservation: res.reservation,
                                  currentReservationId: res.reservation!.reservationId,
                                  currentListingId: res.reservation!.instanceId,
                                  didSelectBack: () {

                                  },
                                );
                            }));
                          }
                        },
                      ),
                    ),
                  ),
                );
              case ResOverViewTabs.reservation:
                return Flexible(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: FacilityOverviewInfoWidget(
                        model: widget.model,
                        overViewState: FacilityPreviewState.reservation,
                        newFacilityBooking: reservation,
                        reservations: [],
                        /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
                        listingOwnerProfile: currentUser,
                        listing: listing,
                        selectedReservationsSlots: [],
                        selectedActivityType: null,
                        currentListingActivityOption: null,
                        currentSelectedSpace: null,
                        currentSelectedSpaceOption: null,
                        didSelectSpace: (space) {},
                        didSelectSpaceOption: (spaceOption) {},
                        updateBookingItemList: (slotItem, currency) {},
                        didSelectItem: () {},
                        isAttendee: true,
                      ),
                    ),
                  ),
                );
              case ResOverViewTabs.discussion:
                return Flexible(
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          const SizedBox(height: (kIsWeb) ? 80 : 175),
                          mainContainerSectionOneRowTwo(
                              context,
                              postList,
                              listing,
                              currentUser,
                              reservation,
                              userProfiles
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }


         return ListView.builder(
             itemCount: 1,
             itemBuilder: (context, index) {
               return Row(
                   children: [
                   getMainWidget(pageIndex)
             ]
           );
         }
       );
     }
   );
  }

  Widget mainContainerSectionOneRowTwo(BuildContext context, List<Post> postList, ListingManagerForm listing, UserProfileModel currentUser, ReservationItem reservation, List<UserProfileModel> userProfiles) {
   return PostWidgetBuilder(
     model: widget.model,
     postList: widget.replyPosts ?? postList,
     isReply: widget.isReply,
     listing: listing,
     currentUser: currentUser,
     emptyPostView: (widget.isReply) ? emptyReplyContainer(context, widget.model) : emptyPostContainer(context, widget.model),
     reservation: reservation,
     userProfiles: userProfiles,
     // headerWidget: headerWidget,
     // onEndReached: () => _controller.animateTo(300, duration: const Duration(milliseconds: 800), curve: Curves.easeIn),
   );
  }



  Widget retrieveInputForPost(BuildContext context, BookedReservationFormState state, String reservationId, List<AttendeeItem> attendees) {
    return post.Input(
        isAudioAttachmentUploading: isAudioAttachmentUploading,
        isCameraImageAttachmentUploading: isCameraImageAttachmentUploading,
        isImageVideoAttachmentUploading: isImageVideoAttachmentUploading,
        onSubmitPressed: (postText) async {

          /// handle uploading media content to firebase, save all uri media content url's in new media post class
          final reference = FirebaseStorage.instance.ref('reservation/$reservationId/post_content/');
          final List<ImagePost> mediaPosts = [];

          if (_selectedFileSpaceImage.isNotEmpty) {
            for (XFile selectedImage in _selectedFileSpaceImage) {

              try {
                /// is uploading media content
                final UniqueId urlId = UniqueId();
                final imageFile = File(selectedImage.path);
                final decodeMedia = await decodeImageFromList(imageFile.readAsBytesSync());
                await reference.child(urlId.getOrCrash()).putFile(imageFile);
                final uri = await reference.child(urlId.getOrCrash()).getDownloadURL();


                final mediaPost = ImagePost(
                    name: urlId.getOrCrash(),
                    size: imageFile.lengthSync(),
                    uri: uri,
                    height: decodeMedia.height.toDouble(),
                    width: decodeMedia.width.toDouble()
                );

                mediaPosts.add(mediaPost);

              } catch (e) {
                /// could not upload media content
                final snackBar = SnackBar(
                    backgroundColor: widget.model.paletteColor,
                    content: Text(e.toString(), style: TextStyle(color: widget.model.webBackgroundColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            }
            setState(() {
              /// is finished uploading media content
              context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.imagesChanged(mediaPosts));
            });
          }

          setState(() {
            context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.textPostChanged(postText));
            if (widget.isReply && widget.replyToPost != null) {
              context.read<BookedReservationFormBloc>().add(const BookedReservationFormEvent.postIsSaving(true));
              context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishSubmittingReply(widget.replyToPost!, attendees)
              );
            } else {
              context.read<BookedReservationFormBloc>().add(const BookedReservationFormEvent.postIsSaving(true));
              context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didFinishSubmittingPost(attendees));
            }
            _selectedFileSpaceImage.clear();
          });

        },
        onAttachmentPressed: (type) async {

          switch (type) {

            case MediaType.camera:
              try {
                isCameraImageAttachmentUploading = true;
                final cameraImage = await _imagePicker.pickImage(source: ImageSource.camera);

                if (cameraImage != null) {
                  if ((_selectedFileSpaceImage.length + 1) <= 5) {
                    _selectedFileSpaceImage.add(cameraImage);
                    setState(() {});

                  } else {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.paletteColor,
                        content: Text('Sorry, a maximum of 5 images or videos can be posted at one time', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                isCameraImageAttachmentUploading = false;
              } catch (e) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: Text(e.toString(), style: TextStyle(color: widget.model.paletteColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              isCameraImageAttachmentUploading = false;
              return;
            case MediaType.multiPhotosVideo:
              try {
                isImageVideoAttachmentUploading = true;
                final multiImage = await _imagePicker.pickMultiImage();


                if (multiImage.isNotEmpty) {
                  if ((multiImage.length + _selectedFileSpaceImage.length) <= 5) {
                    _selectedFileSpaceImage.addAll(multiImage);
                    setState(() {});
                  } else {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.paletteColor,
                        content: Text('Sorry, a maximum of 5 images or videos can be posted at one time', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
                isImageVideoAttachmentUploading = false;
              } catch (e) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: Text(e.toString(), style: TextStyle(color: widget.model.paletteColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                isImageVideoAttachmentUploading = false;
              }
              isImageVideoAttachmentUploading = false;
              break;
            case MediaType.audio:
            // TODO: Handle this case.
              break;
            default:
              return;
          }

        },
        isSubmitting: state.isSubmitting,
        model: widget.model
    );
  }
}



