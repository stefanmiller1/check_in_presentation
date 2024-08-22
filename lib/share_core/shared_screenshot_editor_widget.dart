part of check_in_presentation;

class SharedScreenshotEditorWidget extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm listing;
  final ActivityManagerForm activityForm;
  final ReservationItem reservation;

  const SharedScreenshotEditorWidget({super.key, required this.model, required this.listing, required this.activityForm, required this.reservation});

  @override
  State<SharedScreenshotEditorWidget> createState() => _SharedScreenshotEditorWidgetState();
}

class _SharedScreenshotEditorWidgetState extends State<SharedScreenshotEditorWidget> with TickerProviderStateMixin {

  late PageController? _pageController = PageController(initialPage: 0);
  late int selectedImageIndex = 0;
  late int selectedDateTypeIndex = 0;


  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
   return ClipRRect(
     borderRadius: BorderRadius.all(Radius.circular(30)),
     child: Column(
       children: [
         InkWell(
           onTap: () {
            setState(() {
              if (selectedImageIndex == ((widget.activityForm.profileService.activityBackground.activityProfileImages?.length ?? 0) - 1)) {
                _pageController?.jumpToPage(0);
              } else {
                _pageController?.jumpToPage(selectedImageIndex + 1);
              }
              // selectedDateTypeIndex = (_pageController?.page ?? 0).toInt();
            });
           },
           child: Container(
             height: 280,
             width: MediaQuery.of(context).size.width,
             child: (widget.activityForm.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) ? PageView.builder(
               controller: _pageController,
               itemCount: widget.activityForm.profileService.activityBackground.activityProfileImages?.length ?? 0,
               scrollDirection: Axis.horizontal,
               physics: const NeverScrollableScrollPhysics(),
               onPageChanged: (index) {
                 setState(() {
                   selectedImageIndex = index;
                 });
               },
               itemBuilder: (_, index) {
                 final String imageUrl = widget.activityForm.profileService.activityBackground.activityProfileImages?[index].uriPath ?? '';

                 return Image.network(imageUrl, fit: BoxFit.fitWidth);
               }
             ) : Container()
           ),
         ),
         const SizedBox(height: 12),
         Flexible(
           flex: 1,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 3.0),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 /// market title
                 Text(widget.activityForm.profileService.activityBackground.activityTitle.value.fold((l) => 'Activity Title', (r) => r), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                 Text('${widget.listing.listingProfileService.listingLocationSetting.street.getOrCrash()}\n${widget.listing.listingProfileService.listingLocationSetting.city.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.provinceState.getOrCrash()}, ${widget.listing.listingProfileService.listingLocationSetting.countryRegion}', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize)),
                 if (selectedDateTypeIndex == 0) InkWell(
                   onTap: () {
                       setState(() {
                         selectedDateTypeIndex = 1;
                       });
                     },
                     child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...formatReservationSlotItems(widget.reservation.reservationSlotItem, 3).map((e) =>
                              Text(e, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1)
                            ).toList(),
                          if (formatReservationSlotItems(widget.reservation.reservationSlotItem, 3).length == 3) Text('& More..')
                      ]
                   )
                 ),
                 if (selectedDateTypeIndex == 1) InkWell(
                   onTap: () {
                     setState(() {
                       selectedDateTypeIndex = 0;
                     });
                   },
                   child: Text(formatNextOrLastReservationSlotItem(widget.reservation.reservationSlotItem), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.questionTitleFontSize, overflow: TextOverflow.ellipsis), textAlign: TextAlign.center),
                 )
               ]
             ),
           ),
         ),
         const SizedBox(height: 12),
       ]
     ),
   );
  }
}