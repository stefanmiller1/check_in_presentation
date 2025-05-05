part of check_in_presentation;

class ReservationShowAllPaging extends StatefulWidget {

  final DashboardModel model;
  final List<ReservationSlotState> statusType;
  final UniqueId userId;

  const ReservationShowAllPaging({super.key, required this.model, required this.userId, required this.statusType});

  @override
  State<ReservationShowAllPaging> createState() => _ReservationShowAllPagingState();
}

class _ReservationShowAllPagingState extends State<ReservationShowAllPaging> {

  @override
  void initState() {

     ReservationCoreHelper.pagingController = PagingController(firstPageKey: 0);
      if (mounted) {
        ReservationCoreHelper.pagingController?.addPageRequestListener((pageKey) {
          ReservationCoreHelper.fetchByCompleted(context, widget.statusType, true, null, null, widget.userId.getOrCrash(), pageKey);
        });
      }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.paletteColor : widget.model.mobileBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text('Reservations'),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: Icon(Icons.cancel, size: 30, color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.mobileBackgroundColor : widget.model.paletteColor), padding: EdgeInsets.zero),
        titleTextStyle: TextStyle(color: (widget.model.systemTheme.brightness != Brightness.dark) ? widget.model.accentColor : widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: PagedListView<int, ReservationPreviewer>(
            addAutomaticKeepAlives: true,
            scrollDirection: Axis.vertical,
            pagingController: ReservationCoreHelper.pagingController!,
            builderDelegate: PagedChildBuilderDelegate<ReservationPreviewer>(
                animateTransitions: true,
                firstPageProgressIndicatorBuilder: (context) {
                  return emptyLargeListView(context, 10, 300, Axis.vertical, kIsWeb);
                },
                newPageProgressIndicatorBuilder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
                  );
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return noItemsFound(
                      widget.model,
                      Icons.calendar_today_outlined,
                      'No Reservations Yet!',
                      'Start a Pop-Up Shop in your backyard or Rent out a basement for your next underground Rave.',
                      'Start Booking',
                      didTapStartButton: () {

                    }
                  );
                },
                itemBuilder: (context, item, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: baseSearchItemContainer(
                        height: 500,
                        width: 500,
                        model: widget.model,
                        isSelected: false,
                        backgroundWidget: getReservationMediaFrameFlexible(context, widget.model, 500, 500, item.listing, item.activityManagerForm, item.reservation!, false,
                            didSelectItem: () {
                              didSelectReservationPreview(context, widget.model, item);
                            }),
                        bottomWidget: getSearchFooterWidget(
                            context,
                            widget.model,
                            widget.userId,
                            widget.model.paletteColor,
                            widget.model.disabledTextColor,
                            widget.model.accentColor,
                            item,
                            false,
                            didSelectItem: () {
                            },
                            didSelectInterested: () {
                            }
                        )
                    ),
                  );

                  return Column(
                    children: [
                      Text(item.reservation?.reservationId.getOrCrash() ?? ''),
                      Text(item.activityManagerForm?.profileService.activityBackground.activityTitle.getOrCrash() ?? 'not activity'),
                    ],
                  );
                }
            )
        ),
      ),
    );
  }
}