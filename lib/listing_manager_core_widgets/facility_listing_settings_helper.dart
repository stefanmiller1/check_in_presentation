part of check_in_presentation;


enum SettingSectionMarker {basics, reservation, attendees, rules}
enum SettingNavMarker {backgroundInfo, requirementsInfo, locationInfo, spaces, reservations, reservation, spaceOption, activity, hoursAndAvailability, accessAndVisibility, cancellations, customFields, spaceRules, activityRules, payments, checkIns, reservationConditions, pricingRules, quotas, attendanceType, ticketBased, passesBased}

class SettingsSectionItemModel {

  final String settingTitle;
  final SettingSectionMarker sectionMarker;

  SettingsSectionItemModel({required this.settingTitle, required this.sectionMarker});
}


class SettingsItemModel {

  late bool? isHovering;
  late bool? isActive;
  late bool? isCompletedSetup;
  late UniqueId? settingSpaceOption;
  final String settingsTitle;
  final String settingSubTitle;
  final IconData settingIcon;
  final String? settingImageIcon;
  final SettingNavMarker navItem;
  final SettingSectionMarker sectionNavItem;

  SettingsItemModel({this.settingImageIcon, this.isHovering, this.isActive, this.settingSpaceOption, this.isCompletedSetup, required this.settingIcon, required this.sectionNavItem, required this.navItem, required this.settingsTitle, required this.settingSubTitle});
}

List<SettingsSectionItemModel> settingsHeader(BuildContext context) {
  return [
    SettingsSectionItemModel(settingTitle: 'Listing Basics', sectionMarker: SettingSectionMarker.basics),
    SettingsSectionItemModel(settingTitle: 'Reservation Settings', sectionMarker: SettingSectionMarker.reservation),
    SettingsSectionItemModel(settingTitle: 'Policies and Rules', sectionMarker: SettingSectionMarker.rules)
  ];
}

List<SettingsItemModel> subSettingListingItems(BuildContext context, ListingSettingFormState? state) {
  return [
    SettingsItemModel(settingIcon: Icons.info_outlined,sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.backgroundInfo, settingsTitle: 'Background Info', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.location_on_outlined,sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.locationInfo, settingsTitle: 'Location', settingSubTitle: 'Address \nGeneral location', isCompletedSetup: isFinishedLocationVerification(state)),
    SettingsItemModel(settingIcon: Icons.workspaces_outline,sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.spaces, settingsTitle: 'Spaces', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.directions_run_rounded,sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.activity, settingsTitle: 'Activity', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.hourglass_empty_rounded,sectionNavItem: SettingSectionMarker.basics, navItem: SettingNavMarker.hoursAndAvailability, settingsTitle: 'Hours and Availability', settingSubTitle: ''),

    SettingsItemModel(settingIcon: Icons.visibility_outlined ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.accessAndVisibility, settingsTitle: 'Access and Visibility', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.cancel_outlined ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.cancellations, settingsTitle: 'Cancellations', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.create_outlined ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.customFields, settingsTitle: 'Custom Rules', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.rule_rounded ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.spaceRules, settingsTitle: 'Space Rules', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.rule_rounded ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.activityRules, settingsTitle: 'Activity Rules', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.payments_outlined ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.payments, settingsTitle: 'Payments', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.sticky_note_2_outlined ,sectionNavItem: SettingSectionMarker.reservation, navItem: SettingNavMarker.checkIns, settingsTitle: 'Check-Ins', settingSubTitle: ''),

    SettingsItemModel(settingIcon: Icons.airplane_ticket_rounded , sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.reservationConditions, settingsTitle: 'Reservation Conditions', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.monetization_on_outlined , sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.pricingRules, settingsTitle: 'Pricing Rules', settingSubTitle: ''),
    SettingsItemModel(settingIcon: Icons.repeat , sectionNavItem: SettingSectionMarker.rules, navItem: SettingNavMarker.quotas, settingsTitle: 'Quotas', settingSubTitle: ''),
  ];
}

bool isFinishedLocationVerification(ListingSettingFormState? state) {
  return !(state?.listingManagerForm.listingProfileService.listingLocationSetting.isVerified ?? false);
}
