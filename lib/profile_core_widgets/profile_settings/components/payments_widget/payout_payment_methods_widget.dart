import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/stripe/business_address_service/stripe_business_address.dart';
import 'package:country_picker/country_picker.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:dartz/dartz.dart' as bloc;


import 'helpers.dart';


class PayoutAccountLink extends StatefulWidget {

  final DashboardModel model;

  const PayoutAccountLink({super.key, required this.model});

  @override
  State<PayoutAccountLink> createState() => _PayoutAccountLinkState();
}

class _PayoutAccountLinkState extends State<PayoutAccountLink> {

  late PageController? pageController = null;
  late String? selectedCountry = null;
  late bool isEditingProfile = false;
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


  List<PayoutMethodWidget> setupPayoutsOnBoarding(BuildContext context, UserProfileModel profile, PaymentServicesState state) => [
    if (profile.stripeAccountDetailsSubmitted != true && profile.stripeCompanyName == null) PayoutMethodWidget(
      marker: PayoutMethodMarker.intro,
      isDarkMode: true,
      mainWidget: getFullBleedImageWithText(
          context,
          widget.model,
          'assets/images/activity_creator/onboarding/IMG_7389.png',
          'How to Receive Payments',
          'Setup your account to receive payments. This way we will know where to send you your money.'
      ),
    ),
    if (profile.stripeCompanyName == null || isEditingProfile) PayoutMethodWidget(
      marker: PayoutMethodMarker.companyInfo,
      isDarkMode: false,
      mainWidget: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Have a Company Name?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Enter your company name so we can smoothly handle your payouts and set up your Stripe account.', style: TextStyle(color: widget.model.paletteColor)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: widget.model.paletteColor),
                  initialValue: state.userProfile?.stripeCompanyName,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: widget.model.disabledTextColor),
                    hintText: 'Company Name',
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: widget.model.paletteColor,
                    ),
                    prefixIcon: Icon(Icons.cases_outlined, color: widget.model.disabledTextColor),
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
                  autocorrect: false,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeCompanyName(null));
                      } else {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeCompanyName(value));
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              AnimatedOpacity(
                duration: Duration(milliseconds: 600),
                opacity: (context.read<PaymentServicesBloc>().state.userProfile?.stripeCompanyName == null) ? 0.1 : 1,
                child: IgnorePointer(
                  ignoring: state.userProfile?.stripeCompanyName?.isEmpty == true || state.userProfile?.stripeCompanyName == null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Your Company Address', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 62.5,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isDense: true,
                                    customButton: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: widget.model.accentColor,
                                          border: Border.all(color: widget.model.disabledTextColor),
                                          borderRadius: BorderRadius.circular(35),
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(selectedCountry ?? 'Select a Country', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.normal)))
                                        ),
                                      ),
                                    ),
                                    onChanged: (Object? navItem) {
                                    },
                                    items: ['Canada'].map((e) {
                                          return DropdownMenuItem<String>(
                                            onTap: () {
                                            setState(() {
                                                  late StripeBusinessAddress businessAddress = (state.userProfile?.stripeBusinessAddress != null) ? state.userProfile!.stripeBusinessAddress! : StripeBusinessAddress.empty();
                                                    businessAddress = businessAddress.copyWith(
                                                        country: 'CA'
                                                    );
                                                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessAddress(businessAddress));
                                                    selectedCountry = e;
                                                });
                                            },
                                            value: e,
                                            child: Text(e, style: TextStyle(color: widget.model.paletteColor),),
                                          );
                                        }
                                    ).toList(),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: widget.model.webBackgroundColor
                                     ),
                                   ),
                                  )
                                ),
                              ),
                            )
                          ),

                          const SizedBox(width: 15),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: TextStyle(color: widget.model.paletteColor),
                                initialValue: state.userProfile?.stripeBusinessAddress?.city,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: widget.model.disabledTextColor),
                                  hintText: 'City',
                                  errorStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: widget.model.paletteColor,
                                  ),
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
                                autocorrect: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.singleLineFormatter,
                                  TextInputFormatter.withFunction((oldValue, newValue) {
                                    final newText = _capitalizeFirstLetter(newValue.text);
                                    // Set the cursor position to the end of the new text
                                    return TextEditingValue(
                                      text: newText,
                                      selection: TextSelection.collapsed(offset: newText.length),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    late StripeBusinessAddress businessAddress = (state.userProfile?.stripeBusinessAddress != null) ? state.userProfile!.stripeBusinessAddress! : StripeBusinessAddress.empty();
                                    businessAddress = businessAddress.copyWith(
                                        city: _capitalizeFirstLetter(value),
                                    );
                                    context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessAddress(businessAddress));
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(color: widget.model.paletteColor),
                          initialValue: state.userProfile?.stripeBusinessAddress?.line1,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: widget.model.disabledTextColor),
                            hintText: 'Address (street name and number)',
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: widget.model.paletteColor,
                            ),
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
                          autocorrect: false,
                          onChanged: (value) {
                            setState(() {
                              late StripeBusinessAddress businessAddress = (state.userProfile?.stripeBusinessAddress != null) ? state.userProfile!.stripeBusinessAddress! : StripeBusinessAddress.empty();
                              businessAddress = businessAddress.copyWith(
                                  line1: value
                              );
                              context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessAddress(businessAddress));
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(color: widget.model.paletteColor),
                          initialValue: state.userProfile?.stripeBusinessAddress?.state,

                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: widget.model.disabledTextColor),
                            hintText: 'State or Province',
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: widget.model.paletteColor,
                            ),
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
                          autocorrect: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            LengthLimitingTextInputFormatter(2),
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              return TextEditingValue(
                                text: newValue.text.toUpperCase(), // Convert input to uppercase
                                selection: newValue.selection,
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              late StripeBusinessAddress businessAddress = (state.userProfile?.stripeBusinessAddress != null) ? state.userProfile!.stripeBusinessAddress! : StripeBusinessAddress.empty();
                              businessAddress = businessAddress.copyWith(
                                  state: value.toUpperCase(),
                              );
                              context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessAddress(businessAddress));
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('eg: ON or NY', style: TextStyle(color: widget.model.disabledTextColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: TextStyle(color: widget.model.paletteColor),
                          initialValue: state.userProfile?.stripeBusinessAddress?.postal_code,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: widget.model.disabledTextColor),
                            hintText: 'Postal',
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: widget.model.paletteColor,
                            ),
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
                          autocorrect: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.singleLineFormatter,
                            TextInputFormatter.withFunction((oldValue, newValue) {
                              return TextEditingValue(
                                text: newValue.text.toUpperCase(), // Convert input to uppercase
                                selection: newValue.selection,
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              late StripeBusinessAddress businessAddress = (state.userProfile?.stripeBusinessAddress != null) ? state.userProfile!.stripeBusinessAddress! : StripeBusinessAddress.empty();
                              businessAddress = businessAddress.copyWith(
                                postal_code: value.toUpperCase(),
                              );
                              context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessAddress(businessAddress));
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    ),
    if (profile.stripeBusinessAddress == null) PayoutMethodWidget(
      marker: PayoutMethodMarker.details,
      isDarkMode: true,
      mainWidget: getFullBleedImageWithText(
        context,
        widget.model,
        'assets/images/activity_creator/onboarding/IMG_6792.png', // Replace with your image path for step 2
        'Provide Your Details',
        'Enter the necessary information to finalize your payout account setup. This includes your tax information and address, which are crucial for compliance with tax regulations and accurate payment processing. Stripe payout integrations will ensure that you receive your payments on time.',
      ),
    ),
    if (profile.stripeBusinessAddress == null || isEditingProfile) PayoutMethodWidget(
      marker: PayoutMethodMarker.taxInfo,
      isDarkMode: false,
      mainWidget: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Have a Business Number?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(' a 9-digit Ontario Business Identification Number (BIN).', style: TextStyle(color: widget.model.paletteColor)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: widget.model.paletteColor),
                  initialValue: state.userProfile?.stripeBusinessID,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: widget.model.disabledTextColor),
                    hintText: 'Business Account Number',
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: widget.model.paletteColor,
                    ),
                    prefixIcon: Icon(Icons.cases_outlined, color: widget.model.disabledTextColor),
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
                  autocorrect: false,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessIDChanged(null));
                      } else {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeBusinessIDChanged(value));
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('Have a Registered GST/HST Account Number?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('An alphanumeric code made up of your nine-digit business number, followed by RT 0001. This number will appear on invoices for your buyers that pay to participate in your activities and on payout receipts.', style: TextStyle(color: widget.model.paletteColor)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: widget.model.paletteColor),
                  initialValue: state.userProfile?.stripeHSTRegistrationNumber,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: widget.model.disabledTextColor),
                    hintText: 'GST/HST Account Number',
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: widget.model.paletteColor,
                    ),
                    prefixIcon: Icon(Icons.cases_outlined, color: widget.model.disabledTextColor),
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
                  autocorrect: false,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeHSTRegistrationNumberChanged(null));
                      } else {
                        context.read<PaymentServicesBloc>().add(PaymentServicesEvent.profileStripeHSTRegistrationNumberChanged(value));
                      }
                    });
                  },
                ),
              ),
              // an alphanumeric code made up of your nine-digit business number, followed by RT 0001

            ],
          ),
        ),
      ),
    ),
    // Step 3: Full-bleed image with text overlay for step 3
    if (profile.stripeCompanyName == null && profile.stripeBusinessAddress == null && profile.stripeBusinessID == null && profile.stripeAccountId != null) PayoutMethodWidget(
      marker: PayoutMethodMarker.review,
      isDarkMode: true,
      mainWidget: getFullBleedImageWithText(
        context,
        widget.model,
        'assets/images/activity_creator/onboarding/IMG_6794.png', // Replace with your image path for step 3
        'Review and Confirm',
        'Check your details carefully and confirm your account information. Accurate tax and address details are essential to ensure correct payments and compliance with regulations. Using Stripe payout integrations helps facilitate timely distribution of your earnings.',
      ),
    ),
    if (profile.stripeCompanyName != null && profile.stripeBusinessAddress != null && profile.stripeBusinessID != null && profile.stripeAccountId != null) PayoutMethodWidget(
      marker: PayoutMethodMarker.review,
      isDarkMode: true,
      mainWidget: getFullBleedImageWithText(
        context,
        widget.model,
        'assets/images/activity_creator/onboarding/IMG_6794.png', // Replace with your image path for step 3
        (profile.stripeAccountDetailsSubmitted != true) ? 'Finish Setting Up My Payout Account' : 'Go to My Stripe Payout Account',
        'Check your details carefully and confirm your account information. Accurate tax and address details are essential to ensure correct payments and compliance with regulations. Using Stripe payout integrations helps facilitate timely distribution of your earnings.',
      ),
    ),
    PayoutMethodWidget(
        marker: PayoutMethodMarker.payoutAccount,
        isDarkMode: false,
        mainWidget: updatePayoutMethodWidget(context, profile, state)
    )
  ];


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
                        content: Text('Taking you to your Payouts Dashboard', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                  }
              )
          );
        },
        buildWhen: (p,c) => p.isSaving != c.isSaving || p.isEditing != c.isEditing || p.cancellationList != c.cancellationList || p.userProfile != c.userProfile,
        builder: (context, state) {

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
                  },
                  child: setupPayoutsOnBoarding(context, profile, state).map((e) => e.mainWidget).toList()
              ),
              Positioned(
                top: 0,
                child: SizedBox(
                  height: 60,
                  width: (MediaQuery.of(context).size.width <= 550) ? MediaQuery.of(context).size.width : 550,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    titleTextStyle: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                    elevation: 0,
                    title: Text('Payout Methods', style: TextStyle(color: ((setupPayoutsOnBoarding(context, profile, state))[_currentPage].isDarkMode) ? widget.model.accentColor : widget.model.paletteColor,)),
                    centerTitle: true,
                    leadingWidth: 70,
                    toolbarHeight: 60,
                    leading: IconButton(
                    icon: Icon(Icons.cancel, color: ((setupPayoutsOnBoarding(context, profile, state))[_currentPage].isDarkMode) ? widget.model.accentColor : widget.model.paletteColor, size: 40,),
                    tooltip: 'Cancel',
                    onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              createNewMainFooter(
                  context,
                  widget.model,
                  true,
                  ((setupPayoutsOnBoarding(context, profile, state))[_currentPage].marker) != PayoutMethodMarker.payoutAccount,
                  getTitleForNextPayoutButton((setupPayoutsOnBoarding(context, profile, state))[_currentPage].marker, state),
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
        },
      ),
    );
  }



  Widget updatePayoutMethodWidget(BuildContext context, UserProfileModel profile, PaymentServicesState state) {

    final userProfile = state.userProfile;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 45),
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
                    if (state.userProfile != null) context.read<PaymentServicesBloc>().add(PaymentServicesEvent.presentStripePayoutAccount(state.userProfile!));
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
              //       border: Border.all(color: widget.model.paletteColor),
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     child: Center(child: Text('Delete My Payout Account', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold))),
              //   ),
              // ),

              if (!state.isSaving && (!(profile.stripeAccountDetailsSubmitted ?? false))) InkWell(
                onTap: () {
                    if (state.userProfile != null) {
                      context.read<PaymentServicesBloc>().add(PaymentServicesEvent.finishedNewStripePayoutMethod(state.userProfile!));
                    }
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
              const SizedBox(height: 25),

// Section for Company Name and Address
              if ((state.userProfile?.stripeCompanyName != null && state.userProfile!.stripeCompanyName!.isNotEmpty) ||
                  (state.userProfile?.stripeBusinessAddress != null))
                ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Company Name and Address', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isEditingProfile = true; // Set editing profile to true
                               _currentPage = setupPayoutsOnBoarding(context, profile, state).indexWhere((element) => element.marker == PayoutMethodMarker.companyInfo);
                              pageController?.jumpToPage(_currentPage); // Navigate to the companyInfo section
                            });
                            // Add your edit functionality here
                          },
                          child: Text('Edit', style: TextStyle(color: widget.model.paletteColor)),
                        ),
                      ],
                    ),
                  ),
                  Text(state.userProfile?.stripeCompanyName ?? '', style: TextStyle(color: widget.model.paletteColor)),
                  Text(state.userProfile?.stripeBusinessAddress?.line1 ?? '', style: TextStyle(color: widget.model.paletteColor)),
                  Text(state.userProfile?.stripeBusinessAddress?.city ?? '', style: TextStyle(color: widget.model.paletteColor)),
                  Text(state.userProfile?.stripeBusinessAddress?.state ?? '', style: TextStyle(color: widget.model.paletteColor)),
                  Text(state.userProfile?.stripeBusinessAddress?.postal_code ?? '', style: TextStyle(color: widget.model.paletteColor)),
                ],

              // Section for Business ID and HST
              if ((state.userProfile?.stripeBusinessID != null && state.userProfile!.stripeBusinessID!.isNotEmpty) ||
                  (state.userProfile?.stripeHSTRegistrationNumber != null && state.userProfile!.stripeHSTRegistrationNumber!.isNotEmpty))
                ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Business ID and HST', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isEditingProfile = true; // Set editing profile to true
                              _currentPage = setupPayoutsOnBoarding(context, profile, state).indexWhere((element) => element.marker == PayoutMethodMarker.taxInfo);
                              pageController?.jumpToPage(_currentPage); // Navigate to the companyInfo section
                            });
                            // Add your edit functionality here
                          },
                          child: Text('Edit', style: TextStyle(color: widget.model.paletteColor)),
                        ),
                      ],
                    ),
                  ),
                  if (state.userProfile?.stripeBusinessID != null) Text('Business ID: ${state.userProfile?.stripeBusinessID ?? ''}', style: TextStyle(color: widget.model.paletteColor)),
                  if (state.userProfile?.stripeHSTRegistrationNumber != null) Text('HST Registration: ${state.userProfile?.stripeHSTRegistrationNumber ?? ''}', style: TextStyle(color: widget.model.paletteColor)),
                ],
            ],
      ),
    );
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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