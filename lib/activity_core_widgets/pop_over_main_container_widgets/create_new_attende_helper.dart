part of check_in_presentation;

enum NewAttendeeStepsMarker {getStarted, addActivityRules, addActivityCustomRules, requestToJoinComplete, joinComplete}
enum AttendeeVendorMarker {formMessage, welcomeMessage, availableTime, boothType, customDocuments, customLists, disclaimer, review, profileSelection}

class NewAttendeeContainerModel {

  final NewAttendeeStepsMarker markerItem;
  final AttendeeVendorMarker? subVendorMarkerItem;
  final Widget childWidget;

  NewAttendeeContainerModel({required this.markerItem, this.subVendorMarkerItem, required this.childWidget});
}

bool activityIsByRequest(ActivityManagerForm activity) => activity.rulesService.accessVisibilitySetting.isReviewRequired == true;
bool activityHasRules(ActivityManagerForm activity) => activity.rulesService.ruleOption.isValid() && activity.rulesService.ruleOption.getOrCrash().isNotEmpty;
bool activityHasCustomRules(ActivityManagerForm activity) => activity.rulesService.customFieldRuleSetting.isNotEmpty;
// bool attendeeVendorIsValid(AttendeeItem attendee) => (attendee.attendeeType == AttendeeType.vendor && attendee.eventMerchantVendorProfile != null);
//
//
bool activityRequiresVendorFee(VendorMerchantForm? vendorForm) => vendorForm?.boothPaymentOptions?.any((booth) => booth.fee != null && booth.fee! > 0) ?? false;


NewAttendeeStepsMarker getInitialContainerForNewAttendee(ActivityManagerForm activity) {
  if (activityHasRules(activity)) {
    return NewAttendeeStepsMarker.addActivityRules;
  } else if (activityHasCustomRules(activity)) {
    return NewAttendeeStepsMarker.addActivityCustomRules;
  } else if (activityIsByRequest(activity)) {
    return NewAttendeeStepsMarker.requestToJoinComplete;
  }
  return NewAttendeeStepsMarker.joinComplete;
}


NewAttendeeStepsMarker getInitialContainerForNewAffiliateAttendee(ActivityManagerForm activity) {
  if (activityHasRules(activity)) {
    return NewAttendeeStepsMarker.addActivityRules;
  }
  return NewAttendeeStepsMarker.getStarted;
}


// NewAttendeeStepsMarker nextButtonForActivityRules() {
//
// }

Widget getStarted() {
  return Container();
}

Widget rulesToAdd(BuildContext context, DashboardModel model, List<DetailOption> rules, UserProfileModel resOwner) {
  return SingleChildScrollView(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('You\'re Almost Done..', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize))),
            Text('To Finish We just need you to review some rules before Joining',
                  style: TextStyle(color: model.disabledTextColor)),

            Divider(
                thickness: 0.5,
                color: model.disabledTextColor
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  ...rules.map(
                          (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            textColor: model.paletteColor,
                            leading: Icon(getIconForRuleOption(context, e.uid), color: model.paletteColor),
                            title: Text(predefinedDetailOptions(context).where((element) => element.uid == e.uid).isNotEmpty ? predefinedDetailOptions(context).where((element) => element.uid == e.uid).first.detail ?? '' : ''),
                            trailing: Icon(Icons.check_circle, color: model.paletteColor),
                          )
                      )
                  ).toList(),
                ]
              ),
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Once you join, ${resOwner.legalName.getOrCrash()} would like you to follow these rules. Let\'s make this reservation as fun and respectable activity (${resOwner.legalName.getOrCrash()} has the choice and right to decide who stays or has to go at any time)',
                  style: TextStyle(color: model.disabledTextColor)),
            ),

      ]
    )
  );
}

Widget customRulesToAdd(BuildContext context, DashboardModel model, List<CustomRuleOption> customRules, {required Function(CustomRuleOption selectedRule, CustomRuleOption currentRule) didUpdateCustomRule}) {
  return Container(
      color: model.webBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('One More Step!', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text('To Finish Joining please answer a few questions below.',
              style: TextStyle(color: model.disabledTextColor)),
        ),
        Divider(
            thickness: 0.5,
            color: model.disabledTextColor),
            const SizedBox(height: 8.0),
            ...customRules.map(
              (e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widgetForCustomRule(
                    context,
                    model,
                    e,
                    didUpdateCustomRule: (selectedRule) {
                      didUpdateCustomRule(selectedRule, e);
              },
            )
          ),
        ).toList(),
        const SizedBox(height: 80),
        ],
      ),
    )
  );
}

