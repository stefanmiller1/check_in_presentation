import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import '../../check_in_presentation.dart';
import 'package:check_in_credentials/check_in_credentials.dart';

enum CancellationRequestType {none, noLongerAvailable, lookingForDifferentPrice, uncomfortable, requestersDecision, other}
enum CancelMarker {cancelReason, cancelMessage, submit, finished}

String getReservationCancellationTitle(CancellationRequestType type) {
  switch (type) {
    case CancellationRequestType.noLongerAvailable:
      return 'This is no longer available';
    case CancellationRequestType.lookingForDifferentPrice:
      return 'The pricing has changed for these dates';
    case CancellationRequestType.uncomfortable:
      return 'This guest has made me uncomfortable and has broken my rules';
    case CancellationRequestType.requestersDecision:
      return 'Request was made to cancel';
    case CancellationRequestType.other:
      return 'Other';
    case CancellationRequestType.none:
      return 'Why would you like to cancel?';
  }
}

String getBackButtonTitle(CancelMarker marker) {
  switch (marker) {
    case CancelMarker.cancelReason:
      return 'Cancel';
    case CancelMarker.cancelMessage:
      return 'Back';
    case CancelMarker.submit:
      return 'Back';
    case CancelMarker.finished:
      return 'Back';
  }
}

String getForwardButtonTitle(CancelMarker marker) {
  switch (marker) {
    case CancelMarker.cancelReason:
      return 'Next';
    case CancelMarker.cancelMessage:
      return 'Review';
    case CancelMarker.submit:
      return 'Yes, Cancel';
    case CancelMarker.finished:
      return 'Done';
  }
}

bool isCompleteCurrentTab(CancelMarker marker, CancellationRequestType? type, String? reason) {
  switch (marker) {
    case CancelMarker.cancelReason:
      return type != null;
    case CancelMarker.cancelMessage:
      return reason?.isNotEmpty == true;
    case CancelMarker.submit:
      return true;
    case CancelMarker.finished:
      return true;
  }
}

Widget tabTracker(DashboardModel model, CancelMarker marker) {
  return Row(
    children: [
      Text('Reason For Cancelling', style: TextStyle(color: model.paletteColor)),
      SizedBox(width: 10),
      Divider(),
      SizedBox(width: 10),
      Text('Response Message', style: TextStyle(color: (marker == CancelMarker.cancelMessage || marker == CancelMarker.submit || marker == CancelMarker.finished) ? model.paletteColor : model.disabledTextColor)),
      SizedBox(width: 10),
      Icon(Icons.arrow_forward_ios_rounded, color: model.paletteColor, size: 12,),
      SizedBox(width: 10),
      Text('Cancel', style: TextStyle(color: (marker == CancelMarker.submit || marker == CancelMarker.finished) ? model.paletteColor : model.disabledTextColor))
    ],
  );
}

Widget getCancelReason(DashboardModel model, String title, CancellationRequestType? type, {required Function(CancellationRequestType) didSelectType}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(title, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
          SizedBox(height: 25),
          Center(
            child: Container(
              width: 525,
              height: 68,
              child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                      isDense: true,
                      customButton: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: model.accentColor,
                            border: Border.all(color: model.disabledTextColor),
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(getReservationCancellationTitle(type ?? CancellationRequestType.none), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.normal)))
                          ),
                        ),
                      ),
                      onChanged: (Object? navItem) {
                      },
                      items: CancellationRequestType.values.where((element) => element != CancellationRequestType.none).map(
                              (e) {
                            return DropdownMenuItem<CancellationRequestType>(
                              onTap: () {
                                didSelectType(e);
                              },
                              value: e,
                              child: Text(getReservationCancellationTitle(e), style: TextStyle(color: model.paletteColor),),
                            );
                          }
                      ).toList(),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: model.webBackgroundColor
                    ),
                  ),
                )
              ),
            ),
          ),

          SizedBox(height: 30),
          Visibility(
              visible: type == CancellationRequestType.uncomfortable,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Before Cancelling:', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize,)),
                  SizedBox(height: 10),
                  Text('Determine what this person did to make you decide to choose this option (if anything specific happened). You can also review our Policy to help making this decision.', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
                ],
              )
          )
        ],
      ),
    ),
  );
}


Widget getCancelMessageReason(BuildContext context, DashboardModel model, TextEditingController controller, String userName, {required Function(String) didUpdateText}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text('Tell $userName Your Reason for Cancelling', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
          SizedBox(height: 25),

          Text('message to $userName', style: TextStyle(color: model.paletteColor)),
          SizedBox(height: 5),
          getDescriptionTextField(
              context,
              model,
              controller,
              '',
              6,
              200,
              updateText: (value) {
                didUpdateText(value);
              }
          ),
        ],
      ),
    ),
  );
}


Widget getCancelReviewRefund(DashboardModel model, double totalFee, double? taxPercentage, String currency, String refundTitle, String refundDescription) {
  final totalTaxAmount = totalFee * (taxPercentage ?? CICOTaxesFee);
  final sellerFee = totalFee * CICOSellerPercentageFee;
  final totalBuyerTaxAmount = sellerFee * (taxPercentage ?? CICOTaxesFee);


  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(9.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text('How does this look?', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
          SizedBox(height: 25),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 0.5, color: model.disabledTextColor)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Original Total', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      Text(completeTotalPriceWithCurrency(totalFee - (sellerFee + totalBuyerTaxAmount) + totalTaxAmount, currency), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, decoration: TextDecoration.lineThrough))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Earnings to Date', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      Text(completeTotalPriceWithCurrency(0, currency), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, decoration: TextDecoration.lineThrough))
                    ],
                  )
                  //
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 600,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(width: 0.5, color: model.disabledTextColor)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text('Cancellations', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('setup for a full refund', style: TextStyle(color: model.paletteColor),),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          /// each will receive this message?

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: model.disabledTextColor),
          ),

          Container(
              width: 600,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(width: 0.5, color: model.disabledTextColor)
              ),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text('Refund Details', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// title...(could be related to number of attendees refunding)
                              Text(refundTitle, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
                              /// description...(could be related to total in terms of booth refunds & number of booths refunded)
                              Text(refundDescription, style: TextStyle(color: model.disabledTextColor)),
                            ],
                          ),

                           Text(completeTotalPriceWithCurrency(totalFee, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                        ],
                      ),

                      SizedBox(height: 10),
                      Container(
                        width: 600,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Service Fee', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
                                Text(refundDescription, style: TextStyle(color: model.disabledTextColor)),
                              ],
                            ),

                           Text('- ${completeTotalPriceWithCurrency(sellerFee, currency)}', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),

                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Taxes & Fees HST (13% - Ontario,Canada)', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
                              Text(refundDescription, style: TextStyle(color: model.disabledTextColor)),
                            ],
                          ),

                          Text(completeTotalPriceWithCurrency(totalTaxAmount - totalBuyerTaxAmount, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),

                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(color: model.disabledTextColor),
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Total', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
                            Text(completeTotalPriceWithCurrency(totalFee - (sellerFee + totalBuyerTaxAmount) + totalTaxAmount, currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),

                          ]
                      ),
                      SizedBox(height: 10)
                  ],
                )
              )
            )
        ],
      ),
    ),
  );
}