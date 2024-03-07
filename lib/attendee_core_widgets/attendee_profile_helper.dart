part of check_in_presentation;

Widget mainContainerForSectionOneAtt({required BuildContext context, required DashboardModel model, required AttendeeItem attendeeItem, required bool isColumn, required Function() didSelectRemoveAttendee, required Function() didSelectLeaveActivity}) {

  bool selectedAttendeeIsCurrentUser = false;
  bool isActivityOwner = true;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [

      const SizedBox(height: 35),
      if (!(isColumn)) Container(
        // height: 400,
        width: 300,
        decoration: BoxDecoration(
          color: model.webBackgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getContainerForSelectedAttendeeRow(
            context: context,
            model: model,
            attendeeItem: attendeeItem
          ),
        )
      ),

      if (isColumn) Container(
        // height: 300,
        width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: model.webBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: getContainerForSelectedAttendeeColumn(
                context: context,
                model: model,
                attendeeItem: attendeeItem
          ),
        )
      ),

      const SizedBox(height: 8),
      Text('Joined: ${DateFormat.MMMEd().format(attendeeItem.dateCreated)}', style: TextStyle(color: model.disabledTextColor, )),

      const SizedBox(height: 8),
      Visibility(
        visible: isActivityOwner,
        child: InkWell(
          onTap: () {
            didSelectRemoveAttendee();
          },
          child: Container(
            width: (isColumn) ? MediaQuery.of(context).size.width : 300,
            height: 60,
            decoration: BoxDecoration(
              color: model.webBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Align(
              child: Text('Remove Attendee', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ),
        ),
      ),

      Visibility(
        visible: selectedAttendeeIsCurrentUser,
        child: InkWell(
          onTap: () {
            didSelectLeaveActivity();
          },
          child: Container(
            width: (isColumn) ? MediaQuery.of(context).size.width : 300,
            height: 60,
            decoration: BoxDecoration(
              color: model.webBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
            child: Align(
              child: Text('Leave Activity', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
            ),
          ),
        ),
      ),

    ],
  );
}


Widget getContainerForSelectedAttendeeColumn({required BuildContext context, required DashboardModel model, required AttendeeItem attendeeItem}) {
  switch (attendeeItem.attendeeType) {
    case AttendeeType.free:
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Icon(Icons.person_outline_rounded, color: model.paletteColor),
                  const SizedBox(width: 10),
                  Text('Attendee', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                ]
            )
          ]
      );
    case AttendeeType.instructor:
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (attendeeItem.classesInstructorProfile != null) instructorWidgetCard(attendeeItem.classesInstructorProfile!, context, model),
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
                    child: Text(attendeeItem.contactStatus == null ? 'Invited' : getContactStatusName(attendeeItem.contactStatus!), style: TextStyle(color: model.disabledTextColor)),
                  )
              ),
            ),

            Row(
              children: [
                Icon(Icons.people_outline, color: model.paletteColor),
                const SizedBox(width: 10),
                Text('Instructor', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
            ]
          )
        ]
      );
    case AttendeeType.vendor:
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVendorAttendeeType(
                context,
                model,
                attendee: attendeeItem,
                didSelectAttendee: (attendee) {
                  // didSelectAttendee(attendee);
                }
            ),
            const SizedBox(height: 10),
            Row(
                children: [
                  Icon(Icons.storefront_sharp, color: model.paletteColor),
                  const SizedBox(width: 10),
                  Text('Vendor/Merchant', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                ]
            )
          ]
      );
    case AttendeeType.partner:
     return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
                children: [
                  Icon(Icons.handshake_outlined, color: model.paletteColor),
                  const SizedBox(width: 10),
                  Text('Partner', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
            ]
          )
        ]
      );
    case AttendeeType.organization:
      return Container(

      );
    default:
      return Container(

      );
  }
}

Widget getContainerForSelectedAttendeeRow({required BuildContext context, required DashboardModel model, required AttendeeItem attendeeItem}) {
  switch (attendeeItem.attendeeType) {
    case AttendeeType.free:
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
                children: [
                  Icon(Icons.person_outline_rounded, color: model.paletteColor),
                  const SizedBox(width: 10),
                  Text('Attendee', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
            ]
          )
        ]
      );
    case AttendeeType.instructor:
      return Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (attendeeItem.classesInstructorProfile != null) instructorWidgetCard(attendeeItem.classesInstructorProfile!, context, model),
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
                        child: Text(attendeeItem.contactStatus == null ? 'Invited' : getContactStatusName(attendeeItem.contactStatus!), style: TextStyle(color: model.disabledTextColor)),
                      )
                  ),
                ),

                Row(
                    children: [
                      Icon(Icons.people_outline, color: model.paletteColor),
                      const SizedBox(width: 10),
                      Text('Instructor', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                    ]
                )
              ]
          ),
      );
    case AttendeeType.vendor:
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getVendorAttendeeType(
                context,
                model,
                attendee: attendeeItem,
                didSelectAttendee: (attendee) {
                  // didSelectAttendee(attendee);
                }
            ),
            const SizedBox(height: 10),
            Row(
                children: [
                  Icon(Icons.storefront_sharp, color: model.paletteColor),
                  const SizedBox(width: 10),
                  Text('Vendor/Merchant', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                ]
            )
          ]
      );
    case AttendeeType.partner:
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
                children: [
                  Icon(Icons.handshake_outlined, color: model.paletteColor),
                  const SizedBox(width: 10),
                  Text('Partner', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                ]
            )
          ]
      );
    case AttendeeType.organization:
      return Container(

      );
    default:
      return Container(

      );
  }
}