part of check_in_presentation;

class ActivityPreviewScreen extends StatefulWidget {

  final DashboardModel? model;
  final UniqueId currentListingId;
  final UniqueId currentReservationId;
  final ListingManagerForm? listing;
  final ReservationItem? reservation;
  final Function() didSelectBack;
  // final Function(ReservationPreviewer) didSelectSimilar;

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
  late bool isLoading = false;
  ActivityCreateNewMarker activityMarker = ActivityCreateNewMarker.activityDetails;
  ActivityPreviewTabs activityOverviewMarker = ActivityPreviewTabs.activity;

  late DashboardModel dashboardModel;

  @override
  void initState() {
    dashboardModel = DashboardModel.instance;
    _scrollController = ScrollController();
    _tabController = TabController(initialIndex: 0, length: ActivityPreviewTabs.values.length, vsync: this);

    facade.ActivityFormUpdateFacade.instance.updateViewCount(activityResId: widget.currentReservationId.getOrCrash());
    // updateStateSafely();
    super.initState();
  }

  void updateStateSafely() {

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1350), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget getMainContainerForActivityDetails(
      BuildContext context,
      DashboardModel model,
      ActivityManagerForm activityForm,
      ListingManagerForm listing,
      ReservationItem reservation,
      UserProfileModel activityOwner,
      List<AttendeeItem> allAttendees,
      List<EventMerchantVendorProfile> allAttendeeVendorProfiles,
      List<UniqueId> linkedCommunities,
      ) {

    final String? currentUser = facade.FirebaseChatCore.instance.firebaseUser?.uid;
    final bool isOwner = reservation.reservationOwnerId.getOrCrash() == currentUser;
    final AttendeeItem? currentAttendee = allAttendees.where((element) => element.attendeeOwnerId.getOrCrash() == currentUser).isNotEmpty ? allAttendees.where((element) => element.attendeeOwnerId.getOrCrash() == currentUser).first : null;
    final main = Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      color: (kIsWeb && (Responsive.isMobile(context))) ? model.accentColor : model.accentColor.withOpacity(0.35),
      child: getReservationFooterWidget(
          context,
          model,
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
                  model,
                  listing,
                  reservation,
                  activityForm,
                  activityOwner
              );
            });
          },
          didSelectManage: () {
            setState(() {
              if (isOwner) {
                if (kIsWeb) {
                  Beamer.of(context).update(
                      configuration: RouteInformation(
                          location: '/${DashboardMarker.resSettings.name.toString()}'
                      ),
                      rebuild: false
                  );
                  context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                } else {
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: (_) {
                  //       /// if owner else show attendee manage options
                  //       return ActivitySettingsScreenMobile(
                  //         model: model,
                  //         reservationItem: reservation,
                  //         activityManagerForm: activityForm,
                  //         listing: listing,
                  //         currentUser: currentUser,
                  //       );
                  //     })
                  // );
                }
              }

              switch (currentAttendee?.attendeeType) {
                case AttendeeType.free:
                  return presentALertDialogMobile(
                      context,
                      'Leaving?',
                      'Are you sure you want to leave this Activity?',
                      'Leave',
                      didSelectDone: () {
                        context.read<AttendeeFormBloc>().add(
                            AttendeeFormEvent.didDeleteAttendee());
                      }
                  );
                case AttendeeType.vendor:
                  if (kIsWeb) {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: '/${DashboardMarker.resSettings.name.toString()}'
                        ),
                        rebuild: false
                    );
                    context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.currentDashboardMarker(DashboardMarker.resSettings));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ManageAttendeeSettingsSubContainer(
                          model: model,
                          currentSettingItem: null,
                          reservationItem: reservation,
                          currentUser: currentUser,
                          // currentActivityManagerForm: activityForm,
                          // currentAttendee: currentAttendee,
                          // currentActivityOwnerProfile: activityOwner,
                          didSelectNavItem: (nav) {

                          }
                      );
                    },
                    )
                    );
                  }
                  // TODO: Handle this case.
                  break;
                case null:
                // TODO: Handle this case.
                  break;
                case AttendeeType.tickets:
                  // TODO: Handle this case.
                case AttendeeType.pass:
                  // TODO: Handle this case.
                case AttendeeType.instructor:
                  // TODO: Handle this case.
                case AttendeeType.partner:
                  // TODO: Handle this case.
                case AttendeeType.organization:
                  // TODO: Handle this case.
                case AttendeeType.interested:
                  // TODO: Handle this case.
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
                  model,
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
            presentActivityShareOptions(context, model, listing, reservation, activityForm);
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
    );


    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                child: mainContainerPageView(
                    context,
                    model,
                    reservation,
                    activityForm,
                    listing,
                    activityOwner,
                    allAttendees,
                    allAttendeeVendorProfiles,
                    linkedCommunities
                ),
              ),
            )
          ],
        ),

        if (activityForm.rulesService.accessVisibilitySetting.isPrivateOnly != true) Positioned(
          bottom: 0,
          child: ClipRRect(
            child: (kIsWeb && (Responsive.isMobile(context))) ? main : BackdropFilter(
              filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: main
            ),
          ),
        ),



        if (kIsWeb) mainContainerHeaderTabWeb(model),
        if (!(kIsWeb)) SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: AppBar(
            backgroundColor: (model.systemTheme.brightness != Brightness.dark) ? model.paletteColor : model.mobileBackgroundColor,
            elevation: 0,
            automaticallyImplyLeading: true,
            centerTitle: true,
            toolbarHeight: 80,
            leading: IconButton(onPressed: () {
              widget.didSelectBack();
              Navigator.of(context).pop();
            }, icon: Icon(Icons.cancel, size: 30, color: (model.systemTheme.brightness != Brightness.dark) ? model.mobileBackgroundColor : model.paletteColor), padding: EdgeInsets.zero),
            title: Text(activityForm.profileService.activityBackground.activityTitle.value.fold((l) => '${activityOwner.legalName.getOrCrash()}\'s Activity', (r) => r)),
            titleTextStyle: TextStyle(color: (model.systemTheme.brightness != Brightness.dark) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
            actions: [
              IconButton(
                onPressed: () {
                  presentActivityShareOptions(context, model, listing, reservation, activityForm);
                },
                icon: Icon(Icons.ios_share_rounded, color:  (model.systemTheme.brightness != Brightness.dark) ? model.mobileBackgroundColor : model.paletteColor),
              ),
              // IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
              // const SizedBox(width: 10),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: mainContainerHeaderTabMobile(context, model),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget mainContainerPageView(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityManagerForm, ListingManagerForm listing, UserProfileModel activityOwner, List<AttendeeItem> allAttendees, List<EventMerchantVendorProfile> allAttendeeVendorProfiles, List<UniqueId> linkedCommunities) {
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

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height
              ),

              ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (pageIndex == ActivityPreviewTabs.activity) Flexible(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: ReservationActivityInfoWidget(
                              model: model,
                              isLoading: false,
                              listingForm: listing,
                              activityForm: activityManagerForm,
                              activityOwner: activityOwner,
                              reservation: reservation,
                              allAttendees: allAttendees,
                              allVendors: allAttendeeVendorProfiles,
                              showSuggestions: false,
                              activitySetupComplete: true,
                              linkedCommunities: linkedCommunities,
                              didSelectShowReservation: () {
                                setState(() {
                                  _tabController?.animateTo(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                                  _pageController.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                                });
                              },
                              didSelectActivityTicket: (ticket) {
                                setState(() {
                                  presentNewTicketAttendeeJoin(
                                      context,
                                      model,
                                      reservation,
                                      activityManagerForm,
                                      activityOwner
                                  );
                                });
                              },
                              isOwner: false,
                              didSelectSeeMoreReservations: () {

                              },
                              didSelectSimilarRes: (res) {
                                if (kIsWeb) {
                                  didSelectSimilarReservation(context, model, res);
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
                      ),

                      if (pageIndex == ActivityPreviewTabs.reservation) Flexible(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 800),
                            child: FacilityOverviewInfoWidget(
                              model: model,
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
                  );
                }
              ),

              if (MediaQuery.of(context).size.width >= 1600) Padding(
                padding: const EdgeInsets.only(left: 1170.0, top: 75),
                child: SizedBox(
                    width: 600,
                    height: MediaQuery.of(context).size.height,
                    child: BasicWebFooter(model: model)
                ),
              ),
            ],
          );
      }
    );
  }

  Widget mainContainerHeaderTabMobile(BuildContext context, DashboardModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
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
          indicatorColor: (model.systemTheme.brightness != Brightness.dark) ? model.webBackgroundColor : model.paletteColor,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          labelColor: (model.systemTheme.brightness != Brightness.dark) ? model.webBackgroundColor : model.paletteColor,
          unselectedLabelColor: model.disabledTextColor,
          tabs: ActivityPreviewTabs.values.map(
                  (e) => Tab(text: e.name.toUpperCase())
          ).toList()
        ),
      ),
    );
  }

  Widget mainContainerHeaderTabWeb(DashboardModel model) {

    Widget main = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: model.accentColor.withOpacity(0.35)
        ),
        child: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          onTap: (index) {
            setState(() {
              activityOverviewMarker = ActivityPreviewTabs.values[index];
              _pageController.jumpToPage(index);
            });
          },
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: model.paletteColor
          ),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          labelColor: model.accentColor,
          unselectedLabelColor: model.paletteColor,
          tabs: ActivityPreviewTabs.values.map(
                  (e) => ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Tab(text: e.name.toUpperCase()),
              )
          ).toList(),
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Flexible(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: BackdropFilter(
                      filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: main
                )
              ),
            )
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    dashboardModel.systemTheme = Theme.of(context);
    dashboardModel.currentThemeData = dashboardModel.systemTheme.brightness != Brightness.dark
        ? ThemeData.light() : ThemeData.dark();
    dashboardModel.changeTheme(dashboardModel.currentThemeData!);

    final DashboardModel model = (widget.model != null) ? widget.model! : dashboardModel;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Scaffold(
        backgroundColor: model.mobileBackgroundColor,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
          ],
          child: (widget.reservation != null && widget.listing != null) ? retrieveActivitySettings(model, widget.listing!, widget.reservation!) : getListingContainer(model),
      ),
      ),
    );
  }

  Widget getListingContainer(DashboardModel model) {
    return BlocProvider(create: (context) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(widget.currentListingId.getOrCrash())),
      child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
              loadListingManagerItemSuccess: (item) {
                return getReservationContainer(model, item.failure);
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }

  Widget getReservationContainer(DashboardModel model, ListingManagerForm listing) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.currentReservationId.getOrCrash())),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeWhen(
                resLoadInProgress: () => JumpingDots(color: model.paletteColor, numberOfDots: 3),
                loadReservationItemSuccess: (res) {
                  return retrieveActivitySettings(model, listing, res);
                },
                orElse: () => Container()
            );
          },
        )
    );
  }


  Widget retrieveActivitySettings(DashboardModel model, ListingManagerForm listing, ReservationItem reservation) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservation.reservationId.getOrCrash()))),
      ],
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
              loadActivityManagerFormSuccess: (item) => retrieveActivityOwner(model, listing, reservation, item.item),
              orElse: () => retrieveActivityOwner(model, listing, reservation, ActivityManagerForm.empty())
          );
        },
      ),
    );
  }

  Widget retrieveActivityOwner(DashboardModel model, ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(reservation.reservationOwnerId.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  // loadInProgress: (_) => JumpingDots(color: model.paletteColor, numberOfDots: 3),
                  loadSelectedProfileFailure: (_) => Container(),
                  loadSelectedProfileSuccess: (item) => retrieveAllAttendees(model, listing, reservation, activityForm, item.profile),
                  orElse: () => Container()
          );
        }
      ),
    );
  }

  Widget retrieveAllAttendees(DashboardModel model, ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile) {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(reservation.reservationId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadAllAttendanceActivitySuccess: (attendee) {
                return BlocProvider(create: (context) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchAllEventMerchProfileFromIds(attendee.item.where((e) => e.attendeeType == AttendeeType.vendor).map((e) => (e.eventMerchantVendorProfile != null) ? e.eventMerchantVendorProfile!.getOrCrash() : '').toList())),
                    child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
                      builder: (context, state) {
                        return state.maybeMap(
                            loadAllMerchVendorFromIdsSuccess: (item) {
                              return  retrieveAllLinkedCommunityIds(model, listing, reservation, activityForm, activityOwnerProfile, attendee.item, item.items);
                          },
                        orElse: () => retrieveAllLinkedCommunityIds(model, listing, reservation, activityForm, activityOwnerProfile, attendee.item, [])
                      );
                    },
                  )
                );
                // return retrieveAllVendorProfiles(model, listing, reservation, activityForm, activityOwnerProfile, attendee.item);
              },
              orElse: () => retrieveAllLinkedCommunityIds(model, listing, reservation, activityForm, activityOwnerProfile, [], [])
          );
        },
      ),
    );
  }


  Widget retrieveAllLinkedCommunityIds(DashboardModel model, ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile, List<AttendeeItem> allAttendees, List<EventMerchantVendorProfile> allAttendeeVendorProfiles) {
    return BlocProvider(create: (_) => getIt<CommunityManagerWatcherBloc>()..add(CommunityManagerWatcherEvent.watchReservationLinkedCommunity(reservation.reservationId)),
        child: BlocBuilder<CommunityManagerWatcherBloc, CommunityManagerWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadReservationLinkedCommunitiesSuccess: (item) => retrieveMainContainerForAttendee(model, listing, reservation, activityForm, activityOwnerProfile, allAttendees, allAttendeeVendorProfiles, item.communityIds),
                  orElse: () => retrieveMainContainerForAttendee(model, listing, reservation, activityForm, activityOwnerProfile, allAttendees, allAttendeeVendorProfiles, [])
          );
        }
      )
    );
  }

  Widget retrieveMainContainerForAttendee(DashboardModel model, ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm, UserProfileModel activityOwnerProfile, List<AttendeeItem> allAttendees, List<EventMerchantVendorProfile> allAttendeeVendorProfiles, List<UniqueId> linkedCommunities) {
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
                        backgroundColor: model.webBackgroundColor,
                        content: failure.maybeMap(
                          couldNotRetrievePaymentMethod: (_) => Text('Could not retrieve payment details', style: TextStyle(color: model.disabledTextColor)),
                          paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor)),
                          orElse: () => Text('A Problem Happened', style: TextStyle(color: model.disabledTextColor)),
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
                    model,
                    activityForm,
                    listing,
                    reservation,
                    activityOwnerProfile,
                    allAttendees,
                    allAttendeeVendorProfiles,
                    linkedCommunities
              )
            ),
          ];

          if (isLoading) {
            return JumpingDots(color: model.paletteColor, numberOfDots: 3);
          }

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: model.mobileBackgroundColor,
              ),
              Visibility(
                  visible: activitySetupComplete(activityForm) == true,
                  child: IgnorePointer(
                    ignoring: activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true,
                    child: activityContainerModel.firstWhere((element) => element.markerItem == activityMarker).childWidget)
              ),

              /// handle private activity
              if (activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true) Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: model.mobileBackgroundColor
              ),
              /// handle non-activity reservation
              if (activitySetupComplete(activityForm) == false) Positioned(
                top: (MediaQuery.of(context).size.height / 2) - 200,
                child: Container(
                    width: 600,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: model.accentColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                          children: [
                            const SizedBox(height: 15),
                            Icon(Icons.info, color: model.disabledTextColor, size: 60),
                            const SizedBox(height: 15),
                            Text('Activity Doesn\'t Exist', style: TextStyle(color: model.disabledTextColor, fontSize: model.questionTitleFontSize)),
                            Text('This activity is no longer available. If you would like to gain access or would like to request an invite, please contact the organizer.', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                            const SizedBox(height: 15),
                            BasicWebFooter(model: model),
                            const SizedBox(height: 15),
                      ]
                    ),
                  )
                ),
              ),
              if (activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true) Positioned(
                top: (MediaQuery.of(context).size.height / 2) - 200,
                child: Container(
                  width: 600,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: model.accentColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                            children: [
                                const SizedBox(height: 15),
                                Icon(Icons.lock, color: model.disabledTextColor, size: 60),
                                const SizedBox(height: 15),
                                Text('Private Activity', style: TextStyle(color: model.disabledTextColor, fontSize: model.questionTitleFontSize)),
                                Text('This activity has been set to private, and is no longer open. If you would like to gain access or would like to request an invite, please contact the organizer.', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                                const SizedBox(height: 15),
                          ]
                        ),
                      )
                  ),
              ),

            ],
          );
        },
      ),
    );
  }
}