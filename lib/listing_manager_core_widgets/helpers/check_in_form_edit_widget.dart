part of check_in_presentation;

class CheckInFormEditWidget extends StatefulWidget {

  final DashboardModel model;
  final CheckInSetting currentCheckInForm;
  final List<SpaceOption>? spaces;
  final List<ReservationSlotItem>? reservations;
  final Function(CheckInSetting checkIn) didSaveCheckIn;

  const CheckInFormEditWidget({Key? key, required this.model, required this.currentCheckInForm, required this.spaces, required this.didSaveCheckIn, required this.reservations}) : super(key: key);

  @override
  State<CheckInFormEditWidget> createState() => _CheckInFormEditWidgetState();
}

class _CheckInFormEditWidgetState extends State<CheckInFormEditWidget> {


  ScrollController? _scrollController;
  List<UniqueId> currentSpaceList = [];

  late StringBoolItem option1 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option2 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option3 = StringBoolItem(stringItem: '', boolItem: false);
  late StringBoolItem option4 = StringBoolItem(stringItem: '', boolItem: false);

  late TextEditingController _firstTextEditingController;
  late TextEditingController _secondTextEditingController;
  late TextEditingController _thirdTextEditingController;
  late TextEditingController _fourthTextEditingController;

  @override
  void initState() {
    _scrollController = ScrollController();

    _firstTextEditingController = TextEditingController();
    _secondTextEditingController = TextEditingController();
    _thirdTextEditingController = TextEditingController();
    _fourthTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _firstTextEditingController.dispose();
    _secondTextEditingController.dispose();
    _thirdTextEditingController.dispose();
    _fourthTextEditingController.dispose();
    super.dispose();
  }

