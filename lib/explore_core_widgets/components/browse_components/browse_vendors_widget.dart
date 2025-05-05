part of check_in_presentation;

class BrowseVendorMainWidget extends StatefulWidget {


  final DashboardModel model;
  final double widgetWidth;
  final double widthConstraint;
  final List<EventMerchantVendorProfile> profiles;

  const BrowseVendorMainWidget({super.key, required this.model, required this.profiles, required this.widgetWidth, required this.widthConstraint});

  @override
  State<BrowseVendorMainWidget> createState() => _BrowseVendorMainWidgetState();
}

class _BrowseVendorMainWidgetState extends State<BrowseVendorMainWidget> {

  int _currentPage = 0;
  late bool showButton = false;
  late final Future<List<EventMerchVendorPreview>> getVendorProfileList;
  late PageController _reservationPageController;

  Future<List<EventMerchVendorPreview>> _fetchVendorProfiles(List<EventMerchantVendorProfile> profiles) async {
    final futures = profiles.map((vendor) async {
      int weight = 0;
      try {
        final vendorProfile = await facade.UserProfileFacade.instance
            .getCurrentUserProfile(userId: vendor.profileOwner.getOrCrash());
            
        final vendingCount = await facade.AttendeeFacade.instance
            .getNumberOfAttending(attendeeOwnerId: vendor.profileOwner.getOrCrash(),
            status: ContactStatus.joined,
            attendingType: AttendeeType.vendor,
            isInterested: null);
        weight = vendingCount ?? 0;

        return EventMerchVendorPreview(
          vendorToPreview: vendor,
          previewWeight: weight,
          vendorOwnerProfile: vendorProfile,
          attendedCount: vendingCount,
        );
      } catch (_) {
        return EventMerchVendorPreview(vendorToPreview: vendor, previewWeight: weight);
      }
    });

    final vendorPreviews = await Future.wait(futures);
    return vendorPreviews.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
  }

  @override
  void dispose() {
    _reservationPageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getVendorProfileList = _fetchVendorProfiles(widget.profiles);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize or update PageController when dependencies change
    _reservationPageController = PageController(
      viewportFraction: (MediaQuery.of(context).size.width >= widget.widthConstraint)
          ? widget.widgetWidth / widget.widthConstraint
          : widget.widgetWidth / MediaQuery.of(context).size.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventMerchVendorPreview>>(
      future: getVendorProfileList,
      builder: (context, snap) {
        final vendorList = snap.data ?? [];
    
        if (snap.connectionState == ConnectionState.waiting) {
          return emptyLargeListView(context, 4, 300, Axis.horizontal, kIsWeb);
        }
    
        return RepaintBoundary(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
          
              PageView.builder(
                  padEnds: false,
                  // physics: (Responsive.isMobile(context)) ? null : NeverScrollableScrollPhysics(),
                  controller: _reservationPageController,
                  itemCount: vendorList.length,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final EventMerchVendorPreview preview = vendorList[index];
          
          
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
          
                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
          
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: widget.widgetWidth,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                    imageUrl: (preview.vendorToPreview?.uriImage?.uriPath != null) ? preview.vendorToPreview!.uriImage!.uriPath! : '',
                                    imageBuilder: (context, imageProvider) => Image(image: imageProvider, fit: BoxFit.cover),
                                    errorWidget: (context, url, error) => Container(
                                      // height: 325,
                                      width: widget.widgetWidth,
                                  ),
                                ),
                              ),
                            ),
          
                            Container(
                              width: widget.widgetWidth,
                              child: bottomFooterVendorDetails(
                                  context,
                                  widget.model,
                                  preview,
                                Colors.grey.shade200,
                                Colors.grey.shade200.withOpacity(0.75),
                                Colors.black,
                              )
                            ),
          
                          ],
                        ),
                      ),
                    );
                  }
              ),
              
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left MouseRegion
                MouseRegion(
                onEnter: (_) => setState(() => showButton = true),
                onExit: (_) => setState(() => showButton = false),
                  child: Container(
                    width: 100,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
                // Right MouseRegion
                MouseRegion(
                onEnter: (_) => setState(() => showButton = true),
                onExit: (_) => setState(() => showButton = false),
                  child: Container(
                    width: 100,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),

              AnimatedOpacity(
                duration: Duration(milliseconds: 350),
                opacity: (showButton) ? 1 : 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MouseRegion(
                          onEnter: (_) => setState(() => showButton = true),
                          onHover: (_) => setState(() => showButton = true),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color:  widget.model.paletteColor,
                                border: Border.all(color: widget.model.paletteColor, width: 0.5),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _reservationPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                                });
                              },
                              icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.model.disabledTextColor),
                            ),
                          ),
                        ),
                        MouseRegion(
                          onEnter: (_) => setState(() => showButton = true),
                          onHover: (_) => setState(() => showButton = true),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: widget.model.paletteColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _reservationPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                                });
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded, color: widget.model.disabledTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ),
        );
      }
    );
  }
}


