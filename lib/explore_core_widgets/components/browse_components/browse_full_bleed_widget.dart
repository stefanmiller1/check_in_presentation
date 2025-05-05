part of check_in_presentation;

class BrowseFullBleedWidget extends StatefulWidget {
  final DashboardModel model;
  final List<ReservationItem> reservations;

  const BrowseFullBleedWidget({
    Key? key,
    required this.model,
    required this.reservations,
  }) : super(key: key);

  @override
  State<BrowseFullBleedWidget> createState() => _BrowseFullBleedWidgetState();
}

class _BrowseFullBleedWidgetState extends State<BrowseFullBleedWidget> with TickerProviderStateMixin {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < widget.reservations.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1100),
        curve: Curves.easeInOutCubic,
      );

      _progressController
        ..reset()
        ..forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.reservations.length,
        itemBuilder: (context, index) {
          final reservation = widget.reservations[index];
          final imageUrl = ((reservation.reservationMetadata?.activityMainMedia ?? []).isNotEmpty == true) ? (reservation.reservationMetadata?.activityMainMedia ?? [])[0].uriPath ?? '' : '';
      
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  memCacheWidth: 1000,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return CircularProgressIndicator(
                          value: _progressController.value,
                          strokeWidth: 3,
                          color: widget.model.accentColor,
                          backgroundColor: Colors.white24,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.reservationMetadata?.activityTitle ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            reservation.reservationMetadata?.city ?? '',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.people, color: Colors.white70, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${reservation.reservationMetadata?.attendeeCount} attending',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(width: 16),
                          if (reservation.reservationMetadata?.activityhasPublishedVForm ?? false) Row(
                              children: [
                                Icon(Icons.store_mall_directory, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Open to Vendors',
                                  style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: HoverButton(
                          onpressed: () {

                          },
                          color: widget.model.accentColor,
                          hoverColor: widget.model.disabledTextColor.withOpacity(0.2),
                          hoverElevation: 0,
                          highlightElevation: 0,
                          hoverShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          animationDuration: Duration.zero,
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                          hoverPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
                          elevation: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: widget.model.accentColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              'Join Now',
                              style: TextStyle(
                                color: widget.model.paletteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: widget.model.secondaryQuestionTitleFontSize,
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}