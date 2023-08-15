part of check_in_presentation;

Widget mainContainerForCustom({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function(CustomRuleOption) createCustomEditForm, required Function(List<CustomRuleOption>) customFieldRuleSettingsChanged, required Function() editCustomRuleEdit}) {
  return Column(
    children: [
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Create Custom Rules for All Attendees', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ),
      const SizedBox(height: 15),
      ...state.activitySettingsForm.rulesService.customFieldRuleSetting.asMap().map(
              (i, value) => MapEntry(i,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      createCustomEditForm(value);
                    },
                    child: Container(
                      width: 675,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getCustomRuleTitle(value.customRuleType ?? CustomRuleObjectType.numberLimitRule), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                              IconButton(onPressed: () {
                                  final List<CustomRuleOption> removeRule = [];
                                  removeRule.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customFieldRuleSetting);
                                  removeRule.remove(value);
                                  customFieldRuleSettingsChanged(removeRule);
                              }, icon: Icon(Icons.cancel_outlined, color: model.disabledTextColor)),
                            ],
                          ),
                          widgetForCustomRule(
                              context,
                              model,
                              value,
                              didUpdateCustomRule: (selection) {

                            }
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
      ).values.toList(),
      const SizedBox(height: 15),
      Container(
        width: 675,
        height: 60,
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
                    return model.webBackgroundColor; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    )
                )
            ),
            onPressed: () {
              editCustomRuleEdit();
            },
            child: Align(
              alignment: Alignment.center,
              child: Text('Create New Custom Rule',
                style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), textAlign: TextAlign.center,
            ),
          )
        ),
      ),
    ],
  );
}