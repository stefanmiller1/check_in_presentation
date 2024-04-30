part of check_in_presentation;

Widget getInstructorAttendeeType(BuildContext context, DashboardModel model, {required AttendeeItem attendee, required Function(AttendeeItem) didSelectAttendee}) {

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: model.webBackgroundColor,
      border: Border.all(color: model.disabledTextColor)
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          didSelectAttendee(attendee);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            retrieveUserProfile(
              attendee.attendeeOwnerId.getOrCrash(),
              model,
              model.paletteColor,
              null,
              null,
              profileType: UserProfileType.nameAndEmail,
              trailingWidget: null,
              selectedButton: (e) {
              },
            ),
            const SizedBox(height: 10),
            // if (attendee.classesInstructorProfile != null) instructorWidgetCard(attendee.classesInstructorProfile!, context, model),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: model.accentColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(attendee.contactStatus == null ? 'Invited' : getContactStatusName(attendee.contactStatus!), style: TextStyle(color: model.disabledTextColor)),
                )
              ),
            )
          ]
        ),
      ),
    ),
  );
}

Widget getPartnerAttendeeType(BuildContext context, DashboardModel model, {required AttendeeItem attendee, required Function(AttendeeItem) didSelectAttendee}) {
  return Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
    color: model.webBackgroundColor,
    border: Border.all(color: model.disabledTextColor)
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: retrieveUserProfile(
        attendee.attendeeOwnerId.getOrCrash(),
        model,
        model.paletteColor,
        null,
        null,
        profileType: UserProfileType.nameAndEmail,
        trailingWidget: null,
        selectedButton: (e) {
        },
      ),
    ),
  );
}


Widget getVendorAttendeeType(BuildContext context, DashboardModel model, {required AttendeeItem attendee, required Function(AttendeeItem) didSelectAttendee}) {
  return Container(
    height: 320,
    width: 190,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: model.webBackgroundColor,
        border: Border.all(color: model.disabledTextColor)
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          didSelectAttendee(attendee);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height
            ),
            if (attendee.eventMerchantVendorProfile != null) CircleAvatar(
              radius: 40
            ),

            if (attendee.eventMerchantVendorProfile == null) Positioned(
              top: 140,
              child: Icon(Icons.storefront_outlined, size: 35, color: model.disabledTextColor)
            ),

          Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: model.webBackgroundColor,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          retrieveUserProfile(
                            attendee.attendeeOwnerId.getOrCrash(),
                            model,
                            model.accentColor,
                            null,
                            null,
                            profileType: UserProfileType.firstLetterOnlyProfile,
                            trailingWidget: null,
                            selectedButton: (e) {
                            },
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 8),
                          //   // child: Text(attendee.eventMerchantVendorProfile?.brandName.value.fold((l) => '', (r) => r) ?? '', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1)
                          // ),
                        ]
                )
              )
            ),




            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: model.accentColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(attendee.contactStatus == null ? 'Invited' : getContactStatusName(attendee.contactStatus!), style: TextStyle(color: model.disabledTextColor)),
                )
              )
            )

          ]
        )
      ),
    ),
  );
}


