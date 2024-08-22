part of check_in_presentation;

class FormCreatorDashboardMain extends StatefulWidget {

  final DashboardModel model;
  final bool showPreview;
  final Widget previewFormWidget;
  final List<FormCreatorContainerModel> formContainerItem;

  const FormCreatorDashboardMain({super.key, required this.model, required this.formContainerItem, required this.showPreview, required this.previewFormWidget});

  @override
  State<FormCreatorDashboardMain> createState() => _FormCreatorDashboardMainState();
}

class _FormCreatorDashboardMainState extends State<FormCreatorDashboardMain> with TickerProviderStateMixin {

  final _controller = ScrollController();
  late bool showPreviewer = (MediaQuery.of(context).size.width <= 800) == false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLessThanMain = (MediaQuery.of(context).size.width <= 800);

    return Stack(
      alignment: Alignment.topRight,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(left: (isLessThanMain || showPreviewer) ? 40.0 : 8.0, right: 28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLessThanMain || showPreviewer) Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 565),
                        child: getMainContainer())
                        ) else Expanded(
                        child: getMainContainer()
                      )
                  ],
                ),
              ),
            ),
          ),

          AnimatedContainer(
            width: (showPreviewer) ? ReservationHelperCore.previewerWidth : 0,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.only(right: 75.0, top: 75, bottom: 75),
              child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.webBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: widget.model.disabledTextColor.withOpacity(0.35),
                            spreadRadius: 5,
                            blurRadius: 13,
                            offset: const Offset(5,0)
                      )
                    ]
                  ),
                  width: ReservationHelperCore.previewerWidth,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: widget.previewFormWidget)
              ),
            ),
          ),

           Positioned(
              top: 18,
              right: 18,
              child: InkWell(
                onTap: () {
                  setState(() {
                    showPreviewer = !showPreviewer;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: (showPreviewer) ? widget.model.accentColor : widget.model.paletteColor,
                      borderRadius: BorderRadius.circular(30),
                      border: (showPreviewer) ? Border.all(color: widget.model.disabledTextColor) : null
                  ),
                  height: 45,
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Row(
                      children: [
                        Icon(Icons.remove_red_eye_outlined, color: (showPreviewer) ? widget.model.paletteColor : widget.model.accentColor,),
                        const SizedBox(width: 8),
                        Text('preview', style: TextStyle(color: (showPreviewer) ? widget.model.paletteColor : widget.model.accentColor)),
                      ],
                    ),
                  ),
                ),
              )
          ),
      ],
    );
  }

  Widget getMainContainer() {
    return Column(
      children: [
        const SizedBox(height: 18),
        ...widget.formContainerItem.map(
                (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Container(
                    width: 675,
                    // height: 60,
                    decoration: BoxDecoration(
                      color: widget.model.webBackgroundColor,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: ListTile(
                      leading: Icon(e.formHeaderIcon, color: (e.isActivated) ? widget.model.paletteColor : widget.model.disabledTextColor),
                      title: Text(e.formHeaderTitle, style: TextStyle(color: (e.isActivated) ? widget.model.paletteColor : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      subtitle: (e.formHeaderSubTitle != null || e.showErrorMessage == true) ? Text((e.showErrorMessage == true && (e.errorMessage != null)) ? e.errorMessage! : e.formHeaderSubTitle!, style: TextStyle(color: (e.showErrorMessage == true) ? Colors.red : widget.model.disabledTextColor)) : null,
                      trailing: Container(
                        height: 60,
                        width: 60,
                        child: FlutterSwitch(
                          width: 60,
                          inactiveToggleColor: widget.model.accentColor,
                          inactiveIcon: Icon(Icons.add, color: widget.model.disabledTextColor),
                          inactiveTextColor: widget.model.paletteColor,
                          inactiveColor: widget.model.mobileBackgroundColor,
                          activeColor: widget.model.paletteColor,
                          value: e.isActivated,
                          onToggle: (value) {
                            setState(() {
                              e.didSelectActivate(value);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    height: (e.isActivated) ? (e.formSubHelper != null) ? e.height + 118 : e.height : 0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Visibility(
                            visible: e.formSubHelper != null,
                            child: Column(
                              children: [
                                Container(
                                    height: 110,
                                    width: VendorMerchantCore.forWidth,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: widget.model.disabledTextColor),
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                  child: e.formSubHelper
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),

                          Container(
                              height: e.height,
                              width: VendorMerchantCore.forWidth,
                              decoration: BoxDecoration(
                                  border: Border.all(color: widget.model.disabledTextColor),
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: (e.isLoading == true) ? JumpingDots(numberOfDots: 3, color: widget.model.paletteColor) : e.formMainCreatorWidget
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
        ).toList(),

      ],
    );
  }

}