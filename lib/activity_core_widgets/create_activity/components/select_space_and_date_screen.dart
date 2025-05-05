
import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_application/check_in_application.dart';

class SelectSpaceAndDatesScreen extends StatefulWidget {
  
  final DashboardModel model;
  final UserProfileModel currentUser;
  final ListingManagerForm currentFacility;
  final ReservationItem? initReservation;
  final Function(ReservationItem) didChangeReservationItem;

  const SelectSpaceAndDatesScreen({super.key, required this.model, required this.currentFacility, required this.didChangeReservationItem, this.initReservation, required this.currentUser});

  @override
  State<SelectSpaceAndDatesScreen> createState() => _SelectSpaceAndDatesScreenState();
}

class _SelectSpaceAndDatesScreenState extends State<SelectSpaceAndDatesScreen> {

  late ReservationItem? selectedReservationItem = null;
  
   @override
  void initState() {
    selectedReservationItem = widget.initReservation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height
        ),
        retrieveExistingFacilityRes(widget.currentFacility, widget.currentUser
        ),
        Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: Column(
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: widget.model.webBackgroundColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text('Back', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (selectedReservationItem != null && selectedReservationItem?.reservationSlotItem.isNotEmpty == true) {
                                widget.didChangeReservationItem(selectedReservationItem!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Please select slots to confirm your dates',
                                      style: TextStyle(color: widget.model.accentColor),
                                    ),
                                    backgroundColor: widget.model.paletteColor,
                                  ),
                                );
                              }
                            });
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: (selectedReservationItem != null && selectedReservationItem?.reservationSlotItem.isNotEmpty == true) ? widget.model.paletteColor : widget.model.accentColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Center(child: Text('Confirm Selected Slots', style: TextStyle(color: (selectedReservationItem != null && selectedReservationItem?.reservationSlotItem.isNotEmpty == true) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget retrieveExistingFacilityRes(ListingManagerForm facility, UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([facility.listingServiceId.getOrCrash()], null, null, [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current])),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            // resLoadInProgress: (_) => progressOverlay(model),
            loadReservationListSuccess: (e) => retrieveFacilityOwner(e.item, facility, currentUser),
            loadReservationListFailure: (_) => retrieveFacilityOwner([], facility, currentUser),
            ///TODO: add failure of type empty
            /// if network call cant be made you should not be allowed to make any new reservation
            orElse: () => retrieveFacilityOwner([], facility, currentUser));
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

  Widget getReservation(ListingManagerForm listing, UserProfileModel listingOwnerProfile, UserProfileModel currentUser, List<ReservationItem> reservations,) {
            print('found reservation');
            UniqueId? selectedActivityType;
            SpaceOption currentSelectedSpace = listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => SpaceOption.empty(), (r) => r.first);
            SpaceOptionSizeDetail? currentSelectedSpaceOption = listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => null, (r) => r[0].quantity[0]);
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
                  child: AddNewReservationSlots(
                      model: widget.model,
                      listing: listing,
                      reservations: reservations,
                      isPopOver: false,
                      didSaveReservation: (res) {
                        setState(() {
                          selectedReservationItem = res;
                        });
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
                          customFieldRuleSetting: listing.listingReservationService.customFieldRuleSetting,
                          dateCreated: DateTime.now()
                            )
                          ),
        ),
      ],
    );
  }

}