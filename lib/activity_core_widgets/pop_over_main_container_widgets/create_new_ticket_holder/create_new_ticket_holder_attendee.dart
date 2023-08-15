part of check_in_presentation;

class ReservationCreateTicketAttendee extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  final Function() didSelectBack;

  const ReservationCreateTicketAttendee({super.key, required this.model, required this.reservation, required this.activityForm, required this.didSelectBack, required this.currentUser, required this.resOwner});

  @override
  State<ReservationCreateTicketAttendee> createState() => _ReservationCreateTicketAttendeeState();
}

class _ReservationCreateTicketAttendeeState extends State<ReservationCreateTicketAttendee> {


  void _handleCreateCheckOutForWeb(BuildContext context, ) {
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
                            currentUser: widget.currentUser,
                            ownerUser: widget.resOwner,
                            reservation: widget.reservation,
                            amount: completeTotalPriceWithIntFormat(getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []) +
                                getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOReservationPercentageFee +
                                getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOTaxesFee, widget.activityForm.rulesService.currency),
                            currency: widget.activityForm.rulesService.currency,
                            didFinishPayment: (e) {
                              context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingTicketAttendeeWeb(e));
                              widget.didSelectBack();
                            }
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
            attendeeOwnerId: widget.currentUser.userId,
            reservationId: widget.reservation.reservationId,
            cost: '',
            paymentStatus: PaymentStatusType.noStatus,
            attendeeType: AttendeeType.tickets,
            paymentIntentId: '',
            contactStatus: ContactStatus.pending,
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

              /// did submit ticket - verify ticket limit has not been reached for all selected tickets
              state.authFailureOrSuccessTicketOption.fold(() {},
                  (either) => either.fold((failure) {
                    final snackBar = SnackBar(
                        backgroundColor: widget.model.webBackgroundColor,
                        content: failure.maybeMap(
                          ticketsNoLongerAvailable: (e) => Text('Sorry, the tickets you selected are no longer available'),
                          ticketLimitReached: (e) => e.failedTicket != null ? Text('Your ${e.failedTicket!.ticketTitle ?? 'Ticket'} for ${DateFormat.jm().format(e.failedTicket!.reservationTimeSlot!.slotRange.start)} - ${DateFormat.jm().format(e.failedTicket!.reservationTimeSlot!.slotRange.end)} only has ${e.ticketsRemaining ?? 0} remaining', style: TextStyle(color: widget.model.disabledTextColor))
                           : Text('Sorry, There are not enough tickets left.', style: TextStyle(color: widget.model.disabledTextColor)),
                          attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                          attendeePermissionDenied: (e) => Text('Sorry, you dont have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                          orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                        ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }, (_) {

                    print('success');
                    // if (kIsWeb) {
                    //   _handleCreateCheckOutForWeb(context);
                    // } else {
                    //   /// TODO: - hold attendee tickets
                    //   context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingTicketAttendee(widget.currentUser,
                    //       (getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []) +
                    //           getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOReservationPercentageFee +
                    //           getTicketTotalPriceDouble(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [])*CICOTaxesFee).toString(),
                    //       widget.activityForm.rulesService.currency,
                    //       null));
                    // }
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

                  }, (_) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    widget.didSelectBack();
                    // Navigator.of(context).pop(context);
                  }));

              ///

            },
            buildWhen: (p,c) => p.isSubmitting != c.isSubmitting,
            builder: (context, state) {

              print('timeee check... ${DateTime.now().add(Duration(minutes: 3)).millisecondsSinceEpoch}');

              return Stack(
                children: [
                  Container(
                    color: widget.model.webBackgroundColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height
                  ),

                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Center(
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 700),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      getTicketOptionsForActivity(
                                        context,
                                        widget.model,
                                        widget.reservation,
                                        widget.activityForm,
                                        context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [],
                                        false,
                                        true,
                                        didDecreaseAmount: (ticket) {
                                          List<TicketItem> newTickets = [];
                                          newTickets.addAll(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []);
                                          TicketItem lastTicketSelected = newTickets.lastWhere((element) => element.selectedTicketId == ticket.ticketId);
                                          newTickets.remove(lastTicketSelected);
                                          setState(() {
                                            context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateSelectedTicketOption(newTickets));
                                          });
                                        },
                                        didIncreaseAmount: (ticket) {
                                          List<TicketItem> newTickets = [];
                                          newTickets.addAll(context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []);
                                          newTickets.add(TicketItem(
                                            ticketId: UniqueId(),
                                            selectedTicketId: ticket.ticketId,
                                            ticketOwner: widget.currentUser.userId,
                                            isOnHold: true,
                                            createdAt: DateTime.now(),
                                            expiresAt: DateTime.now().add(Duration(minutes: 3)).millisecondsSinceEpoch,
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


                        if ((context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []).isNotEmpty) Row(
                          children: [
                            Flexible(
                              child: Center(
                                child: Container(
                                  constraints: const BoxConstraints(maxWidth: 700),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: getTicketPricingDetails(widget.model, context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [], widget.activityForm.rulesService.currency))
                                )
                              )
                            )
                          ]
                        ),

                        if ((context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []).isNotEmpty) Row(
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
                                        context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [],
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

                  Positioned(
                    bottom: 0,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          height: 110,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey.shade200.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: retrieveAuthenticationState(
                          context,
                        ),
                      ),
                    ]
                  )
            ]
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

  Widget retrieveAuthenticationState(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadProfileFailure: (_) => GetLoginSignUpWidget(model: widget.model),
              loadUserProfileSuccess: (item) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (!(context.read<AttendeeFormBloc>().state.isSubmitting)) IconButton(
                            onPressed: () {
                              setState(() {
                                widget.didSelectBack();
                              });
                            },
                            icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor)
                        ),
                        if ((context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []).isNotEmpty) getFooterTotalTicketPricing(widget.model, context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? [], widget.activityForm.rulesService.currency),
                      ]
                    ),
                    if (!(context.read<AttendeeFormBloc>().state.isSubmitting)) InkWell(
                      onTap: () {
                        if ((context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []).isNotEmpty) {
                          context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.checkTicketLimits());
                        } else {
                          final snackBar = SnackBar(
                              elevation: 4,
                              backgroundColor: widget.model.paletteColor,
                              content: Text('Pick Your Tickets!', style: TextStyle(color: widget.model.webBackgroundColor))
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Container(
                        height: 60,
                        // width: 200,
                        decoration: BoxDecoration(
                          color: ((context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []).isNotEmpty) ? widget.model.paletteColor : Colors.transparent,
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                          border: Border.all(color: widget.model.paletteColor)
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Confirm Tickets', style: TextStyle(color: ((context.read<AttendeeFormBloc>().state.attendeeItem.ticketItems ?? []).isNotEmpty) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                          ),
                        ),
                      ),
                    ),

                    if (context.read<AttendeeFormBloc>().state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor, radius: 8)
                  ],
                );
              },
              orElse: () => GetLoginSignUpWidget(model: widget.model)
          );
        },
      ),
    );
  }

}