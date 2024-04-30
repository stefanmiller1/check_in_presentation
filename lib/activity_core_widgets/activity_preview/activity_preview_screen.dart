part of check_in_presentation;

class ActivityPreviewScreen extends StatefulWidget {

  final DashboardModel model;
  final UniqueId currentListingId;
  final UniqueId currentReservationId;
  final ListingManagerForm? listing;
  final ReservationItem? reservation;
  final Function() didSelectBack;

  const ActivityPreviewScreen({super.key, required this.model, required this.listing, required this.reservation, required this.currentListingId, required this.currentReservationId, required this.didSelectBack});

  @override
  State<ActivityPreviewScreen> createState() => _ActivityPreviewScreenState();
}

class _ActivityPreviewScreenState extends State<ActivityPreviewScreen> with SingleTickerProviderStateMixin {

  late TabController? _tabController;
  late ScrollController _scrollController;
  late bool isSubmittingSignIn = false;
  late PageController _pageController = PageController(initialPage: 0);
  late int _currentPageIndex = 0;
  ActivityCreateNewMarker activityMarker = ActivityCreateNewMarker.activityDetails;
  ActivityPreviewTabs activityOverviewMarker = ActivityPreviewTabs.activity;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(initialIndex: 0, length: ActivityPreviewTabs.values.length, vsync: this);
    super.initState();
  }


  Widget getMainContainerForActivityDetails(
      BuildContext context,
      ActivityManagerForm activityForm,
      ListingManagerForm listing,
      ReservationItem reservation,
      UserProfileModel activityOwner,
      List<AttendeeItem> allAttendees,
      List<UniqueId> linkedCommunities,
      ) {

    final String? currentUser = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    final bool isOwner = reservation.reservationOwnerId.getOrCrash() == currentUser;
    final AttendeeItem? currentAttendee = allAttendees.where((element) => element.attendeeOwnerId.getOrCrash() == currentUser).isNotEmpty ? allAttendees.where((element) => element.attendeeOwnerId.getOrCrash() == currentUser).first : null;

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                child: mainContainerPageView(
                    context,
                    reservation,
                    activityForm,
                    listing,
                    activityOwner,
                    allAttendees,
                    linkedCommunities
                ),
              ),
            )
          ],
        ),

        Positioned(
          bottom: 0,
          child: ClipRRect(
            child: BackdropFilter(
              filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                color: widget.model.accentColor.withOpacity(0.35),
                child: getReservationFooterWidget(
                    context,
                    widget.model,
                    activityForm,
                    reservation,
                    currentAttendee,
                    allAttendees,
                    currentUser,
                    isOwner,
                    false,
                    didSelectJoin: () {
                      setState(() {
                        presentNewAttendeeJoin(
                            context,
                            widget.model,
                            reservation,
                            activityForm,
                            activityOwner
                        );
                      });
                    },
                    didSelectManage: () {
                      setState(() {
                        if (kIsWeb) {

                        } else {
                          if (isOwner) {

                          } else {
                            presentALertDialogMobile(
                                context,
                                'Leaving?',
                                'Are you sure you want to leave this Activity?',
                                'Leave',
                                didSelectDone: () {
                                  context.read<AttendeeFormBloc>().add(
                                      AttendeeFormEvent.didDeleteAttendee());
                                }
                            );
                          }
                        }
                      });
                    },
                    didSelectManageTickets: () {
                      setState(() {
                        if (kIsWeb) {

                        } else {

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
                            activityOwner
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

                    },
                    didSelectMoreOptions: () {
                      if (kIsWeb) {

                      } else {

                      }
                    },
                    didSelectInterested: () {
                      if (kIsWeb) {

                      } else {

                      }
                    }
                ),
              ),
            ),
          ),
        ),



        if (kIsWeb) mainContainerHeaderTabWeb(),
        if (!(kIsWeb)) SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: AppBar(
            backgroundColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.paletteColor : widget.model.mobileBackgroundColor,
            elevation: 0,
            automaticallyImplyLeading: true,
            centerTitle: true,
            toolbarHeight: 80,
            leading: IconButton(onPressed: () {
              widget.didSelectBack();
              Navigator.of(context).pop();
            }, icon: Icon(Icons.cancel, size: 30, color: widget.model.paletteColor), padding: EdgeInsets.zero),
            title: Text(activityForm.profileService.activityBackground.activityTitle.value.fold((l) => '${activityOwner.legalName.getOrCrash()}\'s Activity', (r) => r)),
            titleTextStyle: TextStyle(color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
            actions: [
              // IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
              // const SizedBox(width: 10),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: mainContainerHeaderTabMobile(context),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget mainContainerPageView(BuildContext context, ReservationItem reservation, ActivityManagerForm activityManagerForm, ListingManagerForm listing, UserProfileModel activityOwner, List<AttendeeItem> allAttendees, List<UniqueId> linkedCommunities) {
    return PageView.builder(
        controller: _pageController,
        itemCount: 2,
        scrollDirection: Axis.horizontal,
        allowImplicitScrolling: true,
        physics: (kIsWeb) ? NeverScrollableScrollPhysics() : null,
        onPageChanged: (page) {
          setState(() {
            _tabController?.animateTo(page, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
          });
        },
        itemBuilder: (_, index) {

          ActivityPreviewTabs pageIndex = ActivityPreviewTabs.values[index];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: (kIsWeb) ? 25.0 : 0),
              child: Row(
                children: [

                  if (pageIndex == ActivityPreviewTabs.activity) Flexible(
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: ReservationActivityInfoWidget(
                              model: widget.model,
                              activityForm: activityManagerForm,
                              activityOwner: activityOwner,
                              reservation: reservation,
                              allAttendees: allAttendees,
                              showSuggestions: false,
                              activitySetupComplete: true,
                              linkedCommunities: linkedCommunities,
                              didSelectActivityTicket: (ticket) {
                                setState(() {
                                  presentNewTicketAttendeeJoin(
                                      context,
                                      widget.model,
                                      reservation,
                                      activityManagerForm,
                                      activityOwner
                                  );
                            });
                          },
                            isOwner: false,
                        ),
                      ),
                    )
                  ),

                  if (pageIndex == ActivityPreviewTabs.reservation) Flexible(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: FacilityOverviewInfoWidget(
                          model: widget.model,
                          overViewState: FacilityPreviewState.reservation,
                          newFacilityBooking: reservation,
                          reservations: [],
                          /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
                          listingOwnerProfile: activityOwner,
                          listing: listing,
                          selectedReservationsSlots: [],
                          selectedActivityType: null,
                          currentListingActivityOption: null,
                          currentSelectedSpace: null,
                          currentSelectedSpaceOption: null,
                          didSelectSpace: (space) {
                          },
                          didSelectSpaceOption: (spaceOption) {
                          },
                          updateBookingItemList: (slotItem, currency) {
                          },
                          didSelectItem: () {
                          },
                          isAttendee: allAttendees.map((e) => e.attendeeOwnerId.getOrCrash()).contains(facade.FirebaseChatCore.instance.firebaseUser?.uid),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget mainContainerHeaderTabMobile(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        onTap: (index) {
          setState(() {
            activityOverviewMarker = ActivityPreviewTabs.values[index];
            _pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
          });
        },
        indicatorColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.webBackgroundColor : widget.model.paletteColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        labelColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.webBackgroundColor : widget.model.paletteColor,
        unselectedLabelColor: widget.model.disabledTextColor,
        tabs: ActivityPreviewTabs.values.map(
                (e) => Tab(text: e.name.toUpperCase())
        ).toList()
      ),
    );
  }

  Widget mainContainerHeaderTabWeb() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Flexible(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
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
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          onTap: (index) {
                            setState(() {
                              activityOverviewMarker = ActivityPreviewTabs.values[index];
                              _pageController.animateToPage(index, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                            });
                          },
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: widget.model.paletteColor
                          ),
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          labelColor: widget.model.accentColor,
                          unselectedLabelColor: widget.model.paletteColor,
                          tabs: ActivityPreviewTabs.values.map(
                                  (e) => ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Tab(text: e.name.toUpperCase()),
                        )
                      ).toList(),
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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Scaffold(
        backgroundColor: widget.model.mobileBackgroundColor,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
          ],
          child: (widget.reservation != null && widget.listing != null) ? retrieveActivitySettings(widget.listing!, widget.reservation!) : getListingContainer(),
      ),
      ),
    );
  }

  Widget getListingContainer() {
    return BlocProvider(create: (context) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(widget.currentListingId.getOrCrash())),
      child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadListingManagerItemSuccess: (item) {
                return getReservationContainer(item.failure);
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }

  Widget getReservationContainer(ListingManagerForm listing) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.currentReservationId.getOrCrash())),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeWhen(
                resLoadInProgress: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                loadReservationItemSuccess: (res) {
                  return retrieveActivitySettings(listing, res);
                },
                orElse: () => Container()
            );
          },
        )
    );
  }


  Widget retrieveActivitySettings(ListingManagerForm listing, ReservationItem reservation) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(reservation.reservationOwnerId.getOrCrash()))),
        BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservation.reservationId.getOrCrash()))),
      ],
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadActivityManagerFormSuccess: (item) => retrieveActivityOwner(listing, reservation, item.item),
              orElse: () => retrieveActivityOwner(listing, reservation, ActivityManagerForm.empty())
          );
        },
      ),
    );
  }

  Widget retrieveActivityOwner(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm) {
    return BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              // loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
              loadSelectedProfileSuccess: (item) => retrieveAllAttendees(listing, reservation, activityForm, item.profile),
              orElse: () => Container()
        );
      }
    );
  }

  Widget retrieveAllAttendees(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile) {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(reservation.reservationId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadAllAttendanceActivitySuccess: (item) => retrieveAllLinkedCommunityIds(listing, reservation, activityForm, activityOwnerProfile, item.item),
              orElse: () => retrieveAllLinkedCommunityIds(listing, reservation, activityForm, activityOwnerProfile, [])
          );
        },
      ),
    );
  }

  Widget retrieveAllLinkedCommunityIds(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile, List<AttendeeItem> allAttendees) {
    return BlocProvider(create: (_) => getIt<CommunityManagerWatcherBloc>()..add(CommunityManagerWatcherEvent.watchReservationLinkedCommunity(reservation.reservationId)),
        child: BlocBuilder<CommunityManagerWatcherBloc, CommunityManagerWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadReservationLinkedCommunitiesSuccess: (item) => retrieveMainContainerForAttendee(listing, reservation, activityForm, activityOwnerProfile, allAttendees, item.communityIds),
                  orElse: () => retrieveMainContainerForAttendee(listing, reservation, activityForm, activityOwnerProfile, allAttendees, [])
          );
        }
      )
    );
  }

  Widget retrieveMainContainerForAttendee(ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile, List<AttendeeItem> allAttendees, List<UniqueId> linkedCommunities) {
    return BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(dart.optionOf(AttendeeItem(
        attendeeId: AttendeeItem.empty().attendeeId,
        attendeeOwnerId: (facade.FirebaseChatCore.instance.firebaseUser != null) ? UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser!.uid) : UniqueId(),
        reservationId: reservation.reservationId,
        cost: AttendeeItem.empty().cost,
        paymentStatus: AttendeeItem.empty().paymentStatus,
        attendeeType: AttendeeItem.empty().attendeeType,
        paymentIntentId: AttendeeItem.empty().paymentIntentId,
        dateCreated: AttendeeItem.empty().dateCreated)),
        dart.optionOf(reservation),
        dart.optionOf(activityForm),
        dart.optionOf(activityOwnerProfile)
      ),
    ),
      child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
        listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
        listener: (context, state) {
          state.authPaymentFailureOrSuccessOption.fold(
                  () => {},
                  (either) => either.fold(
                      (failure) {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.webBackgroundColor,
                        content: failure.maybeMap(
                          couldNotRetrievePaymentMethod: (_) => Text('Could not retrieve payment details', style: TextStyle(color: widget.model.disabledTextColor)),
                          paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                          orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                      )
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, (success) {
                Navigator.of(context).pop();
              }
            )
          );
        },
        buildWhen: (p,c) => p.attendeeItem != c.attendeeItem || p.isSubmitting != c.isSubmitting,
        builder: (context, state) {

          List<NewActivityModel> activityContainerModel = [
            NewActivityModel(
                markerItem: ActivityCreateNewMarker.activityDetails,
                childWidget: getMainContainerForActivityDetails(
                    context,
                    activityForm,
                    listing,
                    reservation,
                    activityOwnerProfile,
                    allAttendees,
                    linkedCommunities
              )
            ),

          ];

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: widget.model.mobileBackgroundColor,
              ),
              activityContainerModel.firstWhere((element) => element.markerItem == activityMarker).childWidget
            ],
          );
        },
      ),
    );
  }
}