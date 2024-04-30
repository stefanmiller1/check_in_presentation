part of check_in_presentation;

class CreateNewPartnerForm extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final UserProfileModel resOwner;
  final ActivityManagerForm activityForm;
  final bool isFromInvite;

  const CreateNewPartnerForm({Key? key, required this.model, required this.reservation, required this.activityForm, required this.resOwner, required this.isFromInvite}) : super(key: key);

  @override
  State<CreateNewPartnerForm> createState() => _CreateNewPartnerFormState();
}

class _CreateNewPartnerFormState extends State<CreateNewPartnerForm> {

  ScrollController? _scrollController;

  String querySearch = '';
  late ContactDetails? contactDetails = ContactDetails.empty();

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5)),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleTextStyle: TextStyle(color: widget.model.accentColor),
        title: Text('Invite a Partner or Organization You\'re Collaborating With'),
        // toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        backgroundColor: widget.model.paletteColor,
        actions: [
          IconButton(
            onPressed: () {

            },
            tooltip: 'Create Invite Link',
            icon: Icon(Icons.ios_share, color: widget.model.accentColor),
            padding: EdgeInsets.all(1),
          ),
          SizedBox(width: 10),
          // Column(
          //   children: [
          //     SizedBox(height: 32.5),
          //     IconButton(
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //       icon: Icon(Icons.cancel_outlined, color: widget.model.accentColor),
          //       padding: EdgeInsets.all(1),
          //     ),
          //   ],
          // ),
          // SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(create: (_) => getIt<AttendeeFormBloc>()..add(AttendeeFormEvent.initializeAttendeeForm(
          dart.optionOf(AttendeeItem(
          attendeeId: UniqueId(),
          attendeeOwnerId: UniqueId(),
          reservationId: widget.reservation.reservationId,
          cost: '',
          paymentStatus: PaymentStatusType.noStatus,
          attendeeType: AttendeeType.partner,
          paymentIntentId: '',
          contactStatus: ContactStatus.invited,
          dateCreated: DateTime.now())
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
        buildWhen: (p,c) => p.isSubmitting != c.isSubmitting,
        builder: (context, state) {
          return Stack(
                alignment: Alignment.bottomCenter,
                children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                            const SizedBox(height: 8),

                            SearchProfiles(
                              model: widget.model,
                              showAddProfile: false,
                              selectedProfilesToSave: (profile) {
                                setState(() {
                                  contactDetails = contactDetails?.copyWith(
                                      contactId: profile.userId,
                                      emailAddress: profile.emailAddress,
                                      name: profile.legalName
                                  );
                                  context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateAttendeeContactDetails(contactDetails!));
                                });
                              },
                            ),

                          ],
                        ),
                      ),
                    ),

                    // const SizedBox(height: 25),
                    if (state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                    if (!state.isSubmitting) Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                        child: InkWell(
                          onTap: () {
                            context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.attendeeIsSaving(true));
                            context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.isFinishedInvitingAttendee());
                          },
                          child: Container(
                            width: 675,
                            height: 60,
                            decoration: BoxDecoration(
                              color: (context.read<AttendeeFormBloc>().state.attendeeItem.attendeeDetails != null) ? widget.model.paletteColor : widget.model.webBackgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Align(
                              child: Text('Invite Partner', style: TextStyle(color: (context.read<AttendeeFormBloc>().state.attendeeItem.attendeeDetails != null) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        ),
                      ),
                    ),
                  )
                ]
              );
            }
          )
        )
      )
    );
  }
}