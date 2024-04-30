part of check_in_presentation;


class AnimatedBorderButton extends StatefulWidget {

  final String buttonText;
  final bool isActivated;
  final DashboardModel model;
  final Function() didSelectButton;

  const AnimatedBorderButton({super.key, required this.buttonText, required this.isActivated, required this.model, required this.didSelectButton});

  @override
  State<AnimatedBorderButton> createState() => _AnimatedBorderButtonState();
}

class _AnimatedBorderButtonState extends State<AnimatedBorderButton> {

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container();
    }
    return IgnorePointer(
      ignoring: !widget.isActivated,
      child: InkWell(
        onTap: () {
          widget.didSelectButton();
        },
        child: AnimatedGradientBorder(
          borderSize: (widget.isActivated) ? 5 : 0,
          glowSize: (widget.isActivated) ? 2 : 0.1,
          gradientColors: const [
            // Color.fromRGBO(0, 0, 0, 1.0),
            Color.fromRGBO(202, 137, 255, 1.0),
            Color.fromRGBO(255, 61, 106, 1.0),
            Color.fromRGBO(60, 11, 206, 1.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(50)),
          child: Container(
            // constraints: const BoxConstraints(maxWidth: 200),
            height: 45,
            // width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: (widget.isActivated) ? null : Border.all(color: widget.model.disabledTextColor, width: 1),
                color: (widget.isActivated) ? widget.model.paletteColor : widget.model.webBackgroundColor
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.buttonText, style: TextStyle(color: (widget.isActivated) ? widget.model.accentColor : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}