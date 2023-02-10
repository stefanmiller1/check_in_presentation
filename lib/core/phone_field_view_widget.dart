part of check_in_presentation;

class PhoneFieldView extends StatefulWidget {

  // final Key inputKey;
  final DashboardModel model;
  final PhoneController controller;
  final CountrySelectorNavigator selectorNavigator;
  final Function(PhoneNumber) onChangedPhoneNumber;
  final AutovalidateMode validateMode;
  final String hintText;

  const PhoneFieldView({Key? key, required this.controller,required this.selectorNavigator, required this.model, required this.onChangedPhoneNumber, required this.validateMode, required this.hintText}) : super(key: key);

  @override
  State<PhoneFieldView> createState() => _PhoneFieldViewState();
}

class _PhoneFieldViewState extends State<PhoneFieldView> {

  final inputKey = GlobalKey<FormFieldState<PhoneNumber>>();

  @override
  void initState() {
    super.initState();
  }

  PhoneNumberInputValidator? _getValidator() {
    List<PhoneNumberInputValidator> validators = [];
      // validators.add(PhoneValidator.required());
      validators.add(PhoneValidator.valid());

    return validators.isNotEmpty ? PhoneValidator.compose(validators) : null;
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
        child: PhoneFormField(
          countrySelectorNavigator: widget.selectorNavigator,
          style: TextStyle(color: widget.model.paletteColor),
          key: inputKey,
          controller: widget.controller,
          shouldFormat: true,
          autofillHints: [AutofillHints.telephoneNumber],
          defaultCountry: IsoCode.CA,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: widget.model.disabledTextColor),
            hintText: widget.hintText,
            errorStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: widget.model.paletteColor,
            ),
            // prefixIcon: Icon(Icons.phone_enabled_rounded, color: model.disabledTextColor),
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

          enabled: true,
          showFlagInInput: true,
          validator: _getValidator(),
          onChanged: (p) => widget.onChangedPhoneNumber(p!),
      )
    );
  }
}