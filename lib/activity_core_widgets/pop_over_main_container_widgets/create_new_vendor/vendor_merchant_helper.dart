part of check_in_presentation;

bool isDocumentsOptionValid(VendorMerchantForm form) {
  if (form.customOptions?.isNotEmpty == true) {
    if (form.customOptions?.map((e) => e.customRuleOption?.ruleId.getOrCrash()).contains('6e24dae0-96dd-11eb-babc-gykug7878f67') == true) {
      if (form.customOptions?.where((element) => (element.customRuleOption != null) && element.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67').isNotEmpty == true) {
        return form.customOptions?.firstWhere((element) => (element.customRuleOption != null) && element.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67').customRuleOption?.customDocumentOptions?.isNotEmpty == true;
        }
      }
    }
  return false;
}

List<DocumentFormOption>? getDocumentsList(VendorMerchantForm? form) {
  if (form?.customOptions?.where((element) => (element.customRuleOption != null) && element.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67').isNotEmpty == true) {
    return form?.customOptions?.firstWhere((element) => (element.customRuleOption != null) && element.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67').customRuleOption?.customDocumentOptions;
  }
  return null;
}

MVCustomOption? getDocumentRuleOption(VendorMerchantForm? form) {
  if (form?.customOptions?.where((element) => (element.customRuleOption != null) && element.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67').isNotEmpty == true) {
    return form?.customOptions?.firstWhere((element) => (element.customRuleOption != null) && element.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67');
  }
  return null;
}

Widget getVendorAvailableTimeSlot(
    BuildContext context,
    DashboardModel model,
    MCCustomAvailability timeOption,
    int index,
    bool isSelected,
  {required Function(MCCustomAvailability) didSelectTimeOption}) {

  return SlideInTransitionWidget(
      durationTime: 300 * index,
      offset: Offset(0, 0.25),
      transitionWidget: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index != 0) Divider(
          color: model.disabledTextColor
        ),
        const SizedBox(height: 4),
        Container(
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
                  didSelectTimeOption(timeOption);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.calendar_today, size: 45, color: isSelected ? model.paletteColor : model.disabledTextColor),
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
                                if (timeOption.dateTitle != null) Visibility(
                                  visible: timeOption.dateTitle != null,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(timeOption.dateTitle!, style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (timeOption.dateTitle == null) Visibility(
                                  visible: timeOption.dateTitle == null,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 4),
                                        Text('Slot ${index + 1}', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (timeOption.slotDescription != null) Visibility(
                                  visible: timeOption.slotDescription != null,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 4),
                                        Text(timeOption.slotDescription!, style: TextStyle(color: model.disabledTextColor)),
                                      ]
                                    ),
                                  )
                                ),
                                if (timeOption.slotDescription == null) Visibility(
                                    visible: timeOption.slotDescription == null,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Column(
                                          children: [
                                            const SizedBox(height: 4),
                                            Text('Select this time slot to participate on these dates!', style: TextStyle(color: model.disabledTextColor)),
                                      ]
                                    ),
                                  )
                                ),
                                const SizedBox(height: 4),
                                Wrap(
                                    spacing: 4.0,
                                    runSpacing: 4.0,
                                    children: timeOption.selectedSlotItem.map(
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
                                                  child: Text('${DateFormat.yMMMd().format(e.selectedDate)}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                        )
                                      )
                                    )
                                  ).toList()
                                ),
                              ]
                            )
                          )
                        ]
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (timeOption.vendorType != null && timeOption.vendorType!.isNotEmpty) Visibility(
          visible: timeOption.vendorType != null && timeOption.vendorType!.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 6,
              spacing: 8,
              children: timeOption.vendorType!.map((e) => Container(
                  decoration: BoxDecoration(
                      color:  model.paletteColor,
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(getVendorMerchTitle(e), style: TextStyle(color: model.accentColor)),
                  )
                ),
              ).toList()
            ),
          )
        ),
        const SizedBox(height: 4),

      ],
    ),
  );
}


