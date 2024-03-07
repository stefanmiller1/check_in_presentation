part of check_in_presentation;

Widget instructorEditorContainer({required BuildContext context, required DashboardModel model, required ClassesInstructorProfile classInstructorBackground, required Function(int) didChangeNumberOfYears, required Function(ExperienceOption experience, int index) didSelectExperience, required Function(int) didSelectRemoveExperience, required Function() didSelectCreateExperience, required Function(CertificateOption) didSelectCertificate, required Function(int) didSelectRemoveCertificate, required Function() didCreateNewCertificate}) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle_outlined, color: model.disabledTextColor,
              ),
              const SizedBox(width: 10),
              Text('Instructor Info', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
            ],
          ),
          const SizedBox(height: 25),
          Text('Experience', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesExperienceYears,
                  style: TextStyle(
                      color: model.paletteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: model.secondaryQuestionTitleFontSize), maxLines: 1,)),
              Row(
                children: [
                  QuantityButtons(
                      model: model,
                      initNumber: classInstructorBackground.numberOfYearsInExperience,
                      counterCallback: (int v) {
                        didChangeNumberOfYears(v);
                      }
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: model.paletteColor,
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      height: 35,
                      width: 60,
                      child: Center(
                        child: Text(classInstructorBackground.numberOfYearsInExperience.toString() ?? '1', style: TextStyle(color: model.disabledTextColor)
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 50),
          Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreTitle, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 20),
          /// add instructors work in terms of years and experience
          Container(
            decoration: BoxDecoration(
                color: model.accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border(
                    top: BorderSide(width: 0.5, color: model.disabledTextColor),
                    left: BorderSide(width: 0.5, color: model.disabledTextColor),
                    right: BorderSide(width: 0.5, color: model.disabledTextColor),
                    bottom: BorderSide(width: 0.5, color: model.disabledTextColor)
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // width: 230,
                          child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreYearTerm, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                        ),
                        const SizedBox(width: 100),
                        Expanded(
                          child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreExperienceName, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...classInstructorBackground.experience.toList().asMap().map((i, e) {

                    final ExperienceOption exOption = classInstructorBackground.experience.toList()[i];

                    return MapEntry(i, InkWell(
                        onTap: () {
                          didSelectExperience(exOption, i);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(DateFormat.y().format(exOption.experiencePeriod.start), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 10),
                                    Icon(Icons.calendar_today_rounded, color: model.paletteColor),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Row(children: [
                                  Text(DateFormat.y().format(exOption.experiencePeriod.end), style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 10),
                                  Icon(Icons.calendar_today_rounded, color: model.paletteColor),
                                ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          height: 50,
                                          width: 300,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(25),
                                              border: Border.all(color: model.disabledTextColor, width: 1)
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(exOption.experienceTitle.getOrCrash(), maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 15),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: Icon(Icons.clear, size: 35, color: model.paletteColor),
                                            onPressed: () {
                                              didSelectRemoveExperience(i);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              )
                            ],
                          )
                        ),
                      );
                    }
                  ).values.toList() ?? [],
                  const SizedBox(height: 25),
                  if (classInstructorBackground.experience.length <= 5) InkWell(
                    onTap: () {
                      didSelectCreateExperience();

                    },
                    child: Container(
                      width: 675,
                      height: 60,
                      decoration: BoxDecoration(
                        color: model.paletteColor,
                        borderRadius: const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Align(
                        child: Text('Add an Experience', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          /// add certificates
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Divider(
              thickness: 0.35,
              color: model.disabledTextColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: model.accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border(
                    top: BorderSide(width: 0.5, color: model.disabledTextColor),
                    left: BorderSide(width: 0.5, color: model.disabledTextColor),
                    right: BorderSide(width: 0.5, color: model.disabledTextColor),
                    bottom: BorderSide(width: 0.5, color: model.disabledTextColor)
                )
            ),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // width: 230,
                          child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreType, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                        ),
                        const SizedBox(width: 50),
                        Expanded(
                          child: Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreCertificateSub, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 1, overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    ...classInstructorBackground.certificates.toList().asMap().map((i, e) =>
                        MapEntry(i , InkWell(
                            onTap: () {
                              didSelectCertificate(e);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getCertificateName(context, e.certificateType), style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                                const SizedBox(width: 25),
                                Expanded(
                                  child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          border: Border.all(color: model.disabledTextColor, width: 1)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(e.certificateTitle.value.fold((l) => '', (r) => r))),
                                      )
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 15),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.clear, size: 35, color: model.paletteColor),
                                        onPressed: () {
                                          didSelectRemoveCertificate(i);
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ),
                        )
                    ).values.toList(),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        didCreateNewCertificate();
                      },
                      child: Container(
                        width: 675,
                        height: 60,
                        decoration: BoxDecoration(
                          color: model.paletteColor,
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Align(
                          child: Text('Add a Certificate', style: TextStyle(color: model.accentColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


void handleSelectedExperience(BuildContext context, DashboardModel model, int index, ExperienceOption exOption, {required Function(ExperienceOption experience, int index) didSelectSaveExperience}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
    barrierColor: model.disabledTextColor.withOpacity(0.34),
    transitionDuration: Duration(milliseconds: 650),
    pageBuilder: (BuildContext contexts, anim1, anim2) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                ),
                width: 550,
                height: 350,
                child: CreateNewExperienceForm(
                  experienceOption: exOption,
                  model: model,
                  savedExperience: (e) {
                    didSelectSaveExperience(e, index);
                  },
                )
            ),
          )
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
        child: child,
      );
    },
  );
}


void handleCreateNewExperience(BuildContext context, DashboardModel model, {required Function(ExperienceOption) didSelectSaveExperience}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
    barrierColor: model.disabledTextColor.withOpacity(0.34),
    transitionDuration: Duration(milliseconds: 650),
    pageBuilder: (BuildContext contexts, anim1, anim2) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                ),
                width: 550,
                height: 350,
                child: CreateNewExperienceForm(
                  experienceOption: ExperienceOption.empty(),
                  model: model,
                  savedExperience: (e) {
                    didSelectSaveExperience(e);
                  },
                )
            ),
          )
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
        child: child,
      );
    },
  );
}

void handleNewCertificate(BuildContext context, DashboardModel model, {required Function(CertificateOption) didSelectSaveCertificate}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
    barrierColor: model.disabledTextColor.withOpacity(0.34),
    transitionDuration: const Duration(milliseconds: 650),
    pageBuilder: (BuildContext contexts, anim1, anim2) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: model.accentColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                ),
                width: 550,
                height: 350,
                child: CreateNewCertificateForm(
                  certificateOption: null,
                  model: model,
                  savedCertificate: (e) {
                    didSelectSaveCertificate(e);
                  },
                )
            ),
          )
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
        child: child,
      );
    },
  );
}