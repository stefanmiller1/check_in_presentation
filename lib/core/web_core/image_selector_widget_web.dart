import 'dart:typed_data';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImageSelectorWithPreview extends StatefulWidget {
  final DashboardModel model;
  final bool? showTitle;
  final int? numberOfImages;
  final List<ImageUpload> currentImageList;
  final Function(List<ImageUpload>) imagesToUpLoad;

  const ImageSelectorWithPreview({
    super.key,
    required this.currentImageList,
    required this.imagesToUpLoad,
    required this.model,
    this.showTitle = true,
    this.numberOfImages,
  });

  @override
  _ImageSelectorWithPreviewState createState() => _ImageSelectorWithPreviewState();
}

class _ImageSelectorWithPreviewState extends State<ImageSelectorWithPreview> {

  static const int maxSizeInBytes = 5 * 1024 * 1024; 

  void _handleImageSelection(BuildContext context) async {
    final files = await ImagePickerWeb.getMultiImagesAsBytes();
    late List<ImageUpload> currentImages = [];
    currentImages.addAll(widget.currentImageList);

    if (files != null && (files.isNotEmpty)) {
      if ((files.length + currentImages.length) <= 6 && currentImages.length <= 6) {
        List<ImageUpload> validImages = [];
        for (Uint8List dataImage in files) {
          if (dataImage.lengthInBytes > maxSizeInBytes) {
            // Display SnackBar for files exceeding 5MB
            final snackBar = SnackBar(
              elevation: 4,
              backgroundColor: widget.model.paletteColor,
              content: Text(
                'One or more files exceed 5MB. Please select smaller files.',
                style: TextStyle(color: widget.model.webBackgroundColor),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            continue;
          }

          validImages.add(ImageUpload(
            key: UniqueId().getOrCrash(),
            imageToUpload: dataImage,
          ));
        }

        if (validImages.isNotEmpty) {
          currentImages.addAll(validImages);
          widget.imagesToUpLoad(currentImages);
        }
      } else {
        final snackBar = SnackBar(
          elevation: 4,
          backgroundColor: widget.model.paletteColor,
          content: Text(
            'Sorry, only 6 images can be added. Please try again.',
            style: TextStyle(color: widget.model.webBackgroundColor),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showTitle == true)
          Column(
            children: [
              SizedBox(height: 25),
              /// *** select/add profile images for activity *** ///
              Text(
                'Photos/Videos*',
                style: TextStyle(
                  fontSize: widget.model.secondaryQuestionTitleFontSize,
                  color: widget.model.disabledTextColor,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        mainTopContainer(
          context: context,
          model: widget.model,
          numberOfImages: List.generate(widget.numberOfImages ?? 6, (index) => (index + 1).toString()),
          currentImages: widget.currentImageList,
          didSelectImage: () {
            _handleImageSelection(context);
          },
          activityProfileImagesChanged: (images) {
            widget.imagesToUpLoad(images);
          },
        ),
      ],
    );
  }
}