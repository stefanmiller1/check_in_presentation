part of check_in_presentation;

class ActivitySetupGames extends StatelessWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivitySetupGames({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityAvailability.gameActivityAvailability?.tournamentNumberOfTeams == null) {
    //   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.gameNumberOfTeamsChanged(4));
    // }
return Container();
    // return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityManagerForm), dart.optionOf(reservation))),
    // child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
    // listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
    // listener: (context, state) {
    //
    // },
    // buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
    // builder: (context, state) {
    //     return Scaffold(
    //       appBar: AppBar(
    //         elevation: 0,
    //         backgroundColor: model.paletteColor,
    //         title: Text('Preset Game', style: TextStyle(color: model.accentColor)),
    //         actions: [
    //
    //         ],
    //       ),
    //       body: Padding(
    //         padding: const EdgeInsets.all(18.0),
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 8.0),
    //                 child: Text(AppLocalizations.of(context)!.activityPresetGameTeamTitle, style: TextStyle(fontWeight: FontWeight.bold, color: model.paletteColor, fontSize: model.questionTitleFontSize)),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(AppLocalizations.of(context)!.activityPresetGameTeamSubTitle, style: TextStyle(color: model.paletteColor)),
    //               ),
    //
    //               Row(
    //                 children: [
    //                   Container(
    //                       decoration: BoxDecoration(
    //                           color: model.accentColor,
    //                           borderRadius: BorderRadius.all(Radius.circular(12))
    //                       ),
    //                       height: 35,
    //                       width: 60,
    //                       child: Center(
    //                         child: Text(context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.gameActivityAvailability?.tournamentNumberOfTeams.toString() ?? '4', style: TextStyle(color: model.disabledTextColor)
    //                         ),
    //                       )
    //                   ),
    //                   QuantityButtons(
    //                       model: model,
    //                       initNumber: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.gameActivityAvailability?.tournamentNumberOfTeams ?? 4,
    //                       counterCallback: (int v) {
    //                         context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.gameNumberOfTeamsChanged(v));
    //                       }
    //                   ),
    //                   Text(AppLocalizations.of(context)!.activityTeams,
    //                       style: TextStyle(
    //                           color: model.paletteColor,
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: model.secondaryQuestionTitleFontSize)),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //   )
    // );
  }
}