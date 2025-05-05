import 'dart:convert';
import 'package:check_in_application/check_in_application.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:http/http.dart' as http;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jumping_dot/jumping_dot.dart';
import '../../../check_in_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:dartz/dartz.dart' as bloc;
import '../create_activity_screen_2_helper.dart'; // Import the domain package

class GoogleMapLocationPicker extends StatefulWidget {
  final UserProfileModel currentUser;
  final DashboardModel model;
  final ListingManagerForm? initListing;
  final LocationModel? initLocation;
  final LocationPickerState? initScreenState;
  final Function(LocationModel) onLocationPicked;
  final Function(ListingManagerForm) onFacilityPicked;

  const GoogleMapLocationPicker({super.key, required this.currentUser, required this.onLocationPicked, required this.model, required this.onFacilityPicked, this.initListing, this.initLocation, this.initScreenState});

  @override
  _GoogleMapLocationPickerState createState() => _GoogleMapLocationPickerState();
}
 
class _GoogleMapLocationPickerState extends State<GoogleMapLocationPicker> {
  // ListingManagerItem
  late GoogleMapController _mapController;
  late ScrollController _scrollController;

  LocationPickerState _currentState = LocationPickerState.pickLocation;
  late Stream<List<ListingManagerForm>> listingStream;
  ListingManagerForm? _selectedExistingFacility;
  String _address = '';
  String _placeId = '';


  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget getMainContainer(BuildContext context, LocationPickerState state) {
    switch (state) {
      case LocationPickerState.pickLocation:
      return getLocationPicker(context);
      case LocationPickerState.reviewLocation:
      return getLocationReview(context);
    }
  } 

