part of check_in_presentation;

class CompleteTaskAnimationWidget extends StatefulWidget {

  final DashboardModel model;

  const CompleteTaskAnimationWidget({super.key, required this.model});

  @override
  State<CompleteTaskAnimationWidget> createState() => _CompleteTaskAnimationWidgetState();
}

class _CompleteTaskAnimationWidgetState extends State<CompleteTaskAnimationWidget> {

  late ConfettiController _controllerCenter;


  @override
  void initState() {
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerCenter.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: -pi / 2,
            emissionFrequency: 0.01,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 80,
            gravity: 0.3,// don't specify a direction, blast randomly
            shouldLoop: true, // start again as soon as the animation is finished
            colors: [
              widget.model.paletteColor,
              widget.model.paletteColor.withOpacity(0.7),
              widget.model.paletteColor.withOpacity(0.4),
              widget.model.paletteColor.withOpacity(0.2),
            ], //
            createParticlePath: drawStar,// manually specify the colors to be used
            // define a custom shape/path.
          ),
        ),
      ]
    );
  }
}