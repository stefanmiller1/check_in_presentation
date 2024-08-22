import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../../check_in_presentation.dart';
import '../../../../profile_core_widgets/profile_settings/components/payments_widget/payout_payment_methods_widget.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/booth_payments/mv_booth_payments.dart';
import 'package:check_in_domain/domain/misc/attendee_services/form/merchant_vendor/custom_availability/mv_custom_availability.dart';
import 'package:intl/intl.dart';
import 'package:check_in_credentials/check_in_credentials.dart';


class VendorFormBoothPaymentWidget extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final ReservationItem reservation;
  final VendorMerchantForm form;
  final MVBoothPayments? currentBoothPayment;
  final ActivityManagerForm activityForm;
  final Function(MVBoothPayments) onChanged;

  const VendorFormBoothPaymentWidget({super.key, required this.model, required this.reservation, required this.form, required this.onChanged, this.currentBoothPayment, required this.activityForm, required this.currentUser});

  @override
  State<VendorFormBoothPaymentWidget> createState() => _VendorFormBoothPaymentWidgetState();
}

class _VendorFormBoothPaymentWidgetState extends State<VendorFormBoothPaymentWidget> {

  late PageController? timePageController = PageController(viewportFraction: 0.30);
  late bool isHovering = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          Text('Name of booth?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 3,),
          const SizedBox(height: 4),
          TextFormField(
            style: TextStyle(color: widget.model.paletteColor),
            initialValue: widget.currentBoothPayment?.boothTitle,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: widget.model.disabledTextColor),
              hintText: 'Table - 6 x 5\'',
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
              late MVBoothPayments? newBoothPayment = widget.currentBoothPayment;
              if (value.isEmpty) {
                newBoothPayment = newBoothPayment?.copyWith(
                    boothTitle: null
                );
              } else {
                newBoothPayment = newBoothPayment?.copyWith(
                    boothTitle: value
                );
              }
              if (newBoothPayment != null) {
                widget.onChanged(newBoothPayment);
              }
            },
          ),

          Visibility(
            visible: widget.form.availableTimeSlots?.where((element) => element.isConfirmed == true).isNotEmpty == true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Text('Any dates this booth will not be available?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 3,),
                const SizedBox(height: 4),

                pagingControllerForForm(
                    context,
                    widget.model,
                    timePageController,
                    false,
                    false,
                    57.5,
                    isHovering,
                    Container(),
                    widget.form.availableTimeSlots?.where((element) => element.isConfirmed == true).toList().asMap().map((i, e) => MapEntry(
                      i,
                      InkWell(
                      onTap: () {
                        late MVBoothPayments? newBoothPayment = widget.currentBoothPayment;
                        List<MCCustomAvailability> availability = [];
                        availability.addAll(newBoothPayment?.unavailableBoothDates ?? []);

                        if (availability.contains(e) == true) {
                          availability.remove(e);
                        } else {
                          availability.add(e);
                        }

                        newBoothPayment = newBoothPayment?.copyWith(
                            unavailableBoothDates: availability
                        );

                        if (newBoothPayment != null) {
                          widget.onChanged(newBoothPayment);
                        }


                      },
                      child: Container(
                        width: 250,
                        decoration: BoxDecoration(
                            border: (widget.currentBoothPayment?.unavailableBoothDates?.map((e) => e.uid).contains(e.uid) == true) ? Border.all(color: widget.model.paletteColor) : null ,
                            borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.model.paletteColor.withOpacity(0.025),
                                borderRadius: BorderRadius.all(Radius.circular(25))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.calendar_month, color: widget.model.disabledTextColor),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(e.dateTitle ?? 'Slot ${i + 1}', style: TextStyle(color: widget.model.disabledTextColor, overflow: TextOverflow.fade), maxLines: 1)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      )
                    ).values.toList() ?? [],
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
            ),
          ),



          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Limit Booths?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  Text('Leave this blank if you do not want to \nlimit this booth type.', style: TextStyle(color: widget.model.disabledTextColor)),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    child: TextFormField(
                      style: TextStyle(color: widget.model.paletteColor),
                      initialValue: (widget.currentBoothPayment?.boothLimit != null) ? widget.currentBoothPayment?.boothLimit.toString() : null,
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
                        late MVBoothPayments? newBoothPayment = widget.currentBoothPayment;
                        if (value.isEmpty) {
                          newBoothPayment = newBoothPayment?.copyWith(
                              boothLimit: null
                          );
                        } else {
                          newBoothPayment = newBoothPayment?.copyWith(
                              boothLimit: int.parse(value)
                          );
                        }
                        if (newBoothPayment != null) {
                          widget.onChanged(newBoothPayment);
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
                      value: widget.currentBoothPayment?.waitListOffered ?? false,
                      onToggle: (value) {
                        late MVBoothPayments? newBoothPayment = widget.currentBoothPayment;
                        newBoothPayment = newBoothPayment?.copyWith(
                            waitListOffered: value
                        );
                        if (newBoothPayment != null) {
                          widget.onChanged(newBoothPayment);
                        }

                      },
                    ),
                  ),
                ],
              )
            ],
          ),

          const SizedBox(height: 8),
          Visibility(
            visible: widget.currentUser.stripeCustomerId == null,
            child: InkWell(
              onTap: () {
                if (kIsWeb) {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: 'Payment Methods',
                    transitionDuration: Duration(milliseconds: 350),
                    pageBuilder: (BuildContext contexts, anim1, anim2) {
                      return  Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.model.accentColor,
                                      borderRadius: BorderRadius.all(Radius.circular(17.5))
                                  ),
                                  width: 550,
                                  height: 750,
                                  child: PayoutAccountLink(
                                    model: widget.model,
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return PayoutAccountLink(
                          model: widget.model,
                        );
                      })
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisSize: MainAxisSize.max,
                 children: [

                  const SizedBox(height: 15),
                  Text('Booth Fees?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  Text('setup you stripe account to begin accepting payments', style: TextStyle(color: widget.model.disabledTextColor,)),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(' Setup Payouts ', textAlign: TextAlign.center, style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    )
                  ),
                ]
              )
            )
          ),

          Visibility(
            visible: widget.currentUser.stripeCustomerId != null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booth Fee?', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    Text('Leave this blank if you do not want to \n charge vendors.', style: TextStyle(color: widget.model.disabledTextColor)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          child: TextFormField(
                            style: TextStyle(color: widget.model.paletteColor),
                            initialValue: (widget.currentBoothPayment?.fee != null) ? widget.currentBoothPayment?.fee.toString() : null,
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
                              late MVBoothPayments? newBoothPayment = widget.currentBoothPayment;
                              if (value.isEmpty) {
                                newBoothPayment = newBoothPayment?.copyWith(
                                    fee: null
                                );
                              } else {
                                newBoothPayment = newBoothPayment?.copyWith(
                                    fee: int.parse(value)
                                );
                              }
                              if (newBoothPayment != null) {
                                widget.onChanged(newBoothPayment);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${NumberFormat.simpleCurrency(locale: widget.activityForm.rulesService.currency).currencyName}', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      ],
                    ),
                    Visibility(
                      visible: (widget.currentBoothPayment?.fee != null &&  widget.currentBoothPayment?.fee != 0),
                      child: Row(
                        children: [
                          Text('= ${completeTotalPriceWithCurrency(
                              (widget.currentBoothPayment?.fee ?? 0) -
                              ((widget.currentBoothPayment?.fee ?? 0) * CICOSellerPercentageFee),
                              widget.activityForm.rulesService.currency)}', style: TextStyle(color: widget.model.disabledTextColor)),
                          const SizedBox(width: 8),
                          Text('in Earnings', style: TextStyle(color: widget.model.disabledTextColor))
                        ],
                      ),
                    )
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Refunds', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    Text('Must have a fee to offer \n refunds', textAlign: TextAlign.end, style: TextStyle(color: widget.model.disabledTextColor)),
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
                        value: widget.currentBoothPayment?.refundAvailable == true,
                        onToggle: (value) {
                          late MVBoothPayments? newBoothPayment = widget.currentBoothPayment;
                          newBoothPayment = newBoothPayment?.copyWith(
                              refundAvailable: value
                          );
                          if (newBoothPayment != null) {
                            widget.onChanged(newBoothPayment);
                          }

                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
