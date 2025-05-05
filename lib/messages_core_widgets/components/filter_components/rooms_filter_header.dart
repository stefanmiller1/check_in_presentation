part of check_in_presentation;

class RoomsFilterHeader extends StatefulWidget {
  
  final RoomsFilterObject? initialFilterModel;
  final List<RoomsFilter> defaultFilterList;
  final RoomsFilter filterItem;
  final DashboardModel model;
  final UserProfileModel currentUser;
  final Function(RoomsFilterObject? filterModel) didUpdateFilterModel;

  const RoomsFilterHeader({super.key, this.initialFilterModel, required this.model, required this.filterItem, required this.defaultFilterList, required this.didUpdateFilterModel, required this.currentUser});

  @override
  State<RoomsFilterHeader> createState() => _RoomsFilterHeaderState();
}

class _RoomsFilterHeaderState extends State<RoomsFilterHeader> {
  
  late RoomsFilterObject? _currentFilterModel = null;


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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<RoomsFilter>(
                  isDense: true,
                  customButton: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: BorderRadius.circular(35),
                      ),
                        child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 6),
                            Text(widget.filterItem.filterTitle,
                              style: TextStyle(
                                color: widget.model.accentColor,
                                fontSize: widget.model.secondaryQuestionTitleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_downward, color: widget.model.accentColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                style: TextStyle(color: widget.model.accentColor),
                  onChanged: (RoomsFilter? newFilter) {
                    setState(() {
                      _currentFilterModel = _currentFilterModel?.copyWith(
                        roomType: newFilter?.filterType,
                      );
                    });
                    widget.didUpdateFilterModel(_currentFilterModel);
                  },
                  items: widget.defaultFilterList.map((filter) {
                    return DropdownMenuItem<RoomsFilter>(
                      value: filter,
                      child: ListTile(
                        leading: Icon(
                          _getRoomIcon(filter.filterType),
                          color: widget.model.paletteColor,
                        ),
                        title: Text(
                          filter.filterTitle.toUpperCase(),
                          style: TextStyle(color: widget.model.paletteColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: hasUnreadMessagesInRoom(filter.filterType, widget.currentUser)
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 11,
                    offset: const Offset(0, -10),
                  width: 320,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: widget.model.webBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // "Unread" Toggle Button using HoverButton
            SizedBox(
              height: 45,
              child: HoverButton(
                onpressed: () {
                  setState(() {
                    if (_currentFilterModel?.showUnreadOnly == true) {
                      _currentFilterModel = _currentFilterModel?.copyWith(
                        showUnreadOnly: false,
                      );
                    } else {
                      _currentFilterModel = _currentFilterModel?.copyWith(
                        showUnreadOnly: true,
                      );
                    }
                  });
                  widget.didUpdateFilterModel(_currentFilterModel);
                },
                animationDuration: Duration.zero,
                color: (_currentFilterModel?.showUnreadOnly ?? false) ? widget.model.paletteColor : widget.model.webBackgroundColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                child: Text(
                  "Unread",
                  style: TextStyle(
                    color: (_currentFilterModel?.showUnreadOnly ?? false) ? widget.model.accentColor : widget.model.disabledTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),
            if (widget.filterItem.showArchiveButton == true) SizedBox(
              height: 45,
              child: HoverButton(
                onpressed: () {
                  setState(() {
                    if (_currentFilterModel?.isArchive == true) {
                      _currentFilterModel = _currentFilterModel?.copyWith(
                        isArchive: false,
                      );
                    } else {
                      _currentFilterModel = _currentFilterModel?.copyWith(
                        isArchive: true,
                      );
                    }
                  });
                  widget.didUpdateFilterModel(_currentFilterModel);
                },
                animationDuration: Duration.zero,
                color: (_currentFilterModel?.isArchive ?? false) ? widget.model.paletteColor : widget.model.webBackgroundColor,
                hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                hoverElevation: 0,
                highlightElevation: 0,
                hoverShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hoverPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 0,
                child: Text(
                  "Archived",
                  style: TextStyle(
                    color: (_currentFilterModel?.isArchive ?? false) ? widget.model.accentColor : widget.model.disabledTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          ]
        )
      )
    );
  }

  IconData _getRoomIcon(types.RoomType? type) {
    switch (type) {
      case types.RoomType.direct:
        return CupertinoIcons.chat_bubble_2_fill;
      case types.RoomType.group:
        return CupertinoIcons.person_3_fill;
      case types.RoomType.channel:
        return CupertinoIcons.circle;
      default:
        return CupertinoIcons.tray_full;
    }
  }
}