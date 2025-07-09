import 'dart:math';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/activity_core_widgets/create_activity/components/select_more_info_screen.dart';
import 'package:check_in_presentation/activity_core_widgets/pop_over_main_container_widgets/create_new_vendor_form/widgets/welcome_message_widget.dart';
import 'package:check_in_presentation/core/ios_core/image_selector_widget_mobile.dart' if (dart.library.html) 'package:check_in_presentation/core/web_core/image_selector_widget_web.dart';
import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hovering/hovering.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:check_in_presentation/core/ios_core/single_image_selector_widget_mobile.dart' if (dart.library.html) 'package:check_in_presentation/core/web_core/single_image_selector_widget_web.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'create_activity_screen_2_helper.dart';

class CreateReservationActivityFormWidget extends StatefulWidget {

final DashboardModel model;
final ListingManagerForm? currentListing;
final ReservationItem? initReservation;
final bool isPopOver;
final Function(ReservationItem) isSaving;
final Function(ReservationItem) isPublishing;

const CreateReservationActivityFormWidget({super.key, required this.model, this.currentListing, required this.isPopOver, this.initReservation, required this.isSaving, required this.isPublishing});

  @override
  State<CreateReservationActivityFormWidget> createState() => _CreateReservationActivityFormWidgetState();
}

class _CreateReservationActivityFormWidgetState extends State<CreateReservationActivityFormWidget> {

  late bool isLoadingLogin = false;
  late bool isHovering = false;
  late bool reloadMain = false;
  late ScrollController? _scrollController = null;
  late ListingManagerForm? _currentSelectedListing = null;
  late ListingManagerForm? _currentSelectedNewListing = null;
  late ActivityManagerForm _currentActivityForm = ActivityManagerForm.empty();
  final _random = Random();

  Map<String?, double> ruleIdToHeight = {
    '6e24dae0-96dd-11eb-babc-gykug7878f67': 225.0,
    '6e24dae0-96dd-11eb-babc-ghgv676f7676': 150.0,
    '6e24dae0-96dd-11eb-babc-joij90hh7hii': 95.0,
    '6e24dae0-96dd-11eb-babc-weifunbi938b': 165.0,
  };

  @override
  void initState() {
    _scrollController = ScrollController();
    

    // _currentSelectedListing = widget.currentListing;
    if (widget.initReservation != null) updateListing();
    if (widget.initReservation != null) updateActivityForm();

    if (widget.initReservation != null) {
      initReload();
    }

    super.initState();
  }

  void updateListing() async {
    setState(() {
       reloadMain = true;
    });
    if (widget.initReservation == null) {
      reloadMain = false;
      return;
    }
    try {
      _currentSelectedListing = await ListingFacade.instance.getListingManagerItem(listingId: widget.initReservation!.instanceId.getOrCrash());
      
      setState(() {
         reloadMain = false;
      });
    } catch (e) {
      
    }
  }

  void updateActivityForm() async {
    reloadMain = true;
    if (widget.initReservation == null) {
      reloadMain = false;
      return;
    }

  try {

    _currentActivityForm = await ActivitySettingsFacade.instance.getActivitySettings(reservationId: widget.initReservation!.reservationId.getOrCrash());
    reloadMain = false;
  } catch (e) {

  }

  }