  bool locationIsValid(CreateLocationState state) {
    if (state.location.countryRegion.isNotEmpty &&
        state.location.street.isValid() &&
        state.location.city.isValid() &&
        state.location.provinceState.isValid() &&
        state.location.postalCode.isValid()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(create: (context) => getIt<CreateLocationBloc>()..add(CreateLocationEvent.initialLocation(bloc.optionOf(LocationModel.empty()))),
        child: BlocConsumer<CreateLocationBloc, CreateLocationState>(
          listenWhen: (p, c) => p.authFailureOrSuccessOption != c.authFailureOrSuccessOption,
          listener: (context, state) {
                state.authFailureOrSuccessOption.fold(() {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              // cancelledByUser: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                              insufficientPermission: (_) => Text('Someone Has Already Created This Location', style: TextStyle(color: widget.model.disabledTextColor),),
                              serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {
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
          buildWhen: (p,c) => p.authFailureOrSuccessOption != c.authFailureOrSuccessOption || p.location != c.location || p.isSubmittingAddress != c.isSubmittingAddress,
          builder: (context, state) {
            return getMainContainer(context, _currentState);
          }
        )
      )
    );
  }

  Widget getLocationPicker(BuildContext context) {
    return Stack(
      children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            // onCameraIdle: _updateAddress,
            initialCameraPosition: CameraPosition(
              target: context.read<CreateLocationBloc>().state.location.locationPosition != null ? LatLng(context.read<CreateLocationBloc>().state.location.locationPosition!.latitude, context.read<CreateLocationBloc>().state.location.locationPosition!.longitude) : LatLng(43.6452, -79.3832), // Default to San Francisco
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            top: 25,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.add_circle, color: widget.model.paletteColor, size: 50),
              onPressed: () async {
              final zoom = await _mapController.getZoomLevel();
              _mapController.animateCamera(CameraUpdate.zoomTo(zoom + 1));
                },
              ),
            ),
          Positioned(
            top: 75,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.remove_circle, color: widget.model.paletteColor, size: 50),
              onPressed: () async {
              final zoom = await _mapController.getZoomLevel();
              _mapController.animateCamera(CameraUpdate.zoomTo(zoom - 1));
                },
              ),
            ),
          
          Center(
            child: Icon(Icons.cancel, color: widget.model.paletteColor, size: 60),
          ),

          Positioned(
            bottom: 25,
            left: 20,
            right: 20,
            child: Row(
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
                          child: Center(child: Text('Cancel', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () async {

                          // Temporarily disable stream updates
                          setState(() {
                            listingStream = Stream.empty();
                          });
                          await _updateAddress(context);
                          _currentState = LocationPickerState.reviewLocation;
                              
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: widget.model.paletteColor,
                              borderRadius: BorderRadius.circular(25)
                          ),
                    child: Center(child: Text('Pick This Spot', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]
    );
  }

  Widget getLocationReview(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        /// list of nearby 
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              StreamBuilder<List<ListingManagerForm>>(
                stream: listingStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return JumpingDots();
                  }
              
                    return Column(
                      children: [
                        const SizedBox(height: 8),
                        ListTile(
                          title: Text('Pick a Nearby Facility Instead', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.model.secondaryQuestionTitleFontSize, 
                            color: widget.model.paletteColor,
                            ),
                          ),
                          subtitle: Text('If the space you\'re looking for is already added pick from here instead', style: TextStyle(
                            color: widget.model.disabledTextColor,
                            ),
                          ),
                        ),
                        PagingSmallFacilitiesWidget(
                          model: widget.model,
                          height: 260,
                          isMobile: false,
                          currentUser: widget.currentUser,
                          selectedFacility: _selectedExistingFacility,
                          didSelectFacility: (facility) {
                              setState(() {
                              if (_selectedExistingFacility == facility) {
                                _selectedExistingFacility = null;
                              } else {
                                _selectedExistingFacility = facility;
                              }
                              });
                          },
                          facilities: snapshot.data ?? [],
                          isOwner: false,
                      ),
          
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: widget.model.disabledTextColor)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('or', style: TextStyle(color: widget.model.paletteColor)),
                              ),
                              Expanded(child: Divider(color: widget.model.disabledTextColor)),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
          
              ListTile(
                title: Text('Review & Confirm Selected Spot', style: TextStyle( fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize,color: widget.model.paletteColor,),
                ),
                subtitle: Text('Review the spot you have selected on the map',style: TextStyle(color: widget.model.disabledTextColor,),
                ),
              ),

              if (_selectedExistingFacility != null) AnimatedOpacity(
              opacity: (_selectedExistingFacility != null) ? 1 : 0, 
              duration: Duration(milliseconds: 350),
                child:  SlideInTransitionWidget(
                  durationTime: 500,
                  offset: Offset(0, 0.25),
                  transitionWidget: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FacilityOverviewInfoWidget(
                          model: widget.model,
                          overViewState: FacilityPreviewState.listingPreview,
                          newFacilityBooking: ReservationItem.empty(),
                          reservations: [],
                          /// THIS NEEDS TO BE THE LISTING OWNER!!!!!
                          listingOwnerProfile: widget.currentUser,
                          listing: _selectedExistingFacility!,
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
                      ],
                    ),
                  ),
                )
              ),

              if (_selectedExistingFacility == null) AnimatedOpacity(
                opacity: (_selectedExistingFacility != null) ? 0 : 1, 
                duration: Duration(milliseconds: 350),
                child: SlideInTransitionWidget(
                  durationTime: 500,
                  offset: Offset(0, 0.25),
                  transitionWidget: Column(
                    children: [
                      locationFormField(
                        model: widget.model,
                        onStreetChanged: (street) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.streetChanged(street));
                        },
                        onCityChanged: (city) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.cityChanged(city));
                        },
                        onProvinceStateChanged: (provinceState) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.provinceStateChanged(provinceState));
                        },
                        onPostalCodeChanged: (postalCode) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.postalCodeChanged(postalCode));
                        },
                        onLocationMediaChanged: (media) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.locationMediaChanged([media]));
                        },
                        initialLocation: context.read<CreateLocationBloc>().state.location
                      ),
                  
                      /// aditional options
                      const SizedBox(height: 10),
                      Divider(color: widget.model.disabledTextColor),
                      ListTile(
                        title: Text('Additional Options',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            color: widget.model.paletteColor,
                          ),
                        ),
                        subtitle: Text('This is not required, but it will help others who may also use the space', style: TextStyle(color: widget.model.disabledTextColor)),
                      ),
                      buildAdditionalOptionsWidget(
                        context: context,
                        model: widget.model, 
                        initialLocation: context.read<CreateLocationBloc>().state.location, 
                        onLocationTypeChanged: (type) {
                            context.read<CreateLocationBloc>().add(CreateLocationEvent.locationTypeChanged(type));
                        },
                        onLocationNameChanged: (name) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.locationNameChanged(name));
                        },
                        onParkingAvailabilityChanged: (availability) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.parkingAvailabilityChanged(availability));
                        },
                        onNearTransitChanged: (nearTransit) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.nearTransitChanged(nearTransit));
                        },
                        onOvernightStorageProvisionChanged: (provision) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.overnightStorageProvisionChanged(provision));
                        },
                        onBarrierFreeAccessibleChanged: (accessible) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.barrierFreeAccessibleChanged(accessible));
                        },
                        onBarrierFreeProvisionChanged: (provision) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.barrierFreeProvisionChanged(provision));
                        },
                        onAmenityProvisionChanged: (provision) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.amenityProvisionChanged(provision));
                        },
                        onEquipmentProvisionChanged: (provision) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.equipmentProvisionChanged(provision));
                        },
                        onRentalOptionChanged: (option) {
                          context.read<CreateLocationBloc>().add(CreateLocationEvent.rentalOptionChanged(option));
                        },
                      ),
                    ]
                  ),
                )
              ),

              const SizedBox(height: 100),
              
            ],
          ),
        ),
        /// optional settings..
        /// amenities, parking, 

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
                          setState(() {
                            if (_selectedExistingFacility != null) {
                              _selectedExistingFacility = null;
                              } else {
                              _currentState = LocationPickerState.pickLocation;
                              _selectedExistingFacility = null;
                            }
                          });
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: widget.model.webBackgroundColor,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Center(child: Text(_selectedExistingFacility != null ? 'Cancel' : 'Back', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedExistingFacility != null) {
                              widget.onFacilityPicked(_selectedExistingFacility!);
                            } else {
                              widget.onLocationPicked(context.read<CreateLocationBloc>().state.location);
                            }
                          });
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: widget.model.paletteColor,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Center(child: Text(_selectedExistingFacility != null ? 'Confirm Existing Location' : 'Create New Location', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]
    );
  }

  

  Future<void> _updateAddress(BuildContext context) async {
      try {
        final center = await _mapController.getLatLng(
            ScreenCoordinate(
            x: (MediaQuery.of(context).size.width < 550 ? (MediaQuery.of(context).size.width / 2).round() : 275),
            y: (MediaQuery.of(context).size.height < 850 ? (MediaQuery.of(context).size.height / 2).round() : 425),
          ),
        );

        // if (kIsWeb) {
          // Use a web service to get the address from coordinates
          // final response = await http.get(Uri.parse(
          final apiKey = GOOGLE_GEOCODING_KEY; // Replace with your actual API key
          final url = Uri.parse(
              'https://maps.googleapis.com/maps/api/geocode/json?latlng=${center.latitude},${center.longitude}&key=$apiKey');

          final response = await http.get(url);

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            if (data['results'] != null && data['results'].isNotEmpty) {
              // print(data['results']);

              // final address = data['results'][0]['formatted_address'];
                final streetNumber = data['results'][0]['address_components'].firstWhere((component) => component['types'] is List && component['types'].contains('street_number'), orElse: () => {'long_name' : null})?['long_name'] ?? '';
                final streetName = data['results'][0]['address_components'].firstWhere((component) => component['types'] is List && component['types'].contains('route'), orElse: () => {'long_name' : null})?['long_name'] ?? '';
                _address = '$streetNumber $streetName';
                final postalCode = data['results'][0]['address_components'].firstWhere((component) =>component['types'] is List && component['types'].contains('postal_code'), orElse: () => {'long_name' : null})?['long_name'] ?? '';
                final country = data['results'][0]['address_components'].firstWhere((component) => component['types'] is List && component['types'].contains('country'), orElse: () => {'long_name' : null})?['long_name'] ?? '';
                final city = data['results'][0]['address_components'].firstWhere((component) => component['types'] is List && component['types'].contains('locality'), orElse: () => {'long_name' : null})?['long_name'] ?? '';
                final provinceState = data['results'][0]['address_components'].firstWhere((component) => component['types'] is List && component['types'].contains('administrative_area_level_1'), orElse: () => {'long_name' : null})?['long_name'] ?? '';              
                final placeId = data['results'][0]['place_id'];

              
              setState(() {
                // _address = address;
                // _placeId = placeId;
                context.read<CreateLocationBloc>().add(CreateLocationEvent.locationOwnerChanged(widget.currentUser.userId.getOrCrash()));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.placeIdChanged(placeId));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.longLatChanged(center.latitude, center.longitude));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.countryChanged(country));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.cityChanged(city));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.provinceStateChanged(provinceState));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.streetChanged(_address));
                context.read<CreateLocationBloc>().add(CreateLocationEvent.postalCodeChanged(postalCode));

                listingStream = FirebaseMapFacade.instance.mapListings(
                  latitude: center.latitude,
                  longitude: center.longitude,
                  selectedRadius: 4,
                );
              
                // _selectedLocation = LocationModel(
                //   ownerId: widget.currentUser.userId.getOrCrash(), // Add appropriate values
                //   locationType: LocationType.other,
                //   placeId: _placeId,
                //   longLat: "${center.latitude},${center.longitude}",
                //   countryRegion: country, // Add appropriate values
                //   city: FacilityLocationCity(city), // Add appropriate values
                //   provinceState: FacilityLocationStateProvince(provinceState, country), // Add appropriate values
                //   street: FacilityLocationStreet(_address),
                //   postalCode: FacilityLocationPostalCode(postalCode, country), // Add appropriate values
                //   isLocationConfirmed: false,
                //   isUnverified: true,
                //   isVerified: true,
                //   isVerifiedAlready: false,
                //   isCompleted: true,
                //   locationPosition: GeoFirePoint(center.latitude, center.longitude),
                // );

              });
            }
          }
          //   } else {
          //     setState(() {
          //       _address = 'No address available';
          //       _placeId = '';
          //     });
          //   }
          // } else {
          //   setState(() {
          //     _address = 'Failed to get address: HTTP ${response.statusCode}';
          //     _placeId = '';
          //   });
          // }
        // } 
        // else {
        //   List<Placemark> placemarks = await placemarkFromCoordinates(center.latitude, center.longitude);
        //   if (placemarks.isNotEmpty) {
        //     final placemark = placemarks.first;
        //     setState(() {
        //       _address = '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}';
        //       _placeId = placemark.name ?? '';
        //     });
        //   } else {
        //     setState(() {
        //       _address = 'No address available';
        //       _placeId = '';
        //     });
        //   }
        // }
      } catch (e) {
          _address = 'Failed to get address: $e';
          _placeId = '';
      }
    }

}