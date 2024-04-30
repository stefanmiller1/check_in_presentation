part of check_in_presentation;

void didSelectInvitationRequest ({required BuildContext context, required DashboardModel model, required String currentUser, required AttendeeType attendeeType, required ReservationItem reservationItem, required InvitationType inviteType, required ActivityManagerForm? activityManagerForm}) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Send Invite',
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
                    height: 750,
                    child: SendInvitationRequest(
                      model: model,
                      currentUserId: currentUser,
                      attendeeType: attendeeType,
                      reservationItem: reservationItem,
                      inviteType: inviteType,
                      activityForm: activityManagerForm,
                      didSelectInvite: (contacts) {

                },
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
          return SendInvitationRequest(
            model: model,
            currentUserId: currentUser,
            attendeeType: attendeeType,
            reservationItem: reservationItem,
            inviteType: inviteType,
            activityForm: activityManagerForm,
            didSelectInvite: (contacts) {},
          );
        })
    );
  }
}