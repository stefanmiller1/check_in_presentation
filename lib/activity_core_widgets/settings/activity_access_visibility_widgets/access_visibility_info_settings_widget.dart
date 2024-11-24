part of check_in_presentation;

class AccessVisibilitySettingWidget extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservation;
  final ActivityManagerForm? activityForm;

  const AccessVisibilitySettingWidget({Key? key, required this.model, this.activityForm, required this.reservation}) : super(key: key);

  @override
  State<AccessVisibilitySettingWidget> createState() => _AccessVisibilitySettingWidgetState();
}

class _AccessVisibilitySettingWidgetState extends State<AccessVisibilitySettingWidget> {

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
            children: [

              mainContainerForVisibilitySettings(
                  context: context,
                  model: widget.model,
                  reservation: widget.reservation,
                  activityForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
                  isPrivateOnly: () {
                    setState(() {
                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.accessVisibilitySetting.isPrivateOnly == true) {
                        context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isPrivateOnlyChanged(false));
                      } else {
                        context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isPrivateOnlyChanged(true));
                      }
                    });
                  },
                  createPrivateList: () {
                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
                      barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
                      transitionDuration: Duration(milliseconds: 650),
                      pageBuilder: (BuildContext contexts, anim1, anim2) {
                        return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: widget.model.accentColor,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                                ),
                                width: 600,
                                height: 950,

                              ),
                            )
                        );
                      },
                      transitionBuilder: (context, anim1, anim2, child) {
                        return SlideTransition(
                          position: Tween(begin: Offset(0, 1), end: Offset(0, 0.15)).animate(anim1),
                          child: child,
                        );
                      },
                    );
                  },
                  isInviteOnly: () {
                    setState(() {
                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.accessVisibilitySetting.isInviteOnly == true) {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isInviteOnlyChanged(false));
                      } else {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isInviteOnlyChanged(true));
                      }
                    });
                  },
                  isReviewRequired: () {
                    setState(() {
                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.accessVisibilitySetting.isReviewRequired == true) {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isReviewRequiredChanged(false));
                      } else {
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isReviewRequiredChanged(true));
                      }
                    });
                  }
              ),

            ]
          ),
        ),
      )
    );
  }
}