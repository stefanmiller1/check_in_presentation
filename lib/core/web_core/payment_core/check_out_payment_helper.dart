part of check_in_presentation;

enum CheckOutPaymentMarker {selectFromPaymentMethod, addPaymentMethod, processPayment, finishedPayment, failedPayment}

bool isNextValid(CheckOutPaymentMarker marker, CardItem? card, bool showProcessedPayment) {
  switch (marker) {
    case CheckOutPaymentMarker.selectFromPaymentMethod:
      return card != null;
    case CheckOutPaymentMarker.addPaymentMethod:
      return false;
    case CheckOutPaymentMarker.processPayment:
      return showProcessedPayment;
    case CheckOutPaymentMarker.finishedPayment:
      return false;
    case CheckOutPaymentMarker.failedPayment:
      return false;
  }
}

Widget headerNavWidget(BuildContext context, DashboardModel model, CheckOutPaymentMarker marker) {
  return Column(
      children: [
        const SizedBox(height: 25),
        Text(headerString(marker), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
        const SizedBox(height: 15),
        Divider(color: model.disabledTextColor),
    ],
  );
}

String headerString(CheckOutPaymentMarker marker) {
  switch (marker) {

    case CheckOutPaymentMarker.selectFromPaymentMethod:
      return 'Select a Payment Method';
    case CheckOutPaymentMarker.addPaymentMethod:
      return 'Add Payment Method';
    case CheckOutPaymentMarker.processPayment:
      return 'Process Payment';
    case CheckOutPaymentMarker.finishedPayment:
      return 'Finished Payment';
    case CheckOutPaymentMarker.failedPayment:
      return 'Something Went Wrong..';
    default:
      return '';
  }
}


Widget bottomNavWidget(BuildContext context, DashboardModel model, bool isNextValid, bool isBackValid, CheckOutPaymentMarker marker, {required Function() didSelectBack, required Function() didSelectNext}) {
  return ClipRRect(
    child: BackdropFilter(
      filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Center(
        child: Container(
          color: Colors.grey.shade200.withOpacity(0.5),
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
              children: [

                if (isBackValid) Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 580),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            didSelectBack();
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 220
                            ),
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: model.paletteColor),
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(child: Text('Back', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))),
                          ),
                        ),

                        if (isNextValid) InkWell(
                          onTap: () {
                            didSelectNext();
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                maxWidth: 220
                            ),
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              color: model.paletteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(child: Text('Check Out', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ],
                    )
                  )
                )
              ]
            )
          )
        )
      )
    )
  );
}