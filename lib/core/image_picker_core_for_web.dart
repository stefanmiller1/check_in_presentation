import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';

Future<Uint8List?> handleImageSelection(BuildContext context, DashboardModel model) async {
  final imageData = await ImagePickerWeb.getImageAsBytes();
  return imageData;
}
