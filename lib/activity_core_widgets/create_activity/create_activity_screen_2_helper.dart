import 'package:check_in_presentation/activity_core_widgets/create_activity/components/select_space_and_date_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import '../../check_in_presentation.dart';
import 'components/google_map_location_picker.dart';

enum ReservationState {reserve, request, post}
enum LocationPickerState { pickLocation, reviewLocation}

bool isReservationFormValid(ReservationItem reservation, ActivityManagerForm? activityForm, ListingManagerForm? facility) {
  if (activityForm?.profileService.activityBackground.activityTitle.isValid() == true && 
  activityForm?.profileService.activityBackground.activityDescription1.isValid() == true && 
  activityForm?.activityTypes?.isNotEmpty == true &&
  facility != null &&
  activityForm?.profileService.activityBackground.activityProfileImages?.isNotEmpty == true &&
  isReservationSlotValid(reservation)) {
    return true;
  }
  return false;
}


bool isTitleValid(String? title) {
  if (title != null && title == '') {
    return false;
  }
   return true;
}

bool isReservationSlotValid(ReservationItem res) {
  if (res.reservationSlotItem.isNotEmpty == true) {
    return true;
  }
  return false;
}

void didSelectAddNewLocation(BuildContext context, DashboardModel model, UserProfileModel currentUser, LocationModel? initLocation, {required Function(LocationModel) didUpdateLocation, required Function(ListingManagerForm) didUpdateFacility}) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Create Activity',
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return  Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                      decoration: BoxDecoration(
                          color: model.accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                      ),
                      width: 550,
                      height: 850,
                      child: GoogleMapLocationPicker(
                        model: model,
                        currentUser: currentUser,
                        initLocation: initLocation,
                        onLocationPicked: didUpdateLocation,
                        onFacilityPicked: didUpdateFacility,
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
  } else {
      Navigator.push(context, MaterialPageRoute(
              builder: (_) {
                return GoogleMapLocationPicker(
                   model: model,
                   currentUser: currentUser,
                   initLocation: initLocation,
                   onLocationPicked: didUpdateLocation,
                   onFacilityPicked: didUpdateFacility,
        );
      })
    );
  }
}


void didSelectSearchLocation(BuildContext context, DashboardModel model, UserProfileModel currentUser, ListingManagerForm? initFacility, {required Function(ListingManagerForm) didSelectFacility}) {
  if (kIsWeb) {
    showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: 'Create Activity',
          transitionDuration: Duration(milliseconds: 350),
          pageBuilder: (BuildContext contexts, anim1, anim2) {
            return  Align(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        width: 550,
                        height: 850,
                        child: SelectFacilityListScreen(
                          model: model,
                          selectedListing: initFacility,
                          currentUser: currentUser,
                          didSelectListing: didSelectFacility
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
  } else {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return SelectFacilityListScreen(
                model: model,
                selectedListing: initFacility,
                currentUser: currentUser,
                didSelectListing: didSelectFacility
        );
      })
    );
  }
}

void didSelectSpaceAndTimeOptions(BuildContext context, DashboardModel model, UserProfileModel currentUser, ListingManagerForm facility, ReservationItem? initReservation, {required Function(ReservationItem) didSelectReservation}) {
  if (kIsWeb) {
     showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierLabel: 'Create Activity',
          transitionDuration: Duration(milliseconds: 350),
          pageBuilder: (BuildContext contexts, anim1, anim2) {
            return  Align(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Container(
                        decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        width: 550,
                        height: 850,
                        child: SelectSpaceAndDatesScreen(
                          model: model,
                          currentUser: currentUser,
                          currentFacility: facility,
                          initReservation: initReservation,
                          didChangeReservationItem: didSelectReservation,
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
  } else {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return SelectSpaceAndDatesScreen(
                          model: model,
                          currentUser: currentUser,
                          currentFacility: facility,
                          initReservation: initReservation,
                          didChangeReservationItem: didSelectReservation,
                  );
      })
    );
  }
}