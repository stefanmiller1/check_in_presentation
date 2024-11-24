part of check_in_presentation;

class CreateNewActivityScreen extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm? currentListingManForm;
  final bool isPopOver;
  final Function() didSelectClose;
  final int? initPage;


  const CreateNewActivityScreen({super.key, required this.model, this.currentListingManForm, this.initPage, required this.didSelectClose, required this.isPopOver});

  @override
  State<CreateNewActivityScreen> createState() => _CreateNewActivityScreenState();
}

class _CreateNewActivityScreenState extends State<CreateNewActivityScreen> {


  late PageController? pageController = null;
  late ListingManagerForm? selectedListing = null;
  late UserProfileModel? selectedListingOwner = null;
  late ReservationItem? selectedReservationItem = null;
  late String? listingCode = null;
  ScrollController? _scrollController;
  late bool isLoadingLogin = false;
  late bool isLoading = false;
  late bool willAttendHere = false;
  late bool isConfirmed = false;
  int _currentPage = 0;


  @override
  void initState() {
    selectedListing = widget.currentListingManForm;
    pageController = PageController(initialPage: widget.initPage ?? 0);
    _currentPage = widget.initPage ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  List<Widget> newActivityContainer(BuildContext context, UserProfileModel currentUser) => [
    /// select a facility...
    SingleChildScrollView(
      child: Column(
        children: [
          Transform.scale(
            scale: 8,
            child: lottie.Lottie.asset(
                height: 425,
                repeat: false,
                'assets/lottie_animations/Animation - 1716552555161.json'
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Add my Activity to the map!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
          ),
          const SizedBox(height: 5),
          Text('Welcome to a circle - get Started By Clicking \'Next'':', style: TextStyle(color: widget.model.disabledTextColor, ), textAlign: TextAlign.center),
        ],
      ),
    ),

    SelectFacilityListScreen(
      model: widget.model,
      currentUser: currentUser,
      selectedListing: selectedListing,
      didSelectListing: (listing) {
        setState(() {
          print(listing.listingServiceId.getOrCrash());
          selectedListing = listing;
        });
      },
    ),

    SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Disclaimer!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
              ),
              Text('Select at I Agree then pick your dates', style: TextStyle(color: widget.model.disabledTextColor)),

              ListTile(
                leading: Icon(Icons.add_task, color: widget.model.paletteColor),
                title: Text('Permissions', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('You have obtained or will be able to at a later date explicit permission from the owner or authorized representative of the space to use the venue for your event.', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
              ListTile(
                leading: Icon(Icons.add_task, color: widget.model.paletteColor),
                title: Text('Responsibility', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('You are responsible for all communications and agreements with the space owner and will ensure that all necessary arrangements are in place.', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
              ListTile(
                leading: Icon(Icons.add_task, color: widget.model.paletteColor),
                title: Text('Reservation Removals', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text(' If it is found that you do not have the necessary permissions or are not in compliance with the above conditions, we (the platform) reserve the right to cancel and remove your event listing without notice.', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            ),
            const SizedBox(height: 8),
            Text('Please confirm that you have the necessary permissions and agree to the above terms by selecting “I Agree”. If you do not have permission, please select “Cancel” to exit the event posting process.', style: TextStyle(color: widget.model.paletteColor)),

            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (widget.isPopOver == true) {
                      Navigator.of(context).pop();
                    } else {
                      widget.didSelectClose();
                    }
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 200
                    ),
                    height: 45,
                    width: 185,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Cancel', style: TextStyle(color: Colors.red, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    setState(() {
                      isConfirmed = !isConfirmed;
                      print(selectedListing?.listingServiceId.getOrCrash());
                    });
                  },
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 200
                    ),
                    height: 45,
                    width: 185,
                    decoration: BoxDecoration(
                      color: (isConfirmed) ? widget.model.paletteColor : widget.model.accentColor,
                      borderRadius: const BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('I Agree', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ),
                  ),
                )

              ],
            ),
              const SizedBox(height: 100),
          ],
        ),
      )
    ),

    /// verify location with listing code
  if (selectedListing != null) SingleChildScrollView(
    child: Container(
      height: 800,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              color: widget.model.disabledTextColor,
              size: 72,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Have an Access Code?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: widget.model.paletteColor),
                initialValue: listingCode,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: widget.model.disabledTextColor),
                  hintText: 'Enter Code Here',
                  errorStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: widget.model.paletteColor,
                  ),
                  prefixIcon: Icon(Icons.lock, color: widget.model.disabledTextColor),
                  filled: true,
                  fillColor: widget.model.accentColor,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      width: 2,
                      color: widget.model.paletteColor,
                    ),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: widget.model.paletteColor,
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
                      color: widget.model.disabledTextColor,
                      width: 0,
                    ),
                  ),
                ),
                autocorrect: false,
                onChanged: (value) {
                  setState(() {
                    listingCode = value;
                  });
                },
              ),
            ),
            /// explain this is case sensitive
            const SizedBox(height: 18),
            Text('This code is case sensitive, you can find your access code in the invitation e-mail, or request an access code below', style: TextStyle(color: widget.model.disabledTextColor)),
            /// button to request access code
            const SizedBox(height: 28),
            InkWell(
              onTap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'hello@cincout.ca',
                  query: encodeQueryParameters(<String, String>{
                    'subject':'Hello! - Space Access Request',
                    'body': 'I have a space i\'d like to access for an event i have coming up - looking to use this space ${selectedListing?.listingServiceId.getOrCrash().substring(0, 7)}'
                  }),
                );

                if (await canLaunchUrl(params)) {
                  launchUrl(params);
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 300),
                decoration: BoxDecoration(
                  color: widget.model.paletteColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    'Request Access',
                    style: TextStyle(
                      color: widget.model.accentColor,
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          ]
        ),
      ),
    )
  ),


    /// review selected profile
    if (selectedListing != null) SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Is this the place?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
          ),
          Text('Select at Next to pick your dates', style: TextStyle(color: widget.model.disabledTextColor)),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
            child: FacilityOverviewInfoWidget(
              model: widget.model,
              overViewState: FacilityPreviewState.reservation,
              newFacilityBooking: ReservationItem.empty(),
              reservations: [],
              /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
              listingOwnerProfile: currentUser,
              listing: selectedListing!,
              selectedReservationsSlots: [],
              selectedActivityType: null,
              currentListingActivityOption: null,
              currentSelectedSpace: null,
              currentSelectedSpaceOption: null,
              didSelectSpace: (space) {
              },
              didSelectSpaceOption: (spaceOption) {
              },
              updateBookingItemList: (slotItem, currency) {
              },
              didSelectItem: () {
              },
              isAttendee: false,
            ),
          ),
        ],
      ),
    ),


    if (selectedListing != null) retrieveExistingReservations(selectedListing!, currentUser),

    /// verify that you will be here on these dates (yes or no)
    if (selectedListing != null && selectedReservationItem != null && selectedReservationItem?.reservationSlotItem.isNotEmpty == true) SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 70.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            /// ------------------------ ///
            /// image booking space/name/where/review
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                    children: getSpacesFromSelectedReservationSlot(context, selectedListing!, selectedReservationItem?.reservationSlotItem ?? []).map(
                            (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: getSelectedSpaces(context, e, widget.model),
                        )
                    ).toList()
                ),
              ),
            ),

            /// ------------------------ ///
            /// your booking
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),

            Text('Your Booking Slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),

            viewListOfSelectedSlots(
              context,
              widget.model,
              [],
              selectedReservationItem?.reservationSlotItem ?? [],
              [],
              false,
              AppLocalizations.of(context)!.profileFacilitySlotTime,
              AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
              AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
              selectedListing!,
              didSelectReservation: (e) {
              },
              didSelectCancelResSlot: (e, f) {
                setState(() {});
              },
              didSelectRemoveResSlot: (e, f) {

              }
            ),
            /// ------------------------ ///
            /// policy & guidelines
            const SizedBox(height: 5),
            Divider(color: widget.model.paletteColor),
            const SizedBox(height: 5),

            Text('When Selecting Confirm Reservation, I agree to the Rules made by the Listing Owner, Ground Rules for Guests, Cancellatio, Rebooking, and Refunding Policy defined by CICO and the Listing Owner.', style: TextStyle(color: widget.model.disabledTextColor)),
            const SizedBox(height: 34),
          ],
        ),
      ),
    ),

  if (selectedListing != null && selectedReservationItem != null) retrieveFacilityOwnerForSetupCompletion(selectedReservationItem!, selectedListing!, currentUser)

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 90,
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
          title: Text('Create Your Activity', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            elevation: 0,
            centerTitle: true,
            backgroundColor: widget.model.paletteColor,
            leadingWidth: 70,
            leading: IconButton(
            icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
            tooltip: 'Cancel',
            onPressed: () {
              if (widget.isPopOver == true) {
                Navigator.of(context).pop();
              } else {
                widget.didSelectClose();
              }
          },
        ),
      ),
      body:  PointerInterceptor(
        child: Stack(
            children: [
              Container(
                  color: widget.model.webBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height
              ),
              if (isLoadingLogin == true) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
              if (isLoadingLogin == false) retrieveAuthenticationState(context),
          ],
        ),
      )
    );
  }

  Widget retrieveAuthenticationState(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
              loadUserProfileSuccess: (item) {
                return getMainContainer(context, item.profile);
              },
              orElse: () =>  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetLoginSignUpWidget(showFullScreen: false, model: widget.model, didLoginSuccess: () {
                    setState(() {
                      isLoadingLogin = true;

                      Future.delayed(const Duration(milliseconds: 250), () {
                        setState(() {
                          isLoadingLogin = false;
                        });
                      });
                    });
                  },
                ),
              )
          );
        },
      ),
    );
  }


  Widget getMainContainer(BuildContext context, UserProfileModel currentUser) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            color: widget.model.webBackgroundColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height
        ),
        CreateNewMain(
            isPreviewer: false,
            model: widget.model,
            isLoading: isLoading,
            pageController: pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              // setState(() {
              //   if (index != (attendeeMainContainer(context, currentUser, profiles, state).length - 1)) {
              //     currentVendorMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].subVendorMarkerItem;
              //     currentMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].markerItem;
              //   }
              // });
            },
            child: newActivityContainer(context, currentUser).toList()
        ),
        createNewMainFooter(
          context,
          widget.model,
          showBackButtonNewActivity(),
          showNextButtonNewActivity(_currentPage, selectedListing, isConfirmed, selectedReservationItem?.reservationSlotItem ?? [], listingCode),
          null,
          didSelectBack: () {
            setState(() {
              if (_currentPage == 0) {
                if (widget.isPopOver == true) {
                  Navigator.of(context).pop();
                  } else {
                  widget.didSelectClose();
                }
              } else {
              isLoading = true;
              Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  isLoading = false;
                  });
                });
                pageController?.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                }
            });
          },
          didSelectNext: () {
            setState(() {
              isLoading = true;
              Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  isLoading = false;
                });
              });
              pageController?.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
            });
          }),
      ],
    );
  }


  Widget retrieveExistingReservations(ListingManagerForm listing, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([listing.listingServiceId.getOrCrash()], null, null, [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current])),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              // resLoadInProgress: (_) => progressOverlay(model),
              loadReservationListSuccess: (e) => retrieveFacilityOwner(e.item, listing, currentUser),
              loadReservationListFailure: (_) => retrieveFacilityOwner([], listing, currentUser),
              ///TODO: add failure of type empty
              /// if network call cant be made you should not be allowed to make any new reservation
              orElse: () => retrieveFacilityOwner([], listing, currentUser));
        },
      ),
    );
  }

  Widget retrieveFacilityOwner(List<ReservationItem> reservations, ListingManagerForm listing, UserProfileModel currentUser) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              loadInProgress: (_) => loadingListingProfile(listing),
              loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
              loadSelectedProfileSuccess: (item) => getReservation(listing, item.profile, currentUser, reservations),
              orElse: () => couldNotRetrieveListingProfile()
          );
        }
      ),
    );
  }



  Widget retrieveFacilityOwnerForSetupCompletion(ReservationItem reservation, ListingManagerForm listing, UserProfileModel currentUser) {
    return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadInProgress: (_) => loadingListingProfile(listing),
                loadSelectedProfileFailure: (_) => couldNotRetrieveListingProfile(),
                loadSelectedProfileSuccess: (item) => getSetupComplete(context, listing, reservation, item.profile, currentUser),
                orElse: () => couldNotRetrieveListingProfile()
            );
          }
      ),
    );
  }

  Widget getSetupComplete(BuildContext context, ListingManagerForm listing, ReservationItem reservation, UserProfileModel listingOwnerProfile, UserProfileModel currentUser, ) {
    return BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(
        dart.optionOf(reservation),
        dart.optionOf(listing),
        dart.optionOf(listingOwnerProfile)
      )
    ),
    child: BlocConsumer<ReservationFormBloc, ReservationFormState>(
    listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
    listener: (context, state) {

    state.authFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold((failure) {

          final snackBar = SnackBar(
              backgroundColor: widget.model.webBackgroundColor,
              content: failure.maybeMap(
                invalidDate: (_) => Text('Sorry, the Date(s) You Have Selected are Conflicting', style: TextStyle(color: widget.model.disabledTextColor)),
                waitingForPaymentConfirmation: (_) => Text('Waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                // waitingForPaymentConfirmation: (_) => Text('Sorry, You will Need to first Agree to the Terms and Conditions Before Completing Your Reservation', style: TextStyle(color: widget.model.disabledTextColor)),
                paymentResultError: (_) => Text('Please Fill Out Payment Method Details', style: TextStyle(color: widget.model.disabledTextColor)),
                // cancelled: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle( color: widget.model.disabledTextColor)),

                reservationServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
              ));

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }, (_) {
              final snackBar = SnackBar(
                  elevation: 4,
                  backgroundColor: widget.model.paletteColor,
                  /// booking successful - confirmation e-mail sent!
                  content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              if (widget.isPopOver == true) {
                Navigator.of(context).pop();
              } else {
                widget.didSelectClose();
              }

        }));

    },
    buildWhen: (p,c) =>  p.newFacilityBooking != c.newFacilityBooking ||
      p.isTermsConditionsAccepted != c.isTermsConditionsAccepted ||
      p.currentSelectedSpace != c.currentSelectedSpace ||
      p.currentSelectedSpaceOption != c.currentSelectedSpaceOption ||
      p.cardItem != c.cardItem ||
      p.isSavingCard != c.isSavingCard ||
      p.isSubmitting != c.isSubmitting,
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),

              if (state.isSubmitting == false) SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 36),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      size: 72,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'All Done!',
                      style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.questionTitleFontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Select the Confirm Reservation - and get your Activity Started!',
                      style: TextStyle(
                        color: widget.model.disabledTextColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    InkWell(
                      onTap: () {
                        context.read<ReservationFormBloc>().add(
                          ReservationFormEvent.isFinishedCreatingReservation(
                            currentUser,
                            0,
                            listing.listingProfileService.backgroundInfoServices.currency,
                            null,
                            listing.listingReservationService.accessVisibilitySetting.isReviewRequired ?? false,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        constraints: BoxConstraints(maxWidth: 300),
                        decoration: BoxDecoration(
                          color: widget.model.paletteColor,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                          child: Text(
                            'Confirm Reservation',
                            style: TextStyle(
                              color: widget.model.accentColor,
                              fontSize: widget.model.secondaryQuestionTitleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                  ],
                ),
              ),
              if (state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),

            ],
          );
        }
      )
    );
  }


  Widget getReservation(ListingManagerForm listing, UserProfileModel listingOwnerProfile, UserProfileModel currentUser, List<ReservationItem> reservations,) {
            UniqueId? selectedActivityType;
            SpaceOption currentSelectedSpace = listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => SpaceOption.empty(), (r) => r.first);
            SpaceOptionSizeDetail? currentSelectedSpaceOption = listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)[0].quantity[0];
            FacilityActivityCreatorForm? currentListingActivityOption;

            return Column(
              children: [
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('What about Your Dates?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), textAlign: TextAlign.center),
                ),
                Text('Select the dates - when you start and when your activity ends below', style: TextStyle(color: widget.model.disabledTextColor)),
                const SizedBox(height: 25),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: (Responsive.isMobile(context)) ? 10 : 60.0),
                    child: AddNewReservationSlots(
                        model: widget.model,
                        listing: listing,
                        reservations: reservations,
                        isPopOver: false,
                        didSaveReservation: (res) {
                          setState(() {
                            selectedReservationItem = res;
                          });
                          // context.read<ReservationFormBloc>().add(ReservationFormEvent.updateBookingItemList(res.reservationSlotItem, listing.listingProfileService.backgroundInfoServices.currency));
                        },
                        selectedSpace: currentSelectedSpace,
                        selectedSportSpace: currentSelectedSpaceOption,
                        selectedListingActivityOption: currentListingActivityOption,
                        listingOwnerProfile: listingOwnerProfile,
                        selectedFacilityBooking: selectedReservationItem ?? ReservationItem(
                            reservationId: ReservationItem.empty().reservationId,
                            reservationOwnerId: currentUser.userId,
                            instanceId: listing.listingServiceId,
                            reservationCost: listing.listingRulesService.defaultPricingRuleSettings.defaultPricingRate.toString(),
                            reservationState: ReservationSlotState.confirmed,
                            paymentStatus: ReservationItem.empty().paymentStatus,
                            paymentIntentId: ReservationItem.empty().paymentIntentId,
                            reservationSlotItem: [],
                            isInternalProgram: listing.listingProfileService.backgroundInfoServices.listingOwner.getOrCrash() == currentUser.userId.getOrCrash(),
                            customFieldRuleSetting: listing.listingReservationService.customFieldRuleSetting,
                            dateCreated: DateTime.now()
              )
            ),
          ),
        ),
      ],
    );
  }
}