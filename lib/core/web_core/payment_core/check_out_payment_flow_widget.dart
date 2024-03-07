part of check_in_presentation;

/// pop-over web widget for check-out payment workflow
class WebCheckOutPaymentWidget extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel ownerUser;
  final UserProfileModel currentUser;
  final String amount;
  final String currency;
  final String description;
  final ReservationItem reservation;
  final Function(String paymentId) didFinishPayment;
  final Function() didPressFinished;

  const WebCheckOutPaymentWidget({super.key, required this.model, required this.currentUser, required this.ownerUser, required this.reservation, required this.amount, required this.currency, required this.description, required this.didFinishPayment, required this.didPressFinished});

  @override
  State<WebCheckOutPaymentWidget> createState() => _WebCheckOutPaymentWidgetState();
}

class _WebCheckOutPaymentWidgetState extends State<WebCheckOutPaymentWidget> {

  CheckOutPaymentMarker _currentMainContainer = CheckOutPaymentMarker.selectFromPaymentMethod;
  late CardItem? cardItem = null;
  late bool _showProcessedPayment = false;
  late bool _showFinishedButton = false;


  Widget getMainContainer(
      BuildContext context,
      CheckOutServicesState state,
      CheckOutPaymentMarker marker,
      List<CardItem> cardItems,
      ) {
    switch (marker) {
      case CheckOutPaymentMarker.selectFromPaymentMethod:
        if (cardItems.isEmpty) {
          return getPaymentMethodToAdd(state);
        } else {
        return retrievePaymentHistoryList(
            context,
            widget.model,
            cardItems,
            cardItem ?? CardItem.empty(),
            selectedCard: (card) {
              setState(() {
                if (cardItem != null) {
                  cardItem = null;
                } else {
                  cardItem = card;
                }
              });
            },
            selectedNew: () {
                setState(() {
                  _currentMainContainer = CheckOutPaymentMarker.addPaymentMethod;
                  context.read<CheckOutServicesBloc>().add(CheckOutServicesEvent.createPaymentIntent(
                      widget.currentUser,
                      widget.amount,
                      widget.currency,
                      widget.description,
                      null,

                  )
                );
              });
            }
          );
        }
      case CheckOutPaymentMarker.addPaymentMethod:
        return getPaymentMethodToAdd(state);
      case CheckOutPaymentMarker.processPayment:
        return state.authPaymentFailureOrSuccessOption.fold(
            () => Container(
                height: 600,
                width: 600,
                child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)),
            (a) => a.fold(
                    (failure) => getPaymentProcessingWidget(
                        context,
                        widget.model,
                        failure,
                        didTapConfirm: (paymentIntent) {
                          setState(() {
                            context.read<CheckOutServicesBloc>().add(CheckOutServicesEvent.confirmPaymentIntent(paymentIntent));
                            _currentMainContainer = CheckOutPaymentMarker.finishedPayment;
                   });
                 }
               ),
            (r) => successResult(context, widget.model, _showFinishedButton, didPressFinished: widget.didPressFinished)
          )
        );
      case CheckOutPaymentMarker.finishedPayment:
        return successResult(context, widget.model, _showFinishedButton, didPressFinished: widget.didPressFinished);
      case CheckOutPaymentMarker.failedPayment:
        return errorResult('Payment Did Not Go Through', widget.model);
    }
  }

  Widget getPaymentMethodToAdd(CheckOutServicesState state) {
    return state.authPaymentFailureOrSuccessOption.fold(
          () => Container(
          height: 600,
          width: 600,
          child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)),
          (a) => a.fold(
              (l) => Container(child: Text('Failed To Load Checkout Form ${l.toString()}')),
              (r) => Container(
              height: 600,
              width: 600,
              child:  EmbeddedStripeCheckoutForm(
                client_secret: r.stringItemOne,
                didCompleteCheckout: () {
                  if (mounted) {
                    setState(() {
                      _currentMainContainer = CheckOutPaymentMarker.finishedPayment;
                    });

                    widget.didFinishPayment(r.stringItemTwo);
                  // setState(() {
                    // _currentMainContainer = CheckOutPaymentMarker.finishedPayment;
                    // widget.didFinishPayment(r.stringItemTwo);
                // },
              // );
              }
            },
            didNotCompleteSuccessfully: () {
              if (mounted) {
                setState(() {
                  _currentMainContainer = CheckOutPaymentMarker.failedPayment;
                });
              }
            },
          )
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<StripePaymentWatcherBloc>()..add(StripePaymentWatcherEvent.watchAllPaymentMethods(widget.currentUser.stripeCustomerId ?? '')),
      child: BlocBuilder<StripePaymentWatcherBloc, StripePaymentWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadAllPaymentMethodsFailure: (_) => retrieveCheckOutContainer([]),
              loadAllPaymentMethodsSuccess: (items) => retrieveCheckOutContainer(items.cards),
              orElse: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3));
        },
      )
    );
  }

  Widget retrieveCheckOutContainer(List<CardItem> paymentMethods) {
     return BlocProvider(create: (_) => getIt<CheckOutServicesBloc>()..add(CheckOutServicesEvent.initializeCheckOutService(
           dart.optionOf(widget.ownerUser),
           dart.optionOf(widget.reservation),
           paymentMethods.isEmpty,
           widget.amount,
           widget.currency,
           widget.description,
           widget.currentUser,
         )
        ),
        child: BlocConsumer<CheckOutServicesBloc, CheckOutServicesState>(
         listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.authPaymentFailureOrSuccessOption != c.authPaymentFailureOrSuccessOption || p.authPaymentConfirmationFailureOrSuccessOption != c.authPaymentConfirmationFailureOrSuccessOption,
         listener: (context, state) {

         state.authPaymentFailureOrSuccessOption.fold(
               () => {},
             (either) => either.fold((failure) {
               print('failed');
              },
             (r) {
               _showFinishedButton = true;
            })
         );

         state.authPaymentConfirmationFailureOrSuccessOption.fold(
                 () => {},
                 (either) => either.fold((failure) {
                      final snackBar = SnackBar(
                        backgroundColor: widget.model.webBackgroundColor,
                        content: failure.maybeMap(
                          requiresMoreAction: (_) => Text('One more thing...', style: TextStyle(color: widget.model.disabledTextColor)),
                          couldNotRetrievePaymentMethod: (_) => Text('Could not retrieve payment details', style: TextStyle(color: widget.model.disabledTextColor)),
                          paymentServerError: (e) => Text(e.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                          ownerDoesNotHaveAccount: (_) => Text('${widget.ownerUser.legalName.getOrCrash()} is unable to accept payments. Please Contact Owner', style: TextStyle(color: widget.model.disabledTextColor)),
                          orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                )
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
           }, (r) {
              /// payment completed successfully
              _showProcessedPayment = true;
              widget.didFinishPayment(r.stringItemTwo);
              _showFinishedButton = true;

           })
         );

       },
       buildWhen: (p, c) => p.isSubmitting != c.isSubmitting || p.authPaymentFailureOrSuccessOption != c.authPaymentFailureOrSuccessOption || p.authPaymentConfirmationFailureOrSuccessOption != c.authPaymentConfirmationFailureOrSuccessOption,
       builder: (context, state) {
         return Center(
            child: Stack(
              children: [
                Container(
                  color: Colors.transparent,
                  width: 600,
                  height: MediaQuery.of(context).size.height,
                ),

                Container(
                  child: headerNavWidget(
                    context,
                    widget.model,
                    _currentMainContainer,
                  ),
                ),

                CreateNewMain(
                  child: Column(
                    children: [
                      const SizedBox(height: 65),
                        Row(
                          children: [
                            Flexible(
                                child: Container(
                                    constraints: const BoxConstraints(maxWidth: 600),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: getMainContainer(
                                                  context,
                                                  state,
                                                  _currentMainContainer,
                                                  paymentMethods
                                )
                              )
                            )
                          )
                        ]
                      )
                    ]
                  )
                ),

                Positioned(
                  bottom: 0,
                  child: Row(
                   children: [
                      bottomNavWidget(
                             context,
                             widget.model,
                             isNextValid(_currentMainContainer, cardItem, _showProcessedPayment),
                             _currentMainContainer != CheckOutPaymentMarker.finishedPayment,
                             _currentMainContainer,
                             didSelectBack: () {
                               setState(() {
                                 switch (_currentMainContainer) {
                                   case CheckOutPaymentMarker.selectFromPaymentMethod:
                                     Navigator.of(context).pop();
                                     break;
                                   case CheckOutPaymentMarker.addPaymentMethod:
                                    _currentMainContainer = CheckOutPaymentMarker.selectFromPaymentMethod;
                                    break;
                                   case CheckOutPaymentMarker.processPayment:
                                    _currentMainContainer = CheckOutPaymentMarker.addPaymentMethod;
                                    break;
                                   case CheckOutPaymentMarker.finishedPayment:
                                     break;
                                   case CheckOutPaymentMarker.failedPayment:
                                     Navigator.of(context).pop();
                                     break;
                                 }
                               });
                             },
                             didSelectNext: () {
                               setState(() {
                                 switch (_currentMainContainer) {
                                   case CheckOutPaymentMarker.selectFromPaymentMethod:
                                     _currentMainContainer = CheckOutPaymentMarker.addPaymentMethod;

                                     if (cardItem != null) {
                                       _currentMainContainer = CheckOutPaymentMarker.processPayment;
                                       context.read<CheckOutServicesBloc>().add(CheckOutServicesEvent.createPaymentIntent(
                                         widget.currentUser,
                                         widget.amount,
                                         widget.currency,
                                         widget.description,
                                         cardItem?.paymentId,
                                       ));
                                     }
                                     break;
                                   case CheckOutPaymentMarker.addPaymentMethod:
                                     _currentMainContainer = CheckOutPaymentMarker.processPayment;
                                     break;
                                   case CheckOutPaymentMarker.processPayment:
                                     _currentMainContainer = CheckOutPaymentMarker.finishedPayment;
                                     break;
                                   case CheckOutPaymentMarker.finishedPayment:
                                     Navigator.of(context).pop();
                                     break;
                             }
                          });
                        }
                      )
                    ]
                  )
                ),
              ],
            )
          );
        }
      )
    );
  }
}