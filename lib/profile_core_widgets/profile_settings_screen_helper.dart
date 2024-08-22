part of check_in_presentation;

enum ProfileSettingMarker {personalIno, payments, notification, privacy, switchToHosting, listSpace, listActivity, manageSpace, howWorks, getHelp, giveFeedback, termsOfService, privacyPolicy, }

class ProfileSettingListModel {

  final String title;
  final IconData icon;
  final ProfileSettingMarker marker;

  ProfileSettingListModel({
      required this.title,
      required this.icon,
      required this.marker
    });
}

List<ProfileSettingListModel> accountSettingsList(bool isActivityApp) {
  return [
    ProfileSettingListModel(title: 'Personal Information', icon: Icons.account_circle_outlined, marker: ProfileSettingMarker.personalIno),
    ProfileSettingListModel(title: 'Payments & Payouts', icon: Icons.payments_outlined, marker: ProfileSettingMarker.payments),
    if (!isActivityApp) ProfileSettingListModel(title: 'Notifications - Coming Soon', icon: Icons.notifications_none, marker: ProfileSettingMarker.notification),
    ProfileSettingListModel(title: 'Privacy', icon: Icons.privacy_tip_outlined, marker: ProfileSettingMarker.privacy),
  ];
}

List<ProfileSettingListModel> accountHostingList(BuildContext context) {
  return [
    ProfileSettingListModel(title: 'Switch to Hosting - Coming Soon', icon: Icons.swap_calls_rounded, marker: ProfileSettingMarker.switchToHosting),
    ProfileSettingListModel(title: 'List Your Space - Coming Soon', icon: Icons.house_outlined, marker: ProfileSettingMarker.listSpace),
    // ProfileSettingListModel(title: 'List Your Activity', icon: Icons.directions_run_rounded, marker: ProfileSettingMarker.listActivity),
    ProfileSettingListModel(title: 'Manage Your Spaces - Coming Soon', icon: Icons.add_business_outlined, marker: ProfileSettingMarker.manageSpace),
  ];
}

List<ProfileSettingListModel> accountSupportList(BuildContext context) {
  return [
    ProfileSettingListModel(title: 'How CICO Works', icon: Icons.pan_tool_outlined, marker: ProfileSettingMarker.howWorks),
    ProfileSettingListModel(title: 'Get Help', icon: Icons.info_outline_rounded, marker: ProfileSettingMarker.getHelp),
    ProfileSettingListModel(title: 'Give us feedback', icon: Icons.chat_outlined, marker: ProfileSettingMarker.giveFeedback),
  ];
}

List<ProfileSettingListModel> accountLegalList(BuildContext context) {
  return [
    ProfileSettingListModel(title: 'Terms of Service', icon: Icons.public_rounded, marker: ProfileSettingMarker.termsOfService),
    ProfileSettingListModel(title: 'Privacy Policy', icon: Icons.public_rounded, marker: ProfileSettingMarker.privacyPolicy),
  ];
}


Widget profileSettingItemWidget(DashboardModel model, IconData icon, String title, bool isEnnd, bool isSelected, {required Function() didSelectItem}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () {
          didSelectItem();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(icon, color: (isSelected) ? model.paletteColor : model.disabledTextColor),
                      const SizedBox(width: 18.0),
                      Expanded(child: Text(title, style: TextStyle(color: (isSelected) ? model.paletteColor : model.disabledTextColor), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ],
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_right_rounded, color: (isSelected) ? model.paletteColor : model.disabledTextColor)
            ],
          ),
        ),
      ),
      if (!isEnnd && kIsWeb == false) Divider(color: model.disabledTextColor)
    ],
  );
}


