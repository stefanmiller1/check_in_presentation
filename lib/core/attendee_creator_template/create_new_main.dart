part of check_in_presentation;

class CreateNewMain extends StatefulWidget {

  final List<Widget> child;
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
                physics: const NeverScrollableScrollPhysics(),
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

                  Widget currentPage = widget.child[index];

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


Widget createNewMainFooter(BuildContext context, DashboardModel model, bool showBackButton, bool showNextButton, {required Function() didSelectBack, required Function() didSelectNext}) {
  return ClipRRect(
    child: BackdropFilter(
      filter: UI.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        color: model.accentColor.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Visibility(
                      visible: showBackButton,
                      child: IconButton(
                          onPressed: () {
                            didSelectBack();
                          },
                          icon: Icon(Icons.arrow_back_ios, color: model.paletteColor)
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                  visible: showNextButton,
                  child: InkWell(
                    onTap: () {
                      didSelectNext();
                    },
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 200
                      ),
                      height: 45,
                      width: 185,
                      decoration: BoxDecoration(
                        color: model.paletteColor,
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Next', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),
                    ),
                  ),
                )
              ),

            ],
          ),
        ),
      ),
    ),
  );
}