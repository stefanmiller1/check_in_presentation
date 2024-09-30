part of check_in_presentation;

class ActivityApplicationSettingsWidget extends StatefulWidget {

  final DashboardModel model;
  final AttendeeItem attendeeItem;
  final ReservationItem reservationItem;
  final UserProfileModel activityOwnerProfile;
  final ActivityManagerForm activityManagerForm;

  const ActivityApplicationSettingsWidget({super.key, required this.model, required this.attendeeItem, required this.reservationItem, required this.activityOwnerProfile, required this.activityManagerForm});

  @override
  State<ActivityApplicationSettingsWidget> createState() => _ActivityApplicationSettingsWidgetState();
}

class _ActivityApplicationSettingsWidgetState extends State<ActivityApplicationSettingsWidget> {

  List<VendorContactDetail> selectedVendors = [];
  late String? currentEditingMode = null;
  final widthResponsive = 1340;

  void _handleApplicantMoreOptionsDropdownSelection(BuildContext context, VendorApplicationBoothOptions? selectedAction, UserProfileModel? userProfile, EventMerchantVendorProfile? profile, AttendeeItem currentAttendee, List<VendorContactDetail> booths) async {
    if (selectedAction == null) return;

    switch (selectedAction) {
      case VendorApplicationBoothOptions.selectAll:

        break;
      case VendorApplicationBoothOptions.previewPdf:
        if (currentAttendee.vendorForm == null) {
          return;
        }

        showSelectedDocumentButton(
            context,
            widget.model,
            getDocumentsList(currentAttendee.vendorForm!)?.toList() ?? []
        );
        break;
      case VendorApplicationBoothOptions.previewReceipt:
        if (userProfile == null || profile == null || currentAttendee.vendorForm == null) {
          return;
        }
        final invoiceNumber = await facade.AttendeeFacade.instance.getNumberOfAttending(attendeeOwnerId: currentAttendee.attendeeOwnerId.getOrCrash(), status: ContactStatus.joined, attendingType: AttendeeType.vendor, isInterested: null) ?? 1;
        final receiptPdf = await generateReceiptPdf(widget.activityManagerForm, widget.activityOwnerProfile, userProfile, profile, currentAttendee, invoiceNumber);
        final receiptDoc = [
          DocumentFormOption(
              documentForm: ImageUpload(
                  key: '',
                  imageToUpload: receiptPdf
              )
          )
        ];

        showSelectedDocumentButton(
            context,
            widget.model,
            receiptDoc
        );

        break;
      case VendorApplicationBoothOptions.previewRefund:
        // if (userProfile == null || profile == null || currentAttendee.vendorForm == null) {
        //   return;
        // }
        // final receiptPdf = await generateRefundPdf(widget.activityManagerForm, userProfile, profile, currentAttendee.vendorForm!);
        // final receiptDoc = [
        //   DocumentFormOption(
        //       documentForm: ImageUpload(
        //           key: '',
        //           imageToUpload: receiptPdf
        //       )
        //   )
        // ];
        // showSelectedDocumentButton(
        //     context,
        //     widget.model,
        //     receiptDoc
        // );
        break;
      case VendorApplicationBoothOptions.previewStatus:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(
        dart.optionOf(widget.attendeeItem),
        dart.optionOf(widget.reservationItem),
        dart.optionOf(widget.activityManagerForm),
        dart.optionOf(widget.activityOwnerProfile))
    ),
      child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
          listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
          listener: (context, state) {

            state.authRefundFailureOrSuccessOption.fold(
                    () => {},
                    (either) => either.fold(
                        (failure) {
                      final snackBar = SnackBar(
                          backgroundColor: Colors.red.shade100,
                          content: failure.maybeMap(
                            paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: Colors.red)),
                            orElse: () => Text('A Problem Happened', style: TextStyle(color: Colors.red)),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                        (_) => null
                )
            );

            state.authVendorPaymentFailureOrSuccessOption.fold(
                    () => {},
                    (either) => either.fold(
                        (failure) {
                      final snackBar = SnackBar(
                          backgroundColor: Colors.red.shade100,
                          content: failure.maybeMap(
                            ownerDoesNotHaveAccount: (_) => Text('${widget.activityOwnerProfile.legalName.getOrCrash()} is unable to accept payments. Please Contact Owner', style: TextStyle(color: Colors.red)),
                            paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: Colors.red)),
                            orElse: () => Text('A Problem Happened', style: TextStyle(color: Colors.red)),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                        (_) => null
                )
            );


            state.authFailureOrSuccessOption.fold(
                    () {},
                    (either) => either.fold((failure) {
                  final snackBar = SnackBar(
                      backgroundColor: widget.model.webBackgroundColor,
                      content: failure.maybeMap(
                        attendeeWaitingForPaymentConfirmation: (e) => Text('waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                        attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                        attendeePermissionDenied: (e) => Text('Sorry, you don\'t have permission to do that', style: TextStyle(color: widget.model.disabledTextColor)),
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

                }));
          },
          buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
            builder: (context, state) {
              if (state.isSubmitting == true) {
                selectedVendors.clear();
                return Scaffold(
                    appBar: (!(kIsWeb)) ? AppBar(
                        elevation: 0,
                        backgroundColor: widget.model.paletteColor,
                        automaticallyImplyLeading: false,
                        title: Text('Manage Application', style: TextStyle(color: widget.model.accentColor)),
                        centerTitle: true
                    ) : null,
                    body: Center(child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3))
                );
              }
              return BlocProvider(create: (context) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(widget.reservationItem.reservationId.getOrCrash(), widget.attendeeItem.attendeeOwnerId.getOrCrash())),
                  child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
                      builder: (context, state) {
                        return state.maybeMap(
                            attLoadInProgress: (_) => getLoadingForOverviewFooter(context),
                            /// earnings from all vendors
                            loadAttendeeItemSuccess: (attendee) {
                              return getContainerForAttendee(context, attendee.item);
                            },
                            /// no earnings yet.
                            orElse: () {
                              return  getContainerForAttendee(context, null);
                      }
                    );
                  }
                )
              );

        }
      )
    );
  }

  Widget getContainerForAttendee(BuildContext context, AttendeeItem? attendee) {
    if (kIsWeb) {
      return Stack(
        children: [
          Container(
              child: getVendorProfile(context, attendee ?? widget.attendeeItem)
          ),
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (currentEditingMode != null) {
                    currentEditingMode = null;
                  } else {
                    currentEditingMode = 'requested';
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(' Edit ', style: TextStyle(color: (currentEditingMode != null) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
              ),
            ),
          )
        ],
      );
    }
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: widget.model.paletteColor,
          automaticallyImplyLeading: false,
          title: Text('Manage Application', style: TextStyle(color: widget.model.accentColor)),
          centerTitle: true,
          leading: (kIsWeb) ? null : IconButton(
            icon: Icon(Icons.cancel, color: widget.model.accentColor),
            tooltip: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: (attendee != null) ? [
            Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (currentEditingMode != null) {
                      currentEditingMode = null;
                    } else {
                      currentEditingMode = 'requested';
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(' Edit ', style: TextStyle(color: (currentEditingMode != null) ? widget.model.accentColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] : null,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.model.webBackgroundColor
          ),
          child: getVendorProfile(context, attendee ?? widget.attendeeItem),
          /// profile
          /// sections of each vendor booth option
          /// edit
        )
    );
  }

  Widget getVendorProfile(BuildContext context, AttendeeItem attendee) {
    if (widget.attendeeItem.eventMerchantVendorProfile != null) {
      return BlocProvider(create: (context) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchAllEventMerchProfileFromIds([widget.attendeeItem.eventMerchantVendorProfile!.getOrCrash()])),
        child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadAllMerchVendorFromIdsSuccess: (items) {
                    if (items.items.isNotEmpty) {
                      return getCurrentUserProfile(context, attendee, items.items.first);
                    }
                    return getCurrentUserProfile(context, attendee, null);
                  },
                  orElse: () => getCurrentUserProfile(context, attendee, null)
              );
            }
        ),
      );
    } else {
      return getCurrentUserProfile(context, attendee, null);
    }
  }

  Widget getCurrentUserProfile(BuildContext context, AttendeeItem attendee, EventMerchantVendorProfile? vendorProfile) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) => getEditMainContainer(context, attendee, vendorProfile, item.profile),
              orElse: () {
                return getEditMainContainer(context, attendee, vendorProfile, null);
            }
          );
        },
      ),
    );
  }

  Widget getEditMainContainer(BuildContext context, AttendeeItem attendee, EventMerchantVendorProfile? vendorProfile, UserProfileModel? currentUserProfile) {

    List<VendorContactDetail> attendingList = [];

      if (vendorProfile != null && currentUserProfile != null) {
        for (MVBoothPayments booth in attendee.vendorForm?.boothPaymentOptions ?? [MVBoothPayments(uid: attendee.attendeeOwnerId, boothTitle: 'Booth')]) {
          // if (queriedAttendees.entries.where((element) => element.key.attendeeOwnerId == attendee.attendeeOwnerId).isNotEmpty && queriedAttendees.entries.where((element) => element.key.attendeeOwnerId == attendee.attendeeOwnerId).first.value.map((e) => e.boothItem.uid).contains(booth.uid) == false) {

          if (attendingList.map((e) => e.uid).contains(booth.selectedId) == false) {
              attendingList.add(VendorContactDetail(
                vendorProfile: vendorProfile,
                uid: (booth.selectedId != null) ? booth.selectedId! : UniqueId.fromUniqueString('${booth.uid.getOrCrash()} ${attendee.attendeeOwnerId.getOrCrash()}'),
                userProfile: currentUserProfile,
                attendee: attendee,
                boothItem: booth,
            )
          );
        }
      }
    }

    return getMainContainer(context, attendee, attendingList, vendorProfile, currentUserProfile);
  }

  Widget getMainContainer(BuildContext context, AttendeeItem attendee, List<VendorContactDetail> attending, EventMerchantVendorProfile? vendorProfile, UserProfileModel? currentUserProfile) {

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        /// show header and edit options
        // if (kIsWeb)

        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              if (vendorProfile != null) Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // const SizedBox(height: 8),
                    // Text('Update Application', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    // const SizedBox(height: 4),
                    // Text('if this application is still open you can add more days or cancel the days you\'ve already requested down below', style: TextStyle(color: widget.model.disabledTextColor)),
                    // const SizedBox(height: 8),
                    // /// option to update submission (if form has not closed)
                    // vendorFormApplyButton(
                    //   context,
                    //   widget.model,
                    //   widget.reservationItem,
                    //   widget.activityManagerForm,
                    //   widget.activityOwnerProfile,
                    //   false,
                    //   MediaQuery.of(context).size.width,
                    //   false,
                    //   (widget.activityManagerForm.rulesService.vendorMerchantForms ?? []).firstWhere((element) => element.formId == attendee.vendorForm?.formId, orElse: () => attendee.vendorForm!),
                    //   attendee.vendorForm!,
                    //   0,
                    // ),

                    // const SizedBox(height: 8),
                    // Divider(
                    //   color: widget.model.disabledTextColor,
                    // ),
                    const SizedBox(height: 8),

                    /// current linked vendor profile
                    Text('Linked Vendor Profile', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    const SizedBox(height: 4),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: getActivityVendorProfileTile(
                        widget.model,
                        vendorProfile,
                        false,
                        didSelectAttendee: (attendee) {
                          setState(() {

                          });
                        }),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: vendorAttendeeApplicationHeaderBar(
                  context,
                  widget.model,
                  null,
                  widthResponsive,
                  widget.activityManagerForm,
                  widget.activityOwnerProfile,
                  attendee,
                  attending,
                  attendee.vendorForm,
                  vendorProfile,
                  currentUserProfile,
                  didSelectOption: (e) {
                    _handleApplicantMoreOptionsDropdownSelection(context, e, currentUserProfile, vendorProfile, attendee, attending);
                  },
                  didSelectSelectAll: () {

                  }
                ),
              ),
              const SizedBox(height: 8),
              if (Responsive.isMobile(context)) Text('scroll left to right to view more', style: TextStyle(color: widget.model.disabledTextColor)),
              ...attending.toList().asMap().map((i, vendorDetail) {

                late bool isSelected = selectedVendors.map((e) => e.uid).contains(vendorDetail.uid);
                /// get date for selected booth..if null booth applies to all dates
                final MCCustomAvailability? availability = (vendorDetail.boothItem.availabilityId != null && attendee.vendorForm?.availableTimeSlots?.where((element) => element.uid == vendorDetail.boothItem.availabilityId).isNotEmpty == true) ? attendee.vendorForm?.availableTimeSlots?.firstWhere((element) => element.uid == vendorDetail.boothItem.availabilityId) : null;

                return MapEntry(i, SlideInTransitionWidget(
                    durationTime: 300 * i,
                    offset: Offset(0, 0.25),
                      transitionWidget: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: widget.model.accentColor,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getRowForBoothOption(
                                      context,
                                      widget.model,
                                      widget.activityOwnerProfile.userId.getOrCrash() == facade.FirebaseChatCore.instance.firebaseUser?.uid,
                                      widget.activityManagerForm.rulesService.currency,
                                      vendorDetail,
                                      i,
                                      availability,
                                      isSelected,
                                      vendorDetail.boothItem.status?.name == currentEditingMode,
                                      didSelectEdit: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedVendors.removeWhere((element) => element.uid == vendorDetail.uid);
                                          } else {
                                        selectedVendors.add(vendorDetail);
                                      }
                                  });
                                }
                              )
                            )
                          ),
                        )
                      )
                    )
                  );
                }
              ).values.toList(),
              const SizedBox(height: 65),
            ],
          ),
        ),

        /// leave activity
        if (vendorNoLongerEligible(attending.map((e) => e.boothItem).toList()) && currentEditingMode != null) Positioned(
            bottom: 15,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: (currentEditingMode != null) ? Border.all(color: Colors.red) : null,
                  color: widget.model.accentColor,
                  boxShadow: [
                    BoxShadow(
                        color: widget.model.disabledTextColor.withOpacity(0.35),
                        spreadRadius: 5,
                        blurRadius: 13,
                        offset: const Offset(5,0)
                    )
                  ],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: InkWell(
                  onTap: () {
                    presentALertDialogMobile(
                        context,
                        'Leaving?',
                        'Are you sure you want to leave this Activity?',
                        'Leave',
                        didSelectDone: () {
                          context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.didDeleteAttendee());
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        }
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Leave Activity', style: TextStyle(color: (currentEditingMode != null) ? Colors.red : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
                  ),
                ),
              ),
            ),
          )
        ),
        /// Cancel Request
        if (vendorNoLongerEligible(attending.map((e) => e.boothItem).toList()) == false && vendorCanEditForm(attending)) Positioned(
          bottom: (kIsWeb) ? 0 : 15,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                border: (selectedVendors.isNotEmpty && currentEditingMode != null) ? Border.all(color: Colors.red) : null,
                color: widget.model.accentColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.model.disabledTextColor.withOpacity(0.35),
                    spreadRadius: 5,
                    blurRadius: 13,
                  offset: const Offset(5,0)
                  )
                ],
                borderRadius: BorderRadius.circular(40),
              ),
              child: InkWell(
                onTap: () {

                if (currentEditingMode != null && selectedVendors.isNotEmpty) {
                  presentALertDialogMobile(
                      context,
                      'Cancelling?',
                      'Are you sure you want to Cancel these Booths?',
                      'Yes, Cancel',
                      didSelectDone: () {

                        Navigator.of(context).pop();
                        final List<VendorContactDetail> selectedInView = [];
                        for (VendorContactDetail vendor in attending.where((element) => element.boothItem.status == AvailabilityStatus.requested)) {
                          if (selectedVendors.map((e) => e.uid).contains(vendor.uid)) {
                            selectedInView.add(vendor);
                          }
                        }
                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.didCancelAttendeesGroup(selectedInView));

                      }
                    );
                  }
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Cancel Request', style: TextStyle(color: (selectedVendors.isNotEmpty && currentEditingMode != null) ? Colors.red : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: (Responsive.isDesktop(context)) ? widget.model.secondaryQuestionTitleFontSize : null)),
                  ),
                ),
              ),
            ),
          )
        )
      ],
    );
  }
}