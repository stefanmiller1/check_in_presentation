part of check_in_presentation;





Widget saveCancelFooter(BuildContext context, DashboardModel model, bool isSaving, bool isChangeMade, bool isValid, bool canDelete, bool? cantCancel, {required Function() didSelectSave, required Function() didSelectCancel, required Function() didSelectDelete}) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0),
    child: Container(
      // width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: (isSaving) ? Colors.transparent : model.accentColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: model.disabledTextColor.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(5,0)
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (isSaving) ? JumpingDots(numberOfDots: 3, color: model.paletteColor) : Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (cantCancel == false || cantCancel == null) InkWell(
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
            if (cantCancel == false || cantCancel == null) const SizedBox(width: 18),
            // const Spacer(),
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
