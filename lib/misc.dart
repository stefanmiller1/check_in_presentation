part of check_in_presentation;

Widget progressOverlay(DashboardModel model) {
  return Padding(padding: const EdgeInsets.all(8),
      child: Center(
          child: CircularProgressIndicator(
            backgroundColor: model.accentColor,
            valueColor:AlwaysStoppedAnimation<Color>(model.paletteColor),
          )
      )
  );
}

Widget somethingWentWrongError(BuildContext context, DashboardModel model) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    child: Column(
      children: [
        SizedBox(height: 150),
        Text('¯|_(ツ)_/¯', style: TextStyle(fontSize: 40)),
        Text('Sorry, something went wrong.')
      ],
    ),
  );
}

class ContainerPatternPainter extends CustomPainter {

  final Color model;
  final Color? bColor;

  ContainerPatternPainter({this.bColor, required this.model});

  @override
  void paint(Canvas canvas, Size size) {
    DiagonalStripesLight(bgColor: bColor ?? Colors.transparent, fgColor: model, featuresCount: 20).paintOnWidget(canvas, size, patternScaleBehavior: PatternScaleBehavior.container);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


final _emailMaskRegExp = RegExp('^(.)(.*?)([^@]?)(?=@[^@]+\$)');
String maskEmail(String input, [int minFill = 4, String fillChar = '*']) {
  minFill ??= 4;
  fillChar ??= '*';
  return input.replaceFirstMapped(_emailMaskRegExp, (m) {
    if (m.group(2) != null && m.group(1) != null) {
      var start = m.group(1);
      var middle = fillChar * max(minFill, m.group(2)!.length);
      var end = m.groupCount >= 3 ? m.group(3) : start;
      return start! + middle + end!;
    } else {
      return input;
    }
  });
}

String maskPhone(String number) {
  return number.replaceRange(3, 7, '****');
}


TextFormField getDescriptionTextField(BuildContext context, DashboardModel model, TextEditingController controller, String? validator, int? maxLine, int? maxLength, {required Function(String input) updateText}) {
  return TextFormField(
    maxLength: maxLength,
    maxLines: maxLine,
    style: TextStyle(color: model.paletteColor),
    onChanged: (value) {
      updateText(value);
    },
    controller: controller,
    decoration: InputDecoration(
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.disabledTextColor,
        ),
      ),
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: model.disabledTextColor,
      ),
      filled: true,
      fillColor: model.accentColor,
      focusedBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.paletteColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.disabledTextColor,
          width: 5,
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
    // validator: (e) => validator,
  );
}


Widget getTimeSlotAmount(String costTimeSlot, String costPerSlot, String costingEstimate, BuildContext context, bool isVisible, bool showHelp, DashboardModel model, TextEditingController controller, {required Function(String input) updateTextNow}) {
  return Visibility(
    visible: isVisible,
    child: Container(
      width: 235,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHelp) Text(costTimeSlot, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: getTextField(
                    context,
                    model,
                    controller,
                    updateText: (e) {
                      updateTextNow(e);
                    }),
              ),
              const SizedBox(width: 10),
              Text(costPerSlot, style: TextStyle(color: model.paletteColor)),
            ],
          ),
          const SizedBox(height: 5),
          if (showHelp) Text(costingEstimate, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
        ],
      ),
    ),
  );
}



TextFormField getTextField(BuildContext context, DashboardModel model, TextEditingController controller, {required Function(String input) updateText}) {

  return TextFormField(
    style: TextStyle(color: model.paletteColor),
    onChanged: (value) {
      updateText(value);
    },
    controller: controller,
    keyboardType: TextInputType.number,
    // inputFormatters: [FilteringTextInputFormatter.digitsOnly, CurrencyInputFormatter()],
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    decoration: InputDecoration(
      hintText: "\$0.00",
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.disabledTextColor,
        ),
      ),
      errorStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: model.disabledTextColor,
      ),
      filled: true,
      fillColor: model.accentColor,
      focusedBorder:  OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.paletteColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: model.disabledTextColor,
          width: 5,
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
    // validator: (e) => validator,
  );
}