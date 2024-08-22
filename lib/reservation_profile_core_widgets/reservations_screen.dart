part of check_in_presentation;

class ReservationScreen extends StatefulWidget {

  final DashboardModel model;
  final UniqueId? initialReservationId;
  final Function(
      ListingManagerForm listing,
      ReservationItem res,
      UserProfileModel profile,
      ActivityManagerForm activityManagerForm,
      AttendeeItem? attendeeItem,
      List<TicketItem> currentUsersTickets) didSelectReservation;

  const ReservationScreen({
    super.key,
    required this.model,
    required this.didSelectReservation,
    this.initialReservationId,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> with SingleTickerProviderStateMixin {

  late int _pageIndex = 1;
  late TabController? _tabController;
  late PageController? _pageController;


  @override
  void initState() {
    _tabController = TabController(initialIndex: ReservationCoreHelper.currentTabPageIndex, length: 2, vsync: this);
    _pageController = PageController(initialPage: ReservationCoreHelper.currentTabPageIndex);

    if (facade.FirebaseChatCore.instance.firebaseUser?.uid != null) {
      ReservationCoreHelper.pagingController = PagingController(firstPageKey: 0);
      if (mounted) {
        ReservationCoreHelper.pagingController?.addPageRequestListener((pageKey) {
          ReservationCoreHelper.fetchByCompleted(context, [ReservationSlotState.completed], null, facade.FirebaseChatCore.instance.firebaseUser!.uid, pageKey);
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController?.dispose();
    // ReservationCoreHelper.pagingController?.dispose();
    facade.ReservationFacade.instance.lastDoc = null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: retrieveAuthenticationState(context, kIsWeb)
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, bool isBrowser) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => emptyLargeListView(context, 10, Axis.vertical, kIsWeb),
              loadProfileFailure: (_) => (isBrowser) ? GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },) : emptyLargeListView(context, 10, Axis.vertical, kIsWeb),
              loadUserProfileSuccess: (item) => getNotificationsForAllReservations(context, item.profile),
              orElse: () {
                return emptyLargeListView(context, 10, Axis.vertical, kIsWeb);
            }
          );
        },
      ),
    );
  }

