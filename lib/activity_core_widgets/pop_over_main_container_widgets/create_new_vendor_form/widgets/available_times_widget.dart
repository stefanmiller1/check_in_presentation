import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../../check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_availability/mv_custom_availability.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as UI;

class VendorFormAvailableTimesWidget extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final VendorMerchantForm form;
  final MCCustomAvailability? currentAvailability;
  final Function(MCCustomAvailability) onChanged;

  const VendorFormAvailableTimesWidget({super.key, required this.model, required this.reservation, required this.form, required this.onChanged, this.currentAvailability});

  @override
  State<VendorFormAvailableTimesWidget> createState() => _VendorFormAvailableTimesWidgetState();
}

class _VendorFormAvailableTimesWidgetState extends State<VendorFormAvailableTimesWidget> {

  late PageController? timePageController = PageController(viewportFraction: 0.375);
  late bool isHovering = false;


  @override
  void dispose() {
    timePageController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text('Create the time & availability you want to offer your vendors. Let vendors know how many days they will be vending based on dates you\'ve secured!', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 3,),

            const SizedBox(height: 18),
            IgnorePointer(
              ignoring: widget.currentAvailability?.isConfirmed == true,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: (widget.currentAvailability?.isConfirmed == true) ? widget.model.accentColor : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getDatesToSelect(
                          context,
                          widget.reservation,
                          widget.currentAvailability?.selectedSlotItem ?? [],
                          didSelectTimeSlot: (res) {

                            late MCCustomAvailability? newAvailability = widget.currentAvailability;
                            List<ReservationSlotItem> slots = [];
                            slots.addAll(newAvailability?.selectedSlotItem ?? []);


                            if (slots.contains(res) == true) {
                              slots.remove(res);
                            } else {
                              slots.add(res);
                            }

                            newAvailability = newAvailability?.copyWith(
                                selectedSlotItem: slots
                            );

                            if (newAvailability != null) {
                              widget.onChanged(newAvailability);
                            }
                          }
                      ),
                      Text('Select the dates that belong to this slot...Vendors will be participating on the dates you include for this Time Slot', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2,),
                      Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {

                              if (widget.currentAvailability?.selectedSlotItem.isEmpty == true) {
                                /// show error message
                                return;
                              }

                              late MCCustomAvailability? newAvailability = widget.currentAvailability;
                              /// show confirmation message
                              newAvailability = newAvailability?.copyWith(
                                  isConfirmed: true
                              );
                              if (newAvailability != null) {
                                widget.onChanged(newAvailability);
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: widget.currentAvailability?.isConfirmed == true ? widget.model.disabledTextColor.withOpacity(0.5) : (widget.currentAvailability?.selectedSlotItem.isNotEmpty == true) ? widget.model.paletteColor : widget.model.accentColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (widget.currentAvailability?.isConfirmed == true) Icon(
                                        Icons.lock,
                                        color: widget.model.disabledTextColor,
                                      ),
                                      Text(widget.currentAvailability?.isConfirmed == true ? 'Confirmed' : 'Confirm', style: TextStyle(color: widget.currentAvailability?.isConfirmed == true ? widget.model.disabledTextColor : (widget.currentAvailability?.selectedSlotItem.isNotEmpty == true) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                ],
                              ),
                            )
                          ),
                        )
                      ),
                    ],
                  ),
                )
              ),
            ),



            AnimatedContainer(
                height: (widget.currentAvailability?.isConfirmed == true) ? 525 : 0,
                duration: const Duration(milliseconds: 350),
                  child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Have a name or theme for these dates?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            style: TextStyle(color: widget.model.paletteColor),
                            initialValue: widget.currentAvailability?.dateTitle,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: widget.model.disabledTextColor),
                              hintText: 'Slot 1...',
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.paletteColor,
                              ),
                              filled: true,
                              fillColor: widget.model.accentColor,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: widget.model.paletteColor,
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
                                  color: widget.model.paletteColor,
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
                            onChanged: (value) {
                              late MCCustomAvailability? newAvailability = widget.currentAvailability;
                              newAvailability = newAvailability?.copyWith(
                                  dateTitle: (value.isEmpty) ? null : value
                              );

                              if (newAvailability != null) {
                                widget.onChanged(newAvailability);
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          Text('Any more details you would like to add?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 1,
                          ),
                          const SizedBox(height: 4),
                          TextFormField(
                            style: TextStyle(color: widget.model.paletteColor),
                            initialValue: widget.currentAvailability?.slotDescription,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: widget.model.disabledTextColor),
                              hintText: 'All things clothing & vintage...',
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.paletteColor,
                              ),
                              filled: true,
                              fillColor: widget.model.accentColor,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  width: 2,
                                  color: widget.model.paletteColor,
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
                                  color: widget.model.paletteColor,
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
                            onChanged: (value) {
                              late MCCustomAvailability? newAvailability = widget.currentAvailability;
                              if (value.isEmpty) {
                                newAvailability = newAvailability?.copyWith(
                                    slotDescription: null
                                );
                              } else {
                                newAvailability = newAvailability?.copyWith(
                                    slotDescription: value
                                );
                              }

                              if (newAvailability != null) {
                                widget.onChanged(newAvailability);
                              }
                            },
                          ),
                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Limit Slots?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                  Text('Leave this blank if you do not want to \nlimit applicants.', style: TextStyle(color: widget.model.disabledTextColor)),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 80,
                                    child: TextFormField(
                                      style: TextStyle(color: widget.model.paletteColor),
                                      initialValue: (widget.currentAvailability?.slotLimit != null) ? widget.currentAvailability?.slotLimit.toString() : null,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(color: widget.model.disabledTextColor),
                                        hintText: '0',
                                        errorStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: widget.model.paletteColor,
                                        ),
                                        filled: true,
                                        fillColor: widget.model.accentColor,
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: widget.model.paletteColor,
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
                                            color: widget.model.paletteColor,
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
                                      onChanged: (value) {
                                        late MCCustomAvailability? newAvailability = widget.currentAvailability;
                                        if (value.isEmpty) {
                                          newAvailability = newAvailability?.copyWith(
                                              slotLimit: null
                                          );
                                        } else {
                                          newAvailability = newAvailability?.copyWith(
                                              slotLimit: int.parse(value)
                                          );
                                        }
                                        if (newAvailability != null) {
                                          widget.onChanged(newAvailability);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Create wait-list', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                  Text('Must have a limit to create a \nwait-list', textAlign: TextAlign.end, style: TextStyle(color: widget.model.disabledTextColor)),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    child: FlutterSwitch(
                                      width: 60,
                                      inactiveToggleColor: widget.model.accentColor,
                                      inactiveIcon: Icon(Icons.add, color: widget.model.disabledTextColor),
                                      inactiveTextColor: widget.model.paletteColor,
                                      inactiveColor: widget.model.mobileBackgroundColor,
                                      activeColor: widget.model.paletteColor,
                                      value: widget.currentAvailability?.waitListOffered ?? false,
                                      onToggle: (value) {
                                        late MCCustomAvailability? newAvailability = widget.currentAvailability;

                                        newAvailability = newAvailability?.copyWith(
                                            waitListOffered: value
                                        );

                                        if (newAvailability != null) {
                                          widget.onChanged(newAvailability);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 18),
                          Wrap(
                            alignment: WrapAlignment.start,
                            runSpacing: 6,
                            spacing: 8,
                            children: MerchantVendorTypes.values.map(
                                    (e) => InkWell(
                                  onTap: () {

                                    late MCCustomAvailability? newAvailability = widget.currentAvailability;
                                    List<MerchantVendorTypes> types = [];
                                    types.addAll(newAvailability?.vendorType ?? []);


                                    if (types.contains(e) == true) {
                                      types.remove(e);
                                    } else {
                                      types.add(e);
                                    }

                                    newAvailability = newAvailability?.copyWith(
                                        vendorType: types
                                    );

                                    if (newAvailability != null) {
                                      widget.onChanged(newAvailability);
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: (widget.currentAvailability?.vendorType?.contains(e) == true) ? widget.model.paletteColor : widget.model.accentColor,
                                          borderRadius: BorderRadius.circular(18)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(getVendorMerchTitle(e), style: TextStyle(color: (widget.currentAvailability?.vendorType?.contains(e) == true) ? widget.model.accentColor : widget.model.disabledTextColor)),
                                      )
                                  ),
                                )
                            ).toList(),
                          ),

                  ],
                ),
              ),
            ),



        ]
      ),
    );
  }


  Widget getDatesToSelect(BuildContext context, ReservationItem reservation, List<ReservationSlotItem> selectedSlotItem, {required Function(ReservationSlotItem) didSelectTimeSlot}) {
    return Column(
      children: [
        for (var entry in getGroupBySpaceBookings(reservation.reservationSlotItem).entries.toList()..sort((a,b) => b.key.compareTo(a.key)))

          pagingControllerForForm(
              context,
              widget.model,
              timePageController,
              false,
              false,
              90,
              isHovering,
              Container(),
              entry.value.map((e) {

                final String? spaceType = getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).isNotEmpty ? getSpaceTypeOptions(context).where((i) => i.uid == e.selectedSpaceId).first.spaceTitle : null;

                return InkWell(
                onTap: () {
                    if (isSelectedAvailabilitySlot(e, widget.form) && widget.currentAvailability?.selectedSlotItem.contains(e) == false) {
                      return;
                    }
                    didSelectTimeSlot(e);
                  },
                child: Container(
                  width: (Responsive.isMobile(context) == false) ? 350 : 250,
                  decoration: BoxDecoration(
                      border: (selectedSlotItem.contains(e)) ? Border.all(color: widget.model.paletteColor) : null ,
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: (isSelectedAvailabilitySlot(e, widget.form) && widget.currentAvailability?.selectedSlotItem.contains(e) == false) ? widget.model.paletteColor.withOpacity(0.1) : widget.model.paletteColor.withOpacity(0.025),
                          borderRadius: BorderRadius.all(Radius.circular(25))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(spaceType ?? 'Space', style: TextStyle(color: widget.model.disabledTextColor)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                      Flexible(child: Align(alignment: Alignment.centerRight, child: Text('${DateFormat.MMMEd().format(e.selectedDate)}', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 1, textDirection: UI.TextDirection.rtl))),
                                      const SizedBox(width: 5),
                                      if (Responsive.isMobile(context) == false) Icon(Icons.calendar_today_outlined, size: 20, color: widget.model.disabledTextColor),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ).toList(),
              didStartHover: (show) {
                setState(() {
                  isHovering = show;
                });
              },
              didSelectArrow: (forwardBack) {
                setState(() {
                  if (forwardBack) {
                    timePageController?.animateTo((timePageController?.offset ?? 0) + 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  } else {
                    timePageController?.animateTo((timePageController?.offset ?? 0) - 400, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                  }
                });
              },
              didSelectRemove: (index) {

              }
          ),
      ],
    );
  }
}


