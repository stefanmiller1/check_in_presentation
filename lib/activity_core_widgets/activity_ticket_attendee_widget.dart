part of check_in_presentation;

Widget mainContainerTicket({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() didSelectTicketFixed, required Function() didSelectTicketPerSlotBased, required ReservationSlotItem? selectedReservationSlot, required ReservationTimeFeeSlotItem? selectedResTimeSlot, required Function(ReservationSlotItem) didSelectRes, required Function(ReservationSlotItem, ReservationTimeFeeSlotItem) didSelectSlotRes, required TextEditingController firstTextEditingController, required Function(String) didSelectFirstLabel, required TextEditingController secondTextEditingController, required Function(String) didSelectSecondLabel}) {
  return Column(
    children: [

      const SizedBox(height: 25),

      Text('${AppLocalizations.of(context)!.activityAttendanceTypeGenerate} ${AppLocalizations.of(context)!.activityAttendanceTypeTickets}', style: TextStyle(
          color: model.disabledTextColor,
          fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 10),
      Text(AppLocalizations.of(context)!.activityAttendanceTypeGenerateHint, style: TextStyle(
          color: model.paletteColor)),
      const SizedBox(height: 50),

      Container(
        width: 675,
        child: Row(
          children: [
            Expanded(child: Text('A Ticket that will cover the entire Reservation.', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor))),
            SizedBox(width: 10),
            FlutterSwitch(
              width: 60,
              inactiveColor: model.accentColor,
              activeColor: model.paletteColor,
              value: state.activitySettingsForm.activityAttendance.isTicketFixed ?? false,
              onToggle: (value) {
                didSelectTicketFixed();
              },
            )
          ],
        ),
      ),
      const SizedBox(height: 8),
      Visibility(
        visible: state.activitySettingsForm.activityAttendance.isTicketFixed == false,
          child: Container(
            width: 675,
            child: Row(
              children: [
                Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text('A Ticket for each Reservation Slot.', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.disabledTextColor)),
                      Text('Otherwise, tickets will be based on a per day basis.', style: TextStyle(color: model.disabledTextColor)),
                  ],
                  )
                ),

                SizedBox(width: 10),
                FlutterSwitch(
                  width: 60,
                  inactiveColor: model.accentColor,
                  activeColor: model.paletteColor,
                  value: state.activitySettingsForm.activityAttendance.isTicketPerSlotBased ?? false,
                  onToggle: (value) {
                    didSelectTicketPerSlotBased();
                },
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),

      Visibility(
          visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketFixed == false,
          child: Column(
            children: [
              const SizedBox(height: 15),
              reservationSelectionHeader(
                  context,
                  model,
                  context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketPerSlotBased ?? false,
                  true,
                  selectedReservationSlot,
                  selectedResTimeSlot,
                  getGroupBySpaceBookings(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem),
                  didSelectRes: (res) {
                    didSelectRes(res);
                  },
                  didSelectResTime: (res, slot) {
                    didSelectSlotRes(res, slot);
              }
            )
          ],
        )
      ),


      const SizedBox(height: 25),
      Container(
        width: 675,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('How Much Will a Ticket Cost?', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Text('${NumberFormat.simpleCurrency(locale: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.currency).currencySymbol}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
          SizedBox(width: 16),
          Container(
            width: 160,
            child: labelContainerForPricing(
                model,
                null,
                firstTextEditingController,
                hintLabel: 'Free',
                didUpdateLabel: (e) {
                  didSelectFirstLabel(e);
            }),
          ),
          const SizedBox(width: 5),
          Text('${NumberFormat.simpleCurrency(locale: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.currency).currencyName ?? ''}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
        ],
      ),

      const SizedBox(height: 25),
      Container(
        width: 675,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('How Many Tickets?', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ],
        ),
      ),

      Row(
          children: [
            Icon(Icons.airplane_ticket_outlined, color: model.paletteColor),
            const SizedBox(width: 5),
            Container(
              width: 160,
              child: labelContainerForPricing(
                  model,
                  null,
                  secondTextEditingController,
                  hintLabel: 'Number of Tickets',
                  didUpdateLabel: (e) {
                    didSelectSecondLabel(e);
              }),
            ),
            const SizedBox(width: 5),
            Text('Tickets', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
          ]
      )


    ]
  );
}

Widget getTicketForEntireActivity(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityForm, ActivityTicketOption e, bool showFindTickets, bool showTrailing, bool isSelected, {required Function(ActivityTicketOption) didSelectTicket}) {
  print('entire ticket $e');
  return Container(
    decoration: BoxDecoration(
        color: model.accentColor,
        borderRadius: BorderRadius.circular(25),
        border: isSelected ? Border.all(color: model.paletteColor, width: 1.5) : null
    ),
    child: Padding(
      padding: const EdgeInsets.all(9.0),
        child: IntrinsicHeight(
          child: InkWell(
          onTap: () {
            didSelectTicket(e);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.airplane_ticket_outlined, color: model.paletteColor),
              const SizedBox(width: 8),
              if (e.reservationSlot != null) Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat.MMM().format(e.reservationSlot?.selectedDate ?? DateTime.now()), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                  Text(DateFormat.d().format(e.reservationSlot?.selectedDate ?? DateTime.now()), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(width: 8),
              VerticalDivider(
                color: model.disabledTextColor,
                width: 1,
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// title for ticket
                            /// space option
                            Text('Ticket For Entire Event', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                            /// ticket fee
                            const SizedBox(height: 4),
                            Text((e.ticketFee != null) ? completeTotalPriceWithCurrency(e.ticketFee!.toDouble(), activityForm.rulesService.currency) : 'Free', style: TextStyle(color: model.disabledTextColor)),
                            const SizedBox(height: 4),
                            /// time slots
                            Wrap(
                                spacing: 4.0,
                                runSpacing: 4.0,
                                children: reservation.reservationSlotItem.map(
                                  (e) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: model.paletteColor.withOpacity(0.075),
                                              borderRadius: BorderRadius.all(Radius.circular(25),
                                              )
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Text('${DateFormat.MMMEd().format(e.selectedDate)} X ${e.selectedSlots.length}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                          )
                                      )
                                  )
                                ).toList() ?? []
                            ),
                          ],
                        ),
                      ),
                      if (showTrailing) Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (showFindTickets) Container(
                                decoration: BoxDecoration(
                                    color: model.paletteColor,
                                    borderRadius: BorderRadius.all(Radius.circular(25),
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Find Tickets', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1),
                                )
                            ),

                            Icon(Icons.keyboard_arrow_right_outlined, color: model.paletteColor)
                          ],
                        ),
                      )
                  ],
                )
              )
            ],
          ),
        )
      )
    )
  );
}


