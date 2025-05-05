part of check_in_presentation;

class VendorFormEditorWidget extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final ActivityManagerForm activityForm;
  final UserProfileModel resOwner;
  final ListingManagerForm listing;
  final VendorMerchantForm? form;
  final Function(VendorMerchantForm) isSaving;
  final Function(VendorMerchantForm) isPublishing;

  const VendorFormEditorWidget({super.key, required this.model, required this.reservation, this.form, required this.listing, required this.activityForm, required this.resOwner, required this.isSaving, required this.isPublishing});


  @override
  State<VendorFormEditorWidget> createState() => _VendorFormEditorWidgetState();
}

class _VendorFormEditorWidgetState extends State<VendorFormEditorWidget> {

  late ScrollController? _scrollController = null;
  late PageController? boothPaymentPageController = PageController(viewportFraction: 0.15);
  late PageController? availabilityPageController = PageController(viewportFraction: 0.175);
  late PageController? discountPageController = PageController(viewportFraction: 0.175);

  late PageController? openClosePageController = PageController(viewportFraction: 0.25);
  late bool isHovering = false;
  late bool reloadMain = false;
  late bool isLoadingAvailability = false;
  late bool isLoadingBoothPayments = false;
  late bool isLoadingDiscountCodes = false;
  late String? _selectedDiscountCode = null;
  late UniqueId? _selectedAvailableTime = null;
  late UniqueId? _selectedBoothPayments = null;

  late AttendeeVendorMarker? currentVendorMarkerItem = null;

  Map<String?, double> ruleIdToHeight = {
    '6e24dae0-96dd-11eb-babc-gykug7878f67': 225.0,
    '6e24dae0-96dd-11eb-babc-ghgv676f7676': 150.0,
    '6e24dae0-96dd-11eb-babc-joij90hh7hii': 95.0,
    '6e24dae0-96dd-11eb-babc-weifunbi938b': 165.0,
    '6e24dae0-96dd-11eb-babc-joijo909jioi' : 165.0,
    '6e24dae0-96dd-11eb-babc-bjhv7iuih8i8' : 110.0,
    '6e24dae0-96dd-11eb-babc-gyiugi7989h8' : 165.0,
    '6e24dae0-96dd-11eb-babc-iub9898h98hh' : 165.0,
    '6e24dae0-96dd-11eb-babc-gyug787gjhbh' : 165.0,
    '6e24dae0-96dd-11eb-babc-udbisud909d9' : 110.0
  };


  @override
  void initState() {
    _scrollController = ScrollController();

    if (widget.form != null) {
      initReload();
    }

    super.initState();
  }

  @override
  void dispose() {

    boothPaymentPageController?.dispose();
    availabilityPageController?.dispose();
    openClosePageController?.dispose();
    discountPageController?.dispose();
    _scrollController?.dispose();

    super.dispose();
  }