Widget getBoothPaymentsOption(
    BuildContext context,
    DashboardModel model,
    MVBoothPayments booth,
    String currency,
    bool isSelected,
    int index,
    {required Function(MVBoothPayments) didSelectTimeOption}) {

  return SlideInTransitionWidget(
          durationTime: 300 * index,
         offset: Offset(0, 0.25),
            transitionWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 4),
                  Container(
                    width: 135,
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
                            didSelectTimeOption(booth);
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 4),
                              Text(booth.boothTitle ?? 'Booth ${index + 1}', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                              Divider(
                                  color: model.disabledTextColor
                              ),
                              Icon(Icons.storefront, size: 45, color: isSelected ? model.paletteColor : model.disabledTextColor),
                              if (booth.isLimited == true) Visibility(
                                visible: booth.isLimited == true,
                                child: Container(

                                )
                              ),
                              if (booth.fee != null) Visibility(
                                visible: booth.fee != null,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: model.paletteColor,
                                      borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(completeTotalPriceWithCurrency(
                                        booth.fee!.toDouble() +
                                        booth.fee!.toDouble()*CICOReservationPercentageFee +
                                        booth.fee!.toDouble()*CICOTaxesFee, currency), style: TextStyle(color: model.accentColor, overflow: TextOverflow.fade), textAlign: TextAlign.center, maxLines: 1),
                                  )
                                )
                              ),
                              const SizedBox(height: 4),
                            ]
                          ),
                        ),
                      ),
                    )
                  ),
            /// show fee if applicable
            /// show number of slots remaining if almost full..percentage less than 85% left

      ],
    ),
  );
}


Widget headerTabItem(DashboardModel model, bool isSelected, bool isComplete, String title, IconData icon, {required Function() didSelectItem}) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: (isSelected) ? Border.all(color: model.paletteColor, width: 1.5) : null
      ),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: IntrinsicHeight(
          child: InkWell(
              onTap: () {
                didSelectItem();
              },
              child: Container(
                  width: 135,
                  decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        children: [
                          /// not complete
                          if (isComplete == true) Icon(Icons.check_circle, color: model.paletteColor),
                          /// complete
                          if (isComplete == false) Icon(Icons.cancel_outlined, color: model.paletteColor,),
                          const SizedBox(width: 5),
                          Expanded(child: Text(title, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 1)),
                          Icon(icon, color: model.paletteColor),

                        ]
                    ),
                  )
              )
          ),
        ),
      )
  );
}


Widget documentDownloadUploadWidget(BuildContext context, DashboardModel model, DocumentFormOption documentDownload, DocumentFormOption? documentUpload, {required Function(DocumentFormOption refDoc) didSelectUpload}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    children: [
        Container(
            decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.circular(25),
            ),
          // height: 65,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () async {
                FilePickerPreviewerWidget.didOpenDocument(context, documentDownload, model);
              },
              title: Text('Download Document', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
              leading: Icon(Icons.downloading, color: model.disabledTextColor),
            ),
          )
        ),
      const SizedBox(height: 18),
      if (documentUpload?.documentForm.imageToUpload == null || documentUpload?.documentForm.uriPath == null && documentUpload?.documentForm.imageToUpload == null) InkWell(
        onTap: () {
          didSelectUpload(documentDownload);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Icon(CupertinoIcons.tray_arrow_up, size: 80, color: model.disabledTextColor),
                  const SizedBox(height: 8),
                  Text('Upload Document', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                  const SizedBox(height: 8),
                  Text('Keep an eye Out! Please make sure to fill out this document out properly - the organizer will verify after you apply and may reject or require you to upload again after being accepted.', style: TextStyle(color: model.disabledTextColor)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          )
        ),
      ),

      if (documentUpload?.documentForm.imageToUpload != null || documentUpload?.documentForm.uriPath != null && documentUpload?.documentForm.imageToUpload == null) InkWell(
        onTap: () {
          didSelectUpload(documentDownload);
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(25),
            ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Icon(CupertinoIcons.check_mark_circled, size: 100, color: model.disabledTextColor),
              const SizedBox(height: 8),
              Text('Saved!', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
              /// preview upload
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: model.webBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    // height: 65,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () async {
                          FilePickerPreviewerWidget.didOpenDocument(context, documentUpload!, model);
                        },
                        title: Text('Preview Document', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                        leading: Icon(Icons.downloading, color: model.disabledTextColor),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: model.webBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    // height: 65,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () async {
                          didSelectUpload(documentDownload);
                        },
                        title: Text('Re-Upload Document', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                        leading: Icon(CupertinoIcons.tray_arrow_up, color: model.disabledTextColor),
                      ),
                    )
                ),
              ),
              const SizedBox(height: 30),
            ]
          )
        ),
      )
    ]
  );
}