Widget getTicketWithCounterForEntireActivity(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityForm, ActivityTicketOption e, List<TicketItem> ticketCount, bool showSelector, {required Function(ActivityTicketOption) didIncreaseAmount, required Function(ActivityTicketOption) didDecreaseAmount}) {
  return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchNumberOfTicketsTakenStarted(reservation.reservationId.getOrCrash(), e.ticketId.getOrCrash())),
      child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                // loadOnHoldTicketsFailure: (_) => activityTicketsLoadingFailure(),
                loadNumberOfTicketsTakenSuccess: (count) => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          getTicketForEntireActivity(
                              context,
                              model,
                              reservation,
                              activityForm,
                              e,
                              false,
                              false,
                              false,
                              didSelectTicket: (ticket) {
                              }
                          ),
                          const SizedBox(height: 8),
                          Row(
                              children: [
                                Expanded(
                                  child: Text('Choose Your Number of Tickets', style: TextStyle(color: model.disabledTextColor))),
                                const SizedBox(width: 15),
                                Visibility(
                                    visible: (count.amount >= e.ticketQuantity),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: model.paletteColor,
                                            borderRadius: BorderRadius.all(Radius.circular(25),
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Sold Out', style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                        )
                                    )
                                ),
                                Visibility(
                                  visible: (count.amount < e.ticketQuantity && (count.amount.toDouble()/e.ticketQuantity.toDouble() >= 0.85)),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: model.paletteColor,
                                          borderRadius: BorderRadius.all(Radius.circular(25),
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Selling Out', style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                      )
                                  ),
                                ),
                              ]
                          )
                        ],
                      ),
                    ),
                    if (showSelector) amountSelector(
                        model,
                        (count.amount >= e.ticketQuantity),
                        ticketCount,
                        e,
                        didDecreaseAmount: didDecreaseAmount,
                        didIncreaseAmount: didIncreaseAmount
                    )
                  ],
                ),
                orElse: () => getLoadingTicketItem(context, model),
            );
          }
      )
  );
}


