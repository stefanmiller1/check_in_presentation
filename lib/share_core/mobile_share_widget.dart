import 'dart:io';

import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_share/social_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_facade/check_in_facade.dart';

class MobileShareWidget extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm listing;
  final ActivityManagerForm activityForm;
  final ReservationItem reservation;

  const MobileShareWidget({super.key, required this.model, required this.activityForm, required this.reservation, required this.listing});

  @override
  State<MobileShareWidget> createState() => _MobileShareWidgetState();
}

class _MobileShareWidgetState extends State<MobileShareWidget> {

  late bool isLoading = false;
  late String? copyLink = null;

  Future<String?> screenshot() async {
    var data = await screenshotController.capture();
    if (data == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final assetPath = '${tempDir.path}/temp.png';
    File file = await File(assetPath).create();
    await file.writeAsBytes(data);
    return file.path;
  }

  Future<String?> screenshotPath() async {
    var data = await screenshotController.capture();
    if (data == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    return'${tempDir.path}/temp.png';
  }

  void getCopyLinkUrl() async {

    try {
      isLoading = true;
      final String getImageUrl = widget.activityForm.profileService.activityBackground.activityProfileImages?[0].uriPath ?? '';

      final linkUrl = await ShareFacadeCore.instance.generateAndShareLink(
          title: widget.activityForm.profileService.activityBackground.activityTitle.value.fold((l) => 'Activity Title', (r) => r),
          description: 'Someone wants to share an Activity with you!',
          imageUrl: getImageUrl,
          appLinkRoute: getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash()));

      copyLink = linkUrl;
      isLoading = false;
    } catch (e) {
      copyLink = getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash());
    }

    setState(() {
      isLoading = false;
    });

  }

  @override
  void initState() {
    getCopyLinkUrl();
    super.initState();
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.paletteColor : widget.model.mobileBackgroundColor,
                leading: IconButton(onPressed: () {
                  Navigator.of(context).pop();
                  }, icon: Icon(Icons.cancel, size: 30, color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor)),
                title: Text('Share', style: TextStyle(color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor)),
                centerTitle: true,
                actions: [

                ]
              ),
              body: Column(
                children: [

                  if (isLoading) Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 300,
                          decoration: BoxDecoration(
                            color: widget.model.accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )
                  ),
                  if (!(isLoading)) Screenshot(
                    controller: screenshotController,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 300,
                          decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.circular(30),
                        ),
                        child: SharedScreenshotEditorWidget(
                          model: widget.model,
                          listing: widget.listing,
                          activityForm: widget.activityForm,
                          reservation: widget.reservation,
                        )
                      ),
                    ),
                  ),

                  Container(
                    height: 110,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mobileShareOptionList().map(
                          (e) => (isLoading) ? Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade100,
                              child: CircleAvatar(
                                backgroundColor: widget.model.accentColor.withOpacity(0.2),
                                radius: 30,
                              ),
                            ),
                          ) : Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: () async {
                                Navigator.of(context).pop();
                                switch (e.shareType) {
                                  case MobileShareTypes.copyLink:
                                    Clipboard.setData(ClipboardData(text: copyLink ?? getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash())));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Copied to Clipboard!'),
                                      ),
                                    );
                                    break;
                                  case MobileShareTypes.instaStories:
                                    var path = await screenshot();
                                    if (path == null) {
                                      return;
                                    }

                                    SocialShare.shareInstagramStory(
                                        attributionURL: 'www.google.com',
                                        appId: FB_APP_ID,
                                        imagePath: path
                                    );
                                    // TODO: Handle this case.
                                    break;
                                  case MobileShareTypes.whatsApp:
                                    SocialShare.shareWhatsapp(
                                      copyLink ?? getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash())
                                    );
                                    // TODO: Handle this case.
                                    break;
                                  case MobileShareTypes.messenger:
                                    SocialShare.shareSms(
                                      'Check out the ${widget.activityForm.profileService.activityBackground.activityTitle.value.fold((l) => 'Activity', (r) => r)}',
                                      url: copyLink ?? getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash()),
                                      trailingText: '',
                                    );

                                    break;
                                  case MobileShareTypes.instaMessage:
                                    // var path = await screenshot();
                                    // if (path == null) {
                                    //   return;
                                    // }
                                    //
                                    // LecleSocialShare.I.sendMessageToInstagram(message: copyLink ?? getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash()));

                                    break;
                                  case MobileShareTypes.download:
                                    // var path = await screenshotPath();
                                    // if (path == null) {
                                    //   return;
                                    // }
                                    //
                                    // SocialShare.reSaveImage(path, 'circle_activity_share_message');
                                    // // TODO: Handle this case.
                                    break;
                                  case MobileShareTypes.more:
                                    var path = await screenshotPath();
                                    if (path == null) {
                                      return;
                                    }

                                    SocialShare.shareOptions(
                                        copyLink ?? getUrlForActivity(widget.reservation.instanceId.getOrCrash(), widget.reservation.reservationId.getOrCrash()),
                                        imagePath: path
                                    );
                                    break;
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    foregroundImage: (e.imagePath != null) ? Image.asset(e.imagePath!, color: widget.model.paletteColor).image : null,
                                    radius: 30,
                                    child: (e.icon != null) ? Icon(e.icon, color: Colors.black, size: 35) : null,
                                  ),
                                  const SizedBox(height: 4),
                                  if (e.isComingSoon) SizedBox(
                                      width: 100,
                                      child: Text('Coming Soon', style: TextStyle(color: widget.model.paletteColor.withOpacity(0.35), overflow: TextOverflow.ellipsis))),
                                  Flexible(
                                    child: Container(
                                      width: 90,
                                        child: Text(e.title, style: TextStyle(color: (e.isComingSoon) ? widget.model.paletteColor.withOpacity(0.35) : widget.model.paletteColor, overflow: TextOverflow.ellipsis),
                                                maxLines: 2, textAlign: TextAlign.center,

                                )
                              ),
                            )
                          ],
                        )
                      ),
                    )
                  ).toList()
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}