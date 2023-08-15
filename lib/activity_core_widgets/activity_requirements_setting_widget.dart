part of check_in_presentation;

Widget mainContainerForSectionOneRowOneReq({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() isSeventeenAndUnder, required Function(int) minimumAgeChanged, required Function() isMensOnly, required Function() isWomenOnly, required Function() isCoEdOnly, required Function(List<SkillLevel>) skillLevelExpectationChanged, }) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// *** age requirements *** ///
        SizedBox(height: 25),
        Text('Age Limit', style: TextStyle(
          color: model.disabledTextColor,
          fontSize: model.secondaryQuestionTitleFontSize,
        )
        ),
        const SizedBox(height: 20),
        Container(
          width: 675,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.activityRequirementAgeSeventeenUnder, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,)),
                  Text('otherwise any partner can request to collaborate with you', style: TextStyle(color: model.disabledTextColor))
                ],
              )
              ),
              FlutterSwitch(
                width: 60,
                inactiveColor: model.accentColor,
                activeColor: model.paletteColor,
                value: state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder,
                onToggle: (value) {
                  isSeventeenAndUnder();
                },
              ),
            ],
          ),
        ),

        Visibility(
          visible: !state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder,
          child: Container(
            width: 675,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(AppLocalizations.of(context)!.activityAllowedBelowAge,
                        style: TextStyle(
                            color: model.paletteColor,
                            fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,
                      ),
                    ),
                    Row(
                      children: [
                        QuantityButtons(
                            model: model,
                            initNumber: state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement,
                            counterCallback: (int v) {
                              minimumAgeChanged(v);
                          }
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: model.paletteColor,
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            height: 35,
                            width: 60,
                            child: Center(
                              child: Text(state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement.toString(), style: TextStyle(color: model.disabledTextColor)
                              ),
                            )
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 15),

        /// games and class based req.
        Visibility(
          // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityTypeOption.classesLessons,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.sports, color: model.paletteColor),
                    const SizedBox(width: 5),
                    Icon(Icons.videogame_asset_rounded, color: model.paletteColor),
                    const SizedBox(width: 15),
                    Expanded(child: Text('Specific Demographic Info', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1)),
                  ],
                ),
                Text(AppLocalizations.of(context)!.activityRequirementPreferencesGender, style: TextStyle(color: model.disabledTextColor)),
                const SizedBox(height: 10),
                Container(
                  width: 675,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderMen, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))
                      ),
                      FlutterSwitch(
                        width: 60,
                        inactiveColor: model.accentColor,
                        activeColor: model.paletteColor,
                        value: state.activitySettingsForm.profileService.activityRequirements.isMensOnly ?? false,
                        onToggle: (value) {
                          isMensOnly();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 675,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderWomen, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))
                      ),
                      FlutterSwitch(
                        width: 60,
                        inactiveColor: model.accentColor,
                        activeColor: model.paletteColor,
                        value: state.activitySettingsForm.profileService.activityRequirements.isWomenOnly ?? false,
                        onToggle: (value) {
                          isWomenOnly();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 675,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderCoed, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))
                      ),
                      FlutterSwitch(
                        width: 60,
                        inactiveColor: model.accentColor,
                        activeColor: model.paletteColor,
                        value: state.activitySettingsForm.profileService.activityRequirements.isCoEdOnly ?? false,
                        onToggle: (value) {
                          isCoEdOnly();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
        ),

        Visibility(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Row(
                children: [
                  Icon(Icons.sports, color: model.paletteColor),
                  const SizedBox(width: 5),
                  Icon(Icons.videogame_asset_rounded, color: model.paletteColor),
                  const SizedBox(width: 15),
                  Text('Any Required Skills?', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                ],
              ),
              Text(AppLocalizations.of(context)!.activityRequirementPreferencesSkillsExpected, style: TextStyle(color: model.disabledTextColor)),
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                    color: model.webBackgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(AppLocalizations.of(context)!.facilitiesSelectMulti, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize))
                ),
              ),

              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      color: model.accentColor.withOpacity(0.3),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border(
                          top: BorderSide(width: 0.5, color: model.disabledTextColor),
                          left: BorderSide(width: 0.5, color: model.disabledTextColor),
                          right: BorderSide(width: 0.5, color: model.disabledTextColor),
                          bottom: BorderSide(width: 0.5, color: model.disabledTextColor)
                      )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: SkillLevel.values.map(
                          (e) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                            width: 500,
                            height: 40,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                      return model.paletteColor.withOpacity(0.1);
                                    }
                                    if (states.contains(MaterialState.hovered)) {
                                      return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? model.paletteColor : model.paletteColor.withOpacity(0.1);
                                    }
                                    return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? model.paletteColor : Colors.transparent; // Use the component's default.
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    )
                                ),
                              ),
                              onPressed: () {

                                  final List<SkillLevel> listOfSkills = [];
                                  listOfSkills.addAll(state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation ?? []);

                                  if (listOfSkills.contains(e)) {
                                    listOfSkills.removeWhere((element) => element == e);
                                  } else {
                                    listOfSkills.add(e);
                                  }
                                  skillLevelExpectationChanged(listOfSkills);
                              },
                              child: Text(getSkillTypeName(context, e), style: TextStyle(color: (state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? model.accentColor : model.paletteColor, fontWeight: (state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? FontWeight.bold : FontWeight.normal)),
                            )
                        ),
                      ),
                    ).toList(),
                  )
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget mainContainerForSectionOneRowTwoReq({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() isAlcoholForSale, required Function() isFoodForSale, required Widget getVendorAttendees, required Function() didSelectCreateVendor}) {

  bool activityAgeSetting = state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder;

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 25),
      /// what is sold for all non - events.
      /// TODO: do not show if facility does not allow specific items to be sold.

      /// what is sold - specifically for events.
      Visibility(
        // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityOption.toRent || context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityOption.tournament,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// show event or non-rent selling options
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                // if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityOption.toRent)
                Row(
                  children: [
                    Icon(Icons.map, color: model.paletteColor),
                    const SizedBox(width: 5),
                    Icon(Icons.sports, color: model.paletteColor),
                    const SizedBox(width: 5),
                    Icon(Icons.videogame_asset_rounded, color: model.paletteColor),
                    const SizedBox(width: 5),
                  ],
                ),
                if (state.activitySettingsForm.activityType.activity == ProfileActivityOption.tournament) Icon(Icons.sports_handball_rounded, color: model.paletteColor),
                const SizedBox(width: 15),
                Expanded(child: Text('What are You Selling?', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
              ],
            ),
            const SizedBox(height: 20),

            IgnorePointer(
              ignoring: !activityAgeSetting,
              child: Container(
                width: 675,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.activityRequirementEventAlcoholTitle, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,)),
                        Visibility(
                            visible: !activityAgeSetting,
                            child: Text('Because this event is 18 and below - alcohol cannot be provided*', style: TextStyle(color: model.disabledTextColor))
                        )
                      ],
                    )
                    ),
                    FlutterSwitch(
                      width: 60,
                      inactiveColor: model.accentColor,
                      activeColor: model.paletteColor,
                      value: state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale ?? false,
                      onToggle: (value) {
                        isAlcoholForSale();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),

      Container(
        width: 675,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementEventFoodTitle, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))
            ),
            FlutterSwitch(
              width: 60,
              inactiveColor: model.accentColor,
              activeColor: model.paletteColor,
              value: state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale ?? false,
              onToggle: (value) {
                isFoodForSale();
              },
            ),
          ],
        ),
      ),

      const SizedBox(height: 25),
      getVendorAttendees,

      const SizedBox(height: 15),
      /// invite merchants or vendors
      InkWell(
        onTap: () {
          didSelectCreateVendor();
        },
        child: Container(
          width: 675,
          height: 60,
          decoration: BoxDecoration(
            color: model.webBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Align(
            child: Text('Invite New Vendor or Merchant', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          ),
        ),
      ),

    ],
  );
}


