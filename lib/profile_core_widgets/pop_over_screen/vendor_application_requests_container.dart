part of check_in_presentation;

class ApplicationRequestsMainContainer extends StatefulWidget {

  final UniqueId? profileId;
  final DashboardModel model;

  const ApplicationRequestsMainContainer({super.key, required this.model, this.profileId});

  @override
  State<ApplicationRequestsMainContainer> createState() => _ApplicationRequestsMainContainerState();
}

class _ApplicationRequestsMainContainerState extends State<ApplicationRequestsMainContainer> {

  late bool? _isLoading = false;
  late UniqueId? _selectedItem = null;
  late List<ReservationPreviewer> listOfAttendingReservations = [];

  @override
  void initState() {
    getListOfAttending();
    super.initState();
  }

  void getListOfAttending() async {

    try {
      setState(() {
        _isLoading = true;
      });
      List<ReservationPreviewer> list = await facade.ReservationFacade.instance.listOfAttendingReservationItemsFiltered(status: ContactStatus.requested, attendingType: AttendeeType.vendor, isInterested: null);
      listOfAttendingReservations.addAll(list);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: widget.model.mobileBackgroundColor,
        elevation: 0,
        title: Icon(Icons.note_alt_outlined, color: widget.model.paletteColor),
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [

          ],
        ),
        body: (_isLoading == true) ? JumpingDots(color: widget.model.paletteColor, numberOfDots: 3) : Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Text('Waiting to Hear Back', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
                  Text('Places you\'ve applied to but still reviewing your application', style: TextStyle(color: widget.model.disabledTextColor, overflow: TextOverflow.ellipsis), maxLines: 1,),
                  const SizedBox(height: 18),


                  Wrap(
                      alignment: WrapAlignment.center,
                      children: listOfAttendingReservations.map(
                              (e) {
                            // if (e.reservation == null) {
                            //   return Container();
                            // }
                            return baseSearchItemContainer(
                                model: widget.model,
                                height: 400,
                                width: 400,
                                backgroundWidget: getReservationMediaFrameFlexible(
                                    context,
                                    widget.model,
                                    400,
                                    400,
                                    e.listing,
                                    e.activityManagerForm,
                                    e.reservation!,
                                    ((_selectedItem == e.reservation?.reservationId) && (_isLoading ?? false)),
                                    didSelectItem: () {
                                      didSelectReservationPreview(context, widget.model, e);
                                    }),
                                bottomWidget: getSearchFooterWidget(
                                    context,
                                    widget.model,
                                    widget.profileId,
                                    widget.model.paletteColor,
                                    widget.model.disabledTextColor,
                                    widget.model.accentColor,
                                    e,
                                    ((_selectedItem == e.reservation?.reservationId) && (_isLoading ?? false)),
                                    didSelectItem: () {
                                      didSelectReservationPreview(context, widget.model, e);
                                    },
                                    didSelectInterested: () {
                                      setState(() {
                                        _selectedItem = e.reservation?.reservationId;
                                        _isLoading = true;

                                        Future.delayed(const Duration(seconds: 1), () {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        });
                                      });
                                    }
                                ),
                            isSelected: null
                        );
                      }
                  ).toList()
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}