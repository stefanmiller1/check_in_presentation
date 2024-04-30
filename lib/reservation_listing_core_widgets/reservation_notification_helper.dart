part of check_in_presentation;

Widget reservationInviteNotificationTitle(DashboardModel model, Widget title, int notificationCount) {
  if (notificationCount != 0) {
    return badges.Badge(
        position: badges.BadgePosition.custom(end: -25, top: -5),
        showBadge: true,
        badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
        badgeContent: Text(notificationCount.toString(), style: TextStyle(color: model.accentColor)),
        child: title
      );
    } else {
    return title;
  }
}
