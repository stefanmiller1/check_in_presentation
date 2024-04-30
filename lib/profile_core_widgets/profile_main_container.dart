part of check_in_presentation;

class ProfileMainContainer extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUserProfile;

  const ProfileMainContainer({super.key, required this.model, required this.currentUserProfile});

  @override
  State<ProfileMainContainer> createState() => _ProfileMainContainerState();
}

class _ProfileMainContainerState extends State<ProfileMainContainer> {

  late bool isGeneralProfileEditorVisible = false;
  late bool isVendorMerchProfileEditorVisible = false;
  late bool isCommunityProfileEditorVisible = false;
  late bool isReloading = false;
  late EventMerchantVendorProfile? selectedProfile = null;

  List<ProfileCreatorContainerModel> profileModel(UserProfileModel userProfile, List<ReservationItem> reservations, List<EventMerchantVendorProfile> vProfiles, List<AttendeeItem> attendingList, List<ListingManagerForm> listings, bool isOwner) => [
    ProfileCreatorContainerModel(
        isEditorVisible: isGeneralProfileEditorVisible,
        profileHeaderIcon: CupertinoIcons.settings,
        profileHeaderTitle: '${userProfile.legalName.getOrCrash()}\'s Profile',
        profileHeaderSubTitle: 'Edit Profile',
        profileTabTitle: 'Profile',
        isOwner: isOwner,
        showAddIcon: true,
        didSelectNew: () {
          setState(() {
            isGeneralProfileEditorVisible = !isGeneralProfileEditorVisible;
          });
        },
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
          facilities: listings,
          reservations: reservations,
          attending: attendingList,
      )
    ),
    ProfileCreatorContainerModel(
        isReloading: isReloading,
        isEditorVisible: isVendorMerchProfileEditorVisible,
        profileHeaderIcon: CupertinoIcons.add_circled,
        profileHeaderTitle: 'Vendor Profile',
        profileHeaderSubTitle: 'Create New',
        profileTabTitle: 'Vendor Profile',
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
            height: 760,
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
            attending: attendingList,
            model: widget.model,
            didSelectShare: () {

            },
            didSelectAddPartners: () {

            },
            didSelectCreateNew: () {
              setState(() {
                isVendorMerchProfileEditorVisible = !isVendorMerchProfileEditorVisible;
              });
            },
            didSelectEdit: (profile) {
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
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadUserProfileSuccess: (item) {
                    return getVendorMerchProfiles(item.profile);
                  },
                  orElse: () {
                    return getVendorMerchProfiles(null);
            }
          );
        }
      )
    );
  }

  Widget getVendorMerchProfiles(UserProfileModel? currentLoggedIn) {
    return BlocProvider(create: (_) => getIt<VendorMerchProfileWatcherBloc>()..add(VendorMerchProfileWatcherEvent.watchCurrentUsersMerchVendorList(widget.currentUserProfile.userId.getOrCrash())),
      child: BlocBuilder<VendorMerchProfileWatcherBloc, VendorMerchProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadCurrentUserVendorMerchListSuccess: (list) => getFacilities(currentLoggedIn, list.items),
              orElse: () => getFacilities(currentLoggedIn, [])
          );
        },
      ),
    );
  }

  Widget getFacilities(UserProfileModel? currentLoggedIn, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsStarted([''])),
      child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
      builder: (context, state) {
        return state.maybeMap(
          loadAllPublicListingItemsSuccess: (e) => getCreatedReservations(currentLoggedIn, e.items.where((element) => element.listingProfileService.backgroundInfoServices.listingOwner == widget.currentUserProfile.userId).toList(), vProfiles),
          orElse: () => getCreatedReservations(currentLoggedIn, [], vProfiles));
        }
      ),
    );
  }

  Widget getCreatedReservations(UserProfileModel? currentLoggedIn, List<ListingManagerForm> listings, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current, ReservationSlotState.confirmed, ReservationSlotState.completed], widget.currentUserProfile, false)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                loadCurrentUserReservationsSuccess: (e) => getAttendingReservations(currentLoggedIn, listings, e.item, vProfiles),
                orElse: () => getAttendingReservations(currentLoggedIn, listings, [], vProfiles)
          );
        }
      ),
    );
  }

  Widget getAttendingReservations(UserProfileModel? currentLoggedIn, List<ListingManagerForm> listings, List<ReservationItem> reservations, List<EventMerchantVendorProfile> vProfiles) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchProfileAllAttendingResStarted(ContactStatus.joined, AttendeeType.vendor, null)),
        child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            loadProfileAttendingResSuccess: (e) {
              return getMainContainer(currentLoggedIn, listings, reservations, e.attending, vProfiles);
            },
            orElse: () => getMainContainer(currentLoggedIn, listings, reservations, [], vProfiles)
          );
        }
      )
    );
  }

  Widget getMainContainer(UserProfileModel? currentLoggedIn, List<ListingManagerForm> listings, List<ReservationItem> reservations, List<AttendeeItem> attendingList, List<EventMerchantVendorProfile> vProfiles) {
    final bool isOwner = currentLoggedIn?.userId == widget.currentUserProfile.userId;

    return ProfileMainDashboardMain(
        model: widget.model,
        profileContainerItem: profileModel(
            widget.currentUserProfile,
            reservations,
            vProfiles,
            attendingList,
            listings,
            isOwner
      ),
    );
  }
}