part of check_in_presentation;

Widget spaceOptionsForListingToSelect(BuildContext context, DashboardModel model, List<SpaceOption> spaces, {required SpaceOption? currentSpace, required SpaceOptionSizeDetail? currentSpaceOption, required Function(SpaceOption) didSelectSpace, required Function(SpaceOptionSizeDetail) didSelectSpaceOption}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Wrap(
        direction: Axis.horizontal,
        children: spaces.map(
                (e)  {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: (currentSpace?.uid == e.uid) ? Border.all(color: model.paletteColor, width: 1) : null,
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      color: model.accentColor
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                return model.disabledTextColor.withOpacity(0.25);
                              }
                              if (states.contains(MaterialState.hovered)) {
                                return model.disabledTextColor.withOpacity(0.25);
                              }
                              return model.accentColor.withOpacity(0.4); // Use the component's default.
                            },
                          ),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                              )
                          )
                      ),
                      onPressed: () {
                        didSelectSpace(e);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(getSpaceTypeOptions(context).where((element) => element.uid == e.uid).isNotEmpty ? getSpaceTypeOptions(context).where((element) => element.uid == e.uid).first.spaceTitle : '', style: TextStyle(color: (currentSpace?.uid == e.uid) ? model.paletteColor : model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        ).toList(),
      ),

      SizedBox(height: 15),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: spaceSelectionHeader(
            context,
            model,
            currentSpaceOption,
            (currentSpace != null) ? [currentSpace] : [],
            didSelectSpace: (SpaceOptionSizeDetail e, SpaceOption space) {
              didSelectSpaceOption(e);
            }
        ),
      ),
    ],
  );
}