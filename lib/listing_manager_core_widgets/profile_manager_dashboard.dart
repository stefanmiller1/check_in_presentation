part of check_in_presentation;

Widget headerContainerMain({required DashboardModel model, required Function() didSSelectProfileStatus, required Function() didSelectedProfileRemove, required Function() didSelectProfilePreview, required Function() didSelectProfileClose, }) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: model.paletteColor,
              borderRadius: BorderRadius.all(Radius.circular(25),
              ),
            ),
            child: Icon(Icons.directions_run, color: model.webBackgroundColor),
          ),
        ),
        Expanded(child: Text('Main Profile Title', style: TextStyle(color: model.paletteColor, fontSize: model.questionTitleFontSize), softWrap: false, overflow: TextOverflow.fade, maxLines: 1,)),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Row(
            children: [
              IconButton(
                  tooltip: 'Status',
                  onPressed: () {
                  }, icon: Icon(Icons.block_rounded, size: 18, color: model.disabledTextColor,)),

              IconButton(
                  tooltip: 'Remove',
                  onPressed: () {

                  },
                  icon: Icon(Icons.delete_forever_outlined, size: 18, color: model.disabledTextColor,)
              ),

              IconButton(
                  tooltip: 'Preview',
                  onPressed: () {

                  },
                  icon: Icon(Icons.preview_rounded, size: 18, color: model.disabledTextColor)
              ),

              IconButton(
                  tooltip: 'Close',
                  onPressed: () {

                  },
                  icon: Icon(Icons.cancel_outlined, size: 18, color: model.disabledTextColor,)
              ),
            ],
          ),
        )
      ],
    ),
  );
}