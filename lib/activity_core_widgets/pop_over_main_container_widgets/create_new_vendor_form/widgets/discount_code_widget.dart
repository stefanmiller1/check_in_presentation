import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_presentation/core/voucher_widget.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/discount_code_service/discount_code_item.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';

class DiscountCodeGeneratorWidget extends StatefulWidget {

  final DashboardModel model;
  final VendorMerchantForm form;
  final DiscountCode? currentDiscountOption;
  final Function(DiscountCode) onChange;

  const DiscountCodeGeneratorWidget({super.key, required this.model, required this.form, this.currentDiscountOption, required this.onChange});

  @override
  State<DiscountCodeGeneratorWidget> createState() => _DiscountCodeGeneratorWidgetState();
}

class _DiscountCodeGeneratorWidgetState extends State<DiscountCodeGeneratorWidget> {

  void _copyToClipboard() {
    if (widget.currentDiscountOption?.codeId != null) {
      Clipboard.setData(ClipboardData(text: widget.currentDiscountOption!.codeId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to Clipboard!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not copy - please try again'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text('Copy Your Discount Code below set a discount amount and title', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2),
          const SizedBox(height: 4),
          Text('Discount Code Title', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2),
          const SizedBox(height: 4),
          TextFormField(
            style: TextStyle(color: widget.model.paletteColor),
            initialValue: widget.currentDiscountOption?.discountTitle,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: widget.model.disabledTextColor),
              hintText: '20% Off - Friends Discount',
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
              late DiscountCode? newDiscountCode = widget.currentDiscountOption;
              if (value.isEmpty) {
                newDiscountCode = newDiscountCode?.copyWith(
                    discountTitle: null
                );
              } else {
                newDiscountCode = newDiscountCode?.copyWith(
                    discountTitle: value
                );
              }
              if (newDiscountCode != null) {
                widget.onChange(newDiscountCode);
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
                  Text('Discount Amount', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2),
                  const SizedBox(height: 4),
                  Container(
                    width: 100,
                    child: TextFormField(
                      style: TextStyle(color: widget.model.paletteColor),
                      initialValue: widget.currentDiscountOption?.discountAmount.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.percent_outlined, color: widget.model.disabledTextColor),
                        hintStyle: TextStyle(color: widget.model.disabledTextColor),
                        hintText: '20',
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
                        late DiscountCode? newDiscountCode = widget.currentDiscountOption;

                        // Check if value is empty or not a valid number
                        int? parsedValue;
                        try {
                          parsedValue = int.parse(value);
                        } catch (e) {
                          parsedValue = null; // Parsing failed, handle it accordingly
                        }

                        // If value is empty or invalid, set discountAmount to 1
                        if (value.isEmpty || parsedValue == null || parsedValue == 0) {
                          newDiscountCode = newDiscountCode?.copyWith(discountAmount: 1);
                        } else {
                          newDiscountCode = newDiscountCode?.copyWith(discountAmount: parsedValue);
                        }

                        // Only trigger onChange if newDiscountCode is not null and parsedValue is not 0
                        if (newDiscountCode != null && parsedValue != null && parsedValue != 0) {
                          widget.onChange(newDiscountCode);
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
                  Text('Disable Discount', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
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
                      value: widget.currentDiscountOption?.isNotValid ?? false,
                      onToggle: (value) {
                        late DiscountCode? newDiscountCode = widget.currentDiscountOption;
                        newDiscountCode = newDiscountCode?.copyWith(
                            isNotValid: value
                        );
                        if (newDiscountCode != null) {
                          widget.onChange(newDiscountCode);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Create Invite List', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: InkWell(
                      onTap: () {
                        presentPrivateInviteDialog(
                            context,
                            widget.model,
                            [],
                            selectedProfilesToSave: () {

                          }
                        );
                      },
                      child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: widget.model.paletteColor
                          ),
                          child: Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text((widget.currentDiscountOption?.privateList == null || widget.currentDiscountOption?.privateList?.isEmpty == true) ? '  Send & Share  ' : ' ${widget.currentDiscountOption?.privateList?.length ?? 0} Invited: add More  ', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.accentColor)),
                          )
                        )
                      ),
                    ),
                  ),
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Make Private', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  Text('Can only be used by those invited', style: TextStyle(color: widget.model.disabledTextColor)),
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
                      value: widget.currentDiscountOption?.isPrivate ?? false,
                      onToggle: (value) {
                        late DiscountCode? newDiscountCode = widget.currentDiscountOption;
                        newDiscountCode = newDiscountCode?.copyWith(
                            isPrivate: value
                        );
                        if (newDiscountCode != null) {
                          widget.onChange(newDiscountCode);
                        }
                      },
                    ),
                  ),
                ],
              )

            ],
          ),
          const SizedBox(height: 15),
          Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _copyToClipboard(),
                child: Column(
                  children: [
                    FlexibleShapeContainer(
                        isTopConvex: false,
                        isBottomConvex: true,
                        model: widget.model,
                        isNotValid: widget.currentDiscountOption?.isNotValid == true,
                        mainWidget: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(widget.currentDiscountOption?.discountTitle ?? 'Voucher', style: TextStyle(color: (widget.currentDiscountOption?.isNotValid == true) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.questionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
                                ),
                                Text(widget.currentDiscountOption?.codeId ?? '', style: TextStyle(color: (widget.currentDiscountOption?.isNotValid == true) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: 40, fontWeight: FontWeight.bold)),
                          ],
                        )
                      )
                    ),
                    const SizedBox(height: 2),
                    FlexibleShapeContainer(
                        isTopConvex: true,
                        isBottomConvex: false,
                        model: widget.model,
                        isNotValid: widget.currentDiscountOption?.isNotValid == true,
                        mainWidget: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${widget.currentDiscountOption?.discountAmount}% Off Discount', style: TextStyle(color: (widget.currentDiscountOption?.isNotValid == true) ? widget.model.accentColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                                const SizedBox(height: 8),
                                Text('Press Here to Copy to Share', style: TextStyle(color: (widget.currentDiscountOption?.isNotValid == true) ? widget.model.accentColor : widget.model.disabledTextColor)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('Your attendee will be able to use this voucher upon checkout', style: TextStyle(color: (widget.currentDiscountOption?.isNotValid == true) ? widget.model.accentColor : widget.model.disabledTextColor), textAlign: TextAlign.center,),
                            ),
                          ],
                        )
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: InkWell(
              onTap: () => _copyToClipboard(),
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: widget.model.accentColor
                  ),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('  Copy Voucher  ', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor)),
                  )
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }
}