  Widget labelContainer(int? numberOfLines, TextEditingController controller, {required Function(String) didUpdateLabel, required String hintLabel}) {
    return TextFormField(
      controller: controller,
      maxLines: numberOfLines,
      style: TextStyle(color: widget.model.paletteColor),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: widget.model.disabledTextColor),
        hintText: hintLabel,
        errorStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: widget.model.paletteColor,
        ),
        // prefixIcon: Icon(Icons.home_outlined, color: widget.model.disabledTextColor),
        // labelText: "Email",
        filled: true,
        fillColor: widget.model.accentColor,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            width: 2,
            color: widget.model.paletteColor,
          ),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: widget.model.paletteColor,
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
            color: widget.model.disabledTextColor,
            width: 0,
          ),
        ),
      ),
      autocorrect: false,
      onChanged: (value) {
        didUpdateLabel(value);
      },
    );
  }

  bool isAllowedToSave(CheckInSetting setting) {
    return setting.listOfConfirmationItems.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
      automaticallyImplyLeading: false,
      titleTextStyle: TextStyle(color: widget.model.paletteColor),
      title: Text('Create A New Check In Form: Anyone with a reservation will need to fill out this form before confirming their attendance'),
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
      body: BlocProvider(create: (context) => getIt<CustomCheckInFormBloc>()..add(CustomCheckInFormEvent.initialCheckInForm(dart.optionOf(widget.currentCheckInForm))),
        child: BlocConsumer<CustomCheckInFormBloc, CustomCheckInFormState>(
          listener: (context, state) {

          },
          buildWhen: (p,c) => p.customCheckInSetting != c.customCheckInSetting,
          builder: (context, state) {

            return Container(
              width: 600,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select How Much Time Before Your Check-In Window Closes', style: TextStyle(
                        fontSize: widget.model.secondaryQuestionTitleFontSize,
                        color: widget.model.disabledTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 130,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                    // offset: const Offset(-10,-15),
                                    isDense: true,
                                    // buttonElevation: 0,
                                    // buttonDecoration: BoxDecoration(
                                    //   color: Colors.transparent,
                                    //   borderRadius: BorderRadius.circular(35),
                                    // ),
                                    customButton: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: widget.model.accentColor,
                                        border: Border.all(color: widget.model.disabledTextColor),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text((state.customCheckInSetting.hoursBefore.hour != 0 && state.customCheckInSetting.hoursBefore.minute == 0) ? '${state.customCheckInSetting.hoursBefore.hour}h': '${state.customCheckInSetting.hoursBefore.hour}h ${state.customCheckInSetting.hoursBefore.minute}min', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.normal),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.keyboard_arrow_down_rounded, color: widget.model.paletteColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onChanged: (Object? navItem) {
                                    },
                                    // buttonWidth: 80,
                                    // buttonHeight: 70,
                                    // dropdownElevation: 1,
                                    // dropdownPadding: const EdgeInsets.all(1),
                                    // dropdownDecoration: BoxDecoration(
                                    //     boxShadow: [BoxShadow(
                                    //         color: Colors.black.withOpacity(0.07),
                                    //         spreadRadius: 1,
                                    //         blurRadius: 15,
                                    //         offset: Offset(0, 2)
                                    //     )
                                    //     ],
                                    //     color: widget.model.accentColor,
                                    //     border: Border.all(color: widget.model.disabledTextColor),
                                    //     borderRadius: BorderRadius.circular(20)),
                                    // itemHeight: 50,
                                    // // dropdownWidth: mainWidth,
                                    // focusColor: Colors.grey.shade100,
                                    items: twentyFourHourInterval(TimeOfDay(hour: 0, minute: 30)).map(
                                            (e) { return DropdownMenuItem<TimeOfDay>(
                                              onTap: () {
                                                  setState(() {
                                                    context.read<CustomCheckInFormBloc>().add(CustomCheckInFormEvent.hoursBeforeChanged(e));
                                                  });
                                              },
                                              value: e,
                                              child: Text((e.hour != 0 && e.minute == 0) ? '${e.hour}h': '${e.hour}h ${e.minute}min', style: TextStyle(color: widget.model.disabledTextColor))
                                          );
                                        }
                                    ).toList()
                                )
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Before Reservation Starts', style: TextStyle(
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            color: widget.model.disabledTextColor,
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: 25),
                      Text('Select How Much Time Until Your Check-In Window Closes', style: TextStyle(
                        fontSize: widget.model.secondaryQuestionTitleFontSize,
                        color: widget.model.disabledTextColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 130,
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                    // offset: const Offset(-10,-15),
                                    isDense: true,
                                    // buttonElevation: 0,
                                    // buttonDecoration: BoxDecoration(
                                    //   color: Colors.transparent,
                                    //   borderRadius: BorderRadius.circular(35),
                                    // ),
                                    customButton: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: widget.model.accentColor,
                                        border: Border.all(color: widget.model.disabledTextColor),
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text((state.customCheckInSetting.hoursUntil.hour != 0 && state.customCheckInSetting.hoursUntil.minute == 0) ? '${state.customCheckInSetting.hoursUntil.hour}h': '${state.customCheckInSetting.hoursUntil.hour}h ${state.customCheckInSetting.hoursUntil.minute}min', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.normal),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.keyboard_arrow_down_rounded, color: widget.model.paletteColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onChanged: (Object? navItem) {
                                    },
                                    // buttonWidth: 80,
                                    // buttonHeight: 70,
                                    // dropdownElevation: 1,
                                    // dropdownPadding: const EdgeInsets.all(1),
                                    // dropdownDecoration: BoxDecoration(
                                    //     boxShadow: [BoxShadow(
                                    //         color: Colors.black.withOpacity(0.07),
                                    //         spreadRadius: 1,
                                    //         blurRadius: 15,
                                    //         offset: Offset(0, 2)
                                    //     )
                                    //     ],
                                    //     color: widget.model.accentColor,
                                    //     border: Border.all(color: widget.model.disabledTextColor),
                                    //     borderRadius: BorderRadius.circular(20)),
                                    // itemHeight: 50,
                                    // // dropdownWidth: mainWidth,
                                    // focusColor: Colors.grey.shade100,
                                    items: twentyFourHourInterval(TimeOfDay(hour: 0, minute: 30)).map(
                                            (e) {
                                          return DropdownMenuItem<TimeOfDay>(
                                              onTap: () {
                                                setState(() {
                                                  context.read<CustomCheckInFormBloc>().add(CustomCheckInFormEvent.hoursUntilChanged(e));
                                                });
                                              },
                                              value: e,
                                              child: Text((e.hour != 0 && e.minute == 0) ? '${e.hour}h': '${e.hour}h ${e.minute}min', style: TextStyle(color: widget.model.disabledTextColor))
                                          );
                                        }
                                    ).toList()
                                )
                            ),
                          ),
                          SizedBox(width: 10),
                          Text('Until Reservation Ends', style: TextStyle(
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                            color: widget.model.disabledTextColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 25),

                      Text('Select Spaces that this Check-In Form Will be applied to', style: TextStyle(
                        fontSize: widget.model.secondaryQuestionTitleFontSize,
                        color: widget.model.disabledTextColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (widget.spaces != null) multiSelectionHeader(
                          context,
                          widget.model,
                          state.customCheckInSetting.listOfSpaceIds ?? [],
                          widget.spaces!,
                          didSelectSpaces: (space) {
                            setState(() {
                              if (currentSpaceList.contains(space.spaceId)) {
                                currentSpaceList.remove(space.spaceId);
                              } else {
                                currentSpaceList.add(space.spaceId);
                              }
                              context.read<CustomCheckInFormBloc>().add(CustomCheckInFormEvent.listOfSpaceIdsChanged(currentSpaceList));
                          });
                        }
                      ),

                      SizedBox(height: 25),
                      Text('Create Confirmations:', style: TextStyle(
                        fontSize: widget.model.secondaryQuestionTitleFontSize,
                        color: widget.model.disabledTextColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Before Checking In require these items be check-ed off before Check-In can be completed', style: TextStyle(
                        color: widget.model.disabledTextColor,
                        ),
                      ),
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: labelContainer(
                                null,
                                _firstTextEditingController,
                                hintLabel: 'I Have No Covid Symptoms',
                                didUpdateLabel: (e) {

                                  setState(() {
                                    option1 = option1.copyWith(
                                        stringItem: e
                                    );
                                    List<StringBoolItem> selectionOptions = [option1, option2, option3, option4];
                                    context.read<CustomCheckInFormBloc>()..add(CustomCheckInFormEvent.listOfConfirmationItemsChanged(selectionOptions));
                                  });
                                }),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: labelContainer(
                                null,
                                _secondTextEditingController,
                                hintLabel: 'I Will Not Use Outdoor Running Shoes',
                                didUpdateLabel: (e) {
                                  setState(() {
                                    option2 = option2.copyWith(
                                        stringItem: e
                                    );
                                    List<StringBoolItem> selectionOptions = [option1, option2, option3, option4];
                                    context.read<CustomCheckInFormBloc>()..add(CustomCheckInFormEvent.listOfConfirmationItemsChanged(selectionOptions));
                                  });
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: labelContainer(
                                null,
                                _thirdTextEditingController,
                                hintLabel: 'I Have Tested For Covid Within The Last 14-Days',
                                didUpdateLabel: (e) {
                                  setState(() {
                                    option3 = option3.copyWith(
                                        stringItem: e
                                    );
                                    List<StringBoolItem> selectionOptions = [option1, option2, option3, option4];
                                    context.read<CustomCheckInFormBloc>()..add(CustomCheckInFormEvent.listOfConfirmationItemsChanged(selectionOptions));
                                  });
                                }),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: labelContainer(
                                null,
                                _fourthTextEditingController,
                                hintLabel: '...',
                                didUpdateLabel: (e) {
                                  setState(() {
                                    option4 = option4.copyWith(
                                        stringItem: e
                                    );
                                    List<StringBoolItem> selectionOptions = [option1, option2, option3, option4];
                                    context.read<CustomCheckInFormBloc>()..add(CustomCheckInFormEvent.listOfConfirmationItemsChanged(selectionOptions));
                                  });
                                }),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      SizedBox(height: 25),
                      Visibility(
                        visible: state.customCheckInSetting.listOfConfirmationItems.isNotEmpty,
                        child: widgetForCheckInPreview(context, widget.model, state.customCheckInSetting),
                      ),
                      SizedBox(height: 25),
                      Container(
                        height: 60,
                        child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected) &&
                                      states.contains(MaterialState.pressed) &&
                                      states.contains(MaterialState.focused)) {
                                    return widget.model.paletteColor.withOpacity(0.1);
                                  }
                                  if (states.contains(MaterialState.hovered)) {
                                    return widget.model.webBackgroundColor.withOpacity(
                                        0.95);
                                  }
                                  return widget.model.webBackgroundColor;
                                },
                              ),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                                ),
                              ),
                            ),
                            onPressed: () {

                              if (isAllowedToSave(state.customCheckInSetting)) {
                                widget.didSaveCheckIn(state.customCheckInSetting);
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Save Changes', style: TextStyle(color: isAllowedToSave(state.customCheckInSetting) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                            )
                        ),
                      ),
                      SizedBox(height: 50),

                    ],
                  ),
                ),
              ),
            );
          }
        ),

      ),


    );
  }
}