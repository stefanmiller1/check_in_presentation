part of check_in_presentation;

bool showNextButtonNewActivity(int index, ListingManagerForm? listing, bool isConfirmed, List<ReservationSlotItem> slots, String? listingCode) {
  switch (index) {
    case 0:
      return true;
    case 1:
      return listing != null;
    case 2:
      return isConfirmed;
    case 3:
      if (listing == null) {
        return false;
      }
      return listingCode == listing?.listingServiceId.getOrCrash().substring((listing?.listingServiceId.getOrCrash().length ?? 0) - 7);
    case 4:
      return true;
    case 5:
      return slots.isNotEmpty;
    case 6:
      return true;
    case 7:
      return false;
  }
  return true;
}
bool showBackButtonNewActivity() => true;



void didSelectCreateNewActivity(BuildContext context, DashboardModel model, ReservationItem? initRes, ListingManagerForm? listing, {required Function(ReservationItem) didSaveActivity, required Function(ReservationItem) didPublishActivity}) {
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
                    width: 1200,
                    height: 1050,
                    child: CreateReservationActivityFormWidget(
                      currentListing: listing,
                      initReservation: initRes,
                      isPopOver: true,
                      isSaving: (res) => didSaveActivity(res),
                      isPublishing: (res) => didPublishActivity(res),
                      model: model,
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
          return CreateReservationActivityFormWidget(
              currentListing: listing,
              initReservation: null,
              isPopOver: true,
              isSaving: (res) => didSaveActivity(res),
              isPublishing: (res) => didPublishActivity(res),
              model: model,
          );
        })
    );
  }
}