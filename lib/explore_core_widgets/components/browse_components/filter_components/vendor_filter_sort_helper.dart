import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'vendor_filter_sort_widget.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';

int getNumberOfVendorFilterItems(ExploreFilterObject? filterObject) {
  int count = 0;

  if (filterObject?.vendorFilter == null) {
    return 0;
  }

  if (filterObject!.vendorFilter!.filterByVendorType != null && filterObject.vendorFilter!.filterByVendorType!.isNotEmpty) {
    count += filterObject.vendorFilter!.filterByVendorType!.length ?? 0;
  }

  if (filterObject.vendorFilter!.isLookingForWork != null) {
    count += 1;
  }

  return count;
}

void showVendorFeedFilterOptions(BuildContext context, DashboardModel model, ExploreFilterObject? filterModel, {required Function(ExploreFilterObject?) didFinishUpdatingFilter}) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Filter',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              width: 700,
              height: 850,
              child: VendorFeedFilterPopOver(
                initialFilterModel: filterModel,
                model: model,
                didFinishUpdatingFilter: didFinishUpdatingFilter,
              ),
            ),
          ),
        );
      },
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VendorFeedFilterPopOver(
          initialFilterModel: filterModel,
          model: model,
          didFinishUpdatingFilter: didFinishUpdatingFilter,
        ),
      ),
    );
  }
}