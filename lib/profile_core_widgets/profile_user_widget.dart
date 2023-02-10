part of check_in_presentation;

enum UserProfileType {searchProfile, slotProfile, nameOnlyProfile, nameAndEmail, firstLetterNameOnlyProfile, firstLetterOnlyProfile, listingProfile}
List<String> predefinedGenderOptions() {
  return ['Female','Male','Non-Binary','Prefer Not To Say'];
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
    child: Center(child: Text((e.legalName.isValid()) ? e.legalName.value.fold((l) => '..', (r) => r)[0] : e.emailAddress.value.fold((l) => 'cannot find', (r) => r)[0], style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15))),
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
  return Container(
    // height: 60,
    width: 200,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
        ),
        IconButton(onPressed: () {
            selectedButton(e);
        }, tooltip: 'Message', icon: Icon(Icons.message_outlined, size: 21, color: textColor,)),
        SizedBox(
          width: 10,
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

