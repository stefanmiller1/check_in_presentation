import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FilePickerPreviewerWidget {

  static void didOpenDocument(BuildContext context, DocumentFormOption document, DashboardModel model) async {

    if (document.documentForm.uriPath != null) {
      if (await canLaunchUrlString(document.documentForm.uriPath!)) {
        launchUrlString(document.documentForm.uriPath!);
        }
      } else {

      final snackBar = SnackBar(
          elevation: 4,
          backgroundColor: model.paletteColor,
          content: Text('Sorry, preview is allowed after saving', style: TextStyle(color: model.webBackgroundColor))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  static Future<DocumentFormOption> handleFileSelection(BuildContext context, DashboardModel model) async {

    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );

    if (file != null && file.files.isNotEmpty) {
      XFile? fileBytes = file.files.first.xFile;
      final imageFile = await fileBytes.readAsBytes();
      String fileName = file.files.first.name;

      final DocumentFormOption document = DocumentFormOption(
          documentForm: ImageUpload(
              key: UniqueId().getOrCrash(),
              imageToUpload: imageFile
          ),
          isRequiredOption: false
      );

      return document;
    } else {
      final snackBar = SnackBar(
          elevation: 4,
          backgroundColor: model.paletteColor,
          content: Text('Sorry, something went wrong', style: TextStyle(color: model.webBackgroundColor))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return Future.error('Sorry, something went wrong');
  }
}
