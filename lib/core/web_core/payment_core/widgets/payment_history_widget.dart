part of check_in_presentation;

Widget retrievePaymentHistoryList(BuildContext context, DashboardModel model, List<CardItem> cards, CardItem selectedCardItem, {required Function(CardItem) selectedCard, required Function() selectedNew}) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 15),
      ...cards.map(
              (e) => getPaymentItemWidget(
            context,
            model,
            e,
            e.paymentId == selectedCardItem.paymentId,
            false,
            false,
            false,
            false,
            false,
            selectedCard: (CardItem card) {
              selectedCard(card);
            },
            selectedSetDefault: (bool ) {  },
            saveNewDefault: (CardItem ) {  },
            selectedRemove: (CardItem ) {  },
          )
      ).toList(),
      SizedBox(
        height: 10,
      ),
      Container(
        height: 60,
        width: 550,
        child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected) &&
                      states.contains(MaterialState.pressed) &&
                      states.contains(MaterialState.focused)) {
                    return model.paletteColor.withOpacity(0.1);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return model.webBackgroundColor.withOpacity(0.95);
                  }
                  return model.webBackgroundColor;
                },
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                ),
              ),
            ),
            onPressed: () {
              selectedNew();
            },
            child: Text('Create a New Payment Method', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize),)
        ),
      )

    ],
  );
}