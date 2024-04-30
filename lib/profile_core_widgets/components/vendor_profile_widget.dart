part of check_in_presentation;

class VendorMerchantProfileWidget extends StatelessWidget {

  final UserProfileModel currentUser;
  final DashboardModel model;
  final bool isOwner;
  final List<EventMerchantVendorProfile> vendorProfiles;
  final List<AttendeeItem> attending;
  final Function() didSelectCreateNew;
  final Function() didSelectShare;
  final Function() didSelectAddPartners;
  final Function(EventMerchantVendorProfile profile) didSelectEdit;

  const VendorMerchantProfileWidget({super.key, required this.currentUser, required this.model, required this.didSelectShare, required this.didSelectAddPartners, required this.didSelectEdit, required this.didSelectCreateNew, required this.vendorProfiles, required this.attending, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return getMainContainer(context, vendorProfiles, attending);
  }

  /// create new vendor profile setup
  Widget getEmptyVendorMerchProfile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: model.mobileBackgroundColor.withOpacity(0.35),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: model.accentColor,
                            ),
                          ),
                          const SizedBox(width: 20),
                        Expanded(
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: model.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: model.accentColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 30,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: model.accentColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        /// create new profile
        Visibility(
          visible: isOwner,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: model.mobileBackgroundColor.withOpacity(0.35),
                ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text('If your\'re a vendor or merchant - you can create a custom profile for showcasing your shop. Your community will get to see upcoming reservations, where they can find you and what you\'ve been apart of.', style: TextStyle(color: model.disabledTextColor)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => didSelectCreateNew(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: model.paletteColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text('Create New Profile', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize)),
                        )
                      ),
                    )
                  ]
                ),
              )
            ),
          ),
        ),
        const SizedBox(height: 18),
        Divider(color: model.disabledTextColor),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: model.mobileBackgroundColor.withOpacity(0.35),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Appearances', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: widgetForEmptyReturns(
                      context,
                      model,
                      Icons.date_range_rounded,
                      'No Reservations Joined Yet!',
                      'Let your community know exactly where to find you by joining the reservations you plan to be at - all Reservations you join as a Vendor will show up here.',
                      'Join as Vendor'
                  ),
                ),
              ],
            )
          ),
        ),
      ],
    );
  }


  Widget getMainContainer(BuildContext context, List<EventMerchantVendorProfile> profiles, List<AttendeeItem> attending) {

    if (profiles.isEmpty) {
      return getEmptyVendorMerchProfile(context);
    }

    final EventMerchantVendorProfile profile = profiles[0];
    final isOwner = profile.profileOwner == currentUser.userId;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: model.accentColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: getVendorMerchProfileHeader(
                    model,
                    isOwner,
                    profile,
                    attending.length,
                    didSelectShare: () {
                      didSelectShare();
                    },
                    didSelectAddPartners: () {
                      didSelectAddPartners();
                    },
                    didSelectEdit: () {
                      didSelectEdit(profile);
                    },
                ),
            )
          ),
        ),
        const SizedBox(height: 18),
        Divider(color: model.disabledTextColor),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: model.mobileBackgroundColor.withOpacity(0.35),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (attending.isEmpty) Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: model.mobileBackgroundColor.withOpacity(0.35),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text('Upcoming Appearances', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
                            const SizedBox(height: 18),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: widgetForEmptyReturns(
                                  context,
                                  model,
                                  Icons.date_range_rounded,
                                  'No Reservations Joined Yet!',
                                  'Let your community know exactly where to find you by joining the reservations you plan to be at - all Reservations you join as a Vendor will show up here.',
                                  'Join as Vendor'
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  if (attending.isNotEmpty) Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Appearances', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,),
                      const SizedBox(height: 18),
                      Wrap(
                        children: attending.map(
                            (e) {
                              return FutureBuilder<ReservationItem?>(
                              future: facade.ReservationFacade.instance.getReservationItem(resId: e.reservationId.getOrCrash()),
                              builder: (context, snap) {
                                    if (snap.connectionState == ConnectionState.waiting) {
                                        // return JumpingDots(color: model.paletteColor, numberOfDots: 3);
                                    } else if (snap.data == null) {
                                      return Container();
                                    }

                                    if (snap.data == null) {
                                      return Container();
                                    }

                                    final reservation = snap.data!;

                                    return FutureBuilder<ActivityManagerForm?>(
                                      future: facade.ActivitySettingsFacade.instance.getActivitySettings(reservationId: e.reservationId.getOrCrash()),
                                      builder: (context, activitySnap) {
                                        if (activitySnap.connectionState == ConnectionState.waiting) {
                                          // return JumpingDots(color: model.paletteColor, numberOfDots: 3);
                                        } else if (activitySnap.data == null) {
                                          return Container();
                                        }

                                        final activity = activitySnap.data;

                                        return baseSearchItemContainer(
                                            model: model,
                                            backgroundWidget: getReservationMediaFrameFlexible(context, model, 400, 400, null, activity, reservation, false, didSelectItem: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (_) {
                                                    return ActivityPreviewScreen(
                                                      model: model,
                                                      listing: null,
                                                      reservation: reservation,
                                                      currentReservationId: reservation.reservationId,
                                                      currentListingId: reservation.instanceId,
                                                      didSelectBack: () {}
                                                    );
                                                  }
                                                )
                                              );
                                            }),
                                            bottomWidget: getSearchFooterWidget(
                                                context,
                                                model,
                                                currentUser.userId,
                                                model.paletteColor,
                                                model.disabledTextColor,
                                                model.accentColor,
                                                null,
                                                activity,
                                                reservation,
                                                false,
                                                didSelectItem: () {},
                                                didSelectInterested: () {
                                                  // didSelectInterested();
                                                }
                                            )
                                        );

                                  }
                                );
                              }
                            );
                          }
                        ).toList()
                      ),
                    ],
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }
}

