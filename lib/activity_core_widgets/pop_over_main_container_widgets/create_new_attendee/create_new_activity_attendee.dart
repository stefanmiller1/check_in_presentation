part of check_in_presentation;

class ReservationCreateNewAttendee extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  final bool isFromInvite;

  const ReservationCreateNewAttendee({super.key, required this.model, required this.reservation, required this.resOwner, required this.activityForm, required this.isFromInvite});

  @override
  State<ReservationCreateNewAttendee> createState() => _ReservationCreateNewAttendeeState();
}


class _ReservationCreateNewAttendeeState extends State<ReservationCreateNewAttendee> {

  /// new attendee main container
  NewAttendeeStepsMarker currentMarkerItem = NewAttendeeStepsMarker.addActivityCustomRules;

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
    if (activityHasCustomRules(widget.activityForm)) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.addActivityCustomRules,
        childWidget: customRulesToAdd(
            context,
            widget.model,
            state.attendeeItem.customFieldRuleSetting ?? [],
            didUpdateCustomRule: (selectedRule, currentRule) {
              final List<CustomRuleOption> currentRules = [];
              currentRules.addAll(state.attendeeItem.customFieldRuleSetting ?? []);

              final int index = currentRules.indexWhere(
                      (element) => element.ruleId == currentRule.ruleId);
              currentRules.replaceRange(index, index + 1, [selectedRule]);

              setState(() {
                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateCustomRules(currentRules));
              });
            })),
    if (widget.activityForm.rulesService.accessVisibilitySetting.isReviewRequired == true) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.requestToJoinComplete,
        childWidget: requestToJoinCompleted(
          context,
          widget.model,
          'For this activity you will have to send the host a request to join. You\'ll be notified when the host has accepted your request!',
          didSelectRequestToJoin: () {
            if (kIsWeb) {
              context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
            }
            if (user != null) context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(user, '', '', ''));
        }
      )
    ),
    if (widget.activityForm.rulesService.accessVisibilitySetting.isReviewRequired == false) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.joinComplete,
        childWidget: newAttendeeJoinCompleted(
            context,
            widget.model,
            didSelectComplete: () {
              context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
              if (user != null) context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(user, '', '', ''));
        }
      )
    ),
  ];


  @override
  void initState() {
    currentMarkerItem = getInitialContainerForNewAttendee(widget.activityForm);
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
            attendeeType: AttendeeType.free,
            paymentIntentId: '',
            contactStatus: (widget.activityForm.rulesService.accessVisibilitySetting.isReviewRequired == true) ? ContactStatus.requested : ContactStatus.joined,
            customFieldRuleSetting: widget.activityForm.rulesService.customFieldRuleSetting,
            checkInSetting: widget.activityForm.rulesService.checkInSetting,
            classesInstructorProfile: ClassesInstructorProfile.empty(),
            eventMerchantVendorProfile: EventMerchantVendorProfile.empty(),
            dateCreated: DateTime.now())
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
                    content: Text('You\'re In', style: TextStyle(color: widget.model.webBackgroundColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  if (widget.isFromInvite == false) {
                    Navigator.of(context).pop();
                  }
              }));

        },
        buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
        builder: (contexts, state) {

          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
              elevation: 0,
              backgroundColor: widget.model.paletteColor,
              automaticallyImplyLeading: false,
              title: Text('Join Activity', style: TextStyle(color: widget.model.accentColor)),
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
              alignment: Alignment.bottomCenter,
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

                ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.shade200.withOpacity(0.5),
                        child: footerWidgetForNewAttendee(
                            context,
                            widget.model,
                            currentMarkerItem,
                            widget.activityForm,
                            state,
                            attendeeMainContainer(context, null, state).last.markerItem == currentMarkerItem,
                            didSelectBack: () {

                              setState(() {
                                // check if [currentMarkerItem] index is equal to 0 in array
                                final currentIndex = attendeeMainContainer(context, null, state).indexWhere((element) => element.markerItem == currentMarkerItem);
                                if (currentIndex == 0) {
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
                                } else {
                                  /// get item at index - 1
                                  final NewAttendeeStepsMarker previousIndexItem = attendeeMainContainer(context, null, state)[currentIndex - 1].markerItem;
                                  currentMarkerItem = previousIndexItem;
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


                ]
              )
            )
          );
        },
      )
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, AttendeeFormState state) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) {
                return CreateNewMain(
                    child: attendeeMainContainer(context, item.profile, state).firstWhere((element) => element.markerItem == currentMarkerItem).childWidget
                );
              },
              orElse: () => GetLoginSignUpWidget(model: widget.model)
          );
        },
      ),
    );
  }
}