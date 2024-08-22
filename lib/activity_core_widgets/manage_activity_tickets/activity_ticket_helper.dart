part of check_in_presentation;

class ActivityTicketHelperCore {

  static ActivityTicketOption? selectedTicket;
  static bool isLoading = false;
}

Widget activityTicketsLoadingFailure() {
  return Container(
    child: Text('Could not load tickets'),
  );
}