import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> handleImageSelection(BuildContext context, DashboardModel model, ) async {
  final ImagePicker _picker = ImagePicker();

  final imageSelected = await _picker.pickImage(
      source: ImageSource.gallery,
  );
  final imageData = await imageSelected?.readAsBytes();
  return imageData;

}