part of check_in_presentation;

class FilterSelectionList extends StatefulWidget {

  final DashboardModel model;
  final List<Widget> filterItems;
  final String createTitle;
  final Function() didSelectCreateNew;

  const FilterSelectionList({Key? key, required this.filterItems, required this.didSelectCreateNew, required this.createTitle, required this.model}) : super(key: key);

  @override
  State<FilterSelectionList> createState() => _FilterSelectionListState();
}

class _FilterSelectionListState extends State<FilterSelectionList> {

  late bool showButton = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) {

      },
      onHover: (e) {
        setState(() {
          showButton = true;
        });
      },
      onExit: (e) {
        setState(() {
          showButton = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 35,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: [
            ...widget.filterItems,
            SizedBox(width: 10),
            AnimatedOpacity(
              duration: Duration(milliseconds: 350),
              opacity: (showButton) ? 1 : 0,
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                            return widget.model.disabledTextColor.withOpacity(0.25);
                          }
                          if (states.contains(MaterialState.hovered)) {
                            return widget.model.disabledTextColor.withOpacity(0.25);
                          }
                          return widget.model.accentColor.withOpacity(0.4); // Use the component's default.
                        },
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(15)),
                          )
                      )
                  ),
                  onPressed: widget.didSelectCreateNew,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.createTitle, style: TextStyle(color: widget.model.disabledTextColor),),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}