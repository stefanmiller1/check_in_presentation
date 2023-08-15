part of check_in_presentation;

class CounterBadge extends StatelessWidget {

  final DashboardModel model;

  const CounterBadge({
    Key? key,
    required this.count,
    required this.model,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
          color: model.paletteColor, borderRadius: BorderRadius.circular(9)),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: model.accentColor,
        ),
      ),
    );
  }
}