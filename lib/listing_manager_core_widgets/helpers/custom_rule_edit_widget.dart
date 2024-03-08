part of check_in_presentation;

class CustomRuleEditForm extends StatefulWidget {

  final DashboardModel model;
  final CustomRuleOption currentCustomRuleOption;
  final Function(CustomRuleOption rule) didSaveCustomRule;

  const CustomRuleEditForm({Key? key, required this.model, required this.currentCustomRuleOption, required this.didSaveCustomRule}) : super(key: key);

  @override
  State<CustomRuleEditForm> createState() => _CustomRuleEditFormState();
}

class _CustomRuleEditFormState extends State<CustomRuleEditForm> {

  ScrollController? _scrollController;
  // late CustomRuleOption _customRuleOption;
  late bool _showMoreOptions = false;
  late StringBoolItem option1 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option2 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option3 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option4 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option5 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option6 = StringBoolItem(stringItem: '', boolItem: false);

  late NumberLimitRule numberOption1 = NumberLimitRule(numberToLimit: 0, labelForNumberLimit: '');
  late NumberLimitRule numberOption2 = NumberLimitRule(numberToLimit: 0, labelForNumberLimit: '');
  late NumberLimitRule numberOption3 = NumberLimitRule(numberToLimit: 0, labelForNumberLimit: '');
  late NumberLimitRule numberOption4 = NumberLimitRule(numberToLimit: 0, labelForNumberLimit: '');

  late TextEditingController _firstTextEditingController;
  late TextEditingController _secondTextEditingController;
  late TextEditingController _thirdTextEditingController;
  late TextEditingController _fourthTextEditingController;
  late TextEditingController _fifthTextEditingController;
  late TextEditingController _sixTextEditingController;
  late TextEditingController _sevenTextEditingController;
  late TextEditingController _eighthTextEditingController;

  
  @override
  void initState() {
    _scrollController = ScrollController();

    _firstTextEditingController = TextEditingController();
    _secondTextEditingController = TextEditingController();
    _thirdTextEditingController = TextEditingController();
    _fourthTextEditingController = TextEditingController();
    _fifthTextEditingController = TextEditingController();
    _sixTextEditingController = TextEditingController();
    _sevenTextEditingController = TextEditingController();
    _eighthTextEditingController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _firstTextEditingController.dispose();
    _secondTextEditingController.dispose();
    _thirdTextEditingController.dispose();
    _fourthTextEditingController.dispose();
    _fifthTextEditingController.dispose();
    _sixTextEditingController.dispose();
    _sevenTextEditingController.dispose();
    _eighthTextEditingController.dispose();

    super.dispose();
  }