  Widget getNotificationsForAllReservations(BuildContext context, UserProfileModel currentUser) {
      return BlocProvider(create: (_) => getIt<NotificationWatcherBloc>()..add(NotificationWatcherEvent.watchAllAccountNotificationAmountByType([AccountNotificationType.invite, AccountNotificationType.request, AccountNotificationType.joined, AccountNotificationType.activityPost, AccountNotificationType.resSlot], null)),
        child: BlocBuilder<NotificationWatcherBloc, NotificationWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                loadAllAccountNotificationByTypeSuccess: (item) {
                  return listOfReservations(context, currentUser, item.notifications);
                },
              orElse: () => listOfReservations(context, currentUser, [])
          );
        }
      )
    );
  }

  Widget listOfReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return Column(
      children: [
        const SizedBox(height: 25),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          onTap: (index) {
            ReservationCoreHelper.currentTabPageIndex = index;
            _pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
          },
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: widget.model.paletteColor
          ),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelColor: widget.model.accentColor,
            unselectedLabelColor: widget.model.disabledTextColor,
            tabs: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: const Tab(text: 'Reservations')
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Tab(text: 'Completed')
              )
            ]
          ),

        const SizedBox(height: 15),
        Expanded(
          child: PageView.builder(
              physics: (kIsWeb) ? const NeverScrollableScrollPhysics() : null,
              controller: _pageController,
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              itemBuilder: (_, index) {
                if (index == 0) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        getCurrentReservations(context, currentUser, notifications),
                        getRequestedReservations(context, currentUser, notifications),
                        getAttendingJoinedReservations(context, currentUser, notifications),
                        getAttendingInvitedReservations(context, currentUser, notifications),
                        Divider(color: widget.model.accentColor),
                        getConfirmedReservations(context, currentUser, notifications),
                      ],
                    ),
                  );
                } else {
                    return getCompletedReservations(context, currentUser, notifications);
                }
              }
          ),
        ),
      ],
    );
  }


  Widget getAttendingJoinedReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchProfileAllAttendingResStarted(ContactStatus.joined, null, 5, currentUser.userId.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadProfileAttendingResSuccess: (e) {
                return  Visibility(
                    visible: e.attending.isNotEmpty,
                    child: ReservationAttendingPreviewerListWidget(
                      model: widget.model,
                      showLoadingList: true,
                      titleText: 'Joined',
                      isPagingView: false,
                      selectedReservationId: widget.initialReservationId,
                      currentUserId: currentUser.userId,
                      didSelectReservation: (item) {
                        if (item.listing != null && item.reservation != null) {
                          final AttendeeItem attendeeItem = e.attending.firstWhere((element) => element.reservationId == item.reservation?.reservationId, orElse: () => AttendeeItem.empty());
                          widget.didSelectReservation(item.listing!, item.reservation!, currentUser, item.activityManagerForm ?? ActivityManagerForm.empty(), attendeeItem, []);
                        }
                      },
                      reservations: e.attending.map((f) => f.reservationId).toList(),
                    )
                );
              },
          orElse: () => Container()
        );
      })
    );
  }

  Widget getAttendingInvitedReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchProfileAllAttendingResStarted(ContactStatus.invited, null, 5, currentUser.userId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadProfileAttendingResSuccess: (e) {
                    return Visibility(
                      visible: e.attending.isNotEmpty,
                      child: ReservationAttendingPreviewerListWidget(
                        model: widget.model,
                        showLoadingList: true,
                        titleText: 'Invites',
                        isPagingView: false,
                        selectedReservationId: widget.initialReservationId,
                        currentUserId: currentUser.userId,
                        didSelectReservation: (item) {
                          if (item.listing != null && item.reservation != null) {
                            final AttendeeItem attendeeItem = e.attending.firstWhere((element) => element.reservationId == item.reservation?.reservationId, orElse: () => AttendeeItem.empty());
                            widget.didSelectReservation(item.listing!, item.reservation!, currentUser, item.activityManagerForm ?? ActivityManagerForm.empty(), attendeeItem, []);
                          }
                        },
                       reservations: e.attending.map((f) => f.reservationId).toList(),
                                        ),
                    );
              },
           orElse: () => Container()
        );
      })
    );
  }

  Widget getCurrentReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current], currentUser, false, null, null)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
      return state.maybeMap(
          resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
          loadCurrentUserReservationsSuccess: (e) {
              /// happening now!
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    if (e.item.isEmpty) noItemsFound(
                    widget.model,
                    Icons.calendar_today_outlined,
                    'No Reservations Yet!',
                    'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                    'Start Booking',
                    didTapStartButton: () {
                    }),

                    if (e.item.isNotEmpty) Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.model.disabledTextColor.withOpacity(0.23),
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              ReservationAttendingPreviewerListWidget(
                                model: widget.model,
                                showLoadingList: false,
                                titleText: 'Happening Now!',
                                isPagingView: false,
                                selectedReservationId: widget.initialReservationId,
                                currentUserId: currentUser.userId,
                                didSelectReservation: (item) {
                                  if (item.listing != null && item.reservation != null) {
                                    widget.didSelectReservation(item.listing!, item.reservation!, currentUser, item.activityManagerForm ?? ActivityManagerForm.empty(), item.attendingItem, []);
                                  }
                                },
                                reservations: e.item.map((e) => e.reservationId).toList(),
                              ),
                              const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              );
            },
            orElse: () => noItemsFound(
                widget.model,
                Icons.calendar_today_outlined,
                'No Reservations Yet!',
                'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                'Start Booking',
                didTapStartButton: () {
                }),
          );
        }
      )
    );
  }

  Widget getRequestedReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchProfileAllAttendingResStarted(ContactStatus.requested, null, 5, currentUser.userId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadProfileAttendingResSuccess: (e) {
                    return Visibility(
                      visible: e.attending.isNotEmpty,
                      child: ReservationAttendingPreviewerListWidget(
                        model: widget.model,
                        showLoadingList: true,
                        titleText: 'Requests',
                        isPagingView: false,
                        selectedReservationId: widget.initialReservationId,
                        currentUserId: currentUser.userId,
                        didSelectReservation: (item) {
                          if (item.listing != null && item.reservation != null) {
                            final AttendeeItem attendeeItem = e.attending.firstWhere((element) => element.reservationId == item.reservation?.reservationId, orElse: () => AttendeeItem.empty());
                            widget.didSelectReservation(item.listing!, item.reservation!, currentUser, item.activityManagerForm ?? ActivityManagerForm.empty(), attendeeItem, []);
                          }
                        },
                        reservations: e.attending.map((f) => f.reservationId).toList(),
                      ),
                    );
                  },
                  orElse: () => Container()
              );
            })
    );
  }

  Widget getConfirmedReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.confirmed], currentUser, false, null, null)),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadCurrentUserReservationsSuccess: (e) {

                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ReservationAttendingPreviewerListWidget(
                        model: widget.model,
                        showLoadingList: true,
                        titleText: 'Coming-Up',
                        isPagingView: false,
                        selectedReservationId: widget.initialReservationId,
                        currentUserId: currentUser.userId,
                        didSelectReservation: (item) {
                          if (item.listing != null && item.reservation != null) {
                            widget.didSelectReservation(item.listing!, item.reservation!, currentUser, item.activityManagerForm ?? ActivityManagerForm.empty(), item.attendingItem, []);
                          }
                        },
                        reservations: e.item.map((e) => e.reservationId).toList(),
                      ),
                  ]
                );
              },
            orElse: () => Container()
          );
        }
      )
    );
  }




  // ReservationHelperCore.selectedReservationItem
  Widget getCompletedReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: PagedListView<int, ReservationPreviewer>(
              addAutomaticKeepAlives: true,
              scrollDirection: Axis.vertical,
              pagingController: ReservationCoreHelper.pagingController!,
              builderDelegate: PagedChildBuilderDelegate<ReservationPreviewer>(
                animateTransitions: true,
               firstPageProgressIndicatorBuilder: (context) {
                 return emptyLargeListView(context, 10, Axis.vertical, kIsWeb);
               },
               newPageProgressIndicatorBuilder: (context) {
                 return Padding(
                   padding: const EdgeInsets.symmetric(vertical: 18.0),
                   child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                 );
               },
               noItemsFoundIndicatorBuilder: (context) {
                 return noItemsFound(
                     widget.model,
                     Icons.calendar_today_outlined,
                     'No Reservations Yet!',
                     'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                     'Start Booking',
                     didTapStartButton: () {
                   }
                 );
               },
               itemBuilder: (context, item, index) {
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: baseSearchItemContainer(
                     height: 400,
                     width: 400,
                       model: widget.model,
                       isSelected: widget.initialReservationId == item.reservation?.reservationId,
                       backgroundWidget: getReservationMediaFrameFlexible(context, widget.model, 400, 400, item.listing, item.activityManagerForm, item.reservation!, false,
                           didSelectItem: () {
                          if (item.listing != null && item.reservation != null) {
                             widget.didSelectReservation(item.listing!, item.reservation!, currentUser, item.activityManagerForm ?? ActivityManagerForm.empty(), item.attendingItem, []);
                           }
                       }),
                       bottomWidget: getSearchFooterWidget(
                           context,
                           widget.model,
                           currentUser.userId,
                           widget.model.paletteColor,
                           widget.model.disabledTextColor,
                           widget.model.accentColor,
                           item,
                           false,
                           didSelectItem: () {
                           },
                           didSelectInterested: () {
                       }
                     )
                   ),
                 );

                 return Column(
                   children: [
                     Text(item.reservation?.reservationId.getOrCrash() ?? ''),
                     Text(item.activityManagerForm?.profileService.activityBackground.activityTitle.getOrCrash() ?? 'not activity'),
                ],
             );
          }
        )
      ),
    );

    //   return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.completed], currentUser, false)),
    //     child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
    //       builder: (context, state) {
    //         return state.maybeMap(
    //           loadCurrentUserReservationsSuccess: (e) {
    //             return Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //
    //                 const SizedBox(height: 8),
    //                 Text('Where You Went', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
    //                 const SizedBox(height: 6),
    //                 ...e.item.map((e) => getReservationCardListing(
    //                   context,
    //                   false,
    //                   e,
    //                   currentUser,
    //                   widget.model,
    //                   true,
    //                   widget.initialReservationId == e.reservationId || ReservationHelperCore.selectedReservationItem == e,
    //                   notifications.where((element) => element.reservationId == e.reservationId).toList(),
    //                   didSelectReservation: (
    //                       ListingManagerForm listing,
    //                       ReservationItem reservation,
    //                       ActivityManagerForm activity,
    //                       AttendeeItem? attendeeItem,
    //                       List<TicketItem> currentUsersTickets,
    //                       ) {
    //                     widget.didSelectReservation(listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets);
    //                   },
    //                     didSelectResDetail: (model, listing, reservation, isResOwner, isFromChat, currentUser) {
    //                       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
    //                         return ReservationDetailsWidget(
    //                           model: model,
    //                           listing: listing,
    //                           reservationItem: reservation,
    //                           isReservationOwner: false,
    //                           allAttendees: [],
    //                           isFromChat: true,
    //                           currentUser: currentUser,
    //                         );
    //                       })
    //                       );
    //                     }
    //                 )
    //                 ).toList(),
    //               ]
    //             );
    //           },
    //           ///TODO: add failure of type empty
    //           /// if network call cant be made you should not be allowed to make any new reservation
    //           orElse: () => Container()
    //       );
    //     },
    //   )
    // );
  }
}