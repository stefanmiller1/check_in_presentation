part of check_in_presentation;

String getCustomRuleTitle(CustomRuleObjectType rule) {
  switch (rule) {
    case CustomRuleObjectType.textFieldRule:
      return 'Text Field Rule';
    case CustomRuleObjectType.singleSelectionRule:
      return 'Single Selection Rule';
    case CustomRuleObjectType.multiSelectionRule:
      return 'Multi Selection Rule';
    case CustomRuleObjectType.numberLimitRule:
      return 'Number Limit Rule';
    case CustomRuleObjectType.checkBoxRule:
      return 'Check Box Rule';
  }
}

Widget widgetForCustomRule(
    BuildContext context,
    DashboardModel model,
    CustomRuleOption customRule,
    {
      required Function(CustomRuleOption) didUpdateCustomRule,
    }
    ) {
  switch (customRule.customRuleType) {
    case CustomRuleObjectType.textFieldRule:
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: model.paletteColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: Text(customRule.customRuleTitleLabel, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)
                        )
                      ),
                      if (customRule.customRuleOptionDetail?.isRequiredOption ?? false) Text('*', style: TextStyle(color: model.paletteColor),),
                      ],
                    ),
                  ),
                  if (customRule.customRuleOptionDetail?.labelHelpText != null && customRule.customRuleOptionDetail?.labelHelpText != '') IconButton(icon: Icon(Icons.info_outlined, color: model.paletteColor, size: 13.5,), tooltip: customRule.customRuleOptionDetail?.labelHelpText ?? '', onPressed: () {},)
                ],
              ),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  maxLength: 200,
                  maxLines: 6,
                  initialValue: customRule.labelTextRuleOption?.titleLabel,
                  style: TextStyle(color: model.paletteColor),
                  onChanged: (value) {
                    customRule = customRule.copyWith(
                      labelTextRuleOption: customRule.labelTextRuleOption?.copyWith(
                        titleLabel: value
                      )
                    );
                    didUpdateCustomRule(customRule);
                  },
                  decoration: InputDecoration(
                    hintText: 'Type Here...',
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: model.disabledTextColor,
                      ),
                    ),
                    counterStyle: TextStyle(
                      color: model.paletteColor,
                    ),
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: model.disabledTextColor,
                    ),
                    filled: true,
                    fillColor: model.accentColor,
                    focusedBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: model.paletteColor,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: model.disabledTextColor,
                        width: 5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: model.disabledTextColor,
                        width: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    case CustomRuleObjectType.singleSelectionRule:
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: model.paletteColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Row(
                    children: [
                      Expanded(
                          child: Text(customRule.customRuleTitleLabel, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
                      if (customRule.customRuleOptionDetail?.isRequiredOption ?? false) Text('*', style: TextStyle(color: model.paletteColor),),
                      ],
                    ),
                  ),
                  if (customRule.customRuleOptionDetail?.labelHelpText != null && customRule.customRuleOptionDetail?.labelHelpText != '') IconButton(icon: Icon(Icons.info_outlined, color: model.paletteColor, size: 13.5,), tooltip: customRule.customRuleOptionDetail?.labelHelpText ?? '', onPressed: () {},)
                ],
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: model.paletteColor),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(AppLocalizations.of(context)!.facilitiesSelect, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 675,
                    child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                            // offset: const Offset(-10,-15),
                            isDense: true,
                            // buttonElevation: 0,
                            // buttonDecoration: BoxDecoration(
                            //   color: Colors.transparent,
                            //   borderRadius: BorderRadius.circular(35),
                            // ),
                            customButton: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: model.accentColor,
                                border: Border.all(color: model.disabledTextColor),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text((customRule.selectionLabelOption?.labelPlaceHolder != null) ? (customRule.selectionLabelOption?.labelPlaceHolder ?? 'Select From Below') : 'Select A Rule', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.normal),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.keyboard_arrow_down_rounded, color: model.paletteColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onChanged: (Object? navItem) {

                            },
                            // buttonWidth: 80,
                            // buttonHeight: 70,
                            // dropdownElevation: 1,
                            // dropdownPadding: const EdgeInsets.all(1),
                            // dropdownDecoration: BoxDecoration(
                            //     boxShadow: [BoxShadow(
                            //         color: Colors.black.withOpacity(0.07),
                            //         spreadRadius: 1,
                            //         blurRadius: 15,
                            //         offset: Offset(0, 2)
                            //     )
                            //     ],
                            //     color: model.accentColor,
                            //     border: Border.all(color: model.disabledTextColor),
                            //     borderRadius: BorderRadius.circular(20)),
                            // itemHeight: 50,
                            // // dropdownWidth: mainWidth,
                            // focusColor: Colors.grey.shade100,
                            items: customRule.selectionLabelOption?.selectionLabelOptions.where((element) => element.stringItem != '').map(
                                    (e) {
                                  return DropdownMenuItem<String>(
                                      onTap: () {

                                        customRule = customRule.copyWith(
                                          selectionLabelOption: customRule.selectionLabelOption?.copyWith(
                                            labelPlaceHolder: e.stringItem
                                          )
                                        );
                                        didUpdateCustomRule(customRule);
                                      },
                                      value: e.stringItem,
                                      child: Text(e.stringItem, style: TextStyle(color: model.disabledTextColor))
                            );
                          }
                        ).toList()
                      )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    case CustomRuleObjectType.multiSelectionRule:
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: model.paletteColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(customRule.customRuleTitleLabel, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
                      if (customRule.customRuleOptionDetail?.isRequiredOption ?? false) Text('*', style: TextStyle(color: model.paletteColor),),
                      ],
                    ),
                  ),
                  if (customRule.customRuleOptionDetail?.labelHelpText != null && customRule.customRuleOptionDetail?.labelHelpText != '') IconButton(icon: Icon(Icons.info_outlined, color: model.paletteColor, size: 13.5,), tooltip: customRule.customRuleOptionDetail?.labelHelpText ?? '', onPressed: () {},)
                ],
              ),

              SizedBox(height: 10),
              ...?customRule.selectionLabelOption?.selectionLabelOptions.where((element) => element.stringItem != '').map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.stringItem, style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))),
                            SizedBox(width: 10),
                            FlutterSwitch(
                              width: 60,
                              inactiveColor: model.accentColor,
                              activeColor: model.paletteColor,
                              value: e.boolItem,
                              onToggle: (value) {

                                final List<StringBoolItem> selectedOptions = [];
                                selectedOptions.addAll(customRule.selectionLabelOption?.selectionLabelOptions ?? []);

                                final int index = selectedOptions.indexWhere((element) => element.stringItem == e.stringItem);
                                final StringBoolItem newItem = StringBoolItem(stringItem: e.stringItem, boolItem: value);

                                selectedOptions.replaceRange(index, index+1, [newItem]);

                                customRule = customRule.copyWith(
                                  selectionLabelOption: customRule.selectionLabelOption?.copyWith(
                                    selectionLabelOptions: selectedOptions
                                  )
                                );

                                didUpdateCustomRule(customRule);

                          },
                        )
                      ],
                    ),
                  )
                ).toList()
            ],
          ),
        ),
      );
    case CustomRuleObjectType.numberLimitRule:
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: model.paletteColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),

              ...?customRule.numberLimitRuleOption?.numberLimit?.where((element) => element.labelForNumberLimit != '').map(
                      (e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${e.labelForNumberLimit} (max: ${e.numberToLimit})', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                              SizedBox(width: 5),
                              if (customRule.customRuleOptionDetail?.labelHelpText != null && customRule.customRuleOptionDetail?.labelHelpText != '') IconButton(icon: Icon(Icons.info_outlined, color: model.paletteColor, size: 13.5,), tooltip: customRule.customRuleOptionDetail?.labelHelpText ?? '', onPressed: () {},)
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 190,
                            child: TextFormField(
                              maxLength: 5,
                              style: TextStyle(color: model.paletteColor),
                              initialValue: e.numberToLimit.toString(),
                              onChanged: (value) {

                                final List<NumberLimitRule> selectedOptions = [];
                                selectedOptions.addAll(customRule.numberLimitRuleOption?.numberLimit ?? []);

                                final int index = selectedOptions.indexWhere((element) => element.labelForNumberLimit == e.labelForNumberLimit);
                                final NumberLimitRule newItem = NumberLimitRule(numberToLimit: int.parse(value), labelForNumberLimit: e.labelForNumberLimit);

                                selectedOptions.replaceRange(index, index+1, [newItem]);

                                customRule = customRule.copyWith(
                                    numberLimitRuleOption: customRule.numberLimitRuleOption?.copyWith(
                                        numberLimit: selectedOptions
                                    )
                                );

                                didUpdateCustomRule(customRule);

                              },
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                hintText: 'Max',
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: model.disabledTextColor,
                                  ),
                                ),
                                counterStyle: TextStyle(
                                  color: model.paletteColor,
                                ),
                                errorStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: model.disabledTextColor,
                                ),
                                filled: true,
                                fillColor: model.accentColor,
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: model.paletteColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: model.disabledTextColor,
                                    width: 5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(
                                    color: model.disabledTextColor,
                                    width: 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
              ).toList()
            ],
          ),
        ),
      );
    case CustomRuleObjectType.checkBoxRule:

      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            border: Border.all(color: model.paletteColor)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              CheckboxListTile(
                activeColor: model.paletteColor,
                value: customRule.checkBoxRuleOption?.labelForRequirement.boolItem ?? false,
                onChanged: (value) {
                  customRule = customRule.copyWith(
                    checkBoxRuleOption: customRule.checkBoxRuleOption?.copyWith(
                      labelForRequirement: StringBoolItem(stringItem: customRule.checkBoxRuleOption?.labelForRequirement.stringItem ?? '', boolItem: customRule.checkBoxRuleOption?.labelForRequirement.boolItem ?? false)
                    )
                  );
                  didUpdateCustomRule(customRule);
                },
                title: Row(
                  children: [
                    Expanded(
                      child: Text(customRule.checkBoxRuleOption?.labelForRequirement.stringItem ?? '', style: TextStyle(
                          color: model.paletteColor,
                          fontSize: model.secondaryQuestionTitleFontSize)
                      ),
                    ),
                    if (customRule.customRuleOptionDetail?.isRequiredOption ?? false) Text('*', style: TextStyle(color: model.paletteColor),),
                    SizedBox(width: 5),
                    if (customRule.customRuleOptionDetail?.labelHelpText != null && customRule.customRuleOptionDetail?.labelHelpText != '') IconButton(icon: Icon(Icons.info_outlined, color: model.paletteColor, size: 13.5,), tooltip: customRule.customRuleOptionDetail?.labelHelpText ?? '', onPressed: () {},)
                  ],
                ),
              ),

              SizedBox(height: 5),
              Visibility(
                visible: (customRule.checkBoxRuleOption?.selectableLink != null && customRule.checkBoxRuleOption?.selectableLink != ''),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Text('Link:', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize),),
                      SizedBox(width: 5),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            decoration: BoxDecoration(
                              color: model.paletteColor,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(customRule.checkBoxRuleOption?.selectableLink ?? '', style: TextStyle(color: model.webBackgroundColor,)),
                            )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
             ),
          ),
        );
    default:
      return Container();
  }

}