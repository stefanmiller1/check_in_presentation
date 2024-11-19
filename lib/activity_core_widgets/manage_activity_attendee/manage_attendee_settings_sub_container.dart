part of check_in_presentation;


class ManageAttendeeSettingsSubContainer extends StatefulWidget {

  final DashboardModel model;
  final String? currentUser;
  final ReservationItem reservationItem;
  late  SettingsItemModel? currentSettingItem;
  // final ActivityManagerForm? currentActivityManagerForm;
  // final UserProfileModel currentActivityOwnerProfile;
  // final AttendeeItem? currentAttendee;
  final Function(SettingsItemModel navItem) didSelectNavItem;

  ManageAttendeeSettingsSubContainer({super.key, required this.model, this.currentSettingItem, required this.reservationItem, required this.didSelectNavItem, required this.currentUser});

  @override
  State<ManageAttendeeSettingsSubContainer> createState() => _ManageAttendeeSettingsSubContainerState();
}

class _ManageAttendeeSettingsSubContainerState extends State<ManageAttendeeSettingsSubContainer> {

  @override
  void initState() {
    if (kIsWeb) {
      // widget.currentSettingItem = subActivityAttendeeSettingItems(widget.currentActivityManagerForm, widget.currentAttendee)[0];
    }
    super.initState();
  }


  Widget getAttendeeItem(ActivityManagerForm? activityForm) {
    return BlocProvider(create: (context) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(widget.reservationItem.reservationId.getOrCrash(), widget.currentUser ?? '')),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadAttendeeItemSuccess: (attendee) {
                    return getCurrentActivityOwnerProfle(activityForm, attendee.item);
                  },
                  orElse: () {
                    return getCurrentActivityOwnerProfle(activityForm, null);
            }
          );
        }
      )
    );
  }

  Widget getCurrentActivityOwnerProfle(ActivityManagerForm? activityForm, AttendeeItem? attendee) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.reservationItem.reservationOwnerId.getOrCrash())),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadSelectedProfileSuccess: (item) {
                    return getMainContainer(activityForm, attendee, item.profile);
                  },
                  orElse: () {
                    /// user cant be found
                    return getMainContainer(activityForm, attendee, null);
                  }
              );
            }
        )
    );
  }


  Widget getMainContainer(ActivityManagerForm? activityForm, AttendeeItem? attendee, UserProfileModel? ownerUserProfile) {
    return Scaffold(
      appBar: (!(kIsWeb)) ? AppBar(
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        automaticallyImplyLeading: false,
        title: Text('Manage Attendance', style: TextStyle(color: widget.model.accentColor)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel, color: widget.model.accentColor),
          tooltip: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ) : null,
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              children: [
                if (kIsWeb) const SizedBox(height: 30),
                ...attendeeSettingsHeader(context).map(
                        (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(e.settingTitle, style: TextStyle(color: (widget.currentSettingItem?.sectionNavItem == e.sectionMarker) ? widget.model.paletteColor : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          const SizedBox(height: 5),
                          Column(
                            children: subActivityAttendeeSettingItems(activityForm, attendee).where((element) => element.sectionNavItem == e.sectionMarker).map(
                                    (f) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        if (kIsWeb) {
                                          widget.didSelectNavItem(f);
                                        } else {
                                          switch (f.navItem) {
                                            case SettingNavMarker.reservation:
                                              break;
                                            case SettingNavMarker.vendorForm:
                                              if (attendee != null && ownerUserProfile != null && activityForm != null) {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                                  return ActivityApplicationSettingsWidget(
                                                      model: widget.model,
                                                      attendeeItem: attendee,
                                                      reservationItem: widget.reservationItem,
                                                      activityManagerForm: activityForm,
                                                      activityOwnerProfile: ownerUserProfile
                                                  );
                                                }
                                                )
                                                );
                                              }
                                              break;
                                            case SettingNavMarker.backgroundInfo:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.requirementsInfo:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.locationInfo:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.spaces:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.reservations:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.reports:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.spaceOption:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.activity:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.hoursAndAvailability:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.accessAndVisibility:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.cancellations:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.customFields:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.spaceRules:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.activityRules:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.payments:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.checkIns:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.guides:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.uploads:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.reservationConditions:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.pricingRules:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.quotas:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.attendanceType:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.ticketBased:
                                              // TODO: Handle this case.
                                            case SettingNavMarker.passesBased:
                                              // TODO: Handle this case.
                                          }
                                        }
                                      });
                                    },
                                    leading: f.settingImageIcon != null ? CircleAvatar(backgroundImage: Image.network(f.settingImageIcon!).image, backgroundColor: widget.model.paletteColor) : Icon(f.settingIcon, color: (widget.currentSettingItem?.navItem == f.navItem && f.navItem != SettingNavMarker.reservation || widget.currentSettingItem?.settingSpaceOption == f.settingSpaceOption && f.navItem == SettingNavMarker.reservation) ? widget.model.paletteColor : null),
                                    title: Text(f.settingsTitle, style: TextStyle(color: (widget.currentSettingItem?.navItem == f.navItem && f.navItem != SettingNavMarker.reservation || widget.currentSettingItem?.settingSpaceOption == f.settingSpaceOption && f.navItem == SettingNavMarker.reservation && f.settingsTitle == widget.currentSettingItem?.settingsTitle) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                                    trailing: (!(f.isCompletedSetup ?? false)) ? null : Container(height: 7, width: 7, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: widget.model.paletteColor, border: Border.all(color: widget.model.paletteColor, width: 0.5))),
                                    subtitle: (f.settingSubTitle != '') ? Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(f.settingSubTitle, style: TextStyle(color:(widget.currentSettingItem?.navItem == f.navItem && f.navItem != SettingNavMarker.reservation || widget.currentSettingItem?.settingSpaceOption == f.settingSpaceOption && f.navItem == SettingNavMarker.reservation && f.settingsTitle == widget.currentSettingItem?.settingsTitle) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                                    ) : null,
                                  );
                                }
                            ).toList(),
                          ),
                        ],
                      ),
                    )
                ).toList(),
                Divider(color: widget.model.disabledTextColor, thickness: 0.25),
                const SizedBox(height: 15),
                if (attendee != null) Text('Created at: ${DateFormat.MMMd().add_jm().format(attendee!.dateCreated)}', style: TextStyle(color: widget.model.disabledTextColor))
              ]
          )
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(widget.reservationItem.reservationId.getOrCrash())),
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadActivityManagerFormSuccess: (item) {
                return getAttendeeItem(item.item);
              },
              orElse: () => getAttendeeItem(null)
          );
        },
      ),
    );
  }
}