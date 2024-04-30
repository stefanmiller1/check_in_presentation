import 'dart:typed_data';

import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:html' as html;

class FilePickerPreviewerWidget {

  static void didOpenDocument(BuildContext context, DocumentFormOption document, DashboardModel model) async {

    if (document.documentForm.uriPath != null) {
      if (await canLaunchUrlString(document.documentForm.uriPath!)) {
        launchUrlString(document.documentForm.uriPath!);
      }
    } else {
      print('blobbing');
      final blob = html.Blob([document.documentForm.imageToUpload]);
      final url = html.Url.createObjectUrl(blob);

      // Create a link element
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", '${document.documentForm.key}.pdf');

      // Programmatically click the link to trigger the download
      html.document.body!.append(anchor);
      anchor.click();

      // Cleanup
      html.Url.revokeObjectUrl(url);
      anchor.remove();

    }
  }

  static Future<DocumentFormOption> handleFileSelection(BuildContext context, DashboardModel model) async {

    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );

    if (file != null && file.files.isNotEmpty) {
      Uint8List? fileBytes = file.files.first.bytes;
      String fileName = file.files.first.name;

      final DocumentFormOption document = DocumentFormOption(
          documentForm: ImageUpload(
              key: '$fileName - ${UniqueId().getOrCrash()}',
              imageToUpload: fileBytes
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