part of check_in_presentation;

Widget mainContainerSectionOneRes({required BuildContext context, required DashboardModel model, required ReservationSlotItem? selectedReservationSlot, required int durationType, required String timeAgo}) {

  Map<String, List<ReservationSlotItem>> selected = HashMap<String, List<ReservationSlotItem>>();
  if (selectedReservationSlot != null) {
    selected.putIfAbsent('${selectedReservationSlot.selectedDate.toString()}${selectedReservationSlot.selectedSideOption}', () => []).add(selectedReservationSlot);
  }

  return Container(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// *** Reservation Owner Title *** ///
          SizedBox(height: 25),
          SizedBox(height: 10),
          Text('Created: ${timeAgo}', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          Text('Reservation id: ${context.read<UpdateActivityFormBloc>().state.reservationItem.reservationId.getOrCrash()}', style: TextStyle(color: model.disabledTextColor),),

          /// *** Reservation Details *** ///
          SizedBox(height: 15),
          Text('Reservation Info', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
          Text('Select Time Slot Make Changes or Edits', style: TextStyle(color: model.disabledTextColor)),


          /// *** Reservation Selected Slots *** ///
          if (selectedReservationSlot == null) for (var entry in getGroupOfSelectedBookings(context.read<UpdateActivityFormBloc>().state.reservationItem.reservationSlotItem).entries.toList(
              growable: false)..sort((a, b) {
            return b.key.compareTo(a.key);
          }))


            if (entry.value.isNotEmpty)
              getDetailListOfReservations(
                  context,
                  model,
                  context.read<UpdateActivityFormBloc>().state.reservationItem,
                  DateTime.now(),
                  durationType,
                  entry,
                  didSelectChange: (e) {

                  }
              ),


          if (selectedReservationSlot != null)
            if (selected.entries.isNotEmpty)
              getDetailListOfReservations(
                  context,
                  model,
                  context.read<UpdateActivityFormBloc>().state.reservationItem,
                  DateTime.now(),
                  durationType,
                  selected.entries.first,
                  didSelectChange: (e) {

                  }
              ),

        ],
      ),
    ),
  );
}


Widget mainContainerFooterRes({required BuildContext context, required DashboardModel model, required UpdateActivityFormState state}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Text('Reservation Costs', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize,)),
        SizedBox(height: 5),
        Text('Your Total Payment: ${state.reservationItem.reservationCost}', style: TextStyle(color: model.paletteColor, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        if (state.reservationItem.reservationState == ReservationSlotState.refunded) Text('Refunded: ${state.reservationItem.reservationCost}', style: TextStyle(color: model.paletteColor, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 25),
      ],
    ),
  );
}


