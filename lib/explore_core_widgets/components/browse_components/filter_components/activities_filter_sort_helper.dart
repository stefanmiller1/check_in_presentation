import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';

import 'activities_filter_sort_widget.dart';



int getNumberOfActivityFilterItems(ExploreFilterObject? filter) {
  
  late ExploreActivitiesFilter? activitiesFilter;
   activitiesFilter = filter?.activitiesFilter;

  if (activitiesFilter == null) return 0;

  int total = 0;

  // Count non-null and list-based fields
  if (activitiesFilter.filterByActivityType != null && activitiesFilter.filterByActivityType!.isNotEmpty) {
    total += activitiesFilter.filterByActivityType!.length;
  }

  if (activitiesFilter.filterBySlotType != null && activitiesFilter.filterBySlotType!.isNotEmpty) {
    total += activitiesFilter.filterBySlotType!.length;
  }

  if (activitiesFilter.filterByDateType != null) {
    total += 1;
  }

  if (activitiesFilter.filterWithStartDate != null) {
    total += 1;
  }

  if (activitiesFilter.filterWithEndDate != null) {
    total += 1;
  }

  if (activitiesFilter.dateRangeFilter != null) {
    total += 1;
  }

  if (activitiesFilter.isLookingForVendors != null) {
    total += 1;
  }

  return total;
}


// bool filterBy


void showActivityFeedFilterOptions(BuildContext context, DashboardModel model, ExploreFilterObject? filterModel, {required Function(ExploreFilterObject?) didFinishUpdatingFilter}) {
   if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Filter',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 700,
                    height: 850,
                    child: ActivityFeedFilterPopOver(
                      initialFilterModel: filterModel,
                      model: model,
                      didFinishUpdatingFilter: (filter) {
                        didFinishUpdatingFilter(filter);
                      },
              )
            )
          )
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
      },
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return ActivityFeedFilterPopOver(
            initialFilterModel: filterModel,
            model: model, 
            didFinishUpdatingFilter: (filter) {  
              didFinishUpdatingFilter(filter);
            },
          );
        })
    );
  }
}