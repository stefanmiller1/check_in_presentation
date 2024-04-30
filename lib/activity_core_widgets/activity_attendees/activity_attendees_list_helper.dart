// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:flutter/material.dart';

part of check_in_presentation;

class ActivityAttendeeHelperCore {

  static late AttendeeItem? selectedAttendeeItem = null;
  static late UserProfileModel? selectedUserProfileItem = null;
  static bool isLoading = false;

}

Widget getActivityAttendeeTile(DashboardModel model, AttendeeItem attendee, bool isSelected, {required Function(AttendeeItem, UserProfileModel) didSelectAttendee}) {

  return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
          border: (isSelected) ? Border.all(color: model.paletteColor, width: 1.5) : null
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: retrieveUserProfile(
          attendee.attendeeOwnerId.getOrCrash(),
          model,
          null,
          model.paletteColor,
          model.secondaryQuestionTitleFontSize,
          profileType: UserProfileType.attendeeProfile,
          trailingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (attendee.contactStatus != ContactStatus.pending) Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: model.accentColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(attendee.contactStatus == null ? 'Invited' : getContactStatusName(attendee.contactStatus!), style: TextStyle(color: model.disabledTextColor)),
                  )
              ),
              const SizedBox(width: 8),
              Icon(getIconForAttendeeType(attendee.attendeeType), size: 18, color: model.disabledTextColor,),
            ],
          ),
          selectedButton: (e) {
            didSelectAttendee(attendee, e);
        }
      ),
    )
  );
}

Widget getActivityVendorProfileTile(DashboardModel model, EventMerchantVendorProfile profile, bool isSelected, {required Function(AttendeeItem) didSelectAttendee}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      decoration: BoxDecoration(
        color: model.accentColor,
        borderRadius: BorderRadius.circular(18),
        border: (isSelected) ? Border.all(color: model.paletteColor) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            getVendorMerchProfileHeader(
              model,
              false,
              profile,
              null,
              didSelectShare: () {

              },
              didSelectAddPartners: () {

              },
              didSelectEdit: () {

              },
            ),
            Positioned(
                top: 10,
                right: 10,
                child: retrieveUserProfile(
                    profile.profileOwner.getOrCrash(),
                    model,
                    null,
                    model.paletteColor,
                    model.secondaryQuestionTitleFontSize,
                    profileType: UserProfileType.firstLetterOnlyProfile,
                    trailingWidget: null,
                    selectedButton: (e) {

                    }
                )
            )
          ],
        ),
      ),
    ),
  );
}

Widget getFutureActivityVendorProfileTile(DashboardModel model, AttendeeItem attendee, bool isSelected, {required Function(AttendeeItem) didSelectAttendee}) {

  return (attendee.eventMerchantVendorProfile != null) ? FutureBuilder(
      future: facade.MerchVenFacade.instance.getMerchVendorProfile(profileId: attendee.eventMerchantVendorProfile!.getOrCrash()),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade400,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: model.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
              ),
            )
          );
        } else if (snap.hasError || snap.data == null) {
          return getActivityAttendeeTile(model, attendee, isSelected, didSelectAttendee: (att, user) => didSelectAttendee(att));
        }

        final EventMerchantVendorProfile profile = snap.data!;

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(18),
              border: (isSelected) ? Border.all(color: model.paletteColor) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  getVendorMerchProfileHeader(
                    model,
                    false,
                    profile,
                    null,
                    didSelectShare: () {

                    },
                    didSelectAddPartners: () {

                    },
                    didSelectEdit: () {

                    },
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: retrieveUserProfile(
                        attendee.attendeeOwnerId.getOrCrash(),
                        model,
                        null,
                        model.paletteColor,
                        model.secondaryQuestionTitleFontSize,
                        profileType: UserProfileType.firstLetterOnlyProfile,
                        trailingWidget: null,
                        selectedButton: (e) {

                        }
                    )
                  )
                ],
              ),
            ),
          ),
        );
    }
  ) : getActivityAttendeeTile(model, attendee, isSelected, didSelectAttendee: (att, user) => didSelectAttendee(att));
}

List<AttendeeItem> attendeesOnlyList(List<AttendeeItem> attendees) {
  return attendees.where((element) => element.attendeeType == AttendeeType.free || element.attendeeType == AttendeeType.tickets || element.attendeeType == AttendeeType.pass || element.attendeeType == AttendeeType.vendor).toList();
}

IconData? getIconForAttendeeType(AttendeeType type) {

  switch (type) {
    case AttendeeType.free:
      return Icons.person;
    case AttendeeType.tickets:
      return Icons.airplane_ticket_outlined;
    case AttendeeType.pass:
      return Icons.credit_card;
    case AttendeeType.instructor:
      return Icons.school_outlined;
    case AttendeeType.vendor:
      return Icons.add_business_outlined;
    case AttendeeType.partner:
      return Icons.handshake_outlined;
    case AttendeeType.organization:
      return Icons.attractions_sharp;
    case AttendeeType.interested:
      // TODO: Handle this case.
  }
}