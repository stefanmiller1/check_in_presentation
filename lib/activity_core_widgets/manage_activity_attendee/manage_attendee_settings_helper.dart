part of check_in_presentation;

List<SettingsSectionItemModel> attendeeSettingsHeader(BuildContext context) {
  return [
    SettingsSectionItemModel(settingTitle: 'Your Profile', sectionMarker: SettingSectionMarker.profile),
  ];
}

List<SettingsItemModel> subActivityAttendeeSettingItems(ActivityManagerForm? activity, AttendeeItem? attendee) {
  return [
    /// show when you joined...and an option to leave.
    SettingsItemModel(settingIcon: Icons.calendar_month_rounded, sectionNavItem: SettingSectionMarker.profile, navItem: SettingNavMarker.reservation, settingsTitle: 'Your Attendance', settingSubTitle: 'Status: ${attendee?.contactStatus?.name ?? ''}', resSlotItem: null),
    if (attendee?.vendorForm != null) SettingsItemModel(settingIcon: Icons.note_alt_outlined, sectionNavItem: SettingSectionMarker.profile, navItem: SettingNavMarker.vendorForm, settingsTitle: 'Your Application', settingSubTitle: '', resSlotItem: null),
    if (activity?.rulesService.checkInSetting.isNotEmpty == true) SettingsItemModel(settingIcon: Icons.sticky_note_2_outlined, sectionNavItem: SettingSectionMarker.profile, navItem: SettingNavMarker.checkIns, settingsTitle: 'Your Check-In', settingSubTitle: '', resSlotItem: null),
  ];
}

