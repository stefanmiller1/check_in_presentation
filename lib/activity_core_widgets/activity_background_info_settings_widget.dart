part of check_in_presentation;

Widget mainContainerForSectionOneRowOne({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function(String value) activityTitleChanged, required Function(String value) activityDescriptionChanged, required Function(String value) activityDescriptionChangedTwo, }) {
  return Container(
    width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// *** activity name *** ///
            Text('Activity Name', style: TextStyle(
              fontSize: model.secondaryQuestionTitleFontSize,
              color: model.disabledTextColor,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              maxLength: state.activitySettingsForm.profileService.activityBackground.activityTitle.maxLength,
              style: TextStyle(color: model.paletteColor),
              initialValue: state
                  .activitySettingsForm
                  .profileService
                  .activityBackground
                  .activityTitle
                  .value
                  .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: model.disabledTextColor),
                hintText: 'Activity Name',
                errorStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: model.paletteColor,
                ),
                prefixIcon: Icon(Icons.home_outlined, color: model.disabledTextColor),
                filled: true,
                fillColor: model.accentColor,
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    width: 2,
                    color: model.paletteColor,
                  ),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: model.paletteColor,
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
                    color: model.disabledTextColor,
                    width: 0,
                  ),
                ),
              ),
              autocorrect: false,
              onChanged: (value) => activityTitleChanged(value),
              validator: (_) => state
                  .activitySettingsForm
                  .profileService
                  .activityBackground
                  .activityTitle
                  .value
                  .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
            ),
            /// *** activity description *** ///
            SizedBox(height: 25),
            Text('About the Activity', style: TextStyle(
              color: model.disabledTextColor,
              fontSize: model.secondaryQuestionTitleFontSize,
              )
            ),
            const SizedBox(height: 20),
            TextFormField(
            maxLength: state.activitySettingsForm.profileService.activityBackground.activityDescription1.maxLength,
            maxLines: 8,
            initialValue: state
                .activitySettingsForm
                .profileService
                .activityBackground
                .activityDescription1
                .value
                .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                style: TextStyle(color: model.paletteColor),
                decoration: InputDecoration(
                hintStyle: TextStyle(color: model.disabledTextColor),
                hintText: 'Tell them about what\'s in store...',
                errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: model.paletteColor,
                ),
                filled: true,
                fillColor: model.accentColor,
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                    width: 2,
                    color: model.paletteColor,
                  ),
                ),
                focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                    color: model.paletteColor,
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
                      color: model.disabledTextColor,
                      width: 0,
                    ),
                  ),
                ),
                autocorrect: false,
                onChanged: (value) => activityDescriptionChanged(value),
                validator: (_) => state
                    .activitySettingsForm
                    .profileService
                    .activityBackground
                    .activityDescription1
                    .value
                    .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
                  ),
                Visibility(
                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
                  child: Column(
                  children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Icon(Icons.videogame_asset_rounded, color: model.paletteColor),
                      const SizedBox(width: 15),
                      Expanded(child: Text('Tell them more Details', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
                    ],
                  ),
                  Text(AppLocalizations.of(context)!.activityGameBackgroundSubTitle2, style: TextStyle(color: model.paletteColor)),
                  const SizedBox(height: 20),
                  TextFormField(
                  maxLength: state.activitySettingsForm.profileService.activityBackground.activityDescription2?.maxLength,
                  maxLines: 8,
                  initialValue: context.read<UpdateActivityFormBloc>().state
                      .activitySettingsForm
                      .profileService
                      .activityBackground
                      .activityDescription2
                      ?.value
                      .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                  style: TextStyle(color: model.paletteColor),
                  decoration: InputDecoration(
                  hintStyle: TextStyle(color: model.disabledTextColor),
                  hintText: 'Tell them about what\'s in store...',
                  errorStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: model.paletteColor,
                  ),
                  filled: true,
                  fillColor: model.accentColor,
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: model.paletteColor,
                    ),
                  ),
                  focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                    color: model.paletteColor,
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
                        color: model.disabledTextColor,
                        width: 0,
                      ),
                    ),
                  ),
                  autocorrect: false,
                  onChanged: (value) => activityDescriptionChangedTwo(value),
                  validator: (_) => state
                      .activitySettingsForm
                      .profileService
                      .activityBackground
                      .activityDescription2
                      ?.value
                      .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
                      ),
                    ],
                  ),
                ),
                  Visibility(
                    // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
                    child: Column(
                    children: [
                    const SizedBox(height: 25),
                    Row(
                    children: [
                        Icon(Icons.sports, color: model.paletteColor),
                        const SizedBox(width: 15),
                        Expanded(child: Text('Tell them more Details', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
                      ],
                    ),
                    Text(AppLocalizations.of(context)!.activityClassesBackgroundSubTitle2, style: TextStyle(color: model.paletteColor)),
                    const SizedBox(height: 20),
                    TextFormField(
                    maxLength: state.activitySettingsForm.profileService.activityBackground.activityDescription2?.maxLength,
                    maxLines: 8,
                    initialValue: state
                        .activitySettingsForm
                        .profileService
                        .activityBackground
                        .activityDescription2
                        ?.value
                        .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                    style: TextStyle(color: model.paletteColor),
                    decoration: InputDecoration(
                    hintStyle: TextStyle(color: model.disabledTextColor),
                    hintText: 'Tell them about what\'s in store...',
                    errorStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: model.paletteColor,
                    ),
                    filled: true,
                    fillColor: model.accentColor,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        width: 2,
                        color: model.paletteColor,
                        ),
                      ),
                    focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: model.paletteColor,
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
                      color: model.disabledTextColor,
                        width: 0,
                        ),
                      ),
                    ),
                    autocorrect: false,
                    onChanged: (value) => activityDescriptionChangedTwo(value),
                    validator: (_) => state
                        .activitySettingsForm
                        .profileService
                        .activityBackground
                        .activityDescription2
                        ?.value
                        .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
                      ),

                    ],
                  )
                ),
                Visibility(
                // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityTypeOption.experiences,
                child: Column(
                children: [
                const SizedBox(height: 25),
                Row(
                  children: [
                    Icon(Icons.map, color: model.paletteColor),
                    const SizedBox(width: 15),
                    Expanded(child: Text('Tell them more Details', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
                  ],
                ),
                Text(AppLocalizations.of(context)!.activityExperienceBackgroundSubTitle2, style: TextStyle(color: model.paletteColor)),
                const SizedBox(height: 20),
                TextFormField(
                maxLength: state.activitySettingsForm.profileService.activityBackground.activityDescription2?.maxLength,
                maxLines: 8,
                initialValue: state
                    .activitySettingsForm
                    .profileService
                    .activityBackground
                    .activityDescription2
                    ?.value
                    .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
                style: TextStyle(color: model.paletteColor),
                decoration: InputDecoration(
                hintStyle: TextStyle(color: model.disabledTextColor),
                hintText: 'Tell them about what\'s in store...',
                errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: model.paletteColor,
                ),
                filled: true,
                fillColor: model.accentColor,
                focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    width: 2,
                    color: model.paletteColor,
                  ),
                ),
                focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: model.paletteColor,
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
                  color: model.disabledTextColor,
                    width: 0,
                    ),
                  ),
                ),
                autocorrect: false,
                onChanged: (value) => activityDescriptionChangedTwo(value),
                validator: (_) => state
                    .activitySettingsForm
                    .profileService
                    .activityBackground
                    .activityDescription2
                    ?.value
                    .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
                  ),
                ],
              ),
            ),

      ],
    ),
  );
}