Widget getTicketForDayBasedActivity(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, ActivityTicketOption e, bool showFindTickets, bool showTrailing, bool isSelected, {required Function(ActivityTicketOption) didSelectTicket}) {
  return Container(
            decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(25),
              border: isSelected ? Border.all(color: model.paletteColor, width: 1.5) : null
            ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: IntrinsicHeight(
                  child: InkWell(
                  onTap: () {
                    didSelectTicket(e);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                    Icon(Icons.airplane_ticket_outlined, color: model.paletteColor),
                    const SizedBox(width: 8),
                    Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat.MMM().format(e.reservationSlot?.selectedDate ?? DateTime.now()), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                        Text(DateFormat.d().format(e.reservationSlot?.selectedDate ?? DateTime.now()), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    VerticalDivider(
                      color: model.disabledTextColor,
                      width: 1,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// title for ticket
                                /// space option
                                if (getSpaceTypeOptions(context).where((i) => i.uid == e.reservationSlot?.selectedSpaceId).isNotEmpty) Text(getSpaceTypeOptions(context).where((i) => i.uid == e.reservationSlot?.selectedSpaceId).first.spaceTitle, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                                /// ticket fee
                                const SizedBox(height: 4),
                                Text((e.ticketFee != null) ? completeTotalPriceWithCurrency(e.ticketFee!.toDouble(), activityForm.rulesService.currency) : 'Free', style: TextStyle(color: model.disabledTextColor)),
                                const SizedBox(height: 4),
                                /// time slots
                                Wrap(
                                    spacing: 4.0,
                                    runSpacing: 4.0,
                                    children: e.reservationSlot?.selectedSlots.map(
                                            (f) => Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: model.paletteColor.withOpacity(0.075),
                                                    borderRadius: BorderRadius.all(Radius.circular(25),
                                                    )
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(9.0),
                                                  child: Text('${DateFormat.jm().format(f.slotRange.start)} - ${DateFormat.jm().format(f.slotRange.end)}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                        )
                                      )
                                    )
                                  ).toList() ?? []
                                ),
                              ],
                            ),
                          ),
                        if (showTrailing) Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (showFindTickets) Container(
                                  decoration: BoxDecoration(
                                      color: model.paletteColor,
                                      borderRadius: BorderRadius.all(Radius.circular(25),
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Find Tickets', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1),
                                  )
                              ),

                              Icon(Icons.keyboard_arrow_right_outlined, color: model.paletteColor)
                            ],
                          ),
                        )
                  ],
                )
              )
            ],
          )
        )
      )
    )
  );
}

