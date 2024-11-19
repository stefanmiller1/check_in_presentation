part of check_in_presentation;

Widget multiSelectionHeader(BuildContext context, DashboardModel model, List<UniqueId> selectedSpaceOptionDetail, List<SpaceOption> spaces, {required Function(SpaceOptionSizeDetail) didSelectSpaces}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: spaces.asMap().map(
              (i, value) => MapEntry(i, Row(
            children: value.quantity.asMap().map((
                ii, valueQ) => MapEntry(ii, Column(
              children: [
                Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: (selectedSpaceOptionDetail.map((e) => e).contains(valueQ.spaceId)) ? model.paletteColor : Colors.transparent),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          didSelectSpaces(valueQ);
                        },
                        child: Container(
                            height: 85,
                            width: 65,
                            color: model.webBackgroundColor,
                            child: CachedNetworkImage(
                              imageUrl: valueQ.photoUri ?? '',
                              imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.fill),
                              errorWidget: (context, url, error) => Container()
                            )
                        ),
                      ),
                    )
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 60,
                      child: Text(valueQ.spaceTitle ?? '${getSpaceTypeOptions(context)
                          .where((s) => s.uid == value.uid)
                          .first
                          .spaceTitle} ${valueQ.spaceTitle ?? ''} ${ii + 1}',
                        style: TextStyle(
                          color: model.paletteColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ),
              ],
            )
            ),
            ).values.toList(),
          )
          )
      ).values.toList(),
    ),
  );
}

Widget spaceSelectionHeader(BuildContext context, DashboardModel model, SpaceOptionSizeDetail? selectedSPaceOptionDetail, List<SpaceOption> spaces, {required Function(SpaceOptionSizeDetail, SpaceOption) didSelectSpace}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
        children: spaces.asMap().map(
                (i, value) => MapEntry(i, Row(
                children: value.quantity.asMap().map((
                    ii, e) => MapEntry(ii, Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (ii == 0) Text(getSpaceTypeOptions(context).where((i) => i.uid == value.uid).first.spaceTitle, style: TextStyle(color: model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: model.questionTitleFontSize)),
                    const SizedBox(height: 8),
                    if (ii != 0) const SizedBox(height: 30),

                    getSpaceOptionFrameContainer(
                      (selectedSPaceOptionDetail?.spaceId == e.spaceId),
                      e,
                      value,
                      model,
                      didSelectSpace: (SpaceOption space) {
                        didSelectSpace(e, space);
                      },
                    ),

                    Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 60,
                              child: Text(e.spaceTitle ?? '${getSpaceTypeOptions(context).where((s) => s.uid == value.uid).first.spaceTitle} ${e.spaceTitle ?? ''} ${ii + 1}',
                                style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold,), maxLines: 1, overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ).values.toList()
            ),
          )
        ).values.toList()
    ),
  );
}


Widget getSpaceOptionFrameContainer(bool isSelected, SpaceOptionSizeDetail spaceOptionSize, SpaceOption spaceOption, DashboardModel model, {required Function(SpaceOption) didSelectSpace}) {

  return Container(
    height: 85,
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: (isSelected) ? model.paletteColor : Colors.transparent)
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () {
              didSelectSpace(spaceOption);
          },
          child: Container(
              height: 85,
              width: 65,
              color: model.webBackgroundColor,
              child: CachedNetworkImage(
                imageUrl: spaceOptionSize.photoUri ?? '',
                imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.fill),
                placeholder: (context, url) => Shimmer.fromColors(
                    enabled: (spaceOptionSize.photoUri != null),
                    baseColor: model.accentColor,
                    highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 85,
                        width: 65,
                        decoration: BoxDecoration(
                          color: model.webBackgroundColor
                        )
                      ),
                ),
                errorWidget: (context, url, error) => Container()
              ),

          ),
        ),
      )
    ),
  );
}

Widget getSelectedSpaces(BuildContext context, SpaceOptionSizeDetail spaceDetailOptions, DashboardModel model) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
       if (spaceDetailOptions.photoUri != null) Padding(
         padding: const EdgeInsets.symmetric(horizontal: 8.0),
         child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
           child: Container(
             height: 120,
              width: 120,
              child: CachedNetworkImage(
                imageUrl: spaceDetailOptions.photoUri ?? '',
                imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
             )
           )
         ),
       ),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (spaceDetailOptions.spaceDescription != null) Text(spaceDetailOptions.spaceDescription ?? '', style: TextStyle(color: model.paletteColor), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(spaceDetailOptions.spaceTitle ?? '', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
            ],
          )
        )
      ],
    ),
  );
}