Widget bottomFooterVendorDetails(BuildContext context, DashboardModel model, EventMerchVendorPreview preview, Color textColor, Color secondaryTextColor, Color backgroundColor) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: UI.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade800.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 6
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      color: textColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(1.25),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration:  BoxDecoration(
                                              color: backgroundColor,
                                              border: Border.all(color: textColor),
                                              borderRadius: BorderRadius.all(Radius.circular(30))
                                        ),
                                        child: CachedNetworkImage(
                                            imageUrl: preview.vendorOwnerProfile?.photoUri ?? '',
                                            imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider),
                                            placeholder: (context, url) => CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image),
                                            errorWidget: (context, url, error) => Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40),
                                                  // border: Border.all(color: textColor)
                                              ),
                                              child: Center(
                                                child: Text(preview.vendorOwnerProfile?.legalName.getOrCrash()[0] ?? '', style: TextStyle(color: secondaryTextColor, fontSize: model.questionTitleFontSize)),
                                              ),
                                            )
                                        ),
                                      )
                                    )
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('${preview.vendorToPreview?.brandName.value.fold((l) => '${preview.vendorOwnerProfile?.legalName.getOrCrash() ?? ''}\'s profile', (r) => r)}', style: TextStyle(color: textColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1),
                                        Text('Since ${DateFormat.yMMM().format(preview.vendorOwnerProfile?.joinedDate ?? DateTime.now())} ', style: TextStyle(color: secondaryTextColor), maxLines: 1, overflow: TextOverflow.ellipsis)
                                      ]
                                    )
                                  )
                                ]
                              )
                            ]
                          )
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: textColor.withOpacity(0.07),
                              ),
                              child: IconButton(
                                onPressed: () {}, 
                                padding: EdgeInsets.only(top: 4),
                                tooltip: '${preview.rating ?? 5} Stars',
                                icon: Icon(Icons.star_rounded, color: textColor),
                              ),
                            ),
                            Text('${preview.rating ?? 5}', style: TextStyle(color: secondaryTextColor)),
                          ],
                        ),
                      ]
                    )
                  ]
                ),

                const SizedBox(height: 4),

                if (preview.attendedCount != null && preview.attendedCount != 0 || preview.vendorToPreview?.isLookingForWork == true)  Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [

                            Chip(
                                side: BorderSide.none,
                                backgroundColor: model.accentColor.withOpacity(0.18),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                avatar: Icon(Icons.accessibility_new , color: Colors.grey.shade200, size: 18,),
                                label: Text('${preview.attendedCount!} Joined', style: TextStyle(color: Colors.grey.shade200))
                            ),
                            const SizedBox(width: 4),
                            if (preview.vendorToPreview?.isLookingForWork == true) Chip(
                                backgroundColor: model.accentColor.withOpacity(0.18),
                                side: BorderSide.none,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                avatar: Icon(Icons.remove_red_eye_outlined, color: Colors.grey.shade200, size: 18,),
                                label: Text('Looking For Ops', style: TextStyle(color: Colors.grey.shade200),)
                            ),

                        ]
                      )
                    )
                  )
                )
              ]
            ),
          )
        ),
      )
    )
  );
}