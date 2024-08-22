part of check_in_presentation;

class ProfileMainContainer extends StatefulWidget {

  final DashboardModel model;
  final String currentUserId;
  final UserProfileModel? currentUserProfile;
  final ProfileTypeMarker? profileType;
  final bool? isMobileViewOnly;
  final Function()? didSelectAppearancesGetStarted;

  const ProfileMainContainer({super.key, required this.model, required this.currentUserProfile, required this.currentUserId, this.isMobileViewOnly, this.profileType, this.didSelectAppearancesGetStarted});

  @override
  State<ProfileMainContainer> createState() => _ProfileMainContainerState();
}

class _ProfileMainContainerState extends State<ProfileMainContainer> {

  late bool isGeneralProfileEditorVisible = false;
  late bool isVendorMerchProfileEditorVisible = false;
  late bool isCommunityProfileEditorVisible = false;
  late bool isReloading = false;
  late EventMerchantVendorProfile? selectedProfile = null;
  late ProfileTypeMarker? currentProfileTab = widget.profileType ?? ProfileTypeMarker.generalProfile;

  List<ProfileCreatorContainerModel> profileModel(UserProfileModel userProfile, List<EventMerchantVendorProfile> vProfiles, List<AttendeeItem> attendingList, List<ListingManagerForm> listings, List<ReservationItem> reservationsComingUp, List<ReservationItem> reservationsCompleted, List<AccountNotificationItem> notifications, bool isOwner) => [
    ProfileCreatorContainerModel(
        isEditorVisible: isGeneralProfileEditorVisible,
        profileHeaderIcon: CupertinoIcons.settings,
        profileHeaderTitle: '${userProfile.legalName.getOrCrash()}\'s Profile',
        profileHeaderSubTitle: 'Edit Profile',
        profileTabTitle: '${userProfile.legalName.getOrCrash()}\'s Profile',
        isOwner: isOwner,
        showAddIcon: true,
        didSelectNew: () {
          setState(() {
            isGeneralProfileEditorVisible = !isGeneralProfileEditorVisible;
          });
        },
        profileType: ProfileTypeMarker.generalProfile,
        profileMainEditor: ProfileEditorWidgetModel(
          height: 165,
          editorItem: GeneralProfileCreatorEditor(
            model: widget.model,
            currentUser: userProfile,
            didSaveSuccessfully: () {
              setState(() {
                isGeneralProfileEditorVisible = false;
              });
            },
            didCancel: () {
              setState(() {
                isGeneralProfileEditorVisible = !isGeneralProfileEditorVisible;
              });
            }
          )
        ),
        profilesList: GeneralProfileWidget(
          currentUser: userProfile,
          isOwner: isOwner,
          model: widget.model,
          isMobileOnly: widget.isMobileViewOnly == true,
          notifications: notifications,
          facilities: listings,
          reservations: reservationsComingUp,
          completedReservations: reservationsCompleted,
          attending: attendingList,
          didSelectEditProfile: (user) {
            if (kIsWeb) {
              didSelectEditGeneralProfile(context, widget.model, user);
            } else {
              setState(() {
                isGeneralProfileEditorVisible = !isGeneralProfileEditorVisible;
              });
            }
        },
      )
    ),
    ProfileCreatorContainerModel(
        isReloading: isReloading,
        isEditorVisible: isVendorMerchProfileEditorVisible,
        profileHeaderIcon: CupertinoIcons.add_circled,
        profileHeaderTitle: 'Vendor Profile',
        profileHeaderSubTitle: 'Create New',
        profileTabTitle: 'Vendor Profile',
        profileType: ProfileTypeMarker.vendorProfile,
        isOwner: isOwner,
        showAddIcon: vProfiles.isEmpty,
        didSelectNew: () {
          setState(() {
            isReloading = true;
            selectedProfile = null;
            isVendorMerchProfileEditorVisible = !isVendorMerchProfileEditorVisible;
            Future.delayed(const Duration(milliseconds: 750), () {
              setState(() {
                isReloading = false;
              });
            });
          });
        },
        profileMainEditor: ProfileEditorWidgetModel(
            height: 400,
            editorItem: VendorProfileCreatorEditor(
                model: widget.model,
                didSaveSuccessfully: () {
                  setState(() {
                    isVendorMerchProfileEditorVisible = false;
                  });
                },
                didCancel: () {
                  setState(() {
                    isVendorMerchProfileEditorVisible = !isVendorMerchProfileEditorVisible;
                  });
                },
            selectedVendorProfile: selectedProfile,
          )
        ),
        profilesList: VendorMerchantProfileWidget(
            currentUser: userProfile,
            vendorProfiles: vProfiles,
            isOwner: isOwner,
            isMobileOnly: widget.isMobileViewOnly == true,
            attending: attendingList,
            model: widget.model,
            didSelectAppearancesGetStarted: () {
              if (widget.didSelectAppearancesGetStarted != null) {
                widget.didSelectAppearancesGetStarted!();
              }
            },
            didSelectReveiewApplication: () {
              didSelectReviewApplications(context, widget.model, userProfile.userId);
            },
            didSelectShare: () {
              if (widget.currentUserProfile != null) didSelectShareProfile(widget.currentUserProfile!, ProfileTypeMarker.vendorProfile);
            },
            didSelectAddPartners: () {

            },
            didSelectCreateNew: () {
              setState(() {
                isVendorMerchProfileEditorVisible = !isVendorMerchProfileEditorVisible;
              });
            },
            didSelectEdit: (profile) {
              if (kIsWeb) {
                didSelectEditVendorProfile(context, widget.model, profile);
              } else {
                setState(() {
                  isReloading = true;
                  selectedProfile = profile;
                  isVendorMerchProfileEditorVisible = true;
                });

                Future.delayed(const Duration(milliseconds: 750), () {
                  setState(() {
                    isReloading = false;
                  });
                });
              }
        },
      )
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentUserProfile != null) {
      return getVendorMerchProfiles(widget.currentUserProfile!);
    }
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(widget.currentUserId)),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                loadSelectedProfileSuccess: (item) {
                    return getVendorMerchProfiles(item.profile);
                  },
                  orElse: () {
                    /// user cant be found
                    return profileNotFound(context, widget.model);
            }
          );
        }
      )
    );
  }

  Widget getVendorMerchProfiles(UserProfileModel currentUserProfile) {
    return BlocProvider(create: (_) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchCurrentUsersMerchVendorList(widget.currentUserId)),
      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadCurrentUserVendorMerchListSuccess: (list) => getFacilities(currentUserProfile, list.items),
              orElse: () => getFacilities(currentUserProfile, [])
          );
        },
      ),
    );
  }

  Widget getFacilities(UserProfileModel currentUserProfile, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchSelectedUsersPublicListingsStarted([ManagerListingStatusType.finishSetup], widget.currentUserId, null)),
      child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
            loadAllSelectedUsersPublicListingsSuccess: (e) {
            return getReservations(currentUserProfile, e.items, vProfiles);
          },
          orElse: () => getReservations(currentUserProfile, [], vProfiles));
        }
      ),
    );
  }

  Widget getReservations(UserProfileModel currentUserProfile, List<ListingManagerForm> listings, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current, ReservationSlotState.confirmed], currentUserProfile, false, 3, true)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadCurrentUserReservationsSuccess: (e) => getReservationsCompleted(currentUserProfile, listings, e.item, vProfiles),
                orElse: () => getReservationsCompleted(currentUserProfile, listings, [], vProfiles)
          );
        }
      ),
    );
  }

  Widget getReservationsCompleted(UserProfileModel currentUserProfile, List<ListingManagerForm> listings, List<ReservationItem> reservations, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.completed], currentUserProfile, false, 6, true)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadCurrentUserReservationsSuccess: (e) => getAttendingReservations(currentUserProfile, listings, reservations, e.item, vProfiles),
                orElse: () => getAttendingReservations(currentUserProfile, listings, reservations, [], vProfiles)
            );
          }
      ),
    );
  }

  Widget getAttendingReservations(UserProfileModel currentUserProfile, List<ListingManagerForm> listings, List<ReservationItem> reservations, List<ReservationItem> reservationsCompleted, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchProfileAllAttendingResStarted(ContactStatus.joined, AttendeeType.vendor, null, widget.currentUserId)),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadProfileAttendingResSuccess: (e) {
              return getNotificationsForAllReservations(currentUserProfile, listings, reservations, reservationsCompleted, e.attending, vProfiles);
            },
            orElse: () => getNotificationsForAllReservations(currentUserProfile, listings, reservations, reservationsCompleted, [], vProfiles)
          );
        }
      )
    );
  }

  Widget getNotificationsForAllReservations(UserProfileModel currentUserProfile, List<ListingManagerForm> listings, List<ReservationItem> reservations, List<ReservationItem> reservationsCompleted, List<AttendeeItem> attendingList, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<NotificationWatcherBloc>()..add(NotificationWatcherEvent.watchAllAccountNotificationAmountByType([AccountNotificationType.invite, AccountNotificationType.request, AccountNotificationType.joined, AccountNotificationType.activityPost, AccountNotificationType.resSlot], null)),
        child: BlocBuilder<NotificationWatcherBloc, NotificationWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadAllAccountNotificationByTypeSuccess: (item) {
                    return getMainContainer(currentUserProfile, listings, reservations, reservationsCompleted, attendingList, vProfiles, item.notifications);
                  },
            orElse: () => getMainContainer(currentUserProfile, listings, reservations, reservationsCompleted, attendingList, vProfiles, [])
          );
        }
      )
    );
  }

  Widget getMainContainer(UserProfileModel currentUserProfile, List<ListingManagerForm> listings, List<ReservationItem> reservations, List<ReservationItem> reservationsCompleted, List<AttendeeItem> attendingList, List<EventMerchantVendorProfile> vProfiles, List<AccountNotificationItem> notifications) {
    final bool isOwner = widget.currentUserId == facade.FirebaseChatCore.instance.firebaseUser?.uid;

    // print(reservations.length);
    return ProfileMainDashboardMain(
        model: widget.model,
        isMobileOnly: widget.isMobileViewOnly == true,
        profileContainerItem: profileModel(
            currentUserProfile,
            vProfiles,
            attendingList,
            listings,
            reservations,
            reservationsCompleted,
            notifications,
            isOwner
      ),
    );
  }
}