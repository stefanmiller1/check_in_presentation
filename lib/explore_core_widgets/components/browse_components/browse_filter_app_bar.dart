part of check_in_presentation;

class FilterAppBarWidget extends StatefulWidget {
 
 final Function(ExploreFilterObject? filter) didUpdateFilterModel;
 final DashboardModel model;
 final ExploreFilterObject? initialFilterObject;

 const FilterAppBarWidget({super.key, required this.initialFilterObject, required this.didUpdateFilterModel, required this.model});

  @override
  State<FilterAppBarWidget> createState() => _FilterAppBarWidgetState();
}

class _FilterAppBarWidgetState extends State<FilterAppBarWidget> {

  late ExploreFilterObject? currentFilterObject;
  late final randomVendorTypes = MerchantVendorTypes.values.toList()..shuffle();

  @override
  void initState() {
    currentFilterObject = widget.initialFilterObject;
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       
        getMainFilterContainer(),
        if (Responsive.isMobile(context) == false) Column(
          children: [
            if (currentFilterObject?.filterByExplorBrowseType == ExploreBrowseType.user) Column(
              children: [
                const SizedBox(height: 15),
                filterByVendorType(),
                const SizedBox(height: 15),
              ]
            ),

            if (currentFilterObject?.filterByExplorBrowseType == ExploreBrowseType.activity) Column(
              children: [
                const SizedBox(height: 15),
                filterByActivityDateType(),
                const SizedBox(height: 15),
              ]
            ),
          ]
        )
      ],
    );
  }

  Widget getFilterWidget() {
    switch (currentFilterObject?.filterByExplorBrowseType) {
      case null:
        return Container();
      case ExploreBrowseType.activity:
        return badges.Badge(
              showBadge: currentFilterObject != null && getNumberOfActivityFilterItems(currentFilterObject) != 0,
              badgeStyle: badges.BadgeStyle(badgeColor: widget.model.paletteColor),
              badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
              badgeContent: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(getNumberOfActivityFilterItems(currentFilterObject).toString(), style: TextStyle(color: widget.model.accentColor)),
              ),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: widget.model.accentColor,
                  border: (getNumberOfActivityFilterItems(currentFilterObject) != 0) ? Border.all(color: widget.model.paletteColor, width: 2) : null,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(
                  onPressed: () {  
                    showActivityFeedFilterOptions(
                      context, 
                      widget.model,
                      currentFilterObject,
                      didFinishUpdatingFilter: (filter) {
                        currentFilterObject = currentFilterObject?.copyWith(
                          activitiesFilter: filter?.activitiesFilter
                        );
                        widget.didUpdateFilterModel(currentFilterObject);
                      }
                    );
                  },
                  icon: Icon(CupertinoIcons.slider_horizontal_3, color: widget.model.paletteColor),
                  iconSize: 30,
                ),
              ),
            );
      case ExploreBrowseType.user:
        return badges.Badge(
            showBadge: currentFilterObject != null && getNumberOfVendorFilterItems(currentFilterObject) != 0,
            badgeStyle: badges.BadgeStyle(badgeColor: widget.model.paletteColor),
            badgeAnimation: const badges.BadgeAnimation.scale(animationDuration: Duration(milliseconds: 700)),
            badgeContent: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(getNumberOfVendorFilterItems(currentFilterObject).toString(), style: TextStyle(color: widget.model.accentColor)),
                ),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    border: (getNumberOfVendorFilterItems(currentFilterObject) != 0) ? Border.all(color: widget.model.paletteColor, width: 2) : null,
                    borderRadius: BorderRadius.circular(40),
                    ),
                      child: IconButton(
                        onPressed: () {  
                          showVendorFeedFilterOptions(
                              context, 
                              widget.model,
                              currentFilterObject,
                              didFinishUpdatingFilter: (filter) {
                              currentFilterObject = currentFilterObject?.copyWith(
                                vendorFilter: filter?.vendorFilter
                              );
                              widget.didUpdateFilterModel(currentFilterObject);
                            }
                          );
                        },
            icon: Icon(CupertinoIcons.slider_horizontal_3, color: widget.model.paletteColor),
            iconSize: 30,
          ),
        )
      );
    }
  }

  Widget getGetStartedWidget() {
    switch (currentFilterObject?.filterByExplorBrowseType) {
      case null:
        return Container(
          height: 50,
          // width: 200,
          decoration: BoxDecoration(
            color: widget.model.paletteColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Responsive.isMobile(context)) ? 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: widget.model.accentColor),
                ) : Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(Icons.add, color: widget.model.accentColor),
                  const SizedBox(width: 3),
                  Text('Be an Organizer  ', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                ],
              ),
            ),
          ),
        );
      case ExploreBrowseType.activity:
        return Container(
          height: 50,
          // width: 200,
          decoration: BoxDecoration(
            color: widget.model.paletteColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Responsive.isMobile(context)) ? 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: widget.model.accentColor),
                ) : Row(
                children: [
                  const SizedBox(width: 8),
                  Icon(Icons.add, color: widget.model.accentColor),
                  const SizedBox(width: 3),
                  Text(' Add Activity  ', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                ],
              ),
            ),
          ),
        );
      case ExploreBrowseType.user:
        return Container(
          height: 50,
          // width: 200,
          decoration: BoxDecoration(
            color: widget.model.paletteColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Responsive.isMobile(context)) ? 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, color: widget.model.accentColor),
                ) : 
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(Icons.add, color: widget.model.accentColor),
                    const SizedBox(width: 3),
                    Text(' Create Profile  ', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                ],
              ),
            ),
          ),
        );
    }
  }

  Widget getMainFilterContainer() {
    return  Row(
          children: [
            getFilterWidget(),
            const SizedBox(width: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    border: (currentFilterObject?.filterByExplorBrowseType == ExploreBrowseType.activity) ? Border.all(color: widget.model.paletteColor, width: 2) : null,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (currentFilterObject?.filterByExplorBrowseType == ExploreBrowseType.activity) {
                          currentFilterObject = currentFilterObject?.copyWith(
                            filterByExplorBrowseType: null
                          ); // Toggle off
                          Beamer.of(context).update(
                              configuration: RouteInformation(
                                uri: Uri.parse(searchExploreRoute())
                              ),
                              rebuild: false
                          );
                        } else {
                          currentFilterObject = currentFilterObject?.copyWith(
                            filterByExplorBrowseType: ExploreBrowseType.activity
                          ); // Toggle to Activities
                           Beamer.of(context).update(
                              configuration: RouteInformation(
                                uri: Uri.parse(searchExploreByBrowseTypeRoute(ExploreBrowseType.activity.name))
                              ),
                            rebuild: false
                          );
                          
                        }
                      
                        widget.didUpdateFilterModel(currentFilterObject);
                        
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(Icons.local_activity_outlined, color:  widget.model.paletteColor),
                          const SizedBox(width: 8),
                          Text(' Activities ', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    border: (currentFilterObject?.filterByExplorBrowseType == ExploreBrowseType.user) ? Border.all(color: widget.model.paletteColor, width: 2) : null,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                          if (currentFilterObject?.filterByExplorBrowseType == ExploreBrowseType.user) {
                            currentFilterObject = currentFilterObject?.copyWith(
                              filterByExplorBrowseType: null
                              ); // Toggle off
                              Beamer.of(context).update(
                                configuration: RouteInformation(
                                  uri: Uri.parse(searchExploreRoute())
                                ),
                              rebuild: false
                          );
                          } else {
                            currentFilterObject = currentFilterObject?.copyWith(
                              filterByExplorBrowseType: ExploreBrowseType.user
                              ); // Toggle off // Toggle to Activities
                            Beamer.of(context).update(
                              configuration: RouteInformation(
                                uri: Uri.parse(searchExploreByBrowseTypeRoute(ExploreBrowseType.user.name))
                              ),
                            rebuild: false
                          );
                          }
                          widget.didUpdateFilterModel(currentFilterObject);
                        });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(Icons.storefront, color: widget.model.paletteColor),
                          const SizedBox(width: 8),
                          Text('Brands', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            getGetStartedWidget(),
          ],
        ),
      ],
    );
  }

  Widget filterByVendorType() {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: 6,
      spacing: 8,
      children: randomVendorTypes.take(5).map(
              (e) => InkWell(
            onTap: () {
              setState(() {
                late List<MerchantVendorTypes> selectedVendorTypes = [];
                selectedVendorTypes.addAll(currentFilterObject!.vendorFilter?.filterByVendorType ?? []);

                  if (selectedVendorTypes.contains(e)) {
                      selectedVendorTypes.remove(e);
                  } else {
                    selectedVendorTypes.add(e);
                  }

                  currentFilterObject = currentFilterObject?.copyWith(
                    vendorFilter: currentFilterObject?.vendorFilter?.copyWith(
                      filterByVendorType: selectedVendorTypes
                    )
                  );  

                widget.didUpdateFilterModel(currentFilterObject);
              });
            },
            child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: (currentFilterObject?.vendorFilter?.filterByVendorType ?? []).contains(e) ? widget.model.paletteColor : widget.model.accentColor,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Text(' ${getVendorMerchTitle(e)}  ', textAlign: TextAlign.center, style: TextStyle(color: (currentFilterObject?.vendorFilter?.filterByVendorType ?? []).contains(e) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            )
          ),
        )
      ).toList(),
    );
  }

  Widget filterByActivityDateType() {
    return Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 6,
        spacing: 8,
        children: ReservationSlotState.values.where((element) => element == ReservationSlotState.confirmed || element == ReservationSlotState.current || element == ReservationSlotState.completed).map((e) {
            return InkWell(
              onTap: () {

                setState(() {

                  late List<ReservationSlotState> selectedSlots = [];
                  selectedSlots.addAll(currentFilterObject?.activitiesFilter?.filterBySlotType ?? []);

                  if (selectedSlots.contains(e)) {
                    selectedSlots.remove(e);
                  } else {
                    selectedSlots.add(e);
                  }

                  if (currentFilterObject?.activitiesFilter == null) {
                     currentFilterObject = currentFilterObject?.copyWith(
                        activitiesFilter: ExploreActivitiesFilter(
                          filterByActivityType: null,
                          filterBySlotType: selectedSlots,
                          filterByDateType: null,
                          filterWithStartDate: null,
                          filterWithEndDate: null,
                          dateRangeFilter: null,
                          isLookingForVendors: null,
                          reverseOrder: null,
                        )
                      ); 

                  } else {
                    currentFilterObject = currentFilterObject?.copyWith(
                      activitiesFilter: currentFilterObject?.activitiesFilter?.copyWith(
                        filterBySlotType: selectedSlots
                      )
                    );    
                  } // Toggle off // Toggle to Activities
                  
                  widget.didUpdateFilterModel(currentFilterObject);
                });
             
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: ((currentFilterObject?.activitiesFilter?.filterBySlotType ?? []).contains(e)) ? widget.model.paletteColor : widget.model.accentColor,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: Text(getReservationStateTitle(e), textAlign: TextAlign.center, style: TextStyle(color: (currentFilterObject?.activitiesFilter?.filterBySlotType ?? []).contains(e) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              )
            )
          );
        }).toList()
    );
  }

}