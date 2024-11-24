part of check_in_presentation;

class RequirementsSettingsMobileEditor extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;
  final Function() didSave;

  const RequirementsSettingsMobileEditor({super.key, required this.model, required this.activityManagerForm, required this.reservation, required this.didSave});

  @override
  State<RequirementsSettingsMobileEditor> createState() => _RequirementsSettingsMobileEditorState();
}

class _RequirementsSettingsMobileEditorState extends State<RequirementsSettingsMobileEditor> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
        child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
            listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.isSaving != c.isSaving || p.activitySettingsForm != c.activitySettingsForm,
            listener: (context, state) {

              /// handle saving errors & success options
              state.authFailureOrSuccessOptionSaving.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              activityServerError: (e) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              unexpected: (e) => Text('Uh Oh. Something un-expected happened', style: TextStyle(color: widget.model.disabledTextColor)),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {

                    Navigator.of(context).pop();
                    widget.didSave();
                  }
                )
              );
            },
            buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages || p.isSaving != c.isSaving || p.isEditingForm != c.isEditingForm || p.activitySettingsForm != c.activitySettingsForm,
            builder: (context, state) {

              return Scaffold(
                  appBar: scaffoldHeaderWidget(
                      context,
                      widget.model,
                      state,
                      didPressPreview: () {

                      }
                  ),
                  body: Stack(
                    children: [
                      RequirementSettingsWidget(
                        model: widget.model,
                        activityManagerForm: widget.activityManagerForm,
                        reservationItem: widget.reservation,
                      ),
                      isSavingWidget(context, widget.model, state)
                    ],
                  )
              );
            }
        )
    );
  }
}