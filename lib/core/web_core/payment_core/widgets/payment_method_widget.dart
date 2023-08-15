part of check_in_presentation;

Widget getPaymentItemWidget(
    BuildContext context,
    DashboardModel model,
    CardItem e,
    bool selected,
    bool isEditing,
    bool isDefault,
    bool isSavingAsDefault,
    bool showRemove,
    bool removeIsSelected, {required Function(CardItem) selectedCard, required Function(bool) selectedSetDefault, required Function(CardItem) saveNewDefault, required Function(CardItem) selectedRemove}) {

  return Row(
    children: [
      Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    color: model.accentColor,
                    border: Border.all(color: (selected) ? model.paletteColor : Colors.transparent),
                    borderRadius: BorderRadius.all(Radius.circular(12)
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
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
                            return model.accentColor; // Use the component's default.
                          },
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                            )
                        )
                    ),
                    onPressed: () {
                      selectedCard(e);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(children: [
                              SvgPicture.asset(getCardIconItem().where((element) => element.contains(e.cardDetails.brand)).isNotEmpty ? getCardIconItem().where((element) => element.contains(e.cardDetails.brand)).first : 'assets/payment_icons/discover.svg', fit: BoxFit.fitHeight, color: model.paletteColor, height: 25),
                              const SizedBox(width: 25),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('**** ${e.cardDetails.lastFourNumbers}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize, color: (selected) ? model.paletteColor : model.disabledTextColor), maxLines: 1),
                                    Text('Expires ${DateFormat('MMM').format(DateTime(0, e.cardDetails.expMonth))}. ${e.cardDetails.expiryYearDate}', style: TextStyle(fontWeight: FontWeight.bold, color: (selected) ? model.paletteColor : model.disabledTextColor), maxLines: 1),
                                  ],
                                ),
                              )
                            ],
                            ),
                          ),
                          if (isDefault) Container(
                              decoration: BoxDecoration(
                                color: model.paletteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text('Default', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold))))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (showRemove) AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: (selected && !isDefault) ? 60 : 0,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Set this card as your default'),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: model.accentColor,
                          activeColor: model.paletteColor,
                          value: isSavingAsDefault,
                          onToggle: (bool value) {
                            selectedSetDefault(value);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (selected && showRemove) InkWell(
              onTap: () {
                saveNewDefault(e);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: (isSavingAsDefault) ? 55 : 0,
                decoration: BoxDecoration(
                  color: model.paletteColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                    child: Text('Set As Default', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold))
                ),
              ),
            ),

            const SizedBox(height: 10),

          ],
        ),
      ),
      if (isEditing) const SizedBox(width: 15),
      if (showRemove) InkWell(
        onTap: () {
          selectedRemove(e);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 35,
          width: (isEditing) ? 80 : 0,
          decoration: BoxDecoration(
            color: (removeIsSelected) ? model.paletteColor : Colors.transparent,
            border: Border.all(color: model.paletteColor),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Center(child: Text('Remove', style: TextStyle(color: (removeIsSelected) ? model.accentColor : model.paletteColor))))
        )
      )
    ]
  );
}


Widget getPaymentHistoryOnly(BuildContext context, DashboardModel model, PaymentIntent paymentIntent, {required Function(PaymentIntent) didSelectPayment}) {
  return Container(

  );
}


Widget labelContainerForPricing(DashboardModel model, int? numberOfLines, TextEditingController controller, {required Function(String) didUpdateLabel, required String hintLabel}) {
  return TextField(
    controller: controller,
    maxLines: numberOfLines,
    style: TextStyle(color: model.paletteColor),
    // keyboardType: const TextInputType.numberWithOptions(decimal: true),
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      // FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
    ],
    decoration: InputDecoration(
      hintStyle: TextStyle(color: model.disabledTextColor),
      hintText: hintLabel,
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: model.paletteColor,
      ),
      // prefixIcon: Icon(Icons.home_outlined, color: widget.model.disabledTextColor),
      // labelText: "Email",
      filled: true,
      fillColor: model.accentColor,
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          width: 2,
          color: model.paletteColor,
        ),
      ),
      focusedBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.paletteColor,
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
          color: model.disabledTextColor,
          width: 0,
        ),
      ),
    ),
    autocorrect: false,
    onChanged: (value) {
      didUpdateLabel(value);
    },
  );
}

class ThousandsDividerInputFormatter extends TextInputFormatter {
  final int numberDivider;

  ThousandsDividerInputFormatter(this.numberDivider);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int oldValueLength = oldValue.text.length;
    final int newValueLength = newValue.text.length;

    if (newValueLength > oldValueLength) {
      // User is typing a character
      final int selectionIndex = newValue.selection.end;

      String newString = newValue.text.replaceAll(',', '');
      final double parsedValue = double.tryParse(newString) ?? 0;
      final double dividedValue = parsedValue / numberDivider;

      final List<String> parts = dividedValue.toStringAsFixed(3).split('.');
      final String wholePart = parts[0];
      final String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      newString = '$wholePart$decimalPart';

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: selectionIndex + (newString.length - newValueLength),
        ),
      );
    } else if (newValueLength < oldValueLength) {
      // User is deleting a character
      final int selectionIndex = newValue.selection.end;

      String newString = newValue.text.replaceAll(',', '');
      final double parsedValue = double.tryParse(newString) ?? 0;
      final double dividedValue = parsedValue / numberDivider;

      final List<String> parts = dividedValue.toStringAsFixed(3).split('.');
      final String wholePart = parts[0];
      final String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

      newString = '$wholePart$decimalPart';

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: selectionIndex + (newString.length - newValueLength),
        ),
      );
    }

    return newValue;
  }
}