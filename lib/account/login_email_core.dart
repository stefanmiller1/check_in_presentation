part of check_in_presentation;

class LoginEmailWidget extends StatefulWidget {

  final DashboardModel model;
  final Function() didCompleteSuccessfully;
  final Function() goBack;

  const LoginEmailWidget({Key? key, required this.model, required this.goBack, required this.didCompleteSuccessfully}) : super(key: key);

  @override
  State<LoginEmailWidget> createState() => _LoginEmailWidgetState();
}

class _LoginEmailWidgetState extends State<LoginEmailWidget> {

  LoginWidgetMarker selectedContentWidget = LoginWidgetMarker.login;

  Widget getContentForm(BuildContext context, ) {
    switch (selectedContentWidget) {

      case LoginWidgetMarker.login:
        return loginFormBuild(context);
      case LoginWidgetMarker.signUp:
        // return SignUpPage(
        //     goBack: (e) {
        //       widget.goBack();
        //     },
        //     model: widget.model);
      case LoginWidgetMarker.forgotPassword:
        return LoginForgotPassword(
            model: widget.model,
            goBack: () {
              setState(() {
                selectedContentWidget = LoginWidgetMarker.login;
              });
            }
        );
      default:
        return loginFormBuild(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getContentForm(context);
  }


  Widget loginFormBuild(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt<CreateAuthUserAccountBloc>(),
        child: BlocConsumer<CreateAuthUserAccountBloc, CreateAuthUserAccountState>(
            listenWhen: (p, c) => p.authEmailFailOrSuccessOption != c.authEmailFailOrSuccessOption || p.authFailureOrSuccessOption != c.authFailureOrSuccessOption,
            listener: (context, state) {

              state.authEmailFailOrSuccessOption.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              emailAlreadyInUse: (_) => Text(AppLocalizations.of(context)!.loginEmailUseError, style: TextStyle(color: widget.model.disabledTextColor),),
                              invalidEmailAndPasswordCombination: (_) => Text(AppLocalizations.of(context)!.loginInvalidComboError, style: TextStyle(color: widget.model.disabledTextColor),),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {
                    setState(() {

                      widget.didCompleteSuccessfully();
                    });
                  }
                )
              );

              state.authFailureOrSuccessOption.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              // cancelledByUser: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                              serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              emailAlreadyInUse: (_) => Text(AppLocalizations.of(context)!.loginEmailUseError, style: TextStyle(color: widget.model.disabledTextColor),),
                              invalidEmailAndPasswordCombination: (_) => Text(AppLocalizations.of(context)!.loginInvalidComboError, style: TextStyle(color: widget.model.disabledTextColor),),
                              exceptionError: (e) => Text(e.error, style: TextStyle(color: widget.model.disabledTextColor),),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {
                        setState(() {

                          widget.didCompleteSuccessfully();
                      });
                  }
                )
              );
            },
            builder: (context, state) {
              return Form(
                autovalidateMode: state.showErrorMessages,
                child: SingleChildScrollView(
                  child: Container(
                    width: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 35),
                        Text('a Circle Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.model.questionTitleFontSize,
                            color: widget.model.paletteColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text('admin logins only', style: TextStyle(
                          fontSize: widget.model.secondaryQuestionTitleFontSize,
                          color: widget.model.disabledTextColor,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          width: 450,
                          decoration: BoxDecoration(
                            color: widget.model.webBackgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(12)
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 25),
                              Container(
                                width: 430,
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text(AppLocalizations.of(context)!.loginDashboardEmailTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: widget.model.disabledTextColor,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 8),
                                      Center(
                                        child: Container(
                                          width: 435,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: AppLocalizations.of(context)!.loginDashboardEmailField,
                                              errorStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: widget.model.paletteColor,
                                              ),
                                              prefixIcon: Icon(Icons.email, color: widget.model.disabledTextColor),
                                              // labelText: "Email",
                                              filled: true,
                                              fillColor: widget.model.accentColor,
                                              focusedErrorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                  color: widget.model.disabledTextColor,
                                                ),
                                              ),
                                              focusedBorder:  OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                  color: widget.model.disabledTextColor,
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
                                                  color: widget.model.webBackgroundColor,
                                                  width: 0,
                                                ),
                                              ),
                                            ),
                                            autocorrect: false,
                                            onChanged: (value) => context
                                                .read<CreateAuthUserAccountBloc>()
                                                .add(CreateAuthUserAccountEvent.emailChanged(value)),
                                            validator: (_) => context
                                                .read<CreateAuthUserAccountBloc>()
                                                .state
                                                .user.emailAddress
                                                .value
                                                .fold(
                                                    (f) => f.maybeMap(
                                                  userProfile: (u) => u.f?.maybeMap(
                                                      invalidEmail: (_) => AppLocalizations.of(context)!.loginDashboardEmailError,
                                                      orElse: () => null),
                                                  orElse: () => null,
                                                ),
                                              (_) => null
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 430,
                                child: Center(
                                  child: Padding(padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(AppLocalizations.of(context)!.loginDashboardPassword,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: widget.model.disabledTextColor,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: Container(
                                            width: 435,
                                            child: TextFormField(
                                              decoration: InputDecoration(prefixIcon: Icon(Icons.lock, color: widget.model.disabledTextColor),
                                                hintText: AppLocalizations.of(context)!.loginDashboardPassword,
                                                focusedErrorBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  borderSide: BorderSide(
                                                    color: widget.model.disabledTextColor,
                                                  ),
                                                ),
                                                errorStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: widget.model.paletteColor,
                                                ),
                                                filled: true,
                                                fillColor: widget.model.accentColor,
                                                focusedBorder:  OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(25.0),
                                                  borderSide: BorderSide(
                                                    color: widget.model.disabledTextColor,
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
                                                    color: widget.model.webBackgroundColor,
                                                    width: 0,
                                                  ),
                                                ),
                                              ),

                                              autocorrect: false,
                                              obscureText: true,
                                              validator: (e) => e!.isNotEmpty ? null : AppLocalizations.of(context)!.signUpDashboardError,
                                              onFieldSubmitted: (value) {
                                                context
                                                    .read<CreateAuthUserAccountBloc>()
                                                    .add(const CreateAuthUserAccountEvent.signInPressed(),
                                                );
                                              },
                                              onChanged:
                                                  (value) => context
                                                  .read<CreateAuthUserAccountBloc>()
                                                  .add(CreateAuthUserAccountEvent.loginPasswordChanged(value)
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),


                              // ListTile(
                              //   contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 10),
                              //   dense: true,
                              //   hoverColor: Colors.red,
                              //   focusColor: Colors.red,
                              //   selectedTileColor: Colors.red,
                              //   onTap: () {
                              //     setState(() {
                              //       selectedContentWidget = LoginWidgetMarker.signUp;
                              //     });
                              //   },
                              //   title: Text("${AppLocalizations.of(context)!.loginDashboardCreateFacility} >",
                              //     style: TextStyle(color: widget.model.disabledTextColor,
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 13.5), textAlign: TextAlign.left,
                              //   ),
                              // ),
                              ListTile(
                                contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 0, top: 0),
                                dense: true,
                                onTap: () {
                                  setState(() {
                                    selectedContentWidget = LoginWidgetMarker.forgotPassword;
                                  });
                                },
                                title: Text(AppLocalizations.of(context)!.loginDashboardPasswordReset,
                                  style: TextStyle(color: widget.model.disabledTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.5),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              SizedBox(height: 10),
                              if (!(state.isSubmitting)) Center(
                                child: Container(
                                  width: 300,
                                  height: 65,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8, top: 15),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            return widget.model.accentColor;
                                          },
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(35)),
                                            )
                                        ),
                                      ),
                                      onPressed: () {
                                        if (state.isSubmitting == false) {
                                          context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.signInPressed(),
                                          );
                                        }
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                        child: Text(AppLocalizations.of(context)!.signIn,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: (state.isSubmitting == false) ? Colors.grey.shade700 : widget.model.disabledTextColor.withOpacity(0.4),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              if (state.isSubmitting) JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                            ]
                          )
                        ),
                        SizedBox(height: 15),
                        TextButton(
                          onPressed: () {
                            widget.goBack();
                          },
                          child: Text(AppLocalizations.of(context)!.backButton, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
}