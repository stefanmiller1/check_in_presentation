import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';

Future<Uint8List?> handleImageSelection(BuildContext context, DashboardModel model) async {
  final imageData = await ImagePickerWeb.getImageAsBytes();
  return imageData;
}


void presentSelectPictureOptions(BuildContext context, DashboardModel model, {required Function(ImageSource source) imageSource}) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(12.0),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: model.accentColor,
                borderRadius: BorderRadius.circular(15)
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      imageSource(ImageSource.camera);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Take a Photo', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Divider(color: model.disabledTextColor),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      imageSource(ImageSource.gallery);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text('Choose From Library', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                  color: model.accentColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Center(child: Text('Cancel', style: TextStyle(color: model.paletteColor))),
            ),
          )
        ],
      ),
    );
  }
  );
}