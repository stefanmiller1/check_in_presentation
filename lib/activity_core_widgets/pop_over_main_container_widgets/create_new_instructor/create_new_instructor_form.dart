part of check_in_presentation;

class CreateNewInstructorForm extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  final bool isFromInvite;

  const CreateNewInstructorForm({Key? key, required this.model, required this.reservation, required this.resOwner, required this.activityForm, required this.isFromInvite}) : super(key: key);

  @override
  State<CreateNewInstructorForm> createState() => _CreateNewInstructorFormState();
}

class _CreateNewInstructorFormState extends State<CreateNewInstructorForm> {

  ScrollController? _scrollController;
  late TextEditingController nameTextController;
  late ClassesInstructorProfile classInstructorBackground = ClassesInstructorProfile.empty();
  late ContactDetails? contactDetails = ContactDetails.empty();
  late bool didEditEmail = false;
  late bool isLoading = false;
  NewAttendeeStepsMarker currentMarkerItem = NewAttendeeStepsMarker.getStarted;

  List<NewAttendeeContainerModel> attendeeMainContainer(BuildContext context, UserProfileModel? user, AttendeeFormState state) => [
    if (activityHasRules(widget.activityForm)) NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.addActivityRules,
        childWidget: rulesToAdd(
            context,
            widget.model,
            widget.activityForm.rulesService.ruleOption.getOrCrash(),
            widget.resOwner
      )
    ),
    NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.getStarted,
        childWidget: SingleChildScrollView(
          child: Column(
            children: [
              // instructorEditorContainer(
              //     context: context,
              //     model: widget.model,
              //     classInstructorBackground: classInstructorBackground,
              //     didChangeNumberOfYears: (number) {
              //       setState(() {
              //         classInstructorBackground = classInstructorBackground.copyWith(
              //             numberOfYearsInExperience: number
              //         );
              //         context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              //       });
              //     },
              //     didSelectExperience: (experience, i) {
              //       setState(() {
              //         handleSelectedExperience(
              //             context,
              //             widget.model,
              //             i,
              //             experience,
              //             didSelectSaveExperience: (e, i) {
              //               setState(() {
              //                 late List<ExperienceOption> newExperience = [];
              //                 newExperience.addAll(classInstructorBackground.experience);
              //
              //                 newExperience.replaceRange(i, i+1, [e]);
              //                 classInstructorBackground = classInstructorBackground.copyWith(
              //                     experience: newExperience
              //                 );
              //                 context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              //               });
              //             }
              //         );
              //       });
              //     },
              //     didSelectRemoveExperience: (i) {
              //       setState(() {
              //           late List<ExperienceOption> newExperience = [];
              //           newExperience.addAll(classInstructorBackground.experience);
              //
              //           newExperience.removeAt(i);
              //           classInstructorBackground = classInstructorBackground.copyWith(
              //               experience: newExperience
              //           );
              //
              //           classInstructorBackground.experience.toList().addAll(newExperience);
              //           context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              //         });
              //     },
              //     didSelectCreateExperience: () {
              //       setState(() {
              //         handleCreateNewExperience(
              //             context,
              //             widget.model,
              //             didSelectSaveExperience: (experience) {
              //               setState(() {
              //                 late List<ExperienceOption> newExperience = [];
              //                 newExperience.addAll(classInstructorBackground.experience);
              //
              //                 newExperience.add(experience);
              //                 classInstructorBackground = classInstructorBackground.copyWith(
              //                     experience: newExperience
              //                 );
              //                 context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              //               });
              //             }
              //         );
              //       });
              //     },
              //     didSelectCertificate: (certificate) {
              //
              //     },
              //     didSelectRemoveCertificate: (i) {
              //       setState(() {
              //         late List<CertificateOption> newCertificate = [];
              //         newCertificate.addAll(classInstructorBackground.certificates);
              //
              //         newCertificate.removeAt(i);
              //         classInstructorBackground = classInstructorBackground.copyWith(
              //             certificates: newCertificate
              //         );
              //
              //         classInstructorBackground.certificates.toList().addAll(newCertificate);
              //         context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              //       });
              //     },
              //     didCreateNewCertificate: () {
              //       setState(() {
              //         handleNewCertificate(
              //             context,
              //             widget.model,
              //             didSelectSaveCertificate: (certificate) {
              //               setState(() {
              //                 late List<CertificateOption> newCertificate = [];
              //                 newCertificate.addAll(classInstructorBackground.certificates);
              //
              //                 newCertificate.add(certificate);
              //                 classInstructorBackground = classInstructorBackground.copyWith(
              //                     certificates: newCertificate
              //                 );
              //                 context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              //               });
              //             }
              //         );
              //       });
              //     }
              // ),
              const SizedBox(height: 110)
          ],
        )
      )
    ),
    NewAttendeeContainerModel(
        markerItem: NewAttendeeStepsMarker.joinComplete,
        childWidget: newAttendeeJoinCompleted(
          context,
          widget.model,
          didSelectComplete: () {
          context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
          if (user != null) context.read<AttendeeFormBloc>().add(AttendeeFormEvent.isFinishedCreatingAttendee(user, '', '', ''));
        }
      )
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    nameTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController?.dispose();
    super.dispose();
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
              attendeeType: AttendeeType.instructor,
              paymentIntentId: '',
              contactStatus: ContactStatus.joined,
              dateCreated: DateTime.now(),
              classesInstructorProfile: UniqueId(),
            )
          ),
          dart.optionOf(widget.reservation),
          dart.optionOf(widget.activityForm),
          dart.optionOf(widget.resOwner)
          )
        ),
        child: BlocConsumer<AttendeeFormBloc, AttendeeFormState>(
          listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
          listener: (context, state) {
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
                    Navigator.of(context).pop();
                  }
              }));
          },
          buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.attendeeItem != c.attendeeItem,
          builder: (context, state) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    titleTextStyle: TextStyle(color: widget.model.paletteColor),
                    title: Text('Join as an Instructor', style: TextStyle(color: widget.model.accentColor)),
                    elevation: 0,
                    centerTitle: true,
                    backgroundColor: widget.model.paletteColor,
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
                ],
              ),
            )
          );
        }
      ),
    );
  }

  Widget retrieveAuthenticationState(BuildContext context, AttendeeFormState state) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),

                    if (state.isSubmitting == false) CreateNewMain(
                        model: widget.model,
                        isLoading: isLoading,
                        isPreviewer: false,
                        child: attendeeMainContainer(context, item.profile, state).map((e) => e.childWidget).toList()
                    ),

                    ClipRRect(
                        child: BackdropFilter(
                            filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade200.withOpacity(0.5),
                              child: footerWidgetForNewAttendee(
                                context,
                                widget.model,
                                false,
                                currentMarkerItem,
                                null,
                                null,
                                null,
                                widget.activityForm,
                                state,
                                null,
                                attendeeMainContainer(context, null, state).last.markerItem == currentMarkerItem,
                                didSelectBack: () {

                                  setState(() {
                                    if (widget.isFromInvite == false) {
                                      Navigator.of(context).pop();
                                    }
                                  });
                                },
                                didSelectNext: () {

                                  setState(() {
                                    // check current index in array
                                    final currentIndex = attendeeMainContainer(context, null, state).indexWhere((element) => element.markerItem == currentMarkerItem);
                                    /// get item at index + 1
                                    final NewAttendeeStepsMarker nextIndexItem = attendeeMainContainer(context, null, state)[currentIndex + 1].markerItem;
                                    currentMarkerItem = nextIndexItem;

                                  });
                                },
                              ),
                            )
                        )
                    )

                  ],
                );
              },
              orElse: () => GetLoginSignUpWidget(showFullScreen: false, model: widget.model, didLoginSuccess: () {  },)
          );
        },
      ),
    );
  }
}