Widget mainContainerForSectionFooterReq({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() isGearProvided, required Function() isEquipmentProvided, required Function() isAnalyticsProvided, required Function() isOfficiatorProvided, required Function() isAlcoholProvided, required Function() isFoodProvided, required Function() isSecurityProvided}) {

  bool activityAgeSetting = state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder;

  /// TODO: THESE OPTIONS NEED TO TAKE FACILITY RESTRICTIONS INTO ACCOUNT (IF 18+ ACTIVITIES ARE ALLOWED OR NOT)
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// what will be provided for non event activities (i.e classes, games, experiences)
        Visibility(
          // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityOption.events,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.map, color: model.paletteColor),
                  const SizedBox(width: 15),
                  Text('Providing Anything?', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                ],
              ),
              Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: model.disabledTextColor)),
              const SizedBox(height: 10),

              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.activityRequirementsCoveredJerseyGear, style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                        const SizedBox(height: 10),
                        Container(
                            height: 120,
                            child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Jersey_Gear.png', color: (state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high)),
                        const SizedBox(height: 18),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: (state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false),
                          onToggle: (value) {
                            isGearProvided();
                          },
                        )
                      ],
                    ),
                    const SizedBox(width: 23),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                        const SizedBox(height: 10),
                        Container(
                            height: 120,
                            child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', color: (state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                        const SizedBox(height: 18),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: (state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false),
                          onToggle: (value) {
                            isEquipmentProvided();
                          },
                        )
                      ],
                    ),
                    const SizedBox(width: 16),
                    Visibility(
                      // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.activityRequirementsCoveredAnalyticsStandings, style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Container(
                              height: 120,
                              child: Icon(Icons.bar_chart_rounded, size: 110, color: (state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45))),
                          const SizedBox(height: 18),
                          FlutterSwitch(
                            width: 60,
                            inactiveColor: model.accentColor,
                            activeColor: model.paletteColor,
                            value: (state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false),
                            onToggle: (value) {
                              isAnalyticsProvided();
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Visibility(
                      // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Officiator/Referees', style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center),
                          const SizedBox(height: 35),
                          Container(
                              height: 80,
                              width: 120,
                              child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Referee_Officiator.png', color: (state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                          const SizedBox(height: 15),
                          const SizedBox(height: 18),
                          FlutterSwitch(
                            width: 60,
                            inactiveColor: model.accentColor,
                            activeColor: model.paletteColor,
                            value: (state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false),
                            onToggle: (value) {
                              isOfficiatorProvided();
                            },
                          )
                        ],
                      ),
                    )

                  ],
                ),
              )
            ],
          ),
        ),

        /// what will be provided specifically for events
        /// TODO: WILL DEPEND ON FACILITY RULES
        Visibility(
          // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityOption.events,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// show provided specifically for events
                const SizedBox(height: 25),
                Row(
                  children: [
                    Icon(Icons.connect_without_contact_rounded, color: model.paletteColor),
                    const SizedBox(width: 15),
                    Text('Provided for your Event?', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                  ],
                ),
                Visibility(
                    visible: !activityAgeSetting,
                    child: Text('Because this event is 18 and below - alcohol cannot be provided*', style: TextStyle(color: model.paletteColor))),
                Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: model.disabledTextColor)),
                const SizedBox(height: 10),

                Container(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                          SizedBox(height: 10),
                          Container(
                              height: 120,
                              width: 120,
                              child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                          SizedBox(height: 18),
                          FlutterSwitch(
                            width: 60,
                            inactiveColor: model.accentColor,
                            activeColor: model.paletteColor,
                            value: (state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false),
                            onToggle: (value) {
                              isEquipmentProvided();
                            },
                          )
                        ],
                      ),
                      const SizedBox(width: 15),
                      /// NOT AN OPTION IF EVENT IS UNDER 18...
                      IgnorePointer(
                        ignoring: !activityAgeSetting,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.activityRequirementEventAlcohol, style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) ? model.paletteColor : model.disabledTextColor)),
                            SizedBox(height: 10),
                            Container(
                                height: 120,
                                width: 120,
                                child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Alcohol.png', color: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                            SizedBox(height: 18),
                            FlutterSwitch(
                              width: 60,
                              inactiveColor: model.accentColor,
                              activeColor: model.paletteColor,
                              value: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false),
                              onToggle: (value) {
                                isAlcoholProvided();
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(AppLocalizations.of(context)!.activityRequirementEventFoodOrDrink, style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center),
                          SizedBox(height: 25),
                          Container(
                              height: 90,
                              width: 120,
                              child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Food_Drinks.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
                          SizedBox(height: 40),
                          FlutterSwitch(
                            width: 60,
                            inactiveColor: model.accentColor,
                            activeColor: model.paletteColor,
                            value: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false),
                            onToggle: (value) {
                              isFoodProvided();
                            },
                          )
                        ],
                      ),
                      const SizedBox(width: 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Security', style: TextStyle(fontWeight: FontWeight.bold, color: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) ? model.paletteColor : model.disabledTextColor), textAlign: TextAlign.center,),
                          SizedBox(height: 15),
                          Container(
                              height: 120,
                              width: 120,
                              child: Center(child: Icon(Icons.lock, size: 55, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) ? model.paletteColor : model.disabledTextColor.withOpacity(0.45)))),
                          SizedBox(height: 18),
                          FlutterSwitch(
                            width: 60,
                            inactiveColor: model.accentColor,
                            activeColor: model.paletteColor,
                            value: (state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false),
                            onToggle: (value) {
                              isSecurityProvided();
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
        ),
      ],
    ),
  );
}
