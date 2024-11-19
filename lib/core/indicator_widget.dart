part of check_in_presentation;

class Indicator extends StatelessWidget {
  Indicator({
    super.key,
    this.normalColor  = Colors.black,
    this.selectedColor = Colors.white,
    required this.controller,
    this.itemCount = 0,
  });

  final PageController controller;

  final int itemCount;

  final Color normalColor;

  final Color selectedColor;

  final double size = 8.0;

  final double spacing = 4.0;

  Widget _buildIndicator(int index, int pageCount, double dotSize, double spacing) {

    bool isCurrentPageSelected = index == (controller.page != null ? (controller.page?.round() ?? 1 % pageCount) : 0);

    return Container(
      height: size,
      width: size + (2 * spacing),
      child: Center(
        child: Material(
          color: isCurrentPageSelected ? selectedColor : normalColor,
          type: MaterialType.circle,
          child: Container(
            width: dotSize,
            height: dotSize,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, spacing);
      }),
    );
  }
}

