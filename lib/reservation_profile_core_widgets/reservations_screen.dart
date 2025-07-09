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

  late ReservationFilterObject? _currentFilterModel = ReservationFilterObject(
    filterType: ReservationTypeFilter.comingUp,
    reservationHostingType: null,
    contactStatusOptions: ContactStatus.values,
    formStatus: null,
    privateReservationsOnly: null,
    isReverseSorted: null,
    filterByDateType: null,
    filterWithStartDate: null,
    filterWithEndDate: null
  );
  late bool isLoading = false;

  late List<ReservationFilter> _reservationFilters = [
    ReservationFilter(
      filterTitle: 'Coming Up',
      filterType: ReservationTypeFilter.comingUp,
    ),
    ReservationFilter(
      filterTitle: 'Completed',
      filterType: ReservationTypeFilter.completed,
    ),
    ReservationFilter(
      filterTitle: 'Hosting', 
      filterType: ReservationTypeFilter.hosting, 
      reservationHostingType: ReservationSlotState.values.where((state) => state != ReservationSlotState.completed).toList()
    ),
    ReservationFilter(
      filterTitle: 'Posted',
      filterType: ReservationTypeFilter.posted,
      reservationHostingType: [ReservationSlotState.confirmed, ReservationSlotState.current, ReservationSlotState.cancelled]
    ),
    ReservationFilter(
      filterTitle: 'Draft',
      filterType: ReservationTypeFilter.draft,
      formStatus: FormStatus.values.where((status) => status != FormStatus.published).toList()
    ),
    ReservationFilter(
      filterTitle: 'Attending',
      filterType: ReservationTypeFilter.attending,
      contactStatusOptions: ContactStatus.values,
    ),
  ];
  

  @override
  void initState() {

    if (facade.FirebaseChatCore.instance.firebaseUser?.uid != null) {
      ReservationCoreHelper.pagingController = PagingController(firstPageKey: 0);
      if (mounted) {
        ReservationCoreHelper.pagingController?.addPageRequestListener((pageKey) {
          ReservationCoreHelper.fetchByCompleted(context, [ReservationSlotState.completed], true, _currentFilterModel?.privateReservationsOnly, _currentFilterModel?.isReverseSorted, facade.FirebaseChatCore.instance.firebaseUser!.uid, pageKey);
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
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
              loadInProgress: (_) => emptyLargeListView(context, 10, 300, Axis.vertical, kIsWeb),
              loadProfileFailure: (_) => (isBrowser) ? GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },) : emptyLargeListView(context, 10, 300, Axis.vertical, kIsWeb),
              loadUserProfileSuccess: (item) => getNotificationsForAllReservations(context, item.profile),
              orElse: () {
                return emptyLargeListView(context, 10, 300, Axis.vertical, kIsWeb);
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

  Widget getReservationByFilterType(BuildContext context, ReservationFilter filter, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    switch (filter.filterType) {
      case ReservationTypeFilter.comingUp:
        return Column(
          children: [
            getConfirmedCurrentReservations(context, currentUser, _currentFilterModel, notifications),
            // getReservationsByFilter(context, currentUser, 'Happening Now!', [ReservationSlotState.current], null, notifications),
            // getReservationsByFilter(context, currentUser, 'Coming Up', [ReservationSlotState.confirmed], null, notifications),
          ]
        );
      case ReservationTypeFilter.completed:
        return getCompletedReservations(context, currentUser, notifications);
      case ReservationTypeFilter.hosting:
        return getReservationsByFilter(context, currentUser, 'Hosting', _currentFilterModel, filter, notifications);
        /// show completed as separate tab with show more option which switches to completed tab
      case ReservationTypeFilter.posted:
        return getReservationsByFilter(context, currentUser, 'Posted', _currentFilterModel, filter, notifications);
        /// show completed as separate tab with show more option which switches to completed tab
      case ReservationTypeFilter.draft:
         return getReservationsByFilter(context, currentUser, 'Draft', _currentFilterModel, filter, notifications);
      case ReservationTypeFilter.attending:
        return Column(
          children: [
            if ((_currentFilterModel?.contactStatusOptions ?? []).contains(ContactStatus.requested)) getAttendingRequestedReservation(context, currentUser, notifications),
            if ((_currentFilterModel?.contactStatusOptions ?? []).contains(ContactStatus.joined)) getAttendingJoinedReservations(context, currentUser, notifications),
            if ((_currentFilterModel?.contactStatusOptions ?? []).contains(ContactStatus.invited)) getAttendingInvitedReservations(context, currentUser, notifications),
        ]
      );
    }
  }

  Widget listOfReservations(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
    return Column(
      children: [
        ReservationFilterHeader(
          initialFilterModel: _currentFilterModel,
          filterItem: _reservationFilters.firstWhere((e) => _currentFilterModel?.filterType == e.filterType),
          model: widget.model,
          didUpdateFilterModel: (filterModel) {
            setState(() {
              isLoading = true;

              if (_currentFilterModel != null && filterModel != null) {
                final previousFilters = _currentFilterModel!.filterType;
                final newFilters = filterModel.filterType;

                bool hasFilterChanged = previousFilters == newFilters && _currentFilterModel != filterModel;
              
                if (hasFilterChanged) {
                  // Clear paging controller and fetch new data
                 // **Fix: Create a new PagingController instance**
                  ReservationCoreHelper.pagingController?.dispose();
                  ReservationCoreHelper.pagingController = PagingController(firstPageKey: 0);

                  // Add new listener
                  ReservationCoreHelper.pagingController?.addPageRequestListener((pageKey) {
                    ReservationCoreHelper.fetchByCompleted(
                      context,
                      [ReservationSlotState.completed],
                      true,
                      _currentFilterModel?.privateReservationsOnly,
                      _currentFilterModel?.isReverseSorted,
                      facade.FirebaseChatCore.instance.firebaseUser!.uid,
                      pageKey,
                    );
                  });
                  // Manually trigger first page fetch

                }
              }

              _currentFilterModel = filterModel;

              Future.delayed(const Duration(milliseconds: 600), () {
                setState(() {
                  isLoading = false;
                });
              });
            });
          }
        ),


        const SizedBox(height: 15),
        if (isLoading == true) Expanded(child: emptyLargeListView(context, 10, 300, Axis.vertical, kIsWeb)),
        if (isLoading == false) Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SingleChildScrollView(
              child: getReservationByFilterType(
                context, 
                _reservationFilters.firstWhere((e) => _currentFilterModel?.filterType == e.filterType), 
                currentUser,
                 notifications
              )
            ),
          ),
        ),
        
      ],
    );
  }


  Widget getReservationsByFilter(BuildContext context, UserProfileModel currentUser, String title, ReservationFilterObject? filterItem, ReservationFilter fixedFilter, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations(fixedFilter.reservationHostingType ?? [], currentUser, false, null, filterItem?.filterWithStartDate, filterItem?.filterWithEndDate, null, filterItem?.privateReservationsOnly, filterItem?.isReverseSorted, fixedFilter.formStatus)),
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
                    'Nothing Yet!',
                    'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                    'Start Booking',
                    didTapStartButton: () {

                    }),

                    if (e.item.isNotEmpty) Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: widget.model.disabledTextColor.withOpacity(0.23),
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
                                titleText: title,
                                isPagingView: false,
                                selectedReservationId: widget.initialReservationId,
                                currentUserId: currentUser.userId,
                                didSelectReservation: (item) {
                                  if (fixedFilter.filterType == ReservationTypeFilter.draft) {
                                    didSelectCreateNewActivity(
                                      context,
                                      widget.model,
                                      item.reservation,
                                      item.listing,
                                      didSaveActivity: (res) {
                                        print('saveee');
                                        setState(() {
                                          isLoading = true;
                                        });

                                        Future.delayed(const Duration(milliseconds: 600), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      },
                                      didPublishActivity: (res) {
                                        print('saveee');
                                        setState(() {
                                          isLoading = true;
                                        });

                                        Future.delayed(const Duration(milliseconds: 600), () {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        });
                                      },
                                    );
                                  } else if (item.listing != null && item.reservation != null) {
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
                'Start a Pop-Up Shop in an Alley or Rent out a basement for your next underground Rave.',
                'Start Booking',
                didTapStartButton: () {

              }),
          );
        }
      )
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


  Widget getAttendingRequestedReservation(BuildContext context, UserProfileModel currentUser, List<AccountNotificationItem> notifications) {
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

  Widget getConfirmedCurrentReservations(BuildContext context, UserProfileModel currentUser, ReservationFilterObject? filterItem, List<AccountNotificationItem> notifications) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.confirmed, ReservationSlotState.current], currentUser, false, null, filterItem?.filterWithStartDate, filterItem?.filterWithEndDate, null, filterItem?.privateReservationsOnly, filterItem?.isReverseSorted, null)),
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
                        titleText: 'Coming-Up & Current',
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

                      if (e.item.isEmpty) Column(
                        children: [
                          getAttendingRequestedReservation(
                            context,
                            currentUser,
                            notifications
                          ),
                          getAttendingJoinedReservations(
                            context,
                            currentUser,
                            notifications
                          ),
                        ],
                      ),


                  ]
                );
              },
            orElse: () => Column(
              children: [
                Column(
                  children: [
                    getAttendingRequestedReservation(
                      context,
                      currentUser,
                      notifications
                    ),
                    getAttendingJoinedReservations(
                      context,
                      currentUser,
                      notifications
                    ),
                  ],
                ),
              ],
            )
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
                 return emptyLargeListView(context, 10, 300, Axis.vertical, kIsWeb);
               },
               newPageProgressIndicatorBuilder: (context) {
                 return Padding(
                   padding: const EdgeInsets.symmetric(vertical: 28.0),
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
                           } else {
                            
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