Widget getTicketWithCounterForDayBasedActivity(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityForm, ActivityTicketOption e, List<TicketItem> ticketCount, bool showAmount, {required Function(ActivityTicketOption) didIncreaseAmount, required Function(ActivityTicketOption) didDecreaseAmount}) {
  return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchNumberOfTicketsTakenStarted(reservation.reservationId.getOrCrash(), e.ticketId.getOrCrash())),
      child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              // loadOnHoldTicketsFailure: (_) => activityTicketsLoadingFailure(),
              loadNumberOfTicketsTakenSuccess: (count) => Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTicketForDayBasedActivity(
                            context,
                            model,
                            activityForm,
                            e,
                            false,
                            false,
                            false,
                            didSelectTicket: (ticket) {
                            }
                        ),
                        const SizedBox(height: 8),
                        Row(
                            children: [
                              Expanded(
                                child: Text('Choose Your Number of Tickets', style: TextStyle(color: model.disabledTextColor))),
                              const SizedBox(width: 15),
                              Visibility(
                                  visible: (count.amount >= e.ticketQuantity),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: model.paletteColor,
                                          borderRadius: BorderRadius.all(Radius.circular(25),
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Sold Out', style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                      )
                                  )
                              ),
                              Visibility(
                                visible: (count.amount < e.ticketQuantity && (count.amount.toDouble()/e.ticketQuantity.toDouble() >= 0.85)),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: model.paletteColor,
                                        borderRadius: BorderRadius.all(Radius.circular(25),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Selling Out', style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                    )
                                ),
                              ),
                            ]
                        )
                      ],
                    ),
                  ),
                  if (showAmount) amountSelector(
                      model,
                      (count.amount >= e.ticketQuantity),
                      ticketCount,
                      e,
                      didDecreaseAmount: didDecreaseAmount,
                      didIncreaseAmount: didIncreaseAmount
                  )
                ],
              ),
              orElse: () => getLoadingTicketItem(context, model),
            );
          }
      )
  );
}

Widget getTicketForSlotBasedActivity(BuildContext context, DashboardModel model, ActivityManagerForm activityForm, ActivityTicketOption e, bool showFindTickets, bool showTrailing, bool isSelected, {required Function(ActivityTicketOption) didSelectTicket}) {
  return Container(
        decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(25),
            border: isSelected ? Border.all(color: model.paletteColor, width: 1.5) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: IntrinsicHeight(
            child: InkWell(
              onTap: () {
                didSelectTicket(e);
              },
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.airplane_ticket_outlined, color: model.paletteColor),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormat.MMM().format(e.reservationSlot?.selectedDate ?? DateTime.now()), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                    Text(DateFormat.d().format(e.reservationSlot?.selectedDate ?? DateTime.now()), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(width: 8),
                VerticalDivider(
                  color: model.disabledTextColor,
                  width: 1,
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// title for ticket
                              /// space option
                              if (getSpaceTypeOptions(context).where((i) => i.uid == e.reservationSlot?.selectedSpaceId).isNotEmpty) Text(getSpaceTypeOptions(context).where((i) => i.uid == e.reservationSlot?.selectedSpaceId).first.spaceTitle, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                              /// ticket fee
                              const SizedBox(height: 4),
                              Text((e.ticketFee != null) ? completeTotalPriceWithCurrency(e.ticketFee!.toDouble(), activityForm.rulesService.currency) : 'Free', style: TextStyle(color: model.disabledTextColor)),
                              const SizedBox(height: 4),
                              /// time slots
                              if (e.reservationTimeSlot != null) Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: model.paletteColor.withOpacity(0.075),
                                        borderRadius: BorderRadius.all(Radius.circular(25),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Text('${DateFormat.jm().format(e.reservationTimeSlot!.slotRange.start)} - ${DateFormat.jm().format(e.reservationTimeSlot!.slotRange.end)}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                    )
                                )
                              )
                            ],
                          ),
                        ),
                        if (showTrailing) Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (showFindTickets) Container(
                                    decoration: BoxDecoration(
                                        color: model.paletteColor,
                                        borderRadius: BorderRadius.all(Radius.circular(25),
                                        )
                                    ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                      child: Text('Find Tickets', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1),
                                  )
                                ),

                              Icon(Icons.keyboard_arrow_right_outlined, color: model.paletteColor)
                        ],
                      ),
                    )
                  ],
                )
              )
            ],
          )
        )
      )
    )
  );
}

