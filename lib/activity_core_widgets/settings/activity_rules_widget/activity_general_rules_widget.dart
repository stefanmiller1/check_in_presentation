part of check_in_presentation;

class ActivityGeneralRulesWidget extends StatefulWidget {

  final DashboardModel model;

  const ActivityGeneralRulesWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<ActivityGeneralRulesWidget> createState() => _ActivityGeneralRulesWidgetState();
}

class _ActivityGeneralRulesWidgetState extends State<ActivityGeneralRulesWidget> {

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
              mainContainerGenRules(
                  context: context,
                  model: widget.model,
                  state: context.read<UpdateActivityFormBloc>().state,
                  ruleOptionChanged: (ruleOptions) {
                    setState(() {
                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.ruleOptionChanged(ListK(ruleOptions)));
                    });
                  },
                  customRuleOptionStringChanged: (value, i) {

                      context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption?.getOrCrash()[i] = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption!.getOrCrash()[i].copyWith(customDetail: value);
                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.customRuleOptionChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption ?? ListK([])));

                  },
                  customRuleOptionRemoveChanged: (i) {
                    setState(() {
                      context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption?.getOrCrash().removeAt(i);
                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.customRuleOptionChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption ?? ListK([])));
                    });
                  },
                  customRuleOptionAdd: (customDetailOptionList) {
                    setState(() {
                      if ((context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption?.getOrCrash().length ?? 1) < 5) {
                        customDetailOptionList.getOrCrash().add(DetailCustomOption(uid: UniqueId(), customDetail: ''));
                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRuleOptionChanged(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customRuleOption ?? ListK([])));
                      }

                    });
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}