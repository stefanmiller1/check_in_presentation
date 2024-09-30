part of check_in_presentation;

class GetLoginSignUpWidget extends StatefulWidget {

  final DashboardModel model;
  final bool showFullScreen;
  final Function() didLoginSuccess;

  const GetLoginSignUpWidget({super.key, required this.model, required this.didLoginSuccess, required this.showFullScreen});

  @override
  State<GetLoginSignUpWidget> createState() => _GetLoginSignUpWidgetState();
}

class _GetLoginSignUpWidgetState extends State<GetLoginSignUpWidget> {

  late PhoneController _phoneController;
  late bool _showEmailSignIn = false;
  late bool showOnBoarding = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    showOnBoarding = false;
    _phoneController = PhoneController(null);
    _controller = VideoPlayerController.asset('assets/videos/Circle_Homepage_Animation.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

                      if (r) {
                        // showOnBoarding = false;
                        /// not first time sign in
                        widget.didLoginSuccess();
                        context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());

                      } else {
                        /// is first time sign in
                        /// do not show if on web app
                        if (kIsWeb) {
                          widget.didLoginSuccess();
                          context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());
                        } else {
                          showOnBoarding = true;
                          context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.updateFirstTimeSignIn());
                        }
                      }

                },
              ),
            );
          },
          buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
          builder: (context, state) {

            if (showOnBoarding) {
              return OnBoardingActivitiesProfile(
                model: widget.model,
                didSelectSkip: () {
                  setState(() {
                    widget.didLoginSuccess();
                    context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());
                  });
                },
                didSelectComplete: () {
                  setState(() {
                    widget.didLoginSuccess();
                    context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());
                  });
                },
              );
            }

            // if (Responsive.isMobile(context) || widget.showFullScreen == false) {

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            // height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          ),

                          if ((kIsWeb && Responsive.isMobile(context)) == false)
                            if (_controller.value.isInitialized) Container(
                              width: 750,
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                    child: VideoPlayer(_controller)
                            ),
                          ),
                        ) else
                          Container(
                              height: 600,
                              width: MediaQuery.of(context).size.width,
                              child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                        ),

                          Container(
                            width: 600,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 80.0),
                              child: Container(
                                  child: Image.asset('assets/logo_icon/CIRCLE_LOGO_LIGHT.png')
                              ),
                            ),
                          ),
                        ],
                      ),


                    if (_showEmailSignIn == false) getLoginSignupWidget(
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
                    ),

                    if  (_showEmailSignIn) Center(
                      child: LoginEmailWidget(
                        didCompleteSuccessfully: () {
                          setState(() {
                            widget.didLoginSuccess();
                            context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());
                          });
                        },
                        model: widget.model,
                        goBack: () {
                          setState(() {
                            _showEmailSignIn = false;
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            // }

            // return Padding(
            //   padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //
            //       Expanded(
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             if (_controller.value.isInitialized)
            //               Flexible(
            //                 flex: 2,
            //                   child: Container(
            //                     width: double.infinity,
            //                     height: double.infinity,
            //                     child: FittedBox(
            //                       fit: BoxFit.contain,
            //                       child: SizedBox(
            //                         width: _controller.value.size.width,
            //                         height: _controller.value.size.height,
            //                         child: ClipRRect(
            //                             borderRadius: BorderRadius.circular(25),
            //                             child: VideoPlayer(_controller)
            //                         ),
            //                       ),
            //                     ),
            //                   )
            //               )
            //             else
            //               Flexible(
            //                 flex: 2,
            //                 child: Container(
            //                     width: double.infinity,
            //                     height: double.infinity,
            //                     child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)),
            //               ),
            //
            //             const SizedBox(width: 18),
            //
            //             if (_showEmailSignIn == false) Flexible(
            //               flex: 1,
            //               // flex: (MediaQuery.of(context).size.height >= 1800) ? 1 : (MediaQuery.of(context).size.height >= 1300) ? 2 : (MediaQuery.of(context).size.height >= 900) ? 6 : 10,
            //               child: Container(
            //                 // height: MediaQuery.of(context).size.height,
            //                 width: MediaQuery.of(context).size.width,
            //                 child: SingleChildScrollView(
            //                   child: Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Container(
            //                         width: 600,
            //                         child: Padding(
            //                           padding: const EdgeInsets.symmetric(horizontal: 80.0),
            //                           child: Container(
            //                               child: Image.asset('assets/logo_icon/CIRCLE_LOGO_LIGHT.png')
            //                           ),
            //                         ),
            //                       ),
            //                       getLoginSignupWidget(
            //                           context: context,
            //                           model: widget.model,
            //                           isLoading: state.isSubmitting,
            //                           phoneController: _phoneController,
            //                           validateMode: state.showErrorMessages,
            //                           onPhoneChanged: (p) {
            //
            //                           },
            //                           onContinuePressed: () async {
            //                             final Uri params = Uri(
            //                               scheme: 'mailto',
            //                               path: 'hello@cincout.ca',
            //                               query: encodeQueryParameters(<String, String>{
            //                                 'subject':'Looking To Join The Beta! - Circle Activities',
            //                                 'body': 'Hey! - Use my email to add me to the wait-list!'
            //                               }),
            //                             );
            //
            //                             if (await canLaunchUrl(params)) {
            //                               launchUrl(params);
            //                             }
            //                           },
            //                           onAppleSignInPressed: () {
            //                             setState(() {
            //                               context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.userProfileStreamClosed());
            //                               context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.signInWithApplePressed());
            //                             });
            //                           },
            //                           onGoogleSignInPressed: () {
            //                             setState(() {
            //                               context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.userProfileStreamClosed());
            //                               context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.signInWithGooglePressed());
            //                             });
            //                           },
            //                           onEmailSignInPressed: () {
            //                             setState(() {
            //                               _showEmailSignIn = !_showEmailSignIn;
            //                             });
            //                           }
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(width: 8),
            //             if  (_showEmailSignIn) Container(
            //               height: MediaQuery.of(context).size.height,
            //               constraints: const BoxConstraints(maxWidth: 600),
            //               child: Center(
            //                 child: LoginEmailWidget(
            //                   didCompleteSuccessfully: () {
            //                     setState(() {
            //                       context.read<UserProfileWatcherBloc>().add(const UserProfileWatcherEvent.watchUserProfileStarted());
            //                     });
            //                   },
            //                   model: widget.model,
            //                   goBack: () {
            //                     setState(() {
            //                       _showEmailSignIn = false;
            //                     });
            //                   },
            //                 ),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //     ],
            //   ),
            // );
          },
        )
    );
  }
}


