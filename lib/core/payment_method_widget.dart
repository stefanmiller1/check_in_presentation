part of check_in_presentation;

Widget getPaymentItemWidget(BuildContext context, DashboardModel model, CardItem e, bool selected, bool isEditing, bool isDefault, bool isSavingAsDefault, bool removeIsSelected, {required Function(CardItem) selectedCard, required Function(bool) selectedSetDefault, required Function(CardItem) saveNewDefault, required Function(CardItem) selectedRemove}) {

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

            AnimatedContainer(
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

            if (selected) InkWell(
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
      InkWell(
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
