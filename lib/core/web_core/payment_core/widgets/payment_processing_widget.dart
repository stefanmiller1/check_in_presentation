part of check_in_presentation;

Widget getPaymentProcessingWidget(BuildContext context, DashboardModel model, PaymentMethodValueFailure failure, {required Function(String paymentIntent) didTapConfirm}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const SizedBox(height: 15),
      Container(
        width: 600,
        child: failure.maybeMap(
            requiresMoreAction: (e) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lottie.Lottie.asset(
                    height: 200,
                    'assets/lottie_animations/animation_lkjyr3j5.zip'),
                const SizedBox(height: 15),
                Text('To Finish Up, Please Confirm Your Payment', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    didTapConfirm(e.paymentIntent ?? '');
                  },
                  child: Container(
                    height: 60,
                    width: 400,
                    decoration: BoxDecoration(
                      color: model.paletteColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      child: Text('Confirm and Finish', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)))
                    ),
                  ),
                )
              ],
            ),
            paymentServerError: (e) => errorResult(e.failedValue ?? 'Something Went Wrong', model),
            couldNotRetrievePaymentMethod: (e) =>  errorResult('Could Not Retrieve Payment Method', model),
            insufficientFunds: (_) =>  errorResult('Sorry, but we could not complete your Purchase. Please Check Your Balance before trying to purchase again.', model),
            orElse: () =>  errorResult('Oops, Something went wrong', model),
        ),
      )
    ],
  );
}

Widget successResult(BuildContext context, DashboardModel model, bool showFinishButton,{required Function() didPressFinished}) {
  return Column(
    children: [
      lottie.Lottie.asset('assets/lottie_animations/uo8RQ4Hhlc.json'),
      const SizedBox(height: 20),
      Text('You\'re All Set', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 20),
      if (showFinishButton) InkWell(
        onTap: () {
          didPressFinished();
          Navigator.of(context).pop();
        },
        child: Container(
          height: 60,
          width: 400,
          decoration: BoxDecoration(
            color: model.paletteColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text('Finish!', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)
              )
            )
          ),
        ),
      )
    ]
  );
}

Widget errorResult(String errorMessage, DashboardModel model,) {
  return Container(
  width: 600,
  child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        lottie.Lottie.asset('assets/lottie_animations/animation_lkk5o86r.json'),
        const SizedBox(height: 20),
        Text(errorMessage, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ]
    )
  );
}