part of check_in_presentation;

Widget getPricingBreakDown(DashboardModel model, double price, double numberOfSlots, String currency) {

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
            Expanded(child: Text('${completeTotalPriceWithCurrency(price/numberOfSlots, currency)} X $numberOfSlots', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,))),
            Text(completeTotalPriceWithCurrency(price, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
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
            Text(completeTotalPriceWithCurrency(price*CICOBuyerPercentageFee, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
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
            Text(completeTotalPriceWithCurrency(price*CICOTaxesFee, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
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
          Text(completeTotalPriceWithCurrency(
                price +
                price*CICOBuyerPercentageFee +
                price*CICOTaxesFee, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
        ],
      )
    ],
  );
}

Widget cancellationDetails(BuildContext context, DashboardModel model, ActivityManagerForm activityForm) {
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

        /// ------------------------ ///
        /// policy & guidelines
        const SizedBox(height: 5),
        Divider(color: model.disabledTextColor),
        const SizedBox(height: 5),

        Text('When Selecting Confirm Ticket, I agree to the Rules made by the Listing Owner, Ground Rules for Guests, Cancellations, Rebooking, and Refunding Policy defined by CICO and the Listing Owner.', style: TextStyle(color: model.disabledTextColor)),

    ]
  );
}