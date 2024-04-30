import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../../check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_options/mv_custom_options.dart';

class VendorFormDisclaimerOptionsWidget extends StatefulWidget {

  final DashboardModel model;
  final VendorMerchantForm form;
  final Function(bool value, MVCustomOption option) onChanged;
  final Function(MVCustomOption) oncChangedOptionItem;

  const VendorFormDisclaimerOptionsWidget({super.key, required this.model, required this.onChanged, required this.form, required this.oncChangedOptionItem});

  @override
  State<VendorFormDisclaimerOptionsWidget> createState() => _VendorFormDisclaimerOptionsWidgetState();
}

class _VendorFormDisclaimerOptionsWidgetState extends State<VendorFormDisclaimerOptionsWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          ...predefinedDisclaimers(context).where((element) => element.customRuleOption != null).map(
                  (e) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(e.customRuleOption!.customRuleTitleLabel, style: TextStyle(color: (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    leading: Icon(getIconForCustomOptions(e.customRuleOption!.ruleId.getOrCrash()), color: (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ? widget.model.paletteColor : widget.model.disabledTextColor,),
                    subtitle: (e.customRuleOption!.labelTextRuleOption != null) ? Text(e.customRuleOption!.labelTextRuleOption!.titleLabel, style: TextStyle(color: (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ? widget.model.paletteColor : widget.model.disabledTextColor)) : null,
                    trailing: Container(
                      height: 60,
                      width: 60,
                      child: FlutterSwitch(
                        width: 60,
                        inactiveToggleColor: widget.model.accentColor,
                        inactiveIcon: Icon(Icons.add, color: widget.model.disabledTextColor),
                        inactiveTextColor: widget.model.paletteColor,
                        inactiveColor: widget.model.mobileBackgroundColor,
                        activeColor: widget.model.paletteColor,
                        value: widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true,
                        onToggle: (value) {
                          widget.onChanged(value, e);
                        },
                      ),
                    ),
                  ),

                  if (e.customRuleOption!.checkBoxRuleOption?.isNotEmpty == true && e.customRuleOption?.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-bjhv7iuih8i8')
                    if (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) boolOptionsForForm(
                    context,
                    widget.model,
                    widget.form.disclaimerOptions?.firstWhere((element) => element.customRuleOption?.ruleId == e.customRuleOption?.ruleId).customRuleOption?.checkBoxRuleOption ?? [],
                    didSelectRuleOption: (value, newOption) {

                      late CheckBoxRuleOption newCheckBoxItem = newOption;
                      newCheckBoxItem = newCheckBoxItem.copyWith(
                        labelForRequirement: newCheckBoxItem.labelForRequirement.copyWith(
                          boolItem: value
                        )
                      );

                      late List<CheckBoxRuleOption> checkBoxRules = [];
                      checkBoxRules.addAll(e.customRuleOption?.checkBoxRuleOption ?? []);

                      final index = checkBoxRules.indexWhere((element) => element.labelForRequirement.stringItem == newCheckBoxItem.labelForRequirement.stringItem);
                      checkBoxRules.replaceRange(index, index + 1, [newCheckBoxItem]);

                      late MVCustomOption currentOption = e;
                      currentOption = currentOption.copyWith(
                        customRuleOption: currentOption.customRuleOption?.copyWith(
                            checkBoxRuleOption: checkBoxRules
                        )
                      );

                      widget.oncChangedOptionItem(currentOption);
                    }
                  ),

                  if (e.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-weifunbi938b' && e.customRuleOption!.labelTextRuleOption != null)
                    if (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) textFieldControllerForForm(
                      widget.model,
                      160,
                      3,
                      e.customRuleOption!.labelTextRuleOption!.titleLabel,
                      'more specific furniture..',
                      'What can Vendors expect?',
                      didChangeText: (value) {
                        late MVCustomOption currentOption = e;
                        currentOption = currentOption.copyWith(
                            customRuleOption: currentOption.customRuleOption?.copyWith(
                                labelTextRuleOption: currentOption.customRuleOption?.labelTextRuleOption?.copyWith(
                                  titleLabel: value
                            )
                          )
                        );
                        widget.oncChangedOptionItem(currentOption);
                      }
                  ),

                  if (e.customRuleOption!.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-joijo909jioi' && e.customRuleOption!.labelTextRuleOption != null)
                    if (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) textFieldControllerForForm(
                      widget.model,
                      160,
                      3,
                      e.customRuleOption!.labelTextRuleOption!.titleLabel,
                      'more specific snacks...',
                      'What can Vendors expect?',
                      didChangeText: (value) {
                        late MVCustomOption currentOption = e;
                        currentOption = currentOption.copyWith(
                            customRuleOption: currentOption.customRuleOption?.copyWith(
                                labelTextRuleOption: currentOption.customRuleOption?.labelTextRuleOption?.copyWith(
                                    titleLabel: value
                                )
                            )
                        );
                      widget.oncChangedOptionItem(currentOption);
                    }
                  ),

                  if (e.customRuleOption!.checkBoxRuleOption?.isNotEmpty == true && e.customRuleOption?.ruleId.getOrCrash() != '6e24dae0-96dd-11eb-babc-bjhv7iuih8i8')
                    if (widget.form.disclaimerOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ...e.customRuleOption!.checkBoxRuleOption?.map(
                    (f) => textFieldControllerForForm(
                      widget.model,
                      160,
                      3,
                      f.labelForRequirement.stringItem,
                      'custom instructions..',
                      'Instructions',
                      didChangeText: (value) {
                        late MVCustomOption currentOption = e;
                        currentOption = currentOption.copyWith(
                            customRuleOption: currentOption.customRuleOption?.copyWith(
                                labelTextRuleOption: currentOption.customRuleOption?.labelTextRuleOption?.copyWith(
                                    titleLabel: value
                                )
                            )
                        );
                        widget.oncChangedOptionItem(currentOption);
                      }
                    )
                  ).toList() ?? []

                ],
              )
          ).toList() ?? []
        ],
      ),
    );
  }



}