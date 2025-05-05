part of check_in_presentation;

bool showHeader(ReservationPreviewer res) => res.previewWeight >= 10 || res.reservation?.reservationState == ReservationSlotState.current;

Widget couldNotRetrieveListingProfile() {
  return Container(
      child: Center(
        child: Text('This Activity Might be Over!'),
      )
  );
}

Widget getActivityResultsWidget(BuildContext context, DashboardModel model, UniqueId? currentUserId, ReservationPreviewer preview, {required Function() didSelectItem, required Function() didSelectInterested}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
              imageUrl: preview.activityManagerForm?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
              imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
              errorWidget: (context, url, error) {
                return getActivityTypeTabOption(
                    context,
                    model,
                    40,
                    false,
                    getActivityOptions().firstWhere((element) => element.activityId == preview.reservation?.reservationSlotItem.first.selectedActivityType)
              );
            },
          ),
        ),
      ),

      /// footer details container
      bottomFooterDetails(
          context,
          model,
          preview,
          currentUserId,
          didSelectItem: () {
            didSelectItem();
          },
          didSelectInterested: () {
            didSelectInterested();
          }
      ),
      /// header detail container
      /// starting soon...
      /// if popular
      /// happening now (or should be header?)?
      if (showHeader(preview)) Positioned(
        left: 8,
        top: 15,
        child: Container(
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.29),
                spreadRadius: 1,
                blurRadius: 15,
                offset: Offset(0, 2)
            )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Text(getHeaderState(preview), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
                const SizedBox(width: 2.5),
                Icon(getIconForHeaderState(preview), color: model.paletteColor),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

IconData getIconForHeaderState(ReservationPreviewer res) {
  if (res.previewWeight >= 10) {
    return Icons.star_border_rounded;
  } else if (res.reservation?.reservationState == ReservationSlotState.current) {
    return Icons.access_time_rounded;
  }
  return Icons.star_border_rounded;
}

String getHeaderState(ReservationPreviewer res) {
  if (res.previewWeight >= 10) {
    return ' POPULAR';
  } else if (res.reservation?.reservationState == ReservationSlotState.current) {
    return ' HAPPENING NOW';
  }
  return '';
}

Widget bottomFooterDetails(BuildContext context, DashboardModel model, ReservationPreviewer res, UniqueId? currentUserId, {required Function() didSelectItem, required Function() didSelectInterested}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: UI.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade800.withOpacity(0.5),
          /// when activity starts.
          /// activity owner
          /// community
          /// activity type
          /// people attending
          /// info...this is a ... activity that will happen at this location on ... ..., there are
          /// how to join (affiliiate options)
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                getSearchFooterWidget(
                    context,
                    model,
                    currentUserId,
                    Colors.grey.shade200,
                    Colors.grey.shade200.withOpacity(0.75),
                    Colors.black,
                    res,
                    false,
                    didSelectItem: () {
                      didSelectItem();
                    },
                    didSelectInterested: () {
                      didSelectInterested();
                    }
                ),

                const SizedBox(height: 4),
                // if (res.attendeesCount != null && res.attendeesCount != 0 || res.activityManagerForm?.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true) Theme(
                //   data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                //   child: Container(
                //     height: 30,
                //     width: MediaQuery.of(context).size.width,
                //     child: SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //       child: Row(
                //         children: [

                //           if (res.attendeesCount != 0 && res.attendeesCount != null) Chip(
                //               side: BorderSide.none,
                //               backgroundColor: model.accentColor.withOpacity(0.18),
                //               padding: EdgeInsets.zero,
                //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //               avatar: Icon(Icons.person, color: Colors.grey.shade200, size: 18,),
                //               label: Text(res.attendeesCount == 1 ? '${res.attendeesCount} Person Joined' : '${res.attendeesCount} People Joined', style: TextStyle(color: Colors.grey.shade200))
                //           ),
                //           const SizedBox(width: 4),
                //           if (res.activityManagerForm?.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true) Chip(
                //               backgroundColor: model.accentColor.withOpacity(0.18),
                //               side: BorderSide.none,
                //               padding: EdgeInsets.zero,
                //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //               avatar: Icon(Icons.remove_red_eye_outlined, color: Colors.grey.shade200, size: 18,),
                //               label: Text('Looking For Vendors/Merchants', style: TextStyle(color: Colors.grey.shade200),)
                //           ),

                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}