part of check_in_presentation;

Widget getActivityTypeTabOption(BuildContext context, DashboardModel model, double height, bool isSelected, ActivityOption activityOption) {
  return Tab(
    height: height,
    iconMargin: EdgeInsets.zero,
    icon: Container(
      width: 100,
      decoration: BoxDecoration(
        color: (isSelected) ? model.paletteColor : model.disabledTextColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SvgPicture.asset(getIconPathForActivity(context, activityOption.activityId), fit: BoxFit.fitHeight, color: (isSelected) ? model.accentColor : model.paletteColor, height: MediaQuery.of(context).size.height * .08),
        ),
      ),
    ),
  );
}

Widget getActivityFromReservationId(BuildContext context, DashboardModel model, double radius, ReservationItem reservation) {

  final UniqueId activityId = reservation.reservationSlotItem.isNotEmpty ? reservation.reservationSlotItem.first.selectedActivityType : getActivityOptions()[0].activityId;

  return CircleAvatar(
    radius: radius,
    backgroundColor: model.accentColor,
    child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SvgPicture.asset(getIconPathForActivity(context, activityId))
    ),
  );
}


Widget getActivityIconFromActivityId(BuildContext context, DashboardModel model, double radius, UniqueId activityId) {

  return CircleAvatar(
    radius: radius,
    backgroundColor: model.accentColor,
    child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SvgPicture.asset(getIconPathForActivity(context, activityId))
    ),
  );
}