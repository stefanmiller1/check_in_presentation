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



void didSelectCreateNewActivity(BuildContext context, DashboardModel model, ListingManagerForm? listing, int? initPage) {
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
                    width: 750,
                    height: 1050,
                    child: CreateNewActivityScreen(
                      currentListingManForm: listing,
                      initPage: initPage,
                      isPopOver: true,
                      didSelectClose: () {},
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
          return CreateNewActivityScreen(
              currentListingManForm: listing,
              initPage: initPage,
              isPopOver: true,
              didSelectClose: () {},
              model: model
          );
        })
    );
  }
}