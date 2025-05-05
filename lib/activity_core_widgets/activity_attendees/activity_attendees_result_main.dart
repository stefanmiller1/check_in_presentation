// import 'package:check_in_domain/check_in_domain.dart';
// import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:check_in_web_mobile_explore/presentation/screens/activity_attendees/activity_attendees_list_helper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:jumping_dot/jumping_dot.dart';

part of check_in_presentation;

class ActivityAttendeesResultMain extends StatefulWidget {

  final DashboardModel model;
  final AttendeeItem? attendee;
  final UserProfileModel? selectedProfile;

  const ActivityAttendeesResultMain({super.key, required this.model, this.attendee, this.selectedProfile});

  @override
  State<ActivityAttendeesResultMain> createState() => _ActivityAttendeesResultMainState();
}

class _ActivityAttendeesResultMainState extends State<ActivityAttendeesResultMain> {

  ScrollController? _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController = ScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ActivityAttendeeHelperCore.isLoading == true) {
      return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: (!(kIsWeb)) ? AppBar(
          elevation: 0,
          backgroundColor: widget.model.paletteColor,
          title: Text('Attendee', style: TextStyle(color: widget.model.accentColor)),
          centerTitle: true,
        ) : null,
        body: (widget.selectedProfile != null && widget.attendee != null) ? getMainContainer(context, widget.selectedProfile!) : defaultPagePreview()
      ),
    );
  }

  Widget getMainContainer(BuildContext context, UserProfileModel selectedProfile) {

    bool isLessThanMain = (MediaQuery.of(context).size.width <= 1150);
    return IntrinsicHeight(
            child: Container(
              width: MediaQuery.of(context).size.width - 600,
              height: MediaQuery.of(context).size.height - 300,
              child: ProfileMainContainer(
                model: widget.model,
                currentUserId: selectedProfile.userId.getOrCrash(),
                currentUserProfile: selectedProfile,
                isMobileViewOnly: true
              )
            ),
          );
   
    return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
            
                          // mainContainerForSectionOneAtt(
                          //   context: context,
                          //   model: widget.model,
                          //   attendeeItem: widget.attendee!,
                          //   isColumn: false,
                          //   didSelectRemoveAttendee: () {
                          //
                          //   },
                          //   didSelectLeaveActivity: () {
                          //
                          //   }
                          // ),
                          const SizedBox(width: 25),
                          IntrinsicHeight(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 600,
                              height: MediaQuery.of(context).size.height - 300,
                              child: ProfileMainContainer(
                                model: widget.model,
                                currentUserId: selectedProfile.userId.getOrCrash(),
                                currentUserProfile: selectedProfile,
                                isMobileViewOnly: true
                              )
                            ),
                          )
                      ],
                    )
                  ],
                );
  }

  Widget mainHeaderContainer(BuildContext context, Widget attendeeType) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.model.webBackgroundColor,
        ),
        child: Row(
          children: [
            attendeeType,
            const SizedBox(width: 15),
            Container(

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Remove'),
              ),
            ),
            const SizedBox(width: 15),
          ]
        )
      ),
    );
  }

  Widget defaultPagePreview() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.person_2_outlined, color: widget.model.disabledTextColor, size: 85),
          const SizedBox(height: 10),
          Text('Attendees', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 10),
          Text('Select any attendee from the list and preview their Profile!', style: TextStyle(color: widget.model.disabledTextColor)),
        ],
      ),
    );
  }
}