Widget requestToJoinCompleted(BuildContext context, DashboardModel model, String requestInfo, {required Function() didSelectRequestToJoin}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (kIsWeb == false) const SizedBox(height: 80),

          lottie.Lottie.asset(
              height: 450,
              'assets/lottie_animations/animation_700434682245.json'
          ),
          const SizedBox(height: 15),
          Text('Send Request!', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 5),
          Text(requestInfo, style: TextStyle(color: model.disabledTextColor)),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              didSelectRequestToJoin();
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: model.paletteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                        child: Row(
                            children: [
                              Icon(Icons.textsms_outlined, color: model.accentColor),
                              const SizedBox(width: 5),
                              Text('Click to Send Request', style: TextStyle(color: model.accentColor))
                            ]
                        )
                    )
                )
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    )
  );
}

Widget newAttendeeJoinCompleted(BuildContext context, DashboardModel model, {required Function() didSelectComplete}) {
  /// suggest adding to discussion...show animation
  return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if (kIsWeb == false) const SizedBox(height: 80),
            lottie.Lottie.asset(
                height: 425,
                'assets/lottie_animations/animation_700434682245.json'
            ),
            const SizedBox(height: 15),
            /// add to the discussion.
            Text('Welcome!', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 5),
            Text('Go to your reservations to find whats coming up. Share this activity with your community.', style: TextStyle(color: model.disabledTextColor)),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                didSelectComplete();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: model.paletteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Row(
                            children: [
                            Icon(Icons.textsms_outlined, color: model.accentColor),
                            const SizedBox(width: 5),
                            Text('Click to Join', style: TextStyle(color: model.accentColor))
                      ]
                    )
                  )
                )
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
    )
  );
}


bool showBackButton(NewAttendeeStepsMarker marker) {
  switch (marker) {
    case NewAttendeeStepsMarker.getStarted:
      return true;
    case NewAttendeeStepsMarker.addActivityRules:
      return true;
    case NewAttendeeStepsMarker.addActivityCustomRules:
      return true;
    case NewAttendeeStepsMarker.requestToJoinComplete:
      return true;
    case NewAttendeeStepsMarker.joinComplete:
      return true;
  }
}


/// validate attendee requirements
bool attendeeBoothPaymentsValid(VendorMerchantForm? vendorForm) {
  if (vendorForm?.availableTimeSlots == null || vendorForm?.availableTimeSlots?.isEmpty == true) {
    return vendorForm?.boothPaymentOptions != null && vendorForm?.boothPaymentOptions?.isNotEmpty == true;
  }

  // if multiple time slots are selectable
  // Convert all availability IDs in MVBoothPayments to a set for efficient lookup
  final Set<UniqueId>? boothIds = vendorForm?.boothPaymentOptions?.map((timeslot) => timeslot.availabilityId).whereType<UniqueId>().toSet(); // This removes null values if availabilityId is optional.toSet();

  // Check if every custom availability ID exists in the set of payment availability IDs
  return (vendorForm != null && vendorForm.availableTimeSlots != null && boothIds != null) ? vendorForm.availableTimeSlots!.every((availability) => boothIds.contains(availability.uid)) : false;
}


bool antendeeDocumentFormsIsValid(List<DocumentFormOption> list1, List<DocumentFormOption> list2) {
  // Extract keys from the first list
  var keys1 = list1.map((option) => option.documentForm.key).toSet();
  // Extract keys from the second list
  var keys2 = list2.map((option) => option.documentForm.key).toSet();

  // Check if both sets are equal
  return keys1.difference(keys2).isEmpty && keys2.difference(keys1).isEmpty;
}

