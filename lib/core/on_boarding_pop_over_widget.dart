part of check_in_presentation;

class OnBoardingPopOverWidget extends StatefulWidget {

  final DashboardModel model;
  final double width;
  final double height;
  final Widget popOverWidget;

  const OnBoardingPopOverWidget({super.key, required this.popOverWidget, required this.model, required this.width, required this.height});

  @override
  State<OnBoardingPopOverWidget> createState() => _OnBoardingPopOverWidgetState();
}

class _OnBoardingPopOverWidgetState extends State<OnBoardingPopOverWidget> {

  late bool isOpen = false;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0, milliseconds: 150), () {
      setState(() {
        isOpen = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: isOpen ? 1 : 0,
          duration: const Duration(seconds: 1, milliseconds: 400),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.black.withOpacity(0.25),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
        ),
        AnimatedContainer(
          width: isOpen ? widget.width : 0,
          height: isOpen ? widget.height : 0,
          constraints: BoxConstraints(maxWidth: 600),
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: widget.model.webBackgroundColor,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: isOpen ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: widget.height,
              constraints: BoxConstraints(maxWidth: widget.width),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: widget.popOverWidget
              ),
            ),
          ),
        ),
      ],
    );
  }
}