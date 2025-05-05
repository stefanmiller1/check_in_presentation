part of check_in_presentation;

class PagingSmallFacilitiesWidget extends StatefulWidget {

  final DashboardModel model;
  final double height;
  final bool isOwner;
  final bool isMobile;
  final UserProfileModel currentUser;
  final ListingManagerForm? selectedFacility;
  final Function(ListingManagerForm) didSelectFacility;
  final List<ListingManagerForm> facilities;

  const PagingSmallFacilitiesWidget({super.key, required this.model, required this.height, required this.currentUser, required this.didSelectFacility, required this.facilities, required this.isMobile, required this.isOwner, this.selectedFacility});

  @override
  State<PagingSmallFacilitiesWidget> createState() => _PagingSmallFacilitiesWidgetState();
}

class _PagingSmallFacilitiesWidgetState extends State<PagingSmallFacilitiesWidget> {

  int _currentPage = 0;
  late bool showButton = false;


  @override
  Widget build(BuildContext context) {
    final PageController  _facilitiesPageController = (kIsWeb) ? PageController(viewportFraction: (Responsive.isDesktop(context)) ? 1/2.1 : 450 / MediaQuery.of(context).size.width) : PageController(viewportFraction: 0.9);

    return PagingWithArrowsCoreWidget(
         height: widget.height,
         model: widget.model,
         pagingWidget: PageView.builder(
           padEnds: false,
           controller: _facilitiesPageController,
           itemCount: widget.facilities.length,
           onPageChanged: (page) {
             setState(() {
               _currentPage = page;
             });
           },
           itemBuilder: (context, index) {

             late String? listingImage;

             final ListingManagerForm listing = widget.facilities[index];

             for (SpaceOption space in listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)) {
               if (space.quantity.where((element) => element.photoUri != null).isNotEmpty) {
                 listingImage = space.quantity.firstWhere((element) => element.photoUri != null).photoUri;
               }
             }

            return  Padding(
              padding: const EdgeInsets.all(15.0),
              child: Stack(
                children: [
                  Container(
                    height: widget.height,
                    width: widget.height,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.selectedFacility?.listingServiceId == listing.listingServiceId ? widget.model.paletteColor : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ListingResultMain(
                           showReservations: false,
                           listing: listing,
                           isLoading: false,
                           model: widget.model,
                           didSelectEmbeddedRes: (listing, res) {
                        
                           },
                           didSelectListingItem: (listing) =>  widget.didSelectFacility(listing),
                           didChangeSpaceOptionItem: (SpaceOptionSizeDetail space) {
                             setState(() {
                               // currentSpaceOption = space;
                             });
                           },
                         ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        ),
        didSelectBack: () {
          setState(() {
            _facilitiesPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
          });
        },
        didSelectForward: () {
          setState(() {
            _facilitiesPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
          });
      }
    );
  }
}