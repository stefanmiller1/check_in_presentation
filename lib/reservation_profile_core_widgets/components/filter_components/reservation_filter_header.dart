part of check_in_presentation;

class ReservationFilterHeader extends StatefulWidget {

  final ReservationFilterObject? initialFilterModel;
  final ReservationFilter filterItem;
  final DashboardModel model;
  final Function(ReservationFilterObject? filterModel) didUpdateFilterModel;
  
  const ReservationFilterHeader({Key? key, required this.filterItem, required this.model, required this.didUpdateFilterModel, this.initialFilterModel}) : super(key: key);

  @override
  State<ReservationFilterHeader> createState() => _ReservationFilterHeaderState();
}

class _ReservationFilterHeaderState extends State<ReservationFilterHeader> {
  
  late ReservationFilterObject? _currentFilterModel = null;

  @override
  void initState() {
    _currentFilterModel = widget.initialFilterModel;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              child: badges.Badge(
                showBadge: _currentFilterModel != null && getNumberOfReservationFilterItems(_currentFilterModel, widget.filterItem) != 0,
                badgeStyle: badges.BadgeStyle(badgeColor: widget.model.paletteColor),
                badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
                badgeContent: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(getNumberOfReservationFilterItems(_currentFilterModel, widget.filterItem).toString(), style: TextStyle(color: widget.model.accentColor)),
                ),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    border: (getNumberOfReservationFilterItems(_currentFilterModel, widget.filterItem) != 0) ? Border.all(color: widget.model.paletteColor, width: 2) : null,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: IconButton(
                    onPressed: () {  
                        showReservationFilterPopOver(
                          context,
                          _currentFilterModel,
                          widget.filterItem,
                          widget.model,
                          didFinishUpdatingFilter: (filter) {
                            _currentFilterModel = _currentFilterModel?.copyWith(
                                contactStatusOptions: filter?.contactStatusOptions,
                                reservationHostingType: filter?.reservationHostingType,
                                formStatus: filter?.formStatus,
                                privateReservationsOnly: filter?.privateReservationsOnly,
                                isReverseSorted: filter?.isReverseSorted,
                                filterWithStartDate: filter?.filterWithStartDate,
                                filterWithEndDate: filter?.filterWithEndDate,
                            );
                            widget.didUpdateFilterModel(_currentFilterModel);
                          }   
                        );
                    },
                    icon: Icon(CupertinoIcons.slider_horizontal_3, color: widget.model.paletteColor),
                    iconSize: 30,
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<ReservationTypeFilter>(
                  isDense: true,
                  customButton: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 6),
                            Text(
                              widget.filterItem.filterTitle,
                              style: TextStyle(
                                color: widget.model.accentColor,
                                fontSize: widget.model.secondaryQuestionTitleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Icon(Icons.arrow_downward, color: widget.model.accentColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                  style: TextStyle(color: widget.model.accentColor),
                  onChanged: (ReservationTypeFilter? newValue) {
                      if (newValue == null) return;

                    _currentFilterModel = _currentFilterModel?.copyWith(
                      filterType: newValue,
                    );

                    widget.didUpdateFilterModel(_currentFilterModel);
                  },
                  items: [
                    // Mapping items and injecting the divider at index 2
                    ...ReservationTypeFilter.values.asMap().entries.expand<DropdownMenuItem<ReservationTypeFilter>>((entry) {
                      int index = entry.key;
                      ReservationTypeFilter value = entry.value;

                      // Add the divider after the second item (at index 2)
                      if (index == 2) {
                        return [
                          DropdownMenuItem<ReservationTypeFilter>(
                            enabled: false,
                            child: Divider(
                              thickness: 3, // Thick divider
                              color: widget.model.accentColor, // Divider color
                              // height: 3,
                            ),
                          ),
                          DropdownMenuItem<ReservationTypeFilter>(
                            value: value,
                            child: Text(value.name.toUpperCase(),
                              style: TextStyle(color: widget.model.paletteColor),
                            ),
                          ),
                        ];
                      } else {
                        return [
                          DropdownMenuItem<ReservationTypeFilter>(
                            value: value,
                            child: Text(
                              value.name.toUpperCase(),
                              style: TextStyle(color: widget.model.paletteColor),
                            ),
                          ),
                        ];
                      }
                    }),
                  ],
                  dropdownStyleData: DropdownStyleData(
                    elevation: 11,
                    offset: const Offset(0, -10),
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: widget.model.webBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),

            
          ]
        ),
      )
    );
  }
} 