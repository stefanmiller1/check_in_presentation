part of check_in_presentation;

enum MobileShareTypes {copyLink, instaStories, whatsApp, messenger, instaMessage, download, more}
// List<>

class ShareMobileOptions {

  final IconData? icon;
  final String? imagePath;
  final String title;
  final bool isComingSoon;
  final MobileShareTypes shareType;

  ShareMobileOptions({
     required this.icon,
     required this.imagePath,
     required this.title,
     required this.shareType,
     required this.isComingSoon
  });
}

List<ShareMobileOptions> mobileShareOptionList() => [
  ShareMobileOptions(icon: Icons.insert_link_rounded, imagePath: null, title: 'Copy Link', shareType: MobileShareTypes.copyLink, isComingSoon: false),
  ShareMobileOptions(icon: null, imagePath: 'assets/icons_svg/socials/insta_icon.png', title: 'Instagram Story', shareType: MobileShareTypes.instaStories, isComingSoon: false),
  ShareMobileOptions(icon: null, imagePath: 'assets/icons_svg/socials/whatsapp_icon.png', title: 'WhatsApp', shareType: MobileShareTypes.whatsApp, isComingSoon: false),
  ShareMobileOptions(icon: null, imagePath: 'assets/icons_svg/socials/messenger_icon.png', title: 'Messenger', shareType: MobileShareTypes.messenger, isComingSoon: false),
  ShareMobileOptions(icon: null, imagePath: 'assets/icons_svg/socials/insta_icon.png', title: 'Instagram Message', shareType: MobileShareTypes.instaMessage, isComingSoon: true),
  ShareMobileOptions(icon: Icons.arrow_circle_down_rounded, imagePath: null, title: 'Download', shareType: MobileShareTypes.download, isComingSoon: true),
  ShareMobileOptions(icon: Icons.more_horiz, imagePath: null, title: 'More', shareType: MobileShareTypes.more, isComingSoon: false),
];


void presentActivityShareOptions(BuildContext context, DashboardModel model, ListingManagerForm listing, ReservationItem reservation, ActivityManagerForm activityForm) {
  if (kIsWeb) {
      showDialog(
          context: context,
          builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: const EdgeInsets.all(12),
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 600,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// copy link
                      profileSettingItemWidget(
                        model,
                        Icons.link_rounded,
                        'Copy Link',
                        false,
                        true,
                        didSelectItem: () {
                          Navigator.of(context).pop();
                          Clipboard.setData(ClipboardData(text: getUrlForActivity(reservation.instanceId.getOrCrash(), reservation.reservationId.getOrCrash())));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Copied to Clipboard!'),
                            ),
                          );
                        }
                      ),
                      /// embed widget - coming soon
                      profileSettingItemWidget(
                        model,
                        Icons.web,
                        'Embedded Activity - Coming Soon',
                        false,
                        true,
                        didSelectItem: () {
                          Navigator.of(context).pop();

                        }
                      ),

                    ]
                  ),
                )
              ),


              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  width: 600,
                  height: 45,
                  decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
                ),
              )
              ]
            )
          );
        }
      );
  } else {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: model.accentColor,
        context: context,
        builder: (context) {

          return MobileShareWidget(
            model: model,
            listing: listing,
            activityForm: activityForm,
            reservation: reservation,
          );

      }
    );
  }
}


