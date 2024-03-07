part of check_in_presentation;

enum UserProfileType {searchProfile, slotProfile, nameOnlyProfile, nameAndEmail, firstLetterNameOnlyProfile, firstLetterOnlyProfile, listingProfile, attendeeProfile}
List<String> predefinedGenderOptions() {
  return ['Female','Male','Non-Binary','Prefer Not To Say'];
}

Widget retrieveUserProfile(String profileId, DashboardModel model, Color? backgroundColor, Color? textColor, double? textSize, {required UserProfileType profileType, required Widget? trailingWidget, required Function(UserProfileModel) selectedButton, }) {
  return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(profileId)),
    child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => (profileType != UserProfileType.firstLetterNameOnlyProfile) ? progressOverlay(model) : Container(),
              loadSelectedProfileFailure: (_) => couldNotRetrieveProfile(model),
              loadSelectedProfileSuccess: (item) {

                switch (profileType) {
                  case UserProfileType.searchProfile:
                    return userProfileWidget(
                        e: item.profile,
                        model: model,
                        buttonTitle: AppLocalizations.of(context)!.remove,
                        selectedButton: (profile) {
                          selectedButton(profile);
                        }
                    );
                  case UserProfileType.slotProfile:
                    return userProfileSlotWidget(
                      e: item.profile,
                      backgroundColor: backgroundColor ?? Colors.transparent,
                      textColor: textColor ?? model.paletteColor,
                      model: model,
                    );
                  case UserProfileType.firstLetterNameOnlyProfile:
                    return userProfileNameOnly(
                        e: item.profile,
                        model: model,
                        textColor: textColor ?? model.paletteColor
                    );
                  case UserProfileType.nameOnlyProfile:
                    return userProfileFullNameOnly(
                        e: item.profile,
                        model: model,
                        textColor: textColor ?? model.paletteColor,
                        fontSize: textSize ?? model.questionTitleFontSize
                    );
                  case UserProfileType.firstLetterOnlyProfile:
                    return userFirstLetterProfileNameOnly(
                        e: item.profile,
                        backgroundColor: backgroundColor ?? Colors.transparent,
                        textColor: textColor ?? model.paletteColor,
                        model: model
                    );
                  case UserProfileType.nameAndEmail:
                    return userProfileNameAndEmail(
                        e: item.profile,
                        model: model,
                        backgroundColor: backgroundColor ?? Colors.transparent,
                        textColor: textColor ?? model.paletteColor,
                        selectedButton: (profile) {
                          selectedButton(profile);
                        }
                    );
                  case UserProfileType.listingProfile:
                    return listingProfileWidget(
                        e: item.profile,
                        model: model
                    );
                  case UserProfileType.attendeeProfile:
                    return attendeeProfileWidget(
                      model: model,
                      user: item.profile,
                      selectedItem: selectedButton,
                      trailingWidget: trailingWidget,
                      textColor: textColor ?? model.paletteColor
                    );
                }
              },
              orElse: () => couldNotRetrieveProfile(model)
          );
        }
    ),
  );
}

Widget mobileUserProfileWidget(DashboardModel model, {required UserProfileModel profile, required bool showBadge, required double radius, required Function(UserProfileModel profile) onTapUserProfile}) {
  return GestureDetector(
    onTap: () {
      onTapUserProfile(profile);
    },
    child: Stack(
    children: [
      if (profile.profileImage != null) ClipRRect(
        borderRadius: BorderRadius.circular(radius/2),
        child: SizedBox(
          height: radius,
          width: radius,
          child: Image(image: profile.profileImage!.image, fit: BoxFit.cover),
        ),
      ),
      if (profile.profileImage == null) Container(
        height: radius,
        width: radius,
        decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(radius/2)
        ),
        child: Center(child: Text(profile.legalName.getOrCrash()[0], style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize))),
      ),
      if (profile.isEmailAuth && showBadge) Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: model.webBackgroundColor
          ),
          child: Icon(Icons.verified, color: Colors.deepOrange, size: 20),
          ),
        )
      ],
    )
  );
}

Widget userProfileSlotWidget({required UserProfileModel e, required Color backgroundColor, required Color textColor, required DashboardModel model}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration:  BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: textColor),
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Center(child: Text((e.legalName.isValid()) ? e.legalName.value.fold((l) => '..', (r) => r)[0] : e.emailAddress.value.fold((l) => 'cannot find', (r) => r)[0], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15))),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (e.legalName.isValid()) Text(e.legalName.getOrCrash(), style: TextStyle(color: textColor, fontWeight: FontWeight.bold),  overflow: TextOverflow.ellipsis),
              if (e.emailAddress.isValid()) Text(e.emailAddress.getOrCrash(), style: TextStyle(color: textColor), overflow: TextOverflow.ellipsis),
            ],
          ),
        )
      ],
    ),
  );
}

