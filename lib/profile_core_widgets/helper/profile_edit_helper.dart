part of check_in_presentation;


Widget profileImageEditor(DashboardModel model, String title, String subTitle, Image? currentNetworkImage, Image? selectedImage, {required Function() didSelectImage}) {
  return ListTile(
    onTap: () => didSelectImage(),
    leading: Container(
        height: 60,
        width: 60,
        child: InkWell(
          onTap: () => didSelectImage(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: model.accentColor,
                backgroundImage: (currentNetworkImage != null) ? (selectedImage == null) ? currentNetworkImage.image : selectedImage.image : (selectedImage != null) ? selectedImage.image : null,
              ),
              Icon(Icons.camera_alt, size: 20, color: model.disabledTextColor),
            ],
          ),
        )
    ),
    title: Text('$title*', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
    subtitle: Text(subTitle, style: TextStyle(color: model.disabledTextColor)),
  );
}

Widget saveCancelFooter(DashboardModel model, bool isSaving, bool isChangeMade, bool isValid, bool canDelete, {required Function() didSelectSave, required Function() didSelectCancel, required Function() didSelectDelete}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      decoration: BoxDecoration(
        color: (isSaving) ? Colors.transparent : model.accentColor,
        borderRadius: BorderRadius.circular(18)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (isSaving) ? JumpingDots(numberOfDots: 3, color: model.paletteColor) : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                didSelectCancel();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: model.webBackgroundColor,
                    borderRadius: BorderRadius.circular(18)
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cancel', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize),),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                if (canDelete) InkWell(
                  onTap: () {
                    didSelectDelete();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: model.webBackgroundColor,
                        borderRadius: BorderRadius.circular(18)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text('Delete', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      didSelectSave();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: (isChangeMade && isValid) ? model.paletteColor : model.accentColor,
                          borderRadius: BorderRadius.circular(18)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text('Save', style: TextStyle(color: (isChangeMade && isValid) ? model.accentColor : model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