  void initReload() {
    reloadMain = true;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        reloadMain = false;
      });
    });
  }

  List<FormCreatorContainerModel> formOption(BuildContext context, double customOptionsHeight, double customDisclaimerHeight, VendorMerchantForm form, MCCustomAvailability? currentAvailability, MVBoothPayments? currentBoothPayment, DiscountCode? currentDiscounts, AutovalidateMode validator) => [
    FormCreatorContainerModel(
      formHeaderIcon: Icons.sticky_note_2_outlined,
      formHeaderTitle: 'Form Title',
      formHeaderSubTitle: 'Give this form a name',
      height: 120,
      formMainCreatorWidget: vendorFormTextField(
          context,
          widget.model,
          1,
          form.formTitle,
          'Make this form for specific types of vendors by adding a title',
          'Baked Goods Vendor Application...Clothing Vendor Application..',
          onChanged: (message) {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeFormTitle(message));
          }
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
        if (active) {
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeFormTitle(''));
        } else {
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeFormTitle(null));
        }
      },
      isActivated: form.formTitle != null,
    ),
    FormCreatorContainerModel(
        formHeaderIcon: Icons.favorite_border_rounded,
        formHeaderTitle: 'Welcome Message',
        errorMessage: 'Write something to welcome your vendors :)',
        showErrorMessage: validator == AutovalidateMode.always && !isWelcomeValid(form),
        height: 205,
        formMainCreatorWidget: vendorFormTextField(
            context,
            widget.model,
            3,
            form.welcomeMessage,
            'Greet potential applicants with a welcome message - let them get a feel for the market they are applying for.',
            'Just so you know...',
            onChanged: (message) {
              context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeWelcomeMessage(message));
            }
        ),
        showAddIcon: true,
        didSelectActivate: (active) {
          if (active) {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeWelcomeMessage(''));
          } else {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeWelcomeMessage(null));
          }
        },
      isActivated: form.welcomeMessage != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.timer_outlined,
      formHeaderTitle: 'Open & Closing Dates',
      formHeaderSubTitle: 'When will this form go live and when do you want it to be hidden?',
      height: 200,
      formMainCreatorWidget: openClosedDates(
          context,
          widget.model,
          form,
          DateTime.fromMillisecondsSinceEpoch(retrieveTimeStampForLastTimeSlot(widget.reservation.reservationSlotItem)),
          dateChanged: (newRange) {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeFormStartEndDates(newRange));
          }
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
        setState(() {
          if (active) {
            final DateTime resEndDate = DateTime.fromMillisecondsSinceEpoch(retrieveTimeStampForLastTimeSlot(widget.reservation.reservationSlotItem));
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeFormStartEndDates(DateTimeRange(start: DateTime.now(), end: resEndDate)));
          } else {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeFormStartEndDates(null));
          }
        });
      },
      isActivated: form.openCloseDates != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.calendar_month_outlined,
      formHeaderTitle: 'Available Times',
      formHeaderSubTitle: 'Use the Dates you have already reserved to create dates a vendor will be selling for',
      errorMessage: 'All your reservation dates have to be selected and confirmed before publishing.',
      showErrorMessage: validator == AutovalidateMode.always && !isAvailabilityValid(form, widget.reservation),
      isLoading: isLoadingAvailability,
      formSubHelper: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: pagingControllerForForm(
              context,
              widget.model,
              availabilityPageController,
              true,
              (getTotalSelectedSlotItems(form) == widget.reservation.reservationSlotItem.length || form.availableTimeSlots?.map((e) => e.isConfirmed).where((element) => element == false).isEmpty == false) ? false : true,
              85,
              isHovering,
              InkWell(
                onTap: () {
                  final customUID = UniqueId();
                  _selectedAvailableTime = customUID;
                  List<MCCustomAvailability> currentList = [];
                  currentList.addAll(form.availableTimeSlots?.toList() ?? []);
                  currentList.add(MCCustomAvailability(uid: customUID, selectedSlotItem: [], isConfirmed: false));
                  isLoadingAvailability = true;

                  context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeAvailableTimeOption(currentList));

                  Future.delayed(const Duration(milliseconds: 250), () {
                    setState(() {
                      isLoadingAvailability = false;
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: widget.model.accentColor,
                              borderRadius: BorderRadius.all(Radius.circular(25))
                          ),
                          height: 50,
                          width: 50,
                          child: Icon(Icons.add, color: widget.model.disabledTextColor),
                        ),
                      ),
                      Text('New', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))
                    ],
                  ),
                ),
              ),
              form.availableTimeSlots?.asMap().map((i ,e) => MapEntry(
                i,
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAvailableTime = e.uid;
                      isLoadingAvailability = true;

                      Future.delayed(const Duration(milliseconds: 250), () {
                        setState(() {
                          isLoadingAvailability = false;
                        });
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(35)),
                              border: (_selectedAvailableTime == e.uid) ? Border.all(color: widget.model.paletteColor) : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: widget.model.accentColor,
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                ),
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(child: Text(e.dateTitle ?? 'Slot ${i + 1}', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,))
                          ],
                        ),
                      ),
                    ),
                  )
                )
              ).values.toList() ?? [],
              didStartHover: (show) {
                setState(() {
                  isHovering = show;
                });
              },
              didSelectArrow: (forwardBack) {
                setState(() {
                  if (forwardBack) {
                    availabilityPageController?.animateTo((availabilityPageController?.offset ?? 0) + 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  } else {
                    availabilityPageController?.animateTo((availabilityPageController?.offset ?? 0) - 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  }
                });
              },
              didSelectRemove: (index) {
                List<MCCustomAvailability> currentList = [];
                currentList.addAll(form.availableTimeSlots?.toList() ?? []);
                currentList.removeAt(index);

                if (currentList.isNotEmpty) {
                _selectedAvailableTime = currentList.first.uid;
                }
                context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeAvailableTimeOption(currentList));
            }
          ),
      ),
      height: (currentAvailability?.isConfirmed == true) ? 870 : 350,
      formMainCreatorWidget: VendorFormAvailableTimesWidget(
          model: widget.model,
          reservation: widget.reservation,
          form: form,
          currentAvailability: currentAvailability,
          onChanged: (newAvailability) {
            final List<MCCustomAvailability> availabilities = [];
            availabilities.addAll(form.availableTimeSlots ?? []);

            final int index = availabilities.indexWhere((element) => element.uid == newAvailability.uid);
            availabilities.replaceRange(index, index + 1, [newAvailability]);

            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeAvailableTimeOption(availabilities));
        },
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
        if (active) {
          final customUID = UniqueId();
          _selectedAvailableTime = customUID;
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeAvailableTimeOption([
          MCCustomAvailability(uid: customUID, selectedSlotItem: [], isConfirmed: false)]));
        } else {
          didDeActivateSection(
            context,
            widget.model,
            'Remove this Setting?',
            'you will lose all info after turning this option off.',
            'Remove',
            didSelectDone: () {
              context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeAvailableTimeOption(null));
            }
          );
        }
      },
      isActivated: form.availableTimeSlots != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.storefront,
      formHeaderTitle: 'Booth/Payments',
      isLoading: isLoadingBoothPayments,
      formSubHelper: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: pagingControllerForForm(
            context,
            widget.model,
            boothPaymentPageController,
            true,
            true,
            85,
            isHovering,
            InkWell(
              onTap: () {
                final customUID = UniqueId();
                _selectedBoothPayments = customUID;
                List<MVBoothPayments> currentList = [];
                currentList.addAll(form.boothPaymentOptions?.toList() ?? []);
                currentList.add(MVBoothPayments(uid: customUID));
                isLoadingBoothPayments = true;

                context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeBoothPaymentOptions(currentList));

                Future.delayed(const Duration(milliseconds: 250), () {
                  setState(() {
                    isLoadingBoothPayments = false;
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        height: 50,
                        width: 50,
                        child: Icon(Icons.add, color: widget.model.disabledTextColor),
                      ),
                    ),
                    Text('New', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))
                  ],
                ),
              ),
            ),
            form.boothPaymentOptions?.map((e) => InkWell(
              onTap: () {
                setState(() {
                  _selectedBoothPayments = e.uid;
                  isLoadingBoothPayments = true;

                  Future.delayed(const Duration(milliseconds: 250), () {
                    setState(() {
                      isLoadingBoothPayments = false;
                    });
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                   borderRadius: BorderRadius.all(Radius.circular(35))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          border: (_selectedBoothPayments == e.uid) ? Border.all(color: widget.model.paletteColor) : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.model.accentColor,
                                borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                      Expanded(child: Text(e.boothTitle ?? 'Table 6 x 5\'', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,))
                    ],
                  ),
                ),
              ),
            )
            ).toList() ?? [],
            didStartHover: (show) {
              setState(() {
                isHovering = show;
              });
            },
            didSelectArrow: (forwardBack) {
              setState(() {
                if (forwardBack) {
                  boothPaymentPageController?.animateTo((boothPaymentPageController?.offset ?? 0) + 50, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                } else {
                  boothPaymentPageController?.animateTo((boothPaymentPageController?.offset ?? 0) - 50, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                }
              });
            },
            didSelectRemove: (index) {
              isLoadingBoothPayments = true;
              List<MVBoothPayments> currentList = [];
              currentList.addAll(form.boothPaymentOptions?.toList() ?? []);
              currentList.removeAt(index);

              if (currentList.isNotEmpty) {
                _selectedBoothPayments = currentList.first.uid;
              }
              context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeBoothPaymentOptions(currentList));
              Future.delayed(const Duration(milliseconds: 250), () {
                setState(() {
                  isLoadingBoothPayments = false;
                });
              });
            }
        ),
      ),
      height: (form.availableTimeSlots?.where((element) => element.isConfirmed == true).isNotEmpty == true) ? 500 : 400,
      formMainCreatorWidget: VendorFormBoothPaymentWidget(
        model: widget.model,
        reservation: widget.reservation,
        currentUser: widget.resOwner,
        form: form,
        currentBoothPayment: currentBoothPayment,
        activityForm: widget.activityForm,
        onChanged: (newBooth) {
          final List<MVBoothPayments> boothPayments = [];
          boothPayments.addAll(form.boothPaymentOptions ?? []);

          final int index = boothPayments.indexWhere((element) => element.uid == newBooth.uid);
          boothPayments.replaceRange(index, index + 1, [newBooth]);

          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeBoothPaymentOptions(boothPayments));
        },
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
        if (active) {
          final customUID = UniqueId();
          _selectedBoothPayments = customUID;
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeBoothPaymentOptions([MVBoothPayments(uid: customUID)]));
        } else {
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeBoothPaymentOptions(null));
        }
      },
      isActivated: form.boothPaymentOptions != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.pending_actions,
      formHeaderTitle: 'Custom Options',
      height: customOptionsHeight,
      formMainCreatorWidget: VendorFormCustomOptionsWidget(
        model: widget.model,
        form: form,
        onChanged: (value, option) {
          late List<MVCustomOption> customOptions = [];
          customOptions.addAll(form.customOptions ?? []);
          if (value) {
            customOptions.add(option);
          } else {
            customOptions.removeWhere((element) => element.customRuleOption?.ruleId == option.customRuleOption?.ruleId);
          }
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeCustomOptions(customOptions));
        },

        onChangedOptionItem: (newOption) {
        final List<MVCustomOption> options = [];
        options.addAll(form.customOptions ?? []);

        final int index = options.indexWhere((element) => element.customRuleOption?.ruleId == newOption.customRuleOption?.ruleId);
        options.replaceRange(index, index + 1, [newOption]);

        context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeCustomOptions(options));

        },
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
          if (active) {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeCustomOptions([]));
          } else {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeCustomOptions(null));
          }
        },
      isActivated: form.customOptions != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.info_outline,
      formHeaderTitle: 'Disclaimers',
      height: customDisclaimerHeight,
      errorMessage: 'Please make sure all additional settings are selected or filled out.',
      showErrorMessage: validator == AutovalidateMode.always && !isDisclaimerOptionValid(form),
      formMainCreatorWidget: VendorFormDisclaimerOptionsWidget(
          model: widget.model,
          form: form,
          onChanged: (value, option) {
            late List<MVCustomOption> customOptions = [];
            customOptions.addAll(form.disclaimerOptions ?? []);
            if (value) {
              customOptions.add(option);
            } else {
              customOptions.removeWhere((element) => element.customRuleOption?.ruleId == option.customRuleOption?.ruleId);
            }

            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDisclaimerOptions(customOptions));
          },
          oncChangedOptionItem: (newOption) {

            final List<MVCustomOption> options = [];
            options.addAll(form.disclaimerOptions ?? []);

            final int index = options.indexWhere((element) => element.customRuleOption?.ruleId == newOption.customRuleOption?.ruleId);
            options.replaceRange(index, index + 1, [newOption]);

            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDisclaimerOptions(options));

          },
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
        if (active) {
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDisclaimerOptions([]));
        } else {
          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDisclaimerOptions(null));
        }
      },
      isActivated: form.disclaimerOptions != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.monetization_on_outlined,
      formHeaderTitle: 'Discount Codes',
      formHeaderSubTitle: 'Give your applicants exclusive deals and discounts',
      errorMessage: 'Please make sure all vouchers are between 1 and 99 percent off',
      showErrorMessage: validator == AutovalidateMode.always && !isVoucherOptionsValid(form),
      isLoading: isLoadingDiscountCodes,
      height: 680,
      formSubHelper: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: pagingControllerForForm(
            context,
            widget.model,
            discountPageController,
            true,
            (getTotalSelectedSlotItems(form) == widget.reservation.reservationSlotItem.length || form.availableTimeSlots?.map((e) => e.isConfirmed).where((element) => element == false).isEmpty == false) ? false : true,
            85,
            isHovering,
            InkWell(
              onTap: () {
                final customUID = UniqueId().getOrCrash().substring(0, 5);
                _selectedDiscountCode = customUID;

                List<DiscountCode> currentList = [];
                currentList.addAll(form.discountOptions?.toList() ?? []);
                currentList.add(DiscountCode(codeId: customUID, discountAmount: 20, createdAt: DateTime.now()));
                isLoadingDiscountCodes = true;

                context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDiscountCodeOptions(currentList));

                Future.delayed(const Duration(milliseconds: 250), () {
                  setState(() {
                    isLoadingDiscountCodes = false;
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        height: 50,
                        width: 50,
                        child: Icon(Icons.add, color: widget.model.disabledTextColor),
                      ),
                    ),
                    Text('New', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))
                  ],
                ),
              ),
            ),
            form.discountOptions?.asMap().map((i ,e) => MapEntry(
                i,
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDiscountCode = e.codeId;
                      isLoadingDiscountCodes = true;

                      Future.delayed(const Duration(milliseconds: 250), () {
                        setState(() {
                          isLoadingDiscountCodes = false;
                        });
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(35)),
                              border: (_selectedDiscountCode == e.codeId) ? Border.all(color: widget.model.paletteColor) : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: widget.model.accentColor,
                                    borderRadius: BorderRadius.all(Radius.circular(25))
                                ),
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          Expanded(child: Text(e.discountTitle ?? 'Slot ${i + 1}', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,))
                        ],
                      ),
                    ),
                  ),
                )
              )
            ).values.toList() ?? [],
            didStartHover: (show) {
              setState(() {
                isHovering = show;
              });
            },
            didSelectArrow: (forwardBack) {
              setState(() {
                if (forwardBack) {
                  discountPageController?.animateTo((discountPageController?.offset ?? 0) + 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                } else {
                  discountPageController?.animateTo((discountPageController?.offset ?? 0) - 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                }
              });
            },
            didSelectRemove: (index) {
              isLoadingDiscountCodes = true;
              List<DiscountCode> currentList = [];
              currentList.addAll(form.discountOptions?.toList() ?? []);
              currentList.removeAt(index);

              if (currentList.isNotEmpty) {
                _selectedDiscountCode = currentList.first.codeId;
              }


              context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDiscountCodeOptions(currentList));

              Future.delayed(const Duration(milliseconds: 250), () {
                setState(() {
                  isLoadingDiscountCodes = false;
              });
            });
          }
        ),
      ),
      formMainCreatorWidget: DiscountCodeGeneratorWidget(
        model: widget.model,
        form: form,
        currentDiscountOption: currentDiscounts,
        onChange: (discount) {
          final List<DiscountCode> discounts = [];
          discounts.addAll(form.discountOptions ?? []);

          final int index = discounts.indexWhere((element) => element.codeId == discount.codeId);
          discounts.replaceRange(index, index + 1, [discount]);

          context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDiscountCodeOptions(discounts));
        }
      ),
      showAddIcon: true,
      didSelectActivate: (active) {
        setState(() {
          if (active) {
            final customUID = UniqueId().getOrCrash().substring(0, 5);
            _selectedDiscountCode = customUID;
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDiscountCodeOptions([DiscountCode(codeId: customUID, discountAmount: 20, createdAt: DateTime.now())]));
          } else {
            context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didChangeDiscountCodeOptions(null));
          }
        });
      },
      isActivated: form.discountOptions != null,
    ),
    FormCreatorContainerModel(
      formHeaderIcon: Icons.close,
      formHeaderTitle: 'Close Form',
      height: 0,
      formMainCreatorWidget: Container(),
      showAddIcon: true,
      didSelectActivate: (active) {
        setState(() {
          if (active) {
            context.read<VendorSettingsFormBloc>().add(const VendorSettingsFormEvent.didChangeFormStatus(FormStatus.closed));
          } else {
            context.read<VendorSettingsFormBloc>().add(const VendorSettingsFormEvent.didChangeFormStatus(FormStatus.inProgress));
          }
        });
      },
      isActivated: form.formStatus == FormStatus.closed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<VendorSettingsFormBloc>()..add(VendorSettingsFormEvent.initialVendorForm(dart.optionOf(widget.form ?? VendorMerchantForm.empty()))),
      child: BlocConsumer<VendorSettingsFormBloc, VendorSettingsFormState>(
        listenWhen: (p,c) => p.isPublishing != c.isPublishing,
        listener: (context, state) {


          state.authFailureOrSuccessOption.fold(
                  () {},
                  (either) => either.fold((failure) {
                final snackBar = SnackBar(
                    backgroundColor: widget.model.webBackgroundColor,
                    content: failure.maybeMap(
                      vendorServerError: (_) => Text('Please double check your form.', style: TextStyle(color: widget.model.disabledTextColor)),
                      orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                    ));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }, (_) {
                widget.isPublishing(state.vendorMerchantForm);
                Navigator.of(context).pop();
              }));
        },
        buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages || p.vendorMerchantForm != c.vendorMerchantForm || p.isEditingForm != c.isEditingForm || p.isPublishing != c.isPublishing,
        builder: (context, state) {

          double customOptionHeight = 135;
          state.vendorMerchantForm.customOptions?.where((e) => e.isActive == true).forEach((option) {
              customOptionHeight += ruleIdToHeight[(option.customRuleOption?.ruleId != null) ? option.customRuleOption!.ruleId.getOrCrash() : null] ?? 0;
          });

          double disclaimerOptionHeight = 618;

          state.vendorMerchantForm.disclaimerOptions?.where((e) => e.isActive == true).forEach((option) {
              disclaimerOptionHeight += ruleIdToHeight[(option.customRuleOption?.ruleId != null) ? option.customRuleOption!.ruleId.getOrCrash() : null] ?? 0;
          });

          final MCCustomAvailability? currentAvailability = (state.vendorMerchantForm.availableTimeSlots?.where((element) => element.uid == _selectedAvailableTime).isNotEmpty == true) ? state.vendorMerchantForm.availableTimeSlots?.where((element) => element.uid == _selectedAvailableTime).first : null;
          final MVBoothPayments? currentBoothPayments = (state.vendorMerchantForm.boothPaymentOptions?.where((element) => element.uid == _selectedBoothPayments).isNotEmpty == true) ? state.vendorMerchantForm.boothPaymentOptions?.where((element) => element.uid == _selectedBoothPayments).first : null;
          final DiscountCode? currentDiscount = (state.vendorMerchantForm.discountOptions?.where((element) => element.codeId == _selectedDiscountCode).isNotEmpty == true) ? state.vendorMerchantForm.discountOptions?.where((element) => element.codeId == _selectedDiscountCode).first : null;

          final bool isPublishedForm = widget.form?.formStatus == FormStatus.published;
          final bool isValidForm = isVendorFormValid(state.vendorMerchantForm, widget.reservation);
          final bool isNewForm = widget.form == null;


          if (_selectedBoothPayments == null && state.vendorMerchantForm.boothPaymentOptions?.isNotEmpty == true) {
            _selectedBoothPayments = state.vendorMerchantForm.boothPaymentOptions?.first.uid;
          }

          if (_selectedAvailableTime == null && state.vendorMerchantForm.availableTimeSlots?.isNotEmpty == true) {
            _selectedAvailableTime = state.vendorMerchantForm.availableTimeSlots?.first.uid;
          }

          if (_selectedDiscountCode == null && state.vendorMerchantForm.discountOptions?.isNotEmpty == true) {
            _selectedDiscountCode  = state.vendorMerchantForm.discountOptions?.first.codeId;
          }

          return Scaffold(
                appBar: AppBar(
                elevation: 0,
                toolbarHeight: 90,
                backgroundColor: widget.model.paletteColor,
                title: Column(
                  children: [
                    Text('Create New Vendor Form', style: TextStyle(color: widget.model.accentColor)),
                    const SizedBox(height: 5),
                    /// swap with periodic auto-saving
                    Text(state.vendorMerchantForm.formStatus.name, style: TextStyle(color: widget.model.accentColor, fontSize: 14))
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
                tooltip: 'Cancel',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: state.isPublishing ? [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: JumpingDots(numberOfDots: 3,  color: widget.model.paletteColor)
                )
              ] : [
                /// DO not auto-save if already published
                /// based on init form
                /// save (if not published)
                if (isNewForm || !(isPublishedForm)) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      widget.isSaving(state.vendorMerchantForm);
                    },
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: widget.model.accentColor
                        ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Save & Exit', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)),
                        )
                      )
                    ),
                  ),
                ),
                /// un-publish & save (if published not valid)...allow for
                if (!(isNewForm) && !(isValidForm) && isPublishedForm) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      widget.isSaving(state.vendorMerchantForm);
                    },
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: widget.model.accentColor
                        ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Un-Publish & Exit', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)),
                      ))
                    ),
                  ),
                ),
                /// publish
                if (isNewForm) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didFinishPublishing(widget.reservation));
                    },
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: (isValidForm) ? widget.model.accentColor : widget.model.disabledTextColor.withOpacity(0.085)
                        ),
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Publish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize, color: (isValidForm) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                        )
                      )
                    ),
                  ),
                ),
                /// if published update (on valid condition)
                /// show errors on publish attempt
                if (!(isNewForm)) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      context.read<VendorSettingsFormBloc>().add(VendorSettingsFormEvent.didFinishPublishing(widget.reservation));
                    },
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: (isValidForm) ? widget.model.accentColor : widget.model.disabledTextColor.withOpacity(0.085)
                        ),
                        child: Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(isPublishedForm ? 'Re-Publish' : 'Publish', style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize, color: (isValidForm) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                        )
                      )
                    ),
                  ),
                ),
              ],
              centerTitle: true,
            ),
            body: Form(
              autovalidateMode: state.showErrorMessages,
              child: (reloadMain) ? JumpingDots(numberOfDots: 3, color: widget.model.accentColor) : FormCreatorDashboardMain(
                model: widget.model,
                formContainerItem: formOption(
                    context,
                    customOptionHeight,
                    disclaimerOptionHeight,
                    state.vendorMerchantForm,
                    currentAvailability,
                    currentBoothPayments,
                    currentDiscount,
                    state.showErrorMessages),
                    showPreview: true,
                    previewFormWidget:  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Center(
                      child: Container(
                        height: 950,
                        width: ReservationHelperCore.previewerWidth - 65,
                        child: CreateNewVendorMerchant(
                          model: widget.model,
                          listingForm: widget.listing,
                          reservation: widget.reservation,
                          resOwner: widget.resOwner,
                          activityForm: widget.activityForm,
                          vendorForm: state.vendorMerchantForm,
                          currentVendorMarkerItem: currentVendorMarkerItem,
                          isFromInvite: false,
                          isPreview: false,
                      ),
                    ),
                  ),
                )
              ),
            ),
          );
        }
      )
    );
  }
}