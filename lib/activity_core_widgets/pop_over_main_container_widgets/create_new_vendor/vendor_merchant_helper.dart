part of check_in_presentation;

Widget vendorMerchantEditorContainer({required BuildContext context, required Uint8List? selectedImage, required EventMerchantVendorProfile? eventMerchantVendor, required ActivityManagerForm activityForm, required DashboardModel model, required AttendeeFormState state, required Function() handleImageSelection, required Function(String) didChangeVendorName, required Function(String) didChangeVendorInfo}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const SizedBox(height: 8),

          Text('Vendor\'s Logo*', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          Text('Please fill out everything with an * to continue.', style: TextStyle(color: model.disabledTextColor)),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              handleImageSelection();
            },
            child: CircleAvatar(
              radius: 80,
              foregroundImage: (selectedImage != null) ? Image.memory(selectedImage).image : null,
              backgroundImage: (eventMerchantVendor != null && eventMerchantVendor.uriImage != '') ? Image.network(eventMerchantVendor.uriImage).image : null,
              backgroundColor: model.webBackgroundColor,
              child: Icon(Icons.photo_camera_outlined, color: model.disabledTextColor, size: 45,),
            ),
          ),
          const SizedBox(height: 25),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vendor Brand Name*', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
              const SizedBox(height: 15),
              Container(
                child: TextFormField(
                    initialValue: eventMerchantVendor?.brandName.value.fold(
                            (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
                            (r) => r) ?? '',
                    maxLength: 32,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: model.disabledTextColor),
                      hintText: 'Vendor Name',
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: model.paletteColor,
                      ),
                      prefixIcon: Icon(Icons.account_circle_outlined, color: model.disabledTextColor),
                      filled: true,
                      fillColor: model.accentColor,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: model.paletteColor,
                        ),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: model.paletteColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          width: 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: model.disabledTextColor,
                          width: 0,
                        ),
                      ),
                    ),
                    autocorrect: false,
                    onChanged: (value) {
                      didChangeVendorName(value);
                    },
                    validator: (_) => eventMerchantVendor
                        ?.brandName
                        .value
                        .fold(
                            (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => null), orElse: () => null),
                            (r) => r
                    )
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('More Details about Vendor*', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
              const SizedBox(height: 15),
              Container(
                // width: 250,
                child: TextFormField(
                    initialValue: eventMerchantVendor?.backgroundInfo.value.fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                    maxLength: 300,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: model.disabledTextColor),
                      hintText: 'Vendor Info',
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: model.paletteColor,
                      ),
                      filled: true,
                      fillColor: model.accentColor,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          width: 2,
                          color: model.paletteColor,
                        ),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: model.paletteColor,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          width: 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: model.disabledTextColor,
                          width: 0,
                        ),
                      ),
                    ),
                    autocorrect: false,
                    onChanged: (value) {
                      didChangeVendorInfo(value);
                    },
                    validator: (_) => eventMerchantVendor
                        ?.backgroundInfo
                        .value
                        .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r
                    )
                ),
              ),

              if (activityRequiresVendorFee(activityForm)) Visibility(
                  visible: attendeeVendorIsValid(state.attendeeItem),
                  child: Column(
                    children: [
                      getPricingBreakDown(model, activityForm.profileService.activityRequirements.eventActivityRulesRequirement!.merchantFee!.toDouble(), 1, activityForm.rulesService.currency),
                      cancellationDetails(context, model, activityForm)
                  ],
                )
              ),

            ],
          ),
        ],
      ),
    ),
  );
}