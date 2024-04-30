part of  check_in_presentation;

class VendorFormCustomOptionsWidget extends StatefulWidget {

  final DashboardModel model;
  final VendorMerchantForm form;
  final Function(bool value, MVCustomOption option) onChanged;
  final Function(MVCustomOption) onChangedOptionItem;

  const VendorFormCustomOptionsWidget({super.key, required this.model, required this.onChanged, required this.form, required this.onChangedOptionItem});

  @override
  State<VendorFormCustomOptionsWidget> createState() => _VendorFormCustomOptionsWidgetState();
}

class _VendorFormCustomOptionsWidgetState extends State<VendorFormCustomOptionsWidget> {

  late PageController? documentsPageController = PageController(viewportFraction: 0.25);
  late PageController? linksPageController = PageController(viewportFraction: 0.25);

  late bool docIsHovering = false;
  late bool listIsHovering = false;


  @override
  void dispose() {

    documentsPageController?.dispose();
    linksPageController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          ...predefinedCustomOptions(context).where((element) => element.customRuleOption != null).map(
                  (e) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(e.customRuleOption!.customRuleTitleLabel, style: TextStyle(color: (widget.form.customOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    leading: Icon(getIconForCustomOptions(e.customRuleOption!.ruleId.getOrCrash()), color: (widget.form.customOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ? widget.model.paletteColor : widget.model.disabledTextColor,),
                    subtitle: (e.customRuleOption!.labelTextRuleOption != null) ? Text(e.customRuleOption!.labelTextRuleOption!.titleLabel, style: TextStyle(color: (widget.form.customOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true) ? widget.model.paletteColor : widget.model.disabledTextColor)) : null,
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
                        value: widget.form.customOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true,
                        onToggle: (value) {
                          widget.onChanged(value, e);
                        },
                      ),
                    ),
                  ),

                  if (e.customRuleOption?.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-gykug7878f67')
                    if (widget.form.customOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true)
                      createDocumentPagingView(
                      widget.form.customOptions!.firstWhere((element) => element.customRuleOption?.ruleId == e.customRuleOption?.ruleId),
                  ),
                  if (e.customRuleOption?.ruleId.getOrCrash() == '6e24dae0-96dd-11eb-babc-joij90hh7hii')
                    if (widget.form.customOptions?.map((e) => e.customRuleOption?.ruleId).contains(e.customRuleOption?.ruleId) == true)
                    createCustomListPagingView(
                    widget.form.customOptions!.firstWhere((element) => element.customRuleOption?.ruleId == e.customRuleOption?.ruleId).customRuleOption?.selectionLabelOption
                  )
                ],
              )
          ).toList()
        ],
      ),
    );
  }


  Widget createDocumentPagingView(MVCustomOption option) {

    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// preview doc. make doc. required..
          Text('My Documents', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
          pagingControllerForForm(
            context,
            widget.model,
            documentsPageController,
            true,
            true,
            200,
            docIsHovering,
            InkWell(
              onTap: () async {

                  late MVCustomOption currentOption = option;
                  List<DocumentFormOption> documents = [];
                  documents.addAll(option.customRuleOption?.customDocumentOptions ?? []);

                  try {
                  final newDocument = await FilePickerPreviewerWidget.handleFileSelection(context, widget.model);

                  documents.add(newDocument);

                  currentOption = currentOption.copyWith(
                    customRuleOption: currentOption.customRuleOption?.copyWith(
                      customDocumentOptions: documents
                    )
                  );

                  widget.onChangedOptionItem(currentOption);

                  return;
                } catch (e) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text('cancelled', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Container(
                height: 200,
                width: 90,
                decoration: BoxDecoration(
                  color: widget.model.accentColor,
                  borderRadius: BorderRadius.circular(25)
                      ),
                    child: Icon(Icons.add_circle_outline_outlined, size: 35, color: widget.model.disabledTextColor,
                  ),
                ),
              ),
              option.customRuleOption?.customDocumentOptions?.map((e) => Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        height: 200,
                        // width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: widget.model.disabledTextColor),
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: InkWell(
                          onTap: () async {

                            FilePickerPreviewerWidget.didOpenDocument(context, e, widget.model);

                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.document_scanner_outlined, size: 35, color: widget.model.disabledTextColor,),
                                const SizedBox(height: 12),
                                Text('Preview', textAlign: TextAlign.center, style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                Text(e.documentForm.key, textAlign: TextAlign.center, style: TextStyle(color: widget.model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 8,
                    child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: widget.model.paletteColor,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: IconButton(
                            tooltip: 'delete',
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              late MVCustomOption currentOption = option;
                              List<DocumentFormOption> documents = [];
                              documents.addAll(option.customRuleOption?.customDocumentOptions ?? []);

                              documents.remove(e);

                              currentOption = currentOption.copyWith(
                                  customRuleOption: currentOption.customRuleOption?.copyWith(
                                      customDocumentOptions: documents
                                  )
                              );

                              widget.onChangedOptionItem(currentOption);
                            },
                            icon: Icon(Icons.cancel_outlined, color: widget.model.accentColor)
                        )
                    ),
                  )
                ],
              )
              ).toList() ?? [],
              didStartHover: (show) {
                setState(() {
                  docIsHovering = show;
                });
              },
              didSelectArrow: (forwardBack) {
              setState(() {
                if (forwardBack) {
                   documentsPageController?.animateTo((documentsPageController?.offset ?? 0) + 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                    } else {
                   documentsPageController?.animateTo((documentsPageController?.offset ?? 0) - 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  }
                });
              },
              didSelectRemove: (int index) {
                late MVCustomOption currentOption = option;
                List<DocumentFormOption> documents = [];
                documents.addAll(option.customRuleOption?.customDocumentOptions ?? []);

                documents.removeAt(index);

                currentOption = currentOption.copyWith(
                    customRuleOption: currentOption.customRuleOption?.copyWith(
                        customDocumentOptions: documents
                    )
                );

                widget.onChangedOptionItem(currentOption);
            },
          ),
        ],
      ),
    );
  }


  Widget createCustomListPagingView(List<SelectionLabelOption>? list) {
    late PageController? listPageController = PageController(viewportFraction: 0.4);

    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My List', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
          pagingControllerForForm(
            context,
            widget.model,
            listPageController,
            false,
            true,
            55,
            listIsHovering,
            Container(
              // height: 15,
              // width: 65,
              decoration: BoxDecoration(
                  color: widget.model.accentColor,
                  borderRadius: BorderRadius.circular(25)
              ),
              child: Icon(Icons.add_circle_outline_outlined, size: 35, color: widget.model.disabledTextColor,
              ),
            ),
            list?.map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 105,
                width: 240,
                decoration: BoxDecoration(
                    border: Border.all(color: widget.model.disabledTextColor),
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Icon(Icons.format_list_bulleted_outlined, size: 35, color: widget.model.disabledTextColor,),
                ),
              )
            ).toList() ?? [],
            didStartHover: (show) {
              setState(() {
                listIsHovering = show;
              });
            },
            didSelectArrow: (forwardBack) {
              setState(() {
                if (forwardBack) {
                  listPageController.animateTo((listPageController.offset ?? 0) + 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                } else {
                  listPageController.animateTo((listPageController.offset ?? 0) - 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                }
              });
            },
            didSelectRemove: (int index) {

            },
          ),
        ],
      ),
    );
  }

}





Widget createCustomList(DashboardModel model, bool isActive, List<DocumentFormOption> documents, {required Function() addNewDocument, required Function() removeDocument}) {
  return Column(
    children: [

    ],
  );
}