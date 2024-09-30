part of check_in_presentation;

class VendorMerchantCore {

  static late double forWidth = 675;
}


void didDeActivateSection(BuildContext context, DashboardModel model, String title, String description, String donButton, {required Function() didSelectDone}) {
  if (kIsWeb) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: model.accentColor,
            title: Text(title),
            content: Text(description),
            actions: [
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Canacel'),
                  )
              ),
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    didSelectDone();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(donButton),
                  )
              ),
            ]
        )
    );
    return;
  }

  showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(donButton),
              onPressed: () {
                Navigator.of(context).pop();
                didSelectDone();
              },
            ),
          ]
      )
  );
  // present
}


void presentPrivateInviteDialog(BuildContext context, DashboardModel model, List<String> currentList, {required Function() selectedProfilesToSave}) {
  if (kIsWeb) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                    height: 630,
                    width: 400,
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: SearchProfiles(
                      model: model,
                      showAddProfile: false,
                      selectedProfilesToSave: (profile) {
                        selectedProfilesToSave();
                    },
                  )
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        }
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return SearchProfiles(
            model: model,
            showAddProfile: false,
            selectedProfilesToSave: (profile) {
              selectedProfilesToSave();
            },
          );
        }
    )
    );
  }
}

// Widget createNew
// Widget createNewOptionSubContainer() {
//
// }

bool isSelectedAvailabilitySlot(ReservationSlotItem item, VendorMerchantForm form) {
  for (final customAvailability in form.availableTimeSlots ?? []) {
    if (customAvailability.selectedSlotItem.contains(item)) {
      return true;
    }
  }
  return false;
}




Widget pagingControllerForForm(BuildContext context, DashboardModel model, PageController? pageController, bool showDelete, bool showAdd, double height, bool isHovering, Widget newItem, List<Widget> widgets, {required Function(bool show) didStartHover, required Function(bool nextOrBack) didSelectArrow, required Function(int index) didSelectRemove}) {

  return MouseRegion(
    onEnter: (event) {
      didStartHover(true);
    },
    onExit: (event) {
      didStartHover(false);
    },
    child: Container(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [

          PageView.builder(
            controller: pageController,
            itemCount: widgets.length + ((showAdd) ? 1 : 0),
            padEnds: false,
            itemBuilder: (_, index) {

              final int lastIndex = widgets.length;

              if (index == lastIndex && showAdd) {
                return newItem;
              }

              final Widget widget = widgets[index];

              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Stack(
                      children: [
                        widget,
                        if (showDelete && widgets.length != 1 && index != 0) Positioned(
                          right: 0,
                          top: 8,
                          child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: model.paletteColor,
                                  borderRadius: BorderRadius.circular(25)
                              ),
                              child: IconButton(
                                  tooltip: 'delete',
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    didSelectRemove(index);
                                  },
                                  icon: Icon(Icons.cancel_outlined, color: model.accentColor)
                              )
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              );
            }
          ),

          if (widgets.length >= 3) AnimatedOpacity(
            opacity: isHovering ? 1 : 0,
            duration: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: (pageController != null && pageController.positions.isNotEmpty) ? pageController.offset >= 20 ? model.paletteColor : model.accentColor : model.accentColor,
                        border: Border.all(color: model.paletteColor, width: 0.5),
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: IconButton(
                      onPressed: () {
                        if ((pageController?.offset ?? 0) >= 20) {
                          didSelectArrow(false);
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: (pageController != null && pageController.positions.isNotEmpty) ? pageController.offset >= 20 ? model.disabledTextColor : model.paletteColor : model.paletteColor),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: model.paletteColor,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: IconButton(
                      onPressed: () {
                        didSelectArrow(true);
                        pageController?.animateTo((pageController.offset ?? 0) + 650, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                      },
                      icon: Icon(Icons.arrow_forward_ios_rounded, color: model.disabledTextColor),
                    ),
                  ),
                ],
              ),
            ),
        ],
      )
    ),
  );
}

