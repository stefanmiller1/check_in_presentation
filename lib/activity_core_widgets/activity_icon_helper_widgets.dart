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
          child: SvgPicture.asset(getActivityOptions(context).firstWhere((element) => element.activityId == activityOption.activityId).iconPath ?? '', fit: BoxFit.fitHeight, color: (isSelected) ? model.accentColor : model.paletteColor, height: MediaQuery.of(context).size.height * .08),
        ),
      ),
    ),
  );
}