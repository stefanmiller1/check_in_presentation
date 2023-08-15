part of check_in_presentation;

Widget mainContainerForAttendeeType({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() didChangeIsAttendeeBased, required Function(int) attendanceLimitChanged, required Function() didChangeIsTicketBased, required Function() didChangeIsPassBased}) {
  return Column(
    children: [
      const SizedBox(height: 25),
      Text('Your Attendance', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 10),
      Text('You can choose to keep track of your Attendees (or not) by making sure everyone who joins your activity do so as either an Attendee, a Ticket Holder, or Pass Holder. These are all optional and useful if you\'re creating a free activity but want to limit the number of people who can go, or if you want to charge attendees through tickets, or if you want to offer multi-day events/activities with exclusive passes for attending a set number of days. The choice is up to you.', style: TextStyle(
          color: model.disabledTextColor)),
      const SizedBox(height: 50),
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Container(
          decoration: BoxDecoration(
              color: model.webBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(AppLocalizations.of(context)!.facilitiesSelect, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          ),
        ),
      ),

      const SizedBox(height: 15),
      InkWell(
        onTap: () {
          didChangeIsAttendeeBased();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: (state.activitySettingsForm.activityAttendance.isLimitedAttendance == true) ? model.paletteColor :  model.webBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.crop_free_outlined, size: 40, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance == true) ? model.accentColor : model.paletteColor),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Keep Track of Attendees', style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance == true) ? model.accentColor : model.paletteColor , fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                      Text('Handle Attendees by setting your Attendance Limit Below', style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance == true) ? model.accentColor : model.paletteColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),

      Visibility(
        visible: state.activitySettingsForm.activityAttendance.isLimitedAttendance == true,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Container(
            width: 675,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text('Maximum Number of ${AppLocalizations.of(context)!.activityAttendanceTypeTitle}', style: TextStyle(color: model.paletteColor)),
                const SizedBox(height: 10),
                Container(
                  width: 375,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                        offset: const Offset(-10,-15),
                        isDense: true,
                        buttonElevation: 0,
                        buttonDecoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        customButton: Container(
                          decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.circular(35),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text('${context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.attendanceLimit ?? 0} ${AppLocalizations.of(context)!.activityAttendanceTypeTitle}', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: model.disabledTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onChanged: (Object? navItem) {
                        },
                        buttonWidth: 80,
                        buttonHeight: 70,
                        dropdownElevation: 1,
                        dropdownPadding: const EdgeInsets.all(1),
                        dropdownDecoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                                color: Colors.black.withOpacity(0.11),
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: Offset(0, 2)
                            )
                            ],
                            color: model.cardColor,
                            borderRadius: BorderRadius.circular(14)),
                        itemHeight: 50,
                        // dropdownWidth: (widget.model.mainContentWidth)! - 100,
                        focusColor: Colors.grey.shade100,
                        items: [for(var i=0; i<100; i+=1) i].where((element) => element != 0).map(
                                (e) => DropdownMenuItem<int>(
                                onTap: () {
                                  attendanceLimitChanged(e);
                                },
                                value: e,
                                child: Text('$e ${AppLocalizations.of(context)!.activityAttendanceTypeTitle}', style: TextStyle(color: model.disabledTextColor)
                                )
                            )
                        ).toList()
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),

      InkWell(
        onTap: () {
          didChangeIsTicketBased();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: (state.activitySettingsForm.activityAttendance.isTicketBased == true) ? model.paletteColor :  model.webBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.airplane_ticket_rounded, size: 40, color: (state.activitySettingsForm.activityAttendance.isTicketBased == true) ? model.accentColor : model.paletteColor),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicket1, style: TextStyle(color: (state.activitySettingsForm.activityAttendance.isTicketBased == true) ? model.accentColor : model.paletteColor , fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                      Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendanceTicketDes, style: TextStyle(color: (state.activitySettingsForm.activityAttendance.isTicketBased == true) ? model.accentColor : model.paletteColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      const SizedBox(height: 10),

      InkWell(
        onTap: () {
          didChangeIsPassBased();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: (state.activitySettingsForm.activityAttendance.isPassBased == true) ? model.paletteColor :  model.webBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.credit_card_rounded, size: 40, color: (state.activitySettingsForm.activityAttendance.isPassBased == true) ? model.accentColor : model.paletteColor),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendancePasses1, style: TextStyle(color: (state.activitySettingsForm.activityAttendance.isPassBased == true) ? model.accentColor : model.paletteColor , fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                      Text(AppLocalizations.of(context)!.activityCreatorFormNavAttendancePassesDes, style: TextStyle(color: (state.activitySettingsForm.activityAttendance.isPassBased == true) ? model.accentColor : model.paletteColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),


    ]
  );
}