part of check_in_presentation;

enum NewAttendeeStepsMarker {chooseAttendingType, getStarted, addActivityRules, addActivityCustomRules, requestToJoinComplete, joinComplete}
enum AttendeeVendorMarker {formMessage, welcomeMessage, availableTime, boothType, customDocuments, customLists, disclaimer, review, applicationSent, selectPaymentMethod, profileSelection}


class NewAttendeeContainerModel {

  final NewAttendeeStepsMarker markerItem;
  final AttendeeVendorMarker? subVendorMarkerItem;
  final Widget childWidget;

  NewAttendeeContainerModel({required this.markerItem, this.subVendorMarkerItem, required this.childWidget});
}

bool activityIsByRequest(ActivityManagerForm activity) => activity.rulesService.accessVisibilitySetting.isReviewRequired == true;
bool activityHasRules(ActivityManagerForm activity) => activity.rulesService.ruleOption.isValid() && activity.rulesService.ruleOption.getOrCrash().isNotEmpty;
bool activityHasCustomRules(ActivityManagerForm activity) => activity.rulesService.customFieldRuleSetting.isNotEmpty;
bool activityHasOptions(ActivityManagerForm activity) => activity.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true;
// bool attendeeVendorIsValid(AttendeeItem attendee) => (attendee.attendeeType == AttendeeType.vendor && attendee.eventMerchantVendorProfile != null);


NewAttendeeStepsMarker getInitialContainerForNewAttendee(ActivityManagerForm activity) {
  if (activityHasOptions(activity)) {
    return NewAttendeeStepsMarker.chooseAttendingType;
  } else if (activityHasRules(activity)) {
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


Widget selectJoinTypeOptions(BuildContext context, DashboardModel model, ListingManagerForm listingForm, ReservationItem reservationItem, UserProfileModel activityOwnerProfile, ActivityManagerForm activityForm, {required Function(AttendeeType) didSelectOption}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const SizedBox(height: 15),
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color:  model.accentColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: ListTile(
                onTap: () {
                  didSelectOption(AttendeeType.free);
                },
                leading: Icon(Icons.person_outlined, color: model.paletteColor),
                title: Text('Join as a Attendee', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                subtitle: Text('Give me updates on start/closing times & location'),
              )
          ),

          if (activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true) Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Divider(color: model.disabledTextColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                    ),
                    Expanded(child: Divider(color: model.disabledTextColor)),
                ]
              ),

              const SizedBox(height: 20),
              Text('Join as a Vendor', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
              Text('Select an Application Below', style: TextStyle(color: model.disabledTextColor)),
              const SizedBox(height: 4),
              ...activityForm.rulesService.vendorMerchantForms?.where((element) => element.formStatus == FormStatus.published).toList().asMap().map(
                    (i, e) =>  MapEntry(i, Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: vendorFormApplyButton(
                        context,
                        model,
                        reservationItem,
                        listingForm,
                        activityForm,
                        activityOwnerProfile,
                        false,
                        MediaQuery.of(context).size.width,
                        false,
                        e,
                        e,
                        i,
                        didSelectNewVendor: () {
                          didSelectOption(AttendeeType.vendor);
                        }
                    )
                ),
                ),
              ).values.toList() ?? []
            ],
          ),
        ]
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
          const SizedBox(height: 100),
        ],
      ),
    )
  );
}


