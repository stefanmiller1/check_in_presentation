part of check_in_presentation;


List<SettingsSectionItemModel> activitySettingsHeader(BuildContext context) {
  return [
    SettingsSectionItemModel(settingTitle: 'Activity Basics', sectionMarker: SettingSectionMarker.basics),
    SettingsSectionItemModel(settingTitle: 'Rules Settings', sectionMarker: SettingSectionMarker.rules),
    SettingsSectionItemModel(settingTitle: 'Attendees', sectionMarker: SettingSectionMarker.attendees),
  ];
}

List<SettingsItemModel> subActivitySettingItems(BuildContext context, UpdateActivityFormState state) {
  return [
    /// activity basics
    /// background info
    SettingsItemModel(settingIcon: Icons.info_outlined, sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.backgroundInfo, settingsTitle: 'Background Info', settingSubTitle: ''),
    /// requirement info
    SettingsItemModel(settingIcon: Icons.lock_open_sharp, sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.requirementsInfo, settingsTitle: 'Requirements & Provisions', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.calendar_month_outlined, sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.reservations, settingsTitle: 'Reservations', settingSubTitle: ''),

    /// reservation slots [breakdown res and activity] ... can you change reservation activity? cancel?, refund? update requests? - can also update date info.
    /// if res items contain an activity type show corresponding activity option///

    /// rules settings
    SettingsItemModel(settingIcon: Icons.visibility_outlined ,sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.accessAndVisibility, settingsTitle: 'Access and Visibility', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.cancel_outlined ,sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.cancellations, settingsTitle: 'Cancellations', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.create_outlined ,sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.customFields, settingsTitle: 'Custom Rules', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.rule_rounded ,sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.spaceRules, settingsTitle: 'Space Rules', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.rule_rounded ,sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.activityRules, settingsTitle: 'Activity Rules', settingSubTitle: ''),
    /// payments dependant on activity attendees type (if tickets, then show, tickkets cannot be bought until stripe account is set),
    SettingsItemModel(settingIcon: Icons.payments_outlined ,sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.payments, settingsTitle: 'Payments', settingSubTitle: ''),

    /// attendee settings items
    /// depends on attendance type
    SettingsItemModel(settingIcon: Icons.people_outline_rounded , sectionNavItem: SettingSectionMarker.attendees, navItem: SettingNavMarker.attendanceType, settingsTitle: 'Reservation Attendance', settingSubTitle: ''),
    if (state.activitySettingsForm.activityAttendance.isTicketBased ?? false)
      SettingsItemModel(settingIcon: Icons.airplane_ticket_rounded , sectionNavItem: SettingSectionMarker.attendees, navItem: SettingNavMarker.ticketBased, settingsTitle: 'Ticket Attendance', settingSubTitle: ''),
    if (state.activitySettingsForm.activityAttendance.isPassBased ?? false)
      SettingsItemModel(settingIcon: Icons.airplane_ticket_rounded , sectionNavItem: SettingSectionMarker.attendees, navItem: SettingNavMarker.passesBased, settingsTitle: 'Passes Attendance', settingSubTitle: ''),

  ];
}