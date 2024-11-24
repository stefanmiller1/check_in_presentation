part of check_in_presentation;

class SelectAttendeeTypeWidget extends StatefulWidget {

  final DashboardModel model;

  const SelectAttendeeTypeWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<SelectAttendeeTypeWidget> createState() => _SelectAttendeeTypeWidgetState();
}

class _SelectAttendeeTypeWidgetState extends State<SelectAttendeeTypeWidget> {

  ScrollController? _scrollController;


  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }


  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        width: 675,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              mainContainerForAttendeeType(
                context: context,
                model: widget.model,
                state: context.read<UpdateActivityFormBloc>().state,
                didChangeIsAttendeeBased: () {
                  setState(() {
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isLimitedAttendance == true) {
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                    } else {
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(true));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                    }
                  });
                },
                attendanceLimitChanged: (limit) {
                  context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.attendanceLimitChanged(limit));
                },
                didChangeIsTicketBased: () {
                  setState(() {
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isTicketBased == true) {
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                    } else {
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(true));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                    }
                  });
                },
                didChangeIsPassBased: () {
                  setState(() {
                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityAttendance.isPassBased == true) {
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(false));
                    } else {
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isTicketBasedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isLimitedAttendanceChanged(false));
                      context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPassBasedAttendanceChanged(true));
                    }
                  });
                }
              ),

            ],
          ),
        ),
      ),
    );
  }
}