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
              selectedButton: (e) {
              },
            ),
            const SizedBox(height: 10),
            if (attendee.classesInstructorProfile != null) instructorWidgetCard(attendee.classesInstructorProfile!, context, model),
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
                  )),
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
        selectedButton: (e) {
        },
      ),
    ),
  );
}


Widget getVendorAttendeeType(BuildContext context, DashboardModel model, {required AttendeeItem attendee, required Function(AttendeeItem) didSelectAttendee}) {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            retrieveUserProfile(
              attendee.attendeeOwnerId.getOrCrash(),
              model,
              model.paletteColor,
              null,
              null,
              profileType: UserProfileType.nameAndEmail,
              selectedButton: (e) {
              },
            ),

            const SizedBox(height: 3),
            Text(attendee.eventMerchantVendorProfile!.brandName.value.fold((l) => '', (r) => r), style: TextStyle(color: model.paletteColor, overflow: TextOverflow.ellipsis), maxLines: 1),
            const SizedBox(height: 4),
            if (attendee.eventMerchantVendorProfile != null) Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: Image.asset('assets/profile-avatar.png').image,
                  foregroundImage: Image.network(attendee.eventMerchantVendorProfile!.uriImage).image,
                ),
              ],
            ),

            const SizedBox(height: 5),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: model.accentColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(attendee.contactStatus == null ? 'Invited' : getContactStatusName(attendee.contactStatus!), style: TextStyle(color: model.disabledTextColor)),
              )
            )
          ],
        ),
      ),
    ),
  );
}