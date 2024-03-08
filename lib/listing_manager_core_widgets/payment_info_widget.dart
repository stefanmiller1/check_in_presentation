part of check_in_presentation;

class PaymentsSettingWidget extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel userProfile;
  final String currentCurrency;
  final bool showCurrency;
  final String paymentRequirementTitle;
  final Function() didSelectPaymentButton;
  final Function() didSelectPresentStripeAccountDashboard;
  final Function(Locale) didSelectCurrencyOption;

  const PaymentsSettingWidget({Key? key,
    required this.model,
    required this.userProfile,
    required this.paymentRequirementTitle,
    required this.didSelectPaymentButton,
    required this.showCurrency,
    required this.didSelectCurrencyOption,
    required this.currentCurrency,
    required this.didSelectPresentStripeAccountDashboard}) : super(key: key);

  @override
  State<PaymentsSettingWidget> createState() => _PaymentsSettingWidgetState();
}

class _PaymentsSettingWidgetState extends State<PaymentsSettingWidget> {

  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        width: 675,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Setup Your ${widget.paymentRequirementTitle} Payments', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),

              SizedBox(height: 25),
              Visibility(
                visible: widget.userProfile.stripeAccountDetailsSubmitted ?? false,
                child: Container(
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
                              return widget.model.accentColor.withOpacity(0.95);
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
                        setState(() {
                          widget.didSelectPresentStripeAccountDashboard();
                        });
                      },
                      child: Text('My Stripe Account', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize),)
                  ),
                ),
              ),
              Visibility(
                visible: (!(widget.userProfile.stripeAccountDetailsSubmitted ?? false)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("We Require Payments be setup Before a ${widget.paymentRequirementTitle} can be payed for.",
                      style: TextStyle(
                        color: widget.model.disabledTextColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
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
                                  return widget.model.paletteColor.withOpacity(0.95);
                                }
                                return widget.model.paletteColor;
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              widget.didSelectPaymentButton();
                            });
                          },
                          child: (widget.userProfile.stripeAccountId != null) ? Text('Finish Setting Up Payment Account to Receive Payments', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)) : Text('Create Payment Account For Receiving Payments', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize),)
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              /// *** currency *** ///

              if (widget.showCurrency) Container(
                width: 675,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25),
                    Text('Currency', style: TextStyle(
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                      color: widget.model.disabledTextColor,
                    ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonHideUnderline(
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
                                      child: Text('${NumberFormat.simpleCurrency(locale: widget.currentCurrency).currencyName} (${NumberFormat.simpleCurrency(locale: widget.currentCurrency).currencySymbol})', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.normal),),
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
                            //     )
                            //     ],
                            //     color: widget.model.accentColor,
                            //     border: Border.all(color: widget.model.disabledTextColor),
                            //     borderRadius: BorderRadius.circular(20)),
                            // itemHeight: 50,
                            // // dropdownWidth: mainWidth,
                            // focusColor: Colors.grey.shade100,
                            items: numberFormatSymbols.keys
                                .map((key)=> key.toString().split('_'))
                                .map((split)=>Locale(split[0],split.length == 1 ? null:split[1]))
                                .toList().map(
                                    (e) {

                                  return DropdownMenuItem<Locale>(
                                      onTap: () {
                                        setState(() {
                                          widget.didSelectCurrencyOption(e);
                                        });
                                      },
                                      value: e,
                                      child: Text('${NumberFormat.simpleCurrency(locale: e.toString()).currencyName} (${NumberFormat.simpleCurrency(locale: e.toString()).currencySymbol})', style: TextStyle(color: widget.model.disabledTextColor))
                                  );
                                }
                            ).toList()
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}