Widget mainContainerForSectionOneRowTwo({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function(bool) isPartnersInviteOnly, required Widget getPartnerAttendees, required Function() didSelectCreateNewPartner, required Widget getInstructorAttendees, required Function() didSelectCreateInstructor}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 25),
      /// *** partnerships *** ///
      Text('Activity Partners', style: TextStyle(
        color: model.disabledTextColor,
        fontSize: model.secondaryQuestionTitleFontSize,
        )
      ),
      const SizedBox(height: 20),
      Container(
        // width: 675,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Partners are Invite Only?', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, color: model.paletteColor,)),
                Text('otherwise any partner can request to collaborate with you', style: TextStyle(color: model.disabledTextColor))
                ],
              )
            ),

            FlutterSwitch(
              width: 60,
              inactiveColor: model.accentColor,
              activeColor: model.paletteColor,
              value: state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly ?? false,
              onToggle: (value) {
                isPartnersInviteOnly(value);
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      /// *** partner attendees *** ///
      getPartnerAttendees,
      const SizedBox(height: 25),
      InkWell(
        onTap: () {
          didSelectCreateNewPartner();
        },
        child: Container(
          width: 675,
          height: 60,
          decoration: BoxDecoration(
            color: model.webBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Align(
            child: Text('Invite New Partner', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          ),
        ),
      ),
      Visibility(
      // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                Icon(Icons.sports, color: model.paletteColor),
                const SizedBox(width: 15),
                Expanded(child: Text('About The Instructors', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize))),
              ],
            ),
            Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreYearsSub, style: TextStyle(color: model.paletteColor)),
            const SizedBox(height: 15),
            /// *** instructor attendees *** ///
            getInstructorAttendees,
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                didSelectCreateInstructor();
              },
              child: Container(
                width: 675,
                height: 60,
                decoration: BoxDecoration(
                  color: model.webBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  child: Text('Invite New Instructor', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                ),
              ),
            )

          ],
        )
      )
    ],
  );
}


