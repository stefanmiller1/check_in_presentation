part of check_in_presentation;

class CancellationEditFeeWidget extends StatefulWidget {

  final DashboardModel model;
  final Function(FeeBasedCancellation fee) didUpdateFee;

  const CancellationEditFeeWidget({Key? key, required this.model, required this.didUpdateFee}) : super(key: key);

  @override
  State<CancellationEditFeeWidget> createState() => _CancellationEditFeeWidgetState();
}

class _CancellationEditFeeWidgetState extends State<CancellationEditFeeWidget> {

  TextEditingController? _percentageController1;
  TextEditingController? _daysController1;
  late FeeBasedCancellation _feeBasedCancellation = FeeBasedCancellation(percentage: 0, daysBeforeStart: 0);

  @override
  void initState() {
    _percentageController1 = TextEditingController();
    _daysController1 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _percentageController1?.dispose();
    _daysController1?.dispose();
    super.dispose();
  }

  bool canSaveChanges() {
    return (_feeBasedCancellation.percentage != 0) && (_feeBasedCancellation.daysBeforeStart != 0);
  }

  @override
  Widget build(BuildContext context) {
    final double widthForFrame = 500;

    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
        title: Text('Edit Details About Your Cancellation Fees'),
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
      body: Container(
        width: widthForFrame,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Row(
                children: [
                  Column(
                    children: [
                      Text('Percentage Kept', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      SizedBox(height: 5),
                      Container(
                        width: 180,
                        child: TextFormField(
                          maxLength: 2,
                          style: TextStyle(color: widget.model.paletteColor),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: widget.model.disabledTextColor),
                            hintText: '50 %',
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: widget.model.paletteColor,
                            ),
                            // prefixIcon: Icon(Icons.percent_rounded, color: widget.model.disabledTextColor),
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
                            setState(() {
                              _feeBasedCancellation = _feeBasedCancellation.copyWith(
                                percentage: int.parse(value)
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    children: [
                      Text('Days Before Reservation', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      SizedBox(height: 5),
                      Container(
                        width: 180,
                        child: TextFormField(
                          maxLength: 2,
                          style: TextStyle(color: widget.model.paletteColor),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: widget.model.disabledTextColor),
                            hintText: '4',
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: widget.model.paletteColor,
                            ),
                            // prefixIcon: Icon(Icons.percent_rounded, color: widget.model.disabledTextColor),
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
                            setState(() {
                              _feeBasedCancellation = _feeBasedCancellation.copyWith(
                                  daysBeforeStart: int.parse(value)
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: 15),
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
                      if (canSaveChanges()) {
                        widget.didUpdateFee(_feeBasedCancellation);

                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Save Changes', style: TextStyle(color: canSaveChanges() ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class CancellationEditTimeWidget extends StatefulWidget {

  final DashboardModel model;
  final Function(TimeBasedCancellation fee) didUpdateFee;

  const CancellationEditTimeWidget({Key? key, required this.model, required this.didUpdateFee}) : super(key: key);

  @override
  State<CancellationEditTimeWidget> createState() => _CancellationEditTimeWidgetState();
}

class _CancellationEditTimeWidgetState extends State<CancellationEditTimeWidget> {

  TextEditingController? _intervalDurationController1;
  late TimeBasedCancellation _timeBasedCancellation = TimeBasedCancellation(intervalDuration: 0);

  @override
  void initState() {
    _intervalDurationController1 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _intervalDurationController1?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double widthForFrame = 500;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: TextStyle(color: widget.model.paletteColor),
        title: Text('Edit Details About When a Reservation can be cancelled Before Starting'),
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
      body: Container(
        width: widthForFrame,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Text('Days Before Reservation', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              SizedBox(height: 5),
              Container(
                width: 180,
                child: TextFormField(
                  maxLength: 2,
                  style: TextStyle(color: widget.model.paletteColor),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: widget.model.disabledTextColor),
                    hintText: '4',
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: widget.model.paletteColor,
                    ),
                    // prefixIcon: Icon(Icons.percent_rounded, color: widget.model.disabledTextColor),
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
                    setState(() {
                      _timeBasedCancellation = _timeBasedCancellation.copyWith(
                        intervalDuration: int.parse(value)
                      );
                    });
                  },
                ),
              ),

              SizedBox(height: 15),
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
                      if (_timeBasedCancellation.intervalDuration != 0) {
                        widget.didUpdateFee(_timeBasedCancellation);

                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Save Changes', style: TextStyle(color: (_timeBasedCancellation.intervalDuration != 0) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}