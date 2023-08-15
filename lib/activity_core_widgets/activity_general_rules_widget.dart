part of check_in_presentation;

Widget mainContainerGenRules({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function(List<DetailOption>) ruleOptionChanged, required Function(String, int) customRuleOptionStringChanged, required Function(int) customRuleOptionRemoveChanged, required Function(ListK<DetailCustomOption>) customRuleOptionAdd}) {
  return Column(
    children: [
      const SizedBox(height: 25),
      Text('Here\'s Our Rules:', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 10),
      Text(AppLocalizations.of(context)!.activityRulePreSubTitle, style: TextStyle(
          color: model.paletteColor,
          fontSize: model.secondaryQuestionTitleFontSize)),
      SizedBox(height: 15),
      Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ourPredefinedDetailOptions(context).map(
                      (e) => ListTile(
                    title: Text(e.detail ?? ''),
                    leading: Icon(getIconForRuleOption(context, e.uid), color: model.paletteColor),
                  )
              ).toList())),

      const SizedBox(height: 25),
      Text('What are your Rules?', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 10),
      Text(AppLocalizations.of(context)!.activityRuleCustomDetailsTitle, style: TextStyle(
          color: model.paletteColor,
          fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 10),
      Text(AppLocalizations.of(context)!.activityRuleCustomDetailsSubTitle, style: TextStyle(
          color: model.disabledTextColor)),

      const SizedBox(height: 25),
      _selectableAttendeeBasedRules(
          context,
          model,
          state.activitySettingsForm.rulesService.ruleOption.value.fold((l) => [], (r) => r),
          ruleOptionChanged: (detailOption) => ruleOptionChanged(detailOption)
      ),
      const SizedBox(height: 25),

      Text('Any More Specific Rules?', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 15),
      Container(
        alignment: Alignment.centerLeft,
        height: 55,
        width: 250,
        decoration: BoxDecoration(
            color: model.webBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(17.5))
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(AppLocalizations.of(context)!.activityCreateAndAdd, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
        ),
      ),
      SizedBox(height: 10),
      _selectedCustomRulesToInclude(
          context,
          model,
          state.activitySettingsForm.rulesService.customRuleOption,
          customRuleOptionStringChanged: (value, i) => customRuleOptionStringChanged(value, i),
          customRuleOptionRemoveChanged: (i) => customRuleOptionRemoveChanged(i),
          customRuleOptionAdd: (customList) => customRuleOptionAdd(customList)
      ),

    ]
  );
}

Widget _selectableAttendeeBasedRules(BuildContext context, DashboardModel model, List<DetailOption> detailOptions, {required Function(List<DetailOption>) ruleOptionChanged}) {
  return Container(
    width: 675,
    child: Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
          children: predefinedDetailOptions(context).map(
                  (e) => ListTile(
                textColor: (detailOptions.map((e) => e.uid).contains(e.uid)) ? model.paletteColor : model.disabledTextColor,
                iconColor: (detailOptions.map((e) => e.uid).contains(e.uid)) ? model.paletteColor : model.disabledTextColor,
                leading: Icon(getIconForRuleOption(context, e.uid)),
                title: Text(e.detail ?? ''),
                trailing: Container(
                  height: 50,
                  width: 100,
                  child: FlutterSwitch(
                    width: 60,
                    inactiveColor: model.accentColor,
                    activeColor: model.paletteColor,
                    value: (detailOptions.map((e) => e.uid).contains(e.uid)),
                    onToggle: (value) {

                      if ((detailOptions.map((e) => e.uid).contains(e.uid))) {
                        //remove
                        detailOptions.removeWhere((element) => element.uid == e.uid);
                        ruleOptionChanged(detailOptions);
                      } else {
                        //add
                        detailOptions.add(e);
                        ruleOptionChanged(detailOptions);
                    }
                },
              ),
            ),
          )
        ).toList()
      ),
    ),
  );
}


Widget _selectedCustomRulesToInclude(BuildContext context, DashboardModel model, ListK<DetailCustomOption>? customDetailOptionList, {required Function(String, int) customRuleOptionStringChanged, required Function(int) customRuleOptionRemoveChanged, required Function(ListK<DetailCustomOption>) customRuleOptionAdd} ) {
  return Padding(
    padding: const EdgeInsets.only(left: 30.0),
    child: Container(
      width: 675,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ...customDetailOptionList?.getOrCrash().asMap().map((i,e) {

              final _selectedTextEditingController = TextEditingController();

              if (_selectedTextEditingController.text != e.customDetail) {
                _selectedTextEditingController.text = e.customDetail ?? '';
              }

              return MapEntry(i,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Icon(Icons.info_outline, color: model.paletteColor),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: getDescriptionTextField(
                              context,
                              model,
                              _selectedTextEditingController,
                              '',
                              1,
                              60,
                              updateText: (value) {
                                customRuleOptionStringChanged(value, i);
                            }
                          ),
                        ),
                        const SizedBox(width: 15),
                        Visibility(
                          visible: i != 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: TextButton(onPressed: () {
                                customRuleOptionRemoveChanged(i);
                            }, child: Icon(Icons.cancel_outlined, size: 40, color: (i != 0) ? model.paletteColor : model.disabledTextColor)),
                          ),
                        ),
                        const SizedBox(width: 15),
                      ],
                    ),
                  ],
                ),
              );
            }
            ).values.toList() ?? [],
            SizedBox(height: 10),
            Visibility(
              visible: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption?.getOrCrash().length ?? 1) < 5,
              child: Center(
                child: IconButton(onPressed: () {

                    customRuleOptionAdd(customDetailOptionList ?? ListK([]));

                }, icon: Icon(Icons.add_circle_outline, size: 25, color: model.paletteColor,)),
              ),
            )
          ]
      ),
    ),
  );
}
