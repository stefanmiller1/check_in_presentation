import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';

import 'activities_filter_sort_helper.dart';

class ActivityFeedFilterPopOver extends StatefulWidget {

  final ExploreFilterObject? initialFilterModel;
  final DashboardModel model;
  final Function(ExploreFilterObject?) didFinishUpdatingFilter;

  const ActivityFeedFilterPopOver({super.key, this.initialFilterModel, required this.model, required this.didFinishUpdatingFilter});

  @override
  State<ActivityFeedFilterPopOver> createState() => _ActivityFeedFilterPopOverState();
}

class _ActivityFeedFilterPopOverState extends State<ActivityFeedFilterPopOver> {
  
  
  late ExploreFilterObject? currentFilterObject = null;

  @override
  void initState() {
    currentFilterObject = widget.initialFilterModel;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      backgroundColor: widget.model.paletteColor,
        title: Text(
          'Filter', style: TextStyle(color: widget.model.accentColor),
        ),
        centerTitle: true,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
              tooltip: 'Cancel',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 8),
            Center(
              child: InkWell(
                  onTap: () {
                    if (currentFilterObject != null) {
                      setState(() {
                      currentFilterObject = currentFilterObject?.copyWith(
                        activitiesFilter: currentFilterObject?.activitiesFilter?.copyWith(
                          filterByActivityType: null,
                          filterBySlotType: [ReservationSlotState.confirmed, ReservationSlotState.completed, ReservationSlotState.current],
                          filterByDateType: null,
                          filterWithStartDate: null,
                          filterWithEndDate: null,
                          dateRangeFilter: null,
                          isLookingForVendors: null,
                          ),
                        );
                        widget.didFinishUpdatingFilter(currentFilterObject);
                        Navigator.of(context).pop();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(' Clear ', style: TextStyle(color: (currentFilterObject != null) ? widget.model.accentColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
          ],
        ),
      actions: [
        const SizedBox(width: 8),
          Center(
            child: Container(
                decoration: (currentFilterObject != null) ? BoxDecoration(
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(20)
                ) : null,
              child: InkWell(
                onTap: () {
                  if (currentFilterObject != null) {
                    if (getNumberOfActivityFilterItems(currentFilterObject) == 0) {
                      widget.didFinishUpdatingFilter(null);
                    } else {
                      widget.didFinishUpdatingFilter(currentFilterObject!);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('Add Filter', style: TextStyle(color: (currentFilterObject != null) ? widget.model.paletteColor : widget.model.accentColor.withOpacity(0.4), fontSize: widget.model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                ListTile(
                  title: Text('Select Filters based on the kinds of activity you\'d like to find', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('Activities will be filtered based on what you select once you press done.', style: TextStyle(color: widget.model.disabledTextColor,)),
              ),
              // const SizedBox(height: 15),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //       const SizedBox(height: 8),
              //       ListTile(
              //         title: Text('Select Activity Type', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
              //     ),
              //   ],
              // ),
              // Divider(color: widget.model.disabledTextColor),
              const SizedBox(height: 15),
              ListTile(
                title: Text('Select & Filter By Dates', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('Choose between activities that have long past or yet to happen or happening now'),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
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
                }).toList(),
              ),
              const SizedBox(height: 15),
              Divider(color: widget.model.disabledTextColor),
              const SizedBox(height: 15),
              DateRangeSliderWidget(
                initialStart: currentFilterObject?.activitiesFilter?.dateRangeFilter?.start.month,
                initialEnd: currentFilterObject?.activitiesFilter?.dateRangeFilter?.end.month,
                model: widget.model,
                monthlyActivityCounts: [0, 2, 3, 12, 7, 6, 10, 4, 8, 15, 9, 0],
                didUpdateMonthRange: (startMonth, endMonth) {  
                    setState(() {
                        // Construct DateTimeRange using startMonth and endMonth with the current year
                      final currentYear = DateTime.now().year;
                      final DateTime startDate = DateTime(currentYear, startMonth, 1);
                      final DateTime endDate = DateTime(currentYear, endMonth + 1, 0); // Last day of the endMonth

                      currentFilterObject = currentFilterObject?.copyWith(
                        activitiesFilter: currentFilterObject?.activitiesFilter?.copyWith(
                          dateRangeFilter: DateTimeRange(start: startDate, end: endDate),
                        ),
                      );

                    });
                }, // Activities for Jan to Dec
              )
            ]
          )
        )
      )
    );
  }
}