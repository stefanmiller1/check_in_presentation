part of check_in_presentation;

Widget mainContainerSectionOneCancel({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() isNotAllowedCancellation,  required Function() isAllowedFeeBasedChanges, required Function(List<FeeBasedCancellation>) feeBasedCancellationChanged, required Function() createCancellationWidget, required Function() isAllowedTimeBasedChanges, required Function() timeBasedCancellationChanged, required Function() createCancellationEditWidget}) {
  return Column(
    children: [
      SizedBox(height: 25),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(AppLocalizations.of(context)!.facilityCancellations, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 675,
            child: Text(AppLocalizations.of(context)!.facilityCancellationDescription('Attendee'), style: TextStyle(color: model.disabledTextColor,))),
      ),
      SizedBox(height: 10),

      SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('No Changes or Cancellations Allowed', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ),
      SizedBox(height: 10),

      Container(
        width: 675,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Prevent All Cancellations', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))),
            FlutterSwitch(
              width: 60,
              inactiveColor: model.accentColor,
              activeColor: model.paletteColor,
              value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isNotAllowedCancellation ?? false,
              onToggle: (value) {
                isNotAllowedCancellation();
              },
            )
          ],
        ),
      ),

      Visibility(
          visible: !(state.activitySettingsForm.rulesService.cancellationSettings.isNotAllowedCancellation ?? false),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Default - Change and Cancel Before the Activity Starts', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
              ),

              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 675,
                    child: Text('Allow Partial Changes/Cancellations for Attendees Before the Activity Starts Based on Fee Percentage', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize))),
              ),
              SizedBox(height: 10),

              Container(
                width: 675,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Allow Partial Fee Cancellations', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))),
                    FlutterSwitch(
                      width: 60,
                      inactiveColor: model.accentColor,
                      activeColor: model.paletteColor,
                      value: state.activitySettingsForm.rulesService.cancellationSettings.isAllowedFeeBasedChanges ?? false,
                      onToggle: (value) {
                        isAllowedFeeBasedChanges();
                      },
                    )
                  ],
                ),
              ),

              Visibility(
                visible: state.activitySettingsForm.rulesService.cancellationSettings.isAllowedFeeBasedChanges ?? false,
                child: Container(
                  width: 675,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 675,
                            child: Text('Create a Fee You would like to charge for early Cancellations', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize))),
                      ),
                      SizedBox(height: 10),
                      ...?context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.feeBasedCancellationOptions?.asMap().map((
                          i, e) => MapEntry(i, Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text('Cancel', style: TextStyle(color: model.disabledTextColor,), overflow: TextOverflow.ellipsis),
                                  SizedBox(width: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: model.webBackgroundColor,
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text((e.daysBeforeStart == 1) ? '${e.daysBeforeStart.toString()} day' : '${e.daysBeforeStart.toString()} days', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Before Reservation Starts And Keep', style: TextStyle(color: model.disabledTextColor,), overflow: TextOverflow.ellipsis,),
                                  SizedBox(width: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: model.webBackgroundColor,
                                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('${e.percentage.toString()} %', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text('of the Fee', style: TextStyle(color: model.disabledTextColor,), overflow: TextOverflow.ellipsis),
                                  SizedBox(width: 10),
                                  IconButton(onPressed: () {
                                      final List<FeeBasedCancellation> feeCancellations = [];
                                      feeCancellations.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.feeBasedCancellationOptions ?? []);
                                      feeCancellations.remove(e);

                                      feeBasedCancellationChanged(feeCancellations);

                                  }, icon: Icon(Icons.cancel_outlined, color: model.disabledTextColor))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ).values.toList(),
                      SizedBox(height: 10),

                      Container(
                        height: 60,
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                      return model.paletteColor.withOpacity(0.1);
                                    }
                                    if (states.contains(MaterialState.hovered)) {
                                      return model.paletteColor.withOpacity(0.1);
                                    }
                                    return model.webBackgroundColor; // Use the component's default.
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    )
                                )
                            ),
                            onPressed: () {
                              createCancellationWidget();
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Create Fee Cancellation',
                                style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), textAlign: TextAlign.center,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 675,
                    child: Text('Allow Partial Changes/Cancellations for Attendee Before the Activity Starts Based on Time', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize))),
              ),
              SizedBox(height: 10),

              Container(
                width: 675,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text('Allow Partial Time Cancellations', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor))),
                    FlutterSwitch(
                      width: 60,
                      inactiveColor: model.accentColor,
                      activeColor: model.paletteColor,
                      value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.cancellationSettings.isAllowedTimeBasedChanges ?? false,
                      onToggle: (value) {
                        isAllowedTimeBasedChanges();
                      },
                    )
                  ],
                ),
              ),

              Visibility(
                visible: state.activitySettingsForm.rulesService.cancellationSettings.isAllowedTimeBasedChanges ?? false,
                child: Container(
                  width: 675,
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 675,
                            child: Text('Allow Cancellations a limited number of days before an Activity Starts', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize))),
                      ),
                      ...?state.activitySettingsForm.rulesService.cancellationSettings.timeBasedCancellationOptions?.asMap().map(
                              (i, e) => MapEntry(i,
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 50,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [

                                              Container(
                                                decoration: BoxDecoration(
                                                    color: model.webBackgroundColor,
                                                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text((e.intervalDuration == 1) ? '${e.intervalDuration.toString()} day' : '${e.intervalDuration.toString()} days', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Text('Days Before Activity Starts', style: TextStyle(color: model.disabledTextColor,), overflow: TextOverflow.ellipsis),
                                              SizedBox(width: 5),
                                              IconButton(onPressed: () {
                                                  timeBasedCancellationChanged();
                                              }, icon: Icon(Icons.cancel_outlined, color: model.disabledTextColor))
                                            ],
                                          )
                                      )
                                  )
                              )
                          )
                      ).values.toList(),

                      SizedBox(height: 10),
                      if ((state.activitySettingsForm.rulesService.cancellationSettings.timeBasedCancellationOptions?.length ?? 0) < 1) Container(
                        height: 60,
                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                      return model.paletteColor.withOpacity(0.1);
                                    }
                                    if (states.contains(MaterialState.hovered)) {
                                      return model.paletteColor.withOpacity(0.1);
                                    }
                                    return model.webBackgroundColor; // Use the component's default.
                                  },
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                    )
                                )
                            ),
                            onPressed: () {
                              createCancellationEditWidget();
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Create Time Cancellation',
                                style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), textAlign: TextAlign.center,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),


      const SizedBox(height: 15),


    ],
  );
}