Widget getLoginSignupWidget({required BuildContext context, required DashboardModel model, required bool isLoading, required PhoneController phoneController, required AutovalidateMode validateMode, required Function(PhoneNumber) onPhoneChanged, required Function() onContinuePressed, required Function() onAppleSignInPressed, required Function() onEmailSignInPressed, required Function() onGoogleSignInPressed}) {
  if (isLoading) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          JumpingDots(numberOfDots: 3, color: model.paletteColor),
        ],
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
      children: [
      // const SizedBox(height: 12),
      // Text('Log in or sign up below', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
      // const SizedBox(height: 24),
      // Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(25),
      //     color: model.paletteColor
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       children: [
      //         Text('Market Organizers! 📣', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
      //         const SizedBox(height: 10),
      //         Text('We\'d love to invite you to be a beta tester for our upcoming app designed specifically for market hosts. Get an early peek, share your insights, and help us tailor our app to meet your needs! Intrigued? Tap below to join our beta testing team.', style: TextStyle(color: model.accentColor))
      //       ],
      //     ),
      //   )
      // ),
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
      // const SizedBox(height: 16),
      // InkWell(
      //   onTap: () {
      //     onContinuePressed();
      //   },
      //   child: Container(
      //     height: (kIsWeb) ? 60 : 45,
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(15),
      //         border: Border.all(color: model.paletteColor, width: 0.5)
      //     ),
      //     child: Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Center(child: Text('Count Me In!', style: TextStyle(color: model.paletteColor,  fontWeight: FontWeight.bold))),
      //     ),
      //   ),
      // ),
      // const SizedBox(height: 16),
      // Row(
      //   children: [
      //     Expanded(
      //       child: Container(
      //         height: 1,
      //         color: model.disabledTextColor,
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //       child: Text('or', style: TextStyle(color: model.paletteColor)),
      //     ),
      //     Expanded(
      //       child: Container(
      //         height: 1,
      //         color: model.disabledTextColor,
      //       ),
      //     ),
      //   ],
      // ),

      const SizedBox(height: 16),
      /// use the buttons below to get an account started or login
      Text('Get a new Account started or Sign In Below', style: TextStyle(color: model.paletteColor)),
      const SizedBox(height: 16),
      AppleAuthButton(
        onPressed: (isLoading == false) ? onAppleSignInPressed : null,
        isLoading: isLoading,
        text: 'APPLE SIGN IN',

        style: AuthButtonStyle(
          buttonColor: model.webBackgroundColor,
          height: (kIsWeb) ? 60 : 45,
          width: 600,
          elevation: 0,
          borderWidth: 0.5,
          borderColor: model.paletteColor,
          borderRadius: 15,
          iconColor: model.paletteColor,
          textStyle: TextStyle(color: model.paletteColor)
        ),
      ),
      const SizedBox(height: 8),
      GoogleAuthButton(
        onPressed: (isLoading == false) ? onGoogleSignInPressed : null,
        isLoading: isLoading,
        text: 'GOOGLE SIGN IN',
        style: AuthButtonStyle(
            buttonColor: model.webBackgroundColor,
            height: (kIsWeb) ? 60 : 45,
            width: 600,
            elevation: 0,
            borderWidth: 0.5,
            borderColor: model.paletteColor,
            borderRadius: 15,
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
          height: (kIsWeb) ? 60 : 45,
          width: 600,
          elevation: 0,
          borderWidth: 0.5,
          borderColor: model.paletteColor,
          borderRadius: 15,
          iconColor: model.paletteColor,
          textStyle: TextStyle(color: model.paletteColor)
        ),
      ),
        const SizedBox(height: 24),
        BasicWebFooter(
          model: model
        )
    ],
  );
}