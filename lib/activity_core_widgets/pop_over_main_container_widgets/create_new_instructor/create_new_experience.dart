part of check_in_presentation;

class CreateNewExperienceForm extends StatefulWidget {

  final ExperienceOption experienceOption;
  final DashboardModel model;
  final Function(ExperienceOption) savedExperience;

  const CreateNewExperienceForm({Key? key, required this.experienceOption, required this.model, required this.savedExperience}) : super(key: key);

  @override
  State<CreateNewExperienceForm> createState() => _CreateNewExperienceFormState();
}

class _CreateNewExperienceFormState extends State<CreateNewExperienceForm> {

  TextEditingController experienceTextController = TextEditingController();
  DateRangePickerController dateController = DateRangePickerController();
  late ExperienceOption? experience;

  @override
  void initState() {
    // TODO: implement initState
    experience = widget.experienceOption;
    experienceTextController.text = experience!.experienceTitle.value.fold(
            (l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (e) => e.failedValue, empty: (e) => e.failedValue, orElse: () => '') ?? '', orElse: () => ''),
            (r) => r) ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
        title: Text('Add Your Instructors Experience'),
        toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [
          Column(
            children: [
              SizedBox(height: 30),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.cancel_outlined, color: widget.model.paletteColor, size: 40),
                padding: EdgeInsets.all(1),
              ),
            ],
          ),
          SizedBox(width: 40)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 95,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.facilityAvailableBookingsStarting, style: TextStyle(color: widget.model.paletteColor)),
                            SizedBox(height: 25),
                            Container(
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                          return widget.model.paletteColor.withOpacity(0.1);
                                        }
                                        if (states.contains(MaterialState.hovered)) {
                                          return widget.model.paletteColor.withOpacity(0.1);
                                        }
                                        return widget.model.accentColor; // Use the component's default.
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                        )
                                    )
                                ),
                                onPressed: () {
                                  setState(() {
                                    showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        barrierColor: widget.model.disabledTextColor.withOpacity(0.3),
                                        builder: (BuildContext contexts) {
                                          return AlertDialog(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(25)),
                                            ),
                                            backgroundColor: widget.model.webBackgroundColor,
                                            content: Container(
                                              height: 500,
                                              width: 500,
                                              child: SfDateRangePicker(
                                                initialSelectedRange: PickerDateRange(experience!.experiencePeriod.start, experience!.experiencePeriod.end),
                                                navigationMode: DateRangePickerNavigationMode.snap,
                                                view: DateRangePickerView.decade,
                                                allowViewNavigation: false,
                                                enableMultiView: true,
                                                enablePastDates: true,
                                                showNavigationArrow: true,
                                                showTodayButton: true,
                                                selectionMode: DateRangePickerSelectionMode.range,
                                                todayHighlightColor: widget.model.paletteColor,
                                                rangeTextStyle: TextStyle(
                                                    color: widget.model.paletteColor.withOpacity(0.7)),
                                                selectionTextStyle: TextStyle(
                                                    color: widget.model.accentColor,
                                                    fontWeight: FontWeight.bold),
                                                onSelectionChanged: (
                                                    DateRangePickerSelectionChangedArgs args) {


                                                  if (args.value != null) {
                                                  if (args.value is PickerDateRange) {
                                                    final DateTime rangeStartDate = args.value.startDate;
                                                    final DateTime rangeEndDate = args.value.endDate;

                                                    setState(() {

                                                      experience = experience?.copyWith(
                                                        experiencePeriod: DateTimeRange(start: rangeStartDate, end: rangeEndDate),
                                                      );

                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        });
                                  });
                                },
                                child: Row(
                                  children: [
                                    Expanded(child: Text(DateFormat.y().format(experience!.experiencePeriod.start), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                                    Icon(Icons.calendar_today_rounded, color: widget.model.paletteColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        width: 95,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context)!.facilityAvailableBookingsEnding, style: TextStyle(color: widget.model.paletteColor)),
                            SizedBox(height: 25),
                            Container(
                              height: 50,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                          return widget.model.paletteColor.withOpacity(0.1);
                                        }
                                        if (states.contains(MaterialState.hovered)) {
                                          return widget.model.paletteColor.withOpacity(0.1);
                                        }
                                        return widget.model.accentColor; // Use the component's default.
                                      },
                                    ),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                        )
                                    )
                                ),
                                onPressed: () {
                                  setState(() {

                                    showDialog(
                                        context: context,
                                        barrierColor: widget.model.disabledTextColor.withOpacity(0.3),
                                        builder: (BuildContext contexts) {
                                          return AlertDialog(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(25)),
                                            ),
                                            backgroundColor: widget.model.webBackgroundColor,
                                            content: Container(
                                              height: 500,
                                              width: 500,
                                              child: SfDateRangePicker(
                                                initialSelectedRange: PickerDateRange(experience!.experiencePeriod.start, experience!.experiencePeriod.end),
                                                navigationMode: DateRangePickerNavigationMode.snap,
                                                view: DateRangePickerView.decade,
                                                allowViewNavigation: false,
                                                enableMultiView: true,
                                                enablePastDates: true,
                                                showNavigationArrow: true,
                                                showTodayButton: true,
                                                selectionMode: DateRangePickerSelectionMode.range,
                                                todayHighlightColor: widget.model.paletteColor,
                                                rangeTextStyle: TextStyle(color: widget.model.paletteColor.withOpacity(0.7)),
                                                selectionTextStyle: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold),
                                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {




                                                  if (args.value != null) {
                                                  if (args.value is PickerDateRange) {
                                                    final DateTime rangeStartDate = args.value.startDate;
                                                    final DateTime rangeEndDate = args.value.endDate;

                                                    setState(() {
                                                      experience = experience?.copyWith(
                                                        experiencePeriod: DateTimeRange(start: rangeStartDate, end: rangeEndDate),
                                                        );
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        });

                                  });
                                },
                                child: Row(
                                  children: [
                                    Expanded(child: Text(DateFormat.y().format(experience!.experiencePeriod.end), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                                    Icon(Icons.calendar_today_rounded, color: widget.model.paletteColor),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name of Experience', style: TextStyle(color: widget.model.paletteColor)),
                            SizedBox(height: 15),
                            getDescriptionTextField(
                                context,
                                widget.model,
                                experienceTextController,
                                '',
                                1,
                                32,
                                updateText: (value) {

                                  setState(() {
                                    experience = experience?.copyWith(
                                        experienceTitle: FirstLastName(value)
                                    );
                                  });

                                }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),


                ],
              ),
            ),



            InkWell(
              onTap: () {
                if (experience?.experienceTitle.isValid() ?? false) {
                  Navigator.of(context).pop();
                  widget.savedExperience(experience!);
                } else {
                  final snackBar = SnackBar(
                      elevation: 4,
                      backgroundColor: widget.model.paletteColor,
                      content: Text('Sorry, Please change Name of Experience or Achievement', style: TextStyle(color: widget.model.webBackgroundColor))
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                width: 675,
                height: 60,
                decoration: BoxDecoration(
                  color: widget.model.webBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                child: Align(
                  child: Text('Save Experience', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
        ),
      ),
    );
  }
}