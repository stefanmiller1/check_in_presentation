part of check_in_presentation;

class CreateNewVendorMerchant extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  final VendorMerchantForm? vendorForm;
  final AttendeeVendorMarker? currentVendorMarkerItem;
  final bool isPreview;
  final bool isFromInvite;

  const CreateNewVendorMerchant({Key? key, required this.model, required this.reservation, required this.activityForm, required this.resOwner, required this.isFromInvite, this.vendorForm, this.currentVendorMarkerItem, required this.isPreview}) : super(key: key);

  @override
  State<CreateNewVendorMerchant> createState() => _CreateNewVendorMerchantState();
}

class _CreateNewVendorMerchantState extends State<CreateNewVendorMerchant> {

  late PageController? pageController = null;
  ScrollController? _scrollController;
  NewAttendeeStepsMarker currentMarkerItem = NewAttendeeStepsMarker.getStarted;
  late AttendeeVendorMarker? currentVendorMarkerItem = widget.currentVendorMarkerItem;
  late MCCustomAvailability? selectedBoothAvailability = null;
  late DocumentFormOption? selectedDocumentFormOption = null;
  late bool isLoadingBoothOptions = false;
  late bool isLoadingDocumentOptions = false;
  late bool isLoading = false;


  List<NewAttendeeContainerModel> attendeeMainContainer(BuildContext context, UserProfileModel? user, List<EventMerchantVendorProfile> profiles, AttendeeFormState state) => [

    NewAttendeeContainerModel(
      markerItem: NewAttendeeStepsMarker.getStarted,
      subVendorMarkerItem: AttendeeVendorMarker.formMessage,
      childWidget: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.8,
                child: lottie.Lottie.asset(
                    height: 425,
                     repeat: false,
                    'assets/lottie_animations/q3nloTcuFQ.json'
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Welcome!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 5),
              Text('Complete this form to potentially join us as a vendor!', style: TextStyle(color: widget.model.disabledTextColor), textAlign: TextAlign.center),
            ]
          ),
        )
      )
    ),
    if (widget.vendorForm?.welcomeMessage != null) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        subVendorMarkerItem: AttendeeVendorMarker.welcomeMessage,
        childWidget: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 425,
                      child: Transform.scale(
                        scale: 1.85,
                        child: lottie.Lottie.asset(
                             repeat: false,
                            'assets/lottie_animations/uPJcPUOANE.json'
                        )
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Participating at ${widget.activityForm.profileService.activityBackground.activityTitle.value.fold((l) => 'our Activity', (r) => r)}!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 5),
                    Text(widget.vendorForm?.welcomeMessage ?? '', style: TextStyle(color: widget.model.disabledTextColor), textAlign: TextAlign.center),
            ]
          ),
        )
      )
    ),
    if (widget.vendorForm?.availableTimeSlots != null && widget.vendorForm?.availableTimeSlots?.where((element) => element.isConfirmed == true).isNotEmpty == true) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        subVendorMarkerItem: AttendeeVendorMarker.availableTime,
        childWidget: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Pick Your Dates!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                    ),
                    Text('Select at least one to continue..', style: TextStyle(color: widget.model.disabledTextColor)),
                    const SizedBox(height: 8),
                    if ((widget.vendorForm?.availableTimeSlots?.where((element) => element.isConfirmed == true).length ?? 0) >= 2) InkWell(
                      onTap: ()  {
                        late VendorMerchantForm? newVForm = state.attendeeItem.vendorForm;
                        final List<MCCustomAvailability> availability = [];
                        availability.addAll(state.attendeeItem.vendorForm?.availableTimeSlots ?? []);

                        for (MCCustomAvailability e in widget.vendorForm?.availableTimeSlots ?? []) {
                          if (availability.contains(e) == false) {
                            availability.add(e);
                          }
                        }

                        newVForm = newVForm?.copyWith(
                            availableTimeSlots: availability
                        );

                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateVendorForm(newVForm));
                        },
                        child: Chip(
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: widget.model.paletteColor,
                        avatar: Icon(CupertinoIcons.staroflife, color: widget.model.accentColor),
                      label: Text('Joining All!', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize))
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...widget.vendorForm?.availableTimeSlots?.where((element) => element.isConfirmed == true).toList().asMap().map((i, e) {
                        return MapEntry(i,
                          getVendorAvailableTimeSlot(
                            context,
                            widget.model,
                            e,
                            i,
                            (state.attendeeItem.vendorForm?.availableTimeSlots ?? []).contains(e) == true,
                            didSelectTimeOption: (time) {
                              late VendorMerchantForm? newVForm = state.attendeeItem.vendorForm;
                              final List<MCCustomAvailability> availability = [];
                              availability.addAll(state.attendeeItem.vendorForm?.availableTimeSlots ?? []);

                              if (availability.contains(e)) {
                                availability.remove(e);
                              } else {
                                availability.add(e);
                              }

                              newVForm = newVForm?.copyWith(
                                  availableTimeSlots: availability
                              );

                              context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateVendorForm(newVForm));

                            }
                          ),
                        );
                    }).values.toList() ?? [],
                    const SizedBox(height: 220)
            ]
          ),
        )
      )
    ),
    if (widget.vendorForm?.boothPaymentOptions != null && widget.vendorForm?.boothPaymentOptions?.isNotEmpty == true) NewAttendeeContainerModel(
      markerItem: NewAttendeeStepsMarker.getStarted,
      subVendorMarkerItem: AttendeeVendorMarker.boothType,
      childWidget: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Pick Your Booth!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                  ),
                  Visibility(
                    visible: state.attendeeItem.vendorForm?.availableTimeSlots?.isNotEmpty == true && widget.vendorForm?.availableTimeSlots != null,
                    child: Column(
                      children: [
                        Text('Select at least one booth from each time slot you would like to participate in to continue..', style: TextStyle(color: widget.model.disabledTextColor)),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 6,
                          spacing: 8,
                          children: state.attendeeItem.vendorForm?.availableTimeSlots?.where((element) => widget.vendorForm?.availableTimeSlots?.map((e) => e.uid).contains(element.uid) == true).toList().asMap().map((i, e) =>
                            MapEntry(i, headerTabItem(
                                widget.model,
                                e.uid == selectedBoothAvailability?.uid,
                                state.attendeeItem.vendorForm?.boothPaymentOptions?.map((e) => e.availabilityId).contains(e.uid) ?? false,
                                e.dateTitle ?? 'Slot ${i + 1}',
                                Icons.calendar_month_outlined,
                                didSelectItem: () {
                                  setState(() {
                                    isLoadingBoothOptions = true;
                                    selectedBoothAvailability = e;
                                  });

                                  Future.delayed(const Duration(milliseconds: 250), () {
                                    setState(() {
                                      isLoadingBoothOptions = false;
                                    });
                                  });
                                }
                              )
                            )
                          ).values.toList() ?? [],
                        ),
                        const SizedBox(height: 4),
                        Divider(
                            color: widget.model.disabledTextColor
                        ),
                        const SizedBox(height: 4),
                        if (isLoadingBoothOptions == true) Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                        ),

                        if (isLoadingBoothOptions == false) Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 6,
                          spacing: 8,
                          children: widget.vendorForm?.boothPaymentOptions?.where((element) => (element.unavailableBoothDates == null) || (element.unavailableBoothDates != null && element.unavailableBoothDates?.map((e) => e.uid).contains(selectedBoothAvailability?.uid) == false)).toList().asMap().map((j, f) {
                            return MapEntry(j, getBoothPaymentsOption(
                                  context,
                                  widget.model,
                                  f,
                                  widget.activityForm.rulesService.currency,
                                  state.attendeeItem.vendorForm?.boothPaymentOptions?.where((element) => element.uid == f.uid && element.availabilityId == selectedBoothAvailability?.uid).isNotEmpty == true,
                                  j,
                                  didSelectTimeOption: (booth) {

                                    late MVBoothPayments newBooth = booth;
                                    newBooth = newBooth.copyWith(
                                      availabilityId: selectedBoothAvailability?.uid
                                    );

                                    late VendorMerchantForm? newVForm = state.attendeeItem.vendorForm;
                                    final List<MVBoothPayments> booths = [];
                                    booths.addAll(state.attendeeItem.vendorForm?.boothPaymentOptions ?? []);


                                    if (booths.where((element) => element.uid == f.uid && element.availabilityId == selectedBoothAvailability?.uid).isNotEmpty) {
                                      booths.remove(newBooth);
                                    } else {
                                      booths.add(newBooth);
                                    }

                                    newVForm = newVForm?.copyWith(
                                        boothPaymentOptions: booths
                                    );

                                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateVendorForm(newVForm));

                                  }
                                ),
                              );
                            }
                          ).values.toList() ?? []
                        ),
                      ]
                    ),
                  ),

                  Visibility(
                    visible: state.attendeeItem.vendorForm?.availableTimeSlots?.isEmpty == true || widget.vendorForm?.availableTimeSlots == null || widget.vendorForm?.availableTimeSlots?.where((element) => element.isConfirmed == true).isEmpty == true,
                    child: Column(
                      children: [
                        Text('Select at least one booth to continue..', style: TextStyle(color: widget.model.disabledTextColor)),
                        const SizedBox(height: 8),

                        Wrap(
                          alignment: WrapAlignment.start,
                          runSpacing: 6,
                          spacing: 8,
                          children: widget.vendorForm?.boothPaymentOptions?.toList().asMap().map((i, e) {
                              return MapEntry(i, getBoothPaymentsOption(
                                  context,
                                  widget.model,
                                  e,
                                  widget.activityForm.rulesService.currency,
                                  state.attendeeItem.vendorForm?.boothPaymentOptions?.where((element) => element.uid == e.uid)?.isNotEmpty == true,
                                  i,
                                  didSelectTimeOption: (newBooth) {
                                     late VendorMerchantForm? newVForm = state.attendeeItem.vendorForm;
                                    final List<MVBoothPayments> booths = [];
                                    booths.addAll(state.attendeeItem.vendorForm?.boothPaymentOptions ?? []);


                                    if (booths.where((element) => element.uid == newBooth.uid).isNotEmpty) {
                                      booths.remove(newBooth);
                                    } else {
                                      booths.add(newBooth);
                                    }

                                    newVForm = newVForm?.copyWith(
                                        boothPaymentOptions: booths
                                    );

                                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateVendorForm(newVForm));

                                  }
                                ),
                              );
                            }
                          ).values.toList() ?? []
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 220)
            ]
          ),
        )
      )
    ),
    if (widget.vendorForm != null && isDocumentsOptionValid(widget.vendorForm!)) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        subVendorMarkerItem: AttendeeVendorMarker.customDocuments,
        childWidget: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Fill Out & Upload', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                    ),

                    if ((getDocumentsList(widget.vendorForm!) ?? []).length == 1) Visibility(
                      child: Column(
                        children: [
                          Text('Download then upload in order to continue..', style: TextStyle(color: widget.model.disabledTextColor)),
                          const SizedBox(height: 8),
                          documentDownloadUploadWidget(
                            context,
                            widget.model,
                            (getDocumentsList(widget.vendorForm) ?? []).first,
                            (getDocumentsList(state.attendeeItem.vendorForm) ?? []).isNotEmpty ? (getDocumentsList(state.attendeeItem.vendorForm) ?? []).first : null,
                            didSelectUpload: (refDoc) async {
                              late VendorMerchantForm? newVForm = state.attendeeItem.vendorForm;


                              late MVCustomOption? currentOption = getDocumentRuleOption(widget.vendorForm);
                              List<DocumentFormOption> documents = [];
                              documents.addAll(currentOption?.customRuleOption?.customDocumentOptions ?? []);


                              try {
                                DocumentFormOption newDocument = await FilePickerPreviewerWidget.handleFileSelection(context, widget.model);


                                newDocument = newDocument.copyWith(
                                  documentForm: ImageUpload(
                                        key: refDoc.documentForm.key,
                                        imageToUpload: newDocument.documentForm.imageToUpload,
                                  )
                                );


                                currentOption = currentOption?.copyWith(
                                    customRuleOption: currentOption.customRuleOption?.copyWith(
                                        customDocumentOptions: [newDocument]
                                    )
                                );

                                late List<MVCustomOption> customOptions = [];
                                customOptions.addAll(newVForm?.customOptions ?? []);

                                /// if empty add ... if not empty replace range
                                if (customOptions.map((e) => e.customRuleOption?.ruleId != null ? e.customRuleOption!.ruleId.getOrCrash() : null).contains('6e24dae0-96dd-11eb-babc-gykug7878f67') == false) {
                                  if (currentOption != null) {
                                    customOptions.add(currentOption);
                                  }
                                } else {
                                  if (currentOption != null) {
                                    final int index = customOptions.indexWhere((element) => element.customRuleOption?.ruleId == currentOption?.customRuleOption?.ruleId);
                                    customOptions.replaceRange(index, index + 1, [currentOption]);
                                  }
                                }

                                newVForm = newVForm?.copyWith(
                                  customOptions: customOptions
                                );


                                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateVendorForm(newVForm));
                                return;
                              } catch (e) {
                                final snackBar = SnackBar(
                                    elevation: 4,
                                    backgroundColor: widget.model.paletteColor,
                                    content: Text('cancelled', style: TextStyle(color: widget.model.webBackgroundColor))
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                            }
                          )
                        ]
                      )
                    ),


                    ///
                    if ((getDocumentsList(widget.vendorForm) ?? []).length > 1) Visibility(
                      visible: (getDocumentsList(widget.vendorForm) ?? []).length > 1,
                      child: Column(
                        children: [
                          Text('Upload a document for each in order to continue..', style: TextStyle(color: widget.model.disabledTextColor)),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.start,
                            runSpacing: 6,
                            spacing: 8,
                            children: getDocumentsList(widget.vendorForm)?.toList().asMap().map((i, e) =>
                                MapEntry(i, headerTabItem(
                                    widget.model,
                                    e == selectedDocumentFormOption,
                                    getDocumentsList(state.attendeeItem.vendorForm)?.map((e) => e.documentForm.key).contains(e.documentForm.key) ?? false,
                                    e.documentForm.key,
                                    Icons.sticky_note_2_outlined,
                                    didSelectItem: () {
                                      setState(() {
                                        isLoadingDocumentOptions = true;
                                        selectedDocumentFormOption = e;
                                      });

                                      Future.delayed(const Duration(milliseconds: 250), () {
                                        setState(() {
                                          isLoadingDocumentOptions = false;
                                        });
                                      });
                                    }
                                )
                                )
                            ).values.toList() ?? [],
                          ),
                          const SizedBox(height: 4),
                          Divider(
                              color: widget.model.disabledTextColor
                          ),
                          const SizedBox(height: 4),
                          if (isLoadingBoothOptions == true) Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                          ),

                          if (isLoadingBoothOptions == false && (getDocumentsList(widget.vendorForm) ?? []).where((element) => element.documentForm.key == selectedDocumentFormOption?.documentForm.key).isNotEmpty) documentDownloadUploadWidget(
                              context,
                              widget.model,
                              (getDocumentsList(widget.vendorForm) ?? []).where((element) => element.documentForm.key == selectedDocumentFormOption?.documentForm.key).first,
                              (getDocumentsList(state.attendeeItem.vendorForm) ?? []).where((element) => element.documentForm.key == selectedDocumentFormOption?.documentForm.key).isNotEmpty ?
                              (getDocumentsList(state.attendeeItem.vendorForm) ?? []).where((element) => element.documentForm.key == selectedDocumentFormOption?.documentForm.key).first : null,
                              didSelectUpload: (refDoc) async {

                                late VendorMerchantForm? newVForm = state.attendeeItem.vendorForm;
                                late MVCustomOption? newDocumentOption = getDocumentRuleOption(newVForm);


                                late MVCustomOption? currentOption = getDocumentRuleOption(widget.vendorForm);



                                try {
                                  DocumentFormOption newDocument = await FilePickerPreviewerWidget.handleFileSelection(context, widget.model);


                                  newDocument = newDocument.copyWith(
                                      documentForm: ImageUpload(
                                        key: refDoc.documentForm.key,
                                        imageToUpload: newDocument.documentForm.imageToUpload,
                                      )
                                  );


                                  List<DocumentFormOption> documents = [];
                                  documents.addAll(newDocumentOption?.customRuleOption?.customDocumentOptions ?? []);


                                  if (newDocumentOption?.customRuleOption?.customDocumentOptions?.map((e) => e.documentForm.key).contains(newDocument.documentForm.key) == true) {
                                    final int index = documents.indexWhere((element) => element.documentForm.key == newDocument.documentForm.key);
                                    documents.replaceRange(index, index + 1, [newDocument]);
                                  } else {
                                    documents.add(newDocument);
                                  }

                                  currentOption = currentOption?.copyWith(
                                      customRuleOption: currentOption.customRuleOption?.copyWith(
                                          customDocumentOptions: documents
                                      )
                                  );

                                  late List<MVCustomOption> customOptions = [];
                                  customOptions.addAll(newVForm?.customOptions ?? []);

                                  /// if empty add ... if not empty replace range
                                  if (customOptions.map((e) => e.customRuleOption?.ruleId != null ? e.customRuleOption!.ruleId.getOrCrash() : null).contains('6e24dae0-96dd-11eb-babc-gykug7878f67') == true) {
                                    if (currentOption != null) {
                                      final int index = customOptions.indexWhere((element) => element.customRuleOption?.ruleId == currentOption?.customRuleOption?.ruleId);
                                      customOptions.replaceRange(index, index + 1, [currentOption]);
                                    }
                                  } else {
                                    if (currentOption != null) {
                                      customOptions.add(currentOption);
                                    }
                                  }

                                  newVForm = newVForm?.copyWith(
                                      customOptions: customOptions
                                  );

                                  context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateVendorForm(newVForm));
                                  return;
                                } catch (e) {
                                  print(e);
                                  final snackBar = SnackBar(
                                      elevation: 4,
                                      backgroundColor: widget.model.paletteColor,
                                      content: Text('cancelled', style: TextStyle(color: widget.model.webBackgroundColor))
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }
                          )
                        ]
                      )
                    ),
                    const SizedBox(height: 220)
            ]
          ),
        )
      )
    ),
    if (widget.vendorForm?.disclaimerOptions != null && widget.vendorForm?.disclaimerOptions?.isNotEmpty == true) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        subVendorMarkerItem: AttendeeVendorMarker.disclaimer,
        childWidget: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 18),
                    Icon(Icons.info_outline, size: 70, color: widget.model.paletteColor),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('F.Y.I', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                          color: widget.model.disabledTextColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ...widget.vendorForm?.disclaimerOptions?.toList().asMap().map((i, e) {

                                if (e.customRuleOption?.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-bjhv7iuih8i8' && (e.customRuleOption?.checkBoxRuleOption?.where((element) => element.labelForRequirement.boolItem == true).isNotEmpty == true)) {
                                  return MapEntry(
                                    i, SlideInTransitionWidget(
                                    durationTime: 300 * i,
                                    offset: Offset(0, 0.25),
                                    transitionWidget: ListTile(
                                      title: Text(e.customRuleOption!.customRuleTitleLabel, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                      leading: Icon(getIconForCustomOptions(e.customRuleOption!.ruleId.getOrCrash()), color: widget.model.paletteColor),
                                      subtitle: Text(e.customRuleOption?.checkBoxRuleOption?.firstWhere((element) => element.labelForRequirement.boolItem == true).labelForRequirement.stringItem ?? '', style: TextStyle(color: widget.model.paletteColor))
                                      ),
                                    ),
                                  );
                                } else {
                                return MapEntry(i, SlideInTransitionWidget(
                                  durationTime: 300 * i,
                                  offset: Offset(0, 0.25),
                                  transitionWidget: ListTile(
                                    title: Text(e.customRuleOption!.customRuleTitleLabel, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                    leading: Icon(getIconForCustomOptions(e.customRuleOption!.ruleId.getOrCrash()), color: widget.model.paletteColor),
                                    subtitle: (e.customRuleOption!.labelTextRuleOption != null) ? Text(e.customRuleOption!.labelTextRuleOption!.titleLabel, style: TextStyle(color: widget.model.paletteColor)) : (e.customRuleOption?.checkBoxRuleOption?.isNotEmpty == true) ? Column(children: e.customRuleOption?.checkBoxRuleOption?.map((f) => Text(f.labelForRequirement.stringItem, style: TextStyle(color: widget.model.paletteColor))).toList() ?? []) : null,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ).values.toList() ?? [],
                          ],
                        ),
                      )
                    ),
                    /// select agree to continue...

                    /// press aggree

                    const SizedBox(height: 90)
                  ]
          ),
        )
      )
    ),

    NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        subVendorMarkerItem: AttendeeVendorMarker.profileSelection,
        childWidget: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// if post clarify that once it's because you expect to be a vendor for this activity.
              /// planning to be a vendor?
              ListTile(
                title: Text('Select a Profile Below', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                subtitle: Text('If you\'re expecting to be a vendor then please join using your vendor profile'),
              ),
              if (profiles.isNotEmpty) Column(
                children: [
                  ...profiles.map(
                    (e) => InkWell(
                      onTap: () {
                        if (state.attendeeItem.eventMerchantVendorProfile == e.profileId) {
                          context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateMerchantVendorProfileId(null));
                         } else {
                          context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateMerchantVendorProfileId(e.profileId));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: (state.attendeeItem.eventMerchantVendorProfile != null) ? Border.all(color: widget.model.paletteColor) : null
                            ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: widget.model.accentColor,
                            ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: getVendorMerchProfileHeader(
                                  widget.model,
                                  true,
                                  e,
                                  0,
                                  didSelectShare: () {

                                  },
                                  didSelectAddPartners: () {

                                  },
                                  didSelectEdit: () {

                                  },
                                ),
                              )
                            ),
                          )
                        ),
                      ),
                    )
                  ).toList(),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      if (user != null) {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return Scaffold(
                              resizeToAvoidBottomInset: false,
                              appBar: AppBar(
                                backgroundColor: widget.model.mobileBackgroundColor,
                                elevation: 0,
                                title: const Text('Profile'),
                                titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                                centerTitle: true,
                              ),
                              body: ProfileMainContainer(
                                model: widget.model,
                                currentUserProfile: user,
                              ),
                            );
                         })
                        );
                      }
                    },
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 300
                      ),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text('Create Vendor Profile', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                      )),
                    ),
                  ),
                ]
              ),
              /// create new profile from your profiles page
              if (profiles.isEmpty) InkWell(
                onTap: () {
                  if (user != null) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return Scaffold(
                          resizeToAvoidBottomInset: false,
                          appBar: AppBar(
                            backgroundColor: widget.model.mobileBackgroundColor,
                            elevation: 0,
                            title: const Text('Profile'),
                            titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
                            centerTitle: true,
                          ),
                          body: ProfileMainContainer(
                            model: widget.model,
                            currentUserProfile: user,
                          ),
                        );
                      })
                    );
                  }
                },
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: 300
                  ),
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: widget.model.paletteColor,
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text('Create Vendor Profile', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                  )),
                ),
              ),
              const SizedBox(height: 110),
          ]
        )
      )
    ),

    NewAttendeeContainerModel(
      markerItem: NewAttendeeStepsMarker.getStarted,
      subVendorMarkerItem: AttendeeVendorMarker.review,
      childWidget: SingleChildScrollView(

      )
    ),


    // if (activityHasRules(widget.activityForm)) NewAttendeeContainerModel(
    //     markerItem: NewAttendeeStepsMarker.addActivityRules,
    //     childWidget: rulesToAdd(
    //         context,
    //         widget.model,
    //         widget.activityForm.rulesService.ruleOption.getOrCrash(),
    //         widget.resOwner
    //     )
    // ),

    // /// if no fee required to be a vendor
    // if (activityRequiresVendorFee(state.attendeeItem.vendorForm) == false) NewAttendeeContainerModel(
    //     markerItem: NewAttendeeStepsMarker.joinComplete,
    //     childWidget: newAttendeeJoinCompleted(
    //         context,
    //         widget.model,
    //         didSelectComplete: () {
    //           context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
    //           if (user != null) context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(user, '', '', ''));
    //     }
    //   )
    // )
  ];


  @override
  void initState() {
    _scrollController = ScrollController();
    // currentMarkerItem = getInitialContainerForNewAffiliateAttendee(widget.activityForm);
    currentVendorMarkerItem = widget.currentVendorMarkerItem ?? AttendeeVendorMarker.formMessage;

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }


  void _handleCreateCheckOutForWeb(BuildContext context, UserProfileModel currentUser) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        width: 600,
                        height: 750,
                        child: WebCheckOutPaymentWidget(
                            model: widget.model,
                            currentUser: currentUser,
                            ownerUser: widget.resOwner,
                            reservation: widget.reservation,
                            amount: completeTotalPriceForCheckoutFormat(
                                (widget.activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantFee ?? 0) +
                                (widget.activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantFee ?? 0)*CICOReservationPercentageFee +
                                (widget.activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantFee ?? 0)*CICOTaxesFee, widget.activityForm.rulesService.currency),
                            currency: widget.activityForm.rulesService.currency,
                            description: 'Fee to cover the cost for participating as a vendor.',
                            didFinishPayment: (e) {

                              context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingTicketAttendeeWeb(e));
                              // widget.didSelectBack();
                            },
                            didPressFinished: () {
                              Navigator.of(context).pop();
                            },
                        )
                    )
                )
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(
              dart.optionOf(AttendeeItem(
                  attendeeId: UniqueId(),
                  attendeeOwnerId: UniqueId.fromUniqueString(facade.FirebaseChatCore.instance.firebaseUser?.uid ?? ''),
                  reservationId: widget.reservation.reservationId,
                  cost: '',
                  paymentStatus: PaymentStatusType.noStatus,
                  attendeeType: AttendeeType.vendor,
                  paymentIntentId: '',
                  contactStatus: ContactStatus.joined,
                  dateCreated: DateTime.now(),
                  vendorForm: VendorMerchantForm.empty()
                )
              ),
              dart.optionOf(widget.reservation),
              dart.optionOf(widget.activityForm),
              dart.optionOf(widget.resOwner))
            ),
        child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
        listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
          listener: (context, state) {


          if (activityRequiresVendorFee(widget.vendorForm)) {
            state.authPaymentFailureOrSuccessOption.fold(() {},
                    (either) => either.fold(
                        (failure) {
                      final snackBar = SnackBar(
                          backgroundColor: widget.model.webBackgroundColor,
                          content: failure.maybeMap(
                            paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                            orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                        (_) => null
                )
            );

            state.authFailureOrSuccessPaymentOption.fold(() {},
                    (either) => either.fold((failure) {
                  final snackBar = SnackBar(
                      backgroundColor: widget.model.webBackgroundColor,
                      content: failure.maybeMap(
                        ticketsNoLongerAvailable: (e) => Text('Sorry, the tickets you selected are no longer available'),
                        ticketLimitReached: (e) => (e.failedTicket != null && e.failedTicket!.reservationTimeSlot != null) ? Text('Your ${e.failedTicket!.ticketTitle ?? 'Ticket'} for ${DateFormat.jm().format(e.failedTicket!.reservationTimeSlot!.slotRange.start)} - ${DateFormat.jm().format(e.failedTicket!.reservationTimeSlot!.slotRange.end)} only has ${e.ticketsRemaining ?? 0} remaining', style: TextStyle(color: widget.model.disabledTextColor))
                            : Text('Sorry, There are not enough tickets left. Only ${e.ticketsRemaining ?? 0} Left', style: TextStyle(color: widget.model.disabledTextColor)),
                        attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                        attendeePermissionDenied: (e) => Text('Sorry, you dont have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                        orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }, (currentUser) {


                  if (kIsWeb) {
                    _handleCreateCheckOutForWeb(context, currentUser);
                  } else {
                    /// TODO: - hold attendee tickets
                    context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingTicketAttendee(currentUser, completeTotalPriceForCheckoutFormat(
                            (widget.activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantFee ?? 0) +
                            (widget.activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantFee ?? 0)*CICOReservationPercentageFee +
                            (widget.activityForm.profileService.activityRequirements.eventActivityRulesRequirement?.merchantFee ?? 0)*CICOTaxesFee, widget.activityForm.rulesService.currency),
                        widget.activityForm.rulesService.currency,
                        null));
                  }
                }
              )
            );
          }

          state.authFailureOrSuccessOption.fold(
                  () {},
                  (either) => either.fold((failure) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: failure.maybeMap(
                      attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                      attendeePermissionDenied: (e) => Text('Sorry, you dont have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
                      orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }, (_) {
                final snackBar = SnackBar(
                    elevation: 4,
                    backgroundColor: widget.model.paletteColor,
                    content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (widget.isFromInvite == false) {
                  Navigator.of(context).pop(context);
                } else {

                }
            }));
        },
        buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
        builder: (context, state) {

          return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                toolbarHeight: 90,
                automaticallyImplyLeading: false,
                titleTextStyle: TextStyle(color: widget.model.paletteColor),
                title: Text('Join as a Vendor', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                elevation: 0,
                centerTitle: true,
                backgroundColor: widget.model.paletteColor,
                leadingWidth: 70,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(15),
                  child: Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    // color: widget.model.paletteColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: attendeeMainContainer(context, null, [], state).toList().asMap().map(
                              (i, e) {
                                late bool vendorMarkerIsSelected = (e.subVendorMarkerItem != null && e.subVendorMarkerItem == currentVendorMarkerItem);
                                late bool markerIsSelected = e.markerItem == currentMarkerItem;


                                return MapEntry(i, Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.transparent,
                                          border: (vendorMarkerIsSelected && markerIsSelected) ? Border.all(color: widget.model.accentColor.withOpacity(0.35)) : null
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.5),
                                          child: Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: (vendorMarkerIsSelected && markerIsSelected) ? widget.model.accentColor : widget.model.accentColor.withOpacity(0.35)
                                      )
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      ).values.toList(),
                    ),
                  )
                ),
                leading: Center(
                  child: retrieveUserProfile(
                    widget.resOwner.userId.getOrCrash(),
                    widget.model,
                    widget.model.paletteColor,
                    null,
                    null,
                    profileType: UserProfileType.nameAndEmail,
                    trailingWidget: null,
                    selectedButton: (e) {
                    },
                  ),
                ),
                actions: [
                  if (currentMarkerItem != NewAttendeeStepsMarker.joinComplete || currentMarkerItem != NewAttendeeStepsMarker.requestToJoinComplete) Visibility(
                    visible: state.isSubmitting == false,
                    child: Visibility(
                      visible: widget.isFromInvite == false,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.cancel_outlined, color: widget.model.accentColor),
                        padding: EdgeInsets.only(right: 18),
                      )
                    ),
                  )
                ],
              ),
            body: Stack(
              children: [
                Container(
                    color: widget.model.webBackgroundColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height
                ),

                retrieveAuthenticationState(context, state),


                if (state.isSubmitting) SizedBox(
                    height: 220,
                    child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                ),

              ]
            )
          );
        }
      )
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, AttendeeFormState state) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) {
                return getVendorProfileList(context, state, item.profile);
              },
              orElse: () => GetLoginSignUpWidget(model: widget.model, didLoginSuccess: () {  },)
          );
        },
      ),
    );
  }

  Widget getVendorProfileList(BuildContext context, AttendeeFormState state, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchCurrentUsersMerchVendorList(currentUser.userId.getOrCrash())),
      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
        builder: (context, venState) {
          return venState.maybeMap(
              loadCurrentUserVendorMerchListSuccess: (list) => getMainContainer(context, state, currentUser, list.items),
              orElse: () => getMainContainer(context, state, currentUser, [])
          );
        },
      ),
    );
  }


  Widget getMainContainer(BuildContext context, AttendeeFormState state, UserProfileModel currentUser, List<EventMerchantVendorProfile> profiles) {

    // late int initialVendorIndex = e.markerItem == currentMarkerItem;

    /// TODO: do i exists (from the current selected available options) in the current provided available options - if no then re-update selecetedAvailability?
    if (selectedBoothAvailability == null && state.attendeeItem.vendorForm?.availableTimeSlots != null && state.attendeeItem.vendorForm?.availableTimeSlots?.isNotEmpty == true) {
      selectedBoothAvailability = state.attendeeItem.vendorForm?.availableTimeSlots?.first;
    }

    pageController = PageController(initialPage: 0);


    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),

        if (state.isSubmitting == false) IgnorePointer(
          ignoring: widget.isPreview,
          child: CreateNewMain(
              isPreviewer: false,
              model: widget.model,
              isLoading: isLoading,
              pageController: pageController,
              onPageChanged: (index) {
                setState(() {
                    currentVendorMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].subVendorMarkerItem;
                    currentMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].markerItem;
                });
              },
              child: attendeeMainContainer(
                  context,
                  currentUser,
                  profiles,
                  state
            )
          ),
        ),

        ClipRRect(
            child: BackdropFilter(
                filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: widget.model.accentColor.withOpacity(0.5),
                  child: footerWidgetForNewAttendee(
                    context,
                    widget.model,
                    widget.isPreview,
                    currentMarkerItem,
                    currentVendorMarkerItem,
                    widget.activityForm,
                    state,
                    widget.vendorForm,
                    attendeeMainContainer(context, currentUser, profiles, state).last.markerItem == currentMarkerItem && (currentVendorMarkerItem != null) ? attendeeMainContainer(context, currentUser, profiles, state).last.subVendorMarkerItem == currentVendorMarkerItem : true,
                    didSelectBack: () {

                      setState(() {
                        isLoading = true;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        final currentIndex = attendeeMainContainer(context, currentUser, profiles, state).indexWhere((element) => element.markerItem == currentMarkerItem && element.subVendorMarkerItem == currentVendorMarkerItem);

                        if (currentIndex != 0) {
                          if (pageController?.positions.isNotEmpty == true) {
                            pageController?.animateToPage(currentIndex - 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          }
                        }

                        if (currentIndex == 0) {
                          if (widget.isFromInvite) {
                            final snackBar = SnackBar(
                                elevation: 4,
                                backgroundColor: widget.model.paletteColor,
                                content: Text('To Accept your Invite, please fill out the info above.', style: TextStyle(color: widget.model.webBackgroundColor))
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else {
                            Navigator.of(context).pop();
                          }
                        } else {

                          final NewAttendeeStepsMarker previousIndexItem = attendeeMainContainer(context, currentUser, profiles, state)[currentIndex - 1].markerItem;
                          final previousVendorIndexItem = attendeeMainContainer(context, currentUser, profiles, state)[currentIndex - 1].subVendorMarkerItem;
                          currentVendorMarkerItem = previousVendorIndexItem;
                          currentMarkerItem = previousIndexItem;
                        }
                      });
                    },
                    didSelectNext: () {

                      setState(() {
                        // check current index in array
                        isLoading = true;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        final currentIndex = attendeeMainContainer(context, currentUser, profiles, state).indexWhere((element) => element.markerItem == currentMarkerItem && element.subVendorMarkerItem == currentVendorMarkerItem);
                        if (pageController?.positions.isNotEmpty == true) {
                          pageController?.animateToPage(currentIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                        }
                        /// get item at index + 1

                        if (currentIndex == (attendeeMainContainer(context, currentUser, profiles, state).length - 1)) {
                          if (kIsWeb) {
                            context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
                          }
                          context.read<AttendeeFormBloc>().add(AttendeeFormEvent.checkVendorLimits(currentUser));
                        } else {

                          final previousVendorIndexItem = attendeeMainContainer(context, currentUser, profiles, state)[currentIndex + 1].subVendorMarkerItem;
                          final NewAttendeeStepsMarker nextIndexItem = attendeeMainContainer(context, currentUser, profiles, state)[currentIndex + 1].markerItem;

                          currentVendorMarkerItem = previousVendorIndexItem;
                          currentMarkerItem = nextIndexItem;
                          }
                      });


                },
              ),
            )
          )
        )
      ],
    );
  }
}