  Widget mainContainerForCustomType(BuildContext context, CustomRuleOption ruleOption) {

    List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
    List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

    switch (ruleOption.customRuleType) {
      case CustomRuleObjectType.textFieldRule:
        return Column(
          children: [
            Text('Create a Label*', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
              ),
            ),
            const SizedBox(height: 10),
            labelContainer(
                null,
                _firstTextEditingController,
                hintLabel: 'Reservation Notes:',
                didUpdateLabel: (e) {
                  setState(() {
                    context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleTitleChanged(e));
                  });
                }),
          ],
        );
      case CustomRuleObjectType.singleSelectionRule:

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create a Label*', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
              ),
            ),
            const SizedBox(height: 10),
            labelContainer(
              null,
              _firstTextEditingController,
              hintLabel: 'Equipment You Can Rent',
              didUpdateLabel: (e) {
                setState(() {
                  context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleTitleChanged(e));
                });
              }),
            SizedBox(height: 15),
            Text('Create a List of Options*', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _secondTextEditingController,
                      hintLabel: 'Tennis Net',
                      didUpdateLabel: (e) {

                        setState(() {
                          option1 = option1.copyWith(
                            stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: labelContainer(
                      null,
                      _thirdTextEditingController,
                      hintLabel: 'Volley-Ball Net',
                      didUpdateLabel: (e) {
                        setState(() {
                          option2 = option2.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _fourthTextEditingController,
                      hintLabel: 'Badminton Net & Rackets',
                      didUpdateLabel: (e) {
                        setState(() {
                          option3 = option3.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: labelContainer(
                      null,
                      _fifthTextEditingController,
                      hintLabel: 'Helmets',
                      didUpdateLabel: (e) {
                        setState(() {
                          option4 = option4.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _sixTextEditingController,
                      hintLabel: 'Gear & Equipment',
                      didUpdateLabel: (e) {
                        setState(() {
                          option5 = option5.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: labelContainer(
                      null,
                      _sevenTextEditingController,
                      hintLabel: '...',
                      didUpdateLabel: (e) {
                        setState(() {
                          option6 = option6.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));

                        });
                      }),
                ),
              ],
            ),
          ],
        );
      case CustomRuleObjectType.multiSelectionRule:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create a Label*', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
            ),
            ),
            const SizedBox(height: 10),
            labelContainer(
                null,
                _firstTextEditingController,
                hintLabel: 'Equipment You Can Rent',
                didUpdateLabel: (e) {
                  setState(() {
                    context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleTitleChanged(e));
                  });
                }),
            SizedBox(height: 15),
            Text('Create a List of Options*', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
            ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _secondTextEditingController,
                      hintLabel: 'Tennis Net',
                      didUpdateLabel: (e) {

                        setState(() {
                          option1 = option1.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: labelContainer(
                      null,
                      _thirdTextEditingController,
                      hintLabel: 'Volley-Ball Net',
                      didUpdateLabel: (e) {
                        setState(() {
                          option2 = option2.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _fourthTextEditingController,
                      hintLabel: 'Badminton Net & Rackets',
                      didUpdateLabel: (e) {
                        setState(() {
                          option3 = option3.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: labelContainer(
                      null,
                      _fifthTextEditingController,
                      hintLabel: 'Helmets',
                      didUpdateLabel: (e) {
                        setState(() {
                          option4 = option4.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _sixTextEditingController,
                      hintLabel: 'Gear & Equipment',
                      didUpdateLabel: (e) {
                        setState(() {
                          option5 = option5.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));
                        });
                      }),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: labelContainer(
                      null,
                      _sevenTextEditingController,
                      hintLabel: '...',
                      didUpdateLabel: (e) {
                        setState(() {
                          option6 = option6.copyWith(
                              stringItem: e
                          );
                          List<StringBoolItem> selectionOptions = [option1, option2, option3, option4, option5, option6];
                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleSelectionRuleChanged(SelectionLabelOption(
                              selectionLabelOptions: selectionOptions,
                              isMultiSelection: true)));

                        });
                      }),
                ),
              ],
            ),
          ],
        );
      case CustomRuleObjectType.numberLimitRule:
        return Column(
          children: [
            Row(
              children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Label For Number Rule', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        SizedBox(height: 5),
                        labelContainer(
                            null,
                            _firstTextEditingController,
                            hintLabel: 'Maximum Number of Guests',
                            didUpdateLabel: (e) {
                              setState(() {

                                numberOption1 = numberOption1.copyWith(
                                  numberToLimit: numberOption1.numberToLimit,
                                  labelForNumberLimit: e
                                );
                                List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

                                context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleNumberLimitRuleChanged(NumberLimitRuleOption(
                                    numberLimit: numberOptions
                                )));


                              });
                              setState(() {});
                        }),
                      ],
                    ),
                  ),
                  SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Number', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      Container(
                        width: 65,
                        child: numberLabelContainer(
                            hintLabel: 'Max',
                            didUpdateLabel: (e) {
                              setState(() {
                                numberOption1 = numberOption1.copyWith(
                                    numberToLimit: int.parse(e),
                                    labelForNumberLimit: numberOption1.labelForNumberLimit
                                );
                                List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

                                context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleNumberLimitRuleChanged(NumberLimitRuleOption(
                                    numberLimit: numberOptions
                                )));
                              });
                              setState(() {});
                            }),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _secondTextEditingController,
                      hintLabel: '',
                      didUpdateLabel: (e) {
                        setState(() {

                          numberOption2 = numberOption2.copyWith(
                              numberToLimit: numberOption2.numberToLimit,
                              labelForNumberLimit: e
                          );
                          List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleNumberLimitRuleChanged(NumberLimitRuleOption(
                              numberLimit: numberOptions
                          )));
                        });
                        setState(() {});
                      }),
                ),
                SizedBox(width: 25,
                ),
                Container(
                  width: 65,
                  child: numberLabelContainer(
                      hintLabel: '',
                      didUpdateLabel: (e) {
                        setState(() {

                          numberOption2 = numberOption2.copyWith(
                              numberToLimit: int.parse(e),
                              labelForNumberLimit: numberOption2.labelForNumberLimit
                          );
                          List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleNumberLimitRuleChanged(NumberLimitRuleOption(
                              numberLimit: numberOptions
                          )));
                        });
                      }),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: labelContainer(
                      null,
                      _thirdTextEditingController,
                      hintLabel: '',
                      didUpdateLabel: (e) {
                        setState(() {

                          numberOption3 = numberOption3.copyWith(
                              numberToLimit: numberOption3.numberToLimit,
                              labelForNumberLimit: e
                          );
                          List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleNumberLimitRuleChanged(NumberLimitRuleOption(
                              numberLimit: numberOptions
                          )));
                        });
                      }),
                ),
                SizedBox(width: 25,),
                Container(
                  width: 65,
                  child: numberLabelContainer(
                      hintLabel: '',
                      didUpdateLabel: (e) {
                        setState(() {

                          numberOption3 = numberOption3.copyWith(
                              numberToLimit: int.parse(e),
                              labelForNumberLimit: numberOption3.labelForNumberLimit
                          );
                          List<NumberLimitRule> numberOptions = [numberOption1, numberOption2, numberOption3, numberOption4];

                          context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleNumberLimitRuleChanged(NumberLimitRuleOption(
                              numberLimit: numberOptions
                          )));
                        });
                      }),
                ),
              ],
            ),
          ],
        );
      case CustomRuleObjectType.checkBoxRule:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create a Label*', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
              ),
            ),
            const SizedBox(height: 10),
            labelContainer(
              null,
              _firstTextEditingController,
              hintLabel: 'Please Read Our Rules and Guidelines Before Completing Your Reservation',
              didUpdateLabel: (e) {
              setState(() {

                context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleCheckBoxRuleChanged(CheckBoxRuleOption(
                    selectableLink: context.read<CustomRuleFormBloc>().state.customRuleOption.checkBoxRuleOption?.selectableLink,
                    labelForRequirement: StringBoolItem(
                        stringItem: e,
                        boolItem: false
                      )
                    )
                  )
                );

              });
            }),
            SizedBox(height: 25),
            Text('Add a Link To Your Custom Check-Box Rule', style: TextStyle(
              fontSize: widget.model.secondaryQuestionTitleFontSize,
              color: widget.model.disabledTextColor,
              ),
            ),
            const SizedBox(height: 10),
            labelContainer(
              null,
              _secondTextEditingController,
              hintLabel: 'http://www.myrulesandguidelines.com',
                didUpdateLabel: (e) {
              setState(() {

                context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleCheckBoxRuleChanged(CheckBoxRuleOption(
                      selectableLink: e,
                      labelForRequirement: context.read<CustomRuleFormBloc>().state.customRuleOption.checkBoxRuleOption?.labelForRequirement ?? StringBoolItem(
                          stringItem: context.read<CustomRuleFormBloc>().state.customRuleOption.checkBoxRuleOption?.labelForRequirement.stringItem ?? '',
                          boolItem: false
                      )
                    )
                  )
                );
              });
            }),

            const SizedBox(height: 10),

          ],
        );
      default:
       return Container();
    }
  }


  bool isAllowedToSave(CustomRuleOption ruleOption) {
    switch (ruleOption.customRuleType) {
      case CustomRuleObjectType.textFieldRule:
        return _firstTextEditingController.text != '';
      case CustomRuleObjectType.singleSelectionRule:
        return _firstTextEditingController.text != '' && (ruleOption.selectionLabelOption?.selectionLabelOptions.where((element) => element.stringItem != '').isNotEmpty ?? false);
      case CustomRuleObjectType.multiSelectionRule:
        return _firstTextEditingController.text != '' && (ruleOption.selectionLabelOption?.selectionLabelOptions.where((element) => element.stringItem != '').isNotEmpty ?? false);
      case CustomRuleObjectType.numberLimitRule:
        return _firstTextEditingController.text != '';
      case CustomRuleObjectType.checkBoxRule:
        return _firstTextEditingController.text != '';
      default:
        return false;
    }
  }

  Widget helperOptionsDetail(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: labelContainer(
                  null,
                  _eighthTextEditingController,
                  hintLabel: 'Helper Label',
                  didUpdateLabel: (e) {
                    setState(() {
                      context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleDetailsChanged(CustomRuleOptionDetail(
                          labelHelpText: e,
                          isAdminVisibilityOnly: context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.isAdminVisibilityOnly,
                          isRequiredOption: context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.isRequiredOption)));
                    });
                  }),
            ),
          ],
        ),
        SizedBox(height: 25),
        RadioListTile(
          toggleable: true,
          value: 'Required',
          groupValue: (context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.isRequiredOption ?? false) ? 'Required' : null,
          onChanged: (String? value) {

            setState(() {
              if (context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.isRequiredOption ?? false) {

                context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleDetailsChanged(CustomRuleOptionDetail(
                      labelHelpText: context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.labelHelpText,
                      isAdminVisibilityOnly: context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.isAdminVisibilityOnly,
                      isRequiredOption: false)));
              } else {
                context.read<CustomRuleFormBloc>()..add(CustomRuleFormEvent.customRuleDetailsChanged(CustomRuleOptionDetail(
                    labelHelpText: context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.labelHelpText,
                    isAdminVisibilityOnly: context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleOptionDetail?.isAdminVisibilityOnly,
                    isRequiredOption: true)));

              }
            });
          },
          title: Text('Make This a Required Check-Box Rule', style: TextStyle(
            color: widget.model.disabledTextColor,
            ),
          ),
          activeColor: widget.model.paletteColor,
        ),
      ],
    );
  }

  Widget numberLabelContainer({required Function(String) didUpdateLabel, required String hintLabel,}) {
    return TextFormField(

      style: TextStyle(color: widget.model.paletteColor),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintStyle: TextStyle(color: widget.model.disabledTextColor),
        hintText: hintLabel,
        errorStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: widget.model.paletteColor,
        ),
        // prefixIcon: Icon(Icons.home_outlined, color: widget.model.disabledTextColor),
        // labelText: "Email",
        filled: true,
        fillColor: widget.model.accentColor,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            width: 2,
            color: widget.model.paletteColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: widget.model.paletteColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: widget.model.disabledTextColor,
            width: 0,
          ),
        ),
      ),
      autocorrect: false,
      onChanged: (value) {
        didUpdateLabel(value);
      },
      onEditingComplete: () {
        setState(() {
        });
      },
    );
  }

  Widget labelContainer(int? numberOfLines, TextEditingController controller, {required Function(String) didUpdateLabel, required String hintLabel}) {
    return TextFormField(
      controller: controller,
      maxLines: numberOfLines,
      style: TextStyle(color: widget.model.paletteColor),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: widget.model.disabledTextColor),
        hintText: hintLabel,
        errorStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: widget.model.paletteColor,
        ),
        // prefixIcon: Icon(Icons.home_outlined, color: widget.model.disabledTextColor),
        // labelText: "Email",
        filled: true,
        fillColor: widget.model.accentColor,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            width: 2,
            color: widget.model.paletteColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: widget.model.paletteColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            width: 0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: widget.model.disabledTextColor,
            width: 0,
          ),
        ),
      ),
      autocorrect: false,
      onChanged: (value) {
        didUpdateLabel(value);
      },
      onEditingComplete: () {
        setState(() {
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double widthForFrame = 500;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
        title: Text('Create A New Custom Rule That will Be Applied to All Reservations'),
        toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Column(
            children: [
              SizedBox(height: 30),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.cancel_outlined, color: widget.model.paletteColor, size: 40),
                padding: EdgeInsets.all(1),
              ),
            ],
          ),
          SizedBox(width: 40)
        ],
      ),
      body: BlocProvider(create: (context) => getIt<CustomRuleFormBloc>()..add(CustomRuleFormEvent.initialCustomRule(dart.optionOf(widget.currentCustomRuleOption))),
        child: BlocConsumer<CustomRuleFormBloc, CustomRuleFormState>(
        listener: (context, state) {

        },
        buildWhen: (p,c) => p.customRuleOption != c.customRuleOption,
        builder: (context, state) {
          return Container(
            width: 600,
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Custom Rule Type', style: TextStyle(
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                      color: widget.model.disabledTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                                  color: widget.model.accentColor,
                                  border: Border.all(color: widget.model.disabledTextColor),
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text((state.customRuleOption.customRuleType != null) ? getCustomRuleTitle(state.customRuleOption.customRuleType ?? CustomRuleObjectType.singleSelectionRule) : 'Select A Rule', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.normal),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.keyboard_arrow_down_rounded, color: widget.model.paletteColor),
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
                              //       )
                              //     ],
                              //   color: widget.model.accentColor,
                              //   border: Border.all(color: widget.model.disabledTextColor),
                              //   borderRadius: BorderRadius.circular(20)),
                              // itemHeight: 50,
                              // // dropdownWidth: mainWidth,
                              // focusColor: Colors.grey.shade100,
                              items: CustomRuleObjectType.values.map(
                                      (e) {
                                    return DropdownMenuItem<CustomRuleObjectType>(
                                        onTap: () {

                                          setState(() {
                                            _firstTextEditingController.text = '';
                                            _secondTextEditingController.text = '';
                                            _thirdTextEditingController.text = '';
                                            _fourthTextEditingController.text = '';
                                            _fifthTextEditingController.text = '';
                                            _sixTextEditingController.text = '';
                                            _sevenTextEditingController.text = '';
                                            _eighthTextEditingController.text = '';

                                            context.read<CustomRuleFormBloc>().add(CustomRuleFormEvent.customRuleTypeChanged(e));

                                          });
                                        },
                                        value: e,
                                        child: Text(getCustomRuleTitle(e), style: TextStyle(color: widget.model.disabledTextColor))
                                    );
                                  }
                          ).toList()
                        )
                      ),
                    ),

                    SizedBox(height: 25),
                    Visibility(
                        visible: (context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleType != null),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mainContainerForCustomType(context, context.read<CustomRuleFormBloc>().state.customRuleOption),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _showMoreOptions = !_showMoreOptions;
                                });
                              },
                              child: Text('show more options', style: TextStyle(color: widget.model.paletteColor)),
                            ),
                            SizedBox(height: 10),
                            if (_showMoreOptions) helperOptionsDetail(context),
                            SizedBox(height: 20),

                            Text('Preview Your Custom Rule', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                            SizedBox(height: 10),
                            Text(getCustomRuleTitle(context.read<CustomRuleFormBloc>().state.customRuleOption.customRuleType ?? CustomRuleObjectType.numberLimitRule), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                            SizedBox(height: 5),
                            widgetForCustomRule(
                                context,
                                widget.model,
                                context.read<CustomRuleFormBloc>().state.customRuleOption,
                                didUpdateCustomRule: (selection) {  },
                            ),
                          ],
                        )
                    ),


                    SizedBox(height: 25),
                    Container(
                      height: 60,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected) &&
                                    states.contains(MaterialState.pressed) &&
                                    states.contains(MaterialState.focused)) {
                                  return widget.model.paletteColor.withOpacity(0.1);
                                }
                                if (states.contains(MaterialState.hovered)) {
                                  return widget.model.webBackgroundColor.withOpacity(
                                      0.95);
                                }
                                return widget.model.webBackgroundColor;
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                          onPressed: () {

                            if (isAllowedToSave(state.customRuleOption)) {
                              widget.didSaveCustomRule(state.customRuleOption);
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Save Changes', style: TextStyle(color: isAllowedToSave(state.customRuleOption) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                          )
                      ),
                    ),
                    SizedBox(height: 50),
                    ]
                  ),
                )
              )
            );
          }
        )
      )
    );
  }
}