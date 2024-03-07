part of check_in_presentation;

Widget getTicketPricingDetails(DashboardModel model, List<TicketItem> allSlots, String currency) {

  int numberOfSlots = allSlots.length;

  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('${completeTotalPriceWithCurrency((getTicketTotalPriceDouble(allSlots)/numberOfSlots), currency)} X $numberOfSlots Tickets', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,))),
              Text(completeTotalPriceWithCurrency(getTicketTotalPriceDouble(allSlots), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Service Fee', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,))),
              Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(allSlots)*CICOReservationPercentageFee), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('Taxes & Fees HST (13% - Ontario,Canada)', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,))),
              Text(completeTotalPriceWithCurrency(getTicketTotalPriceDouble(allSlots)*CICOTaxesFee, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(thickness: 0.5, color: model.disabledTextColor),
        ),
        Row(
          children: [
            Text('Total', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
            SizedBox(width: 15),
            Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(allSlots) +
                getTicketTotalPriceDouble(allSlots)*CICOReservationPercentageFee +
                getTicketTotalPriceDouble(allSlots)*CICOTaxesFee), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
        ],
      )
    ],
  );
}


Widget ticketCancellationDetails(BuildContext context, DashboardModel model, List<TicketItem> tickets, ActivityManagerForm activityForm) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// ------------------------ ///
      /// cancellation policy ///
      const SizedBox(height: 5),
      Divider(color: model.disabledTextColor),
      const SizedBox(height: 5),
      Text('Cancellations', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 8),

      if (activityForm.rulesService.cancellationSettings.isNotAllowedCancellation ?? false)
        getPricingCancellationForNoCancellations(context, model),
      if (!(activityForm.rulesService.cancellationSettings.isNotAllowedCancellation ?? false))
        getPricingCancellationWithChangesCancellation(context, model, activityForm.rulesService.cancellationSettings.isAllowedChangeNotEarlyEnd ?? false,
            activityForm.rulesService.cancellationSettings.isAllowedEarlyEndAndChanges ?? false),
      if ((activityForm.rulesService.cancellationSettings.isAllowedFeeBasedChanges ?? false) &&
          (activityForm.rulesService.cancellationSettings.feeBasedCancellationOptions?.isNotEmpty ?? false))
        getPricingWithFeeCancellation(context, model, tickets.map((e) => e.selectedReservationTimeSlot?.slotRange.start ?? e.selectedReservationSlot?.selectedDate ?? DateTime.now()).toList(),
            activityForm.rulesService.cancellationSettings.feeBasedCancellationOptions ?? []),
      if ((activityForm.rulesService.cancellationSettings.isAllowedTimeBasedChanges ?? false) &&
          (activityForm.rulesService.cancellationSettings.timeBasedCancellationOptions?.isNotEmpty ?? false))
        getPricingWithTimeCancellation(context, model, tickets.map((e) => e.selectedReservationTimeSlot?.slotRange.start ?? e.selectedReservationSlot?.selectedDate ?? DateTime.now()).toList(), activityForm.rulesService.cancellationSettings.timeBasedCancellationOptions ?? []),

      /// ------------------------ ///
      /// policy & guidelines
      const SizedBox(height: 5),
      Divider(color: model.disabledTextColor),
      const SizedBox(height: 5),

      Text('When Selecting Confirm Ticket, I agree to the Rules made by the Listing Owner, Ground Rules for Guests, Cancellations, Rebooking, and Refunding Policy defined by CICO and the Listing Owner.', style: TextStyle(color: model.disabledTextColor)),

    ]
  );
}



Widget getFooterTotalTicketPricing(DashboardModel model, List<TicketItem> allSlots, String currency) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(completeTotalPriceWithCurrency((getTicketTotalPriceDouble(allSlots) +
          getTicketTotalPriceDouble(allSlots)*CICOReservationPercentageFee +
          getTicketTotalPriceDouble(allSlots)*CICOTaxesFee), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Row(
        children: [
          Text(allSlots.length.toString(), style: TextStyle(color: model.paletteColor)),
          const SizedBox(width: 6),
          Icon(Icons.airplane_ticket_outlined, color: model.paletteColor),
        ]
      )
    ]
  );
}


