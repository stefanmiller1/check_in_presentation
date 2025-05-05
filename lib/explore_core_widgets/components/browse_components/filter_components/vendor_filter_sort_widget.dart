import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'vendor_filter_sort_helper.dart';
import 'package:check_in_domain/domain/misc/explore_services/filter/explore_filter_item.dart';

class VendorFeedFilterPopOver extends StatefulWidget {
  final ExploreFilterObject? initialFilterModel;
  final DashboardModel model;
  final Function(ExploreFilterObject?) didFinishUpdatingFilter;

  const VendorFeedFilterPopOver({
    super.key,
    this.initialFilterModel,
    required this.model,
    required this.didFinishUpdatingFilter,
  });

  @override
  State<VendorFeedFilterPopOver> createState() => _VendorFeedFilterPopOverState();
}

class _VendorFeedFilterPopOverState extends State<VendorFeedFilterPopOver> {
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
          'Filter',
          style: TextStyle(color: widget.model.accentColor),
        ),
        centerTitle: true,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
              icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40),
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
                      currentFilterObject = currentFilterObject?.copyWith(
                        vendorFilter: currentFilterObject?.vendorFilter?.copyWith(
                          filterByVendorType: [],
                          isLookingForWork: null,
                        ),
                      );
                      widget.didFinishUpdatingFilter(currentFilterObject);
                    } 
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    ' Clear ',
                    style: TextStyle(
                      color: (currentFilterObject != null)
                          ? widget.model.accentColor
                          : widget.model.accentColor.withOpacity(0.4),
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 8),
          Center(
            child: Container(
              decoration: (currentFilterObject != null)
                  ? BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: InkWell(
                onTap: () {
                  if (currentFilterObject != null) {
                      widget.didFinishUpdatingFilter(currentFilterObject!);
                    }
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Add Filter',
                    style: TextStyle(
                      color: (currentFilterObject != null)
                          ? widget.model.paletteColor
                          : widget.model.accentColor.withOpacity(0.4),
                      fontSize: widget.model.secondaryQuestionTitleFontSize,
                    ),
                  ),
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
                title: Text(
                  'Select Filters based on the kinds of vendors you\'d like to find',
                  style: TextStyle(
                    color: widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Vendors will be filtered based on what you select once you press done.'),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text(
                  'Select & Filter By Vendor Type',
                  style: TextStyle(
                    color: widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Choose between different types of vendors.'),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 6,
                spacing: 8,
                children: MerchantVendorTypes.values.map((e) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        late List<MerchantVendorTypes> selectedTypes = [];
                        selectedTypes.addAll(currentFilterObject?.vendorFilter?.filterByVendorType ?? []);

                        if (selectedTypes.contains(e)) {
                          selectedTypes.remove(e);
                        } else {
                          selectedTypes.add(e);
                        }

                        currentFilterObject = currentFilterObject?.copyWith(
                          vendorFilter: currentFilterObject?.vendorFilter?.copyWith(
                            filterByVendorType: selectedTypes,
                            )
                          );
                        
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ((currentFilterObject?.vendorFilter?.filterByVendorType ?? []).contains(e))
                            ? widget.model.paletteColor
                            : widget.model.accentColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        child: Text(
                          getVendorMerchTitle(e),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: (currentFilterObject?.vendorFilter?.filterByVendorType ?? []).contains(e)
                                ? widget.model.accentColor
                                : widget.model.disabledTextColor,
                            fontSize: widget.model.secondaryQuestionTitleFontSize,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              Divider(color: widget.model.disabledTextColor),
              const SizedBox(height: 15),
              ListTile(
                title: Text(
                  'Looking for Work',
                  style: TextStyle(
                    color: widget.model.paletteColor,
                    fontSize: widget.model.secondaryQuestionTitleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Toggle to filter vendors that are looking for work.'),
                trailing: Switch(
                  value: currentFilterObject?.vendorFilter?.isLookingForWork ?? false,
                  onChanged: (value) {
                    setState(() {
                      currentFilterObject = currentFilterObject?.copyWith(
                        vendorFilter: currentFilterObject?.vendorFilter?.copyWith(
                          isLookingForWork: value,
                        ),
                      );
                    });
                  },
                  activeColor: widget.model.paletteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