Widget getTicketWithCounterForSlotBasedActivity(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityForm, ActivityTicketOption e, List<TicketItem> ticketCount, bool showSelector, {required Function(ActivityTicketOption) didIncreaseAmount, required Function(ActivityTicketOption) didDecreaseAmount}) {
  return BlocProvider(create: (context) => getIt<ActivityTicketWatcherBloc>()..add(ActivityTicketWatcherEvent.watchNumberOfTicketsTakenStarted(reservation.reservationId.getOrCrash(), e.ticketId.getOrCrash())),
      child: BlocBuilder<ActivityTicketWatcherBloc, ActivityTicketWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              // loadOnHoldTicketsFailure: (_) => activityTicketsLoadingFailure(),
              loadNumberOfTicketsTakenSuccess: (count) => Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getTicketForSlotBasedActivity(
                            context,
                            model,
                            activityForm,
                            e,
                            false,
                            false,
                            false,
                            didSelectTicket: (ticket) {
                            }
                        ),
                        const SizedBox(height: 8),
                        Row(
                            children: [
                              Expanded(
                                child: Text('Choose Your Number of Tickets', style: TextStyle(color: model.disabledTextColor))),
                              const SizedBox(width: 15),
                              Visibility(
                                  visible: (count.amount >= e.ticketQuantity),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: model.paletteColor,
                                          borderRadius: BorderRadius.all(Radius.circular(25),
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('Sold Out', style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                      )
                                  )
                              ),
                              Visibility(
                                visible: (count.amount < e.ticketQuantity && (count.amount.toDouble()/e.ticketQuantity.toDouble() >= 0.85)),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: model.paletteColor,
                                        borderRadius: BorderRadius.all(Radius.circular(25),
                                        )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Selling Out', style: TextStyle(color: model.accentColor, overflow: TextOverflow.ellipsis), maxLines: 1),
                                    )
                                ),
                              ),
                            ]
                        )
                      ],
                    ),
                  ),
                  if (showSelector) amountSelector(
                      model,
                      (count.amount >= e.ticketQuantity),
                      ticketCount,
                      e,
                      didDecreaseAmount: didDecreaseAmount,
                      didIncreaseAmount: didIncreaseAmount
                  )
                ],
              ),
              orElse: () => getLoadingTicketItem(context, model),
            );
          }
      )
  );
}

Widget amountSelector(DashboardModel model, bool isLocked, List<TicketItem> currentAmount, ActivityTicketOption currentTicketOption, {required Function(ActivityTicketOption) didIncreaseAmount, required Function(ActivityTicketOption) didDecreaseAmount}) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (isLocked == false) Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: () {
              didIncreaseAmount(currentTicketOption);
            }, icon: const Icon(Icons.add_circle), iconSize: 40, color: model.paletteColor,),
            Text(currentAmount.where((element) => element.selectedTicketId == currentTicketOption.ticketId).length.toString(), style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize)),
            IconButton(onPressed: () {
              if (currentAmount.where((element) => element.selectedTicketId == currentTicketOption.ticketId).isNotEmpty) didDecreaseAmount(currentTicketOption);
            }, icon: const Icon(Icons.remove_circle_outline_rounded), iconSize: 40, color: (currentAmount.where((element) => element.selectedTicketId == currentTicketOption.ticketId).isNotEmpty) ? model.paletteColor : model.disabledTextColor,),

          ],
        ),

        if (isLocked == true) Column(
            mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: () {
            }, icon: const Icon(Icons.add_circle_outline_rounded), iconSize: 40, color: model.disabledTextColor,),
            Text(currentAmount.where((element) => element.selectedTicketId == currentTicketOption.ticketId).length.toString(), style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize)),
            IconButton(onPressed: () {
            }, icon: const Icon(Icons.remove_circle_outline_rounded), iconSize: 40, color: model.disabledTextColor),
            Icon(Icons.lock_outline, color: model.paletteColor),
        ]
      )
    ]
  );
}


