part of check_in_presentation;

class SendInvitationRequest extends StatefulWidget {

  final DashboardModel model;
  final String currentUserId;
  final ActivityManagerForm? activityForm;
  final InvitationType inviteType;
  final AttendeeType attendeeType;
  // final List<AttendeeItem> currentAttendees;
  final ReservationItem reservationItem;
  final Function(List<ContactDetails>) didSelectInvite;

  const SendInvitationRequest({
    super.key,
    required this.model,
    required this.currentUserId,
    // required this.currentAttendees,
    required this.reservationItem,
    required this.didSelectInvite,
    required this.attendeeType,
    this.activityForm,
    required this.inviteType,
  });

  @override
  State<SendInvitationRequest> createState() => _SendInvitationRequestState();
}

class _SendInvitationRequestState extends State<SendInvitationRequest> {

  List<con.Contact>? _contacts;
  List<ContactDetails> selectedUsers = [];
  // List<UserProfileModel> searchResults = [];
  late TextEditingController _textController;
  String querySearch = '';
  bool _permissionDenied = false;


  @override
  void initState() {
    selectedUsers = [];
    _textController = TextEditingController();
    _fetchContacts();
    super.initState();
  }

  Future _fetchContacts() async {
    if (!await con.FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await con.FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(widget.reservationItem.reservationId.getOrCrash())),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadAllAttendanceActivitySuccess: (allAttendees) => getMainContainer(context, allAttendees.item),
                  orElse: () => getMainContainer(context, [])
          );
        }
      )
    );
  }


  Widget getMainContainer(BuildContext context, List<AttendeeItem> currentAttendees) {
    return BlocProvider(create: (_) => getIt<InvitationFormBloc>()..add(InvitationFormEvent.initializedInviteForm(dart.optionOf(selectedUsers))),
        child: BlocConsumer<InvitationFormBloc, InvitationFormState>(
            listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
            listener: (context, state)  {

              state.authFailureRemoveAttendeeOrSuccess.fold(
                      () => null,
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                              orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                          (_) {
                      }
                  )
              );
              state.authFailureOrSuccess.fold(
                      () => null,
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              attendeeServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                              orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                          (_) {
                        final snackBar = SnackBar(
                            elevation: 4,
                            backgroundColor: widget.model.paletteColor,
                            content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      }
                  )
              );
            },
            buildWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.inviteList != c.inviteList,
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: widget.model.paletteColor,
                  title: Text(
                    'Send Invite', style: TextStyle(color: widget.model.accentColor),
                  ),
                  centerTitle: true,
                  actions: [
                    if (!state.isSubmitting) Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedUsers.isNotEmpty && !state.isSubmitting) {
                              // context.read<InvitationFormBloc>().add(const InvitationFormEvent.inviteIsSubmittingChanged(true));

                              switch (widget.inviteType) {
                                case InvitationType.reservation:
                                  // if (widget.activityForm != null) {
                                    List<AttendeeItem> attendeeList = [];
                                    for (ContactDetails contact in selectedUsers) {
                                      final AttendeeItem attendee = AttendeeItem(
                                          attendeeId: UniqueId(),
                                          attendeeDetails: contact,
                                          contactStatus: ContactStatus.invited,
                                          attendeeOwnerId: contact.contactId,
                                          reservationId: widget.reservationItem.reservationId,
                                          cost: '',
                                          invitedFrom: UniqueId.fromUniqueString(widget.currentUserId),
                                          paymentStatus: PaymentStatusType.noStatus,
                                          attendeeType: widget.attendeeType,
                                          paymentIntentId: '',
                                          dateCreated: DateTime.now(),
                                      );
                                      attendeeList.add(attendee);
                                    }

                                    context.read<InvitationFormBloc>().add(const InvitationFormEvent.inviteIsSubmittingChanged(true));
                                    context.read<InvitationFormBloc>().add(InvitationFormEvent.finishedSubmittingReservationInvite(widget.reservationItem.reservationId.getOrCrash(), widget.activityForm, attendeeList));
                                  // }
                                  break;
                              }
                            }
                          });
                        },
                        child: Text('Invite', style: TextStyle(color: (selectedUsers.isEmpty) ? widget.model.accentColor.withOpacity(0.4) : widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                body: Column(
                  children: [
                    const SizedBox(height: 8),
                    /// search controller
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                          controller: _textController,
                          style: TextStyle(color: widget.model.paletteColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.zoom_out, color: widget.model.disabledTextColor),
                            hintText: 'Search a Name or Email',
                            errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
                            fillColor: widget.model.accentColor,
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: widget.model.paletteColor,
                                  width: 0
                              ),
                            ),
                            focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: const BorderSide(
                                  color: Colors.transparent,
                                  width: 0
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
                                color: widget.model.webBackgroundColor,
                                width: 0,
                              ),
                            ),
                          ),
                          autocorrect: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: (query) {
                            setState(() {
                              querySearch = query.toLowerCase();
                            });
                          }
                      ),
                    ),

                    /// invite from contacts
                    if (querySearch == '' && !(state.isSubmitting)) Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                  return ContactsListWidget(
                                    model: widget.model,
                                    contactList: _contacts ?? [],
                                  );
                                })
                                );
                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.perm_contact_cal_outlined, color: widget.model.paletteColor),
                                              const SizedBox(width: 18.0),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Invite From Contacts', style: TextStyle(color: widget.model.paletteColor)),
                                                  Text('send invites directly to your contacts', style: TextStyle(color: widget.model.disabledTextColor))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                                      ]
                                  )
                              )
                          ),
                        ),



                        /// ------------------ ///
                        Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width,
                          color: widget.model.accentColor,
                        ),


                        /// search results for all owned communities or start community - go to community members list/count
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                              onTap: () {

                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.people_alt_outlined, color: widget.model.paletteColor),
                                              const SizedBox(width: 18.0),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Create New Community', style: TextStyle(color: widget.model.paletteColor)),
                                                  Text('Get your community to join this reservation', style: TextStyle(color: widget.model.disabledTextColor))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                                      ]
                                  )
                              )
                          ),
                        ),

                        /// ------------------ ///
                        Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width,
                          color: widget.model.accentColor,
                        ),

                        /// TODO: IMPLEMENT INVITE ONLY - LIMITED TO ONCE EVERY 2 WEEKS
                        /// will need limiting if invite only is set in place
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: InkWell(
                              onTap: () {

                              },
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.people_alt_outlined, color: widget.model.paletteColor),
                                              const SizedBox(width: 18.0),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('Invite New Contact', style: TextStyle(color: widget.model.paletteColor)),
                                                  Text('Send an E-mail Invite to Friends', style: TextStyle(color: widget.model.disabledTextColor))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Icon(Icons.alternate_email, color: widget.model.paletteColor)
                                      ]
                                  )
                              )
                          ),
                        ),
                      ],
                    ),

                    if (state.isSubmitting) SizedBox(
                        height: 220,
                        child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                    ),


                    /// search results for all users
                    if (!state.isSubmitting) BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserAllProfilesStarted()),
                      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
                          builder: (context, authState) {
                            return authState.maybeMap(
                                loadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                                loadAllUserProfilesSuccess: (items) {
                                  return querySearchItemsContainer(context, items.profile, currentAttendees);
                                },
                                orElse: () => querySearchItemsContainer(context, [], currentAttendees)
                          );
                        }
                      ),
                    ),

                    /// quickly share icon list
                    Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      color: widget.model.accentColor,
                      child: SingleChildScrollView(
                        child: Row(
                          children: [

                          ],
                        ),
                      ),
                    ),

                  ],
                ),

          );
        }
      )
    );
  }


  Widget querySearchItemsContainer(BuildContext context, List<UserProfileModel> users, List<AttendeeItem> currentAttendees) {

      List<ContactDetails> queryList = [];
      for (UserProfileModel user in users.where((element) => element.legalSurname.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch) || element.legalName.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch))) {
        if (user.legalName.isValid() && user.userId.getOrCrash() != widget.currentUserId && widget.reservationItem.reservationOwnerId != user.userId) {
          queryList.add(
            ContactDetails(
                contactId: user.userId,
                name: FirstLastName('${user.legalName.getOrCrash()} ${user.legalSurname.value.fold((l) => '', (r) => r)}'),
                emailAddress: user.emailAddress,
                contactStatus: (currentAttendees.where((element) => element.attendeeOwnerId == user.userId).isNotEmpty) ? currentAttendees.where((element) => element.attendeeOwnerId == user.userId).first.contactStatus ?? ContactStatus.invited : ContactStatus.invited
            )
          );
        }
      }

      return Expanded(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Invite', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedUsers.length == users.length) {
                            selectedUsers.clear();
                            // selectedUsers.addAll(widget.currentAttendees.reservationAffiliates ?? []);
                          } else {
                            selectedUsers.clear();
                            selectedUsers.addAll(users.map((user) =>  ContactDetails(
                                contactId: user.userId,
                                name: user.legalName,
                                emailAddress: user.emailAddress,
                                contactStatus: ContactStatus.invited
                            )).toList());
                          }
                        });
                      },
                      child: Text('Select All', style: TextStyle(color: widget.model.paletteColor, decoration: TextDecoration.underline)),
                    )
                  ],
                ),
              ),
              Expanded(
                child: (queryList.isNotEmpty) ? ListView.builder(
                    itemCount: queryList.length,
                    itemBuilder: (context, index) {
                      final user = queryList[index];
                      final AttendeeItem? attendee = currentAttendees.where((element) => element.attendeeOwnerId == user.contactId).isNotEmpty ? currentAttendees.firstWhere((element) => element.attendeeOwnerId == user.contactId) : null;
                      final bool isInvitee = widget.reservationItem.reservationOwnerId == widget.currentUserId || attendee?.invitedFrom == widget.currentUserId;

                      return ListTile(
                        onTap: () {
                          setState(() {

                            if (!(currentAttendees.map((e) => e.attendeeOwnerId).contains(user.contactId) ?? false)) {
                              if (!(selectedUsers.map((e) => e.contactId).contains(user.contactId))) {
                                selectedUsers.add(user);
                              } else {
                                selectedUsers.removeWhere((element) => element.contactId == user.contactId);
                              }
                            }
                          });
                        },
                        leading: CachedNetworkImage(
                            imageUrl: users.firstWhereOrNull((profileUser) => profileUser.userId == user.contactId)?.photoUri ?? '',
                            imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                            errorWidget: (context, url, error) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image)
                      ),
                        title: Text(user.name.getOrCrash(), style: TextStyle(color: widget.model.paletteColor)),
                        trailing: (currentAttendees.map((e) => e.attendeeOwnerId).contains(user.contactId)) ? Container(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isInvitee && user.contactStatus == ContactStatus.invited) InkWell(
                                onTap: () {
                                  setState(() {
                                    context.read<InvitationFormBloc>().add(const InvitationFormEvent.inviteIsSubmittingChanged(true));
                                    context.read<InvitationFormBloc>().add(InvitationFormEvent.finishedRemovingAttendee(widget.reservationItem.reservationId.getOrCrash(), user.contactId));
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: widget.model.accentColor
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Undo', style: TextStyle(color: Colors.red)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: widget.model.accentColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(getContactStatus(currentAttendees.firstWhere((element) => element.attendeeOwnerId == user.contactId).contactStatus), style: TextStyle(color: widget.model.disabledTextColor)),
                                ),
                              ),
                            ],
                          ),
                        ) : Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 2, color: widget.model.paletteColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: (selectedUsers.map((e) => e.contactId).contains(user.contactId)) ? widget.model.paletteColor : Colors.transparent
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ) : Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          child: CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image),
                        ),
                        const SizedBox(height: 10),
                        Text('Has Not Joined Yet!', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        const SizedBox(height: 5),
                        Text('Sorry, $querySearch can\'nt be found.')
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

String getContactStatus(ContactStatus? status) {
  switch (status) {
    case ContactStatus.invited:
      return 'Invited';
    case ContactStatus.joined:
      return 'Joined';
    case ContactStatus.pending:
      return 'Pending';
    default:
      return 'Invited';
  }
}