Widget userFirstLetterProfileNameOnly({required UserProfileModel e, required DashboardModel model, required Color textColor, required Color backgroundColor}) {
  return Container(
    width: 30,
    height: 30,
    decoration:  BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.all(Radius.circular(30))
    ),
    child: (e.profileImage != null && e.profileImage?.image != null) ? CircleAvatar(
      backgroundImage: e.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image,
    ) : Center(child: Text((e.legalName.isValid()) ? e.legalName.value.fold((l) => '..', (r) => r)[0] : e.emailAddress.value.fold((l) => 'cannot find', (r) => r)[0], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15))),
  );
}


Widget userProfileNameOnly({required UserProfileModel e, required DashboardModel model, required Color textColor}) {
  return Container(
    child: Text(e.legalName.value.fold((l) => '...', (r) => r[0]), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11)),
  );
}

Widget userProfileFullNameOnly({required UserProfileModel e, required DashboardModel model, required Color textColor, required double fontSize}) {
  return Container(
    child: Text(e.legalName.value.fold((l) => '...', (r) => r), style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: fontSize), overflow: TextOverflow.ellipsis,),
  );
}

Widget userProfileNameAndEmail({required UserProfileModel e, required Color backgroundColor, required Color textColor, required DashboardModel model, required Function(UserProfileModel) selectedButton}) {
  return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                    return model.paletteColor.withOpacity(0.1);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return model.paletteColor.withOpacity(0.1);
                  }
                  return Colors.transparent; // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(13.5)),
                  )
              )
          ),
        onPressed: () {
          selectedButton(e);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                  backgroundImage: (e.profileImage != null && e.profileImage?.image != null) ? e.profileImage!.image : Image.asset('assets/profile-avatar.png').image,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.legalName.isValid()) Text(e.legalName.getOrCrash(), style: TextStyle(color: textColor, fontWeight: FontWeight.bold),  overflow: TextOverflow.ellipsis, maxLines: 1),
                  if (e.emailAddress.isValid()) Text(e.emailAddress.getOrCrash(), style: TextStyle(color: textColor), overflow: TextOverflow.ellipsis, maxLines: 1),
              ],
            ),
          ],
        )
      )
    ),
  );
}

Widget userProfileWidget({required UserProfileModel e, required DashboardModel model, required String buttonTitle, required Function(UserProfileModel) selectedButton}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration:  BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Center(child: Text((e.legalName.isValid()) ? e.legalName.getOrCrash()[0] : e.emailAddress.getOrCrash()[0], style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: 18))),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (e.legalName.isValid()) Text(e.legalName.getOrCrash(), style: TextStyle(color: model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                    if (e.emailAddress.isValid()) Text(e.emailAddress.getOrCrash(), style: TextStyle(color: model.disabledTextColor), overflow: TextOverflow.ellipsis),
                    if ((e.userAddress?.isValid() ?? false) && e.userAddress != null) Text('Address: ${e.userAddress?.getOrCrash()}', style: TextStyle(color: model.disabledTextColor.withOpacity(0.8)), overflow: TextOverflow.ellipsis,),
                    /// connected facilities? /// connected locations??
                  ],
                ),
              ),
            ],
          ),
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                    return model.paletteColor.withOpacity(0.1);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return model.paletteColor.withOpacity(0.1);
                  }
                  return  model.paletteColor; // Use the component's default.
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  )
              )
          ),
          onPressed: () {
            selectedButton(e);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(buttonTitle, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 14,
              color: model.webBackgroundColor,
            ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget attendeeProfileWidget({required Function(UserProfileModel) selectedItem, required DashboardModel model, required UserProfileModel user, required Widget? trailingWidget, required Color textColor}) {
  return ListTile(
      onTap: () {
        selectedItem(user);
    },
    leading: Container(
        decoration: BoxDecoration(
          color: textColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
      padding: const EdgeInsets.all(1.75),
      child: CircleAvatar(backgroundImage: user.profileImage?.image ?? Image.asset('assets/profile-avatar.png').image))),
    title: Text('${user.legalName.getOrCrash()} ${user.legalSurname.value.fold((l) => '', (r) => r)}', style: TextStyle(color: textColor, overflow: TextOverflow.ellipsis), maxLines: 1),
    trailing: trailingWidget,
  );
}

Widget listingProfileWidget({required UserProfileModel e, required DashboardModel model}) {
  return Text(e.legalName.getOrCrash(), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.questionTitleFontSize));
}


Widget couldNotRetrieveProfile(DashboardModel model) {
  return Center(
    child: Container(
      child: Icon(Icons.perm_identity_rounded, color: model.paletteColor,),
    ),
  );
}

