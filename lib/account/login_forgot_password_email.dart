part of check_in_presentation;

class LoginForgotPassword extends StatelessWidget {

  final DashboardModel model;
  final Function() goBack;

  const LoginForgotPassword({Key? key, required this.model, required this.goBack}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateAuthUserAccountBloc>(),
      child: BlocConsumer<CreateAuthUserAccountBloc, CreateAuthUserAccountState>(
          listener: (context, state) {
            state.authFailureOrSuccessOption.fold(
                    () {},
                    (either) => either.fold(
                        (failure) {
                      final snackBar = SnackBar(
                          backgroundColor: model.webBackgroundColor,
                          content: failure.maybeMap(
                            // cancelledByUser: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: model.disabledTextColor),),
                            serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor),),
                            emailAlreadyInUse: (_) => Text(AppLocalizations.of(context)!.loginEmailUseError, style: TextStyle(color: model.disabledTextColor),),
                            invalidEmailAndPasswordCombination: (_) => Text(AppLocalizations.of(context)!.loginInvalidComboError, style: TextStyle(color: model.disabledTextColor),),
                            orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: model.disabledTextColor),),
                        )
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }, (_) {

                  // context.router.replace(const HomePageWebRoute());
                  // context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountBloc.authCheckRequested()); })
              }
            )
          );
        },
        builder: (context, state) {
          return Form(
            autovalidateMode: state.showErrorMessages,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 35),
                    Text(
                      AppLocalizations.of(context)!.loginForgotPasswordTitle, style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: model.accentColor.withOpacity(0.8),
                    ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: 450,
                      decoration: BoxDecoration(
                        color: model.webBackgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(12)
                        ),
                      ),
                      child: Container(
                        width: 430,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(AppLocalizations.of(context)!.loginDashboardEmailTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: model.disabledTextColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: 435,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)!
                                        .loginDashboardEmailField,
                                    errorStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: model.paletteColor,
                                    ),
                                    prefixIcon: Icon(Icons.email,
                                        color: model.disabledTextColor),
                                    // labelText: "Email",
                                    filled: true,
                                    fillColor: model.accentColor,
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: model.disabledTextColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: model.disabledTextColor,
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
                                        color: model.webBackgroundColor,
                                        width: 0,
                                      ),
                                    ),
                                  ),
                                  autocorrect: false,
                                  onChanged: (value) =>
                                      context
                                          .read<CreateAuthUserAccountBloc>()
                                          .add(CreateAuthUserAccountEvent.emailChanged(
                                          value)),
                                  validator: (_) =>
                                      context
                                          .read<CreateAuthUserAccountBloc>()
                                          .state
                                          .user
                                          .emailAddress
                                          .value
                                          .fold(
                                              (f) =>
                                              f.maybeMap(
                                                userProfile: (u) =>
                                                    u.f?.maybeMap(
                                                        invalidEmail: (_) =>
                                                        AppLocalizations.of(context)!
                                                            .loginDashboardEmailError,
                                                        orElse: () => null),
                                                orElse: () => null,
                                        ),
                                    (_) => null
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.loginForgotPasswordHelp,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: model.disabledTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 25),
                            Center(
                              child: Container(
                                width: 300,
                                height: 65,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8, top: 15),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<
                                          Color>(
                                            (Set<MaterialState> states) {
                                          return model.accentColor;
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(35)),
                                        )
                                      ),
                                    ),
                                    onPressed: () {
                                      context.read<CreateAuthUserAccountBloc>().add(const CreateAuthUserAccountEvent.forgotPasswordPressed());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(AppLocalizations.of(context)!.loginForgotPasswordReset,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: model.disabledTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Center(
                              child: Container(
                                width: 300,
                                height: 65,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8, top: 15),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<
                                          Color>(
                                            (Set<MaterialState> states) {
                                          return model.accentColor;
                                        },
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(35)),
                                          )
                                      ),
                                    ),
                                    onPressed: () {
                                      goBack();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(AppLocalizations.of(context)!.cancelButton,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: model.disabledTextColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}