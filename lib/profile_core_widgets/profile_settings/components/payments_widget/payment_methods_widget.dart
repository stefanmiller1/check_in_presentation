part of check_in_presentation;



class PaymentMethodsWidget extends StatefulWidget {

  final bool isPushedView;
  final Function() didSaveSuccess;
  final Function(CardItem?) didSelectPaymentMethod;
  // final UserProfileModel profile;
  final DashboardModel model;

  const PaymentMethodsWidget({super.key, required this.model, required this.isPushedView, required this.didSelectPaymentMethod, required this.didSaveSuccess});

  @override
  State<PaymentMethodsWidget> createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {

  late bool isComplete = false;
  CardItem? _selectedCard;
  late bool isSavingAsDefault = false;
  late List<String> cancellations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadUserProfileSuccess: (item) {
                return getCurrentUsersPaymentMethods(item.profile);
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }

  @override
  Widget getCurrentUsersPaymentMethods(UserProfileModel profile) {
    return BlocProvider(create: (_) => getIt<StripePaymentWatcherBloc>()..add(StripePaymentWatcherEvent.watchAllPaymentMethods(profile.stripeCustomerId ?? '')),
        child: BlocBuilder<StripePaymentWatcherBloc, StripePaymentWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadInProgress: (_) => (widget.isPushedView) ? Scaffold(
                resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                    elevation: 0,
                    title: Text('Payment Methods'),
                    iconTheme: IconThemeData(
                        color: widget.model.paletteColor
                    ),
                  ),
                  body: Center(child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor))
                ) : Container(),
          loadAllPaymentMethodsFailure: (_) => updatePaymentMethodSettings(context, [], profile),
          loadAllPaymentMethodsSuccess: (items) => updatePaymentMethodSettings(context, items.cards, profile),
          orElse: () => updatePaymentMethodSettings(context, [], profile));
        },
      ),
    );
  }

  Widget updatePaymentMethodSettings(BuildContext context, List<CardItem> cards, UserProfileModel profile) {
    return BlocProvider(create: (context) => getIt<PaymentServicesBloc>()..add(PaymentServicesEvent.initializePaymentService(dart.optionOf(profile))),
      child: BlocConsumer<PaymentServicesBloc, PaymentServicesState>(
        listenWhen: (p,c) => p.isSaving != c.isSaving,
        listener: (context, state) {
            state.defaultPaymentFailureOrSuccessOption.fold(
                    () => {},
                    (either) => either.fold(
                      (failure) {
                        final snackBar = SnackBar(
                                elevation: 4,
                                backgroundColor: widget.model.webBackgroundColor,
                                content: failure.maybeMap(
                                  serverError: (value) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                  orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                )
                            );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                      (_) {
                      final snackBar = SnackBar(
                          elevation: 4,
                          backgroundColor: widget.model.paletteColor,
                          content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                      );
                      if (widget.isPushedView) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        didSelectRefresh();
                    } else {
                        widget.didSaveSuccess();
                  }
                }
              )
            );
            state.failureOrSuccessOption.fold(
                    () => {},
                    (either) => either.fold(
                            (failure) {
                              final snackBar = SnackBar(
                                  elevation: 4,
                                  backgroundColor: widget.model.webBackgroundColor,
                                  content: failure.maybeMap(
                                      paymentServerError: (value) => Text(value.failedValue ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                      orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                                )
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            },
                            (_) {
                        final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (widget.isPushedView) {
                  Navigator.of(context).pop();
                  didSelectRefresh();
                } else {
                  widget.didSaveSuccess();
                }
              }
            )
          );
        },
        buildWhen: (p,c) => p.isSaving != c.isSaving || p.isEditing != c.isEditing || p.cancellationList != c.cancellationList,
        builder: (context, state) {
          return retrievePaymentMethods(context, cards, state, profile);
        },
      ),
    );
  }

  Widget retrievePaymentMethods(BuildContext context, List<CardItem> cards, PaymentServicesState state, UserProfileModel profile) {
    return (widget.isPushedView) ? Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: !state.isSaving,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Payment Methods'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCard = null;
                  });
                  context.read<PaymentServicesBloc>().add(PaymentServicesEvent.editBoolDidChange(!state.isEditing));

                },
                child: Text('Edit', style: TextStyle(color: (state.isEditing) ? widget.model.disabledTextColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, decoration: TextDecoration.underline)),
              ),
            ),
          )
        ],
      ),
      body: mainContainer(context, cards, state, profile)
    ) : mainContainer(context, cards, state, profile);
  }

  Widget mainContainer(BuildContext context, List<CardItem> cards, PaymentServicesState state, UserProfileModel profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          if (cards.isNotEmpty) Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Payment Methods',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: widget.model.disabledTextColor,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              ...cards.asMap().map(
                      (i, e) => MapEntry(i, getPaymentItemWidget(
                      context,
                      widget.model,
                      e,
                      _selectedCard?.paymentId == e.paymentId,
                      state.isEditing,
                      !cards.map((e) => e.paymentId).contains(profile.defaultPaymentMethod) ? i == cards.length - 1 : profile.defaultPaymentMethod == e.paymentId,
                      isSavingAsDefault,
                      true,
                      cancellations.contains(e.paymentId),
                      selectedCard: (card) {
                        setState(() {
                          isSavingAsDefault = false;
                          if (_selectedCard != card && !state.isEditing) {
                            _selectedCard = card;
                          } else {
                            _selectedCard = null;
                          }
                          widget.didSelectPaymentMethod(_selectedCard);
                        });
                      },
                      selectedSetDefault: (selected) {
                        setState(() {
                          isSavingAsDefault = !isSavingAsDefault;
                        });
                      },
                      saveNewDefault: (cardItem) {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didChangeDefaultPayment(cardItem.paymentId));
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewDefaultPaymentMethod());
                      },
                      selectedRemove: (cardItem) {

                        cancellations.addAll(state.cancellationList ?? []);
                        setState(() {
                          if (!(cancellations.contains(cardItem.paymentId))) {
                            cancellations.add(cardItem.paymentId);
                          } else {
                            cancellations.remove(cardItem.paymentId);
                          }
                        });
                      }
                    ),
                  )
              ).values.toList(),
              const SizedBox(height: 15),
              Divider(color: widget.model.disabledTextColor),
              const SizedBox(height: 15),
            ],
          ),
          if (state.isSaving) JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
          if (!state.isSaving) InkWell(
            onTap: () {
              if (kIsWeb) {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierLabel: 'Profile',
                  transitionDuration: Duration(milliseconds: 350),
                  pageBuilder: (BuildContext contexts, anim1, anim2) {
                    return  Align(
                        alignment: Alignment.center,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: widget.model.accentColor,
                                    borderRadius: BorderRadius.all(Radius.circular(17.5))
                                ),
                                width: 550,
                                height: 430,
                                child: NewPaymentMethodWidget(
                                  profile: profile,
                                  model: widget.model,
                                  didSaveNewPaymentMethod: (cardToken) {
                                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didUpdateNewPaymentMethod(cardToken));
                                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewPaymentMethod());
                                    // Navigator.of(contexts).pop();
                                  },
                                )
                            )
                        )
                    );
                  },
                  transitionBuilder: (context, anim1, anim2, child) {
                    return Transform.scale(
                        scale: anim1.value,
                        child: Opacity(
                            opacity: anim1.value,
                            child: child
                        )
                    );
                  },
                );
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (contexts) {
                      return NewPaymentMethodWidget(
                        profile: profile,
                        model: widget.model,
                        didSaveNewPaymentMethod: (cardToken) {
                          context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didUpdateNewPaymentMethod(cardToken));
                          context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewPaymentMethod());
                          Navigator.of(contexts).pop();
                        },
                      );
                    })
                );
              }
            },
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: widget.model.paletteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(child: Text('New Payment Method', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
            ),
          ),
          const SizedBox(height: 15),
          if (!state.isSaving && cancellations.isNotEmpty) InkWell(
            onTap: () {

              context.read<PaymentServicesBloc>().add(PaymentServicesEvent.didDChangePaymentsToDelete(cancellations));
              context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedDeleteSelectedPayments());

            },
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: widget.model.paletteColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(child: Text('Delete Selected', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
            ),
          )
        ],
      ),
    );
  }
}