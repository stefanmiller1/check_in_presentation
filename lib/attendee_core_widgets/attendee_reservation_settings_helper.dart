part of check_in_presentation;

List<SettingsSectionItemModel> attendeeSettingsHeader(BuildContext context) {
  return [
    SettingsSectionItemModel(settingTitle: 'Your Profile', sectionMarker: SettingSectionMarker.profile),
  ];
}

List<SettingsItemModel> subActivityAttendeeSettingItems(ActivityManagerForm? activity) {
  return [
    /// show when you joined...and an option to leave.
    SettingsItemModel(settingIcon: Icons.calendar_month_rounded, sectionNavItem: SettingSectionMarker.profile, navItem: SettingNavMarker.reservation, settingsTitle: 'Your Attendance', settingSubTitle: '', resSlotItem: null),
    if (activity?.rulesService.checkInSetting.isNotEmpty == true) SettingsItemModel(settingIcon: Icons.sticky_note_2_outlined, sectionNavItem: SettingSectionMarker.profile, navItem: SettingNavMarker.checkIns, settingsTitle: 'Your Check-In', settingSubTitle: '', resSlotItem: null),
  ];
}