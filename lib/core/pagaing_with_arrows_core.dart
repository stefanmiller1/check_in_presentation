part of check_in_presentation;

class PagingWithArrowsCoreWidget extends StatefulWidget {

  final double height;
  final DashboardModel model;
  final Widget pagingWidget;
  final Function() didSelectBack;
  final Function() didSelectForward;

  const PagingWithArrowsCoreWidget({super.key, required this.height, required this.model, required this.pagingWidget, required this.didSelectBack, required this.didSelectForward});

  @override
  State<PagingWithArrowsCoreWidget> createState() => _PagingWithArrowsCoreWidgetState();
}

class _PagingWithArrowsCoreWidgetState extends State<PagingWithArrowsCoreWidget> {

  late bool showButton = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) {
        setState(() {
          showButton = true;
        });
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
      child: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            height: widget.height,
            child: widget.pagingWidget
          ),

          AnimatedOpacity(
            duration: Duration(milliseconds: 350),
            opacity: (showButton) ? 1 : 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: widget.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color:  widget.model.paletteColor,
                            border: Border.all(color: widget.model.paletteColor, width: 0.5),
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.didSelectBack();
                              // widget.pageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                            });
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.model.disabledTextColor),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: widget.model.paletteColor,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.didSelectForward();
                              // widget.pageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                            });
                          },
                          icon: Icon(Icons.arrow_forward_ios_rounded, color: widget.model.disabledTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}