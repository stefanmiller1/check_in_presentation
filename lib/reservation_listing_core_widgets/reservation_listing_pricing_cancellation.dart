part of check_in_presentation;

Widget getPricingColumn(BuildContext context, DashboardModel model, Color priceColor, String title, String fee, bool isShowingMore, {required Function() onSelectedFee}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          Visibility(
            visible: isShowingMore,
            child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              onSelectedFee();
            }, icon: Icon(Icons.info, color: model.paletteColor)),
          )
        ],
      ),

      SizedBox(height: 3),
      Text(fee, style: TextStyle(color: priceColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize)),

    ],
  );
}


Widget getPricingDetails(DashboardModel model, List<ReservationSlotItem> allSlots, List<ReservationSlotItem> cancelledSlots, int numberOfSlots, String currency) {
  return Container(
    width: 550,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('${completeTotalPriceWithCurrency((getTotalPriceDouble(allSlots, cancelledSlots)/numberOfSlots), currency)} X $numberOfSlots Slots', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,))),
              Text(completeTotalPriceWithCurrency(getTotalPriceDouble(allSlots, cancelledSlots), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
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
              Text(completeTotalPriceWithCurrency((getTotalPriceDouble(allSlots, cancelledSlots)*CICOReservationPercentageFee), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
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
              Text(completeTotalPriceWithCurrency(getTotalPriceDouble(allSlots, cancelledSlots)*CICOTaxesFee, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
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
            Text(completeTotalPriceWithCurrency((getTotalPriceDouble(allSlots, cancelledSlots) +
                    getTotalPriceDouble(allSlots, cancelledSlots)*CICOReservationPercentageFee +
                    getTotalPriceDouble(allSlots, cancelledSlots)*CICOTaxesFee), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    ),
  );
}

Widget getPricingCancellationForNoCancellations(BuildContext context, DashboardModel model) {
  return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('This Reservation is final - once completed, you cannot cancel or make any changes.', style: TextStyle(color: model.disabledTextColor),
              ),
            )
      ],
    ),
  );
}


Widget getPricingCancellationWithChangesCancellation(BuildContext context, DashboardModel model, bool changesOnly, bool cancelOnly) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: (changesOnly && cancelOnly),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Make changes or cancel anytime before your Reservation begins', style: TextStyle(color: model.disabledTextColor),
            ),
          ),
        ),
        Visibility(
          visible: changesOnly && !cancelOnly,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Make changes to your slots anytime before your Reservation begins - However, you will not be able to Cancel', style: TextStyle(color: model.disabledTextColor),
            ),
          ),
        ),

        Visibility(
            visible: cancelOnly && !changesOnly,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Cancel and get a full refund anytime before your Reservation Begins', style: TextStyle(color: model.disabledTextColor),
            ),
          ),
        )
      ],
    ),
  );
}

bool checkIfReservationSelected(List<ReservationSlotItem> allSlots,  List<ReservationSlotItem> cancelledSlots) {
  return ((allSlots.isNotEmpty) && getTotalPriceDouble(allSlots, cancelledSlots) != 0);
}

Widget getTotalPriceOnly(DashboardModel model, List<ReservationSlotItem> allSlots, List<ReservationSlotItem> cancelledSlots, int numberOfSlots, String currency) {
  return Text(completeTotalPriceWithCurrency((getTotalPriceDouble(allSlots, cancelledSlots) + getTotalPriceDouble(allSlots, cancelledSlots)*CICOReservationPercentageFee + getTotalPriceDouble(allSlots, cancelledSlots)*CICOTaxesFee), currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold));
}

Widget getPricingWithFeeCancellation(BuildContext context, DashboardModel model, List<ReservationSlotItem> reservation, List<FeeBasedCancellation> feePercentages) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reservation.isNotEmpty) for (var slot in reservation.toList()..sort((a,b) => b.selectedDate.compareTo(a.selectedDate))..first)
          Visibility(
          // visible: feePercentages.map((e) => timeUntil.subtract(Duration(days: e.daysBeforeStart))).where((element) => element.isAfter(DateTime.now())).isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: feePercentages.map(
                        (e) => Text('Cancel before ${DateFormat.yMMMd().format(slot.selectedDate.subtract(Duration(days: e.daysBeforeStart)))} and receive ${e.percentage}% back', style: TextStyle(color: model.disabledTextColor))
              ).toList()
            ),
          )
        ),
      ]
    ),
  );
}

Widget getPricingWithTimeCancellation(BuildContext context, DashboardModel model, List<ReservationSlotItem> reservation, List<TimeBasedCancellation> timeUntil) {
  return Container(
    child:  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reservation.isNotEmpty) for (var slot in reservation.toList()..sort((a,b) => b.selectedDate.compareTo(a.selectedDate))..first)
        Visibility(
          // visible: slot.isAfter(DateTime.now()),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: timeUntil.map(
                    (e) => Text('Cancel or make Changes anytime before ${DateFormat.yMMMd().format(slot.selectedDate.subtract(Duration(days: e.intervalDuration ?? 0)))}- and get a full Refund.', style: TextStyle(color: model.disabledTextColor)),
              ).toList()
            ),
          ),
        ),
      ],
    ),
  );
}

