part of check_in_presentation;


class AnimatedBorderButton extends StatelessWidget {

  final String buttonText;
  final bool isActivated;
  final DashboardModel model;
  final Function() didSelectButton;

  const AnimatedBorderButton({super.key, required this.buttonText, required this.isActivated, required this.model, required this.didSelectButton});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isActivated,
      child: InkWell(
        onTap: () {
          didSelectButton();
        },
        child: AnimatedGradientBorder(
          borderSize: (isActivated) ? 5 : 0,
          glowSize: (isActivated) ? 2 : 0,
          gradientColors: const [
            // Color.fromRGBO(0, 0, 0, 1.0),
            Color.fromRGBO(202, 137, 255, 1.0),
            Color.fromRGBO(255, 61, 106, 1.0),
            Color.fromRGBO(60, 11, 206, 1.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(999)),
          child: Container(
            // constraints: const BoxConstraints(maxWidth: 200),
            height: 45,
            // width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(999)),
                border: (isActivated) ? null : Border.all(color: model.disabledTextColor, width: 1),
                color: (isActivated) ? model.paletteColor : model.webBackgroundColor
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buttonText, style: TextStyle(color: (isActivated) ? model.accentColor : model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}