part of check_in_presentation;

String getUrlForUserProfile(String userId) => 'https://cincout.ca/${DashboardMarker.home.name.toString()}/${SearchExploreHelperMarker.map.name}/profile/${userId}';

Widget reportProfileWidget(DashboardModel model, String profileId) {
  return Row(
    children: [
      Icon(Icons.flag, color: model.paletteColor),
      const SizedBox(width: 5),
      InkWell(
        onTap: () async {
          final Uri params = Uri(
            scheme: 'mailto',
            path: 'hello@cincout.ca',
            query: encodeQueryParameters(<String, String>{
              'subject':'Profile Help - Circle Activities Issue',
              'body': 'There is a problem with this profile - $profileId'
            }),
          );

          if (await canLaunchUrl(params)) {
            launchUrl(params);
          }
        },
        child: Text('Report This Profile', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
      ),
    ],
  );
}

void dedSelectProfilePopOverOnly(BuildContext context, DashboardModel model, UserProfileModel currentUser) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile',
      // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 875,
                width: 650,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: (model.systemTheme.brightness != Brightness.dark) ? model.paletteColor : model.mobileBackgroundColor,
                    elevation: 0,
                    automaticallyImplyLeading: true,
                    centerTitle: true,
                    title: Text('Profile'),
                    leading: IconButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.cancel, size: 30, color: (model.systemTheme.brightness != Brightness.dark) ? model.mobileBackgroundColor : model.paletteColor), padding: EdgeInsets.zero),
                    titleTextStyle: TextStyle(color: (model.systemTheme.brightness != Brightness.dark) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                  ),
                  body: ProfileMainContainer(
                    model: model,
                    currentUserId: currentUser.userId.getOrCrash(),
                    currentUserProfile: currentUser,
                    isMobileViewOnly: true
                  ),
                ),
              )
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: (model.systemTheme.brightness != Brightness.dark) ? model.paletteColor : model.mobileBackgroundColor,
              elevation: 0,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text('${currentUser.legalName.getOrCrash()}\'s Profile'),
              leading: IconButton(onPressed: () {
                Navigator.of(context).pop();
              }, icon: Icon(Icons.cancel, size: 30, color: (model.systemTheme.brightness != Brightness.dark) ? model.mobileBackgroundColor : model.paletteColor), padding: EdgeInsets.zero),
              titleTextStyle: TextStyle(color: (model.systemTheme.brightness != Brightness.dark) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
            ),
            body: ProfileMainContainer(
              model: model,
              currentUserId: currentUser.userId.getOrCrash(),
              currentUserProfile: currentUser,
            ),
          );
        }
      )
    );
  }
}

void didSelectProfile(BuildContext context, UserProfileModel currentUser, ProfileTypeMarker profileType, DashboardModel model) async {
  if (kIsWeb) {
    final newUrl = getUrlForUserProfile(currentUser.userId.getOrCrash());
    final canLaunch = await canLaunchUrlString(newUrl);

    if (canLaunch) {
      await launchUrlString(newUrl);
    }
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return ProfileMainContainer(
              model: model,
              currentUserId: currentUser.userId.getOrCrash(),
              currentUserProfile: currentUser,
              profileType: profileType
          );
        }
      )
    );
  }
}

void didSelectReviewApplicationsWeb(BuildContext context, UserProfileModel profile) {
  if (kIsWeb) {

  } else {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (_) {
    //       return ApplicationRequestsMainContainer(
    //         model: widget.model,
    //         profileId: profile.userId,
    //       );
    //     }
    //   )
    // );
  }
}


void didSelectReservationPreview(BuildContext context, DashboardModel model, ReservationPreviewer item) async {
  if (item.listing != null && item.reservation != null) {
    final newUrl = getUrlForActivity(item.reservation!.instanceId.getOrCrash(), item.reservation!.reservationId.getOrCrash());
    final canLaunch = await canLaunchUrlString(newUrl);
    if (kIsWeb) {
      if (canLaunch) {
        await launchUrlString(newUrl);
      } else {
        return;
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return ActivityPreviewScreen(
          model: model,
          listing: item.listing,
          reservation: item.reservation,
          currentReservationId: item.reservation!.reservationId,
          currentListingId: item.reservation!.instanceId,
          didSelectBack: () {},
        );
      }));
    }
  }
}


