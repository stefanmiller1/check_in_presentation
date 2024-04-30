import 'package:flutter/material.dart';
import '../../../../check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';

Widget welcomeMessage(BuildContext context, DashboardModel model, VendorMerchantForm form, {required Function(String) onChanged}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        const SizedBox(height: 8),
        Expanded(
            child: Text('Greet potential applicants with a welcome message - let them get a feel for the market they are applying for. adawd awd', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.fade), maxLines: 2,
            ),
        ),
        const SizedBox(height: 18),
        TextFormField(
          style: TextStyle(color: model.paletteColor),
          maxLines: 3,
          initialValue: form.welcomeMessage,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: model.disabledTextColor),
            hintText: 'Just so you know...',
            errorStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: model.paletteColor,
            ),
            filled: true,
            fillColor: model.accentColor,
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                width: 2,
                color: model.paletteColor,
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
                color: model.paletteColor,
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
          onChanged: (value) => onChanged(value),
        ),

      ]
    ),
  );
}