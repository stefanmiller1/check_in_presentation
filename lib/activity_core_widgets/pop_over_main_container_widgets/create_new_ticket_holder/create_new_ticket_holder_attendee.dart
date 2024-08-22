part of check_in_presentation;

class ReservationCreateTicketAttendee extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  // final Function() didSelectBack;

  const ReservationCreateTicketAttendee({super.key, required this.model, required this.reservation, required this.activityForm, required this.resOwner});

  @override
  State<ReservationCreateTicketAttendee> createState() => _ReservationCreateTicketAttendeeState();
}

class _ReservationCreateTicketAttendeeState extends State<ReservationCreateTicketAttendee> {


  NewAttendeeStepsMarker currentMarkerItem = NewAttendeeStepsMarker.getStarted;
  late bool isLoading = false;

  List<NewAttendeeContainerModel> attendeeMainContainer(BuildContext context, UserProfileModel? user, AttendeeFormState state) => [
    NewAttendeeContainerModel(
      markerItem: NewAttendeeStepsMarker.getStarted,
      childWidget: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Flexible(
                      child: Center(
                        child: Container(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 if (user != null) getTicketOptionsForActivity(
                                    context,
                                    widget.model,
                                    widget.reservation,
                                    widget.activityForm,
                                    state.attendeeItem.ticketItems ?? [],
                                    false,
                                    true,
                                    didDecreaseAmount: (ticket) {
                                      List<TicketItem> newTickets = [];
                                      newTickets.addAll(state.attendeeItem.ticketItems ?? []);
                                      TicketItem lastTicketSelected = newTickets.lastWhere((element) => element.selectedTicketId == ticket.ticketId);
                                      newTickets.remove(lastTicketSelected);
                                      setState(() {
                                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateSelectedTicketOption(newTickets));
                                      });
                                    },
                                    didIncreaseAmount: (ticket) {
                                      List<TicketItem> newTickets = [];
                                      newTickets.addAll(state.attendeeItem.ticketItems ?? []);
                                      newTickets.add(TicketItem(
                                        ticketId: UniqueId(),
                                        selectedTicketId: ticket.ticketId,
                                        ticketOwner: user.userId,
                                        isOnHold: true,
                                        createdAt: DateTime.now(),
                                        expiresAt: DateTime.now().add(const Duration(minutes: 3)).millisecondsSinceEpoch,
                                        redeemed: false,
                                        selectedTicketFee: ticket.ticketFee ?? 0,
                                        selectedTicketTitle: ticket.ticketTitle,
                                        selectedReservationSlot: ticket.reservationSlot,
                                        selectedReservationTimeSlot: ticket.reservationTimeSlot,
                                      ));
                                      setState(() {
                                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateSelectedTicketOption(newTickets));
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Divider(thickness: 0.5, color: widget.model.disabledTextColor),
                                  ),
                                ]
                              )
                            ),
                          )
                        ),
                      ],
                    ),
                  ),


                  if ((state.attendeeItem.ticketItems ?? []).isNotEmpty) Row(
                      children: [
                        Flexible(
                            child: Center(
                                child: Container(
                                    constraints: const BoxConstraints(maxWidth: 700),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: getTicketPricingDetails(widget.model, state.attendeeItem.ticketItems ?? [], widget.activityForm.rulesService.currency))
                          )
                        )
                      )
                    ]
                  ),

                  if ((state.attendeeItem.ticketItems ?? []).isNotEmpty) Row(
                      children: [
                        Flexible(
                          child: Center(
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 700),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ticketCancellationDetails(
                                      context,
                                      widget.model,
                                      state.attendeeItem.ticketItems ?? [],
                                      widget.activityForm
                              ),
                            ),
                          )
                        ),
                      )
                    ]
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
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
              }
            )
          ),

  ];

  void _handleCreateCheckOutForWeb(BuildContext context, UserProfileModel currentUser) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
      // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        width: 600,
                        height: 750,
                        child: WebCheckOutPaymentWidget(
                            model: widget.model,
                            currentUser: currentUser,
                            ownerUser: widget.resOwner,
                            reservation: widget.reservation,
                            amount: completeTotalPriceForCheckoutFormat(getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []) +
                                getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOBuyerPercentageFee +
                                getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOTaxesFee, widget.activityForm.rulesService.currency),
                            currency: widget.activityForm.rulesService.currency,
                            description: 'Ticket to be sold and to be made redeemable for a specific Reservation',
                            didFinishPayment: (e) {

                              context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingTicketAttendeeWeb(e));
                              // widget.didSelectBack();
                            },
                            didPressFinished: () {
                              Navigator.of(context).pop();
                            },
                          )
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
                attendeeType: AttendeeType.tickets,
                paymentIntentId: '',
                contactStatus: ContactStatus.joined,
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



              state.authPaymentFailureOrSuccessOption.fold(() {},
                (either) => either.fold(
                    (failure) {
                      final snackBar = SnackBar(
                          backgroundColor: widget.model.webBackgroundColor,
                          content: failure.maybeMap(
                            paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                            orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  (_) => null
                )
              );


              /// did submit ticket - verify ticket limit has not been reached for all selected tickets
              state.authFailureOrSuccessPaymentOption.fold(() {},
                  (either) => either.fold((failure) {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.webBackgroundColor,
                        content: failure.maybeMap(
                          ticketsNoLongerAvailable: (e) => Text('Sorry, the tickets you selected are no longer available'),
                          ticketLimitReached: (e) => (e.failedTicket != null && e.failedTicket!.reservationTimeSlot != null) ? Text('Your ${e.failedTicket!.ticketTitle ?? 'Ticket'} for ${DateFormat.jm().format(e.failedTicket!.reservationTimeSlot!.slotRange.start)} - ${DateFormat.jm().format(e.failedTicket!.reservationTimeSlot!.slotRange.end)} only has ${e.ticketsRemaining ?? 0} remaining', style: TextStyle(color: widget.model.disabledTextColor))
                           : Text('Sorry, There are not enough tickets left. Only ${e.ticketsRemaining ?? 0} Left', style: TextStyle(color: widget.model.disabledTextColor)),
                          attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                          attendeePermissionDenied: (e) => Text('Sorry, you dont have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                          orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, (currentUser) {

                    /// save on hold tickets - show 3 minute countdown
                    context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.createTicketsOnHold());

                    if (kIsWeb) {
                      _handleCreateCheckOutForWeb(context, currentUser);
                    } else {
                      /// TODO: - hold attendee tickets
                      context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingTicketAttendee(currentUser,
                          completeTotalPriceForCheckoutFormat(getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []) +
                              getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOBuyerPercentageFee +
                              getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOTaxesFee, widget.activityForm.rulesService.currency),
                          widget.activityForm.rulesService.currency,
                          null));
                    }
                  }
                )
              );

              /// finished successful
              state.authFailureOrSuccessOption.fold(() {},
                      (either) => either.fold((failure) {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.webBackgroundColor,
                        content: failure.maybeMap(
                          ticketsNoLongerAvailable: (e) => Text('Sorry, the tickets you selected are no longer available'),
                          ticketLimitReached: (e) => Text('Sorry, There are not enough tickets left.', style: TextStyle(color: widget.model.disabledTextColor)),
                          attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                          attendeePermissionDenied: (e) => Text('Sorry, you dont have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                          orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }, (_) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // widget.didSelectBack();
                    Navigator.of(context).pop(context);
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
                    title: Text('Activity Tickets', style: TextStyle(color: widget.model.accentColor)),
                    centerTitle: true,
                    actions: [
                      if (currentMarkerItem != NewAttendeeStepsMarker.joinComplete || currentMarkerItem != NewAttendeeStepsMarker.requestToJoinComplete) Visibility(
                        visible: state.isSubmitting == false,
                          child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.cancel_outlined, color: widget.model.accentColor),
                          padding: EdgeInsets.only(right: 18),
                        ),
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

                  Padding(
                      padding: const EdgeInsets.all(18),
                      child: retrieveAuthenticationState(context, state)
                  ),

                  if (state.isSubmitting) SizedBox(
                      height: 220,
                      child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                  ),

                ]
              )
            )
          );
        }
      )
    );
  }


  Widget getTicketOptionsForActivity(
      BuildContext context,
      DashboardModel model,
      ReservationItem reservation,
      ActivityManagerForm activityForm,
      List<TicketItem> currentTickets,
      bool showFindTicket,
      bool showTicketAmountSelector, {
        required Function(ActivityTicketOption) didDecreaseAmount,
        required Function(ActivityTicketOption) didIncreaseAmount,
      }) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text('Activity Tickets', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Visibility(
            visible: activityForm.activityAttendance.isTicketFixed == true,
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: getTicketWithCounterForEntireActivity(
                      context,
                      model,
                      reservation,
                      activityForm,
                      activityForm.activityAttendance.defaultActivityTickets ?? ActivityTicketOption.empty(),
                      currentTickets,
                      true,
                      didDecreaseAmount: (ticket) {
                        didDecreaseAmount(ticket);
                      },
                      didIncreaseAmount: (ticket) {
                        didIncreaseAmount(ticket);
                      }
              ),
            )
          )
        ),

        Visibility(
            visible: activityForm.activityAttendance.isTicketPerSlotBased == false && activityForm.activityAttendance.isTicketFixed == false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((activityForm.activityAttendance.activityTickets?.length ?? 0) == 1) Text('${activityForm.activityAttendance.activityTickets?.length ?? 0} Event', style: TextStyle(color: model.disabledTextColor)),
                    if ((activityForm.activityAttendance.activityTickets?.length ?? 0) > 1) Text('${activityForm.activityAttendance.activityTickets?.length ?? 0} Events', style: TextStyle(color: model.disabledTextColor)),
                    ...activityForm.activityAttendance.activityTickets?.map(
                            (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: getTicketWithCounterForDayBasedActivity(
                              context,
                              model,
                              reservation,
                              activityForm,
                              e,
                              currentTickets,
                              true,
                              didDecreaseAmount: (ticket) {
                                didDecreaseAmount(ticket);
                              },
                              didIncreaseAmount: (ticket) {
                                didIncreaseAmount(ticket);
                      }
                    ),
                  )
                ).toList() ?? []
              ]
            ),
          )
        ),

        Visibility(
            visible: activityForm.activityAttendance.isTicketPerSlotBased == true && activityForm.activityAttendance.isTicketFixed == false,
            child: Column(
                children: activityForm.activityAttendance.activityTickets?.map(
                        (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: getTicketWithCounterForSlotBasedActivity(
                          context,
                          model,
                          reservation,
                          activityForm,
                          e,
                          currentTickets,
                          true,
                          didDecreaseAmount: (ticket) {
                            didDecreaseAmount(ticket);
                          },
                          didIncreaseAmount: (ticket) {
                            didIncreaseAmount(ticket);
                          }
                      ),
                    )
                ).toList() ?? []
            )
        ),
      ],
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

                    ClipRRect(
                        child: BackdropFilter(
                          filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            height: 110,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey.shade200.withOpacity(0.5),
                            child: footerWidgetForNewAttendee(
                              context,
                              widget.model,
                              false,
                              currentMarkerItem,
                              null,
                              null,
                              widget.activityForm,
                              state,
                              null,
                              attendeeMainContainer(context, null, state).last.markerItem == currentMarkerItem,
                              didSelectBack: () {

                                setState(() {
                                  // check if [currentMarkerItem] index is equal to 0 in array
                                  final currentIndex = attendeeMainContainer(context, null, state).indexWhere((element) => element.markerItem == currentMarkerItem);
                                  if (currentIndex == 0) {
                                    Navigator.of(context).pop();
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

                                  if (currentIndex == (attendeeMainContainer(context, null, state).length - 1)) {
                                    if (kIsWeb) {
                                      context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
                                    }
                                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.checkTicketLimits(item.profile));

                                  } else {

                                    final NewAttendeeStepsMarker nextIndexItem = attendeeMainContainer(context, null, state)[currentIndex + 1].markerItem;
                                    currentMarkerItem = nextIndexItem;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
              orElse: () => GetLoginSignUpWidget(showFullScreen: false, model: widget.model, didLoginSuccess: () {  },)
          );
        },
      ),
    );
  }

}