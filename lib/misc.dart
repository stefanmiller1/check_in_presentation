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