bool showNextButton(NewAttendeeStepsMarker marker, AttendeeVendorMarker? vendorAttendeeMarker, ActivityManagerForm activityForm, VendorMerchantForm? refVendor, AttendeeFormState state) {
  switch (marker) {
    case NewAttendeeStepsMarker.getStarted:
      switch (state.attendeeItem.attendeeType) {
        case (AttendeeType.tickets):
          return (state.attendeeItem.ticketItems?.isNotEmpty == true);
        case (AttendeeType.vendor):
          switch (vendorAttendeeMarker) {
            case AttendeeVendorMarker.formMessage:
              return true;
            case AttendeeVendorMarker.welcomeMessage:
              return true;
            case AttendeeVendorMarker.availableTime:
              return state.attendeeItem.vendorForm?.availableTimeSlots?.isNotEmpty == true;
            case AttendeeVendorMarker.boothType:
              return attendeeBoothPaymentsValid(state.attendeeItem.vendorForm);
            case AttendeeVendorMarker.customDocuments:
              return antendeeDocumentFormsIsValid(getDocumentsList(refVendor) ?? [], getDocumentsList(state.attendeeItem.vendorForm) ?? []);
            case AttendeeVendorMarker.customLists:
              // TODO: Handle this case.
              break;
            case AttendeeVendorMarker.disclaimer:
              return true;
            case AttendeeVendorMarker.review:
              return true;
            case AttendeeVendorMarker.profileSelection:
              break;
          }
          return false;
        default:
          return true;
      }
    case NewAttendeeStepsMarker.addActivityRules:
      return true;
    case NewAttendeeStepsMarker.addActivityCustomRules:
      return true;
    case NewAttendeeStepsMarker.requestToJoinComplete:
      return false;
    case NewAttendeeStepsMarker.joinComplete:
      return false;

  }
}


String getTitleForNextButton(NewAttendeeStepsMarker marker) {
  switch (marker) {
    case NewAttendeeStepsMarker.getStarted:
      return 'Next';
    case NewAttendeeStepsMarker.addActivityRules:
      return 'Next';
    case NewAttendeeStepsMarker.addActivityCustomRules:
      return 'Skip';
    case NewAttendeeStepsMarker.requestToJoinComplete:
      return 'Done';
    case NewAttendeeStepsMarker.joinComplete:
      return 'Done';
  }
}


Widget footerWidgetForNewAttendee(BuildContext context, DashboardModel model, bool isPreview, NewAttendeeStepsMarker marker, AttendeeVendorMarker? vendorAttendeeMarker, ActivityManagerForm activityForm, AttendeeFormState state, VendorMerchantForm? refVendor,  bool isLast, {required Function() didSelectBack, required Function() didSelectNext}) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
            children: [
              Visibility(
                visible: showBackButton(marker),
                child: IconButton(
                    onPressed: () {
                        didSelectBack();
                    },
                  icon: Icon(Icons.arrow_back_ios, color: model.paletteColor)
                ),
              ),
              const SizedBox(width: 4.5),
              Visibility(
                visible: (state.attendeeItem.ticketItems ?? []).isNotEmpty && state.attendeeItem.attendeeType == AttendeeType.tickets,
                child: getFooterTotalTicketPricing(model, state.attendeeItem.ticketItems ?? [], activityForm.rulesService.currency),
              ),
              Visibility(
                visible: activityRequiresVendorFee(state.attendeeItem.vendorForm) && state.attendeeItem.attendeeType == AttendeeType.vendor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Vendor Fee', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,), maxLines: 1,),
                      Text(completeTotalPriceWithCurrency(
                            (attendeeVendorFee(state.attendeeItem.vendorForm?.boothPaymentOptions ?? [])).toDouble() +
                            (attendeeVendorFee(state.attendeeItem.vendorForm?.boothPaymentOptions ?? [])).toDouble()*CICOReservationPercentageFee +
                            (attendeeVendorFee(state.attendeeItem.vendorForm?.boothPaymentOptions ?? [])).toDouble()*CICOTaxesFee, activityForm.rulesService.currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              const SizedBox(width: 6),
              ],
            )
          ),

          Visibility(
            visible: isPreview || showNextButton(marker, vendorAttendeeMarker, activityForm, refVendor, state),
            child:  Visibility(
              visible: state.isSubmitting == false,
              child: InkWell(
                onTap: () {
                  didSelectNext();
                },
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 200
                  ),
                  height: 45,
                  width: 185,
                  decoration: BoxDecoration(
                    color: model.paletteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(isLast ? (activityRequiresVendorFee(state.attendeeItem.vendorForm) && state.attendeeItem.attendeeType == AttendeeType.vendor) ? 'Check Out & Apply' : 'Apply' : getTitleForNextButton(marker), style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                    )),
                ),
              ),
            ),
          )
        ],
      ),
    );

}