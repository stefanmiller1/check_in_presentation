import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/domain/misc/reservation_services/reservation_filter/reservation_filter_sort_widget.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_switch/flutter_switch.dart';


class ReservationFilterPopOver extends StatefulWidget {
  
  final ReservationFilterObject? initialFilterModel;
  final ReservationFilter currentFilterMode;
  final DashboardModel model;
  final Function(ReservationFilterObject?) didFinishUpdatingFilter;

  const ReservationFilterPopOver({super.key, this.initialFilterModel, required this.model, required this.currentFilterMode, required this.didFinishUpdatingFilter});

  @override
  State<ReservationFilterPopOver> createState() => _ReservationFilterPopOverState();
}

class _ReservationFilterPopOverState extends State<ReservationFilterPopOver> {
  
  late ReservationFilterObject? currentFilterObject = null;
  
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
                          contactStatusOptions: null,
                          reservationHostingType: null,
                          formStatus: null,
                          privateReservationsOnly: null,
                          isReverseSorted: null,
                          filterByDateType: null,
                          filterWithStartDate: null,
                          filterWithEndDate: null,
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
                    if (getNumberOfReservationFilterItems(currentFilterObject, widget.currentFilterMode) == 0) {
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
                  title: Text('Reservations can be sorted and filtered based on the settings below.', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  subtitle: Text('Use the options provided to customize your reservation view. You can filter by date, status, and more.', style: TextStyle(color: widget.model.disabledTextColor),
                  ),
                ),
                const SizedBox(height: 15),
                if (widget.currentFilterMode.contactStatusOptions != null) Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 6,
                spacing: 8,
                children: (widget.currentFilterMode.contactStatusOptions ?? []).map((e) {
                    return InkWell(
                      onTap: () {

                        if (e == null) {
                          return;
                        }

                        setState(() {

                          late List<ContactStatus> selectedStatuses = [];
                          selectedStatuses.addAll(currentFilterObject?.contactStatusOptions ?? []);
                          if (selectedStatuses.contains(e)) {
                            selectedStatuses.remove(e);
                          } else {
                            selectedStatuses.add(e);
                          }

                          if (currentFilterObject?.contactStatusOptions == null) {
                            currentFilterObject = currentFilterObject?.copyWith(
                                contactStatusOptions: selectedStatuses,
                            );
                          } else {
                            currentFilterObject = currentFilterObject?.copyWith(
                                contactStatusOptions: selectedStatuses,
                            );
                          }
// Toggle off // Toggle to Activities
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: ((currentFilterObject?.contactStatusOptions ?? []).contains(e)) ? widget.model.paletteColor : widget.model.accentColor,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                          child: Text(e?.name ?? '', textAlign: TextAlign.center, style: TextStyle(color: (currentFilterObject?.contactStatusOptions ?? []).contains(e) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      )
                    )
                  );
                }).toList(),
              ),

                if (widget.currentFilterMode.reservationHostingType != null) 
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 6,
                  spacing: 8,
                  children: (widget.currentFilterMode.reservationHostingType ?? []).map((e) {
                  return InkWell(
                    onTap: () {
                    

                    setState(() {
                      late List<ReservationSlotState> selectedTypes = [];
                      selectedTypes.addAll(currentFilterObject?.reservationHostingType ?? []);
                        if (selectedTypes.contains(e)) {
                        selectedTypes.remove(e);
                        } else {
                        selectedTypes.add(e);
                        }

                      if (currentFilterObject?.reservationHostingType == null) {
                      currentFilterObject = currentFilterObject?.copyWith(
                        reservationHostingType: selectedTypes,
                      );
                      } else {
                      currentFilterObject = currentFilterObject?.copyWith(
                        reservationHostingType: selectedTypes,
                      );
                      }
                    });
                    },
                    child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: ((currentFilterObject?.reservationHostingType ?? []).contains(e)) ? widget.model.paletteColor : widget.model.accentColor,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: Text(e?.name ?? '', textAlign: TextAlign.center, style: TextStyle(color: (currentFilterObject?.reservationHostingType ?? []).contains(e) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 15),
              ListTile(
                title: Text('Sort', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                subtitle: Text('Choose how you want to sort your reservations. You can sort by date, status, and more.', style: TextStyle(color: widget.model.disabledTextColor)),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: Text('Private Only', style: TextStyle(color:  (currentFilterObject?.privateReservationsOnly == true) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                leading: Icon(Icons.lock, color: (currentFilterObject?.privateReservationsOnly == true) ? widget.model.paletteColor : widget.model.disabledTextColor),
                trailing: Container(
                  width: 60,
                  child: FlutterSwitch(
                    width: 60,
                    activeColor: widget.model.paletteColor,
                    inactiveColor: widget.model.accentColor,
                    value: currentFilterObject?.privateReservationsOnly ?? false,
                    onToggle: (val) {
                      setState(() {
                        currentFilterObject = currentFilterObject?.copyWith(privateReservationsOnly: val);
                      });
                    },
                  ),
                ),
              ),
              ListTile(
                title: Text('Reverse Order - Old to New', style: TextStyle(color: (currentFilterObject?.isReverseSorted == true) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                leading: Icon(Icons.arrow_circle_left_rounded, color: (currentFilterObject?.isReverseSorted == true) ? widget.model.paletteColor : widget.model.disabledTextColor),
                trailing: Container(
                  width: 60,
                  child: FlutterSwitch(
                    width: 60, 
                    activeColor: widget.model.paletteColor,
                    inactiveColor: widget.model.accentColor,
                    value: currentFilterObject?.isReverseSorted ?? false,
                    onToggle: (val) {
                      setState(() {
                      currentFilterObject = currentFilterObject?.copyWith(isReverseSorted: val);
                    });
                  },
                  ),
                ),
              ),

              // DateRangeSliderWidget(
              //   initialStart: currentFilterObject.filterWithStartDate,
              //   initialEnd: currentFilterObject.filterWithEndDate,
              //   monthlyActivityCounts: [0], 
              //   model: widget.model, 
              //   didUpdateMonthRange: (start, end) {
              //     setState(() {
              //       currentFilterObject = currentFilterObject?.copyWith(
              //         filterWithStartDate: start, 
              //         filterWithEndDate: end
              //       );
              //     });
              //   }
              // ),

            ]
          )
        )
      )
    );
  }
}