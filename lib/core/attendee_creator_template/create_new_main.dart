part of check_in_presentation;

class CreateNewMain extends StatefulWidget {

  final List<NewAttendeeContainerModel> child;
  final bool isLoading;
  final DashboardModel model;
  final PageController? pageController;
  final Function(int)? onPageChanged;
  final bool isPreviewer;

  const CreateNewMain({super.key, required this.child, required this.isPreviewer, this.pageController, this.onPageChanged, required this.isLoading, required this.model});

  @override
  State<CreateNewMain> createState() => _CreateNewMainState();
}

class _CreateNewMainState extends State<CreateNewMain> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [

          Container(
            child: PageView.builder(
                controller: widget.pageController,
                itemCount: widget.child.length,
                scrollDirection: Axis.horizontal,
                allowImplicitScrolling: true,
                onPageChanged: (index) {
                  if (widget.onPageChanged != null) {
                    widget.onPageChanged!(index);
                  }
                },
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {

                  Widget currentPage = widget.child[index].childWidget;

                  if (widget.isLoading) {
                    return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
                  }
                  return SlideInTransitionWidget(
                      transitionWidget: currentPage,
                      durationTime: 700,
                      offset: Offset(0, 0.25)
                  );

              }
            ),
          )

      ],
    );
  }
}