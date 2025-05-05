part of check_in_presentation;

class ReservationAttendingPreviewerListWidget extends StatefulWidget {

  final DashboardModel model;
  final String titleText;
  final bool showLoadingList;
  final UniqueId? selectedReservationId;
  final UniqueId? currentUserId;
  final Function(ReservationPreviewer) didSelectReservation;
  final bool isPagingView;
  final List<UniqueId> reservations;

  const ReservationAttendingPreviewerListWidget({super.key, required this.model, this.currentUserId, required this.didSelectReservation, required this.reservations, required this.showLoadingList, this.selectedReservationId, required this.titleText, required this.isPagingView});

  @override
  State<ReservationAttendingPreviewerListWidget> createState() => _ReservationAttendingPreviewerListWidgetState();
}

class _ReservationAttendingPreviewerListWidgetState extends State<ReservationAttendingPreviewerListWidget> {
  late Future<List<ReservationPreviewer>>? _getReservationList;
  int _currentPage = 0;
  late bool showButton = false;

  @override
  void initState() {
    super.initState();
    // Initialize with the current reservations
    _getReservationList = facade.ReservationFacade.instance.getReservationsFromAttendingIds(widget.reservations);
  }



  @override
  void didUpdateWidget(covariant ReservationAttendingPreviewerListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the reservation list if it has changed
    if (widget.reservations.length != oldWidget.reservations.length) {
      _getReservationList = facade.ReservationFacade.instance.getReservationsFromAttendingIds(widget.reservations);
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ReservationPreviewer>>(
      future: _getReservationList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && widget.showLoadingList) {
          return emptyLargeListView(context, 3, 300, Axis.vertical, kIsWeb);
        }

        final List<ReservationPreviewer> reservationPreview = snapshot.data ?? [];

        if (widget.isPagingView) {
          final PageController  _reservationPageController = (kIsWeb) ? PageController(viewportFraction: (Responsive.isDesktop(context)) ? 1/2.1 : 450 / MediaQuery.of(context).size.width) : PageController(viewportFraction: 0.9);

          return PagingWithArrowsCoreWidget(
            height: 500,
            model: widget.model,
            pagingWidget: PageView.builder(
              padEnds: false,
              controller: _reservationPageController,
              itemCount: reservationPreview.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                final ReservationPreviewer item = reservationPreview[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      
                      
                      baseSearchItemContainer(
                        width: 500,
                        height: 500,
                        model: widget.model,
                        isSelected: item.reservation?.reservationId == widget.selectedReservationId,
                        backgroundWidget: getReservationMediaFrameFlexible(
                          context,
                          widget.model,
                          500,
                          500,
                          item.listing,
                          item.activityManagerForm,
                          item.reservation!,
                          false,
                          didSelectItem: () {
                            widget.didSelectReservation(item);
                          },
                        ),
                        bottomWidget: getSearchFooterWidget(
                          context,
                          widget.model,
                          widget.currentUserId,
                          widget.model.paletteColor,
                          widget.model.disabledTextColor,
                          widget.model.accentColor,
                          item,
                          false,
                          didSelectItem: () {
                            widget.didSelectReservation(item);
                          },
                          didSelectInterested: () {
                            // Handle interested action
                          },
                        ),
                      ),

                      if (item.reservation?.formStatus == FormStatus.inProgress|| item.reservation?.formStatus == FormStatus.closed) Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 400,
                              child: Row(
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: getStatusColor(widget.model, item.reservation?.formStatus ?? FormStatus.inProgress).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(30)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text((item.reservation?.formStatus ?? FormStatus.inProgress).name, style: TextStyle(color: getStatusColor(widget.model, item.reservation?.formStatus ?? FormStatus.inProgress))),
                                      )
                                    ),
                                  ),
                                ],
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
                  _reservationPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                });
              },
              didSelectForward: () {
                setState(() {
                  _reservationPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
              });
            }
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (snapshot.connectionState == ConnectionState.done)
              Text(
                widget.titleText,
                style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize),
              ),
            const SizedBox(height: 6),
            ...reservationPreview.map((item) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  
                  baseSearchItemContainer(
                    width: 400,
                    height: 400,
                    model: widget.model,
                    isSelected: item.reservation?.reservationId == widget.selectedReservationId,
                    backgroundWidget: getReservationMediaFrameFlexible(
                      context,
                      widget.model,
                      400,
                      400,
                      item.listing,
                      item.activityManagerForm,
                      item.reservation!,
                      false,
                      didSelectItem: () {
                        widget.didSelectReservation(item);
                      },
                    ),
                    bottomWidget: getSearchFooterWidget(
                      context,
                      widget.model,
                      widget.currentUserId,
                      widget.model.paletteColor,
                      widget.model.disabledTextColor,
                      widget.model.accentColor,
                      item,
                      false,
                      didSelectItem: () {
                        widget.didSelectReservation(item);
                      },
                      didSelectInterested: () {
                        // Handle interested action
                      },
                    ),
                  ),
                  if (item.reservation?.formStatus == FormStatus.inProgress|| item.reservation?.formStatus == FormStatus.closed) Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400,
                        child: Row(
                          children: [
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                // width: 130,
                                decoration: BoxDecoration(
                                    color: getStatusColor(widget.model, item.reservation?.formStatus ?? FormStatus.inProgress).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text((item.reservation?.formStatus ?? FormStatus.inProgress).name, style: TextStyle(color: getStatusColor(widget.model, item.reservation?.formStatus ?? FormStatus.inProgress))),
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )).toList()
          ],
        );
      },
    );
  }
}