bool showBackButton(NewAttendeeStepsMarker marker) {
  switch (marker) {
    case NewAttendeeStepsMarker.chooseAttendingType:
      return true;
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


bool antendeeDiscountCodeIsValid() {
  return false;
}

bool isNextEnabled(NewAttendeeStepsMarker marker, CardItem? cardItem, AttendeeVendorMarker? vendorAttendeeMarker, VendorMerchantForm? refVendor, AttendeeFormState state) {
  switch (marker) {
    case NewAttendeeStepsMarker.chooseAttendingType:
      return false;
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
              return state.attendeeItem.eventMerchantVendorProfile != null;
            case AttendeeVendorMarker.selectPaymentMethod:
              return cardItem != null;
            case AttendeeVendorMarker.applicationSent:
              return false;
            case null:
              // TODO: Handle this case.
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
    case NewAttendeeStepsMarker.chooseAttendingType:
      return 'Next';
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

String? getTitleForError(NewAttendeeStepsMarker marker, AttendeeVendorMarker? vendorAttendeeMarker, AttendeeFormState state) {
  switch (marker) {
    case NewAttendeeStepsMarker.chooseAttendingType:
      // TODO: Handle this case.
    case NewAttendeeStepsMarker.getStarted:
    switch (state.attendeeItem.attendeeType) {
      case (AttendeeType.tickets):
        return null;
      case (AttendeeType.vendor):
        switch (vendorAttendeeMarker) {
          case AttendeeVendorMarker.formMessage:
            return null;
          case AttendeeVendorMarker.welcomeMessage:
            return null;
          case AttendeeVendorMarker.availableTime:
            return 'select a date in order to continue';
          case AttendeeVendorMarker.boothType:
            return 'select a booth type in order to continue';
          case AttendeeVendorMarker.customDocuments:
            return 'add a document then press Next to continue';
          case AttendeeVendorMarker.customLists:
          // TODO: Handle this case.
            break;
          case AttendeeVendorMarker.disclaimer:
            return null;
          case AttendeeVendorMarker.review:
            return null;
          case AttendeeVendorMarker.profileSelection:
            return 'select or create a new profile above';
          case AttendeeVendorMarker.selectPaymentMethod:
            return 'select or add a new card above';
          case AttendeeVendorMarker.applicationSent:
            return null;
          case null:
          // TODO: Handle this case.
            break;
        }
        return null;
      default:
        return null;
    }
    case NewAttendeeStepsMarker.addActivityRules:
      // TODO: Handle this case.
    case NewAttendeeStepsMarker.addActivityCustomRules:
      // TODO: Handle this case.
    case NewAttendeeStepsMarker.requestToJoinComplete:
      // TODO: Handle this case.
    case NewAttendeeStepsMarker.joinComplete:
      // TODO: Handle this case.
  }
}


Widget footerWidgetForNewAttendee(
    BuildContext context,
    DashboardModel model,
    bool isPreview,
    NewAttendeeStepsMarker marker,
    DiscountCode? discountCode,
    CardItem? cardItem,
    AttendeeVendorMarker? vendorAttendeeMarker,
    ActivityManagerForm activityForm,
    AttendeeFormState state,
    VendorMerchantForm? vendorForm,
    bool isSecondLast, {
      required Function() didSelectBack,
      required Function() didSelectNext,
      required Function() didSelectDisabledNext,
    }) {


    final double discountPercentage = (discountCode?.discountAmount ?? 1).toDouble();
    final double totalFee = ((attendeeVendorFee(state.attendeeItem.vendorForm?.boothPaymentOptions ?? [])).toDouble() + (attendeeVendorFee(state.attendeeItem.vendorForm?.boothPaymentOptions ?? [])*CICOBuyerPercentageFee).toDouble());
    double discountedTotal = totalFee * (1 - (discountPercentage / 100));

    final bool validDiscountCode = isDiscountCodeValid(vendorForm, discountCode?.codeId);

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
                visible: showBackButton(marker) && vendorAttendeeMarker != AttendeeVendorMarker.applicationSent,
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
              /// show pricing without discount
              Visibility(
                visible: activityRequiresVendorFee(state.attendeeItem.vendorForm) && state.attendeeItem.attendeeType == AttendeeType.vendor && validDiscountCode == false,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Vendor Fee', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,), maxLines: 1,),
                        Expanded(
                          child: Text(completeTotalPriceWithCurrency(totalFee,
                              activityForm.rulesService.currency), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold), maxLines: 1),
                        ),
                      ],
                    ),
                  ),
                ),
                /// show pricing with discount
                Visibility(
                  visible: activityRequiresVendorFee(state.attendeeItem.vendorForm) && state.attendeeItem.attendeeType == AttendeeType.vendor && validDiscountCode == true,
                  child: Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                          Expanded(
                            child: Text(completeTotalPriceWithCurrency(totalFee,
                                activityForm.rulesService.currency), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,  decoration: TextDecoration.lineThrough, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold), maxLines: 1),
                          ),
                          Expanded(
                            child: Text(completeTotalPriceWithCurrency(discountedTotal,
                                activityForm.rulesService.currency), style: TextStyle(color: Colors.green, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold), maxLines: 1),
                        ),
                      ]
                    )
                  )
                ),
              const SizedBox(width: 6),
              ],
            )
          ),

          Visibility(
            visible: state.isSubmitting == false && vendorAttendeeMarker != AttendeeVendorMarker.applicationSent,
            child: InkWell(
              onTap: () {
                if (isNextEnabled(marker, cardItem, vendorAttendeeMarker, vendorForm, state)) {
                  didSelectNext();
                } else {
                  didSelectDisabledNext();
                }
              },
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: 200
                ),
                height: 45,
                width: 185,
                decoration: BoxDecoration(
                  color: (isNextEnabled(marker, cardItem, vendorAttendeeMarker, vendorForm, state)) ? model.paletteColor : model.disabledTextColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
                child: Center(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                      isSecondLast ? (activityRequiresVendorFee(state.attendeeItem.vendorForm) && state.attendeeItem.attendeeType == AttendeeType.vendor) ? 'Check Out & Apply' : 'Apply' : getTitleForNextButton(marker),
                      style: TextStyle(color: (isNextEnabled(marker, cardItem, vendorAttendeeMarker, vendorForm, state)) ? model.accentColor : model.disabledTextColor,
                          fontSize: model.secondaryQuestionTitleFontSize,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, maxLines: 1),
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
}