import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:dartz/dartz.dart' as bloc;


class PayoutAccountLink extends StatefulWidget {

  final DashboardModel model;

  const PayoutAccountLink({super.key, required this.model});

  @override
  State<PayoutAccountLink> createState() => _PayoutAccountLinkState();
}

class _PayoutAccountLinkState extends State<PayoutAccountLink> {

  late PageController? pageController = null;
  late bool isLoading = false;
  int _currentPage = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('Payout Methods'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, authState) {
            return authState.maybeMap(
                loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                loadUserProfileSuccess: (item) {
                  return getCurrentUserPayoutAccountLink(item.profile);
                },
                orElse: () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GetLoginSignUpWidget(
                    showFullScreen: false,
                    model: widget.model,
                    didLoginSuccess: () {

                  },
                ),
              )
            );
          },
        ),
      ),
    );
  }


  Widget getCurrentUserPayoutAccountLink(UserProfileModel profile) {
    return BlocProvider(create: (context) => getIt<PaymentServicesBloc>()..add(PaymentServicesEvent.initializePaymentService(bloc.optionOf(profile))),
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
                          exceptionError: (value) => Text(value.error, style: TextStyle(color: widget.model.paletteColor)),
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
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  }
              )
          );
        },
        buildWhen: (p,c) => p.isSaving != c.isSaving || p.isEditing != c.isEditing || p.cancellationList != c.cancellationList,
        builder: (context, state) {

          List<Widget> setupPayoutsOnBoarding(BuildContext context, UserProfileModel profile, PaymentServicesState state) => [
            getFullBleedImageWithText(
              context,
              widget.model,
              'assets/images/activity_creator/onboarding/IMG_7389.png',
              'How to Receive Payments',
              'Setup your account to receive payments. This way we will know where to send you your money.'
            ),

            updatePayoutMethodWidget(context, profile, state)
          ];

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height
              ),
              CreateNewMain(
                  isPreviewer: false,
                  model: widget.model,
                  isLoading: isLoading,
                  pageController: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    // setState(() {
                    //   if (index != (attendeeMainContainer(context, currentUser, profiles, state).length - 1)) {
                    //     currentVendorMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].subVendorMarkerItem;
                    //     currentMarkerItem = attendeeMainContainer(context, currentUser, profiles, state)[index].markerItem;
                    //   }
                    // });
                  },
                  child: (profile.stripeAccountDetailsSubmitted == true) ? [updatePayoutMethodWidget(context, profile, state)] : setupPayoutsOnBoarding(context, profile, state).toList()
              ),
              createNewMainFooter(
                  context,
                  widget.model,
                  false,
                  true,
                  didSelectBack: () {
                    setState(() {
                      if (_currentPage == 0) {
                          Navigator.of(context).pop();
                      } else {
                        isLoading = true;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                        pageController?.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                      }
                    });
                  },
                  didSelectNext: () {
                    setState(() {
                      isLoading = true;
                      Future.delayed(const Duration(milliseconds: 800), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                      pageController?.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
                    });
                  }),
            ],
          );
          return updatePayoutMethodWidget(context, profile, state);
        },
      ),
    );
  }



  Widget updatePayoutMethodWidget(BuildContext context, UserProfileModel profile, PaymentServicesState state) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 35),
              Text('How to Receive Payments',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: widget.model.disabledTextColor,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Text('Setup your account to receive payments, this way we will know where to send you your money.',
                style: TextStyle(
                  color: widget.model.paletteColor,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 35),
              if (state.isSaving) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
              if (!state.isSaving && (profile.stripeAccountDetailsSubmitted == true)) InkWell(
                onTap: () {
                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.presentStripePayoutAccount(profile));
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: widget.model.paletteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(child:
                  Text('My Payout Account', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
                ),
              ),

              // if (!state.isSaving) InkWell(
              //   onTap: () {
              //     context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedDeletePayoutAccount(profile));
              //   },
              //   child: Container(
              //     height: 55,
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: model.paletteColor),
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     child: Center(child: Text('Delete My Payout Account', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold))),
              //   ),
              // ),

              if (!state.isSaving && (!(profile.stripeAccountDetailsSubmitted ?? false))) InkWell(
                onTap: () {
                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewStripePayoutMethod(profile));
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: widget.model.paletteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(child:
                  Text((profile.stripeAccountId != null) ? 'Finish Setting Up Payouts' : 'Setup Payouts', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
                ),
              ),
          ],
      ),
    );
  }
}


Widget getFullBleedImageWithText(BuildContext context, DashboardModel model, String imagePath, String title, String subtext) {
  return Stack(
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: model.paletteColor.withOpacity(0.25), // Semi-transparent overlay for readability
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: model.accentColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              subtext,
              style: TextStyle(
                color: model.accentColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ],
  );
}