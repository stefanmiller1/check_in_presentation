import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../image_picker_core.dart';

class ProfileImageUploadPreview extends StatefulWidget {

  final DashboardModel model;
  final String title;
  final String subTitle;
  final ImageUpload? currentNetworkImage;
  final Function(ImageUpload) imageToUpLoad;

  const ProfileImageUploadPreview({super.key, required this.model, required this.title, required this.subTitle, this.currentNetworkImage, required this.imageToUpLoad});

  @override
  State<ProfileImageUploadPreview> createState() => _ProfileImageUploadPreviewState();
}

class _ProfileImageUploadPreviewState extends State<ProfileImageUploadPreview> {

  final ImagePicker _imagePicker = ImagePicker();
  late ImageUpload? selectedImage = null;


  @override
  void initState() {
    selectedImage = widget.currentNetworkImage;
    super.initState();
  }

  void _handleSingleImageSelection() async {
    presentSelectPictureOptions(
        context,
        widget.model,
        imageSource: (source) async {
          try {
            final image = await _imagePicker.pickImage(source: source);
            if (image != null) {
              final imageFile = await image.readAsBytes();
              selectedImage = ImageUpload(
                  key: imageFile.toString(),
                  imageToUpload: imageFile);

              if (selectedImage == null) {
                return;
              }

              widget.imageToUpLoad(selectedImage!);
              // context.read<UpdateVendorMerchProfileBloc>().add(UpdateVendorMerchProfileEvent.profileImageChanged();
            }

          } catch (e) {
            final snackBar = SnackBar(
                backgroundColor: widget.model.webBackgroundColor,
                content: Text(e.toString() ?? 'Sorry, Could not get image', style: TextStyle(color: widget.model.paletteColor))
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _handleSingleImageSelection();
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
              ),
              CircleAvatar(
                radius: 60,
                backgroundColor: widget.model.accentColor,
                backgroundImage: (selectedImage?.uriPath != null) ? Image.network(selectedImage!.uriPath!, fit: BoxFit.cover).image : null,
                foregroundImage: (selectedImage?.imageToUpload != null) ? Image.memory(selectedImage!.imageToUpload!, fit: BoxFit.cover).image : null,
              ),
              Icon(Icons.camera_alt, size: 40, color: widget.model.disabledTextColor),
            ],
          ),
          const SizedBox(height: 5),
          Text('${widget.title}*', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
          Text(widget.subTitle, style: TextStyle(color: widget.model.disabledTextColor)),
          const SizedBox(height: 10),
        ],
      ),
    );
    return ListTile(
      onTap: () {
        _handleSingleImageSelection();

      },
      leading: Container(
          height: 60,
          width: 60,
          child: InkWell(
            onTap: () {
              _handleSingleImageSelection();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: widget.model.accentColor,
                  backgroundImage: (selectedImage?.uriPath != null) ? Image.network(selectedImage!.uriPath!, fit: BoxFit.cover).image : null,
                  foregroundImage: (selectedImage?.imageToUpload != null) ? Image.memory(selectedImage!.imageToUpload!, fit: BoxFit.cover).image : null,
                ),
                Icon(Icons.camera_alt, size: 20, color: widget.model.disabledTextColor),
              ],
            ),
          )
      ),
      title: Text('${widget.title}*', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
      subtitle: Text(widget.subTitle, style: TextStyle(color: widget.model.disabledTextColor)),
    );
  }
}



// Widget profileImageEditor(DashboardModel model, String title, String subTitle, Image? currentNetworkImage, Image? selectedImage, {required Function() didSelectImage}) {
//   return ListTile(
//     onTap: () => didSelectImage(),
//     leading: Container(
//         height: 60,
//         width: 60,
//         child: InkWell(
//           onTap: () => didSelectImage(),
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 30,
//                 backgroundColor: model.accentColor,
//                 backgroundImage: (currentNetworkImage != null) ? (selectedImage == null) ? currentNetworkImage.image : selectedImage.image : (selectedImage != null) ? selectedImage.image : null,
//               ),
//               Icon(Icons.camera_alt, size: 20, color: model.disabledTextColor),
//             ],
//           ),
//         )
//     ),
//     title: Text('$title*', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
//     subtitle: Text(subTitle, style: TextStyle(color: model.disabledTextColor)),
//   );
// }