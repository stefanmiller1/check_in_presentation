part of check_in_presentation;

class ReservationRequestPartnershipAttendee extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  final bool isFromInvite;

  const ReservationRequestPartnershipAttendee({super.key, required this.model, required this.reservation, required this.resOwner, required this.activityForm, required this.isFromInvite});

  @override
  State<ReservationRequestPartnershipAttendee> createState() => _ReservationRequestPartnershipAttendeeState();
}

class _ReservationRequestPartnershipAttendeeState extends State<ReservationRequestPartnershipAttendee> {

  NewAttendeeStepsMarker currentMarkerItem = NewAttendeeStepsMarker.requestToJoinComplete;
  late bool isLoading = false;

  List<NewAttendeeContainerModel> attendeeMainContainer(BuildContext context, UserProfileModel? user, AttendeeFormState state) => [
    if (activityHasRules(widget.activityForm)) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.addActivityRules,
        childWidget: rulesToAdd(
            context,
            widget.model,
            widget.activityForm.rulesService.ruleOption.getOrCrash(),
            widget.resOwner
      )
    ),
    /// overview of partnership options? (organization...fundraising...charity...who you are and why they should want to partner with you?)
    NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        childWidget: Container()
    ),
    NewAttendeeContainerModel(
      markerItem: NewAttendeeStepsMarker.requestToJoinComplete,
      childWidget: requestToJoinCompleted(
          context,
          widget.model,
          'In order to become a partner you will have to send the host a request first. As a partner, the host and you will be able to collaborate together on this specific activity. You\'ll be notified when the host has accepted your request!',
          didSelectRequestToJoin: () {
            if (kIsWeb) {
            context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
            }
            if (user != null) context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(user, '', '', ''));
          }
      )
    )
  ];

  @override
  void initState() {
    currentMarkerItem = getInitialContainerForNewAffiliateAttendee(widget.activityForm);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(
        dart.optionOf(AttendeeItem(
            attendeeId: UniqueId(),
            attendeeOwnerId: UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
            reservationId: widget.reservation.reservationId,
            cost: '',
            paymentStatus: PaymentStatusType.noStatus,
            attendeeType: AttendeeType.partner,
            paymentIntentId: '',
            contactStatus: ContactStatus.requested,
            dateCreated: DateTime.now()
          )
        ),
        dart.optionOf(widget.reservation),
        dart.optionOf(widget.activityForm),
        dart.optionOf(widget.resOwner)
        )
      ),
      child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
        listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
        listener: (context, state) {

          /// finished successful
          state.authFailureOrSuccessOption.fold(() {},
                  (either) => either.fold((failure) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: failure.maybeMap(
                      attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                      attendeeLimitReached: (e) => Text('Sorry This Activity is Full', style: TextStyle(color: widget.model.disabledTextColor)),
                      attendeePermissionDenied: (e) => Text('Sorry, you don\'t have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                      orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                    )
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }, (_) {
                final snackBar = SnackBar(
                    elevation: 4,
                    backgroundColor: widget.model.paletteColor,
                    content: Text('Request Sent!', style: TextStyle(color: widget.model.webBackgroundColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (widget.isFromInvite == false) {
                  Navigator.of(context).pop();
                }
              }));


        },
    buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
      builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
              elevation: 0,
              backgroundColor: widget.model.paletteColor,
              automaticallyImplyLeading: false,
              title: Text('Request Partnership', style: TextStyle(color: widget.model.accentColor)),
              centerTitle: true,
              actions: [
              if (currentMarkerItem != NewAttendeeStepsMarker.joinComplete || currentMarkerItem != NewAttendeeStepsMarker.requestToJoinComplete) Visibility(
                visible: state.isSubmitting == false,
                  child: Visibility(
                    visible: widget.isFromInvite == false,
                      child: IconButton(
                      onPressed: () {
                      Navigator.of(context).pop();
                      },
                        icon: Icon(Icons.cancel_outlined, color: widget.model.accentColor),
                      padding: EdgeInsets.only(right: 18),
                    ),
                  )
                )
              ],
            ),
            body: Stack(
            children: [

                Container(
                  color: widget.model.webBackgroundColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height
                ),

                retrieveAuthenticationState(context, state),

                if (state.isSubmitting) SizedBox(
                  height: 220,
                  child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                ),

                ],
              )
            )
          );
        }
      )
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, AttendeeFormState state) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),

                    if (state.isSubmitting == false) CreateNewMain(
                        model: widget.model,
                        isLoading: isLoading,
                        isPreviewer: false,
                        child: attendeeMainContainer(context, item.profile, state).map((e) => e.childWidget).toList()
                    ),

                    if (currentMarkerItem != NewAttendeeStepsMarker.requestToJoinComplete) ClipRRect(
                        child: BackdropFilter(
                            filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade200.withOpacity(0.5),
                              child: footerWidgetForNewAttendee(
                                context,
                                widget.model,
                                false,
                                currentMarkerItem,
                                null,
                                null,
                                null,
                                widget.activityForm,
                                state,
                                null,
                                attendeeMainContainer(context, null, state).last.markerItem == currentMarkerItem,
                                didSelectBack: () {

                                  setState(() {
                                    if (widget.isFromInvite == true) {
                                      final snackBar = SnackBar(
                                          elevation: 4,
                                          backgroundColor: widget.model.paletteColor,
                                          content: Text('To Accept your Invite, please fill out the info above.', style: TextStyle(color: widget.model.webBackgroundColor))
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                didSelectNext: () {

                                  setState(() {
                                    // check current index in array
                                    final currentIndex = attendeeMainContainer(context, null, state).indexWhere((element) => element.markerItem == currentMarkerItem);
                                    /// get item at index + 1
                                    final NewAttendeeStepsMarker nextIndexItem = attendeeMainContainer(context, null, state)[currentIndex + 1].markerItem;
                                    currentMarkerItem = nextIndexItem;

                                  });
                                },
                              ),
                            )
                        )
                     )

                  ],
                );
              },
              orElse: () => GetLoginSignUpWidget(showFullScreen: true, model: widget.model, didLoginSuccess: () {  },)
          );
        },
      ),
    );
  }
}