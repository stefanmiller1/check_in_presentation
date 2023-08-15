part of check_in_presentation;

Widget widgetForCheckInPreview(BuildContext context, DashboardModel model, CheckInSetting checkInForm) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: model.paletteColor
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Preview of Check-In Form Pre-Check-In', style: TextStyle(color: model.webBackgroundColor, fontSize: model.secondaryQuestionTitleFontSize)),
          SizedBox(height: 10),
          Text('To Finish Your Reservation, please Check-In by following the instructions below', style: TextStyle(color: model.webBackgroundColor, fontSize: model.secondaryQuestionTitleFontSize)),
          SizedBox(height: 10),
          ...checkInForm.listOfConfirmationItems.where((element) => element.stringItem != '').map(
                  (e) => RadioListTile(
                    toggleable: true,
                    value: 'Half',
                    groupValue: '...',
                    onChanged: (String? value) {

                    },
                    title: Text(e.stringItem, style: TextStyle(
                        color: model.webBackgroundColor,
                        fontSize: model.secondaryQuestionTitleFontSize)
                    ),
                    activeColor: model.webBackgroundColor,
                  ),
          ).toList()
        ],
      ),
    ),

  );
}