  void initReload() {
    reloadMain = true;

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        reloadMain = false;
      });
    });
  }

  List<FormCreatorContainerModel> formOption(BuildContext context, UserProfileModel currentUser, double customOptionsHeight, double customDisclaimerHeight, ReservationItem form, AutovalidateMode validator) => [

          /// if true host and cost is involved - should not say publish should say send confirmation - or process like a ?   

          /// select dates, if dates already have a reservation - present and ask if this is the reservation they are creating?
            /// ongoing reservation? ask to include all dates
            /// start and end timmes (optional, if known)

          /// if not a pre-existing reservation, show required input fields
          /// 1. Activity Name*
          FormCreatorContainerModel(
            formHeaderIcon: Icons.post_add,
            formHeaderTitle: 'Activity Name',
            formHeaderSubTitle: 'What is the name of your activity?',
            formMainCreatorWidget: vendorFormTextField(
                    context,
                    widget.model, 
                    1, 
                    (_currentActivityForm.profileService.activityBackground.activityTitle.isValid() == true) ? _currentActivityForm.profileService.activityBackground.activityTitle.getOrCrash() : '', 
                    'Make this reservation special by adding a title', 
                    'Another Market...', 
                    onChanged: (text) {
                      setState(() {

                        _currentActivityForm = _currentActivityForm.copyWith(
                            profileService: _currentActivityForm.profileService.copyWith(
                            activityBackground: _currentActivityForm.profileService.activityBackground.copyWith(
                              activityTitle: BackgroundInfoTitle(text)
                            )
                          )
                        );
                      });
                    }
                  ),
            height: 130,
            showAddIcon: true,
            didSelectActivate: (bool isActivated) {
              setState(() {
                isHovering = isActivated;
              });
            },
            isActivated: isHovering,
            isRequired: true,
            errorMessage: 'Write what you your calling this Activity!',
            showErrorMessage: validator == AutovalidateMode.always && (_currentActivityForm.profileService.activityBackground.activityTitle.isValid() == true),
          ),
           FormCreatorContainerModel(
            formHeaderIcon: Icons.post_add,
            formHeaderTitle: 'Activity Descirption',
            formHeaderSubTitle: null,
            formMainCreatorWidget: vendorFormTextField(
                    context,
                    widget.model, 
                    3, 
                    (_currentActivityForm.profileService.activityBackground.activityDescription1.isValid() == true) ? _currentActivityForm.profileService.activityBackground.activityDescription1.getOrCrash() : '', 
                    null, 
                    'Tell them what you have in store..', 
                    onChanged: (text) {
                      setState(() {
                        _currentActivityForm = _currentActivityForm.copyWith(
                          profileService: _currentActivityForm.profileService.copyWith(
                            activityBackground: _currentActivityForm.profileService.activityBackground.copyWith(
                              activityDescription1: BackgroundInfoDescription(text)
                            )
                          )
                        );
                      });
                    }
                  ),
            height: 140,
            showAddIcon: true,
            didSelectActivate: (bool isActivated) {
              setState(() {
                isHovering = isActivated;
              });
            },
            isActivated: isHovering,
            isRequired: true,
            errorMessage: 'Write what you your calling this Activity!',
            showErrorMessage: validator == AutovalidateMode.always && (_currentActivityForm.profileService.activityBackground.activityDescription1.isValid() == true),
          ),
          FormCreatorContainerModel(
            formHeaderIcon: Icons.post_add,
            formHeaderTitle: 'Activity Type',
            formHeaderSubTitle: 'What kind of Activity is it?',
            formMainCreatorWidget: Column(
              children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: getActivityOptions().map((activityType) {
                      return Container(
                        height: 50,
                        child: HoverButton(
                          onpressed: () {
                             setState(() {
                              _currentActivityForm =  _currentActivityForm.copyWith(
                                activityTypes: (_currentActivityForm.activityTypes ?? []).map((e) => e.activity).contains(activityType.activity)
                                    ? (_currentActivityForm.activityTypes ?? []).where((e) => e.activity != activityType.activity).toList()
                                    : [...(_currentActivityForm.activityTypes ?? []), activityType],
                                );
                             });
                          },
                          animationDuration: Duration.zero,
                          color: (_currentActivityForm.activityTypes ?? []).map((e) => e.activity).contains(activityType.activity) ? widget.model.paletteColor : widget.model.accentColor,
                          hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                          hoverElevation: 0,
                          highlightElevation: 0,
                          hoverShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            // side: BorderSide(color: model.disabledTextColor, width: 1),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          
                          // hoverPadding: EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding
                          elevation: 0,
                          child: Text(getTitleForActivityOption(context, activityType.activity) ?? '', textAlign: TextAlign.center, style: TextStyle(color: (_currentActivityForm?.activityTypes ?? []).map((e) => e.activity).contains(activityType.activity) ? widget.model.accentColor : widget.model.paletteColor))
                        )
                      );
                    }).toList(),
                  )
              ]
            ),
            height: 130,
            showAddIcon: true,
            didSelectActivate: (bool isActivated) {
              setState(() {
                isHovering = isActivated;
              });
            },
            isActivated: isHovering,
            isRequired: true,
            errorMessage: 'Please pick at least one activity type!',
            showErrorMessage: validator == AutovalidateMode.always && ((_currentActivityForm.activityTypes ?? []).isNotEmpty == true),
          ),

          /// preset activity options...
          /// corrispoding activity example or template...
          FormCreatorContainerModel(
            formHeaderIcon: Icons.pin_drop_outlined, 
            formHeaderTitle: 'Pick a Location', 
            /// option to pick from a map
            /// option to pick from 5 top listings
            /// option to search/query google API
            /// option to upload 
            formMainCreatorWidget: Row(
              children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0, right: 4.0),
                      child: Container(
                          height: 250,
                          width: 250,
                        child: HoverButton(
                          onpressed: () {
                               didSelectAddNewLocation(
                                  context, 
                                  widget.model,
                                  currentUser,
                                  _currentSelectedNewListing?.listingProfileService.listingLocationSetting,
                                  didUpdateFacility: (facility) {
                                    setState(() {
                                      _currentSelectedNewListing = null;
                                      context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems([], facility.listingProfileService.backgroundInfoServices.currency));
                                      context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeFacilityId(facility.listingServiceId));
                                      _currentSelectedListing = facility;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  didUpdateLocation: (location) {
                                    _currentSelectedListing = null;
                                    _currentSelectedNewListing = ListingManagerForm.empty();

                                    setState(() {
                                      _currentSelectedNewListing = _currentSelectedNewListing?.copyWith(
                                          listingProfileService: _currentSelectedNewListing!.listingProfileService.copyWith(
                                            backgroundInfoServices: _currentSelectedNewListing!.listingProfileService.backgroundInfoServices.copyWith(
                                              listingOwner: currentUser.userId,
                                            ),
                                            spaceSetting: SpaceSettings(
                                                facilityTypeId: FacilityTypeOption.empty(),
                                                spaceTypes: ListK(getSpaceTypeOptions(context).map((e) => SpaceOption(uid: e.uid, quantity: [SpaceOptionSizeDetail.empty()], sports: [])).toList())
                                              ),
                                           listingLocationSetting: location
                                        )
                                      );
                                    });
                                    Navigator.of(context).pop();
                                }
                              );
                          },
                          color: widget.model.accentColor,
                          hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                          hoverElevation: 0,
                          highlightElevation: 0,
                          hoverShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          animationDuration: Duration.zero,
                          elevation: 0,
                          child:  Container(
                            height: 250,
                            width: 250,
                            child: Stack(
                              children: [
                                
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                            child: SvgPicture.asset('assets/icons_svg/search_explore/noun-world-map-751007.svg',  fit: BoxFit.fitWidth, color: (_currentSelectedNewListing != null) ? widget.model.paletteColor : widget.model.disabledTextColor, width: 240)
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(25)),
                                                    color: (_currentSelectedNewListing != null) ? widget.model.paletteColor : widget.model.accentColor,
                                                  ),
                                                  child: (_currentSelectedNewListing != null) ? Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Edit New Location', style: TextStyle(color: widget.model.accentColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true),
                                            ) : Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Add New Location', style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,),
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ]
                                ),
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                  

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 4.0, right: 8.0),
                      child: Container(
                        height: 250,
                        width: 250,
                        child: HoverButton(
                          onpressed: () {
                            didSelectSearchLocation(
                                context,
                                  widget.model, 
                                  currentUser, 
                                  null, 
                                  didSelectFacility: (facility) {
                                  setState(() {
                                    _currentSelectedNewListing = null;
                                    context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems([], facility.listingProfileService.backgroundInfoServices.currency));
                                    context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeFacilityId(facility.listingServiceId));
                                    _currentSelectedListing = facility;
                                  });
                                Navigator.of(context).pop();
                              }
                            );   
                          },
                          color: widget.model.accentColor,
                          hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                          hoverElevation: 0,
                          highlightElevation: 0,
                          hoverShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          animationDuration: Duration.zero,
                          elevation: 0,
                          child: Container(
                            height: 250,
                            width: 250,
                            child: Stack(
                              children: [
                                if (_currentSelectedListing != null) IgnorePointer(
                                  ignoring: true,
                                  child: Container(
                                    height: 250,
                                    width: 250,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: ListingResultMain(
                                        showReservations: false,
                                        listing: _currentSelectedListing!,
                                        isLoading: false,
                                        model: widget.model,
                                        didSelectEmbeddedRes: (listing, res) {
                                      
                                        },
                                        didSelectListingItem: (listing) {},
                                        didChangeSpaceOptionItem: (SpaceOptionSizeDetail space) {
                                          
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                        Radius.circular(25)),
                                        child: Icon(Icons.apartment_outlined, size: 100, color: (_currentSelectedListing != null) ? widget.model.paletteColor : widget.model.disabledTextColor)
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                color: (_currentSelectedListing != null) ? widget.model.paletteColor : widget.model.accentColor,
                                              ),
                                            child: (_currentSelectedListing != null) ? Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Edit Selected', style: TextStyle(color: widget.model.accentColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true),
                                            ) : Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text('Mapped Locations', style: TextStyle(color: widget.model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,),
                                            )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ]
                                                          ),
                              ],
                            ),
                                              ),
                        ),
                      ),
                  )
                )
              ],
            ), 
            height: 250, 
            showAddIcon: false, 
            didSelectActivate: (isActivated) {
            }, 
            isActivated: true,
            isRequired: true,
            hasHoverEffect: false,
          ),

          
          /// 2. Activity Description*  
          /// 3. Activity Location (show list of existing locations if location does not exist select via map & create a temporary location)
          ///     - New Locations can also add:
          ///      - Location Name & Description
          ///      - Contact Details (how to reac\
          ///      - Parking
          ///      - Barriers (stairs, elevator, wheelchair accessible)
          ///      - Amenities (kitchen, bar, storage, free parking, wifi)
          ///      - SQ FT (conversion to occupancy etsimate)
          ///      - Capacity (seating, standing, etc)
          ///      - Location Type (indoor, outdoor, etc)
          ///      - Location Pictures (placeholder or official location pictures)  
          ///      - Equipment (tables, chairs, etc...for fee)
          ///      - Possible Rental Fee (free, donation, paid)
          ///      - Request Verification (get this place verified)
          ///      - Rental Status (available, no longer renting..) 
          ///      - contact details related to current renter/owner
          
          /// pick date or add location details?
          /// corrisponds with space options from facility - if no options exist present the option to include details about the space/pictures, can also add amenities, parking, info etc.
          FormCreatorContainerModel(
            formHeaderIcon: Icons.calendar_today, 
            formHeaderTitle: 'Which Dates and what Hours', 
            formHeaderSubTitle:  (_currentSelectedListing == null || _currentSelectedNewListing == null) ? 'Select or create a Location before picking your dates!' : null,
            /// make hover effect for formMainCreatorWidget 
            formMainCreatorWidget: InkWell(
              onTap: () {
                if (_currentSelectedListing != null) {
                  didSelectSpaceAndTimeOptions(
                    context,
                    widget.model,
                    currentUser,
                    _currentSelectedListing!,
                    form,
                    didSelectReservation: (reservation) {
                      context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems(reservation.reservationSlotItem, _currentSelectedListing!.listingProfileService.backgroundInfoServices.currency));
                      
                      Navigator.of(context).pop();
                    },
                  );
                }
                if (_currentSelectedNewListing != null) {
                  didSelectSpaceAndTimeOptions(
                    context,
                    widget.model,
                    currentUser,
                    _currentSelectedNewListing!,
                    form,
                    didSelectReservation: (reservation) {
                     context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems(reservation.reservationSlotItem, _currentSelectedNewListing!.listingProfileService.backgroundInfoServices.currency));
                      Navigator.of(context).pop();
                    },
                  );
                }
              },
              child: (isReservationSlotValid(form)) ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                
                    Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                    ),
                
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: Padding(
                          //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //     child: Column(
                          //         children: getSpacesFromSelectedReservationSlot(context, _currentSelectedNewListing!, form.reservationSlotItem ?? []).map(
                          //                 (e) => Padding(
                          //               padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //               child: getSelectedSpaces(context, e, widget.model),
                          //             )
                          //         ).toList()
                          //     ),
                          //   ),
                          // ),
                      
                          /// ------------------------ ///
                          /// your booking
                          // const SizedBox(height: 5),
                          // Divider(color: widget.model.paletteColor),
                          // const SizedBox(height: 5),
                      
                          Text('Your Booking Slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                      
                          if (_currentSelectedNewListing != null) viewListOfSelectedSlots(
                            context,
                            widget.model,
                            [],
                            form.reservationSlotItem,
                            [],
                            false,
                            AppLocalizations.of(context)!.profileFacilitySlotTime,
                            AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                            AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                            _currentSelectedNewListing!,
                            didSelectReservation: (e) {
                              didSelectSpaceAndTimeOptions(
                                context,
                                widget.model,
                                currentUser,
                                _currentSelectedNewListing!,
                                form,
                                didSelectReservation: (reservation) {
                                context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems(reservation.reservationSlotItem, _currentSelectedNewListing!.listingProfileService.backgroundInfoServices.currency));
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            didSelectCancelResSlot: (e, f) {
                              
                            },
                            didSelectRemoveResSlot: (e, f) {
                      
                            }
                          ),
                      
                          if (_currentSelectedListing != null) viewListOfSelectedSlots(
                            context,
                            widget.model,
                            [],
                            form.reservationSlotItem,
                            [],
                            false,
                            AppLocalizations.of(context)!.profileFacilitySlotTime,
                            AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                            AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                            _currentSelectedListing!,
                            didSelectReservation: (e) {
                              didSelectSpaceAndTimeOptions(
                                context,
                                widget.model,
                                currentUser,
                                _currentSelectedListing!,
                                form,
                                didSelectReservation: (reservation) {
                                  context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems(reservation.reservationSlotItem, _currentSelectedListing!.listingProfileService.backgroundInfoServices.currency));
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            didSelectCancelResSlot: (e, f) {
                              
                            },
                            didSelectRemoveResSlot: (e, f) {
                      
                            }
                          )
                        ]
                      ),
                    ),
                
                    Positioned(
                      bottom: 15,
                      child: Container(
                      height: 50,
                      child: HoverButton(
                        onpressed: () {
                            if (_currentSelectedListing != null) {
                            didSelectSpaceAndTimeOptions(
                              context,
                              widget.model,
                              currentUser,
                              _currentSelectedListing!,
                              form,
                              didSelectReservation: (reservation) {
                                context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems(reservation.reservationSlotItem, _currentSelectedListing!.listingProfileService.backgroundInfoServices.currency));
                                Navigator.of(context).pop();
                              },
                            );
                          }
                          if (_currentSelectedNewListing != null) {
                            didSelectSpaceAndTimeOptions(
                              context,
                              widget.model,
                              currentUser,
                              _currentSelectedNewListing!,
                              form,
                              didSelectReservation: (reservation) {
                              context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationSlotItems(reservation.reservationSlotItem, _currentSelectedNewListing!.listingProfileService.backgroundInfoServices.currency));
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        },
                        animationDuration: Duration.zero,
                        color: widget.model.paletteColor,
                        hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                        hoverElevation: 0,
                        highlightElevation: 0,
                        hoverShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // side: BorderSide(color: model.disabledTextColor, width: 1),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        // hoverPadding: EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                        hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding
                        elevation: 0,
                        child: Text('Edit Selected Dates', textAlign: TextAlign.center, style: TextStyle(color: widget.model.accentColor))
                        )
                      ),
                    )
                  ],
                )
              ) : Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title for Select a Space
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Select a Space',
                        style: TextStyle(
                          color: widget.model.paletteColor,
                        ),
                      ),
                    ),
                    // Row of blank space Containers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            height: 85,
                            width: 65,
                            decoration: BoxDecoration(
                              color: widget.model.accentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: widget.model.disabledTextColor.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            )
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    // Title for Select a Date and Time
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Select a Date and Time',
                        style: TextStyle(
                          color: widget.model.paletteColor,
                        ),
                      ),
                    ),
                    // GridView for empty calendar slots
                    Container(
                      // height: 300, // Adjust height as needed
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 3, 
                        ),
                        itemCount: 4, // Number of empty slots
                        itemBuilder: (context, index) {
                          final double paddingValue = 1 + _random.nextInt(70).toDouble();
                          final double subPaddingValue = 5 + _random.nextInt(70).toDouble();

                          return Container(
                            decoration: BoxDecoration(
                              color: widget.model.accentColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: ListTile(
                                leading: Icon(Icons.calendar_today, size: 35, color: widget.model.disabledTextColor),
                                title: Padding(
                                  padding: EdgeInsets.only(right: paddingValue),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                    color: widget.model.disabledTextColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 8, right: subPaddingValue),
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                    color: widget.model.disabledTextColor.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            height: 400, 
            showAddIcon: false, 
            isLocked: _currentSelectedListing == null || _currentSelectedNewListing == null,
            hasHoverEffect: !isReservationSlotValid(form),
            didSelectActivate: (isActivated) {

            }, 
            isActivated: _currentSelectedListing != null || _currentSelectedNewListing != null,
            isRequired: _currentSelectedListing != null || _currentSelectedNewListing != null
          ),

          /// 4. Activity Pictures (placeholder or official event flyer..)
          FormCreatorContainerModel(
            formHeaderIcon: Icons.camera_alt_outlined, 
            formHeaderTitle: 'Flyers or Pics?', 
            formMainCreatorWidget: Column(
              children: [
                /// preset images
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HoverButton(
                      onpressed: () {
                        
                      },
                      color: widget.model.accentColor,
                      hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                      hoverElevation: 0,
                      highlightElevation: 0,
                      hoverShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      animationDuration: Duration.zero,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding   
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text('Pick From Presets', textAlign: TextAlign.center, style: TextStyle(color: widget.model.paletteColor)),
                        ),
                      ),
                    ),
                    if ((_currentActivityForm.profileService.activityBackground.activityProfileImages ?? []).isNotEmpty) HoverButton(
                      onpressed: () {
                         setState(() {
                          _currentActivityForm = _currentActivityForm.copyWith(
                            profileService: _currentActivityForm.profileService.copyWith(
                              activityBackground: _currentActivityForm.profileService.activityBackground.copyWith(
                                  activityProfileImages: null
                              )
                            )
                          );
                        });
                      },
                      color: widget.model.paletteColor,
                      hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                      hoverElevation: 0,
                      highlightElevation: 0,
                      hoverShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      animationDuration: Duration.zero,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                      hoverPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Same as default padding   
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(' Clear All ', textAlign: TextAlign.center, style: TextStyle(color: widget.model.accentColor)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                // ImageSelectorWithPreview(
                  ImageSelectorWithPreview(
                    model: widget.model,
                    showTitle: false,
                    currentImageList: _currentActivityForm.profileService.activityBackground.activityProfileImages ?? [],
                    imagesToUpLoad: (images) {
                      setState(() {
                         _currentActivityForm = _currentActivityForm.copyWith(
                          profileService: _currentActivityForm.profileService.copyWith(
                            activityBackground: _currentActivityForm.profileService.activityBackground.copyWith(
                                activityProfileImages: images
                            )
                          )
                        );
                    });
                  },
                )
              ],
            ), 
            height: 430, 
            showAddIcon: false, 
            didSelectActivate: (isActivated) {
              
            }, 
            isLocked: _currentSelectedListing == null || _currentSelectedNewListing == null,
            isActivated: _currentSelectedListing != null || _currentSelectedNewListing != null,
            isRequired: _currentSelectedListing != null || _currentSelectedNewListing != null
          ),
          /// (optional)
          /// 4. autofil - depending on activity tyoe? (market, pop-up...),
          FormCreatorContainerModel(
            formHeaderIcon: Icons.settings_accessibility_outlined, 
            formHeaderTitle: 'More Details..', 
            formMainCreatorWidget: Column(
              children: [
                /// 6. Activity Circle (create a new circle or show a list of circles to select from)
                /// 7. Links (title and link, for example application form, ticket link etc.)
                /// 7. Food or Alcohol? (yes or no)
                /// 8. Age Restrictions? (yes or no)
                /// 10. Ticket Link (if paid)
                /// 11. Private or Public?
                
                AdditionalDetailsWidget(
                  model: widget.model, 
                  activityForm: _currentActivityForm, 
                  reservation: form,
                  didSelectLinkCircle: () {

                  },
                  isTicketedChanged: (value) {
                    setState(() {
                      _currentActivityForm = _currentActivityForm.copyWith(
                          activityAttendance: _currentActivityForm.activityAttendance.copyWith(
                            isTicketBased: value
                          )
                        );
                    });
                  }, 
                  isAgeRestrictedChanged: (value) {
                    setState(() {
                      _currentActivityForm = _currentActivityForm.copyWith(
                          profileService: _currentActivityForm.profileService.copyWith(
                            activityRequirements: _currentActivityForm.profileService.activityRequirements.copyWith(
                                isAgeRestricted: value
                            )
                          )
                        );
                    });
                  },
                  isPrivateChanged: (value) {
                    context.read<ReservationFormBloc>().add(ReservationFormEvent.didChangeReservationIsPrivate(value));
                  }, 
                  onLinkedCirclesChanged: (links) {
                    
                  }
                )
              ],
            ), 
            height: 230, 
            showAddIcon: false, 
            didSelectActivate: (isActivated) {
              
            }, 
            isLocked: _currentSelectedListing == null || _currentSelectedNewListing == null,
            isActivated: _currentSelectedListing != null || _currentSelectedNewListing != null,
            isRequired: _currentSelectedListing != null || _currentSelectedNewListing != null
          ),
         
          /// 13. Know who's Hosting?
          /// if not host - add host details
            /// 1. Socials,
            /// 2. Email,
            /// 3. Website, 
            /// 4. I am hosting,
          /// 14. Send Invites? 
          
          /// are you the hosting or know the host?
            /// if yes, add host details
            /// name,
            /// partners,
            /// socials,
            /// email,
            
            FormCreatorContainerModel(
              formHeaderIcon: Icons.person,
              formHeaderTitle: 'Host Details',
              formHeaderSubTitle: 'Who is hosting this event?',
              formMainCreatorWidget: Column(
                children: [
                  // Text('We will assume this event will be a post unless you specify otherwise', style: TextStyle(color: widget.model.paletteColor)),
                  ListTile(
                    leading: Icon(Icons.person_outline, color: widget.model.paletteColor),
                    title: Text('I will be the Host', style: TextStyle(color: widget.model.paletteColor)),
                    subtitle: Text('Leave this blank and add the Host details below if you are not the host', style: TextStyle(color: widget.model.disabledTextColor)),
                    trailing: Container(
                      width: 60,
                      child: FlutterSwitch(
                        width: 60, 
                        activeColor: widget.model.paletteColor,
                        inactiveColor: widget.model.accentColor,
                        value: _currentActivityForm.profileService.isTrueOwner ?? false,
                        onToggle: (val) {
                          setState(() {
                            _currentActivityForm = _currentActivityForm.copyWith(
                              profileService: _currentActivityForm.profileService.copyWith(
                                isTrueOwner: val
                              )
                            );
                          });
                        },
                      ),
                    ),
                  ),
                  mainActivityBackgroundContainerFooter(
                    context: context,
                    model: widget.model,
                    activityForm: _currentActivityForm,
                    contactEmailChanged: (value) {
                      setState(() {
                        _currentActivityForm = _currentActivityForm.copyWith(
                          profileService: _currentActivityForm.profileService.copyWith(
                            postContactEmail: value
                          )
                        );
                      });
                    },
                    contactWebsiteChanged: (value) {
                      setState(() {
                        _currentActivityForm = _currentActivityForm.copyWith(
                          profileService: _currentActivityForm.profileService.copyWith(
                            postContactWebsite: value
                          )
                        );
                      });
                    },
                    contactInstagramChanged: (value) {
                      setState(() {
                        _currentActivityForm = _currentActivityForm.copyWith(
                          profileService: _currentActivityForm.profileService.copyWith(
                            postContactSocialInstagram: value
                          )
                        );
                      });
                    }
                  )
                ]
              ),
              height: 580,
              showAddIcon: false,
              didSelectActivate: (bool isActivated) {
                setState(() {
                  isHovering = isActivated;
                });
              },
              isActivated: isHovering,
              showErrorMessage: false,
              errorMessage: null,
              formSubHelper: null,
              isLoading: false 
            ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PointerInterceptor(
        child: Stack(
          children: [
             Container(
                  color: widget.model.webBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height
              ),
              if (isLoadingLogin == true) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
              if (isLoadingLogin == false) retrieveAuthenticationState(context),
          ]
        )
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
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: kToolbarHeight + 8.0),
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
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        elevation: 0,
                        toolbarHeight: kToolbarHeight,
                        backgroundColor: widget.model.webBackgroundColor,
                        // title: Text(state.reservationItem?.activityTitle ?? 'Create Your Activity', style: TextStyle(color: widget.model.accentColor)),
                        actions: [
                          
                        ],
                      ),
                    )
                  ],
                ),
            )
          );
        },
      ),
    );
  }


  Widget getMainContainer(BuildContext context, UserProfileModel currentUser) {

    return BlocProvider(create: (_) => getIt<ReservationFormBloc>()..add(ReservationFormEvent.initializedReservation(
        dart.optionOf(widget.initReservation ?? ReservationItem.empty())
       )
      ),
      child: BlocConsumer<ReservationFormBloc, ReservationFormState>(
        listenWhen: (p,c) => p.isPublishing != c.isPublishing || p.isSaving != c.isSaving,
        listener: (context, state) {

          state.authFailureOrSuccessPublishOption.fold(
            () {},
            (either) => either.fold((failure) {
                 final snackBar = SnackBar(
              backgroundColor: Colors.red,
              content: failure.maybeMap(
                invalidDate: (_) => Text('Sorry, the Date(s) You Have Selected are Conflicting', style: TextStyle(color: widget.model.disabledTextColor)),
                waitingForPaymentConfirmation: (_) => Text('Waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                paymentResultError: (_) => Text('Please Fill Out Payment Method Details', style: TextStyle(color: widget.model.disabledTextColor)),
                reservationServerError: (e) => Text(e.failed ?? 'Server Error', style: TextStyle(color: widget.model.disabledTextColor)),
                orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
              ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }, (_) {

                widget.isPublishing(state.reservationItem);
                Navigator.of(context).pop();
              }
            )
          );

          state.authFailureOrSuccessSavingOption.fold(
            () {},
            (either) => either.fold((failure) {
                 final snackBar = SnackBar(
              backgroundColor: Colors.red,
              content: failure.maybeMap(
                invalidDate: (_) => Text('Sorry, the Date(s) You Have Selected are Conflicting', style: TextStyle(color: widget.model.disabledTextColor)),
                waitingForPaymentConfirmation: (_) => Text('Waiting for payment confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                paymentResultError: (_) => Text('Please Fill Out Payment Method Details', style: TextStyle(color: widget.model.disabledTextColor)),
                reservationServerError: (e) => Text(e.failed ?? 'Server Error', style: TextStyle(color: widget.model.disabledTextColor)),
                orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
              ));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }, (_) {

                widget.isSaving(state.reservationItem);
                Navigator.of(context).pop();
              }
            )
          );
        }, 
        buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages || p.reservationItem != c.reservationItem || p.isEditingForm != c.isEditingForm || p.isPublishing != c.isPublishing || p.isSaving != c.isSaving,
        builder: (context, state) {

        // double
        final bool isPublishedForm = widget.initReservation?.formStatus == FormStatus.published;
        final isValidForm = isReservationFormValid(state.reservationItem, _currentActivityForm, _currentSelectedListing ?? _currentSelectedNewListing);
        final bool isNewForm = widget.initReservation == null;

          return Stack(
            children: [
              Form(
                autovalidateMode: state.showErrorMessages,
                child: (reloadMain) 
                  ? Center(child: JumpingDots(numberOfDots: 3, color: widget.model.accentColor)) 
                  : Padding(
                    padding: EdgeInsets.only(top: kToolbarHeight + 20),
                    child: FormCreatorDashboardMain(
                    model: widget.model,
                    formContainerItem: formOption(context, currentUser, 10, 100, state.reservationItem, state.showErrorMessages),
                    showPreview: true,
                    previewFormWidget: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: Container(
                      height: 950,
                      width: 436,
                      child: SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                            children: [
                                  getActivityBackgroundForPreview(
                                    context,
                                    widget.model,
                                    true,
                                    true,
                                    currentUser.userId.getOrCrash(),
                                    _currentActivityForm,
                                    state.reservationItem,
                                    [],
                                    currentUser
                                  ),
                                  getActivityRequirementsColumn(
                                    context,
                                    widget.model,
                                    false,
                                    true,
                                    false,
                                    currentUser,
                                    _currentActivityForm,
                                    state.reservationItem,
                                    [],
                                    [],
                                    currentUser.userId.getOrCrash(),
                                    didSelectAttendees: () {
                            
                                    }
                                  ),
                                  const SizedBox(height: 12),
                                  if (_currentSelectedListing != null) FacilityOverviewInfoWidget(
                                    model: widget.model,
                                    overViewState: FacilityPreviewState.listingPreview,
                                    newFacilityBooking: state.reservationItem,
                                    reservations: [],
                                    /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
                                    listingOwnerProfile: currentUser,
                                    listing: _currentSelectedListing!,
                                    selectedReservationsSlots: null,
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
                                  if (_currentSelectedNewListing != null) FacilityOverviewInfoWidget(
                                    model: widget.model,
                                    overViewState: FacilityPreviewState.listingPreview,
                                    newFacilityBooking: state.reservationItem,
                                    reservations: [],
                                    /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
                                    listingOwnerProfile: currentUser,
                                    listing: _currentSelectedNewListing!,
                                    selectedReservationsSlots: null,
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
                                ]
                              ),
                          ),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  scrolledUnderElevation: 0,
                  toolbarHeight: 90,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  backgroundColor: widget.model.webBackgroundColor,
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.cancel, color: widget.model.paletteColor, size: 40,),
                    tooltip: 'Cancel',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Column(
                    children: [
                      Text((_currentActivityForm.profileService.activityBackground.activityTitle.isValid() == true) ? 'Creating: ${_currentActivityForm.profileService.activityBackground.activityTitle.getOrCrash()}' : 'Create Your Activity', style: TextStyle(color: widget.model.paletteColor)),
                      const SizedBox(height: 5),
                      Text(state.reservationItem.formStatus?.name ?? FormStatus.inProgress.name, style: TextStyle(color: widget.model.disabledTextColor,  fontSize: 14)),
                    ],
                  ),
                  actions: (state.isPublishing || state.isSaving) ? [
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                    child: JumpingDots(numberOfDots: 3,  color: widget.model.paletteColor)
                    )
                  ] : [
                    
                    if (isNewForm || !(isPublishedForm)) Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () {
                          context.read<ReservationFormBloc>().add(ReservationFormEvent.didFinishSavingReservation(_currentActivityForm, _currentSelectedNewListing));
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
                          context.read<ReservationFormBloc>().add(ReservationFormEvent.didFinishSavingReservation(_currentActivityForm, _currentSelectedNewListing));
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

                    if (isNewForm) Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () {
                            context.read<ReservationFormBloc>().add(ReservationFormEvent.didFinishPublishingReservation(_currentActivityForm, _currentSelectedNewListing));
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
                              ))
                          ),
                        ),
                      ),

                      /// if published update (on valid condition)
                      /// show errors on publish attempt
                      if (!(isNewForm)) Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: InkWell(
                          onTap: () {
                            context.read<ReservationFormBloc>().add(ReservationFormEvent.didFinishPublishingReservation(_currentActivityForm, _currentSelectedNewListing));
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
                ),
              )
              // AppBar(
              //   toolbarHeight: 50,
              //   actions: [],
              // ),
            ],
          );
        }
      )
    );
  }
}