void didSelectEditGeneralProfile(BuildContext context, DashboardModel model, UserProfileModel currentUserProfile) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Profile',
    // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
    transitionDuration: Duration(milliseconds: 350),
    pageBuilder: (BuildContext contexts, anim1, anim2) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 200,
                width: 650,
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: (model.systemTheme.brightness != Brightness.dark) ? model.paletteColor : model.mobileBackgroundColor,
                    elevation: 0,
                    automaticallyImplyLeading: true,
                    centerTitle: true,
                    title: Text('Edit Profile'),
                    leading: IconButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.cancel, size: 30, color: (model.systemTheme.brightness != Brightness.dark) ? model.mobileBackgroundColor : model.paletteColor), padding: EdgeInsets.zero),
                    titleTextStyle: TextStyle(color: (model.systemTheme.brightness != Brightness.dark) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                  ),
                  body: GeneralProfileCreatorEditor(
                        model: model,
                          currentUser: currentUserProfile,
                          didSaveSuccessfully: () {
                              Navigator.of(context).pop();
                          },
                            didCancel: () {
                              Navigator.of(context).pop();
                          }

                ),
              ),
            )
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
          scale: anim1.value,
          child: Opacity(
              opacity: anim1.value,
              child: child
          )
      );
    },
  );
}

void didSelectEditVendorProfile(BuildContext context, DashboardModel model, EventMerchantVendorProfile? currentVendorProfile) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Profile',
    // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
    transitionDuration: Duration(milliseconds: 350),
    pageBuilder: (BuildContext contexts, anim1, anim2) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                height: 760,
                width: 650,
                decoration: BoxDecoration(
                    color: model.webBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))
                ),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: (model.systemTheme.brightness != Brightness.dark) ? model.paletteColor : model.mobileBackgroundColor,
                    elevation: 0,
                    automaticallyImplyLeading: true,
                    centerTitle: true,
                    title: Text('Edit Profile'),
                    leading: IconButton(onPressed: () {
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.cancel, size: 30, color: (model.systemTheme.brightness != Brightness.dark) ? model.mobileBackgroundColor : model.paletteColor), padding: EdgeInsets.zero),
                    titleTextStyle: TextStyle(color: (model.systemTheme.brightness != Brightness.dark) ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                  ),
                  body: VendorProfileCreatorEditor(
                    model: model,
                    didSaveSuccessfully: () {
                      Navigator.of(context).pop();
                    },
                    didCancel: () {
                      Navigator.of(context).pop();
                    },
                    selectedVendorProfile: currentVendorProfile,
                  )
                ),
              )
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
          scale: anim1.value,
          child: Opacity(
              opacity: anim1.value,
              child: child
          )
      );
    },
  );
}

void didSelectShowAllFacilities() {

}


void didSelectShowAllReservationsByType(BuildContext context, DashboardModel model, UniqueId userId, List<ReservationSlotState> statusType) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'My Applications',
      // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 875,
                    width: 500,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: ReservationShowAllPaging(
                        userId: userId,
                        model: model,
                        statusType: statusType
                    )
                )
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return ReservationShowAllPaging(
              userId: userId,
              model: model,
              statusType: statusType
          );
        }
      )
    );
  }
}


void didSelectReviewApplications(BuildContext context, DashboardModel model, UniqueId userId) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'My Applications',
      // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 875,
                  width: 650,
                  decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: ApplicationRequestsMainContainer(
                      profileId: userId,
                      model: model
                  )
                )
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  } else {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) {
          return ApplicationRequestsMainContainer(
              profileId: userId,
              model: model
          );
        }
      )
    );
  }
}


void requestAccessToFacilitiesApp() async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: 'hello@cincout.ca',
    query: encodeQueryParameters(<String, String>{
      'subject':'a Circle for Owners - Request',
      'body': 'Hello, I would like to access the current beta for a Circle for organizers'
    }),
  );

  if (await canLaunchUrl(params)) {
  launchUrl(params);
  }
}


void didSelectSeeVendorsAppearances(UserProfileModel currentUser) {

}

void didSelectShareProfile(UserProfileModel user, ProfileTypeMarker profileType) {

}


Widget profileNotFound(BuildContext context, DashboardModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.person_pin_circle_outlined, size: 85, color: model.disabledTextColor),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.error_outline, color: model.paletteColor, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Profile Not Found',
                  style: TextStyle(
                    color: model.paletteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: model.secondaryQuestionTitleFontSize,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'The profile you are looking for does not exist or may have been removed.',
            style: TextStyle(color: model.disabledTextColor),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: model.paletteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: model.paletteColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Please check the URL or try searching for another profile.',
                    style: TextStyle(
                      color: model.paletteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}