Widget mainTopContainer({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state, required Function() didSelectImage, required Function(List<ImageUpload>) activityProfileImagesChanged}) {
  Widget buildItem(String text) {
    return GestureDetector(
      onTap: () {
        didSelectImage();
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: model.disabledTextColor, width: 1),
        ),
        color: Colors.transparent,
        key: ValueKey(text),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
                height: 150,
                width: 150,
                child: Icon(Icons.add_circle_rounded, color: model.disabledTextColor, size: 55))
        ),
      ),
    );
  }

  Widget buildImageItem(ImageUpload imageItem) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.transparent,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
                height: 150,
                width: 150,
                child:
                (imageItem.imageToUpload != null) ?
                Image.memory(imageItem.imageToUpload!, fit: BoxFit.cover) :
                (imageItem.uriPath != null) ?
                Image.network(imageItem.uriPath!, fit: BoxFit.cover) :
                Icon(Icons.error_outline, color: model.disabledTextColor, size: 55,)),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: 1,
                child: GestureDetector(
                  onTap: () {
                    /// in facade - if imageURI no longer exists from original images, then remove from array.
                    /// in facade - all imageToUpload[Image] images should be uploaded and removed from array.

                      late List<ImageUpload> images = [];
                      images.addAll(state.activitySettingsForm.profileService.activityBackground.activityProfileImages ?? []);

                      final index = images.indexWhere((element) => element.key == imageItem.key);
                      images.removeAt(index);

                      activityProfileImagesChanged(images);
                  },
                  child: Icon(Icons.cancel, color: model.paletteColor, size: 35),
                ),
              )
          )
        ],
      ),
    );
  }

  return Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        /// *** select/add profile images for activity *** ///
        Text('Photos/Videos', style: TextStyle(
          fontSize: model.secondaryQuestionTitleFontSize,
          color: model.disabledTextColor,
        ),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    children: ['1','2','3','4','5','6'].map((e) => buildItem(e)).toList(),
                  )
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    children: state.activitySettingsForm.profileService.activityBackground.activityProfileImages?.map((e) => buildImageItem(e)).toList() ?? [],
                  )
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text('Edit & Add an image for your Activity', style: TextStyle(
          color: model.disabledTextColor,
          ),
        ),
      ],
    ),
  );
}