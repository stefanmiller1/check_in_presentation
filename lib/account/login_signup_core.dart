part of check_in_presentation;

class GetLoginSignUpWidget extends StatefulWidget {

  final DashboardModel model;
  final Function() didLoginSuccess;

  const GetLoginSignUpWidget({super.key, required this.model, required this.didLoginSuccess});

  @override
  State<GetLoginSignUpWidget> createState() => _GetLoginSignUpWidgetState();
}

class _GetLoginSignUpWidgetState extends State<GetLoginSignUpWidget> {

  late PhoneController _phoneController;
  late bool _showEmailSignIn = false;

  @override
  void initState() {
    _phoneController = PhoneController(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<CreateAuthUserAccountBloc>()..add(CreateAuthUserAccountEvent.initialized(dart.optionOf(UserProfileModel.empty()))),
        child: BlocConsumer<CreateAuthUserAccountBloc, CreateAuthUserAccountState>(
          listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
          listener: (context, state) {
            state.authFailureOrSuccessOption.fold(
                  () => null,
                  (either) => either.fold(
                    (failure) {
                  final snackBar = SnackBar(
                      backgroundColor: widget.model.paletteColor,
                      content: failure.maybeMap(
                        exceptionError: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        emailAlreadyInUse: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        invalidEmailAndPasswordCombination: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        weakPassword: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        wrongPassword: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        userAlreadySignedIn: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        operationNotAllowed: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor)),
                        serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                        orElse: () => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                      )
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                    (r) {

                      widget.didLoginSuccess();
                  // context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());

                },
              ),
            );
          },
          buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
          builder: (context, state) {

            return (_showEmailSignIn) ? LoginEmailWidget(

              didCompleteSuccessfully: () {
                setState(() {
                  context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());
                });
              },
              model: widget.model,
              goBack: () {
                setState(() {
                  _showEmailSignIn = false;
                });
              },
            ) : getLoginSignupWidget(
                context: context,
                model: widget.model,
                isLoading: state.isSubmitting,
                phoneController: _phoneController,
                validateMode: state.showErrorMessages,
                  onPhoneChanged: (p) {

                  },
                  onContinuePressed: () async {
                    final Uri params = Uri(
                      scheme: 'mailto',
                      path: 'hello@cincout.ca',
                      query: encodeQueryParameters(<String, String>{
                        'subject':'Looking To Join The Beta! - Circle Activities',
                        'body': 'Hey! - Use my email to add me to the wait-list!'
                      }),
                    );

                    if (await canLaunchUrl(params)) {
                      launchUrl(params);
                    }
                  },
                  onAppleSignInPressed: () {
                    setState(() {
                      context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.userProfileStreamClosed());
                      context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.signInWithApplePressed());
                    });
                  },
                  onGoogleSignInPressed: () {
                    setState(() {
                      context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.userProfileStreamClosed());
                      context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.signInWithGooglePressed());
                    });
                  },
                  onEmailSignInPressed: () {
                    setState(() {
                      _showEmailSignIn = !_showEmailSignIn;
                    });
                }
            );
          },
        )
    );
  }
}


Widget getLoginSignupWidget({required BuildContext context, required DashboardModel model, required bool isLoading, required PhoneController phoneController, required AutovalidateMode validateMode, required Function(PhoneNumber) onPhoneChanged, required Function() onContinuePressed, required Function() onAppleSignInPressed, required Function() onEmailSignInPressed, required Function() onGoogleSignInPressed}) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Log in or sign up below', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: model.paletteColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Market Organizers! 📣', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text('We\'d love to invite you to be a beta tester for our upcoming app designed specifically for market hosts. Get an early peek, share your insights, and help us tailor our app to meet your needs! Intrigued? Tap below to join our beta testing team.', style: TextStyle(color: model.accentColor))
              ],
            ),
          )
        ),
        // PhoneFieldView(
        //     // key: _scaffoldKey,
        //     hintText: AppLocalizations.of(context)!.profileAccountPhone,
        //     // inputKey: _phoneKey,
        //     controller: phoneController,
        //     selectorNavigator: const CountrySelectorNavigator.modalBottomSheet(),
        //     model: model,
        //     validateMode: validateMode,
        //     onChangedPhoneNumber: (p) {
        //
        //   }
        // ),
        // const SizedBox(height: 8),
        // const Text('Select a country/region above with your phone number and receive text to confirm it\'s you. Messaging and data rates apply.'),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            onContinuePressed();
          },
          child: Container(
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: model.paletteColor, width: 0.5)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text('Count Me In!', style: TextStyle(color: model.paletteColor,  fontWeight: FontWeight.bold))),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: model.disabledTextColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('or', style: TextStyle(color: model.paletteColor)),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: model.disabledTextColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        /// use the buttons below to get an account started or login
        Text('Get a new Account started or Sign In Below', style: TextStyle(color: model.paletteColor)),
        const SizedBox(height: 16),
        AppleAuthButton(
          onPressed: (isLoading == false) ? onAppleSignInPressed : null,
          isLoading: isLoading,
          text: 'CONTINUE WITH APPLE',
          style: AuthButtonStyle(
            buttonColor: model.webBackgroundColor,
            height: 45,
            width: MediaQuery.of(context).size.width,
            elevation: 0,
            borderWidth: 0.5,
            borderColor: model.paletteColor,
            borderRadius: 12,
            iconColor: model.paletteColor,
            textStyle: TextStyle(color: model.paletteColor)
          ),
        ),
        const SizedBox(height: 8),
        GoogleAuthButton(
          onPressed: (isLoading == false) ? onGoogleSignInPressed : null,
          isLoading: isLoading,
          text: 'CONTINUE WITH GOOGLE',
          style: AuthButtonStyle(
              buttonColor: model.webBackgroundColor,
              height: 45,
              width: MediaQuery.of(context).size.width,
              elevation: 0,
              borderWidth: 0.5,
              borderColor: model.paletteColor,
              borderRadius: 12,
              iconColor: model.paletteColor,
              textStyle: TextStyle(color: model.paletteColor)
          ),
        ),
        const SizedBox(height: 8),
        if (kIsWeb) EmailAuthButton(
          onPressed: onEmailSignInPressed,
          isLoading: isLoading,
          text: 'CONTINUE WITH EMAIL',
          style: AuthButtonStyle(
            buttonColor: model.webBackgroundColor,
            height: 45,
            width: MediaQuery.of(context).size.width,
            elevation: 0,
            borderWidth: 0.5,
            borderColor: model.paletteColor,
            borderRadius: 12,
            iconColor: model.paletteColor,
            textStyle: TextStyle(color: model.paletteColor)
          ),
        )
      ],
    ),
  );
}