Widget ticketItemWidget(DashboardModel model, TicketItem ticket, {required Function(TicketItem ticket) didSelectTicketRefund, required Function(TicketItem) didSelectRedeem}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.all(Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
            // firstLetterOnlyProfile
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         retrieveUserProfile(
                             ticket.ticketOwner.getOrCrash(),
                             model,
                             null,
                             model.paletteColor,
                             20,
                             profileType: UserProfileType.nameAndEmail,
                             trailingWidget: null,
                             selectedButton: (profile) {

                             }
                         ),
                          Padding(
                            padding: EdgeInsets.only(left: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!ticket.isOnHold) Text('Purchased at: ${DateFormat.MMMEd().format(ticket.createdAt)} ${DateFormat.jms().format(ticket.createdAt)}', style: TextStyle(color: model.disabledTextColor), maxLines: 1),
                                /// state?
                                if (ticket.isOnHold) Text('On Hold', style: TextStyle(color: model.disabledTextColor), maxLines: 1),
                                if (!ticket.isOnHold) Text('Purchased', style: TextStyle(color: model.disabledTextColor), maxLines: 1)
                              ],
                            )
                          ),
                      ],
                    )
                  ),

                  if (!ticket.isOnHold) Row(
                    children: [
                      InkWell(
                        onTap: () {
                          didSelectTicketRefund(ticket);
                        },
                        child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: model.paletteColor
                                  ),
                                  height: 40,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Center(
                                        child: Text('Refund', style: TextStyle(color: model.accentColor))),
                                  )
                              ),
                              const SizedBox(width: 10),
                            ]
                        ),
                      ),

                      InkWell(
                          onTap: () {
                            didSelectRedeem(ticket);
                          },
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: (ticket.redeemed == true) ? model.paletteColor : model.webBackgroundColor,
                                  ),
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Center(
                                        child: (ticket.redeemed == true) ? Text('Un-Redeem', style: TextStyle(color: model.accentColor)) : Text('Redeem', style: TextStyle(color: model.paletteColor))),
                                  )
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                      )
                    ]
                  )
            /// refund

            /// who
          ],
        )
      )
    )
  );
}

/// redeem ticket?
/// present ticket/use ticket (QR Code?)?
/// should be the sending/info of the ticket.
Widget getAttendeeTicketItemWidget(BuildContext context, DashboardModel model, ReservationItem reservation, ActivityManagerForm activityForm, TicketItem ticket, {required Function(TicketItem ticket) didSelectTicket}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.all(Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              if (ticket.selectedTicketTitle != null) Text(ticket.selectedTicketTitle!, style: TextStyle(color: model.paletteColor)),
              Visibility(
                visible: activityForm.activityAttendance.isTicketFixed == true,
                child: getTicketForEntireActivity(
                    context,
                    model,
                    reservation,
                    activityForm,
                    activityForm.activityAttendance.defaultActivityTickets ?? ActivityTicketOption.empty(),
                    false,
                    false,
                    false,
                    didSelectTicket: (ticket) {
                    }
                ),
              ),

              /// ticket covers day activity
              Visibility(
                visible: activityForm.activityAttendance.isTicketPerSlotBased == false && activityForm.activityAttendance.isTicketFixed == false,
                child: getTicketForDayBasedActivity(
                    context,
                    model,
                    activityForm,
                    (activityForm.activityAttendance.activityTickets ?? []).firstWhere((element) => ticket.selectedTicketId == element.ticketId, orElse: () => ActivityTicketOption.empty()),
                    false,
                    false,
                    false,
                    didSelectTicket: (ticket) {
                    }
                ),
              ),

              /// ticket covers slot based activity
              Visibility(
                  visible: activityForm.activityAttendance.isTicketPerSlotBased == true && activityForm.activityAttendance.isTicketFixed == false,
                  child: getTicketForSlotBasedActivity(
                      context,
                      model,
                      activityForm,
                      (activityForm.activityAttendance.activityTickets ?? []).firstWhere((element) => ticket.selectedTicketId == element.ticketId, orElse: () => ActivityTicketOption.empty()),
                      false,
                      false,
                      false,
                      didSelectTicket: (ticket) {
                    }
                  ),
                ),
            ],
          )
      )
    ),
  );
}

Widget getLoadingTicketItem(BuildContext context, DashboardModel model) {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: model.accentColor.withOpacity(0.15),
          borderRadius: const BorderRadius.all(Radius.circular(25)),
        ),
      )
  );
}

Widget getLoadingForOverviewFooter(BuildContext context) {
  return Container(
      width: MediaQuery.of(context).size.width,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.15),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.15),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.15),
              ),
            ),

        ],
      ),
    )
  );
}