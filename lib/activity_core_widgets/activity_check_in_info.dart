part of check_in_presentation;

Widget minContainerForCheckIn({required BuildContext context, required DashboardModel model, required Function(CheckInSetting) editSelectCheckInForm, required Function(List<CheckInSetting>) checkInSettingsChanged , required Function() createNewCheckInForm}) {
  return Column(
    children: [
      SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Create Check-In for Specific Slots & Attendees', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 675,
            child: Text('Rules is a good way to create an additional step just before or after a reservation begins. Once completed, attendance and reservation will be confirmed and in progress. This is also a good way to remove or remind Attendees who do not complete your Check-In form before your activity Starts. ', style: TextStyle(color: model.disabledTextColor,))),
      ),

      SizedBox(height: 15),
      ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.checkInSetting.asMap().map(
              (i, value) => MapEntry(i,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Container(
                  child: TextButton(
                    onPressed: () {
                      editSelectCheckInForm(value);
                    },
                    child: Container(
                      width: 675,
                      child: Column(
                        children: [
                          IconButton(onPressed: () {

                              final List<CheckInSetting> newCheckIn = [];
                              newCheckIn.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.checkInSetting);
                              newCheckIn.remove(newCheckIn);
                              checkInSettingsChanged(newCheckIn);

                          }, icon: Icon(Icons.cancel_outlined, color: model.disabledTextColor)),
                          widgetForCheckInPreview(context, model, value),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          )
      ).values.toList(),
      SizedBox(height: 15),
      Container(
        width: 675,
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
              createNewCheckInForm();
            },
            child: Align(
              alignment: Alignment.center,
              child: Text('Create New Check-In',
                style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), textAlign: TextAlign.center,
              ),
            )
        ),
      ),
    ]
  );
}