Widget textFieldControllerForForm(DashboardModel model, double height, int maxLines, String? initial, String? hint, String title, {required Function(String) didChangeText}) {
  return Container(
    height: height,
    child: Padding(
      padding: const EdgeInsets.only(left: 48.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2,
          ),
          const SizedBox(height: 4),
          TextFormField(
            style: TextStyle(color: model.paletteColor),
            maxLines: maxLines,
            initialValue: initial,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: model.disabledTextColor),
              hintText: hint,
              errorStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: model.paletteColor,
              ),
              filled: true,
              fillColor: model.accentColor,
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  width: 2,
                  color: model.paletteColor,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none, // Remove border when not focused
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide.none, // Remove border when not focused
              ),
              focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: model.paletteColor,
                  width: 0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  width: 0,
                ),
              ),
            ),
            autocorrect: false,
            onChanged: (value) => didChangeText(value)
          ),
        ]
      ),
    )
  );
}

Widget boolOptionsForForm(BuildContext context, DashboardModel model, List<CheckBoxRuleOption> ruleOptions, {required Function(bool, CheckBoxRuleOption) didSelectRuleOption}) {
  return Container(
    height: 110,
    child: Padding(
      padding: const EdgeInsets.only(left: 48.0),
      child: Column(
        children: ruleOptions.map((e) => ListTile(
             title: Text(e.labelForRequirement.stringItem, style: TextStyle(color: model.disabledTextColor)),
             leading: Icon(Icons.check_circle_outline_rounded, color: model.disabledTextColor),
             trailing: Container(
               height: 50,
               width: 50,
               child: FlutterSwitch(
                 width: 60,
                 inactiveColor: model.accentColor,
                 activeColor: model.paletteColor,
                 value: e.labelForRequirement.boolItem,
                 onToggle: (value) {
                   didSelectRuleOption(value, e);
                },
              ),
            ),
          )
        ).toList() ?? [],
      )
    )
  );
}


Widget createNewVendorPreviews({required BuildContext context, required DashboardModel model, required bool hasForms, required Function() createNewForm}) {
  return Column(
    children: [
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Create a Vendor Form for all Vendors', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            width: 675,
            child: Text('Designed with versatility in mind, our Vendor Forms empower organizers to effortlessly collect essential information from prospective vendors, including customizable questions, fee structures, and all the pertinent details necessary for a seamless sign-up process.', style: TextStyle(color: model.disabledTextColor,))),
      ),
      Container(
        width: 675,
        height: 60,
        child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                      return model.paletteColor.withOpacity(0.1);
                    }
                    if (states.contains(MaterialState.hovered)) {
                      return model.paletteColor.withOpacity(0.1);
                    }
                    return model.webBackgroundColor; // Use the component's default.
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    )
                )
            ),
            onPressed: () {
              createNewForm();
            },
            child: Align(
              alignment: Alignment.center,
              child: Text('Create New Vendor Form',
                style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), textAlign: TextAlign.center,
              ),
            )
        ),
      ),
      const SizedBox(height: 25),
      if (!(hasForms)) Container(
        width: 435,
        // height: 600,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: model.mobileBackgroundColor.withOpacity(0.45)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 18),
                lottie.Lottie.asset(
                    height: 200,
                    repeat: false,
                    'assets/lottie_animations/8z46mK9a5Y.json'),
                const SizedBox(height: 18),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: model.accentColor
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 24,
                      width: 190,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: model.accentColor
                      ),
                    ),
                  ]
                ),

                const SizedBox(height: 18),
                Container(
                  height: 175,
                  width: 430,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: model.accentColor
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 105,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: model.accentColor
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 50,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: model.accentColor
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Container(
                          height: 24,
                          width: 270,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: model.accentColor
                          ),
                        ),
                      ),
                    ),

                    Container(
                      height: 24,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: model.accentColor
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 225,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: model.accentColor
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: model.accentColor
                      ),
                    ),
                  ],
                ),
            ]
          ),
        )
      ),
    ]
  );
}