part of check_in_presentation;

String getUrlForActivity(String facilityId, String resId) => (kIsWeb) ? Uri.base.origin + searchedReservationRoute(facilityId, resId) : 'https://cincout.ca${searchedReservationRoute(facilityId, resId)}';

Widget mainContainerForVisibilitySettings({required BuildContext context, required DashboardModel model, required ReservationItem reservation, required ActivityManagerForm activityForm, required Function() isPrivateOnly, required Function() createPrivateList, required Function() isInviteOnly, required Function() isReviewRequired}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Change The Visibility of Your Activity', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ),
      const SizedBox(height: 10),
      ShareActivityUrlWidget(
        url: getUrlForActivity(reservation.instanceId.getOrCrash(), reservation.reservationId.getOrCrash()),
        model: model,
        isInviteOnly: activityForm.rulesService.accessVisibilitySetting.isInviteOnly == true,
        isPrivate: activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Text('Private Activity (Login Required, Based On Specific List that you Invited)', style: TextStyle(
            fontSize: model.secondaryQuestionTitleFontSize,
            color: model.disabledTextColor,
          ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 675,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Set Activity to Private Invite Only', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))),
                FlutterSwitch(
                  width: 60,
                  inactiveColor: model.accentColor,
                  activeColor: model.paletteColor,
                  value: activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true,
                  onToggle: (value) {
                    isPrivateOnly();
                  },
                )
              ],
            ),
          ),

          // Visibility(
          //   visible: activityForm.rulesService.accessVisibilitySetting.isPrivateOnly == true,
          //   child: Container(
          //     width: 675,
          //     child: Column(
          //       children: [
          //         SizedBox(height: 25),
          //         Text('Private List Name', style: TextStyle(
          //           fontSize: model.secondaryQuestionTitleFontSize,
          //           color: model.disabledTextColor,
          //         ),
          //         ),
          //         const SizedBox(height: 10),
          //
          //         Container(
          //           height: 60,
          //           child: TextButton(
          //               style: ButtonStyle(
          //                   backgroundColor: MaterialStateProperty.resolveWith<Color>(
          //                         (Set<MaterialState> states) {
          //                       if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
          //                         return model.paletteColor.withOpacity(0.1);
          //                       }
          //                       if (states.contains(MaterialState.hovered)) {
          //                         return model.paletteColor.withOpacity(0.1);
          //                       }
          //                       return model.webBackgroundColor; // Use the component's default.
          //                     },
          //                   ),
          //                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //                       RoundedRectangleBorder(
          //                         borderRadius: const BorderRadius.all(Radius.circular(15)),
          //                       )
          //                   )
          //               ),
          //               onPressed: () {
          //                 createPrivateList();
          //               },
          //               child: Align(
          //                 alignment: Alignment.center,
          //                 child: Text('Create Private List',
          //                   style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), textAlign: TextAlign.center,
          //                 ),
          //               )
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),


          SizedBox(height: 25),
          Text('Invite Only', style: TextStyle(
            fontSize: model.secondaryQuestionTitleFontSize,
            color: model.disabledTextColor,
          ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 675,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Set Activity to Invite Only', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))),
                FlutterSwitch(
                  width: 60,
                  inactiveColor: model.accentColor,
                  activeColor: model.paletteColor,
                  value: activityForm.rulesService.accessVisibilitySetting.isInviteOnly == true,
                  onToggle: (value) {
                    isInviteOnly();
                  },
                )
              ],
            ),
          ),

          const SizedBox(height: 25),
          Text('Review Attendees Before Accepting', style: TextStyle(
            fontSize: model.secondaryQuestionTitleFontSize,
            color: model.disabledTextColor,
          ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 675,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Require all Attendees be reviewed by you before accepting each Participant', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,))),
                FlutterSwitch(
                  width: 60,
                  inactiveColor: model.accentColor,
                  activeColor: model.paletteColor,
                  value: activityForm.rulesService.accessVisibilitySetting.isReviewRequired == true,
                  onToggle: (value) {
                    isReviewRequired();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ]
  );
}