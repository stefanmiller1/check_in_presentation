import 'package:flutter/material.dart';
import '../../../../check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:intl/intl.dart';

Widget openClosedDates(BuildContext context, DashboardModel model, VendorMerchantForm form, DateTime endDate, {required Function(DateTimeRange) dateChanged}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        const SizedBox(height: 8),
        Text('Select a date below for when you want the form to open - and when the form is no longer accepting applications.', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2),
        Text('Leaving this off will leave your form open - until manually closed by you - or until after your reservation has ended', style: TextStyle(color: model.disabledTextColor)),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Form Opens on:', style: TextStyle(color: model.disabledTextColor)),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    DateTime? _selectedDate = await showDatePicker(
                        context: context,
                        initialDate: form.openCloseDates?.start,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: model.accentColor,
                              colorScheme: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? ColorScheme.dark(
                                  primary: model.paletteColor,
                                  onSurface: model.paletteColor
                                  ) : ColorScheme.light(
                                  primary: model.paletteColor,
                                  onSurface: model.paletteColor
                              ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: model.paletteColor, // button text color
                                  ),
                                ),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary,
                              ),
                            ),
                              child: child ?? Container(),
                          );
                        },
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime.now(),
                        lastDate: form.openCloseDates?.end ?? endDate,
                    );

                    if (_selectedDate != null) {
                      dateChanged(DateTimeRange(start: _selectedDate ?? DateTime.now(), end: form.openCloseDates?.end ?? endDate));
                    }
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: model.accentColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(DateFormat.yMMMd().format(form.openCloseDates?.start ?? DateTime.now()), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                    )
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Container(
                      color: model.disabledTextColor,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Form Closes on:', style: TextStyle(color: model.disabledTextColor)),
                InkWell(
                  onTap: () async {
                    DateTime? _selectedDate = await showDatePicker(
                      context: context,
                      initialDate: form.openCloseDates?.end,
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: model.accentColor,
                            colorScheme: (MediaQuery.of(context).platformBrightness == Brightness.dark) ? ColorScheme.dark(
                                primary: model.paletteColor,
                                onSurface: model.paletteColor
                            ) : ColorScheme.light(
                                primary: model.paletteColor,
                                onSurface: model.paletteColor
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: model.paletteColor, // button text color
                              ),
                            ),
                            buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary,
                            ),
                          ),
                          child: child ?? Container(),
                        );
                      },
                      initialDatePickerMode: DatePickerMode.day,
                      firstDate: form.openCloseDates?.start ?? DateTime.now(),
                      lastDate: endDate,
                    );

                    if (_selectedDate != null) {
                      dateChanged(DateTimeRange(start: form.openCloseDates?.start ?? DateTime.now(), end:  _selectedDate ?? endDate ));
                    }
                  },
                  child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(DateFormat.yMMMd().format(form.openCloseDates?.end ?? endDate), style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      )
                  ),
                )
              ],
            )
          ],
        )
      ],
    ),
  );
}