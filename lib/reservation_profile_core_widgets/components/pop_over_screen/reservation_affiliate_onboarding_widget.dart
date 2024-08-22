part of check_in_presentation;


class ReservationAffiliateOnBoarding extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm listingForm;
  final ActivityManagerForm activityManagerForm;
  final AttendeeItem attendeeItem;
  final ReservationItem reservation;
  final UserProfileModel reservationOwner;

  const ReservationAffiliateOnBoarding({super.key, required this.attendeeItem, required this.listingForm, required this.activityManagerForm, required this.model, required this.reservation, required this.reservationOwner});

  @override
  State<ReservationAffiliateOnBoarding> createState() => _ReservationAffiliateOnBoardingState();
}

class _ReservationAffiliateOnBoardingState extends State<ReservationAffiliateOnBoarding> {

  @override
  void initState() {
    super.initState();
  }

  Widget attendeeTypeMainContainer(AttendeeType type) {
    switch (type) {
      case AttendeeType.free:
        return ReservationCreateNewAttendee(
            model: widget.model,
            listingForm: widget.listingForm,
            reservation: widget.reservation,
            activityForm: widget.activityManagerForm,
            resOwner: widget.reservationOwner,
            isFromInvite: true,
          );
      case AttendeeType.instructor:
        return CreateNewInstructorForm(
          model: widget.model,
          reservation: widget.reservation,
          activityForm: widget.activityManagerForm,
          resOwner: widget.reservationOwner,
          isFromInvite: true,
        );
      case AttendeeType.vendor:
        return CreateNewVendorMerchant(
          model: widget.model,
          reservation: widget.reservation,
          activityForm: widget.activityManagerForm,
          resOwner: widget.reservationOwner,
          listingForm: widget.listingForm,
          isPreview: false,
          isFromInvite: true
        );
      case AttendeeType.partner:
        return ReservationRequestPartnershipAttendee(
          model: widget.model,
          reservation: widget.reservation,
          activityForm: widget.activityManagerForm,
          resOwner: widget.reservationOwner,
          isFromInvite: true,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return attendeeTypeMainContainer(widget.attendeeItem.attendeeType);
  }
}